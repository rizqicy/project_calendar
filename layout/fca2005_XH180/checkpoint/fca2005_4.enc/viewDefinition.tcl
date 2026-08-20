if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name fast\
   -timing\
    [list ${::IMEX::libVar}/mmmc/D_CELLS_HD_LPMOS_fast_1_98V_0C.lib]
create_library_set -name slow\
   -timing\
    [list ${::IMEX::libVar}/mmmc/D_CELLS_HD_LPMOS_slow_1_62V_85C.lib]
create_library_set -name typ\
   -timing\
    [list ${::IMEX::libVar}/mmmc/D_CELLS_HD_LPMOS_typ_1_80V_25C.lib]
create_opcond -name oc_fast -process 1 -voltage 1.98 -temperature 0
create_opcond -name oc_slow -process 1 -voltage 1.62 -temperature 85
create_opcond -name oc_typ -process 1 -voltage 1.8 -temperature 25
create_timing_condition -name slow_timing\
   -library_sets [list slow]\
   -opcond oc_slow
create_timing_condition -name typ_timing\
   -library_sets [list typ]\
   -opcond oc_typ
create_timing_condition -name fast_timing\
   -library_sets [list fast]\
   -opcond oc_fast
create_rc_corner -name rc_typ\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -temperature 25\
   -qrc_tech ${::IMEX::libVar}/mmmc/rc_typ/qrcTechFile
create_rc_corner -name rc_best\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -temperature 0\
   -qrc_tech ${::IMEX::libVar}/mmmc/rc_best/qrcTechFile
create_rc_corner -name rc_worst\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -temperature 85\
   -qrc_tech ${::IMEX::libVar}/mmmc/rc_worst/qrcTechFile
create_delay_corner -name slow_max\
   -timing_condition {slow_timing}\
   -rc_corner rc_worst
create_delay_corner -name fast_min\
   -timing_condition {fast_timing}\
   -rc_corner rc_best
create_delay_corner -name typ\
   -timing_condition {typ_timing}\
   -rc_corner rc_typ
create_constraint_mode -name basic_constraint\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/basic_constraint/basic_constraint.sdc]
create_analysis_view -name analysis_normal_typ -constraint_mode basic_constraint -delay_corner typ
create_analysis_view -name analysis_normal_fast_min -constraint_mode basic_constraint -delay_corner fast_min -latency_file ${::IMEX::dataVar}/mmmc/views/analysis_normal_fast_min/latency.sdc
create_analysis_view -name analysis_normal_slow_max -constraint_mode basic_constraint -delay_corner slow_max -latency_file ${::IMEX::dataVar}/mmmc/views/analysis_normal_slow_max/latency.sdc
set_analysis_view -setup [list analysis_normal_slow_max] -hold [list analysis_normal_fast_min]
