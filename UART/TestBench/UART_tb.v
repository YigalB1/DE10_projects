`timescale 1ns/1ns



module UART_tb ();

reg clk_tb;
reg [1:0] key;



initial begin
 $display ("Starting TB ");


clk_tb=0;
key=2'b00;

 // *** Asserting RESET by pressing Key ***
 #20;
key[0]=1;
 #20;
key[0]=0;
 #20;


#100000;




$finish;



end  // of initial begin()



// ***** global settings *************** 
always begin
#5;
clk_tb=~clk_tb;
end


UART_top DUT(clk_tb,key);




endmodule
