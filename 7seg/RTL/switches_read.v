module switches_read (
    input clk,          // Clock signal (e.g., 50MHz)
   // input rst_n,        // Asynchronous reset (active low)
    input [9:0] switches, // 8-bit input from the switches
    output reg [7:0] switch_values // Register to store debounced switch values
);

// Debouncing logic (one flip-flop per switch)
reg [9:0] switch_debounced;
reg [9:0] switch_prev;

always @(posedge clk) begin

        switch_prev <= switches; // Store the current switch state

        // Debounce: If the switch state has been stable for a few clock cycles, update the debounced value.
        // Adjust the number of cycles (e.g., 5, 10, or more) for stronger debouncing.
        if (switches == switch_prev) begin // Check for stability
            switch_debounced <= switches;
        end
        switch_values <= switch_debounced; // Update the output with the debounced values
end


endmodule