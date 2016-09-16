
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name DIGIF_DESERIAL_LOOPBACK -dir "/media/design/fpga/projects/DIGIF_DESERIAL_LOOPBACK/planAhead_run_2" -part xc6slx45csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/media/design/fpga/projects/DIGIF_DESERIAL_LOOPBACK/DIGIF_DESERIAL_LOOPBACK.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/media/design/fpga/projects/DIGIF_DESERIAL_LOOPBACK} }
set_property target_constrs_file "constraints.ucf" [current_fileset -constrset]
add_files [list {constraints.ucf}] -fileset [get_property constrset [current_run]]
link_design
