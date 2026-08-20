set sdc_version     1.5
set out_load        0.045 ;#pF
set clock_period    5 ;# 200MHz
set global_clock_name "i_sck"

set setup_unc [expr {$clock_period * 0.05}]
set hold_unc  [expr {$clock_period * 0.02}]

current_design ${design}

create_clock -domain global_clk -name $global_clock_name -period $clock_period [get_db ports $global_clock_name]

set_clock_uncertainty -setup $setup_unc [get_clocks clk] 
set_clock_uncertainty -hold  $hold_unc [get_clocks clk] 

set_input_delay -clock [get_clocks clk] -add_delay 1.0 \
    [remove_from_collection [all_inputs] [get_ports clk]] set_output_delay 1.5 -clock clk [all_outputs] 

set_load -pin_load ${out_load} [get_ports [all_outputs]]  

# set_ideal_network -no_propagate [get_nets RESET] 
# set_ideal_network -no_propagate [get_nets TEST_ENABLE] 

# Constraints (~/scripts/dont_use.tcl) in a separated file


####################################### MANUAL #######################################
### Skew/uncertainty - (Setup clock uncentatinty to 100 ps / 0,1 ns)
#         set_clock_uncertainty 0.1 clk 
#
### Latency - (Setup latency to 150 ps / 0,15 ns)
#         set_clock_latency 0.15 clk 
#
### Source Latency - (Setup source latency to 150 ps / 0,15 ns)
#         set_clock_latency -source 0.15 clk 
#
### Clock Definition - (Define the clock period 10 picoseconds / 100 MHz)
#         create_clock -period 10 -name clk [get_ports clk]  
#
### Input Delay - 
#         set_input_delay 2.0 -clock clk [all_inputs]
#
### Output Delay - 
#         set_output_delay 1.0 -clock clk [all_outputs]
#
### Ideal Net - 
#         set_ideal_net [get_nets clk]
##         set_ideal_net [get_nets rst]
### Load - 
#         set_load -pin_load 1.0 [get_ports [all_outputs]]
#
### Driver - 
#         set_driving_cell -lib_cell [get_ports[]]