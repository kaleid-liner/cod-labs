`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/28 20:34:23
// Design Name: 
// Module Name: keydriver
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

module keydriver(
    input addr,
    input din,
    input we,
    input clk,
    input up,
    input down,
    input left,
    input right,
    input enter,
    output [`BITS-1:0] dout
    );
    
    reg [`BITS-1:0] value;
    reg avail;

    localparam nop = 0,
               upval = 1,
               downval = 2,
               leftval = 3,
               rightval = 4,
               enterval = 5;
    
    wire up_prs;    // 1
    wire down_prs;  // 2
    wire left_prs;  // 3
    wire right_prs; // 4
    wire enter_prs; // 5
    
    keypressed up_prs_event (
        .key(up),
        .clk(clk),
        .event_pressed(up_prs)
    );
    
    keypressed down_prs_event (
        .key(down),
        .clk(clk),
        .event_pressed(down_prs)
    );
    
    keypressed left_prs_event (
        .key(left),
        .clk(clk),
        .event_pressed(left_prs)
    );

    keypressed right_prs_event (
        .key(right),
        .clk(clk),
        .event_pressed(right_prs)
    );

    keypressed enter_prs_event (
        .key(enter),
        .clk(clk),
        .event_pressed(enter_prs)
    );

    always @ (posedge clk) begin
        if (!we) begin
            if (!avail) begin
                avail <= up_prs | down_prs | left_prs | right_prs | enter_prs;
                if (up_prs) value <= upval;
                else if (down_prs) value <= downval;
                else if (left_prs) value <= leftval;
                else if (right_prs) value <= rightval;
                else if (enter_prs) value <= enterval;
                else value <= nop;
            end
        end else begin
            if (addr == 1) begin
                avail <= din;
            end
        end
    end
    
    assign dout = ({`BITS{~addr}} & value) | (addr & avail);
    
endmodule
