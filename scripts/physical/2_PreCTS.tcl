#------------------------------------ [14] - Place Design
place_design
#------------------------------------ [15] - Extract RC
# set_db extract_rc_engine pre_route
extract_rc
#------------------------------------ [16] - Optmize design (Fix cap, max transition and fanout)
# set_db opt_drv_fix_max_cap true ; set_db opt_drv_fix_max_tran true ; set_db opt_fix_fanout_load false
opt_design -pre_cts
