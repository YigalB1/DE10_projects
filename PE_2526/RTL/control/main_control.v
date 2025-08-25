module main_control(
    input clk,
    input wire rst,
    output [7:0] tx_data,
    output tx_start,
    input tx_busy,
    input [7:0] rx_data,
    input rx_ready
);

    uart_ctrl uart_ctrl(clk,rst,tx_busy,tx_data,tx_start); // NEW UART
endmodule