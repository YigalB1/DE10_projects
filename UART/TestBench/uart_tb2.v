// used for simulation towards host usage
// host is sending a byte, which is recieved
// then triggerring send back to host


`timescale 1ns/1ns

module UART_tb2 ();
reg clk_tb;
reg [1:0] key;
wire [9:0] ledr;
reg iRx_serial;
wire o_Tx_Serial;

UART_top DUT(clk_tb,key,ledr,iRx_serial,o_Tx_Serial);

// Set thye clock
always begin
#5;
clk_tb=~clk_tb;
end


always @(posedge clk_tb) begin
    if (DUT.o_Tx_Done) begin
        $display ("[$display] time=%0t TX_done=%b i_Tx_Byte=%h", $time, DUT.o_Tx_Done, DUT.i_Tx_Byte);
    end

    if (DUT.Rx_valid) begin
        $display ("[$display] time=%0t Rx_valid=%b rx_data=%h", $time, DUT.Rx_valid, DUT.rx_data);
    end
end


initial begin


    //$monitor ("[$monitor] time=%0t o_Tx_Done=%b i_Tx_Byte=0x%0h reset=%b", $time, DUT.o_Tx_Done,DUT.i_Tx_Byte,DUT.reset);
    


    $display ("Starting TB ");
    clk_tb=0;
    key[1]=0;
    #10;
    
    // check led & key[1]
    key[1]=1;
    #10;
    key[1]=0;
    #10;


    



    // *** Asserting RESET by pressing Key ***
    key[0]=1; // active low
    #20;
    key[0]=0;
    #20;
    key[0]=1;
    #20;

    // simulating the byte recieved 
    force DUT.Rx_valid =1;
    force DUT.rx_data=55;
    #20;
    release DUT.Rx_valid;
    release DUT.rx_data;


  #100000;
  #100000;
  #1000000


    $stop;
    //$finish;
end  // of initial begin()





endmodule
