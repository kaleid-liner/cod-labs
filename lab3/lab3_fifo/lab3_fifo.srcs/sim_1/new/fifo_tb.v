`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/11 22:17:28
// Design Name: 
// Module Name: fifo_tb
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


module fifo_tb(

    );
    
    reg en_in, en_out;
    wire full, empty;
    reg [3:0] in;
    reg rst;
    reg clk;
    wire [7:0] an;
    wire [6:0] seg;
    wire dp;
    wire [3:0] out;
    
    fifo ff (
        .en_in(en_in),
        .en_out(en_out),
        .full(full),
        .empty(empty),
        .in(in),
        .clk(clk),
        .rst(rst),
        .an(an),
        .seg(seg),
        .dp(dp),
        .out(out)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        en_out = 0;
        #6 rst = 0;
        in = 5;
        en_in = 1;
        #90 en_out = 1;
        #90 en_in = 0;
        #20 en_out = 0;
    
    end
endmodule
