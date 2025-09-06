module uart_tst (
    input clk,
    input rst,
    input rx_ready,
    input [7:0] rx_data,
    input tx_busy,
    output reg [7:0] tx_data,
    output reg tx_start,
    output reg [3:0] svn_seg_0,
    output reg [9:0] states_leds
    //input UART_loopback // 0: normal mode, 1: loop back for simulations
);

    // State encoding
    localparam STATE0 = 4'd0,
               STATE1 = 4'd1,
               STATE2 = 4'd2,
               STATE3 = 4'd3,
               STATE4 = 4'd4,
               STATE5 = 4'd5,
               STATE6 = 4'd6,
               STATE7 = 4'd7,
               STATE8 = 4'd8,
               STATE9 = 4'd9,
               STATE10 = 4'd10,
               STATE11 = 4'd11,
               STATE12 = 4'd12,
               STATE13 = 4'd13,
               STATE14 = 4'd14,
               STATE15 = 4'd15;


    reg [3:0] state, next_state;
    reg [7:0] data_to_tx ; // dummy data to transmit on TX and recieve on RX 
    reg rx_ready_flag; // rx_ready is one cycle pulse, this flag holds it till we read it
    




    // State register
    //always @(posedge clk or posedge rst) begin 
    always @(posedge clk) begin 
        if (rst) begin
            tx_start <= 1'b0;
            tx_data <= 8'b0;
            rx_ready_flag <= 1'b0;
            states_leds <= 10'b0; // each led for each status
            state <= STATE0; // starting state
            data_to_tx <= 8'd65; // ASCII A

/*
            if (UART_loopback == 1) begin // loop back
                state <= STATE10; // loop back mode
                data_to_tx <= 8'h54;
            end else begin
                state <= STATE0; // normal mode
                // Normal mode: recieve byte from host and send it back, incremented by 1    
                data_to_tx <= 8'd65; // ASCII A
            end
*/

        end else begin// of of rst
            state <= next_state;
           // Set the flag when rx_ready pulses
            if (rx_ready)
                rx_ready_flag <= 1'b1;
            // Clear the flag when FSM enters STATE1 (i.e., after acknowledging)
            else if (state == STATE1 || state == STATE10)
                // rx_ready was captured, reset the flag
                rx_ready_flag <= 1'b0;


            // Work on states

            if (state == STATE0) begin // Send one byte to host
                tx_start <= 1'b1;
                tx_data <= data_to_tx;
                states_leds[0] <= 1'b1; // indicate we are in state 0
            end
            if (state == STATE1) begin  // wait for tx to be finished
                                        // Clear the start signal after one cycle
                tx_start <= 1'b0;
                data_to_tx <= data_to_tx+8'b1; // increment the data to transmit next time
                svn_seg_0 <= 4'hA; // display A on 7 seg
                states_leds[1] <= 1'b1; // indicate we are in state 1
            end
            else if (state == STATE2) begin // wait for rx data ready
                svn_seg_0 <= 4'hB; // display B on 7 seg
                states_leds[2] <= 1'b1; // indicate we are in state 2   
            end
            else if (state == STATE3) begin //wait here
                states_leds[3] <= 1'b1; // indicate we are in state 0   
            end
            else if (state == STATE4) begin // wait for tranmit end
                states_leds[4] <= 1'b1; // indicate we are in state 3   
            end
            else if (state == STATE5) begin // wait for tranmit end
                states_leds[5] <= 1'b1; // indicate we are in state 4   
            end
            else if (state == STATE6) begin // wait for tranmit end
                states_leds[6] <= 1'b1; // indicate we are in state 5   
            end
            else if (state == STATE7) begin // wait for tranmit end
                states_leds[7] <= 1'b1; // indicate we are in state 6   
            end
            else if (state == STATE8) begin // wait for tranmit end
                states_leds[8] <= 1'b1; // indicate we are in state 7   
            end
            else if (state == STATE9) begin // wait for tranmit end
                states_leds[9] <= 1'b1; // indicate we are in state 8
            end
            else if (state == STATE10) begin // Lopp back mode, send one
                data_to_tx <= data_to_tx+8'b1;
                tx_start <= 1'b1;
                tx_data <= data_to_tx; // send dummy data
            end
            else if (state == STATE11) begin // data sent, wait for it to be sent and recieved in rx
                tx_start <= 1'b0;
            end




        end // of not reset
    end // of always

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            STATE0: begin  // wait for Rx data ready
                next_state = STATE1;
                    
            end
            STATE1: begin  // wait for TX to end
               if (tx_busy)
                    next_state = STATE1; // wait here if busy
                else 
                    next_state = STATE2; // start again
            end
            STATE2: begin  // Start transmit
                if (~rx_ready_flag)
                    next_state = STATE2;
                else 
                    next_state = STATE3;
            end
            STATE3: begin  // disable write to tx_uart
                next_state = STATE0;
            end
            STATE4: begin //  wait for TX ready
                end
            
            STATE9: begin // wait for data to be sent
                next_state = STATE9; // stay here, wrong state
             end           
            // Fill in other state transitions as needed
            STATE10: begin // prepare to send 
                next_state = STATE11; // Start transmitting
             end
            STATE11: begin // wait for data to be sent
                //if (tx_busy || ~rx_ready) begin
                if (tx_busy || ~rx_ready_flag) begin
                    next_state = STATE11; 
                    //wait till data is recieved and until TX is ready again
                end else begin 
                    next_state = STATE10; // time to send another byte
                end
            end
  


            default: next_state = STATE9;
        endcase
    end

endmodule