module tx_activate(
input clk,
input rst,
output reg iTx,
output reg [7:0] tx_data
);

/*
always @(posedge clk)
begin
	iTx=0;
	tx_data=55;
end
*/



  parameter IDLE   = 3'b000;
  parameter STATE1 = 3'b001;
  parameter STATE2 = 3'b010;
  parameter STATE3 = 3'b011;
  parameter STATE4 = 3'b100;
  parameter STATE5 = 3'b101;
  parameter STATE6 = 3'b110;
  parameter STATE7 = 3'b111;

  reg [2:0] current_state, next_state;

  always @(posedge clk or posedge rst) begin //1
    if (rst) begin //2
      current_state <= IDLE; 
      //iTx=0;
      //tx_data=0;
    end else begin //2
      current_state <= next_state;
    end //2
  end

  /*
   always @(posedge clk) begin 
    if (current_state==IDLE) begin
    end else if (current_state==STATE1) begin
    end else if (current_state==2) begin
    end
  end //1
  */

  always @(*) begin
    case (current_state)
      IDLE: begin
        next_state = STATE1; 
		  iTx=0;
		  tx_data=0;
      end
      STATE1: begin
        next_state = STATE2; 
		  iTx =1;
		  tx_data=55;
      end
      STATE2: begin
        next_state = STATE2;  // stay here until TX byte is transmitted. TBD.
		  iTx =0;
      end
      STATE3: begin
        next_state = IDLE; 
      end
      default: begin
        next_state = IDLE; 
      end
    endcase
  end



endmodule