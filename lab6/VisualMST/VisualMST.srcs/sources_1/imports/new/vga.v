`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/16 12:00:56
// Design Name: 
// Module Name: vga
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


module vga(
    input clk_50mhz,
    input [11:0] vdata,
    input [7:0] x,
    input [7:0] y,
    output [11:0] vrgb,
    output [15:0] vaddr,
    output hs,
    output vs
    );
    
    localparam BORDER_TOP = 172,
               BORDER_BOTTOM = 427,
               BORDER_LEFT = 272,
               BORDER_RIGHT = 527;
               
    localparam WIDTH = 800,
               HEIGHT = 600;
               
    localparam HSPW = 120,
               HBP = 64,
               HFP = 56,
               VSPW = 6,
               VBP = 23,
               VFP = 37;
               
    localparam HTICK = 1040,
               VTICK = 666;
               
    reg [10:0] hc;
    reg [9:0] vc;
            
    always @(posedge clk_50mhz) begin
        if (hc == HTICK - 1) begin
            hc <= 0;
            if (vc == VTICK - 1) begin
                vc <= 0;
            end else begin
                vc <= vc + 1;
            end
        end else begin
            hc <= hc + 1;
        end
    end
    
    localparam HSBEG = WIDTH + HFP,
               HSEND = WIDTH + HFP + HSPW,
               VSBEG = HEIGHT + VFP,
               VSEND = HEIGHT + VFP + VSPW;
    
    assign hs = ~((hc >= HSBEG) && (hc < HSEND));
    assign vs = ~((vc >= VSBEG) && (vc < VSEND));
                      
    wire [15:0] hcbeg = hc - BORDER_LEFT;
    wire [15:0] vcbeg = vc - BORDER_TOP;
    assign vaddr = hcbeg + vcbeg * 256;
    
    assign vrgb = ((hcbeg == x) && (vcbeg == y))
               || ((hcbeg == x - 1) && (vcbeg == y))
               || ((hcbeg == x + 1) && (vcbeg == y))
               || ((hcbeg == x) && (vcbeg == y - 1))
               || ((hcbeg == x) && (vcbeg == y + 1))
               || (hc < BORDER_LEFT) || (hc > BORDER_RIGHT)
               || (vc < BORDER_TOP) || (vc > BORDER_BOTTOM)
               ? 0 : vdata;
    
endmodule
