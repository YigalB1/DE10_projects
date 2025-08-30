module ram_test (

    input        clk,        // Clock
    input        wr_en,      // Write enable
    input        rd_en,      // Read enable
    input [9:0]  addr,       // 10-bit address (1024 locations)
    input [31:0] data_in,    // Data to write
    output reg [31:0] data_out // Data read
);

    // RAM declaration: 1024 x 32-bit
    reg [31:0] ram [0:1023];

    always @(posedge clk) begin
        if (wr_en)
            ram[addr] <= data_in;

        if (rd_en)
            data_out <= ram[addr];
    end
endmodule
