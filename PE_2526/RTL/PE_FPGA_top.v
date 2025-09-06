
/* ***************** TOp module  ************/
module PE_FPGA_top(

input	MAX10_CLK1_50,

	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
/*
	
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,
*/
	input 		     [1:0]		KEY,
	output		     [9:0]		LEDR,
//	input 		     [9:0]		SW,
	input	iRx_serial, // AA7 DPIO26
	output	oTx_Serial, //Y6  GPIO27
	output clk_1hz, // pin AA2
	output xor_tot, // dummy signal to prevent synthesis killing logic
	output xor_tot2 // dummy signal to prevent synthesis killing logic
);



wire [7:0] rx_data;
wire reset;
// for the memories
wire  [31:0] memA_out;
wire  [31:0] memB_out;
wire  [ 7:0] memC_out;

memories memories(MAX10_CLK1_50,reset,memA_out,memB_out,memC_out,xor_tot);

wire xorA = ^memA_out; // XOR reduction of busA
wire xorB = ^memB_out; // XOR reduction of busB
wire xorC = ^memC_out; // XOR reduction of busC
assign xor_tot2 = xorA ^ xorB ^ xorC;


wire [7:0] tx_data;
wire tx_start;
wire rx_ready;
wire tx_busy;
wire [3:0] val_in_0; // to 7 seg
//wire [6:0] svn_seg_0_val; // from 7 seg

//parameter UART_loopback = 1'b1; // 1: loopback mode. 0: normal mode
//parameter UART_loopback = 1'b0; // 1: loopback mode. 0: normal mode

//wire loopback;
//assign loopback = UART_loopback;

wire rx_in;
//assign rx_in = (UART_loopback == 1) ? oTx_Serial : iRx_serial;
assign rx_in = iRx_serial;

wire [9:0] states_leds;
wire rst_led; // for reset debug

assign LEDR[9] = rst_led; // reset indicator
assign LEDR[8:0] = states_leds[8:0]; // state

uart_top uart_top(MAX10_CLK1_50,reset,rx_in,oTx_Serial,rx_data,rx_ready,tx_data,tx_start,tx_busy); // the NEW UART

control_top control_top(MAX10_CLK1_50,reset,tx_data,tx_start,tx_busy,rx_data,rx_ready,val_in_0,states_leds);

sig_control sig_control(MAX10_CLK1_50,KEY,reset,rst_led,clk_1hz);

seg_disp seg_disp_0(val_in_0,HEX0); 
seg_disp seg_disp_1(8'b0_1001111,HEX1);  // should present 3 on the second 7seg
endmodule
