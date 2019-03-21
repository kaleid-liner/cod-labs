`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/22 12:57:08
// Design Name: 
// Module Name: fib_tb
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


module fib_tb(

    );
    
    reg [3:0] f0, f1;
    reg clk, rst;
    wire [3:0] fn;
    
    always #5 clk <= ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        f0 = 1;
        f1 = 1;
        #7 rst = 0;
    end
    
    fib fib_test (
        .f0(f0),
        .f1(f1),
        .clk(clk),
        .rst(rst),
        .fn(fn)
    );
    
endmodule
