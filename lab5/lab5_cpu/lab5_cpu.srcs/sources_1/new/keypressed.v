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
    reg [22:0] count;
    
    reg cur_key;
    // is key pressed or released in last cycle
    reg prev_key;
    assign event_pressed = (~prev_key) & cur_key;
    
    initial begin count = 0; end
    
    always @ (posedge clk) begin
        prev_key <= cur_key;
    end
    
    always @ (posedge clk) begin
        if (count >= 23'd499999) begin
            count <= 0;
            cur_key <= key;
        end 
        else count <= count + 1;
    end
    
endmodule
