`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/27 20:13:07
// Design Name: 
// Module Name: int_ctrl
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

module int_ctrl(
    input eint,
    // intr[0]: "keyboard" interrupt
    // intr[7:1]: reserved
    input [`INTR_BITS-1:0] intr,
    output if_int,
    output [`INT_VEC_BITS-1:0] int_vec
    );

    assign if_int = eint & intr[0];
    
    assign int_vec = 0;

endmodule
