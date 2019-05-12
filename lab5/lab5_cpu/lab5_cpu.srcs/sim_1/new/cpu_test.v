`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/05 16:05:05
// Design Name: 
// Module Name: cpu_test
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


module cpu_test(
    );
    
    reg clk;
    reg rst;
    initial begin clk = 0; rst = 0; end
    always #10 clk = ~clk;
    
    wire [7:0] addr = 8'h2;
    wire [31:0] dout;
    cpu _cpu (clk, rst, addr, dout);
    
endmodule
