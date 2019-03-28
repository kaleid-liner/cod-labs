`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/28 20:28:15
// Design Name: 
// Module Name: div_tb
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


module div_tb(

    );
    
    reg [3:0] x, y;
    reg clk, rst;
    wire [3:0] q, r;
    wire done, error;
    
    div dut (
        .x(x),
        .y(y),
        .clk(clk),
        .rst(rst),
        .q(q),
        .r(r),
        .done(done),
        .error(error)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        x = 4'b0111;
        y = 4'b0010;
        #7 rst = 0;
        #193 rst = 1;
        x = 4'b1110;
        y = 4'b1111;
        #7 rst = 0;
    end
        
endmodule
