`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/28 10:57:16
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
    
    reg rst, run, clk;
    
    always #10 clk = ~clk;
    
    initial begin
        rst = 0;
        run = 1;
        clk = 0;
    end
    
    cpu _cpu (
        .rst(rst),
        .run(run),
        .clk(clk),
        .intr(0)
    );
endmodule
