#------------------------------------ [01] - Naming Power domain
set_db init_power_nets $Tech_power_name
set_db init_ground_nets $Tech_ground_name
#------------------------------------ [02] - Constraints config w/ MultiMode MultiCorner
if {[file exists $cons/${design}/${design}_${tech_node_used}.view]} {
   read_mmmc $cons/${design}/${design}_${tech_node_used}.view
} else {
   read_mmmc $cons/basic_${tech_node_used}.view
}

#------------------------------------ [03] - Read PDK Physical information
switch $design {
   "exception" {
   }
   default {
      read_physical -lefs $Tech_lef_list
   }
}

#------------------------------------ [04] - Read Netlist
switch $design {
   "exception" {
   }
   default {
      read_netlist $syn/${design}_${tech_node_used}/$design.v
   }
}
#------------------------------------ [05] - Init design
init_design
#------------------------------------ [06] - Connect Power domain nets
switch $design {
   "exception" {
   }
   default {
      connect_global_net $Tech_power_name -type pg_pin -pin_base_name $Tech_power_name -inst_base_name *
      connect_global_net $Tech_ground_name -type pg_pin -pin_base_name $Tech_ground_name -inst_base_name *
   }
}
#------------------------------------ [07] - Set Process node
set_db design_process_node $Tech_process_node
#------------------------------------ [08] - Create Floorplan
switch $design {
   "exception" {
   }
   "trio_dm16" {
      create_floorplan -core_density_size {4 0.9 5 5 5 5}
   }
   "trio_counter4" {
      create_floorplan -core_density_size {1 0.5 15 15 15 15}
   }
   "edu4chip_spi" {
      create_floorplan -core_density_size {0.25 0.8 15 15 15 15}
   }
   "edu4chip_alu" {
      create_floorplan -core_density_size {2 0.5 15 15 15 15}
   }
   "demux_3x8" {
      create_floorplan -core_density_size {4 0.9 5 5 5 5}
   }
   default {
      create_floorplan -core_density_size ${Tech_die_especs}
   }
}

#------------------------------------ [09] - Create Power Ring
# set_db add_rings_skip_shared_inner_ring none
set_db add_rings_avoid_short 1
# set_db add_rings_ignore_rows 0
# set_db add_rings_extend_over_row 0

switch $design {
   "trio_dm16" {
      add_rings -type core_rings -follow core \
      -nets "$Tech_power_name $Tech_ground_name" -width 0.8 -spacing 0.8 -offset 0.8 \
      -layer [list \
         bottom $Tech_power_ring_h \
         top    $Tech_power_ring_h \
         right  $Tech_power_ring_v \
         left   $Tech_power_ring_v]
   }
   "demux_3x8" {
      add_rings -type core_rings -follow core \
      -nets "$Tech_power_name $Tech_ground_name" -width 0.8 -spacing 0.8 -offset 0.8 \
      -layer [list \
         bottom $Tech_power_ring_h \
         top    $Tech_power_ring_h \
         right  $Tech_power_ring_v \
         left   $Tech_power_ring_v]
   }
   default {
      add_rings -type core_rings -follow core \
      -nets "$Tech_power_name $Tech_ground_name" -width $Tech_PR_width -spacing $Tech_PR_spacing -offset $Tech_PR_offset \
      -layer [list \
         bottom $Tech_power_ring_h \
         top    $Tech_power_ring_h \
         right  $Tech_power_ring_v \
         left   $Tech_power_ring_v]
   }
}

#------------------------------------ [10] - Add Power Stripes
switch $design {
	"exception" {
	}
	"trio_dm16" {
	}
	"trio_counter4" {
	}
	"edu4chip_halfadder" {
	}
	"edu4chip_spi" {
	}
	"edu4chip_ula" {
	}
	"demux_3x8" {
	}
	default {
	add_stripes \
      -block_ring_top_layer_limit $Tech_metal_limit \
      -max_same_layer_jog_length 0.44 \
      -set_to_set_distance 7 \
      -pad_core_ring_top_layer_limit $Tech_metal_limit \
      -spacing 0.4 \
      -layer $Tech_metal_plimit \
      -width 0.28 \
      -start_offset 1 \
      -nets "$Tech_power_name $Tech_ground_name"   
   }
}

#------------------------------------ [11] - Route Power and Ground nets
switch $design {
  "exception" {
  }
	default {
      route_special -layer_change_range [list $Tech_Metal_first $Tech_Metal_lastr]\
         -block_pin_target nearest_target -allow_jogging 1 \
         -crossover_via_layer_range [list $Tech_Metal_first $Tech_Metal_lastr] \
         -nets "$Tech_power_name $Tech_ground_name" -allow_layer_change 1 \
         -target_via_layer_range [list $Tech_Metal_first $Tech_Metal_lastr]
  }
}

#------------------------------------ [12] - Pin Configuration
if {[file exists $scr/pins/${design}_pin.tcl]} {
   source $scr/pins/${design}_pin.tcl
} else {
   set_db place_global_place_io_pins 1
}
