`timescale 1ns / 1ps

module display_number(
    input [3:0] x,
    input empty,
    output wire [6:0] seg
    );        
    assign seg[0] = empty | ((x[0] & ~x[1] & ~x[2] & ~x[3]) | (~x[0] & ~x[1] & x[2] & ~x[3]));
    assign seg[1] = empty | ((x[0] & ~x[1] & x[2] & ~x[3]) | (~x[0] & x[1] & x[2] & ~x[3]));
    assign seg[2] = empty | ((~x[0] & x[1] & ~x[2] & ~x[3]));
    assign seg[3] = empty | ((x[0] & ~x[1] & ~x[2] & ~x[3]) | (~x[0] & ~x[1] & x[2] & ~x[3]) | (x[0] & x[1] & x[2] & ~x[3]));
    assign seg[4] = empty | (~((~x[0] & ~x[1] & ~x[2] & ~x[3]) | (~x[0] & x[1] & ~x[2] & ~x[3]) | (~x[0] & x[1] & x[2] & ~x[3]) | (~x[0] & ~x[1] & ~x[2] & x[3])));
    assign seg[5] = empty | ((x[0] & ~x[1] & ~x[2] & ~x[3]) | (~x[0] & x[1] & ~x[2] & ~x[3]) | (x[0] & x[1] & ~x[2] & ~x[3]) | (x[0] & x[1] & x[2] & ~x[3]));
    assign seg[6] = empty | ((~x[0] & ~x[1] & ~x[2] & ~x[3]) | (x[0] & ~x[1] & ~x[2] & ~x[3]) | (x[0] & x[1] & x[2] & ~x[3]));

endmodule
