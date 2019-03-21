`timescale 1ns / 1ps

`include "Define.vh"

module fib(
    input [BITS-1:0] f0,
    input [BITS-1:0] f1,
    input rst,
    input clk,
    output [BITS-1:0] fn
);

    parameter BITS = 4;

    wire [BITS-1:0] f2;

    reg [BITS-1:0] cur, prev;
    
    alu #(BITS) ADD_ALU_FIB (
        .a(cur),
        .b(prev),
        .y(fn),
        .op(`ADD)
    );
    
    always @(posedge clk) begin
        if (rst) begin
            cur <= f1;
            prev <= f0;
        end
        else begin
            cur <= fn;
            prev = cur;
        end
    end

endmodule