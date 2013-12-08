
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
   localparam BANK_WIDTH            = 3;
   localparam CK_WIDTH              = 1;
                                     // # of CK/CK# outputs to memory.
   localparam COL_WIDTH             = 10;
                                     // # of memory Column Address bits.
   localparam CS_WIDTH              = 1;
                                     // # of unique CS outputs to memory.
   localparam nCS_PER_RANK          = 1;
                                     // # of unique CS outputs per rank for phy
   localparam CKE_WIDTH             = 1;
                                     // # of CKE outputs to memory.
   localparam DATA_BUF_ADDR_WIDTH   = 5;
   localparam DQ_CNT_WIDTH          = 6;
                                     // = ceil(log2(DQ_WIDTH))
   localparam DQ_PER_DM             = 8;
   localparam DM_WIDTH              = 8;
                                     // # of DM (data mask)
   localparam DQ_WIDTH              = 64;
                                     // # of DQ (data)
   localparam DQS_WIDTH             = 8;
   localparam DQS_CNT_WIDTH         = 3;
                                     // = ceil(log2(DQS_WIDTH))
   localparam DRAM_WIDTH            = 8;
                                     // # of DQ per DQS
   localparam ECC                   = "OFF";
   localparam DATA_WIDTH            = 64;
   localparam ECC_TEST              = "OFF";
   localparam PAYLOAD_WIDTH         = (ECC_TEST == "OFF") ? DATA_WIDTH : DQ_WIDTH;
   localparam MEM_ADDR_ORDER        = "BANK_ROW_COLUMN";
                                      //Possible localparams
                                      //1.BANK_ROW_COLUMN : Address mapping is
                                      //                    in form of Bank Row Column.
                                      //2.ROW_BANK_COLUMN : Address mapping is
                                      //                    in the form of Row Bank Column.
                                      //3.TG_TEST : Scrambles Address bits
                                      //            for distributed Addressing.
      
   localparam nBANK_MACHS           = 4;
   localparam RANKS                 = 1;
                                     // # of Ranks.
   localparam ODT_WIDTH             = 1;
                                     // # of ODT outputs to memory.
   localparam ROW_WIDTH             = 14;
                                     // # of memory Row Address bits.
   localparam ADDR_WIDTH            = 28;
                                     // # = RANK_WIDTH + BANK_WIDTH
                                     //     + ROW_WIDTH + COL_WIDTH;
                                     // Chip Select is always tied to low for
                                     // single rank devices
   localparam USE_CS_PORT          = 1;
                                     // # = 1; When Chip Select (CS#) output is enabled
                                     //   = 0; When Chip Select (CS#) output is disabled
                                     // If CS_N disabled; user must connect
                                     // DRAM CS_N input(s) to ground
   localparam USE_DM_PORT           = 1;
                                     // # = 1; When Data Mask option is enabled
                                     //   = 0; When Data Mask option is disbaled
                                     // When Data Mask option is disabled in
                                     // MIG Controller Options page; the logic
                                     // related to Data Mask should not get
                                     // synthesized
   localparam USE_ODT_PORT          = 1;
                                     // # = 1; When ODT output is enabled
                                     //   = 0; When ODT output is disabled
                                     // localparam configuration for Dynamic ODT support:
                                     // USE_ODT_PORT = 0; RTT_NOM = "DISABLED"; RTT_WR = "60/120".
                                     // This configuration allows to save ODT pin mapping from FPGA.
                                     // The user can tie the ODT input of DRAM to HIGH.
   localparam IS_CLK_SHARED          = "FALSE";
                                      // # = "true" when clock is shared
                                      //   = "false" when clock is not shared 

   localparam PHY_CONTROL_MASTER_BANK = 1;
                                     // The bank index where master PHY_CONTROL resides;
                                     // equal to the PLL residing bank
   localparam MEM_DENSITY           = "1Gb";
                                     // Indicates the density of the Memory part
                                     // Added for the sake of Vivado simulations
   localparam MEM_SPEEDGRADE        = "125";
                                     // Indicates the Speed grade of Memory Part
                                     // Added for the sake of Vivado simulations
   localparam MEM_DEVICE_WIDTH      = 8;
                                     // Indicates the device width of the Memory Part
                                     // Added for the sake of Vivado simulations

   //***************************************************************************
   // The following localparams are mode register settings
   //***************************************************************************
   localparam AL                    = "0";
                                     // DDR3 SDRAM:
                                     // Additive Latency (Mode Register 1).
                                     // # = "0"; "CL-1"; "CL-2".
                                     // DDR2 SDRAM:
                                     // Additive Latency (Extended Mode Register).
   localparam nAL                   = 0;
                                     // # Additive Latency in number of clock
                                     // cycles.
   localparam BURST_MODE            = "8";
                                     // DDR3 SDRAM:
                                     // Burst Length (Mode Register 0).
                                     // # = "8"; "4"; "OTF".
                                     // DDR2 SDRAM:
                                     // Burst Length (Mode Register).
                                     // # = "8"; "4".
   localparam BURST_TYPE            = "SEQ";
                                     // DDR3 SDRAM: Burst Type (Mode Register 0).
                                     // DDR2 SDRAM: Burst Type (Mode Register).
                                     // # = "SEQ" - (Sequential);
                                     //   = "INT" - (Interleaved).
   localparam CL                    = 11;
                                     // in number of clock cycles
                                     // DDR3 SDRAM: CAS Latency (Mode Register 0).
                                     // DDR2 SDRAM: CAS Latency (Mode Register).
   localparam CWL                   = 8;
                                     // in number of clock cycles
                                     // DDR3 SDRAM: CAS Write Latency (Mode Register 2).
                                     // DDR2 SDRAM: Can be ignored
   localparam OUTPUT_DRV            = "HIGH";
                                     // Output Driver Impedance Control (Mode Register 1).
                                     // # = "HIGH" - RZQ/7;
                                     //   = "LOW" - RZQ/6.
   localparam RTT_NOM               = "60";
                                     // RTT_NOM (ODT) (Mode Register 1).
                                     //   = "120" - RZQ/2;
                                     //   = "60"  - RZQ/4;
                                     //   = "40"  - RZQ/6.
   localparam RTT_WR                = "OFF";
                                     // RTT_WR (ODT) (Mode Register 2).
                                     // # = "OFF" - Dynamic ODT off;
                                     //   = "120" - RZQ/2;
                                     //   = "60"  - RZQ/4;
   localparam ADDR_CMD_MODE         = "1T" ;
                                     // # = "1T"; "2T".
   localparam REG_CTRL              = "OFF";
                                     // # = "ON" - RDIMMs;
                                     //   = "OFF" - Components; SODIMMs; UDIMMs.
   localparam CA_MIRROR             = "OFF";
                                     // C/A mirror opt for DDR3 dual rank

   localparam VDD_OP_VOLT           = "150";
                                     // # = "150" - 1.5V Vdd Memory part
                                     //   = "135" - 1.35V Vdd Memory part

   
   //***************************************************************************
   // The following localparams are multiplier and divisor factors for PLLE2.
   // Based on the selected design frequency these localparams vary.
   //***************************************************************************
   localparam CLKIN_PERIOD          = 5000;
                                     // Input Clock Period
   localparam CLKFBOUT_MULT         = 8;
                                     // write PLL VCO multiplier
   localparam DIVCLK_DIVIDE         = 1;
                                     // write PLL VCO divisor
   localparam CLKOUT0_PHASE         = 337.5;
                                     // Phase for PLL output clock (CLKOUT0)
   localparam CLKOUT0_DIVIDE        = 2;
                                     // VCO output divisor for PLL output clock (CLKOUT0)
   localparam CLKOUT1_DIVIDE        = 2;
                                     // VCO output divisor for PLL output clock (CLKOUT1)
   localparam CLKOUT2_DIVIDE        = 32;
                                     // VCO output divisor for PLL output clock (CLKOUT2)
   localparam CLKOUT3_DIVIDE        = 8;
                                     // VCO output divisor for PLL output clock (CLKOUT3)

   //***************************************************************************
   // Memory Timing localparams. These localparams varies based on the selected
   // memory part.
   //***************************************************************************
   localparam tCKE                  = 5000;
                                     // memory tCKE paramter in pS
   localparam tFAW                  = 30000;
                                     // memory tRAW paramter in pS.
   localparam tPRDI                 = 1_000_000;
                                     // memory tPRDI paramter in pS.
   localparam tRAS                  = 35000;
                                     // memory tRAS paramter in pS.
   localparam tRCD                  = 13125;
                                     // memory tRCD paramter in pS.
   localparam tREFI                 = 7800000;
                                     // memory tREFI paramter in pS.
   localparam tRFC                  = 110000;
                                     // memory tRFC paramter in pS.
   localparam tRP                   = 13125;
                                     // memory tRP paramter in pS.
   localparam tRRD                  = 6000;
                                     // memory tRRD paramter in pS.
   localparam tRTP                  = 7500;
                                     // memory tRTP paramter in pS.
   localparam tWTR                  = 7500;
                                     // memory tWTR paramter in pS.
   localparam tZQI                  = 128_000_000;
                                     // memory tZQI paramter in nS.
   localparam tZQCS                 = 64;
                                     // memory tZQCS paramter in clock cycles.

   //***************************************************************************
   // Simulation localparams
   //***************************************************************************
   localparam SIM_BYPASS_INIT_CAL   = "OFF";
                                     // # = "OFF" -  Complete memory init &
                                     //              calibration sequence
                                     // # = "SKIP" - Not supported
                                     // # = "FAST" - Complete memory init & use
                                     //              abbreviated calib sequence

   localparam SIMULATION            = "FALSE";
                                     // Should be TRUE during design simulations and
                                     // FALSE during implementations

   //***************************************************************************
   // The following localparams varies based on the pin out entered in MIG GUI.
   // Do not change any of these localparams directly by editing the RTL.
   // Any changes required should be done through GUI and the design regenerated.
   //***************************************************************************
   localparam BYTE_LANES_B0         = 4'b1111;
                                     // Byte lanes used in an IO column.
   localparam BYTE_LANES_B1         = 4'b1110;
                                     // Byte lanes used in an IO column.
   localparam BYTE_LANES_B2         = 4'b1111;
                                     // Byte lanes used in an IO column.
   localparam BYTE_LANES_B3         = 4'b0000;
                                     // Byte lanes used in an IO column.
   localparam BYTE_LANES_B4         = 4'b0000;
                                     // Byte lanes used in an IO column.
   localparam DATA_CTL_B0           = 4'b1111;
                                     // Indicates Byte lane is data byte lane
                                     // or control Byte lane. '1' in a bit
                                     // position indicates a data byte lane and
                                     // a '0' indicates a control byte lane
   localparam DATA_CTL_B1           = 4'b0000;
                                     // Indicates Byte lane is data byte lane
                                     // or control Byte lane. '1' in a bit
                                     // position indicates a data byte lane and
                                     // a '0' indicates a control byte lane
   localparam DATA_CTL_B2           = 4'b1111;
                                     // Indicates Byte lane is data byte lane
                                     // or control Byte lane. '1' in a bit
                                     // position indicates a data byte lane and
                                     // a '0' indicates a control byte lane
   localparam DATA_CTL_B3           = 4'b0000;
                                     // Indicates Byte lane is data byte lane
                                     // or control Byte lane. '1' in a bit
                                     // position indicates a data byte lane and
                                     // a '0' indicates a control byte lane
   localparam DATA_CTL_B4           = 4'b0000;
                                     // Indicates Byte lane is data byte lane
                                     // or control Byte lane. '1' in a bit
                                     // position indicates a data byte lane and
                                     // a '0' indicates a control byte lane
   localparam PHY_0_BITLANES        = 48'h3FE_3FE_3FE_2FF;
   localparam PHY_1_BITLANES        = 48'h3FF_FFE_C00_000;
   localparam PHY_2_BITLANES        = 48'h3FE_3FE_3FE_2FF;

   // control/address/data pin mapping localparams
   localparam CK_BYTE_MAP
     = 144'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_13;
   localparam ADDR_MAP
     = 192'h000_000_139_138_137_136_135_134_133_132_131_130_129_128_127_126;
   localparam BANK_MAP   = 36'h12B_12A_125;
   localparam CAS_MAP    = 12'h123;
   localparam CKE_ODT_BYTE_MAP = 8'h00;
   localparam CKE_MAP    = 96'h000_000_000_000_000_000_000_11B;
   localparam ODT_MAP    = 96'h000_000_000_000_000_000_000_11A;
   localparam CS_MAP     = 120'h000_000_000_000_000_000_000_000_000_121;
   localparam PARITY_MAP = 12'h000;
   localparam RAS_MAP    = 12'h124;
   localparam WE_MAP     = 12'h122;
   localparam DQS_BYTE_MAP
     = 144'h00_00_00_00_00_00_00_00_00_00_20_21_22_23_00_01_02_03;
   localparam DATA0_MAP  = 96'h031_032_033_034_035_036_037_038;
   localparam DATA1_MAP  = 96'h021_022_023_024_025_026_027_028;
   localparam DATA2_MAP  = 96'h011_012_013_014_016_017_018_019;
   localparam DATA3_MAP  = 96'h000_001_002_003_004_005_006_007;
   localparam DATA4_MAP  = 96'h231_232_233_234_235_236_237_238;
   localparam DATA5_MAP  = 96'h221_222_223_224_225_226_227_228;
   localparam DATA6_MAP  = 96'h211_212_213_214_216_217_218_219;
   localparam DATA7_MAP  = 96'h200_201_202_203_204_205_206_207;
   localparam DATA8_MAP  = 96'h000_000_000_000_000_000_000_000;
   localparam DATA9_MAP  = 96'h000_000_000_000_000_000_000_000;
   localparam DATA10_MAP = 96'h000_000_000_000_000_000_000_000;
   localparam DATA11_MAP = 96'h000_000_000_000_000_000_000_000;
   localparam DATA12_MAP = 96'h000_000_000_000_000_000_000_000;
   localparam DATA13_MAP = 96'h000_000_000_000_000_000_000_000;
   localparam DATA14_MAP = 96'h000_000_000_000_000_000_000_000;
   localparam DATA15_MAP = 96'h000_000_000_000_000_000_000_000;
   localparam DATA16_MAP = 96'h000_000_000_000_000_000_000_000;
   localparam DATA17_MAP = 96'h000_000_000_000_000_000_000_000;
   localparam MASK0_MAP  = 108'h000_209_215_229_239_009_015_029_039;
   localparam MASK1_MAP  = 108'h000_000_000_000_000_000_000_000_000;

   localparam SLOT_0_CONFIG         = 8'b0000_0001;
                                     // Mapping of Ranks.
   localparam SLOT_1_CONFIG         = 8'b0000_0000;
                                     // Mapping of Ranks.

   //***************************************************************************
   // IODELAY and PHY related localparams
   //***************************************************************************
   localparam IBUF_LPWR_MODE        = "OFF";
                                     // to phy_top
   localparam DATA_IO_IDLE_PWRDWN   = "ON";
                                     // # = "ON"; "OFF"
   localparam BANK_TYPE             = "HP_IO";
                                     // # = "HP_IO"; "HPL_IO"; "HR_IO"; "HRL_IO"
   localparam DATA_IO_PRIM_TYPE     = "HP_LP";
                                     // # = "HP_LP"; "HR_LP"; "DEFAULT"
   localparam CKE_ODT_AUX           = "FALSE";
   localparam USER_REFRESH          = "OFF";
   localparam WRLVL                 = "ON";
                                     // # = "ON" - DDR3 SDRAM
                                     //   = "OFF" - DDR2 SDRAM.
   localparam ORDERING              = "NORM";
                                     // # = "NORM"; "STRICT"; "RELAXED".
   localparam CALIB_ROW_ADD         = 16'h0000;
                                     // Calibration row address will be used for
                                     // calibration read and write operations
   localparam CALIB_COL_ADD         = 12'h000;
                                     // Calibration column address will be used for
                                     // calibration read and write operations
   localparam CALIB_BA_ADD          = 3'h0;
                                     // Calibration bank address will be used for
                                     // calibration read and write operations
   localparam TCQ                   = 100;
   localparam IODELAY_GRP           = "MIG_7SERIES_0_IODELAY_MIG";
                                     // It is associated to a set of IODELAYs with
                                     // an IDELAYCTRL that have same IODELAY CONTROLLER
                                     // clock frequency.
   localparam SYSCLK_TYPE           = "DIFFERENTIAL";
                                     // System clock type DIFFERENTIAL; SINGLE_ENDED;
                                     // NO_BUFFER
   localparam REFCLK_TYPE           = "USE_SYSTEM_CLOCK";
                                     // Reference clock type DIFFERENTIAL; SINGLE_ENDED;
                                     // NO_BUFFER; USE_SYSTEM_CLOCK
   localparam SYS_RST_PORT          = "FALSE";
                                     // "TRUE" - if pin is selected for sys_rst
                                     //          and IBUF will be instantiated.
                                     // "FALSE" - if pin is not selected for sys_rst
      
   localparam CMD_PIPE_PLUS1        = "ON";
                                     // add pipeline stage between MC and PHY
   localparam DRAM_TYPE             = "DDR3";
   localparam CAL_WIDTH             = "HALF";
   localparam STARVE_LIMIT          = 2;
                                     // # = 2;3;4.

   //***************************************************************************
   // Referece clock frequency localparams
   //***************************************************************************
   localparam REFCLK_FREQ           = 200.0;
                                     // IODELAYCTRL reference clock frequency
   localparam DIFF_TERM_REFCLK      = "TRUE";
                                     // Differential Termination for idelay
                                     // reference clock input pins
   //***************************************************************************
   // System clock frequency localparams
   //***************************************************************************
   localparam tCK                   = 1250;
                                     // memory tCK paramter.
                                     // # = Clock Period in pS.
   localparam nCK_PER_CLK           = 4;
                                     // # of memory CKs per fabric CLK
   localparam DIFF_TERM_SYSCLK      = "FALSE";
                                     // Differential Termination for System
                                     // clock input pins

   
   //***************************************************************************
   // AXI4 Shim localparams
   //***************************************************************************
   
   localparam UI_EXTRA_CLOCKS = "FALSE";
                                     // Generates extra clocks as
                                     // 1/2; 1/4 and 1/8 of fabrick clock.
                                     // Valid for DDR2/DDR3 AXI interfaces
                                     // based on GUI selection
   localparam C_S_AXI_ID_WIDTH              = 4;
                                             // Width of all master and slave ID signals.
                                             // # = >= 1.
   localparam C_S_AXI_MEM_SIZE              = "1073741824";
                                     // Address Space required for this component
   localparam C_S_AXI_ADDR_WIDTH            = 30;
                                             // Width of S_AXI_AWADDR; S_AXI_ARADDR; M_AXI_AWADDR and
                                             // M_AXI_ARADDR for all SI/MI slots.
                                             // # = 32.
   localparam C_S_AXI_DATA_WIDTH            = 512;
                                             // Width of WDATA and RDATA on SI slot.
                                             // Must be <= APP_DATA_WIDTH.
                                             // # = 32; 64; 128; 256.
   localparam C_MC_nCK_PER_CLK              = 4;
                                             // Indicates whether to instatiate upsizer
                                             // Range: 0; 1
   localparam C_S_AXI_SUPPORTS_NARROW_BURST = 1;
                                             // Indicates whether to instatiate upsizer
                                             // Range: 0; 1
   localparam C_RD_WR_ARB_ALGORITHM          = "RD_PRI_REG";
                                             // Indicates the Arbitration
                                             // Allowed values - "TDM"; "ROUND_ROBIN";
                                             // "RD_PRI_REG"; "RD_PRI_REG_STARVE_LIMIT"
                                             // "WRITE_PRIORITY"; "WRITE_PRIORITY_REG"
   localparam C_S_AXI_REG_EN0               = 20'h00000;
                                             // C_S_AXI_REG_EN0[00] = Reserved
                                             // C_S_AXI_REG_EN0[04] = AW CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN0[05] =  W CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN0[06] =  B CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN0[07] =  R CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN0[08] = AW CHANNEL UPSIZER REGISTER SLICE
                                             // C_S_AXI_REG_EN0[09] =  W CHANNEL UPSIZER REGISTER SLICE
                                             // C_S_AXI_REG_EN0[10] = AR CHANNEL UPSIZER REGISTER SLICE
                                             // C_S_AXI_REG_EN0[11] =  R CHANNEL UPSIZER REGISTER SLICE
   localparam C_S_AXI_REG_EN1               = 20'h00000;
                                             // Instatiates register slices after the upsizer.
                                             // The type of register is specified for each channel
                                             // in a vector. 4 bits per channel are used.
                                             // C_S_AXI_REG_EN1[03:00] = AW CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN1[07:04] =  W CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN1[11:08] =  B CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN1[15:12] = AR CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN1[20:16] =  R CHANNEL REGISTER SLICE
                                             // Possible values for each channel are:
                                             //
                                             //   0 => BYPASS    = The channel is just wired through the
                                             //                    module.
                                             //   1 => FWD       = The master VALID and payload signals
                                             //                    are registrated.
                                             //   2 => REV       = The slave ready signal is registrated
                                             //   3 => FWD_REV   = Both FWD and REV
                                             //   4 => SLAVE_FWD = All slave side signals and master
                                             //                    VALID and payload are registrated.
                                             //   5 => SLAVE_RDY = All slave side signals and master
                                             //                    READY are registrated.
                                             //   6 => INPUTS    = Slave and Master side inputs are
                                             //                    registrated.
                                             //   7 => ADDRESS   = Optimized for address channel
   localparam C_S_AXI_CTRL_ADDR_WIDTH       = 32;
                                             // Width of AXI-4-Lite address bus
   localparam C_S_AXI_CTRL_DATA_WIDTH       = 32;
                                             // Width of AXI-4-Lite data buses
   localparam C_S_AXI_BASEADDR              = 32'h0000_0000;
                                             // Base address of AXI4 Memory Mapped bus.
   localparam C_ECC_ONOFF_RESET_VALUE       = 1;
                                             // Controls ECC on/off value at startup/reset
   localparam C_ECC_CE_COUNTER_WIDTH        = 8;
                                             // The external memory to controller clock ratio.

   //***************************************************************************
   // Debug localparams
   //***************************************************************************
   localparam DEBUG_PORT            = "OFF";
                                     // # = "ON" Enable debug signals/controls.
                                     //   = "OFF" Disable debug signals/controls.

   //***************************************************************************
   // Temparature monitor localparam
   //***************************************************************************
   localparam TEMP_MON_CONTROL      = "INTERNAL";
                                     // # = "INTERNAL"; "EXTERNAL"
      
   localparam RST_ACT_LOW           = 1;
                                     // =1 for active low reset;
                                     // =0 for active high.


  mig_7series_0 #
    (
     
     .TCQ                              (TCQ),
     .ADDR_CMD_MODE                    (ADDR_CMD_MODE),
     .AL                               (AL),
     .PAYLOAD_WIDTH                    (PAYLOAD_WIDTH),
     .BANK_WIDTH                       (BANK_WIDTH),
     .BURST_MODE                       (BURST_MODE),
     .BURST_TYPE                       (BURST_TYPE),
     .CA_MIRROR                        (CA_MIRROR),
     .VDD_OP_VOLT                      (VDD_OP_VOLT),
     .CK_WIDTH                         (CK_WIDTH),
     .COL_WIDTH                        (COL_WIDTH),
     .CMD_PIPE_PLUS1                   (CMD_PIPE_PLUS1),
     .CS_WIDTH                         (CS_WIDTH),
     .nCS_PER_RANK                     (nCS_PER_RANK),
     .CKE_WIDTH                        (CKE_WIDTH),
     .DATA_WIDTH                       (DATA_WIDTH),
     .DATA_BUF_ADDR_WIDTH              (DATA_BUF_ADDR_WIDTH),
     .DQ_CNT_WIDTH                     (DQ_CNT_WIDTH),
     .DQ_PER_DM                        (DQ_PER_DM),
     .DQ_WIDTH                         (DQ_WIDTH),
     .DQS_CNT_WIDTH                    (DQS_CNT_WIDTH),
     .DQS_WIDTH                        (DQS_WIDTH),
     .DRAM_WIDTH                       (DRAM_WIDTH),
     .ECC                              (ECC),
     .ECC_TEST                         (ECC_TEST),
     .nAL                              (nAL),
     .nBANK_MACHS                      (nBANK_MACHS),
     .CKE_ODT_AUX                      (CKE_ODT_AUX),
     .ORDERING                         (ORDERING),
     .OUTPUT_DRV                       (OUTPUT_DRV),
     .IBUF_LPWR_MODE                   (IBUF_LPWR_MODE),
     .DATA_IO_IDLE_PWRDWN              (DATA_IO_IDLE_PWRDWN),
     .BANK_TYPE                        (BANK_TYPE),
     .DATA_IO_PRIM_TYPE                (DATA_IO_PRIM_TYPE),
     .REG_CTRL                         (REG_CTRL),
     .RTT_NOM                          (RTT_NOM),
     .RTT_WR                           (RTT_WR),
     .CL                               (CL),
     .CWL                              (CWL),
     .tCKE                             (tCKE),
     .tFAW                             (tFAW),
     .tPRDI                            (tPRDI),
     .tRAS                             (tRAS),
     .tRCD                             (tRCD),
     .tREFI                            (tREFI),
     .tRFC                             (tRFC),
     .tRP                              (tRP),
     .tRRD                             (tRRD),
     .tRTP                             (tRTP),
     .tWTR                             (tWTR),
     .tZQI                             (tZQI),
     .tZQCS                            (tZQCS),
     .USER_REFRESH                     (USER_REFRESH),
     .WRLVL                            (WRLVL),
     .DEBUG_PORT                       (DEBUG_PORT),
     .RANKS                            (RANKS),
     .ODT_WIDTH                        (ODT_WIDTH),
     .ROW_WIDTH                        (ROW_WIDTH),
     .ADDR_WIDTH                       (ADDR_WIDTH),
     .SIM_BYPASS_INIT_CAL              (SIM_BYPASS_INIT_CAL),
     .SIMULATION                       (SIMULATION),
     .BYTE_LANES_B0                    (BYTE_LANES_B0),
     .BYTE_LANES_B1                    (BYTE_LANES_B1),
     .BYTE_LANES_B2                    (BYTE_LANES_B2),
     .BYTE_LANES_B3                    (BYTE_LANES_B3),
     .BYTE_LANES_B4                    (BYTE_LANES_B4),
     .DATA_CTL_B0                      (DATA_CTL_B0),
     .DATA_CTL_B1                      (DATA_CTL_B1),
     .DATA_CTL_B2                      (DATA_CTL_B2),
     .DATA_CTL_B3                      (DATA_CTL_B3),
     .DATA_CTL_B4                      (DATA_CTL_B4),
     .PHY_0_BITLANES                   (PHY_0_BITLANES),
     .PHY_1_BITLANES                   (PHY_1_BITLANES),
     .PHY_2_BITLANES                   (PHY_2_BITLANES),
     .CK_BYTE_MAP                      (CK_BYTE_MAP),
     .ADDR_MAP                         (ADDR_MAP),
     .BANK_MAP                         (BANK_MAP),
     .CAS_MAP                          (CAS_MAP),
     .CKE_ODT_BYTE_MAP                 (CKE_ODT_BYTE_MAP),
     .CKE_MAP                          (CKE_MAP),
     .ODT_MAP                          (ODT_MAP),
     .CS_MAP                           (CS_MAP),
     .PARITY_MAP                       (PARITY_MAP),
     .RAS_MAP                          (RAS_MAP),
     .WE_MAP                           (WE_MAP),
     .DQS_BYTE_MAP                     (DQS_BYTE_MAP),
     .DATA0_MAP                        (DATA0_MAP),
     .DATA1_MAP                        (DATA1_MAP),
     .DATA2_MAP                        (DATA2_MAP),
     .DATA3_MAP                        (DATA3_MAP),
     .DATA4_MAP                        (DATA4_MAP),
     .DATA5_MAP                        (DATA5_MAP),
     .DATA6_MAP                        (DATA6_MAP),
     .DATA7_MAP                        (DATA7_MAP),
     .DATA8_MAP                        (DATA8_MAP),
     .DATA9_MAP                        (DATA9_MAP),
     .DATA10_MAP                       (DATA10_MAP),
     .DATA11_MAP                       (DATA11_MAP),
     .DATA12_MAP                       (DATA12_MAP),
     .DATA13_MAP                       (DATA13_MAP),
     .DATA14_MAP                       (DATA14_MAP),
     .DATA15_MAP                       (DATA15_MAP),
     .DATA16_MAP                       (DATA16_MAP),
     .DATA17_MAP                       (DATA17_MAP),
     .MASK0_MAP                        (MASK0_MAP),
     .MASK1_MAP                        (MASK1_MAP),
     .CALIB_ROW_ADD                    (CALIB_ROW_ADD),
     .CALIB_COL_ADD                    (CALIB_COL_ADD),
     .CALIB_BA_ADD                     (CALIB_BA_ADD),
     .SLOT_0_CONFIG                    (SLOT_0_CONFIG),
     .SLOT_1_CONFIG                    (SLOT_1_CONFIG),
     .MEM_ADDR_ORDER                   (MEM_ADDR_ORDER),
     .USE_CS_PORT                      (USE_CS_PORT),
     .USE_DM_PORT                      (USE_DM_PORT),
     .USE_ODT_PORT                     (USE_ODT_PORT),
     .PHY_CONTROL_MASTER_BANK          (PHY_CONTROL_MASTER_BANK),
     .TEMP_MON_CONTROL                 (TEMP_MON_CONTROL),
      
     
     .DM_WIDTH                         (DM_WIDTH),
     
     .nCK_PER_CLK                      (nCK_PER_CLK),
     .tCK                              (tCK),
     .DIFF_TERM_SYSCLK                 (DIFF_TERM_SYSCLK),
     .CLKIN_PERIOD                     (CLKIN_PERIOD),
     .CLKFBOUT_MULT                    (CLKFBOUT_MULT),
     .DIVCLK_DIVIDE                    (DIVCLK_DIVIDE),
     .CLKOUT0_PHASE                    (CLKOUT0_PHASE),
     .CLKOUT0_DIVIDE                   (CLKOUT0_DIVIDE),
     .CLKOUT1_DIVIDE                   (CLKOUT1_DIVIDE),
     .CLKOUT2_DIVIDE                   (CLKOUT2_DIVIDE),
     .CLKOUT3_DIVIDE                   (CLKOUT3_DIVIDE),
     
     .UI_EXTRA_CLOCKS                 (UI_EXTRA_CLOCKS),
     .C_S_AXI_ID_WIDTH                 (C_S_AXI_ID_WIDTH),
     .C_S_AXI_ADDR_WIDTH               (C_S_AXI_ADDR_WIDTH),
     .C_S_AXI_DATA_WIDTH               (C_S_AXI_DATA_WIDTH),
     .C_MC_nCK_PER_CLK                 (C_MC_nCK_PER_CLK),
     .C_S_AXI_SUPPORTS_NARROW_BURST    (C_S_AXI_SUPPORTS_NARROW_BURST),
     .C_RD_WR_ARB_ALGORITHM            (C_RD_WR_ARB_ALGORITHM),
     .C_S_AXI_REG_EN0                  (C_S_AXI_REG_EN0),
     .C_S_AXI_REG_EN1                  (C_S_AXI_REG_EN1),
     .C_S_AXI_CTRL_ADDR_WIDTH          (C_S_AXI_CTRL_ADDR_WIDTH),
     .C_S_AXI_CTRL_DATA_WIDTH          (C_S_AXI_CTRL_DATA_WIDTH),
     .C_S_AXI_BASEADDR                 (C_S_AXI_BASEADDR),
     .C_ECC_ONOFF_RESET_VALUE          (C_ECC_ONOFF_RESET_VALUE),
     .C_ECC_CE_COUNTER_WIDTH           (C_ECC_CE_COUNTER_WIDTH),
      
     
     .SYSCLK_TYPE                      (SYSCLK_TYPE),
     .REFCLK_TYPE                      (REFCLK_TYPE),
     .SYS_RST_PORT                     (SYS_RST_PORT),
     .REFCLK_FREQ                      (REFCLK_FREQ),
     .DIFF_TERM_REFCLK                 (DIFF_TERM_REFCLK),
     .IODELAY_GRP                      (IODELAY_GRP),
      
     .CAL_WIDTH                        (CAL_WIDTH),
     .STARVE_LIMIT                     (STARVE_LIMIT),
     .DRAM_TYPE                        (DRAM_TYPE),
      
      
     .RST_ACT_LOW                      (RST_ACT_LOW)
     )
    u_mig_7series_0
      (
       
       
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
