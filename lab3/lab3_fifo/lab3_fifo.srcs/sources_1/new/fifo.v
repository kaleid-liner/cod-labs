`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/11 19:59:07
// Design Name: 
// Module Name: fifo
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


module fifo(
    input en_in,
    input en_out,
    input [3:0] in,
    input rst,
    input clk,
    input main_clk,
    output [7:0] an,
    output [6:0] seg,
    output dp,
    output [3:0] out,
    output empty,
    output reg full
    );
    
    reg [2:0] rear, head;
    reg [2:0] scan;
    wire [3:0] seg_num;
    wire clk_5mhz;
    wire seg_clk;
    wire will_full;
    wire [2:0] rear_next;
    
    clk_wiz_0 main_clock (
        .clk_out1(clk_5mhz), 
        .clk_in1(main_clk)
    );
    
    clock_500hz seg_clock (
        .clk(clk_5mhz),
        .Q(seg_clk)
    );
    
    always @(posedge seg_clk) begin
        if ((scan == (rear - 1)) || (scan == rear))
            scan <= head;
        else scan <= scan + 1;
    end
    
    seg_displayer seg_dis (
        .x(seg_num),
        .index(scan),
        .head(head),
        .empty(empty),
        .an(an),
        .dp(dp),
        .seg(seg)
    );
    
    regfile #(4, 8, 3) rf (
        .rst(rst),
        .clk(clk),
        .wEn(en_in),
        .rAddr0(head),
        .rDout0(out),
        .rAddr1(scan),
        .rDout1(seg_num),
        .wDin(in),
        .wAddr(rear)
    );
    
    initial begin
        full = 0;
        head = 0;
        rear = 0;
        scan = 0;
    end
    
    always @(posedge clk) begin
        if (rst) begin
            full <= 0;
            head <= 0;
            rear <= 0;
        end else begin
            if (en_in && !full) begin
                rear <= rear + 1;
            end
            if (en_out && !empty) begin
                head <= head + 1;
            end
            if (en_in && !en_out) begin
                full <= will_full;
            end else if (!en_in && en_out) begin
                full <= 0;
            end 
        end
    end
    
    assign empty = (rear == head) & !full;
    assign rear_next = rear + 1;
    assign will_full = rear_next == full;
    
    
endmodule
