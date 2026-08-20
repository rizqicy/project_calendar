# Global Definition
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

if {![file exists ${syn}/${design}_${tech_node_used}]} {
    file mkdir ${syn}/${design}_${tech_node_used}
    set design_first_syn "1"
}

if {![file exists ${lyt}/${design}_${tech_node_used}]} {
    file mkdir ${lyt}/${design}_${tech_node_used}
    set design_first_lyt "1"
}

if {![file exists $ROOT/pics/${design}_${tech_node_used}]} {
    file mkdir $ROOT/pics/${design}_${tech_node_used}
}


set syn_folder ${syn}/${design}_${tech_node_used}
set lyt_folder ${lyt}/${design}_${tech_node_used}

# ---------------------------------- [ Data Preparation ] ----------------------------------
    set TECH_ROOT "/apps/DESIGN_KITS/XFAB_xh018/XKIT/xh018"
    set STD_CELL_ROOT "${TECH_ROOT}/diglibs/D_CELLS_HD/v6_0"
    set LIB_ROOT "${STD_CELL_ROOT}/liberty_LPMOS/v6_0_0/PVT_1_80V_range"
    set LEF_ROOT "${STD_CELL_ROOT}/LEF/v6_0_0"

    # Process
    set Tech_process_node "180"

    # Timing Libraries
    set Tech_fast_lib "$LIB_ROOT/D_CELLS_HD_LPMOS_fast_1_98V_0C.lib"
    set Tech_typ_lib "$LIB_ROOT/D_CELLS_HD_LPMOS_typ_1_80V_25C.lib"
    set Tech_slow_lib "$LIB_ROOT/D_CELLS_HD_LPMOS_slow_1_62V_85C.lib"

    # PVT - Voltage and Temperature
    set Tech_fast_temp "0";  # ℃
    set Tech_typ_temp  "25"; # ℃
    set Tech_slow_temp "85"; # ℃
    set Tech_v_fast "1.98";  # V
    set Tech_v_typ  "1.80";  # V
    set Tech_v_slow "1.62";  # V

    # Physical Libraries
    set Tech_lef_list "${TECH_ROOT}/cadence/v9_0/techLEF/v9_0_1/xh018_xx43_HD_MET4_METMID_METTHK.lef\
        ${LEF_ROOT}/xh018_xx43_MET4_METMID_METTHK_D_CELLS_HD_mprobe.lef\
        ${LEF_ROOT}/xh018_D_CELLS_HD.lef"

    # Extraction
    set qrc_path "${TECH_ROOT}/cadence/v10_1/QRC_assura/v10_1_1/"

    # CTS
    set Tech_cts_file "${scr}/physical/cts/${tech_node_used}_cts.ccopt"

    # Filler Cells
    set Tech_fill_cell "FEED1HD FEED2HD FEED3HD FEED5HD \
        FEED7HD FEED10HD FEED15HD FEED25HD"

    # Metal Stack
    set Tech_Metal_List "MET1 MET2 MET3 MET4"; # All metals
    set Tech_Metal_first "MET1"; # First routing layer
    set Tech_Metal_lastr "MET4"; # Last routing layer

    set Tech_power_ring_v "MET4"; # Power ring Vertical metal
    set Tech_power_ring_h "MET3"; # Power ring Horizontal metal

    set Tech_metal_plimit "MET4"; # Stripes configuration
    set Tech_metal_limit  "MET4"; # Stripes configuration

    set Tech_Metal_pin_h "MET3"; # I/O signals on top or bottom side
    set Tech_Metal_pin_v "MET2"; # I/O signals on left or right side

    # Floorplan / Power
    set Tech_die_especs "1 0.8 15 15 15 15"; #[ (ratio) (density) spacing{left back rigth top})]

    set Tech_PR_width "3"
    set Tech_PR_spacing "3"
    set Tech_PR_offset "3"

    set Tech_power_name  "vdd"
    set Tech_ground_name "gnd"