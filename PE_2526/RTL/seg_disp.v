module seg_disp (
    input      [3:0] val_in,            // 4-bit input (0–15)
    output reg [7:0] seven_seg_out    // Segments a–g for HEX0
);

// Common cathode segment encoding
always @(*) begin
    case (val_in)
        4'h0: seven_seg_out = 8'b0_0111111;
        4'h1: seven_seg_out = 8'b0_0000110;
        4'h2: seven_seg_out = 8'b0_1011011;
        4'h3: seven_seg_out = 8'b0_1001111;
        4'h4: seven_seg_out = 8'b0_1100110;
        4'h5: seven_seg_out = 8'b0_1101101;
        4'h6: seven_seg_out = 8'b0_1111101;
        4'h7: seven_seg_out = 8'b0_0000111;
        4'h8: seven_seg_out = 8'b0_1111111;
        4'h9: seven_seg_out = 8'b0_1101111;
        4'hA: seven_seg_out = 8'b0_1110111;
        4'hB: seven_seg_out = 8'b0_1111100;
        4'hC: seven_seg_out = 8'b0_0111001;
        4'hD: seven_seg_out = 8'b0_1011110;
        4'hE: seven_seg_out = 8'b0_1111001;
        4'hF: seven_seg_out = 8'b0_1110001;
        default: seven_seg_out = 8'b0_0000000;
    endcase
end

endmodule
