`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/16 13:05:52
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
    
    reg cont,      
        step,      
        mem,       
        inc,       
        dec,       
        clk,       
        rst;     
    wire [15:0] led;
    wire [7:0] an;
    wire [6:0] seg;
    wire dp;
    
    top _top (
        cont,      
        step,      
        mem,       
        inc,       
        dec,       
        clk,       
        rst,       
        led,
        an, 
        seg,
        dp
    );       
    
    initial begin clk = 0; rst = 0; inc = 0; dec = 0; cont = 1; step = 0; mem = 0; end
    
    always #5 clk = ~clk;
    
    always begin
    #100 cont = 0;
    #5 step = 1;
    #10 step = 0;
    end
endmodule
