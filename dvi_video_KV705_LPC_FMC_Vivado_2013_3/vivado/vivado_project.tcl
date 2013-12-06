# Created : 13:18:43, Tue Oct 2, 2013 : Sanjay Rai

set DEVICE xc7k325tffg900-2
create_project project_X project_X -part $DEVICE

add_files -verbose {
../PR_modules/PR_module_video_bypass/src/video_filter_PR.vhd
../src/window.vhd
../src/fmc_dvidp_dvi_in.v
../src/fmc_dvidp_dvi_out.v
../src/FMC_DVIDP_CONFIG.v
../src/PB_FMC_DVIDP_CONFIG.v
../src/kcpsm3.v
../src/test_patterns.v
../src/FMC_DVIDP_CONFIG_test.v
../IP/clk_wiz/clk_wiz.xci
}

add_files -fileset constrs_1 -norecurse ../src/xdc/FMC_DVIDP_CONFIG_test.xdc

launch_runs synth_1
wait_on_run synth_1
open_run synth_1 -name netlist_1
source ../Tcl/hd_floorplan_utils.tcl
