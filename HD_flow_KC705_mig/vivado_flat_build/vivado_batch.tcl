# Created : 13:18:43, Tue Oct 2, 2012 : Sanjay Rai

set DEVICE xc7k325tffg900-2
create_project -in_memory -part $DEVICE

read_verilog -sv -verbose {
../src/rtl/mig_7series_ip_top.v
../src/rtl/example_top.v
../src/rtl/traffic_gen/mig_7series_v2_3_axi4_tg.v
../src/rtl/traffic_gen/mig_7series_v2_3_axi4_wrapper.v
../src/rtl/traffic_gen/mig_7series_v2_3_cmd_prbs_gen_axi.v
../src/rtl/traffic_gen/mig_7series_v2_3_data_gen_chk.v
../src/rtl/traffic_gen/mig_7series_v2_3_tg.v
}

read_ip ../IP/mig_7series_0/mig_7series_0.xci

read_xdc -verbose ../src/xdc/example_top.xdc

synth_design -top example_top -fanout_limit 100000 -part $DEVICE

report_drc -ruledeck methodology_checks -name top -file ./example_top_drc_methodology_checks.rpt
report_drc -ruledeck timing_checks -name top -file ./example_top_drc_timing_checks.rpt
opt_design -verbose
place_design -verbose
phys_opt_design -verbose
route_design -verbose -effort_level high
report_timing -delay_type min_max -path_type full_clock_expanded -max_paths 100 -sort_by group -significant_digits 3 -input_pins -name {results_par_1} -file example_top_test.timing_rpt
report_timing_summary -delay_type min_max -path_type full_clock_expanded -max_paths 100 -significant_digits 3 -input_pins -file example_top_test.timing_summary_rpt
write_bitstream ./example_top_test.bit
