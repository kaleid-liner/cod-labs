`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/17 13:34:34
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
`include "Define.vh"

module alu(
    input [BITS-1:0] a,
    input [BITS-1:0] b,
    input [`ALU_OP_BITS-1:0] op,
    output [BITS-1:0] y,
    output [`FLAG_BITS-1:0] flag
    );

    parameter BITS = 4; // as parameter, can vary with instances

    reg [BITS:0] temp_y;

    wire zf = !y;
    wire sf = temp_y[BITS-1];
    reg of;
    reg cf;

    assign y = temp_y;

    assign flag = (zf << `ZF_BIT) | (of << `OF_BIT) | (cf << `CF_BIT) | (sf << `SF_BIT);

    always @(*) begin 
        case (op) 
            `ADD: begin
                temp_y = a + b;
                of = (a[BITS-1] & b[BITS-1] & ~y[BITS-1])
                   | (~a[BITS-1] & ~b[BITS-1] & y[BITS-1]);
                cf = temp_y[BITS];
            end
            `SUB: begin
                temp_y = a - b;
                of = (a[BITS-1] & ~b[BITS-1] & ~y[BITS-1])
                   | (~a[BITS-1] & b[BITS-1] | y[BITS-1]);
                cf = temp_y[BITS];
            end
            `AND: begin
                temp_y = a & b;
                of = 0;
                cf = 0;
            end
            `OR: begin
                temp_y = a | b;
                of = 0;
                cf = 0;
            end
            `XOR: begin
                temp_y = a ^ b;
                of = 0;
                cf = 0;
            end
            `NOT: begin
                temp_y = ~a;
                of = 0;
                cf = 0;
            end
            default: begin
                temp_y = 0;
                of = 0;
                cf = 0;
            end
        endcase
    end

endmodule
