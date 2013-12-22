
`timescale 1ps/1ps

(*dont_touch = "true" *)module mig_7series_ip_top (

   // Inouts
   inout [63:0]          ddr3_dq,
   inout [7:0]           ddr3_dqs_n,
   inout [7:0]           ddr3_dqs_p,

   // Outputs
   output [13:0]         ddr3_addr,
   output [2:0]          ddr3_ba,
   output                ddr3_ras_n,
   output                ddr3_cas_n,
   output                ddr3_we_n,
   output                ddr3_reset_n,
   output [0:0]          ddr3_ck_p,
   output [0:0]          ddr3_ck_n,
   output [0:0]          ddr3_cke,
   output [0:0]          ddr3_cs_n,
   output [7:0]          ddr3_dm,
   output [0:0]          ddr3_odt,

   // Inputs
   // Differential system clocks
   input                 sys_clk_p,
   input                 sys_clk_n,
   
   // user interface signals
   output                ui_clk,
   output                ui_clk_sync_rst,
   
   output                mmcm_locked,
   
   input                 aresetn,
   output                app_sr_active,
   output                app_ref_ack,
   output                app_zq_ack,

   // Slave Interface Write Address Ports
   input  [3:0]          s_axi_awid,
   input  [29:0]         s_axi_awaddr,
   input  [7:0]          s_axi_awlen,
   input  [2:0]          s_axi_awsize,
   input  [1:0]          s_axi_awburst,
   input  [0:0]          s_axi_awlock,
   input  [3:0]          s_axi_awcache,
   input  [2:0]          s_axi_awprot,
   input                 s_axi_awvalid,
   output                s_axi_awready,
   // Slave Interface Write Data Ports
   input  [511:0]        s_axi_wdata,
   input  [63:0]         s_axi_wstrb,
   input                 s_axi_wlast,
   input                 s_axi_wvalid,
   output                s_axi_wready,
   // Slave Interface Write Response Ports
   input                 s_axi_bready,
   output [3:0]          s_axi_bid,
   output [1:0]          s_axi_bresp,
   output                s_axi_bvalid,
   // Slave Interface Read Address Ports
   input  [3:0]          s_axi_arid,
   input  [29:0]         s_axi_araddr,
   input  [7:0]          s_axi_arlen,
   input  [2:0]          s_axi_arsize,
   input  [1:0]          s_axi_arburst,
   input  [0:0]          s_axi_arlock,
   input  [3:0]          s_axi_arcache,
   input  [2:0]          s_axi_arprot,
   input                 s_axi_arvalid,
   output                s_axi_arready,
   // Slave Interface Read Data Ports
   input                 s_axi_rready,
   output [3:0]          s_axi_rid,
   output [511:0]        s_axi_rdata,
   output [1:0]          s_axi_rresp,
   output                s_axi_rlast,
   output                s_axi_rvalid,
   
   output                init_calib_complete,
   
      

   // System reset - Default polarity of sys_rst pin is Active Low.
   // System reset polarity will change based on the option 
   // selected in GUI.
   input                 sys_rst
   );


  mig_7series_0 u_mig_7series_0 (
       
// Memory interface ports
       .ddr3_addr                      (ddr3_addr),
       .ddr3_ba                        (ddr3_ba),
       .ddr3_cas_n                     (ddr3_cas_n),
       .ddr3_ck_n                      (ddr3_ck_n),
       .ddr3_ck_p                      (ddr3_ck_p),
       .ddr3_cke                       (ddr3_cke),
       .ddr3_ras_n                     (ddr3_ras_n),
       .ddr3_reset_n                   (ddr3_reset_n),
       .ddr3_we_n                      (ddr3_we_n),
       .ddr3_dq                        (ddr3_dq),
       .ddr3_dqs_n                     (ddr3_dqs_n),
       .ddr3_dqs_p                     (ddr3_dqs_p),
       .init_calib_complete            (init_calib_complete),
      
       .ddr3_cs_n                      (ddr3_cs_n),
       .ddr3_dm                        (ddr3_dm),
       .ddr3_odt                       (ddr3_odt),
// Application interface ports
       .ui_clk                         (ui_clk),
       .ui_clk_sync_rst                (ui_clk_sync_rst),

       .mmcm_locked                    (mmcm_locked),
       .aresetn                        (aresetn),
       .app_sr_req                     (1'b0),
       .app_ref_req                    (1'b0),
       .app_zq_req                     (1'b0),
       .app_sr_active                  (app_sr_active),
       .app_ref_ack                    (app_ref_ack),
       .app_zq_ack                     (app_zq_ack),

// Slave Interface Write Address Ports
       .s_axi_awid                     (s_axi_awid),
       .s_axi_awaddr                   (s_axi_awaddr),
       .s_axi_awlen                    (s_axi_awlen),
       .s_axi_awsize                   (s_axi_awsize),
       .s_axi_awburst                  (s_axi_awburst),
       .s_axi_awlock                   (s_axi_awlock),
       .s_axi_awcache                  (s_axi_awcache),
       .s_axi_awprot                   (s_axi_awprot),
       .s_axi_awqos                    (4'h0),
       .s_axi_awvalid                  (s_axi_awvalid),
       .s_axi_awready                  (s_axi_awready),
// Slave Interface Write Data Ports
       .s_axi_wdata                    (s_axi_wdata),
       .s_axi_wstrb                    (s_axi_wstrb),
       .s_axi_wlast                    (s_axi_wlast),
       .s_axi_wvalid                   (s_axi_wvalid),
       .s_axi_wready                   (s_axi_wready),
// Slave Interface Write Response Ports
       .s_axi_bid                      (s_axi_bid),
       .s_axi_bresp                    (s_axi_bresp),
       .s_axi_bvalid                   (s_axi_bvalid),
       .s_axi_bready                   (s_axi_bready),
// Slave Interface Read Address Ports
       .s_axi_arid                     (s_axi_arid),
       .s_axi_araddr                   (s_axi_araddr),
       .s_axi_arlen                    (s_axi_arlen),
       .s_axi_arsize                   (s_axi_arsize),
       .s_axi_arburst                  (s_axi_arburst),
       .s_axi_arlock                   (s_axi_arlock),
       .s_axi_arcache                  (s_axi_arcache),
       .s_axi_arprot                   (s_axi_arprot),
       .s_axi_arqos                    (4'h0),
       .s_axi_arvalid                  (s_axi_arvalid),
       .s_axi_arready                  (s_axi_arready),
// Slave Interface Read Data Ports
       .s_axi_rid                      (s_axi_rid),
       .s_axi_rdata                    (s_axi_rdata),
       .s_axi_rresp                    (s_axi_rresp),
       .s_axi_rlast                    (s_axi_rlast),
       .s_axi_rvalid                   (s_axi_rvalid),
       .s_axi_rready                   (s_axi_rready),

      
       
// System Clock Ports
       .sys_clk_p                       (sys_clk_p),
       .sys_clk_n                       (sys_clk_n),
      
       .sys_rst                        (sys_rst)
       );
// End of User Design top instance

endmodule
