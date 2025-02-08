`timescale 1ns/1ns



module seven_seg_tb();

    reg clk_tb;
    reg [9:0] sw_tb;       // 10 switches
    wire [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5; // out to 7 Segments


//integer i; // for the for loop()


initial begin
 $display ("Starting TB ");


clk_tb=0; // init clock value
sw_tb=10'b0000000000;
 #20;

sw_tb=10'b0000000001;
 #20;
sw_tb=10'b0000000010;
 #20;
sw_tb=10'b0000000100;
 #20;
sw_tb=10'b0000001000;
 #20;
sw_tb=10'b0000010000;
 #20;
sw_tb=10'b0000100000;
 #20;
sw_tb=10'b0010000000;
 #20;
sw_tb=10'b0100000000;
 #20;



 $finish; 

end  // of initial begin()



// ***** global settings *************** 
always begin
#5;
clk_tb=~clk_tb;
end


   seven_seg_top DUT(clk_tb,sw_tb,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);




endmodule
