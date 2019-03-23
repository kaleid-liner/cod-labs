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
    output reg [BITS-1:0] y,
    output [`FLAG_BITS-1:0] flag
    );

    parameter BITS = 4; // as parameter, can vary with instances

    reg [BITS:0] temp_y;

    wire zf = !y;
    wire sf = y[BITS-1];
    reg of;
    reg cf;
    reg carry;

    assign flag = (zf << `ZF_BIT) | (of << `OF_BIT) | (cf << `CF_BIT) | (sf << `SF_BIT);

    always @(*) begin 
        case (op) 
            `ADD: begin
                {carry, y} = a + b;
                of = (a[BITS-1] & b[BITS-1] & ~y[BITS-1])
                   | (~a[BITS-1] & ~b[BITS-1] & y[BITS-1]);
                cf = carry;
            end
            `SUB: begin
                {carry, y} = a - b;
                of = (a[BITS-1] & ~b[BITS-1] & ~y[BITS-1])
                   | (~a[BITS-1] & b[BITS-1] | y[BITS-1]);
                cf = carry;
            end
            `AND: begin
                {carry, y} = a & b;
                of = 0;
                cf = 0;
            end
            `OR: begin
                {carry, y} = a | b;
                of = 0;
                cf = 0;
            end
            `XOR: begin
                {carry, y} = a ^ b;
                of = 0;
                cf = 0;
            end
            `NOT: begin
                {carry, y} = ~a;
                of = 0;
                cf = 0;
            end
            default: begin
                {carry, y} = 0;
                of = 0;
                cf = 0;
            end
        endcase
    end

endmodule
