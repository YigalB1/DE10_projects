module uart_control (
    input wire clk,
    input wire rst,

    // UART RX interface
    input wire [7:0] rx_data,
    input wire rx_ready,

    // UART TX interface
    output reg [7:0] tx_data,
    output reg tx_start,
    input wire tx_busy,

    // RAM interfaces
    output reg [9:0] ram_addr,
    output reg [7:0] ram1_data_out,
    output reg [7:0] ram2_data_out,
    output reg [7:0] ram3_data_out,
    output reg ram1_we,
    output reg ram2_we,
    output reg ram3_we,
    input wire [7:0] ram1_data_in,
    input wire [7:0] ram2_data_in,
    input wire [7:0] ram3_data_in,

    // LED control
    output reg led7
);

    reg [3:0] state = 0;
    reg [9:0] byte_counter = 0;
    reg [7:0] command_byte = 0;
    reg [23:0] led_timer = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            tx_start <= 0;
            ram1_we <= 0;
            ram2_we <= 0;
            ram3_we <= 0;
            led7 <= 0;
            byte_counter <= 0;
            ram_addr <= 0;
        end else begin
            tx_start <= 0;
            ram1_we <= 0;
            ram2_we <= 0;
            ram3_we <= 0;

            case (state)
                4'd0: begin
                    if (rx_ready) begin
                        command_byte <= rx_data;
                        state <= 4'd1;
                    end
                end

                4'd1: begin
                    case (command_byte)
                        8'd0: begin
                            if (!tx_busy) begin
                                tx_data <= command_byte;
                                tx_start <= 1;
                                state <= 4'd0;
                            end
                        end
                        8'd1: state <= 4'd2;
                        8'd2: state <= 4'd3;
                        8'd3: state <= 4'd4;
                        8'd4: state <= 4'd5;
                        8'd5: state <= 4'd6;
                        8'd6: state <= 4'd7;
                        8'd15: begin
                            led7 <= 1;
                            led_timer <= 24'd50000000; // 1 second at 50 MHz
                            state <= 4'd15;
                        end
                        default: state <= 4'd0;
                    endcase
                end

                // Fill RAM1
                4'd2: begin
                    if (rx_ready) begin
                        ram1_data_out <= rx_data;
                        ram1_we <= 1;
                        ram_addr <= byte_counter;
                        byte_counter <= byte_counter + 1;
                        if (byte_counter == 1023) begin
                            byte_counter <= 0;
                            state <= 4'd0;
                        end
                    end
                end

                // Fill RAM2
                4'd3: begin
                    if (rx_ready) begin
                        ram2_data_out <= rx_data;
                        ram2_we <= 1;
                        ram_addr <= byte_counter;
                        byte_counter <= byte_counter + 1;
                        if (byte_counter == 1023) begin
                            byte_counter <= 0;
                            state <= 4'd0;
                        end
                    end
                end

                // Fill RAM3
                4'd4: begin
                    if (rx_ready) begin
                        ram3_data_out <= rx_data;
                        ram3_we <= 1;
                        ram_addr <= byte_counter;
                        byte_counter <= byte_counter + 1;
                        if (byte_counter == 1023) begin
                            byte_counter <= 0;
                            state <= 4'd0;
                        end
                    end
                end

                // Read RAM1
                4'd5: begin
                    if (!tx_busy) begin
                        tx_data <= ram1_data_in;
                        tx_start <= 1;
                        ram_addr <= byte_counter;
                        byte_counter <= byte_counter + 1;
                        if (byte_counter == 1023) begin
                            byte_counter <= 0;
                            state <= 4'd0;
                        end
                    end
                end

                // Read RAM2
                4'd6: begin
                    if (!tx_busy) begin
                        tx_data <= ram2_data_in;
                        tx_start <= 1;
                        ram_addr <= byte_counter;
                        byte_counter <= byte_counter + 1;
                        if (byte_counter == 1023) begin
                            byte_counter <= 0;
                            state <= 4'd0;
                        end
                    end
                end

                // Read RAM3
                4'd7: begin
                    if (!tx_busy) begin
                        tx_data <= ram3_data_in;
                        tx_start <= 1;
                        ram_addr <= byte_counter;
                        byte_counter <= byte_counter + 1;
                        if (byte_counter == 1023) begin
                            byte_counter <= 0;
                            state <= 4'd0;
                        end
                    end
                end

                // States 8–14: do nothing
                4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13, 4'd14: begin
                    state <= 4'd0;
                end

                // LED pulse
                4'd15: begin
                    if (led_timer > 0) begin
                        led_timer <= led_timer - 1;
                    end else begin
                        led7 <= 0;
                        state <= 4'd0;
                    end
                end
            endcase
        end
    end

endmodule