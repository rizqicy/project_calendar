#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Thu Aug 20 17:44:03 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v25.10-p002_1 (64bit) 04/23/2025 12:43 (Linux 4.18.0-305.el8.x86_64)
#@(#)CDS: NanoRoute 25.10-p002_1 NR250317-0405/25_10-UB (database version 18.20.663) {superthreading v2.20}
#@(#)CDS: AAE 25.10-b008 (64bit) 04/23/2025 (Linux 4.18.0-305.el8.x86_64)
#@(#)CDS: CTE 25.10-b014_1 () Mar 28 2025 03:11:49 ( )
#@(#)CDS: SYNTECH 25.10-b006_1 () Mar 13 2025 03:32:26 ( )
#@(#)CDS: CPE v25.10-b011
#@(#)CDS: IQuantus/TQuantus 24.1.0-s201 (64bit) Thu Mar 20 10:21:58 PDT 2025 (Linux 4.18.0-305.el8.x86_64)

#@ source /home/edu4chip_18/project_calendar/scripts/phy_synt.tcl
#@ Begin verbose source (pre): source /home/edu4chip_18/project_calendar/scripts/phy_synt.tcl
set scr $env(scr)
#@ source $scr/Setup.tcl
#@ Begin verbose source /home/edu4chip_18/project_calendar/scripts/Setup.tcl (pre)
set ROOT $env(ROOT)
set cons $env(cons)
set lyt $env(lyt)
set lib $env(lib)
set logs $env(logs)
set src $env(src)
set syn $env(syn)
set design $env(design)
set tech_node_used $env(tech_node_used)
set design_first_syn "0"
set design_first_lyt "0"
if {![file exists ${syn}/${design}_${tech_node_used}]} {...}
if {![file exists ${lyt}/${design}_${tech_node_used}]} {...}
if {![file exists $ROOT/pics/${design}_${tech_node_used}]} {...}
set syn_folder ${syn}/${design}_${tech_node_used}
set lyt_folder ${lyt}/${design}_${tech_node_used}
set TECH_ROOT "/apps/DESIGN_KITS/XFAB_xh018/XKIT/xh018"
set STD_CELL_ROOT "${TECH_ROOT}/diglibs/D_CELLS_HD/v6_0"
set LIB_ROOT "${STD_CELL_ROOT}/liberty_LPMOS/v6_0_0/PVT_1_80V_range"
set LEF_ROOT "${STD_CELL_ROOT}/LEF/v6_0_0"
set Tech_process_node "180"
set Tech_fast_lib "$LIB_ROOT/D_CELLS_HD_LPMOS_fast_1_98V_0C.lib"
set Tech_typ_lib "$LIB_ROOT/D_CELLS_HD_LPMOS_typ_1_80V_25C.lib"
set Tech_slow_lib "$LIB_ROOT/D_CELLS_HD_LPMOS_slow_1_62V_85C.lib"
set Tech_fast_temp "0";
set Tech_typ_temp  "25";
set Tech_slow_temp "85";
set Tech_v_fast "1.98";
set Tech_v_typ  "1.80";
set Tech_v_slow "1.62";
set Tech_lef_list "${TECH_ROOT}/cadence/v9_0/techLEF/v9_0_1/xh018_xx43_HD_MET4_METMID_METTHK.lef\
        ${LEF_ROOT}/xh018_xx43_MET4_METMID_METTHK_D_CELLS_HD_mprobe.lef\
        ${LEF_ROOT}/xh018_D_CELLS_HD.lef"
set qrc_path "${TECH_ROOT}/cadence/v10_1/QRC_assura/v10_1_1/"
set Tech_cts_file "${scr}/physical/cts/${tech_node_used}_cts.ccopt"
set Tech_fill_cell "FEED1HD FEED2HD FEED3HD FEED5HD \
        FEED7HD FEED10HD FEED15HD FEED25HD"
set Tech_Metal_List "MET1 MET2 MET3 MET4";
set Tech_Metal_first "MET1";
set Tech_Metal_lastr "MET4";
set Tech_power_ring_v "MET4";
set Tech_power_ring_h "MET3";
set Tech_metal_plimit "MET4";
set Tech_metal_limit  "MET4";
set Tech_Metal_pin_h "MET3";
set Tech_Metal_pin_v "MET2";
set Tech_die_especs "1 0.8 15 15 15 15";
set Tech_PR_width "3"
set Tech_PR_spacing "3"
set Tech_PR_offset "3"
set Tech_power_name  "vdd"
set Tech_ground_name "gnd"
#@ End verbose source /home/edu4chip_18/project_calendar/scripts/Setup.tcl
#@ source $scr/physical/1_DesignInit.tcl
#@ Begin verbose source /home/edu4chip_18/project_calendar/scripts/physical/1_DesignInit.tcl (pre)
set_db init_power_nets $Tech_power_name
set_db init_ground_nets $Tech_ground_name
if {[file exists $cons/${design}/${design}_${tech_node_used}.view]} {...
} else {
read_mmmc $cons/basic_${tech_node_used}.view
#@ Begin verbose source /home/edu4chip_18/project_calendar/constraints/basic_XH180.view (pre)
create_library_set -name fast -timing $Tech_fast_lib
create_library_set -name typ -timing $Tech_typ_lib
create_library_set -name slow -timing $Tech_slow_lib
create_rc_corner -name rc_best -qrc_tech ${qrc_path}/XH018_1143/QRC-Min/qrcTechFile -temp ${Tech_fast_temp}
create_rc_corner -name rc_typ -qrc_tech ${qrc_path}/XH018_1143/QRC-Typ/qrcTechFile -temp ${Tech_typ_temp}
create_rc_corner -name rc_worst -qrc_tech ${qrc_path}/XH018_1143/QRC-Max/qrcTechFile -temp ${Tech_slow_temp}
create_opcond -name oc_fast -process {1.0} -voltage ${Tech_v_fast} -temperature ${Tech_fast_temp}
create_opcond -name oc_typ  -process {1.0} -voltage ${Tech_v_typ}  -temperature ${Tech_typ_temp}
create_opcond -name oc_slow -process {1.0} -voltage ${Tech_v_slow} -temperature ${Tech_slow_temp}
create_timing_condition -name fast_timing -library_sets [list fast] -opcond oc_fast
create_timing_condition -name typ_timing -library_sets [list typ] -opcond oc_typ
create_timing_condition -name slow_timing -library_sets [list slow] -opcond oc_slow
create_delay_corner -name fast_min -timing_condition fast_timing -rc_corner rc_best
create_delay_corner -name typ      -timing_condition typ_timing  -rc_corner rc_typ
create_delay_corner -name slow_max -timing_condition slow_timing -rc_corner rc_worst
create_constraint_mode -name basic_constraint -sdc_files ${cons}/basic_${tech_node_used}.sdc
create_analysis_view -name analysis_normal_fast_min -constraint_mode {basic_constraint} -delay_corner fast_min
create_analysis_view -name analysis_normal_typ -constraint_mode {basic_constraint} -delay_corner typ
create_analysis_view -name analysis_normal_slow_max -constraint_mode {basic_constraint} -delay_corner slow_max
set_analysis_view -setup [list analysis_normal_slow_max] -hold [list analysis_normal_fast_min]
#@ End verbose source /home/edu4chip_18/project_calendar/constraints/basic_XH180.view
}
switch {top} {
read_physical -lefs $Tech_lef_list
}
switch {top} {
read_netlist $syn/${design}_${tech_node_used}/$design.v
}
init_design
switch {top} {
connect_global_net $Tech_power_name -type pg_pin -pin_base_name $Tech_power_name -inst_base_name *
connect_global_net $Tech_ground_name -type pg_pin -pin_base_name $Tech_ground_name -inst_base_name *
}
set_db design_process_node $Tech_process_node
switch {top} {
create_floorplan -core_density_size ${Tech_die_especs}
}
set_db add_rings_avoid_short 1
switch {top} {
add_rings -type core_rings -follow core  -nets "$Tech_power_name $Tech_ground_name" -width $Tech_PR_width -spacing $Tech_PR_spacing -offset $Tech_PR_offset  -layer [list  bottom $Tech_power_ring_h  top    $Tech_power_ring_h  right  $Tech_power_ring_v  left   $Tech_power_ring_v]
}
switch {top} {
add_stripes  -block_ring_top_layer_limit $Tech_metal_limit  -max_same_layer_jog_length 0.44  -set_to_set_distance 7  -pad_core_ring_top_layer_limit $Tech_metal_limit  -spacing 0.4  -layer $Tech_metal_plimit  -width 0.28  -start_offset 1  -nets "$Tech_power_name $Tech_ground_name"   
}
switch {top} {
route_special -layer_change_range [list $Tech_Metal_first $Tech_Metal_lastr] -block_pin_target nearest_target -allow_jogging 1  -crossover_via_layer_range [list $Tech_Metal_first $Tech_Metal_lastr]  -nets "$Tech_power_name $Tech_ground_name" -allow_layer_change 1  -target_via_layer_range [list $Tech_Metal_first $Tech_Metal_lastr]
}
if {[file exists $scr/pins/${design}_pin.tcl]} {...
} else {
set_db place_global_place_io_pins 1
}
#@ End verbose source /home/edu4chip_18/project_calendar/scripts/physical/1_DesignInit.tcl
suspend
gui_open
gui_show
resume
write_db ${lyt_folder}/checkpoint/${design}_1.enc
#@ source $scr/physical/2_PreCTS.tcl
#@ Begin verbose source /home/edu4chip_18/project_calendar/scripts/physical/2_PreCTS.tcl (pre)
place_design
extract_rc
opt_design -pre_cts
#@ End verbose source /home/edu4chip_18/project_calendar/scripts/physical/2_PreCTS.tcl
write_db ${lyt_folder}/checkpoint/${design}_2.enc
#@ source $scr/physical/3_PostCTS.tcl
#@ Begin verbose source /home/edu4chip_18/project_calendar/scripts/physical/3_PostCTS.tcl (pre)
get_db clock_trees
#@ source ${cons}/cts/${tech_node_used}_cts.ccopt
#@ Begin verbose source /home/edu4chip_18/project_calendar/constraints/cts/XH180_cts.ccopt (pre)
get_db cts_buffer_cells;
set BUFFERS_CTS "BUHDX1 BUHDX2 BUHDX3 BUHDX4 BUHDX6 BUHDX8"
set_db cts_buffer_cells $BUFFERS_CTS ;
get_db cts_buffer_cells;
get_db cts_inverter_cells;
set INVERTERS_CTS "INHDX1 INHDX2 INHDX3 INHDX4 INHDX6 INHDX8"
set_db cts_inverter_cells $INVERTERS_CTS ;
get_db cts_inverter_cells;
get_db cts_delay_cells;
set DELAY_CELLS ""
set_db cts_delay_cells $DELAY_CELLS
get_db cts_delay_cells;
#@ End verbose source /home/edu4chip_18/project_calendar/constraints/cts/XH180_cts.ccopt
if {[llength [get_db clocks]] > 0} {...}
#@ End verbose source /home/edu4chip_18/project_calendar/scripts/physical/3_PostCTS.tcl
write_db ${lyt_folder}/checkpoint/${design}_3.enc
#@ source $scr/physical/4_PostRoute.tcl
#@ Begin verbose source /home/edu4chip_18/project_calendar/scripts/physical/4_PostRoute.tcl (pre)
route_design
check_drc
set_db extract_rc_engine post_route
extract_rc
set_db timing_analysis_type ocv
time_design -post_route >> ${design}_tns.rpt
opt_design -post_route -setup
opt_design -post_route -hold
time_design -post_route 
#@ End verbose source /home/edu4chip_18/project_calendar/scripts/physical/4_PostRoute.tcl
write_db ${lyt_folder}/checkpoint/${design}_4.enc
#@ source $scr/physical/5_Signoff.tcl
#@ Begin verbose source /home/edu4chip_18/project_calendar/scripts/physical/5_Signoff.tcl (pre)
add_fillers -base_cells $Tech_fill_cell
extract_rc
set_db timing_analysis_type ocv
time_design -post_route
check_antenna
check_drc
puts "SAVE DESIGN?"
suspend
resume
#@ source ${scr}/physical/reports_deliverables.tc
#@ Begin verbose source /home/edu4chip_18/project_calendar/scripts/physical/reports_deliverables.tcl (pre)
write_netlist ${lyt_folder}/${design}_lyt.v
write_sdf -edge check_edge -map_setuphold merge_always -map_recrem merge_always -version 3.0  ${lyt_folder}/${design}_lyt.sdf
write_stream -mode ALL -unit 2000 ${lyt_folder}/${design}_${tech_node_used}.gds
write_def -floorplan -netlist -routing ${lyt_folder}/${design}_lyt.def
get_db power_method
set_db power_corner min
report_power -power_unit uW > ${lyt_folder}/reports/${design}_pwr.rpt
report_area > ${lyt_folder}/reports/${design}_area.rpt
gui_fit
gui_create_floorplan_snapshot -dir $ROOT/pics/${design}_${tech_node_used}/ -name $design.png -overwrite
set_db timing_analysis_precision_ps 1
report_timing -unconstrained > ${lyt_folder}/reports/${design}_timing.rpt
file copy -force ${design}_tns.rpt ${lyt_folder}/reports/${design}_tns.rpt
if {[llength [get_db clocks]] > 0} {...}
#@ End verbose source /home/edu4chip_18/project_calendar/scripts/physical/reports_deliverables.tcl
#@ End verbose source /home/edu4chip_18/project_calendar/scripts/physical/5_Signoff.tcl
write_db ${lyt_folder}/checkpoint/${design}_5.enc
puts "Design Finished and saved!"
file copy -force ../logs/innovus.log ../layout/${design}_${tech_node_used}/reports/${design}_${tech_node_used}.log
exit
