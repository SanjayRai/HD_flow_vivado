# Created : 13:18:43, Tue Oct 2, 2012 : Sanjay Rai

set DEVICE xc7k325tffg900-2

# Create Placed and Routed DCP for U_PR_A *************************************************
create_project -in_memory -part $DEVICE

read_vhdl -verbose {
../src/moving_average.vhd
../src/video_filter_PR.vhd
}

read_xdc ../../../src/xdc/U_PR_A_ooc_optimize.xdc
set_property USED_IN {implementation out_of_context} [get_files ../../../src/xdc/U_PR_A_ooc_optimize.xdc]
read_xdc ../../../src/xdc/U_PR_A_ooc_timing.xdc
set_property USED_IN {implementation out_of_context} [get_files ../../../src/xdc/U_PR_A_ooc_timing.xdc]
read_xdc ../../../src/xdc/U_PR_A_phys.xdc

synth_design -mode out_of_context -top video_filter_PR -fanout_limit 100000 -part $DEVICE
set_property HD.PARTITION 1 [current_design]
::debug::gen_hd_timing_constraints -percent 50 -file ../src/xdc/U_PR_A_ooc_budget.xdc
read_xdc -mode out_of_context ../src/xdc/U_PR_A_ooc_budget.xdc
opt_design
place_design
route_design
write_checkpoint -force ./U_PR_A_route_design.dcp
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -name timing_1 -file ./U_PR_A_timing_summary.rpt
report_timing -delay_type min_max -max_paths 10 -sort_by group -input_pins -name timing_2 -file ./U_PR_A_timing.rpt
close_project
# *****************************************************************************************



# Create Placed and Routed DCP for U_PR_B *************************************************
create_project -in_memory -part $DEVICE

read_vhdl -verbose {
../src/moving_average.vhd
../src/video_filter_PR.vhd
}

read_xdc ../../../src/xdc/U_PR_B_ooc_optimize.xdc
set_property USED_IN {implementation out_of_context} [get_files ../../../src/xdc/U_PR_B_ooc_optimize.xdc]
read_xdc ../../../src/xdc/U_PR_B_ooc_timing.xdc
set_property USED_IN {implementation out_of_context} [get_files ../../../src/xdc/U_PR_B_ooc_timing.xdc]
read_xdc ../../../src/xdc/U_PR_B_phys.xdc

synth_design -mode out_of_context -top video_filter_PR -fanout_limit 100000 -part $DEVICE
set_property HD.PARTITION 1 [current_design]
::debug::gen_hd_timing_constraints -percent 50 -file ../src/xdc/U_PR_B_ooc_budget.xdc
read_xdc -mode out_of_context ../src/xdc/U_PR_B_ooc_budget.xdc
opt_design
place_design
route_design
write_checkpoint -force ./U_PR_B_route_design.dcp
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -name timing_1 -file ./U_PR_B_timing_summary.rpt
report_timing -delay_type min_max -max_paths 10 -sort_by group -input_pins -name timing_2 -file ./U_PR_B_timing.rpt
close_project
# *****************************************************************************************
