## Technology Settings
setup_design -manufacturer Xilinx -family "SPARTAN6" -part "6slx45csg324" -speed 3

## Input File Settings
add_input_file -format vhdl -work work "ipcore_dir/PLL_50_100_150_200_250.vhd"
add_input_file -format vhdl -work work "DIGIF.vhd"
add_input_file -format vhdl -work work "DESERIAL.vhd"
add_input_file -format vhdl -work work "DIGIF_DESERIAL_LOOPBACK.vhd"

## Settings from "Synthesize - Precision" process properties

# Input tab
setup_design -2004c_compile_mode=false
setup_design -resource_sharing
setup_design -advanced_fsm_optimization
setup_design -use_safe_fsm=false
setup_design -encoding=auto
setup_design -hdl=vhdl_2002
setup_design -variable full_case=FALSE
setup_design -variable parallel_case=FALSE
setup_design -array_bounds_check=false

# Optimization tab
setup_design -addio
setup_design -compile_for_area=false
setup_design -compile_for_timing
setup_design -transformations
setup_design -retiming=false

# Timing tab
setup_analysis -clock_frequency
setup_analysis -summary
setup_analysis -num_summary_paths=10
setup_analysis -critical_paths
setup_analysis -num_critical_paths=1
setup_analysis -timing_violations
setup_analysis -net_fanout
setup_analysis -clock_domain_crossing
setup_analysis -missing_constraints

# Output tab
setup_design -basename=\"\"
setup_design -edif
setup_design -verilog=false
setup_design -vhdl=false
setup_design -vendor_constraint_file=false
