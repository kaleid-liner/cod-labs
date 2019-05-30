`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/28 22:42:17
// Design Name: 
// Module Name: top
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


module top(
    input clk_100mhz,
    input [4:0] key,
    input [11:0] rgb,
    input cont,
    output hs,
    output vs,
    output [11:0] vrgb,
    output [7:0] pc
    );
    
    wire clk_50mhz;
    wire [`BITS-1:0] dout;
    wire [`BITS-1:0] din;
    wire [`BITS-1:0] addr;
    wire we;
    
    clk_wiz_0 _clk_wiz_0 (
        .clk_in1(clk_100mhz),
        .clk_out1(clk_50mhz)
    );
    
    cpu _cpu (
        .clk(clk_50mhz),
        .rst(0),
        .run(cont),
        .intr(0),
        .mem_dout(dout),
        .mem_we(we),
        .mem_din(din),
        .mem_addr(addr),
        .pc_out(pc)
    );
    
    bus _bus (
        .din(din),
        .addr(addr),
        .we(we),
        .rgb(rgb),
        .clk(clk_50mhz),
        .key(key),
        .dout(dout),
        .hs(hs),
        .vs(vs),
        .vrgb(vrgb)
    );
    
endmodule
