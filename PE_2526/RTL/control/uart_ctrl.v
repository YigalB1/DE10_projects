module uart_ctrl (
    input clk,
    input rst,
    input tx_busy,
    output reg [7:0] tx_data,
    output reg tx_start
);

    // State encoding
    localparam STATE0 = 3'd0,
               STATE1 = 3'd1,
               STATE2 = 3'd2,
               STATE3 = 3'd3,
               STATE4 = 3'd4,
               STATE5 = 3'd5,
               STATE6 = 3'd6,
               STATE7 = 3'd7;

    reg [2:0] state, next_state;
    reg  [7:0] num_of_bytes; // how many bytes to send

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STATE0;
            num_of_bytes <= 4'd0; // reset value 
        end
        else begin
            state <= next_state;

            if (state == STATE0) begin // prep next send and wait for TX ready
                tx_start <= 1'b0;
                tx_data <= 8'h30; // the ascii for 0 TX data
                num_of_bytes <= 4'd6; //send 6 bytes
            end
            else if (state == STATE1) begin // start transmitting
                tx_start <= 1'b1;
                // prep fpr next time
                tx_data <= tx_data+8'b1; // inc to next character to send
                num_of_bytes <= num_of_bytes - 1'b1;
            end
            else if (state == STATE2) begin // wait for tranmit end
                tx_start <= 1'b0;
            end
            else if (state == STATE3) begin // staXXXrt transmitting
                tx_start <= 1'b0;
 
            end
            else if (state == STATE4) begin // staXXXrt transmitting
                tx_start <= 1'b0;
     
            end
            
        end // of not reset
    end // of always

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            STATE0: begin  // wait for TX ready
                if (tx_busy)
                    next_state = STATE0;
                else 
                    next_state = STATE1;
            end
            STATE1: begin // start transmitting
                    next_state = STATE2;
            end
            STATE2: begin // wait for transmit end
                if (tx_busy)
                    next_state = STATE2;
                else 
                    next_state = STATE3; // byte was sent
            end
            STATE3: begin // inc data and counter. In limits?
                if (tx_busy) begin // should not be here
                        next_state = STATE3; // error state
                    end else begin
                        next_state = STATE4; // send next byte
                    end
             end           
            STATE4: begin // send next byte and go to STATE0
                if (num_of_bytes == 4'd0) begin // finished counting
                    next_state = STATE0; // restart the sequance
                end else begin
                    next_state = STATE1; // send next byte
                end
            end
            STATE7: begin // Should not be here
                    next_state = STATE7;
            end

            // Fill in other state transitions as needed
            default: next_state = STATE7;
        endcase
    end




endmodule