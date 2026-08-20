set scr $env(scr)

source $scr/Setup.tcl
source $scr/physical/1_DesignInit.tcl
    # puts "Script Stopped at DesignInit phase"
    # puts "\[resume\] to PreCTS"
    suspend
    write_db ${lyt_folder}/checkpoint/${design}_1.enc

source $scr/physical/2_PreCTS.tcl
    # puts "Script Stopped at PreCTs phase"
    # puts "\[resume\] to PostCTS"
    # suspend
    write_db ${lyt_folder}/checkpoint/${design}_2.enc

source $scr/physical/3_PostCTS.tcl
    # puts "Script Stopped at PostCTS phase"
    # puts "\[resume\] to PostRoute"
    # suspend
    write_db ${lyt_folder}/checkpoint/${design}_3.enc

source $scr/physical/4_PostRoute.tcl
    # puts "Script Stopped at PostRoute phase"
    # puts "\[resume\] to Signoff"
    # suspend
    write_db ${lyt_folder}/checkpoint/${design}_4.enc

source $scr/physical/5_Signoff.tcl
    write_db ${lyt_folder}/checkpoint/${design}_5.enc
    puts "Design Finished and saved!"

file copy -force ../logs/innovus.log ../layout/${design}_${tech_node_used}/reports/${design}_${tech_node_used}.log
exit