`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/11 10:48:28
// Design Name: 
// Module Name: regfile
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


module regfile(
    input rst,
    input clk,
    input [ADDR-1:0] rAddr0,
    input [ADDR-1:0] rAddr1,
    input [ADDR-1:0] rAddr2,
    input [ADDR-1:0] wAddr,
    input [BITS-1:0] wDin,
    input wEn,
    output [BITS-1:0] rDout0,
    output [BITS-1:0] rDout1,
    output [BITS-1:0] rDout2
    );
    
    parameter BITS = 4;
    parameter SIZE = 16;
    parameter ADDR = 4;
    
    reg [BITS-1:0] regs [SIZE-1:0];
    
    assign rDout0 = regs[rAddr0];
    assign rDout1 = regs[rAddr1];
    assign rDout2 = regs[rAddr2];
    
    integer i;
    
    initial begin
        for (i = 0; i < SIZE; i = i + 1) begin
            regs[i] = 0;
        end
    end
    
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                regs[i] <= 32'd0;
            end
        end
        else if (wEn) begin
            regs[wAddr] <= wDin;
        end
    end
        
endmodule
