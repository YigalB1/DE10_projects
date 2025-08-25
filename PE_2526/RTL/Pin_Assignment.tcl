# Quartus Pin Assignment Script
# Author: Yigal
# Date: 2025-08-22

#  source C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL/Pin_Assignment.tcl

# 
# UART TX,RX mapped to GPIO header
#set_location_assignment PIN_V10 -to oTx_Serial
#set_location_assignment PIN_V9  -to iRx_serial
set_location_assignment PIN_W7  -to iRx_serial
set_location_assignment PIN_V5 -to oTx_Serial

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to iRx_serial
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to oTx_Serial
# Quartus assign default, yet it is better to guide it
# options: 4,8,12,16mA
set_instance_assignment -name CURRENT_STRENGTH_NEW "8mA" -to oTx_Serial 



# Clock and Reset
# Connect rst to KEY[0] button
set_location_assignment PIN_AA19 -to rst
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rst

# xor_tot is a dummy signal to avoid synthesis logic drop.
# will be deleted later on
set_location_assignment PIN_AB3 -to xor_tot
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to xor_tot

# clk_1hz is used to show board is alive
set_location_assignment PIN_AB2 -to clk_1hz
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk_1hz


# Control Signals

#leds

# Address Bus (10 bits for 1024 lines)
#foreach i {0 1 2 3 4 5 6 7 8 9} {
 #   set_location_assignment PIN_E[i] -to addr[$i]
#}


# Set I/O standard for all pins

