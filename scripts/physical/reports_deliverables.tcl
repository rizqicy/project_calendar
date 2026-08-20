# Deliverables / DRC and LVS Virtuoso
write_netlist ${lyt_folder}/${design}_lyt.v
write_sdf -edge check_edge -map_setuphold merge_always -map_recrem merge_always -version 3.0  ${lyt_folder}/${design}_lyt.sdf
write_stream -mode ALL -unit 2000 ${lyt_folder}/${design}_${tech_node_used}.gds
write_def -floorplan -netlist -routing ${lyt_folder}/${design}_lyt.def

# Power Reports
get_db power_method
set_db power_corner min
report_power -power_unit uW > ${lyt_folder}/reports/${design}_pwr.rpt

# Area Report
report_area > ${lyt_folder}/reports/${design}_area.rpt

# Screenshoot
gui_fit
gui_create_floorplan_snapshot -dir $ROOT/pics/${design}_${tech_node_used}/ -name $design.png -overwrite

# Timing Reports
set_db timing_analysis_precision_ps 1

report_timing -unconstrained > ${lyt_folder}/reports/${design}_timing.rpt
file copy -force ${design}_tns.rpt ${lyt_folder}/reports/${design}_tns.rpt

if {[llength [get_db clocks]] > 0} {
    set_analysis_view -setup analysis_normal_fast_min -hold analysis_normal_fast_min
    set_db timing_analysis_check_type hold
    report_timing > ${lyt_folder}/reports/${design}_hold_f_timing.rpt
    set_db timing_analysis_check_type setup
    report_timing > ${lyt_folder}/reports/${design}_setup_f_timing.rpt

    set_analysis_view -setup analysis_normal_slow_max -hold analysis_normal_slow_max
    set_db timing_analysis_check_type hold
    report_timing > ${lyt_folder}/reports/${design}_hold_s_timing.rpt
    set_db timing_analysis_check_type setup
    report_timing > ${lyt_folder}/reports/${design}_setup_s_timing.rpt
}