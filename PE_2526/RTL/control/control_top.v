module control_top(
    input clk,
    input wire rst,
    output [7:0] tx_data,
    output tx_start,
    input tx_busy,
    input [7:0] rx_data,
    input rx_ready,
    input UART_loopback // 0: normal mode, 1: loop back for simulations
);

    uart_tst uart_tst(clk,rst,rx_ready,rx_data,tx_busy,tx_data,tx_start,UART_loopback); // NEW UART
    
endmodule