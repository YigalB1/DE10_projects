module control_top(
    input clk,
    input wire rst,
    output [7:0] tx_data,
    output tx_start,
    input tx_busy,
    input [7:0] rx_data,
    input rx_ready,
    output [3:0] svn_seg_0_val,
    //input UART_loopback // 0: normal mode, 1: loop back for simulations
    output [9:0] states_leds
);

    uart_tst uart_tst(clk,rst,rx_ready,rx_data,tx_busy,tx_data,tx_start,svn_seg_0_val,states_leds); // NEW UART
    
endmodule