// File fmc_dvidp_dvi_out_conv.vhd translated with vhd2vl v2.0 VHDL to Verilog RTL translator
// Copyright (C) 2001 Vincenzo Liguori - Ocean Logic Pty Ltd - http://www.ocean-logic.com
// Modifications (C) 2006 Mark Gonzales - PMC Sierra Inc
// 
// vhd2vl comes with ABSOLUTELY NO WARRANTY
// ALWAYS RUN A FORMAL VERIFICATION TOOL TO COMPARE VHDL INPUT TO VERILOG OUTPUT 
// 
// This is free software, and you are welcome to redistribute it under certain conditions.
// See the license file license.txt included with the source for details.

//----------------------------------------------------------------
//      _____
//     /     \
//    /____   \____
//   / \===\   \==/
//  /___\===\___\/  AVNET
//       \======/
//        \====/    
//---------------------------------------------------------------
//
// This design is the property of Avnet.  Publication of this
// design is not authorized without written consent from Avnet.
// 
// Please direct any questions to:  technical.support@avnet.com
//
// Disclaimer:
//    Avnet, Inc. makes no warranty for the use of this code or design.
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
//    any errors, which may appear in this code, nor does it make a commitment
//    to update the information contained herein. Avnet, Inc specifically
//    disclaims any implied warranties of fitness for a particular purpose.
//                     Copyright(c) 2010 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------
//
// Create Date:         Nov 11, 2009
// Design Name:         FMC-DVIDP
// Module Name:         fmc_dvidp_dvi_out.vhd
// Project Name:        FMC-DVIDP
// Target Devices:      Spartan-6
// Avnet Boards:        FMC-DVIDP
//
// Tool versions:       ISE 11.4
//
// Description:         FMC-DVIDP DVI output interface.
//                      Based on VSK dvi_out.vhd and modified as follows:
//                      - rename dvi_out to fmc_dvidp_dvi_out
//                      - replace dvi_clk_p/dvi_clk_n by single-ended dvi_clk
//                      - add support for more devices via C_FAMILY generic:
//                         - spartan6
//
// Dependencies:        
//
// Revision:            Nov 11, 2009: 1.00 Initial version
//                      Dec 09, 2009: 1.01 Add a second set of regs
//                                         Add an output enable port
//
//----------------------------------------------------------------
// DISCLAIMER OF LIABILITY
// 
// This text/file contains proprietary, confidential
// information of Xilinx, Inc., is distributed under license
// from Xilinx, Inc., and may be used, copied and/or
// disclosed only pursuant to the terms of a valid license
// agreement with Xilinx, Inc. Xilinx hereby grants you a 
// license to use this text/file solely for design, simulation, 
// implementation and creation of design files limited 
// to Xilinx devices or technologies. Use with non-Xilinx 
// devices or technologies is expressly prohibited and 
// immediately terminates your license unless covered by
// a separate agreement.
//
// Xilinx is providing this design, code, or information 
// "as-is" solely for use in developing programs and 
// solutions for Xilinx devices, with no obligation on the 
// part of Xilinx to provide support. By providing this design, 
// code, or information as one possible implementation of 
// this feature, application or standard, Xilinx is making no 
// representation that this implementation is free from any 
// claims of infringement. You are responsible for 
// obtaining any rights you may require for your implementation. 
// Xilinx expressly disclaims any warranty whatsoever with 
// respect to the adequacy of the implementation, including 
// but not limited to any warranties or representations that this
// implementation is free from claims of infringement, implied 
// warranties of merchantability or fitness for a particular 
// purpose.
//
// Xilinx products are not intended for use in life support
// appliances, devices, or systems. Use in such applications is
// expressly prohibited.
//
// Any modifications that are made to the Source Code are 
// done at the user’s sole risk and will be unsupported.
//
//
// Copyright (c) 2007, 2008 Xilinx, Inc. All rights reserved.
//
// This copyright and support notice must be retained as part 
// of this text at all times. 
//
//----------------------------------------------------------------------------
// Filename            : dvi_out.vhd
// $Revision:: 2433   $: Revision of last commit
// $Date:: 2008-05-27#$: Date of last commit
// Description         : DVI Output Hardware Interface
//----------------------------------------------------------------------------
//-- Uncomment the following library declaration if instantiating
//-- any Xilinx primitives in this code.
//library UNISIM;
//use UNISIM.VComponents.all;

module fmc_dvidp_dvi_out(
    input clk,
    input reset,
    input ce,
    input oe,
    input de_i,
    input vsync_i,
    input hsync_i,
    input[7:0] red_i,
    input[7:0] green_i,
    input[7:0] blue_i,
    output dvi_de,
    output dvi_vsync,
    output dvi_hsync,
    output[11:0] dvi_data,
    output dvi_clk,
    output dvi_reset_n
);

reg  de_r;
reg  vsync_r;
reg  hsync_r;
reg [7:0] red_r;
reg [7:0] green_r;
reg [7:0] blue_r;
wire [11:0] d1;
wire [11:0] d2;
wire [11:0] d2_r;
wire  oe_n;
reg  dvi_de_o;
reg  dvi_vsync_o;
reg  dvi_hsync_o;
wire [11:0] dvi_data_o;
wire  dvi_clk_o;
wire  dvi_reset_n_o;
reg  dvi_de_t;
reg  dvi_vsync_t;
reg  dvi_hsync_t;
wire [11:0] dvi_data_t;
wire  dvi_clk_t;
wire  dvi_reset_n_t;

  assign dvi_reset_n_o =  ~reset;
  assign dvi_reset_n_t =  ~oe;
  always @(posedge clk) begin
    de_r <= de_i;
    vsync_r <= vsync_i;
    hsync_r <= hsync_i;
    red_r <= red_i;
    green_r <= green_i;
    blue_r <= blue_i;
  end

  assign d1 = {green_r[3:0] ,blue_r};
  assign d2 = {red_r,green_r[7:4] };
  assign oe_n =  ~oe;
  always @(posedge clk) begin
    dvi_de_o <= de_r;
    dvi_vsync_o <= vsync_r;
    dvi_hsync_o <= hsync_r;
    //
    dvi_de_t <= oe_n;
    dvi_vsync_t <= oe_n;
    dvi_hsync_t <= oe_n;
  end

  genvar I;
  generate for (I=0; I <= 11; I = I + 1)
  begin : O1
    ODDR # (
       .DDR_CLK_EDGE("SAME_EDGE"))
    ODDR_dvi_data_o(
      .Q(dvi_data_o[I] ),
      .C(clk),
      .CE(1'b1),
      .D1(d1[I] ),
      .D2(d2[I] ),
      .R(1'b0),
      .S(1'b0));
  end
  endgenerate

  ODDR #(
    .DDR_CLK_EDGE("SAME_EDGE"))
  ODDR_dvi_clk_o(
    .Q(dvi_clk_o),
    .C(clk),
    .CE(1'b1),
    .D1(1'b0),
    .D2(1'b1),
    .R(1'b0),
    .S(1'b0));

  generate for (I=0; I <= 11; I = I + 1)
  begin : T1
    ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"))
    ODDR_dvi_data_t(
      .Q(dvi_data_t[I] ),
      .C(clk),
      .CE(1'b1),
      .D1(oe_n),
      .D2(oe_n),
      .R(1'b0),
      .S(1'b0));
  end
  endgenerate

  ODDR #(
    .DDR_CLK_EDGE("SAME_EDGE"))
  ODDR_dvi_clk_t(
    .Q(dvi_clk_t),
    .C(clk),
    .CE(1'b1),
    .D1(oe_n),
    .D2(oe_n),
    .R(1'b0),
    .S(1'b0));

  //
  // Tri-stateable outputs
  //    Can be used to disable outputs to FMC connector
  //    until FMC module is correctly identified.
  // 
  
  OBUFT OBUFT_dvi_de(
      .O(dvi_de),
    .I(dvi_de_o),
    .T(dvi_de_t));

  OBUFT OBUFT_dvi_vsync(
      .O(dvi_vsync),
    .I(dvi_vsync_o),
    .T(dvi_vsync_t));

  OBUFT OBUFT_dvi_hsync(
      .O(dvi_hsync),
    .I(dvi_hsync_o),
    .T(dvi_hsync_t));

  generate for (I=0; I <= 11; I = I + 1)
  begin : IO1
      OBUFT OBUFT_dvi_data(
          .O(dvi_data[I] ),
      .I(dvi_data_o[I] ),
      .T(dvi_data_t[I] ));

  end
  endgenerate
  
  OBUFT OBUFT_dvi_clk(
      .O(dvi_clk),
    .I(dvi_clk_o),
    .T(dvi_clk_t));

  OBUFT OBUFT_dvi_reset_n(
      .O(dvi_reset_n),
    .I(dvi_reset_n_o),
    .T(dvi_reset_n_t));


endmodule
