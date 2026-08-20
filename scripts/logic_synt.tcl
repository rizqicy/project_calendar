set scr $env(scr)
source ${scr}/Setup.tcl

gui_show

# set_db auto_ungroup both
set_db auto_ungroup none
set_db tns_opto true

switch $design {
   "exception" {

    }
    default {
      read_hdl -sv ${src}/${design}.sv
    }
}

read_lib $Tech_slow_lib

elaborate

suspend

set_top_module ${design}

if {[file exists $cons/${design}/${design}_${tech_node_used}.sdc]} {
   read_sdc $cons/${design}/${design}_${tech_node_used}.sdc
} else {
   read_sdc $cons/basic_${tech_node_used}.sdc
}

source ${scr}/dont_use.tcl

syn_generic
syn_map

switch $design {
   "trio_counter4buf" {
    }
    default {
      syn_opt
    }
}

set_db timing_analysis_precision_ps 1

report_area >> ${syn_folder}/reports/${design}_area.txt
report_gates >> ${syn_folder}/reports/${design}_gates.txt
report_power -unit uW >> ${syn_folder}/reports/${design}_power.txt
report_timing -unconstrained >> ${syn_folder}/reports/${design}_timeu.txt
report_timing >> ${syn_folder}/reports/${design}_time.txt
write_hdl ${design} > ${syn_folder}/${design}.v
write_sdf -edge check_edge -setuphold merge_always -nonegchecks -recrem split -version 3.0 -design ${design} > ${syn_folder}/${design}.sdf
write_sdc ${design} > ${syn_folder}/${design}.sdc


write_db ${syn_folder}/checkpoint/${design}.enc

gui_sv_load ${design}

gui_snapshot_sv -png ${design} -overwrite

file copy -force ${logs}/genus.log ${syn_folder}/reports/${design}.log
file copy -force $ROOT/work/${design}.png $ROOT/pics/${design}_${tech_node_used}/${design}.png

suspend
exit