`timescale 1ns / 1ps

module PE2526_tb();

// FPGA IOs signals
reg [1:0] key;
wire [9:0] ledr;
wire iRx_serial;
wire oTx_Serial;
wire clk_1hz;
wire xor_tot;


  // Testbench signals
  reg clk;
  //reg rst;
  wire [31:0] memA_out;
  wire [31:0] memB_out;
  wire [7:0]  memC_out;

PE_FPGA_top DUT(clk,key,ledr,iRx_serial,oTx_Serial,clk_1hz,xor_tot);

/*
  // Instantiate the DUT (Device Under Test)
  memory_block uut (
    .clk(clk),
    .rst(rst),
    .memA_out(memA_out),
    .memB_out(memB_out),
    .memC_out(memC_out)
  );
*/
  // Clock generation: 10ns period (100MHz)
  initial clk = 0;
    always #5 clk = ~clk;


   

  // Test sequence
  initial begin
     //  later on this should be eliminated
    // because the reset will clean this signal
    //DUT.tx_start = 0;

    key[0] = 1; // Key generats the reset. 1 is not pressed, no reset
    key[1] = 0; // not really needed
    repeat (2) @(posedge clk);
    // Initialize reset
    key[0] = 0;
    // Hold reset for 10 cycles
    repeat (5) @(posedge clk);
    // Deassert reset
    key[0] = 1;

    
    // Run for 100 more cycles
    repeat (100000) @(posedge clk);

  // send 1 byte out of UART tx
    //..DUT.tx_data = 8'b10101010;
    //DUT.tx_start = 0;
    //repeat (1) @(posedge clk);
    //DUT.tx_start = 1;
    //repeat (1) @(posedge clk);
    //DUT.tx_start = 0;
    //repeat (1) @(posedge clk);

    //repeat (100) @(posedge clk);


    // Finish simulation
    $stop;
    $finish;
  end

endmodule