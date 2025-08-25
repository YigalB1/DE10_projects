module memories (
  input clk,
  input rst,
  output [31:0] memA_out,
  output [31:0] memB_out,
  output [7:0]  memC_out,
  output xor_tot
);

reg [9:0] addr;
reg [31:0] din;
wire [31:0] dout1,dout2,dout3; // dout was removed
//reg [31:0] dout_s,dout_s1;
reg we1,we2,we3;
reg rd;
//reg init;
reg mem_wrd_start;
reg mem_wrd_end;

ram_test u1(clk,we1,rd,addr,din,dout1);
ram_test u2(clk,we2,rd,addr,din,dout2);
ram_test u3(clk,we3,rd,addr,din,dout3);

/*
mem1 u0 (
        .clock(clk),
        .wren(we1),
        .address(addr),
        .data(din),
        .q(dout)
    );
*/

wire [3:0] axor;
//wire xor_tot;

assign axor[0] = ^dout1; 
assign axor[1] = ^dout2; 
assign axor[2] = ^dout3; 
assign axor[3] = mem_wrd_start^mem_wrd_end; 
assign xor_tot = ^axor;


assign memA_out = dout1;
assign memB_out = dout2;
assign memC_out = dout3[7:0];


reg [31:0] dummy;
//reg [31:0] dummy1;
reg [31:0] control_pack;

always @(posedge clk ) begin //1
  //  dummy1 <= dout + dout1;
    //dout_s  <= dout;
    //dout_s1 <= dout1;
end

/*
always @(posedge clk ) begin //1
    control_pack <= {29'b0, init, mem_wrd_start, mem_wrd_end};
    dummy <= dummy + dout_s + dout_s1 + control_pack;
end
*/

// State machine
// Define state encoding
parameter STATE0   = 4'b0000; // start
parameter STATE1   = 4'b0001; // write
parameter STATE2   = 4'b0010; // wait
parameter STATE3   = 4'b0011; // done writing
parameter STATE4   = 4'b0100; // done
parameter STATE5   = 4'b0101; // done
parameter STATE6   = 4'b0110; // done
parameter STATE7   = 4'b0111; // done
parameter STATE8   = 4'b1000; // done

reg [3:0] current_state;
reg [3:0] next_state;


always @(posedge clk or posedge rst) begin //1
    if (rst==1) begin //2
      current_state <= STATE0; 
    end else begin //2
      current_state <= next_state;
    end //2
  end



// Combinational logic: next state logic
always @(*) begin
    case (current_state)
        STATE0: begin
            next_state <= STATE1;
        end
        STATE1: begin // write to RAM
            next_state <= STATE2;
        end
        STATE2: begin // keep writing until mem is full
            //if (addr==10'b1111111111) begin // memory is full
            if (addr==10'd6) begin // just 5 cycles, for simulations
                next_state <= STATE3; 
            end else begin // memory still not full
                next_state <= STATE2; 
            end
        end
        STATE3: begin
            next_state <= STATE3;
        end
        STATE4: begin  // start reading the memory
            next_state <= STATE5;
        end
        STATE5: begin  // start reading the memory
            //if (addr==10'b1111111111) begin // memory is full
            if (addr==10'd6) begin // 5 cycles for simulation
                next_state <= STATE6; 
            end else begin // memory still not full   
            end
            next_state <= STATE5;
        end
        STATE6: begin  // Finished reading the memory
            next_state <= STATE7;
        end
        STATE7: begin  // 
            next_state <= STATE8;
        end
        STATE8: begin  // 
            next_state <= STATE8;
        end
        default: next_state <= STATE8;
    endcase
end


// handling regs which are not combinatorical. 
// Otherwise they would increment many times each cycle
always @(posedge clk or posedge rst) begin
    if (rst) begin
        addr <= 0;
        din  <= 0;
    end else begin
        case (current_state)
            STATE0: begin
                //init = 1;
                we1 = 0;
                we2 = 0;
                we3 = 0;
                rd=0;
                mem_wrd_start = 0;
                mem_wrd_end = 0;
            end
            STATE1: begin
                we1 = 1;
                we2 = 1;
                we3 = 1;
                mem_wrd_start = 1;
            end
            STATE2: begin
                if (addr != 10'd6) begin
                    addr <= addr + 10'b1;
                    din  <= din + 32'b1;
                end
            end
            STATE3: begin
                mem_wrd_start = 0;
                mem_wrd_end = 1;
                we1= 0;
                we2 = 0;
                we3 = 0;
            end
            STATE4: begin
                addr <= 0;
                we1= 0; // although done is previous STATE, Synthesis need it
                //din <= din; // not really needed, but Synthesis looks at it.
                din <= 32'hDEADBEEF;
                // it may cause logic elimination
                mem_wrd_start = 1;
                mem_wrd_end = 0;
                rd=1;
            end
            STATE5: begin
                if (addr != 10'd65)
                    addr <= addr + 10'b1;
            end
            STATE6: begin
                mem_wrd_start = 0;
                mem_wrd_end = 1;
                rd=0;
            end
            STATE7: begin
                we1= 0; // although done is previous STATE, Synthesis need it
                din <= din; // not really needed, but Synthesis looks at it.
                // it may cause logic elimination
            end
            STATE8: begin
                din <= din; // not really needed, but Synthesis looks at it.
                // it may cause logic elimination
            end
        endcase
    end
end




  // Internal memory arrays
  parameter  MEM_IN_SIZE = 2048; // was 1024
  parameter  OPCODE_SIZE = 256;



endmodule