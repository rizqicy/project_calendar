#------------------------------------ [17] - Create clock trees
get_db clock_trees
source ${cons}/cts/${tech_node_used}_cts.ccopt

if {[llength [get_db clocks]] > 0} {
    get_db clock_trees
    create_clock_tree_spec -out_file ${lyt}/${design}_${tech_node_used}/cts.spec
    # ccopt_design
    clock_opt_design 
}    

#delete_clock_tree_spec ;# removes the already loaded cts specification (reset_cts_config)
# look for "CTS constraint violations" in the innovus.log file
# GUI: Viewing clock tree results in the physical view
# select Clock -> CCOpt Clock Tree Debugger -> click OK for default selection in the window

#------------------------------------ [18] - Check timings
# set_db timing_analysis_type best_case_worst_case
# set_db timing_analysis_clock_propagation_mode sdc_control
# time_design -post_cts
# time_design -post_cts -hold

#------------------------------------ [19] - Fix Timings (Iterative if you want)
# opt_design -post_cts -setup;# optimize for setup
# opt_design -post_cts -hold;# optimize for hold