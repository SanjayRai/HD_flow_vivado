# Created : 13:18:43, Tue Oct 2, 2012 : Sanjay Rai

set DEVICE xc7k325tffg900-2
create_project -in_memory -part $DEVICE

read_verilog -sv -verbose {
../src/rtl/example_top.v
../src/rtl/mig_7series_ip_top_black_box.v
../src/rtl/traffic_gen/mig_7series_v2_0_axi4_tg.v
../src/rtl/traffic_gen/mig_7series_v2_0_axi4_wrapper.v
../src/rtl/traffic_gen/mig_7series_v2_0_cmd_prbs_gen_axi.v
../src/rtl/traffic_gen/mig_7series_v2_0_data_gen_chk.v
../src/rtl/traffic_gen/mig_7series_v2_0_tg.v
}

read_xdc -verbose ../src/xdc/example_top.xdc
read_xdc -verbose ../src/xdc/example_top_HD.xdc

synth_design -top example_top -fanout_limit 100000 -part $DEVICE

read_checkpoint -cell u_mig_7series_ip_top ../vivado_HD_MIG_ONLY_build/u_mig_7series_ip_top_route_design.dcp
lock_design -level routing u_mig_7series_ip_top
#lock_design -level placement u_mig_7series_ip_top
set_property EXCLUDE_PLACEMENT 1 [get_pblocks ]
report_drc -ruledeck methodology_checks -name top -file ./example_top_drc_methodology_checks.rpt
report_drc -ruledeck timing_checks -name top -file ./example_top_drc_timing_checks.rpt
opt_design -verbose
place_design -verbose
phys_opt_design -verbose
route_design -verbose -effort_level high
report_timing -delay_type min_max -path_type full_clock_expanded -max_paths 100 -sort_by group -significant_digits 3 -input_pins -name {results_par_1} -file example_top_test.timing_rpt
report_timing_summary -delay_type min_max -path_type full_clock_expanded -max_paths 100 -significant_digits 3 -input_pins -file example_top_test.timing_summary_rpt
write_bitstream ./example_top_test.bit
