`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/02 12:05:16
// Design Name: 
// Module Name: cpu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "define.vh"

module cpu(
    input clk,
    input rst,
    input run,
    // external interrupt
    input [`INTR_BITS-1:0] intr,
    input [`ADDR_BITS-1:0] ddu_addr,
    output [`BITS-1:0] ddu_mem,
    output [`BITS-1:0] ddu_reg,
    output [`ADDR_BITS-1:0] pc_out
    );
    
    // signal
    wire [1:0] sig_reg_dst;
    wire sig_reg_w;
    wire sig_alu_srca;
    wire [1:0] sig_alu_srcb;
    wire [2:0] sig_pc_src;
    wire sig_pc_wcond;
    wire sig_pc_wncond;
    wire sig_pc_w;
    wire sig_IorD;
    wire sig_mem_r; // perhaps i won't use this
    wire sig_mem_w;
    wire [1:0] sig_reg_src;
    wire sig_ir_w;
    wire [`ALU_OP_BITS-1:0] sig_alu_op;
    wire sig_eint_w;
    wire sig_except_w;
    
    reg [`BITS-1:0] pc;
    wire [`BITS-1:0] npc;
    wire pc_we;
    wire [`BITS-1:0] jmp_addr;
    reg [`BITS-1:0] ir;
    reg [`BITS-1:0] mdr;
    wire [5:0] opcode;
    wire [`BITS-1:0] epc;
    wire [`BITS-1:0] cause;
    wire [`BITS-1:0] syscall_vec;
    
    assign npc = (sig_pc_src == 0) ? alu_res :
                 (sig_pc_src == 1) ? alu_out :
                 (sig_pc_src == 2) ? jmp_addr:
                 (sig_pc_src == 3) ? int_addr:
                                     epc     ;
                                     
    assign opcode = ir[31:26];
                                   
    assign jmp_addr = {pc[31:28], ir[25:0], 2'b00};
    
    assign pc_we = sig_pc_w | (zero & sig_pc_wcond) | (~zero & sig_pc_wncond);
    
    always @(posedge clk) begin
        if (rst) begin
            pc <= 0;
        end else if (pc_we) begin
            pc <= npc;
        end
    end
    
    always @(posedge clk) begin
        if (sig_ir_w)
            ir <= mem_dout;
    end
    
    always @(posedge clk) begin
        alu_out <= alu_res;
        mdr <= mem_dout;
        rda <= rd1;
        rdb <= rd2;
    end

    wire [`ADDR_BITS-1:0] mem_addr;
    wire [`BITS-1:0] mem_din;
    wire [`BITS-1:0] mem_dout;
    wire [`BITS-1:0] tmp_mem_addr;
        
    dist_mem_gen_0 memory (
        .a(mem_addr),
        .d(mem_din),
        .spo(mem_dout),
        .clk(clk),
        .we(sig_mem_w),
        .dpra(ddu_addr),
        .dpo(ddu_mem)
    );
    
    assign mem_din = rdb;
    assign tmp_mem_addr = sig_IorD ? alu_out : pc;
    assign mem_addr = tmp_mem_addr[`ADDR_BITS+1:2];

    wire [`REG_ADDR-1:0] ra1;
    wire [`REG_ADDR-1:0] ra2;
    wire [`REG_ADDR-1:0] wa;
    wire reg_we;
    wire [`BITS-1:0] wd;
    wire [`BITS-1:0] rd1;
    wire [`BITS-1:0] rd2;
    reg [`BITS-1:0] rda;
    reg [`BITS-1:0] rdb;
    
    regfile #(`BITS, `REG_SIZE, `REG_ADDR) regs (
        .rst(rst),
        .clk(clk),
        .rAddr0(ra1),
        .rAddr1(ra2),
        .wAddr(wa),
        .wDin(wd),
        .wEn(reg_we),
        .rDout0(rd1),
        .rDout1(rd2),
        .epc(epc),
        .cause(cause),
        .v0(syscall_vec)
    );
    
    assign reg_we = sig_reg_w;
    assign wa = sig_reg_dst ? ir[15:11] : ir[20:16];
    assign wa = (sig_reg_dst == 0) ? ir[20:16] :
                (sig_reg_dst == 1) ? ir[15:11] :
                (sig_reg_dst == 2) ? 14        :
                                     13        ;
    assign wd = (sig_reg_src == 0) ? alu_out:
                (sig_reg_src == 1) ? mdr    :
                (sig_reg_src == 2) ? pc     :
                                     8      ;
    assign ra1 = ir[25:21];
    assign ra2 = ir[20:16];
    
    wire [`BITS-1:0] alu_srca,
                     alu_srcb,
                     alu_res;
    wire zero;
    wire [`ALU_OP_BITS-1:0] alu_op;
    reg [`BITS-1:0] alu_out;
    
    wire [`BITS-1:0] imm_ext;
    wire [`BITS-1:0] imm_shf;
    
    alu _alu (
        .srca(alu_srca),
        .srcb(alu_srcb),
        .op(sig_alu_op),
        .res(alu_res),
        .zero(zero)
    );
    
    alu_ctrl _alu_ctrl (
        .op(opcode),
        .funct(ir[5:0]),
        .alu_op(alu_op)
    );
    
    assign imm_ext = { {16{ir[15]}}, ir[15:0] };
    assign imm_shf = imm_ext << 2;
    assign alu_srca = sig_alu_srca ? rda : pc;
    assign alu_srcb = (sig_alu_srcb == 0) ? rdb    :
                      (sig_alu_srcb == 1) ? 4      :
                      (sig_alu_srcb == 2) ? imm_ext:
                                            imm_shf;
    
    // control
    localparam SIf  = 0,
               SId  = 1,
               SLSEx = 2,
               SREx  = 3,
               SIEx = 4,
               SJEx = 5,
               SBEx = 6,
               SBNEx = 13,
               SEEx = 15,
               SSysEx = 16,
               SLMem = 7,
               SSMem = 8,
               SRMem = 9,
               SIMem = 10,
               SSysMem = 17,
               SWb  = 11,
               SIdle = 12,
               SInt = 14;
               
    reg [4:0] state;
    wire [4:0] next_state;
    
    // just not want to use case
    assign next_state = 
        (state == SIf)   ? SId :
        (state == SId)   ? (opcode == `R)   ? (ir[5:0] == `SYS_FUNCT) ? SSysEx :
                                                                      SREx   :
                           (opcode == `BEQ) ? SBEx :
                           (opcode == `BNE) ? SBNEx:
                           (opcode == `LW)  ? SLSEx:
                           (opcode == `SW)  ? SLSEx:
                           (opcode == `J)   ? SJEx :
                           (opcode == `ERET)? SEEx :
                                              SIEx :
        (state == SLSEx) ? (opcode == `LW)  ? SLMem:
                                              SSMem:
        (state == SREx)  ? SRMem:
        (state == SIEx)  ? SIMem:
        (state == SSysEx)? SSysMem:
        (state == SLMem) ? SWb  :
        (state == SSysMem)?SInt :
                           run  ? if_int ? SInt :
                                           SIf  :
                                  SIdle;
                         
    
    always @ (posedge clk) begin
        if (rst) begin
            state <= SIdle;
        end else begin
            state <= next_state;
        end
    end 
    
    initial begin
        state = SIdle;
        pc = 0;
        eint = 1;
    end
    
    sig_ctrl _sig_ctrl (
        next_state,
        alu_op,
        sig_reg_dst,                 
        sig_reg_w,                   
        sig_alu_srca,                
        sig_alu_srcb,          
        sig_pc_src,            
        sig_pc_wcond,                
        sig_pc_wncond,               
        sig_pc_w,                    
        sig_IorD,                    
        sig_mem_r,                   
        sig_mem_w,                   
        sig_reg_src,                 
        sig_ir_w,                    
        sig_alu_op,
        sig_eint_w
    );
    
    // not relevant to cpu
    assign pc_out = pc[`ADDR_BITS+1:2];
    
    // hardware interrupt
    reg eint;
    wire if_int;
    wire [`INT_VEC_BITS-1:0] int_vec;
    wire [`BITS-1:0] int_addr;

    int_ctrl _int_ctrl (
        .eint(eint),
        .intr(intr),
        .if_int(if_int),
        .int_vec(int_vec)
    );

    assign int_addr = (cause == 0) ? 'h10 | int_vec :
                      (cause == 8) ? 'h10 | syscall_vec :
                                     'h10;

    always @ (posedge clk) begin
        if (sig_eint_w) begin
            eint <= ~eint;
        end
    end


endmodule
