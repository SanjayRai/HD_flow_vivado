# Created : 13:18:43, Tue Oct 2, 2013 : Sanjay Rai

set DEVICE xc7k325tffg900-2
create_project project_X project_X -part $DEVICE

add_files -verbose {
../src/rtl/mig_7series_ip_top.v
../src/rtl/example_top.v
../src/rtl/traffic_gen/mig_7series_v2_3_axi4_tg.v
../src/rtl/traffic_gen/mig_7series_v2_3_axi4_wrapper.v
../src/rtl/traffic_gen/mig_7series_v2_3_cmd_prbs_gen_axi.v
../src/rtl/traffic_gen/mig_7series_v2_3_data_gen_chk.v
../src/rtl/traffic_gen/mig_7series_v2_3_tg.v
../IP/mig_7series_0/mig_7series_0.xci
}

add_files -fileset constrs_1 -norecurse ../src/xdc/example_top.xdc
add_files -fileset constrs_1 -norecurse ../src/xdc/example_top_HD.xdc


launch_runs synth_1
wait_on_run synth_1
open_run synth_1 -name netlist_1

source ../Tcl/hd_floorplan_utils.tcl

hd_floorplan [get_cells u_mig_7series_ip_top]
