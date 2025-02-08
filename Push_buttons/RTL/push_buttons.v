module push_buttons(
    input MAX10_CLK1_50, 
    input [1:0] KEY,
    output reg [7:0] LEDR
);



reg [9:0] leds;

always @(posedge MAX10_CLK1_50) begin
    //key_reg <=key;
    if(KEY[0]==0) begin
        leds[3:0]=4'b1111;
		  leds[7:4]=4'b0000;
    end
	 else if(KEY[1]==0) begin
		  leds[3:0]=4'b0000;
		  leds[7:4]=4'b1111;
	 end 
	 else begin
		  leds[3:0]=4'b1010;
		  leds[7:4]=4'b0101;
	 end 
end

always @ (posedge MAX10_CLK1_50) begin
	LEDR[7:0] <= leds[7:0];
end
endmodule