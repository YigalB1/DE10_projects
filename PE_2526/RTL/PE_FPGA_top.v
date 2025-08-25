
/* ***************** TOp module  ************/
module PE_FPGA_top(

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
	input	iRx_serial, // AA7 DPIO26
	output	oTx_Serial, //Y6  GPIO27
	output clk_1hz, // pin AA2
	output xor_tot // dummy signal to prevent synthesis killing logic
);


wire Rx_valid; // the recieved byte is valid
wire [7:0] rx_data;
wire iTx_DV; // data to transmitis valid. start transmitting

wire [7:0] i_Tx_Byte;
wire o_Tx_Active;
wire o_Tx_Done;
wire reset;

// for the memories
wire  [31:0] memA_out;
wire  [31:0] memB_out;
wire  [ 7:0] memC_out;

reg  [31:0] memA_d;
reg  [31:0] memB_d;
reg  [ 7:0] memC_d;


reg  [9:0] addr;
wire  [31:0] mem_tst_o;

//ram_test memtest (MAX10_CLK1_50,reset,addr,memA_out,mem_tst_o); // just to prove RAM capabilies
// data in and RST are just to try

memories memories(MAX10_CLK1_50,reset,memA_out,memB_out,memC_out,xor_tot);

 always @(posedge MAX10_CLK1_50) begin //1
		memA_d = memA_d + memA_out;
		memB_d = memB_d + memB_out;
		memC_d = memC_d + memC_out;
  end


wire [7:0] tx_data;
wire tx_start;
wire rx_ready;
wire tx_busy;

uart_top uart(MAX10_CLK1_50,reset,iRx_serial,oTx_Serial,rx_data,rx_ready,tx_data,tx_start,tx_busy); // the NEW UART



//always @(posedge MAX10_CLK1_50) begin
//reset = ~KEY[0];
//end

main_control main_ctrl(MAX10_CLK1_50,reset,tx_data,tx_start,tx_busy,rx_data,rx_ready);
control ctrl(MAX10_CLK1_50,KEY,reset,LEDR,clk_1hz);


//UART my_uart(MAX10_CLK1_50,reset,iRx_serial,Rx_valid,rx_data,iTx_DV,i_Tx_Byte,o_Tx_Active,oTx_Serial,o_Tx_Done);

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
