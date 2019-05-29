`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/28 20:05:48
// Design Name: 
// Module Name: bus
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

module bus(
    input [`BITS-1:0] din,
    input [`BITS-1:0] addr,
    input we,
    input [11:0] rgb,
    input clk,
    input [4:0] key,
    output [`BITS-1:0] dout,
    output hs,
    output vs,
    output [11:0] vrgb
    );
    
    // memory: 0x000 ~ 0xFFF
    // 4096 byts, 1024 double words
    wire select_mem;
    wire mem_we;
    wire [`BITS-1:0] mem_dout;
    // vga: 0x10000 ~ 0x1FFFF
    // x: 0x20000
    // y: 0x20001
    // each element 12 bits
    wire select_vga;
    wire vram_we;
    wire xy_we;
    wire [`BITS-1:0] vga_dout;
    // button: 0x1000 ~ 0x1001
    // 0x1000: readonly
    // 0x1001: one bit flag
    wire select_key;
    wire key_we;
    wire [`BITS-1:0] key_dout;
    // rgb: 0x2000
    wire select_rgb;
    wire [`BITS-1:0] rgb_dout;
    
    assign dout = ({`BITS{select_mem}} & mem_dout) 
                | ({`BITS{select_key}} & key_dout)
                | ({`BITS{select_vga}} & vga_dout)
                | ({`BITS{select_rgb}} & rgb_dout);
    
    assign select_mem = addr < 'h1000;
    assign mem_we = we & select_mem;
    
    assign select_vga = addr >= 'h10000 && addr < 'h20002;
    assign vram_we = we & select_vga & addr[16];
    assign xy_we = we & select_vga & addr[17];
    
    assign select_key = addr == 'h1000 || addr == 'h1001;
    assign key_we = we & (addr == 'h1001);
    
    assign select_rgb = addr == 'h2000;
    assign rgb_dout = rgb;
    
    dist_mem_gen_0 memory (
        .a(addr[`ADDR_BITS+1:2]),
        .d(din),
        .spo(mem_dout),
        .clk(clk),
        .we(mem_we)
    );
    
    keydriver kd (
        .addr(addr[0]),
        .din(din[0]),
        .we(key_we),
        .clk(clk),
        .dout(key_dout),
        .up(key[0]),
        .down(key[1]),
        .left(key[2]),
        .right(key[3]),
        .enter(key[4])
    );
    
    vgadriver vgad (
        .addr(addr[15:0]),
        .din(din[11:0]),
        .vram_we(vram_we),
        .xy_we(xy_we),
        .clk(clk),
        .hs(hs),
        .vs(vs),
        .vrgb(vrgb),
        .dout(vga_dout)
    );
     
endmodule
