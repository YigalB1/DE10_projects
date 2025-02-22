// Control is responsible for:
// reset (TBD from top level)
// toggle a led at 1Hz to show this design is a live
// maybe something to do with Key[1] unused input

module control(
input clk,
input [1:0]	key,
output reg rst,
output reg [9:0] ledr,
output reg clk_1hz // 1hz clk for testing
);

always @(posedge clk) begin
    rst = ~key[0];
    ledr[7:0] = 9'b10101010;

    ledr[8] = clk_1hz; // Toggle led at 1Hz
    ledr[9] = key[1]; // oggle led by pressing button
end


reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd500000000; // add one zero to make it 0.1Hz

always @(posedge clk)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;
 clk_1hz <= (counter<DIVISOR/2)?1'b1:1'b0;
 
end




endmodule