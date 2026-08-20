#------------------------------------ [20] - Auto Route signals
route_design
check_drc

#------------------------------------ [21] - Extract RC post route
set_db extract_rc_engine post_route
extract_rc

#------------------------------------ [22] - Timing report (TNS - Total Negative Slack)
# set_propagated_clock [all_clocks]
set_db timing_analysis_type ocv
time_design -post_route >> ${design}_tns.rpt

#------------------------------------ [23] - Optimize timings post route (on work)
opt_design -post_route -setup
opt_design -post_route -hold
time_design -post_route 