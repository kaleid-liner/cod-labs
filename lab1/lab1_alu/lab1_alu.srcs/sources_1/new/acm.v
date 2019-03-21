`timescale 1ns / 1ps

`include "Define.vh"

module acm(
    input [BITS-1:0] x,
    input rst,
    input clk,
    output reg [BITS-1:0] s
    );

    parameter BITS = 32;

    wire [BITS-1:0] sum;
    alu #(BITS) ADD_ALU_ACM (
        .a(x),
        .b(s),
        .y(sum),
        .op(`ADD)
    );

    initial begin
        s = 0;
    end

    always @ (posedge clk) begin
        if (rst) 
            s <= 0;
        else 
            s <= sum;
    end

endmodule