`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/02 12:49:05
// Design Name: 
// Module Name: alu
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

module alu(
    input [`BITS-1:0] srca,
    input [`BITS-1:0] srcb,
    input [`ALU_OP_BITS-1:0] op,
    output zero,
    output reg [`BITS-1:0] res
    );
    
    always @(*) begin
        case (op) 
            `ALU_ADD: res = srca + srcb;
            `ALU_AND: res = srca & srcb;
            `ALU_SUB: res = srca - srcb;
            `ALU_OR: res = srca | srcb;
            `ALU_XOR: res = srca ^ srcb;
            `ALU_NOR: res = ~(srca | srcb);
            `ALU_SLT: res = (srca < srcb) | (srca[`BITS-1] & ~srcb[`BITS-1]);
            default: res = srca;
        endcase
    end
        
    assign zero = res == 0;
    
endmodule

