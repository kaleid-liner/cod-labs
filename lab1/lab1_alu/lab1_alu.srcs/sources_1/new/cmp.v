`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/20 23:01:31
// Design Name: 
// Module Name: cmp
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
`include "Define.vh"

module cmp(
    input [BITS-1:0] a,
    input [BITS-1:0] b,
    output ug,
    output ul,
    output sg,
    output sl,
    output eq
    );

    parameter BITS = 32;

    wire [BITS-1:0] y;
    wire [`FLAG_BITS-1:0] flag;

    alu #(BITS) du (
        .a(a),
        .b(b),
        .op(`SUB),
        .y(y),
        .flag(flag)
    );

    wire zf = flag[`ZF_BIT];
    wire cf = flag[`CF_BIT];
    wire of = flag[`OF_BIT];
    wire sf = flag[`SF_BIT];

    assign eq = zf;
    assign ul = cf;
    assign ug = ~cf & ~zf;
    assign sl = sf ^ of;
    assign sg = (sf ^~ of) & ~zf;
    
endmodule
