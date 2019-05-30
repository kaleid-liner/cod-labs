`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/28 23:13:21
// Design Name: 
// Module Name: top_test
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


module top_test(
    );
    
    reg clk;
    reg [4:0] key;
    reg cont;
    reg [11:0] rgb;
    
    initial begin
        clk = 0;
        cont = 1;
        key = 0;
        rgb = 0;
        #100
        key = 5'b10000;
    end
    
    always #10 clk = ~clk;
    
    
    top _top (
        .clk_100mhz(clk),
        .key(key),
        .cont(cont),
        .rgb(rgb)
    );
    
endmodule
