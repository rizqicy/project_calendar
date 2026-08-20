switch $tech_node_used {
    "XH180" {
    foreach lc [get_db base_cells -if {.name == "CLK*"}] {
        set_db $lc .dont_use true
        }
    foreach lc [get_db base_cells -if {.name == "DLY*"}] {
        set_db $lc .dont_use true
        }
    foreach lc [get_db base_cells -if {.name == "SD*"}] {
        set_db $lc .dont_use true
        }
    }
}