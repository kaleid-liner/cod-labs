`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/12 17:29:07
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
`include "define.vh"

module top(
    input cont,
    input step,
    input mem,
    input inc,
    input dec,
    input clk,
    input rst,
    output [15:0] led,
    output [7:0] an,
    output [6:0] seg,
    output dp
    );
    
    wire clk_50mhz;
    
    clk_wiz_0 clock_50mhz (
        .clk_in1(clk),
        .clk_out1(clk_50mhz)
    );
    
    wire run;
    wire [`ADDR_BITS-1:0] addr;
    wire [`BITS-1:0] mem_data;
    wire [`BITS-1:0] reg_data;
    wire [`ADDR_BITS-1:0] pc;
    
    cpu _cpu (
        .clk(clk),
        .run(run),
        .ddu_addr(addr),
        .ddu_mem(mem_data),
        .ddu_reg(reg_data),
        .pc_out(pc),
        .rst(rst)
    );
    
    ddu _ddu (
        .cont(cont),
        .step(step),
        .mem(mem),
        .inc(inc),
        .dec(dec),
        .mem_data(mem_data),
        .reg_data(reg_data),
        .pc(pc),
        .clk_50mhz(clk_50mhz),
        .run(run),
        .addr(addr),
        .led(led),
        .seg(seg),
        .an(an),
        .dp(dp)
    );
    
    
endmodule
