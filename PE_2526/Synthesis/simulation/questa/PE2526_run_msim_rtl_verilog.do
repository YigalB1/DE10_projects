transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL {C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL/memories.v}
vlog -vlog01compat -work work +incdir+C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL {C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL/tx_repeater.v}
vlog -vlog01compat -work work +incdir+C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL/UART {C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL/UART/uart_rx.v}
vlog -vlog01compat -work work +incdir+C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL/UART {C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL/UART/UART.v}
vlog -vlog01compat -work work +incdir+C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL/UART {C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL/UART/uart_tx.v}
vlog -vlog01compat -work work +incdir+C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL {C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL/PE_FPGA_top.v}
vlog -vlog01compat -work work +incdir+C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL {C:/Users/DNLD/Documents/Projects/DE10_projects/PE_2526/RTL/control.v}

