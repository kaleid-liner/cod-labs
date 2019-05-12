`timescale 1ns / 1ps

module seg_displayer(
    input [3:0] x,
    input clk_50mhz,
    output [7:0] an,
    output [6:0] seg,
    output dp
    );
    
    display_number D (
        .x(x), 
        .seg(seg)
    );
    
    wire clk_500hz;
    clock_500hz _clock_500hz (
        .clk_50mhz(clk_50mhz),
        .clk_500hz(clk_500hz)
    );
    
    reg [2:0] index;
    always @ (posedge clk_500hz) begin
        index <= index + 1;
    end
    
    genvar i;
    generate for (i = 0; i < 8; i = i + 1) begin
        assign an[i] = !(i == index);
    end
    endgenerate
    
    assign dp = 1;
    
endmodule
