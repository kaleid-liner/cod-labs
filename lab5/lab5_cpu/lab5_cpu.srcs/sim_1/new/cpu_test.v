`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/05 16:05:05
// Design Name: 
// Module Name: cpu_test
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


module cpu_test(
    );
    
    reg clk;
    reg rst;
    reg run;
    
    initial begin clk = 0; rst = 0; run = 1; end
    always #10 clk = ~clk;
    
    always begin
        #100 run = 0;
        #200 run = 1;
    end
    
    wire [7:0] addr = 8'h2;
    wire [31:0] mem_data, reg_data;
    cpu _cpu (
        .clk(clk),
        .run(run),
        .rst(rst),
        .ddu_addr(addr),
        .ddu_mem(mem_data),
        .ddu_reg(reg_data)
    );
    
endmodule
