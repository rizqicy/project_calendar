#------------------------------------ [24] - Add Fillers
add_fillers -base_cells $Tech_fill_cell

#------------------------------------ [25] - Metal Fill (Optional)
# add_metal_fill -layers $Tech_Metal_List

#------------------------------------ [26] - Extract RC after Metal fill
extract_rc
# if {[llength [get_db clocks]] > 0} {
    # set_propagated_clock [all_clocks]
# }

set_db timing_analysis_type ocv
# timing_analysis_cppr both; # Cadence recommendation
time_design -post_route

#------------------------------------ [27] - Check Antenna and DRC Violations
check_antenna
check_drc

puts "SAVE DESIGN?"
suspend

source ${scr}/physical/reports_deliverables.tcl