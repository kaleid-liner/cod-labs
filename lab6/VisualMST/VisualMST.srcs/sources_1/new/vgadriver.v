`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/28 21:46:46
// Design Name: 
// Module Name: vgadriver
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


module vgadriver(
    input [13:0] addr,
    input [11:0] din,
    input vram_we,
    input xy_we,
    input clk,
    output hs,
    output vs,
    output [11:0] vrgb,
    output [`BITS-1:0] dout
    );
    
    wire [13:0] vaddr;
    wire [11:0] vdata;
    
    reg [6:0] x;
    reg [6:0] y;
    
    dist_mem_gen_1 vram (
        .dpra(vaddr),
        .dpo(vdata),
        .clk(clk),
        .we(vram_we),
        .a(addr),
        .d(din)
    );
    
    vga dcu (
        .clk_50mhz(clk),
        .vdata(vdata),
        .hs(hs),
        .vs(vs),
        .x(x),
        .y(y),
        .vrgb(vrgb),
        .vaddr(vaddr)
    );
    
    assign dout = addr[0] ? y : x;
    
    always @ (posedge clk) begin
        if (xy_we) begin
            if (addr[0])
                y <= din;
            else x <= din;
        end
    end
    
endmodule
