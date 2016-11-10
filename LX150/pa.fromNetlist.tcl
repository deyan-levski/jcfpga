
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name LX150 -dir "/media/data/git/jcfpga/LX150/planAhead_run_3" -part xc6slx150fgg484-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/media/data/git/jcfpga/LX150/ADC_CTRL.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/media/data/git/jcfpga/LX150} {ipcore_dir} {hdl} }
add_files [list {ipcore_dir/BLOCKMEM.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "constraints-test-board.ucf" [current_fileset -constrset]
add_files [list {constraints-test-board.ucf}] -fileset [get_property constrset [current_run]]
link_design
