module memory_block (
  input        clk,
  input rst,
  output [31:0] memA_out,
  output [31:0] memB_out,
  output [7:0]  memC_out

//  input [31:0] data_in,

//  input        wr_en_A,
//  input        wr_en_B,
//  input        wr_en_C,

//  input [8:0]  addr_A,  // 9 bits for 0–499
//  input [8:0]  addr_B,  // 9 bits for 0–499
//  input [6:0]  addr_C,  // 7 bits for 0–99

// output  [31:0] memA [0:499],
//  output  [31:0] memB [0:499],
//  output  [7:0]  memC [0:99]
);


reg [9:0] addr;
reg [31:0] din;
//reg [0:31] dout;
reg [31:0] dout_s;
reg we;
reg init;
wire [31:0] dout;

/*
mem1 u0 (
        .clock(clk),
        .wren(we),
        .address(addr),
        .data(din),
        .q(dout)
    );
    */

// State machine
// Define state encoding
parameter STATE0   = 3'b000; // start
parameter STATE1   = 3'b001; // write
parameter STATE2   = 3'b010; // wait
parameter STATE3   = 3'b011; // done
parameter STATE4   = 3'b100; // done
parameter STATE5   = 3'b101; // done
parameter STATE6   = 3'b110; // done

reg [2:0] current_state, next_state;


always @(posedge clk or posedge rst) begin //1
    if (rst) begin //2
      current_state = STATE0; 
    end else begin //2
      current_state = next_state;
    end //2
  end

reg mem_wrd_start;
reg mem_wrd_end;

// Combinational logic: next state logic
always @(*) begin
    case (current_state)
        STATE0: begin
            addr = 0;
            din  =  0;
            init = 1;
            we = 0;
            mem_wrd_start = 0;
            mem_wrd_end = 0;
            next_state = STATE1; ;
        end
        STATE1: begin // write to RAM
            we = 1;
            mem_wrd_start = 1;
            din = addr;
            next_state = STATE2;
        end
        STATE2: begin // keep writing until mem is full
            if (addr==10'b1111111111) begin // memory is full
                next_state = STATE3; 
            end else begin // memory still not full
                addr = addr+1;
                dout_s = dout;
                next_state = STATE2; 
            end
        end
        STATE3: begin
            mem_wrd_start = 0;
            mem_wrd_end = 1;
            next_state = STATE3;
        end
        STATE4: begin  // start reading the memory
            mem_wrd_start = 1;
            mem_wrd_end = 0;
            addr = 0;
            next_state = STATE5;
        end
        STATE5: begin  // start reading the memory
            if (addr==10'b1111111111) begin // memory is full
                next_state = STATE3; 
            end else begin // memory still not full
                addr = addr+1;
            end
            next_state = STATE5;
        end
        STATE6: begin  // start reading the memory
            mem_wrd_start = 1;
            mem_wrd_end = 0;
            next_state = STATE5;
        end
        default: next_state = STATE3;
    endcase
end


always @(posedge clk ) begin //1
dout_s = dout;
  end






/*

 always @(posedge clk or posedge rst) begin //1
    if (rst) begin //2
      addr <= 0;
      din  <=  0;
      init <= 1;
    end else begin //2
        if (init) begin
            integer i;
            for (i = 0; i < 1024; i = i + 1) begin
                mem1[i] = i;  // Truncate if i exceeds DATA_WIDTH
        end
        init=0;
        end else begin
            dout_s = dout;
            addr = addr+1;
        end
      dout_s=dount;
    end //2
  end


*/



  // Internal memory arrays
  parameter  MEM_IN_SIZE = 2048; // was 1024
  parameter  OPCODE_SIZE = 256;






/*
  //(* ramstyle = "M9K" *) reg [31:0] memA [0:MEM_IN_SIZE-1];
  reg [31:0] memA [0:MEM_IN_SIZE-1];
  reg [31:0] memA_s ;
  always @(posedge clk) begin
    memA_s = memA[0]; 
  end


  reg [31:0] memB [0:MEM_IN_SIZE-1];
  reg [7:0]  memC [0:OPCODE_SIZE-1];




reg [31:0] memB_s ;
reg [ 7:0] memC_s ;

 always @(posedge clk) begin //1
	//	memA_s<=memA[0];
        memB_s<=memB[1];
        memC_s<=memC[2];		
  end

    assign memA_out = memA_s;
    assign memB_out = memB_s;
    assign memC_out = memC_s;
    */

/*
  // Assign internal memory to outputs
  genvar i;
  generate
    for (i = 0; i < 500; i = i + 1) begin : assign_inA
      assign memA[i] = i;
      assign memB[i] = i;
    end
  endgenerate

  generate
    for (i = 0; i < 100; i = i + 1) begin : assign_memC
      assign memC[i] = i;
    end
  endgenerate
*/


/*
  // Write logic
  always @(posedge clk) begin
    if (wr_en_A && addr_A < 500)
      inA[addr_A] <= data_in;

    if (wr_en_B && addr_B < 500)
      inB[addr_B] <= data_in;

    if (wr_en_C && addr_C < 100)
      memC[addr_C] <= data_in[7:0];  // Only lower 8 bits used
  end
*/

endmodule