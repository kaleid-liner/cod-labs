`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/28 12:50:07
// Design Name: 
// Module Name: sort_tb
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


module sort_tb(

    );
    
    reg [3:0] x0, x1, x2, x3;
    reg rst, clk;
    wire [3:0] s0, s1, s2, s3;
    wire done;
    
    sort tsort (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .s0(s0),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .rst(rst),
        .clk(clk),
        .done(done)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        x0 = 0;
        x1 = 1;
        x2 = 2;
        x3 = 3;
        rst = 1;
        #7 rst = 0;
    end
    
endmodule
