// Control is responsible for:
// reset (TBD from top level)
// toggle a led at 1Hz to show this design is a live
// maybe something to do with Key[1] unused input

module sig_control(
input clk,
input [1:0]	key,
output wire rst,
output reg [9:0] ledr,
output reg clk_1hz // 1hz clk for testing
);

reg rst_reg;   // to sample the reset push button
always @(posedge clk) begin
    rst_reg = ~key[0];
    ledr[0] =  clk_1hz; // Toggle led at 1Hz
    ledr[1] = ~clk_1hz; // Toggle led at 1Hz
    ledr[2] =  clk_1hz; // Toggle led at 1Hz
    ledr[3] = ~clk_1hz; // Toggle led at 1Hz
    ledr[4] =  clk_1hz; // Toggle led at 1Hz
    ledr[5] = ~clk_1hz; // Toggle led at 1Hz
    ledr[6] =  clk_1hz; // Toggle led at 1Hz
    ledr[7] =  ~clk_1hz; // Toggle led at 1Hz
    ledr[8] =  clk_1hz; // Toggle led at 1Hz
    ledr[9] =  key[1]; // oggle led by pressing button
end
assign rst=rst_reg;

reg[28:0] counter=29'd0;
parameter DIVISOR = 29'd500000000; // add one zero to make it 0.1Hz

always @(posedge clk)
begin
 counter <= counter + 29'd1;
 if(counter>=(DIVISOR-1))
  counter <= 29'd0;
 clk_1hz <= (counter<DIVISOR/2)?1'b1:1'b0;
end

endmodule