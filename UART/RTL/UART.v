// from https://nandland.com/uart-serial-port-module/

module UART(
	input MAX10_CLK1_50,
    input rst,
	input iRx_serial, // the serial input
    output Rx_valid,
    output [7:0] rx_data,
    input iTx_DV, // data to transmit is valid. start transmitting
    input [7:0] i_Tx_Byte,
    output o_Tx_Active,
    output o_Tx_Serial,
    output o_Tx_Done
);

// uart_rx uart_r(MAX10_CLK1_50,iRx_serial,Rx_valid,rx_data); 
// for testing, loop back the tx into rx
uart_rx uart_r(MAX10_CLK1_50,o_Tx_Serial,Rx_valid,rx_data);
uart_tx uart_t(MAX10_CLK1_50,iTx_DV,i_Tx_Byte,o_Tx_Active,o_Tx_Serial,o_Tx_Done);



endmodule