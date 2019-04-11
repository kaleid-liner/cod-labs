`timescale 1ns / 1ps

module seg_displayer(
    input [3:0] x,
    input [2:0] index,
    input [2:0] head,
    input empty,
    output [7:0] an,
    output [6:0] seg,
    output dp
    );
    
    display_number D (
        .x(x), 
        .seg(seg), 
        .empty(empty)
    );
    
    genvar i;
    generate for (i = 0; i < 8; i = i + 1) begin
        assign an[i] = !(i == index);
    end
    endgenerate
    assign dp = !(index == head);
    
endmodule
