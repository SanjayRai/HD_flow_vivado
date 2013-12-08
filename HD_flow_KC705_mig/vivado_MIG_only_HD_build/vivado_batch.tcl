# Created : 13:18:43, Tue Oct 2, 2012 : Sanjay Rai

set DEVICE xc7k325tffg900-2

# Create Placed and Routed DCP for u_mig_7series_ip_top *************************************************
create_project -in_memory -part $DEVICE

read_verilog -verbose {
../src/rtl/mig_7series_ip_top.v
}
read_ip ../IP/mig_7series_0/mig_7series_0.xci

read_xdc ../src/xdc/u_mig_7series_ip_top_ooc_optimize.xdc
set_property USED_IN {implementation out_of_context} [get_files ../src/xdc/u_mig_7series_ip_top_ooc_optimize.xdc]
read_xdc ../src/xdc/u_mig_7series_ip_top_ooc_timing.xdc
set_property USED_IN {out_of_context} [get_files ../src/xdc/u_mig_7series_ip_top_ooc_timing.xdc]
#set_property USED_IN {implementation out_of_context} [get_files ../src/xdc/u_mig_7series_ip_top_ooc_timing.xdc]
read_xdc ../src/xdc/u_mig_7series_ip_top_phys.xdc

synth_design -mode out_of_context -top mig_7series_ip_top -fanout_limit 100000 -part $DEVICE
set_property HD.PARTITION 1 [current_design]
::debug::gen_hd_timing_constraints -percent 60 -file ../src/xdc/u_mig_7series_ip_top_ooc_budget.xdc
read_xdc -mode out_of_context ../src/xdc/u_mig_7series_ip_top_ooc_budget.xdc
opt_design
place_design
route_design
write_checkpoint -force ./u_mig_7series_ip_top_route_design.dcp
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -name timing_1 -file ./u_mig_7series_ip_top_timing_summary.rpt
report_timing -delay_type min_max -max_paths 10 -sort_by group -input_pins -name timing_2 -file ./u_mig_7series_ip_top_timing.rpt
close_project
# *****************************************************************************************
