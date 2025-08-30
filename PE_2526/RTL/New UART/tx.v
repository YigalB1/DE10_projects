module tx (
    input clk,              // 50 MHz system clock
    input rst,   
    input wire [31:0] clk_freq,
    input wire [31:0] baud,          // active-high reset
    input [7:0] data_in,    // byte to transmit
    input wire send,             // pulse to start transmission
    output reg tx,          // UART TX output
    output reg busy         // high while transmitting
);

//parameter BAUD_RATE = 115200;
//parameter CLOCK_FREQ = 50000000;
//parameter BAUD_DIV = CLOCK_FREQ / BAUD_RATE;

//reg [15:0] baud_div;
reg [31:0] baud_div;

always @(posedge clk or posedge rst) begin
    if (rst)
        baud_div <= 0;
    else
        baud_div <= clk_freq / baud;
end


//reg [13:0] clk_div = 0;
reg [31:0] clk_div = 0;
reg baud_tick = 0;

reg [3:0] bit_index = 0;
reg [9:0] shift_reg = 10'b1111111111; // start + data + stop bits

always @(posedge clk or posedge rst) begin
    if (rst) begin
        clk_div <= 0;
        baud_tick <= 0;
    end else begin
        if (clk_div == baud_div - 1) begin
            clk_div <= 0;
            baud_tick <= 1;
        end else begin
            clk_div <= clk_div + 32'b1;
            baud_tick <= 0;
        end
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx <= 1;
        busy <= 0;
        bit_index <= 0;
        shift_reg <= 10'b1111111111;
    end else begin
        if (!busy && send) begin
            shift_reg <= {1'b1, data_in, 1'b0}; // stop, data, start
            busy <= 1;
            bit_index <= 0;
        end else if (busy && baud_tick) begin
            tx <= shift_reg[bit_index];
            bit_index <= bit_index + 4'b1;
            if (bit_index == 9) begin
                busy <= 0;
                tx <= 1;
            end
        end
    end
end

endmodule