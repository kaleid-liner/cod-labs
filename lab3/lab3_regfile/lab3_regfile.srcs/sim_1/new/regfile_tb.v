`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/11 11:11:03
// Design Name: 
// Module Name: regfile_tb
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


module regfile_tb(

    );
    
    reg clk, rst;
    reg [3:0] ra0, ra1, wa;
    reg [3:0] wd;
    reg we;
    wire [3:0] rd0, rd1;
    
    regfile rf (
        .clk(clk),
        .rst(rst),
        .rAddr0(ra0),
        .rAddr1(ra1),
        .wAddr(wa),
        .rDout0(rd0),
        .rDout1(rd1),
        .wEn(we),
        .wDin(wd)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        we = 0;
        #7 rst = 0;
        ra0 = 0;
        ra1 = 1;
        #10 wa = 4;
        we = 1;
        wd = 13;
        #10 ra0 = 4;
        we = 0;
    end
    
endmodule
