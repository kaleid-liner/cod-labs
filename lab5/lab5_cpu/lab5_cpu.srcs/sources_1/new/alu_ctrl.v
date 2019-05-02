`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/02 15:15:28
// Design Name: 
// Module Name: alu_ctrl
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

module alu_ctrl(
    input [`OP_BITS-1:0] op,
    input [`FUNCT_BITS-1:0] funct,
    output reg [`ALU_OP_BITS-1:0] alu_op
    );
    
    always @(*) begin
        case (op)
            `R: begin 
                case (funct) 
                    `ADD_FUNCT: alu_op = `ALU_ADD;
                    `AND_FUNCT: alu_op = `ALU_AND;
                    `OR_FUNCT: alu_op = `ALU_OR;
                    `XOR_FUNCT: alu_op = `ALU_XOR;
                    `NOR_FUNCT: alu_op = `ALU_NOR;
                    `SUB_FUNCT: alu_op = `ALU_SUB;
                    `SLT_FUNCT: alu_op = `ALU_SLT;
                endcase
            end
            `ADDI: alu_op = `ALU_ADD;
            `ANDI: alu_op = `ALU_AND;
            `ORI: alu_op = `ALU_OR;
            `XORI: alu_op = `ALU_XOR;
            `SLTI: alu_op = `ALU_SLT;
            `LW: alu_op = `ALU_ADD;
            `SW: alu_op = `ALU_ADD;
            `BEQ: alu_op = `ALU_SUB;
            `BNE: alu_op = `ALU_SUB;
        endcase
    end
endmodule
