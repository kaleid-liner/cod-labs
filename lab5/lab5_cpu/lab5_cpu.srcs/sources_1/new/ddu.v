`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/12 15:39:08
// Design Name: 
// Module Name: ddu
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

module ddu(
    input cont,
    input step,
    input mem,
    input inc,
    input dec,
    input [`BITS-1:0] mem_data,
    input [`BITS-1:0] reg_data,
    input [`ADDR_BITS-1:0] pc,
    input clk_50mhz,
    output run,
    output reg [`ADDR_BITS-1:0] addr,
    output [15:0] led,
    output [7:0] an,
    output [6:0] seg,
    output dp
    );
    
    wire [`BITS-1:0] data = mem ? mem_data : reg_data;
    
    seg_displayer disp (
        .x(data),
        .clk_50mhz(clk_50mhz),
        .an(an),
        .dp(dp),
        .seg(seg)
    );
    
    wire inc_prs;
    keypressed inc_prs_event (
        .key(inc),
        .clk(clk_50mhz),
        .event_pressed(inc_prs)
    );
    
    wire dec_prs;
    keypressed dec_prs_event (
        .key(dec),
        .clk(clk_50mhz),
        .event_pressed(dec_prs)
    );
    
    wire step_prs;
    keypressed step_prs_event (
        .key(step),
        .clk(clk_50mhz),
        .event_pressed(step_prs)
    );
    
    initial begin
        addr = 0;
    end
    
    always @ (posedge clk_50mhz) begin
        addr <= addr + inc_prs - dec_prs;
    end
    
    assign run = cont | step_prs;
    
    assign led[15:8] = pc;
    assign led[7:0] = addr;
    
endmodule
