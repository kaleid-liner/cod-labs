`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/18 17:42:22
// Design Name: 
// Module Name: debouncer
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


module debouncer(
    input clk_50mhz,
    input button,
    output btn_down
    );
    reg [22:0] count;
    reg [24:0] enter_hold_cnt;
    reg [21:0] hold_cnt;
    
    reg cur_button;
    // is button pressed or released in last cycle
    reg prev_button;
    /*
    assign btn_down = ((~prev_button) & cur_button) | (button & (hold_cnt == 0));
    
    initial 
    begin
        count = 0;
        prev_button = 0;
        enter_hold_cnt = 0;
        hold_cnt = 0;
    end
    
    always @ (posedge clk_50mhz) begin
        prev_button <= cur_button;
    end
    
    always @ (posedge clk_50mhz) begin
        if (count >= 23'd49999) begin
            count <= 0;
            cur_button <= button;
        end 
        else count <= count + 1;
    end
    
    always @ (posedge clk_50mhz) begin
        if (button) begin
            if (enter_hold_cnt >= 25'd25000000) begin
                hold_cnt <= hold_cnt + 1;
            end else begin
                enter_hold_cnt <= enter_hold_cnt + 1;
            end
        end else begin
            enter_hold_cnt <= 0;
        end
    
    end
    */
    always @ (posedge clk_50mhz) begin
        count <= count + 1;
    end
    assign btn_down = button & (count == 0);
    
endmodule
