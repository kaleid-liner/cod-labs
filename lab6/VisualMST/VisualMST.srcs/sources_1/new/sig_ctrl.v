`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/12 15:21:56
// Design Name: 
// Module Name: sig_ctrl
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

module sig_ctrl(
    input [4:0] next_state,
    input [`ALU_OP_BITS-1:0] alu_op,
    output reg [1:0] sig_reg_dst,
    output reg sig_reg_w,
    output reg sig_alu_srca,
    output reg [1:0] sig_alu_srcb,
    output reg [2:0] sig_pc_src,
    output reg sig_pc_wcond,
    output reg sig_pc_wncond,
    output reg sig_pc_w,
    output reg sig_IorD,
    output reg sig_mem_r,
    output reg sig_mem_w,
    output reg [1:0] sig_reg_src,
    output reg sig_ir_w,
    output reg [`ALU_OP_BITS-1:0] sig_alu_op,
    output reg sig_eint_w,
    output reg sig_except_w
    );

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
            sig_reg_src = 0;
            sig_ir_w = 1;
            sig_alu_op = `ALU_ADD;
            sig_eint_w = 0;
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
            sig_reg_src = 0;
            sig_ir_w = 0;
            sig_alu_op = `ALU_ADD;
            sig_eint_w = 0;
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
            sig_reg_src = 0;
            sig_ir_w = 0;
            sig_alu_op = alu_op;
            sig_eint_w = 0;
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
            sig_reg_src = 0;
            sig_ir_w = 0;    
            sig_alu_op = alu_op;         
            sig_eint_w = 0;
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
            sig_reg_src = 0;
            sig_ir_w = 0;     
            sig_alu_op = alu_op;       
            sig_eint_w = 0;
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
            sig_reg_src = 0;
            sig_ir_w = 0;     
            sig_alu_op = alu_op;       
            sig_eint_w = 0;
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
            sig_reg_src = 0;
            sig_ir_w = 0;
            sig_alu_op = alu_op;
            sig_eint_w = 0;
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
            sig_reg_src = 0;
            sig_ir_w = 0;
            sig_alu_op = alu_op;        
            sig_eint_w = 0;
        end
        SEEx: begin
            sig_reg_dst = 0;
            sig_reg_w = 0;
            sig_alu_srca = 0;
            sig_alu_srcb = 0;
            sig_pc_src = 4;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 1;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_reg_src = 0;
            sig_ir_w = 0;
            sig_alu_op = alu_op;
            sig_eint_w = 1;
        end
        SSysEx: begin
            sig_reg_dst = 2;
            sig_reg_w = 1;
            sig_alu_srca = 0;
            sig_alu_srcb = 0;
            sig_pc_src = 0;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 0;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_reg_src = 2;
            sig_ir_w = 0;
            sig_alu_op = alu_op;
            sig_eint_w = 0;
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
            sig_reg_src = 0;
            sig_ir_w = 0;  
            sig_alu_op = alu_op;      
            sig_eint_w = 0;
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
            sig_reg_src = 0;
            sig_ir_w = 0;   
            sig_alu_op = alu_op;
            sig_eint_w = 0;
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
            sig_reg_src = 0;
            sig_ir_w = 0;    
            sig_alu_op = alu_op;        
            sig_eint_w = 0;
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
            sig_reg_src = 0;
            sig_ir_w = 0;    
            sig_alu_op = alu_op;        
            sig_eint_w = 0;
        end
        SSysMem: begin
            sig_reg_dst = 3;
            sig_reg_w = 1;
            sig_alu_srca = 0;
            sig_alu_srcb = 0;
            sig_pc_src = 0;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 0;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_reg_src = 3;
            sig_ir_w = 0;    
            sig_alu_op = alu_op;        
            sig_eint_w = 0;
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
            sig_reg_src = 1;
            sig_ir_w = 0;
            sig_alu_op = alu_op;
            sig_eint_w = 0;
        end
        SIdle: begin
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
            sig_reg_src = 0;
            sig_ir_w = 0;
            sig_alu_op = alu_op;
            sig_eint_w = 0;
        end
        SInt: begin
            sig_reg_dst = 0;
            sig_reg_w = 0;
            sig_alu_srca = 0;
            sig_alu_srcb = 0;
            sig_pc_src = 3;
            sig_pc_wcond = 0;
            sig_pc_wncond = 0;
            sig_pc_w = 1;
            sig_IorD = 0;
            sig_mem_r = 0;
            sig_mem_w = 0;
            sig_reg_src = 0;
            sig_ir_w = 0;
            sig_alu_op = alu_op;
            sig_eint_w = 1;
        end
        endcase
    end 
    
endmodule
