# prevents autoloading of TB file after opening the waveform
quietly set PrefMain(autoOpenFile) 0

# Create and map the default working library
vlib work
vmap work work

set MsgMode verbose
set DisplayMsgMode both


# Compile design files
##vlog C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/Synthesis/mem1.v

# Compile your testbench
##vlog C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/Testbench/PE2526_tb.v

project compileall


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
add wave -radix hex -label state sim:/PE2526_tb/DUT/control_top/uart_tst/state
add wave -radix hex -label next_state sim:/PE2526_tb/DUT/control_top/uart_tst/next_state

add wave -radix bin -label tx_busy      sim:/PE2526_tb/DUT/control_top/uart_tst/tx_busy
add wave -radix bin -label rx_ready     sim:/PE2526_tb/DUT/control_top/uart_tst/rx_ready
add wave -radix hex -label data_to_tx   sim:/PE2526_tb/DUT/control_top/uart_tst/data_to_tx
add wave -radix hex -label tx_data      sim:/PE2526_tb/DUT/control_top/uart_tst/tx_data
add wave -radix hex -label tx_start sim:/PE2526_tb/DUT/control_top/uart_tst/tx_start

add wave -radix bin -label rx_ready_flag sim:/PE2526_tb/DUT/control_top/uart_tst/rx_ready_flag
add wave -radix bin -label rx         sim:/PE2526_tb/DUT/uart_top/rx/rx
add wave -radix bin -label tx         sim:/PE2526_tb/DUT/uart_top/tx/tx
add wave -radix bin -label receiving  sim:/PE2526_tb/DUT/uart_top/rx/receiving
add wave -radix hex -label rx_data sim:/PE2526_tb/DUT/control_top/uart_tst/rx_data
add wave -radix bin -label data_ready sim:/PE2526_tb/DUT/uart_top/rx/data_ready

#add wave -radix hex -label tx sim:/PE2526_tb/DUT/oTx_Serial
#add wave -radix hex -label rx_in sim:/PE2526_tb/DUT/rx_in
#add wave -radix hex -label rx_sync    sim:/PE2526_tb/DUT/uart_top/rx/rx_sync
#add wave -radix hex -label rx_prev    sim:/PE2526_tb/DUT/uart_top/rx/rx_prev
#add wave -radix bin -label data_ready_next sim:/PE2526_tb/DUT/uart_top/rx/data_ready_next
#add wave -radix hex -label baud_counter  sim:/PE2526_tb/DUT/uart_top/rx/baud_counter
#add wave -radix hex -label bit_index  sim:/PE2526_tb/DUT/uart_top/rx/bit_index
#add wave -radix bin -label rx_sync  sim:/PE2526_tb/DUT/uart_top/rx/rx_sync
#add wave -radix hex -label rx_shift  sim:/PE2526_tb/DUT/uart_top/rx/rx_shift


# Run simulation
#run 100
run -all

wave zoom full
wave position 0
view wave
