// Created : 13:18:43, Tue Oct 2, 2012 : Sanjay Rai

`timescale 1ns/100fs

module FMC_DVIDP_CONFIG_test ( 
    input CLK_P,
    input CLK_N,
    input reset_pin,
    // FMC-DVI/DP : I2C Controller
    output fmc_dvidp_i2c_scl,
    inout  fmc_dvidp_i2c_sda,
    output fmc_dvidp_i2c_rst,
    
    // FMC-DVI/DP : DVI Input Interface
    input fmc_dvidp_dvii_clk,
    input fmc_dvidp_dvii_de,
    input fmc_dvidp_dvii_vsync,
    input fmc_dvidp_dvii_hsync,
    input[7:0] fmc_dvidp_dvii_red,
    input[7:0] fmc_dvidp_dvii_green,
    input[7:0] fmc_dvidp_dvii_blue,
    
    // FMC-DVI/DP : DVI Output Interface
    output fmc_dvidp_dvio_reset_n,
    output fmc_dvidp_dvio_clk,
    output fmc_dvidp_dvio_de,
    output fmc_dvidp_dvio_vsync,
    output fmc_dvidp_dvio_hsync,
    output[11:0] fmc_dvidp_dvio_data,

    // FMC-DVI/DP Misc. SIgnals
    output fmc_power_good,
    output fmc_dvidp_tp1,
    output fmc_dvidp_tp2,
    output fmc_dvidp_tp3,

    output FAN_PWM);

wire CLK_50Mhz;

wire RESET_IN;
wire SDA_OUT;

wire sda_en_n;
wire sda_in;
wire pb_reset_out;
wire scl_out;

wire vid_clk;
wire i_bufg_vid_clk;

wire  dvii_de;
wire  dvii_vsync;
wire  dvii_hsync;
wire [7:0] dvii_red;
wire [7:0] dvii_green;
wire [7:0] dvii_blue;

reg  i_fmc_dvidp_dvii_de;
reg  i_fmc_dvidp_dvii_vsync;
reg  i_fmc_dvidp_dvii_hsync;
reg [7:0] i_fmc_dvidp_dvii_red;
reg [7:0] i_fmc_dvidp_dvii_green;
reg [7:0] i_fmc_dvidp_dvii_blue;

wire  i_fmc_dvidp_dvio_de;
wire  i_fmc_dvidp_dvio_vsync;
wire  i_fmc_dvidp_dvio_hsync;
wire [7:0] i_fmc_dvidp_dvio_red;
wire [7:0] i_fmc_dvidp_dvio_green;
wire [7:0] i_fmc_dvidp_dvio_blue;

reg [7:0] i_dvio_de;
reg [7:0] i_dvio_hsync;
reg [7:0] i_dvio_vsync;

reg [7:0] i_dvio_r [0:7];
reg [7:0] i_dvio_g [0:7];
reg [7:0] i_dvio_b [0:7];

wire [7:0] bypass_dvio_r;
wire [7:0] bypass_dvio_g;
wire [7:0] bypass_dvio_b;

wire [7:0] r_out_PR_A;
wire [7:0] g_out_PR_A;
wire [7:0] b_out_PR_A;

wire [7:0] r_out_PR_B;
wire [7:0] g_out_PR_B;
wire [7:0] b_out_PR_B;

wire [7:0] r_out_TP;
wire [7:0] g_out_TP;
wire [7:0] b_out_TP;

wire o_fmc_dvidp_dvio_reset_n;
wire o_fmc_dvidp_dvio_clk;
wire o_fmc_dvidp_dvio_de;
wire o_fmc_dvidp_dvio_vsync;
wire o_fmc_dvidp_dvio_hsync;
wire [11:0] o_fmc_dvidp_dvio_data;

wire i_r_win; 
wire i_g_win; 
wire i_b_win;

wire PLL_LOCKED;

reg i0_de, i1_de;
reg i0_vsync, i1_vsync;
reg i0_hsync, i1_hsync;

wire window_out;

integer i;


assign FAN_PWM = 1'b1;
assign fmc_power_good = 1'b1;
assign fmc_dvidp_tp1 = 1'b0;
assign fmc_dvidp_tp2 = 1'b0;
assign fmc_dvidp_tp3 = 1'b0;

  clk_wiz instance_name
   (
   // Clock in ports
    .mmcm_clk_in_p(CLK_P),    // input mmcm_clk_in_p
    .mmcm_clk_in_n(CLK_N),    // input mmcm_clk_in_n
    // Clock out ports
    .clk_out_50Mhz(CLK_50Mhz),     // output clk_out_50Mhz
    // Status and control signals
    .mmcm_reset_in(reset_pin),// input mmcm_reset_in
    .mmcm_locked_out(PLL_LOCKED));      // output mmcm_locked_out

  // ********************************************************************************************
  // __SRAI (Instations below are required for OOC / HD implementations since
  // BUFG in vid_clk case are not infered at the top level)
  IBUFG U_ibufg_video_clk (
    .I(fmc_dvidp_dvii_clk),
    .O(i_bufg_vid_clk));

  BUFG U_bufg_video_clk (
    .I(i_bufg_vid_clk),
    .O(vid_clk));
  // ********************************************************************************************

  fmc_dvidp_dvi_in U_fmc_dvidp_dvi_in (
    .clk(vid_clk),
    .ce(1'b1),
    .de(fmc_dvidp_dvii_de),
    .vsync(fmc_dvidp_dvii_vsync),
    .hsync(fmc_dvidp_dvii_hsync),
    .red(fmc_dvidp_dvii_red),
    .green(fmc_dvidp_dvii_green),
    .blue(fmc_dvidp_dvii_blue),
    .de_o(dvii_de),
    .vsync_o(dvii_vsync),
    .hsync_o(dvii_hsync),
    .red_o(dvii_red),
    .green_o(dvii_green),
    .blue_o(dvii_blue));

always @(posedge vid_clk)
    begin
        i_fmc_dvidp_dvii_de <= dvii_de;
        i_fmc_dvidp_dvii_vsync <= dvii_vsync;
        i_fmc_dvidp_dvii_hsync <= dvii_hsync;
        i_fmc_dvidp_dvii_red <= dvii_red;
        i_fmc_dvidp_dvii_green <= dvii_green;
        i_fmc_dvidp_dvii_blue <= dvii_blue;
    end

(* dont_touch = "true" *)video_filter_PR U_PR_A (
            .reset(RESET_IN),
            .clk(vid_clk),
            .active_pixel(i_fmc_dvidp_dvii_de),
            .hsync_in(i_fmc_dvidp_dvii_hsync),
            .vsync_in(i_fmc_dvidp_dvii_vsync),
            .r_in(i_fmc_dvidp_dvii_red),
            .g_in(i_fmc_dvidp_dvii_green),
            .b_in(i_fmc_dvidp_dvii_blue),
            .r_out(r_out_PR_A),
            .g_out(g_out_PR_A),
            .b_out(b_out_PR_A));

(* dont_touch = "true" *)video_filter_PR U_PR_B (
            .reset(RESET_IN),
            .clk(vid_clk),
            .active_pixel(i_fmc_dvidp_dvii_de),
            .hsync_in(i_fmc_dvidp_dvii_hsync),
            .vsync_in(i_fmc_dvidp_dvii_vsync),
            .r_in(i_fmc_dvidp_dvii_red),
            .g_in(i_fmc_dvidp_dvii_green),
            .b_in(i_fmc_dvidp_dvii_blue),
            .r_out(r_out_PR_B),
            .g_out(g_out_PR_B),
            .b_out(b_out_PR_B));

always @ (posedge vid_clk)
begin
    i_dvio_de <= {i_dvio_de[6:0], i_fmc_dvidp_dvii_de};
    i_dvio_hsync <= {i_dvio_hsync[6:0], i_fmc_dvidp_dvii_hsync};
    i_dvio_vsync <= {i_dvio_vsync[6:0], i_fmc_dvidp_dvii_vsync};
    i_dvio_r[0] <= i_fmc_dvidp_dvii_red;
    i_dvio_g[0] <= i_fmc_dvidp_dvii_green;
    i_dvio_b[0] <= i_fmc_dvidp_dvii_blue;
    for (i = 1 ; i < 8; i = i+1)
    begin
        i_dvio_r[i] <= i_dvio_r[i-1];
        i_dvio_g[i] <= i_dvio_g[i-1];
        i_dvio_b[i] <= i_dvio_b[i-1];
    end
end

assign bypass_dvio_r = i_dvio_r[4];
assign bypass_dvio_g = i_dvio_g[4];
assign bypass_dvio_b = i_dvio_b[4];

assign i_fmc_dvidp_dvio_de = i_dvio_de[4];
assign i_fmc_dvidp_dvio_hsync = i_dvio_hsync[4];
assign i_fmc_dvidp_dvio_vsync = i_dvio_vsync[4];

//assign i_fmc_dvidp_dvio_red = (window_out ? r_out_PR_A : bypass_dvio_r);
//assign i_fmc_dvidp_dvio_green = (window_out ? g_out_PR_A : bypass_dvio_g);
//assign i_fmc_dvidp_dvio_blue = (window_out ? b_out_PR_A : bypass_dvio_b);

assign i_fmc_dvidp_dvio_red = (window_out ? r_out_PR_A : r_out_PR_B);
assign i_fmc_dvidp_dvio_green = (window_out ? g_out_PR_A : g_out_PR_B);
assign i_fmc_dvidp_dvio_blue = (window_out ? b_out_PR_A : b_out_PR_B);

  fmc_dvidp_dvi_out U_fmc_dvidp_dvi_out (
    .clk(vid_clk),
    .reset(RESET_IN),
    .ce(1'b1),
    .oe(1'b1),
    .de_i(i_fmc_dvidp_dvio_de),
    .vsync_i(i_fmc_dvidp_dvio_vsync),
    .hsync_i(i_fmc_dvidp_dvio_hsync),
    .red_i(i_fmc_dvidp_dvio_red),
    .green_i(i_fmc_dvidp_dvio_green),
    .blue_i(i_fmc_dvidp_dvio_blue),
    .dvi_de(o_fmc_dvidp_dvio_de),
    .dvi_vsync(o_fmc_dvidp_dvio_vsync),
    .dvi_hsync(o_fmc_dvidp_dvio_hsync),
    .dvi_data(o_fmc_dvidp_dvio_data),
    .dvi_clk(o_fmc_dvidp_dvio_clk),
    .dvi_reset_n(o_fmc_dvidp_dvio_reset_n));

    assign fmc_dvidp_dvio_reset_n = o_fmc_dvidp_dvio_reset_n;
    assign fmc_dvidp_dvio_clk = o_fmc_dvidp_dvio_clk;
    assign fmc_dvidp_dvio_de = o_fmc_dvidp_dvio_de;
    assign fmc_dvidp_dvio_vsync = o_fmc_dvidp_dvio_vsync;
    assign fmc_dvidp_dvio_hsync = o_fmc_dvidp_dvio_hsync;
    assign fmc_dvidp_dvio_data = o_fmc_dvidp_dvio_data;


    FMC_DVIDP_CONFIG UUT (
            .RESET_IN(RESET_IN), 
            .CLK(CLK_50Mhz), 
            .DIPSW_IN(8'h00),
            .PUSHB_IN(4'h0),
            .RESET_OUT(pb_reset_out),
            .SCL_OUT(scl_out),
            .SDA_OUT(sda_en_n),
            .SDA_IN(sda_in)
        );

  assign fmc_dvidp_i2c_rst =  ~pb_reset_out;
  assign fmc_dvidp_i2c_scl = scl_out;

  assign sda_out = 1'b0;
  IOBUF i2c_sda_iobuf(
    .IO(fmc_dvidp_i2c_sda),
    .I(sda_out),
    .T(sda_en_n),
    .O(sda_in));



always @( posedge vid_clk)
begin
    i0_de <= dvii_de;
    i1_de <= i0_de;
    i0_vsync <= dvii_vsync;
    i1_vsync <= i0_vsync;
    i0_hsync <= dvii_hsync;
    i1_hsync <= i0_hsync;
end

window # (
        .X0(500),
        .Y0(200),
        .Xn(1400),
        .Yn(800))
    u_window (
        .reset(RESET_IN),
        .clk(vid_clk),
        .hsync(i0_de),
        .vsync(i0_vsync),
        .win_out (window_out));
assign RESET_IN = ~PLL_LOCKED; 

test_patterns  U_test_patterns_gen (
    .reset(RESET_IN),
    .clk(vid_clk),
    .active_pixel(i0_de),
    .hsync_in(i0_hsync),
    .vsync_in(i0_vsync),
    .r_out(r_out_TP),
    .g_out(g_out_TP),
    .b_out(b_out_TP));


endmodule

        


