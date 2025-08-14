
/* ***************** TOp module  ************/
module UART_top(

input	MAX10_CLK1_50,

/*
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,
*/
	input 		     [1:0]		KEY,
	output		     [9:0]		LEDR,
//	input 		     [9:0]		SW,
	input	iRx_serial,
	output	o_Tx_Serial, 
	output clk_1hz // pin AA2
);


wire Rx_valid; // the recieved byte is valid
wire [7:0] rx_data;

wire iTx_DV; // data to transmitis valid. start transmitting
//wire iRx_serial; // the serial stream
wire [7:0] i_Tx_Byte;
wire o_Tx_Active;
//wire o_Tx_Serial;
wire o_Tx_Done;
wire reset;


//always @(posedge MAX10_CLK1_50) begin
//reset = ~KEY[0];
//end

//always @(*) begin
//assign iRx_serial=o_Tx_Serial;
//end

control ctrl(MAX10_CLK1_50,KEY,reset,LEDR,clk_1hz);


UART my_uart(MAX10_CLK1_50,reset,iRx_serial,Rx_valid,rx_data,iTx_DV,i_Tx_Byte,o_Tx_Active,o_Tx_Serial,o_Tx_Done);

// Stage 1: 
// this simulates the case of transmitting into the UART.
// inside the UART, a patch was made to xonnect the TX into the RX, 
// in order to see if transmiltting into the reciever is working
// STage 2: 
// Sending byte after byte, with different value. Working. 2Feb25
// stage 3: Use real input from host, instead of tx_activate
// tx_activate tx_act(MAX10_CLK1_50,reset,iTx_DV,i_Tx_Byte,o_Tx_Done,Rx_valid);

// this is for host testing: the host is sending a byte, and gets it back for comparison
tx_repeater tx_rpt(MAX10_CLK1_50,reset,Rx_valid,rx_data,iTx_DV,i_Tx_Byte,o_Tx_Done);


endmodule
