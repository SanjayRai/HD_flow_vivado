# Created : 13:18:43, Tue Oct 2, 2012 : Sanjay Rai

set DEVICE xc7k325tffg900-2
create_project -in_memory -part $DEVICE

# Select one (only One) of the FIlter types below
set PR_module_list { \
PR_module_video_black_and_white \
PR_module_video_bypass \
PR_module_video_color_inv \
PR_module_video_crossover \
PR_module_video_softness }

set FILTER_TYPE_A [lindex $PR_module_list 3] 
set FILTER_TYPE_B [lindex $PR_module_list 4] 

read_vhdl -verbose {
../src/window.vhd
}
read_verilog -sv -verbose {
../PR_modules/PR_module_blackbox/video_filter_PR.v
../src/fmc_dvidp_dvi_in.v
../src/fmc_dvidp_dvi_out.v
../src/FMC_DVIDP_CONFIG.v
../src/PB_FMC_DVIDP_CONFIG.v
../src/kcpsm3.v
../src/test_patterns.v
../src/FMC_DVIDP_CONFIG_test.v
}

read_ip ../IP/clk_wiz/clk_wiz.xci

read_xdc -verbose ../src/xdc/FMC_DVIDP_CONFIG_test.xdc

synth_design -top FMC_DVIDP_CONFIG_test -fanout_limit 100000 -part $DEVICE


if (1) {

set_property HD.PARTITION 1 [get_cells U_PR_A]
read_checkpoint -cell U_PR_A ../PR_modules/$FILTER_TYPE_A/vivado_hd_flow_batch/U_PR_A_route_design.dcp -strict
lock_design -level routing U_PR_A

set_property HD.PARTITION 1 [get_cells U_PR_B]
read_checkpoint -cell U_PR_B ../PR_modules/$FILTER_TYPE_B/vivado_hd_flow_batch/U_PR_B_route_design.dcp -strict
lock_design -level routing U_PR_B

#report_drc -ruledeck methodology_checks -name top -file ./FMC_DVIDP_CONFIG_test_drc_methodology_checks.rpt
#report_drc -ruledeck timing_checks -name top -file ./FMC_DVIDP_CONFIG_test_drc_timing_checks.rpt
opt_design -verbose
place_design -verbose
phys_opt_design -verbose
route_design -verbose -effort_level high
#report_timing -delay_type min_max -path_type full_clock_expanded -max_paths 100 -sort_by group -significant_digits 3 -input_pins -name {results_par_1} -file FMC_DVIDP_CONFIG_test.timing_rpt
#report_timing_summary -delay_type min_max -path_type full_clock_expanded -max_paths 100 -significant_digits 3 -input_pins -file FMC_DVIDP_CONFIG_test.timing_summary_rpt
write_bitstream ./FMC_DVIDP_CONFIG_test.bit
}
