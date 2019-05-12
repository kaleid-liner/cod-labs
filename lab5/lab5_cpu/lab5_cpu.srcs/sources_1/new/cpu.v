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
    input [`ADDR_BITS-1:0] ddu_addr,
    output [`BITS-1:0] ddu_dout
    );
    
    // signal
    reg sig_reg_dst;
    reg sig_reg_w;
    reg sig_alu_srca;
    reg [1:0] sig_alu_srcb;
    reg [1:0] sig_pc_src;
    reg sig_pc_wcond;
    reg sig_pc_wncond;
    reg sig_pc_w;
    reg sig_IorD;
    reg sig_mem_r; // perhaps i won't use this
    reg sig_mem_w;
    reg sig_mem_reg;
    reg sig_ir_w;
    reg [`ALU_OP_BITS-1:0] sig_alu_op;
    
    wire clk_50mhz;
    reg [`BITS-1:0] pc;
    wire [`BITS-1:0] npc;
    wire pc_we;
    wire [`BITS-1:0] jmp_addr;
    reg [`BITS-1:0] ir;
    reg [`BITS-1:0] mdr;
    wire [5:0] opcode;
    
    assign npc = (sig_pc_src == 0) ? alu_res :
                 (sig_pc_src == 1) ? alu_out :
                                     jmp_addr;
                                     
    assign opcode = ir[31:26];
                                   
    assign jmp_addr = {pc[31:28], ir[25:0], 2'b00};
    
    assign pc_we = sig_pc_w | (zero & sig_pc_wcond) | (~zero & sig_pc_wncond);
    
    always @(posedge clk_50mhz) begin
        if (pc_we)
            pc <= npc;
    end
    
    always @(posedge clk_50mhz) begin
        if (sig_ir_w)
            ir <= mem_dout;
    end
    
    always @(posedge clk_50mhz) begin
        alu_out <= alu_res;
        mdr <= mem_dout;
        rda <= rd1;
        rdb <= rd2;
    end
    
    /*
    clk_wiz_0 main_clock (
        .clk_in1(clk),
        .clk_out1(clk_50mhz)
    );
    */
    assign clk_50mhz = clk;

    wire [`ADDR_BITS-1:0] mem_addr;
    wire [`BITS-1:0] mem_din;
    wire [`BITS-1:0] mem_dout;
    wire [`BITS-1:0] tmp_mem_addr;
        
    dist_mem_gen_0 memory (
        .a(mem_addr),
        .d(mem_din),
        .spo(mem_dout),
        .clk(clk_50mhz),
        .we(sig_mem_w),
        .dpra(ddu_addr),
        .dpo(ddu_dout)
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
        .clk(clk_50mhz),
        .rAddr0(ra1),
        .rAddr1(ra2),
        .wAddr(wa),
        .wDin(wd),
        .wEn(reg_we),
        .rDout0(rd1),
        .rDout1(rd2)
    );
    
    assign reg_we = sig_reg_w;
    assign wa = sig_reg_dst ? ir[15:11] : ir[20:16];
    assign wd = sig_mem_reg ? mdr : alu_out;
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
               SLMem = 7,
               SSMem = 8,
               SRMem = 9,
               SIMem = 10,
               SWb  = 11,
               SStart = 12;
               
    reg [3:0] state;
    wire [3:0] next_state;
    
    // just not want to use case
    assign next_state = 
        (state == SIf)   ? SId :
        (state == SId)   ? (opcode == `R)   ? SREx :
                           (opcode == `BEQ) ? SBEx :
                           (opcode == `BNE) ? SBNEx:
                           (opcode == `LW)  ? SLSEx:
                           (opcode == `SW)  ? SLSEx:
                           (opcode == `J)   ? SJEx :
                                              SIEx :
        (state == SLSEx) ? (opcode == `LW)  ? SLMem:
                                              SSMem:
        (state == SREx)  ? SRMem:
        (state == SIEx)  ? SIMem:
        (state == SJEx)  ? SIf  :
        (state == SBEx)  ? SIf  :
        (state == SBNEx) ? SIf  :
        (state == SLMem) ? SWb  :
                           SIf  ;
    
    always @ (posedge clk_50mhz) begin
        state <= next_state;
    end 
    
    initial begin
        state = SStart;
        pc = 0;
    end
    
    always @ (next_state) begin
        case (next_state)
        SIf: begin 
            sig_reg_dst = 0;
            sig_reg_w = 0;
            sig_alu_srca = 0;
            sig_alu_srcb = 1;
            sig_pc_src = 0;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 1;
            sig_IorD = 0;
            sig_mem_r = 1;
            sig_mem_w = 0;
            sig_mem_reg = 0;
            sig_ir_w = 1;
            sig_alu_op = `ALU_ADD;
        end
        SId: begin
            sig_reg_dst = 0;
            sig_reg_w = 0; 
            sig_alu_srca = 0;
            sig_alu_srcb = 3;
            sig_pc_src = 0;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 0;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_mem_reg = 0;
            sig_ir_w = 0;
            sig_alu_op = `ALU_ADD;
        end
        SLSEx: begin
            sig_reg_dst = 0;
            sig_reg_w = 0;
            sig_alu_srca = 1;
            sig_alu_srcb = 2;
            sig_pc_src = 0;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 0;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_mem_reg = 0;
            sig_ir_w = 0;
            sig_alu_op = alu_op;
        end
        SREx: begin
            sig_reg_dst = 0;
            sig_reg_w = 0;
            sig_alu_srca = 1;
            sig_alu_srcb = 0;
            sig_pc_src = 0;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 0;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_mem_reg = 0;
            sig_ir_w = 0;    
            sig_alu_op = alu_op;         
        end
        SBEx: begin
            sig_reg_dst = 0;
            sig_reg_w = 0;
            sig_alu_srca = 1;
            sig_alu_srcb = 0;
            sig_pc_src = 1;
            sig_pc_wcond = 1;
            sig_pc_wncond = 0;
            sig_pc_w = 0;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_mem_reg = 0;
            sig_ir_w = 0;     
            sig_alu_op = alu_op;       
        end
        SBNEx: begin
            sig_reg_dst = 0;
            sig_reg_w = 0;
            sig_alu_srca = 1;
            sig_alu_srcb = 0;
            sig_pc_src = 1;
            sig_pc_wcond = 0;
            sig_pc_wncond = 1;
            sig_pc_w = 0;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_mem_reg = 0;
            sig_ir_w = 0;     
            sig_alu_op = alu_op;       
        end
        SJEx: begin
            sig_reg_dst = 0;
            sig_reg_w = 0;
            sig_alu_srca = 1;
            sig_alu_srcb = 2;
            sig_pc_src = 2;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 1;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_mem_reg = 0;
            sig_ir_w = 0;
            sig_alu_op = alu_op;
        end
        SIEx: begin
            sig_reg_dst = 0;
            sig_reg_w = 0;
            sig_alu_srca = 1;
            sig_alu_srcb = 2;
            sig_pc_src = 0;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 0;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_mem_reg = 0;
            sig_ir_w = 0;
            sig_alu_op = alu_op;        
        end
        SLMem: begin
            sig_reg_dst = 0;
            sig_reg_w = 0;
            sig_alu_srca = 1;
            sig_alu_srcb = 2;
            sig_pc_src = 0;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 0;
            sig_IorD = 1;
            sig_mem_r = 1;
            sig_mem_w = 0;
            sig_mem_reg = 0;
            sig_ir_w = 0;  
            sig_alu_op = alu_op;      
        end
        SSMem: begin 
            sig_reg_dst = 0;
            sig_reg_w = 0;
            sig_alu_srca = 1;
            sig_alu_srcb = 2;
            sig_pc_src = 0;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 0;
            sig_IorD = 1;
            sig_mem_r = 0;
            sig_mem_w = 1;
            sig_mem_reg = 0;
            sig_ir_w = 0;   
            sig_alu_op = alu_op;
        end
        SRMem: begin
            sig_reg_dst = 1;
            sig_reg_w = 1;
            sig_alu_srca = 1;
            sig_alu_srcb = 2;
            sig_pc_src = 0;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 0;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_mem_reg = 0;
            sig_ir_w = 0;    
            sig_alu_op = alu_op;        
        end
        SIMem: begin
            sig_reg_dst = 0;
            sig_reg_w = 1;
            sig_alu_srca = 1;
            sig_alu_srcb = 2;
            sig_pc_src = 0;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 0;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_mem_reg = 0;
            sig_ir_w = 0;    
            sig_alu_op = alu_op;        
        end
        SWb: begin
            sig_reg_dst = 0;
            sig_reg_w = 1;
            sig_alu_srca = 1;
            sig_alu_srcb = 2;
            sig_pc_src = 0;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 0;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_mem_reg = 1;
            sig_ir_w = 0;
            sig_alu_op = alu_op;
        end
        SStart: begin
            sig_reg_dst = 0;
            sig_reg_w = 0;
            sig_alu_srca = 0;
            sig_alu_srcb = 0;
            sig_pc_src = 0;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 0;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_mem_reg = 0;
            sig_ir_w = 0;
            sig_alu_op = alu_op;
        end
        endcase
    end 
endmodule