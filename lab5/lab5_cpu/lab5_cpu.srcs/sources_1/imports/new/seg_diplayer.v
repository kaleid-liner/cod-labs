`timescale 1ns / 1ps

module seg_displayer(
    input [31:0] x,
    input clk_50mhz,
    output [7:0] an,
    output [6:0] seg,
    output dp
    );
    
    reg [2:0] index;
    
    wire [3:0] number;
    assign number = 
        (index == 0) ? x[3:0]  :
        (index == 1) ? x[7:4]  :
        (index == 2) ? x[11:8] :
        (index == 3) ? x[15:12]:
        (index == 4) ? x[19:16]:
        (index == 5) ? x[23:20]:
        (index == 6) ? x[27:24]:
                       x[31:28];
    
    display_number D (
        .x(number), 
        .seg(seg)
    );
    
    wire clk_500hz;
    clock_500hz _clock_500hz (
        .clk_50mhz(clk_50mhz),
        .clk_500hz(clk_500hz)
    );
    
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
