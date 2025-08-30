module rx (
    input wire clk,
    input wire rst,
    input wire [31:0] baud_tick,
    input wire [31:0] half_baud,
    input wire rx,
    output reg [7:0] data_out,
    output reg data_ready
);
/*
reg [31:0] baud_counter = 0;
reg [3:0] bit_index = 0;
reg [7:0] rx_shift = 0;
reg rx_sync = 1;
reg rx_prev = 1;
reg receiving = 0;
reg data_ready_next = 0;
*/
reg [31:0] baud_counter;
reg [3:0] bit_index ;
reg [7:0] rx_shift;
reg rx_sync;
reg rx_prev;
reg receiving;
reg data_ready_next;


always @(posedge clk) begin
    if (rst) begin
        rx_sync <= 1;
        rx_prev <= 1;
        receiving <= 0;
        baud_counter <= 0;
        bit_index <= 0;
        rx_shift <= 0;
        data_out <= 0;
        data_ready <= 0;
        data_ready_next <= 0;
    end else begin
        // Synchronize RX input
        rx_prev <= rx_sync;
        rx_sync <= rx;

        // Detect start bit
        if (!receiving && rx_prev && !rx_sync) begin
            receiving <= 1;
            // baud_counter <= half_baud;
            baud_counter <= baud_tick;
            bit_index <= 0;
        end

        // Receiving bits
        if (receiving) begin
            if (baud_counter == 0) begin
                baud_counter <= baud_tick;

                if (bit_index < 8) begin
                    rx_shift[bit_index] <= rx_sync;
                    bit_index <= bit_index + 4'b1;
                end else begin
                    receiving <= 0;
                    data_out <= rx_shift;
                    data_ready_next <= 1;  // Trigger pulse
                end
            end else begin
                baud_counter <= baud_counter - 1;
            end
        end



        // One-cycle pulse logic
        // One-cycle pulse logic
if (data_ready_next == 1) begin
    data_ready <= 1;
    data_ready_next <= 0;
end else begin
    data_ready <= 0;
end


//        data_ready <= data_ready_next;
//        data_ready_next <= 0; 
    end // of reset if
end // of always block

endmodule












/* prev file 
module rx( 
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


*/ 