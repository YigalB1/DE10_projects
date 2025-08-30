module uart_top (
  
    input wire clk,
    input wire rst,
    input wire uart_rx,              // incoming serial data
    output wire uart_tx,             // outgoing serial data
    output wire [7:0] rx_data,
    output wire rx_ready,
    input wire [7:0] tx_data,
    input wire tx_start,
    output wire tx_busy
);

    localparam CLK_FREQ = 50000000; // 50 MHz
    localparam BAUD_RATE = 9600;

    wire [31:0] clk_freq  = CLK_FREQ;
    wire [31:0] baud_rate = BAUD_RATE;
    wire [31:0] baud_tick = CLK_FREQ/BAUD_RATE;
    wire [31:0] half_baud = baud_tick/2;


   
    // Instantiate RX block
    rx rx(clk,rst,baud_tick,half_baud,uart_rx,rx_data,rx_ready);
    tx tx(clk,rst,clk_freq,baud_rate,tx_data,tx_start,uart_tx,tx_busy);

endmodule