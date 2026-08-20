set pin_l "A[0] A[1] A[2] A[3]"
set spc_l "1.69"

set pin_t "enable Cin Cout"
set spc_t "1.69"

set pin_r "S[0] S[1] S[2] S[3]"
set spc_r "1.69"

set pin_b "B[0] B[1] B[2] B[3]"
set spc_b "1.69"

set_db design_bottom_routing_layer MET1

set_db assign_pins_edit_in_batch true

if {[info exists pin_l] && [string length $pin_l] > 0} {
    edit_pin -pin $pin_l -spread_type center -edge 0 -layer $Tech_Metal_pin_h -fix_overlap 1 -spacing $spc_l -unit micron -fixed_pin 1
}
if {[info exists pin_t] && [string length $pin_t] > 0} {
    edit_pin -pin $pin_t -spread_type center -edge 1 -layer $Tech_Metal_pin_v -fix_overlap 1 -spacing $spc_t -unit micron -fixed_pin 1
}
if {[info exists pin_r] && [string length $pin_r] > 0} {
    edit_pin -pin $pin_r -spread_type center -edge 2 -layer $Tech_Metal_pin_h -fix_overlap 1 -spacing $spc_r -unit micron -fixed_pin 1
}
if {[info exists pin_b] && [string length $pin_b] > 0} {
    edit_pin -pin $pin_b -spread_type center -edge 3 -layer $Tech_Metal_pin_v -fix_overlap 1 -spacing $spc_b -unit micron -fixed_pin 1

}
set_db assign_pins_edit_in_batch false

check_pin_assignment