`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/02 12:05:16
// Design Name: 
// Module Name: top
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

module top(
    input clk
    );
    
    // signal
    reg sig_reg_dst;
    reg sig_reg_w;
    reg sig_alu_srca;
    reg [1:0] sig_alu_srcb;
    reg [1:0] sig_pc_src;
    reg sig_pc_wcond;
    reg sig_pc_w;
    reg sig_IorD;
    reg sig_mem_r; // perhaps i won't use this
    reg sig_mem_w;
    reg sig_mem_reg;
    reg sig_ir_w;
    
    wire clk_50mhz;
    reg [`BITS-1:0] pc;
    wire [`BITS-1:0] npc;
    wire pc_we;
    wire [`BITS-1:0] jmp_addr;
    reg [`BITS-1:0] ir;
    reg mdr;
    
    assign npc = (sig_pc_src == 0) ? alu_res :
                 (sig_pc_src == 1) ? alu_out :
                                     jmp_addr;
                                   
    assign jmp_addr = {pc[31:28], ir[25:0] << 2};
    
    assign pc_we = sig_pc_w | (zero & sig_pc_wcond);
    
    always @(posedge clk_50mhz) begin
        if (pc_we)
            pc <= npc;
    end
    
    always @(posedge clk_50mhz) begin
        if (sig_ir_w)
            ir <= mem_dout;
    end
    
    clk_wiz_0 main_clock (
        .clk_in1(clk),
        .clk_out1(clk_50mhz)
    );

    wire mem_addr;
    wire [`BITS-1:0] mem_din;
    wire [`BITS-1:0] mem_dout;
    wire rst;
        
    dist_mem_gen_0 memory (
        .a(mem_addr),
        .d(mem_din),
        .spo(mem_dout),
        .clk(clk_50mhz),
        .we(sig_mem_w)
    );
    
    assign mem_din = sig_IorD ? alu_out : pc;

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
    
    wire [`BITS-1:0] alu_srca,
                     alu_srcb,
                     alu_res;
    wire zero;
    wire [`ALU_OP_BITS-1:0] alu_op;
    reg [`ALU_OP_BITS-1:0] alu_out;
    
    wire [`BITS-1:0] imm_ext;
    wire [`BITS-1:0] imm_shf;
    
    alu _alu (
        .srca(alu_srca),
        .srcb(alu_srcb),
        .op(alu_op),
        .res(alu_res),
        .zero(zero)
    );
    
    alu_ctrl _alu_ctrl (
        .op(ir[31:26]),
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
               SEx  = 2,
               SMem = 3,
               SWb  = 4;
    
    wire clk_25mhz;
    clock_25mhz cpu_tick (
        .clk_50mhz(clk_50mhz),
        .clk_25mhz(clk_25mhz)
    );
    
    always @ (posedge clk_25mhz) begin
        
    
    end          
    
endmodule
