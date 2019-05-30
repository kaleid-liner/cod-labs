`timescale 1ns / 1ps

module vga(
    input [6:0] x,
    input [6:0] y,
    input [11:0] vdata,
    input clk_50mhz,
    output [13:0] vaddr,
    output reg [11:0] vrgb,
    output hs,
    output vs
    );

    localparam HL = 11'd1040;
    localparam VL = 11'd666;
    localparam HSPW = 11'd120;
    localparam VSPW = 11'd6;
    
    localparam UP = 11'd265;
    localparam DOWN = 11'd393;
    localparam LEFT = 11'd520;
    localparam RIGHT = 11'd648;
    
    reg [10:0] hcnt,vcnt;
    wire [7:0] px,py;
    
    assign hs= (hcnt < HSPW) ? 0 : 1;
    assign vs = (vcnt < VSPW ) ? 0 : 1;
    assign px = hcnt - LEFT;
    assign py = vcnt - UP;
        
    assign vaddr = px + py * 128;
    
    
    always @ (posedge clk_50mhz)
    begin
    	if ( hcnt == (HL - 1))
    		hcnt <= 0;
    	else
    		hcnt <= hcnt + 1;
    end
    
    always @ (posedge clk_50mhz)
    begin
    	if (hcnt == (HL - 1)) 
    	begin
    		if (vcnt == (VL - 1))
    			vcnt <= 0;
    		else
    			vcnt <= vcnt + 1;
    	end
    end
    
    always @(posedge clk_50mhz)
    begin
        if(vcnt >= UP && vcnt < DOWN && hcnt >=LEFT && hcnt < RIGHT)
        begin
            if( (px<5+x && x<5+px && y==py) ||( py<5+y && y<5+py && x==px)) vrgb <= 12'h000;
            else vrgb <= vdata;
        end
        else vrgb <= 12'h000;
        
    end
    

endmodule

