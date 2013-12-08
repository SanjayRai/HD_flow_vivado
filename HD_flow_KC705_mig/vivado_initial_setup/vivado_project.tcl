# Created : 13:18:43, Tue Oct 2, 2013 : Sanjay Rai

set DEVICE xc7k325tffg900-2
create_project project_X project_X -part $DEVICE

add_files -verbose {
../src/rtl/example_top.v
../src/rtl/mig_7series_ip_top.v
../src/rtl/traffic_gen/mig_7series_v2_0_axi4_tg.v
../src/rtl/traffic_gen/mig_7series_v2_0_axi4_wrapper.v
../src/rtl/traffic_gen/mig_7series_v2_0_cmd_prbs_gen_axi.v
../src/rtl/traffic_gen/mig_7series_v2_0_data_gen_chk.v
../src/rtl/traffic_gen/mig_7series_v2_0_tg.v
../IP/mig_7series_0/mig_7series_0.xci
}

add_files -fileset constrs_1 -norecurse ../src/xdc/example_top.xdc


launch_runs synth_1
wait_on_run synth_1
open_run synth_1 -name netlist_1
set_property HD.PARTITION true [get_cells u_mig_7series_ip_top]
set_property CONTAIN_ROUTING true [get_pblocks pblock_u_mig_7series_ip_top]

set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/ui_clk_sync_rst]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/mmcm_locked]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/aresetn]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/app_*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/init_calib_complete]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/sys_rst]

set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_awid*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_awaddr*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_awlen*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_awsize*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_awburst*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_awlock*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_awcache*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_awprot*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_awvalid*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_awready*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_wdata*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_wstrb*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_wlast*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_wvalid*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_wready*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_bready*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_bid*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_bvalid*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_arid*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_araddr*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_arlen*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_arsize*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_arburst*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_arlock*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_arcache*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_arprot*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_arvalid*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_arready*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_rready*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_rid*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_rdata*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_rlast*]
set_property HD.PARTPIN_RANGE {SLICE_X114Y11:SLICE_X115Y144} [get_pins u_mig_7series_ip_top/s_axi_rvalid*]

set_property LOC BUFGCTRL_X0Y0 [get_cells u_mig_7series_ip_top/u_mig_7series_0/u_iodelay_ctrl/clk_ref_noibuf.u_bufg_clk_ref]
set_property LOC BUFGCTRL_X0Y1 [get_cells u_mig_7series_ip_top/u_mig_7series_0/u_ddr3_infrastructure/u_bufg_clkdiv0]
set_property LOC BUFHCE_X1Y19 [get_cells u_mig_7series_ip_top/u_mig_7series_0/u_ddr3_infrastructure/u_bufh_pll_clk3]
set_property LOC XADC_X0Y0 [get_cells u_mig_7series_ip_top/u_mig_7series_0/temp_mon_enabled.u_tempmon/xadc_supplied_temperature.XADC_inst]
source ../Tcl/hd_floorplan_utils.tcl
