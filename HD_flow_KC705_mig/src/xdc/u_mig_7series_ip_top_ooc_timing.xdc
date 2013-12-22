#---------------------------------------
# Create Clock Constraints - u_mig_7series_ip_top 
#---------------------------------------
create_clock -period 5.00000 -name sys_clk.sys_clk_p [get_ports sys_clk_p] -waveform {0.000 2.500}
set_system_jitter 0.0
set_clock_latency -source -max 1.611 [get_clocks sys_clk.sys_clk_p]
set_clock_latency -source -min 1.3760000000000001 [get_clocks sys_clk.sys_clk_p]
set_clock_uncertainty 0.035 [get_clocks sys_clk.sys_clk_p]
