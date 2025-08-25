# prevents autoloading of TB file after opening the waveform
quietly set PrefMain(autoOpenFile) 0

# Create and map the default working library
vlib work
vmap work work

# Create and map Intel FPGA simulation libraries
vlib altera_mf
vmap altera_mf altera_mf
vlog -work altera_mf "C:/intelFPGA_lite/23.1std/quartus/eda/sim_lib/altera_mf.v"



#vlib altera_lnsim
#vmap altera_lnsim "C:/intelFPGA/23.1std/quartus/eda/sim_lib/altera_lnsim"

# Compile design files
vlog C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/Synthesis/mem1.v
vlog C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL/memories.v
vlog C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL/PE_FPGA_top.v

# Compile your testbench
vlog C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/Testbench/PE2526_tb.v

# Launch simulation with the top-level testbench
vsim -L altera_mf -L altera_lnsim work.PE2526_tb
#vsim work.PE2526_tb

# Optional: Add waveforms
# add wave -r *
add wave -label clk sim:/PE2526_tb/clk
#add wave -label key sim:/PE2526_tb/key
add wave -label reset sim:/PE2526_tb/DUT/reset
#add wave -radix hex -label current_state sim:/PE2526_tb/DUT/memories/current_state
#add wave -radix hex -label next_state sim:/PE2526_tb/DUT/memories/next_state
#add wave -radix hex -label addr sim:/PE2526_tb/DUT/memories/addr
#add wave -radix hex -label din sim:/PE2526_tb/DUT/memories/din
#add wave -radix hex -label dout sim:/PE2526_tb/DUT/memories/dout1
#add wave -radix bin -label we sim:/PE2526_tb/DUT/memories/we1
#add wave -radix bin -label init sim:/PE2526_tb/DUT/memories/init
add wave -radix hex -label state sim:/PE2526_tb/DUT/main_ctrl/uart_ctrl/state
add wave -radix hex -label next_state sim:/PE2526_tb/DUT/main_ctrl/uart_ctrl/next_state
add wave -radix hex -label num_of_bytes sim:/PE2526_tb/DUT/main_ctrl/uart_ctrl/num_of_bytes
add wave -radix hex -label tx_data sim:/PE2526_tb/DUT/main_ctrl/uart_ctrl/tx_data
add wave -radix bin -label tx_busy sim:/PE2526_tb/DUT/main_ctrl/uart_ctrl/tx_busy
add wave -radix hex -label tx_data sim:/PE2526_tb/DUT/uart/tx_data
add wave -radix bin -label tx_start sim:/PE2526_tb/DUT/uart/tx_start
add wave -radix bin -label tx_busy sim:/PE2526_tb/DUT/uart/tx_busy
add wave -radix hex -label shift_reg sim:/PE2526_tb/DUT/uart/tx/shift_reg
add wave -radix hex -label bit_index sim:/PE2526_tb/DUT/uart/tx/bit_index
add wave -radix bin -label busy  sim:/PE2526_tb/DUT/uart/tx/busy 
add wave -radix bin -label tx sim:/PE2526_tb/DUT/uart/tx/tx





# Run simulation
run -all

wave zoom full
wave position 0
view wave
