`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/12 17:32:54
// Design Name: 
// Module Name: keypressed
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


module keypressed(
    input key,
    input clk,
    output event_pressed
    );
    
    reg last_key;
    
    assign event_pressed = ~last_key & key;
    
    always @ (posedge clk)
        last_key <= key;
        
endmodule
