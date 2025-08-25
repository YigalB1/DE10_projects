module uart_rx( 
    input wire clk,
    input wire rst,
    input wire [31:0] clk_freq,
    input wire [31:0] baud,
    input wire[31:0] baud_tick,
    input wire [31:0] half_baud,
    input wire rx,
    output reg [7:0] data_out,
    output reg data_ready
);

//localparam BAUD_TICK = CLK_FREQ / BAUD_RATE;
//localparam HALF_BAUD = BAUD_TICK / 2;




reg [31:0] baud_counter = 0;
reg [3:0] bit_index = 0;
reg [7:0] rx_shift = 0;
reg rx_sync = 1;
reg rx_prev = 1;
reg receiving = 0;

always @(posedge clk) begin
    rx_prev <= rx_sync;
    rx_sync <= rx;

    if (!receiving) begin
        if (rx_prev && !rx_sync) begin  // Start bit detected
            receiving <= 1;
            baud_counter <= half_baud;
            bit_index <= 0;
        end
    end else begin
        if (baud_counter == 0) begin
            baud_counter <= baud_tick;

            if (bit_index < 8) begin
                rx_shift[bit_index] <= rx_sync;
                bit_index <= bit_index + 4'b1;
            end else begin
                receiving <= 0;
                data_out <= rx_shift;
                data_ready <= 1;
            end
        end else begin
            baud_counter <= baud_counter - 1;
        end
    end

    if (data_ready) begin
        data_ready <= 0;  // Clear after one cycle
    end
end

endmodule