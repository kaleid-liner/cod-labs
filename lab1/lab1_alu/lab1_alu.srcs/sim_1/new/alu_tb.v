`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/20 23:50:07
// Design Name: 
// Module Name: alu_tb
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


module alu_tb(
    );
    reg [3:0] a, b;
    wire [3:0] y;
    wire [`FLAG_BITS-1:0] flag;
    reg [`ALU_OP_BITS-1:0] op;
    
    initial begin
        op = `SUB;
        a = 4'b0111;
        b = 4'b1000;
        #5 
        op = `ADD;
        a = 4'b0111;
        b = 4'b0111;
        #5 
        op = `AND;
        a = 4'b0101;
        b = 4'b1010;
        #5 
        op = `OR;
        a = 4'b0101;
        b = 4'b1010;
        #5 
        op = `XOR;
        a = 4'b0101;
        b = 4'b1010;
        #5
        op = `NOT;
        a = 4'b1111;
        #5
        op = `SAR;
        a = 4'b1010;
        b = 2;
        #5
        op = `SHR;
    end
    
    alu #(4) tu (a, b, op, y, flag);
    
endmodule
