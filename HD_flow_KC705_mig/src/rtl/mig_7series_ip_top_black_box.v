
`timescale 1ps/1ps

(*dont_touch = "true" *)module mig_7series_ip_top (

   // Inouts
   inout [63:0]                         ddr3_dq,
   inout [7:0]                        ddr3_dqs_n,
   inout [7:0]                        ddr3_dqs_p,

   // Outputs
   output [13:0]                       ddr3_addr,
   output [2:0]                      ddr3_ba,
   output                                       ddr3_ras_n,
   output                                       ddr3_cas_n,
   output                                       ddr3_we_n,
   output                                       ddr3_reset_n,
   output [0:0]                        ddr3_ck_p,
   output [0:0]                        ddr3_ck_n,
   output [0:0]                       ddr3_cke,
   output [0:0]           ddr3_cs_n,
   output [7:0]                        ddr3_dm,
   output [0:0]                       ddr3_odt,

   // Inputs
   // Differential system clocks
   input                                        sys_clk_p,
   input                                        sys_clk_n,
   
   // user interface signals
   output                                       ui_clk,
   output                                       ui_clk_sync_rst,
   
   output                                       mmcm_locked,
   
   input                                        aresetn,
   output                                       app_sr_active,
   output                                       app_ref_ack,
   output                                       app_zq_ack,

   // Slave Interface Write Address Ports
   input  [3:0]                s_axi_awid,
   input  [29:0]              s_axi_awaddr,
   input  [7:0]                                 s_axi_awlen,
   input  [2:0]                                 s_axi_awsize,
   input  [1:0]                                 s_axi_awburst,
   input  [0:0]                                 s_axi_awlock,
   input  [3:0]                                 s_axi_awcache,
   input  [2:0]                                 s_axi_awprot,
   input                                        s_axi_awvalid,
   output                                       s_axi_awready,
   // Slave Interface Write Data Ports
   input  [511:0]              s_axi_wdata,
   input  [63:0]            s_axi_wstrb,
   input                                        s_axi_wlast,
   input                                        s_axi_wvalid,
   output                                       s_axi_wready,
   // Slave Interface Write Response Ports
   input                                        s_axi_bready,
   output [3:0]                s_axi_bid,
   output [1:0]                                 s_axi_bresp,
   output                                       s_axi_bvalid,
   // Slave Interface Read Address Ports
   input  [3:0]                s_axi_arid,
   input  [29:0]              s_axi_araddr,
   input  [7:0]                                 s_axi_arlen,
   input  [2:0]                                 s_axi_arsize,
   input  [1:0]                                 s_axi_arburst,
   input  [0:0]                                 s_axi_arlock,
   input  [3:0]                                 s_axi_arcache,
   input  [2:0]                                 s_axi_arprot,
   input                                        s_axi_arvalid,
   output                                       s_axi_arready,
   // Slave Interface Read Data Ports
   input                                        s_axi_rready,
   output [3:0]                s_axi_rid,
   output [511:0]              s_axi_rdata,
   output [1:0]                                 s_axi_rresp,
   output                                       s_axi_rlast,
   output                                       s_axi_rvalid,

   
   
   
   output                                       init_calib_complete,
   
      

   // System reset - Default polarity of sys_rst pin is Active Low.
   // System reset polarity will change based on the option 
   // selected in GUI.
   input                                        sys_rst
   );

endmodule
