#---------------------------------------
# Create Clock Constraints - u_mig_7series_ip_top 
#---------------------------------------
create_clock -period 5.000 -name sys_clk_p.sys_clk_p [get_ports {sys_clk_p}] -waveform {0.000 2.500}
set_system_jitter 0.0
set_clock_latency -source -max 1.1449999999999998 [get_clocks {sys_clk_p.sys_clk_p}]
set_clock_latency -source -min 0.9099999999999999 [get_clocks {sys_clk_p.sys_clk_p}]
set_clock_uncertainty 0.035 [get_clocks {sys_clk_p.sys_clk_p}]
