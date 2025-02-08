module seven_seg_top(
 input MAX10_CLK1_50,
 input [9:0] SW, // 8-bit input from the switches
 output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5
// output reg [5:0] [7:0] segment, // 6 * 7-segment display output (common cathode)
// output reg [3:0] digit   // Digit select output (active low)
);

// HEX0..5
wire switches_out;

//switches_read sw(MAX10_CLK1_50,SW,switches_out);
SEG7_LUT_6 seg7(SW[3:0],SW[7:4],SW[3:0],SW[7:4],SW[3:0],SW[7:4],HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);


endmodule