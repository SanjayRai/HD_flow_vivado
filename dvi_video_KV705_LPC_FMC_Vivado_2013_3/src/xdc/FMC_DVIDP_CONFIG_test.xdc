# Created : 13:18:43, Tue Oct 2, 2012 : Sanjay Rai
set PRD 5.0
set PRD_2 [expr $PRD/2]
create_clock -period $PRD -name sys_clk -waveform "0 $PRD_2" [get_ports CLK_P]


set_property IOSTANDARD LVDS [get_ports {CLK_*}]

set_property PACKAGE_PIN AD12 [get_ports {CLK_P}]
set_property PACKAGE_PIN AD11 [get_ports {CLK_N}]
set_property PACKAGE_PIN L26 [get_ports {FAN_PWM}]
set_property IOSTANDARD LVCMOS25 [get_ports {FAN_PWM}]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

set_property IOSTANDARD LVCMOS25 [get_ports {fmc_power_good}]
set_property IOSTANDARD LVCMOS25 [get_ports {fmc_dvidp_*}]

###########################################
# FMC-DVIDP - I2C
###########################################
 #(LA09_N)
set_property PACKAGE_PIN  AK24 [get_ports { fmc_dvidp_i2c_scl}]  
 #(LA09_P)
set_property PACKAGE_PIN  AK23 [get_ports { fmc_dvidp_i2c_sda}] 
 #(LA12_P)
set_property PACKAGE_PIN  AA20 [get_ports { fmc_dvidp_i2c_rst}] 


set_property PACKAGE_PIN  H29 [get_ports { fmc_power_good}] 
 #(LA05_P)
set_property PACKAGE_PIN  AG22 [get_ports { fmc_dvidp_tp1}] 
 #(LA05_N)
set_property PACKAGE_PIN  AH22 [get_ports { fmc_dvidp_tp2}] 
 #(LA10_P)
set_property PACKAGE_PIN  AJ24 [get_ports { fmc_dvidp_tp3}] 

###########################################
# FMC-DVIDP - DVI Input
###########################################
create_clock -period 5.5 -name vid_clk -waveform "0 2.75" [get_ports fmc_dvidp_dvii_clk]
 #(LA17_CC_P)
set_property PACKAGE_PIN  AB27 [get_ports {fmc_dvidp_dvii_clk}]     
 #(LA10_N)
set_property PACKAGE_PIN  AK25 [get_ports {fmc_dvidp_dvii_de}]      
 #(LA12_N)
set_property PACKAGE_PIN  AB20 [get_ports {fmc_dvidp_dvii_vsync}]   
 #(LA11_P)
set_property PACKAGE_PIN  AE25 [get_ports {fmc_dvidp_dvii_hsync}]   
 #(LA25_P)
set_property PACKAGE_PIN  AC26 [get_ports {fmc_dvidp_dvii_blue[0]}] 
 #(LA21_N)
set_property PACKAGE_PIN  AG28 [get_ports {fmc_dvidp_dvii_blue[1]}] 
 #(LA26_P)
set_property PACKAGE_PIN  AK29 [get_ports {fmc_dvidp_dvii_blue[2]}] 
 #(LA27_P)
set_property PACKAGE_PIN  AJ28 [get_ports {fmc_dvidp_dvii_blue[3]}] 
 #(LA23_N)
set_property PACKAGE_PIN  AH27 [get_ports {fmc_dvidp_dvii_blue[4]}] 
 #(LA22_N)
set_property PACKAGE_PIN  AK28 [get_ports {fmc_dvidp_dvii_blue[5]}] 
 #(LA22_P)
set_property PACKAGE_PIN  AJ27 [get_ports {fmc_dvidp_dvii_blue[6]}] 
 #(LA21_P)
set_property PACKAGE_PIN  AG27 [get_ports {fmc_dvidp_dvii_blue[7]}] 
 #(LA19_N)
set_property PACKAGE_PIN  AK26 [get_ports {fmc_dvidp_dvii_green[0]}]
 #(LA23_P)
set_property PACKAGE_PIN  AH26 [get_ports {fmc_dvidp_dvii_green[1]}]
 #(LA18_CC_P)
set_property PACKAGE_PIN AD27  [get_ports {fmc_dvidp_dvii_green[2]}]
 #(LA17_CC_N)
set_property PACKAGE_PIN AC27  [get_ports {fmc_dvidp_dvii_green[3]}]
 #(LA20_N)
set_property PACKAGE_PIN  AF27 [get_ports {fmc_dvidp_dvii_green[4]}]
 #(LA20_P)
set_property PACKAGE_PIN  AF26 [get_ports {fmc_dvidp_dvii_green[5]}]
 #(LA19_P)
set_property PACKAGE_PIN  AJ26 [get_ports {fmc_dvidp_dvii_green[6]}]
 #(LA15_N)
set_property PACKAGE_PIN  AD24 [get_ports {fmc_dvidp_dvii_green[7]}]
 #(LA15_P)
set_property PACKAGE_PIN  AC24 [get_ports {fmc_dvidp_dvii_red[0]}]  
 #(LA16_N)
set_property PACKAGE_PIN  AD22 [get_ports {fmc_dvidp_dvii_red[1]}]  
 #(LA14_N)
set_property PACKAGE_PIN  AE21 [get_ports {fmc_dvidp_dvii_red[2]}]  
 #(LA14_P)
set_property PACKAGE_PIN  AD21 [get_ports {fmc_dvidp_dvii_red[3]}]  
 #(LA13_N)
set_property PACKAGE_PIN  AC25 [get_ports {fmc_dvidp_dvii_red[4]}]  
 #(LA16_P)
set_property PACKAGE_PIN  AC22 [get_ports {fmc_dvidp_dvii_red[5]}]  
 #(LA11_N)
set_property PACKAGE_PIN  AF25 [get_ports {fmc_dvidp_dvii_red[6]}]  
 #(LA13_P)
set_property PACKAGE_PIN  AB24 [get_ports {fmc_dvidp_dvii_red[7]}]  
###########################################
# FMC-DVIDP - DVI Output
###########################################
# FMC1 - C23 (LA18_N_CC)
set_property PACKAGE_PIN AD28 [get_ports {fmc_dvidp_dvio_clk}]          
# FMC1 - G37 (LA33_N)
set_property PACKAGE_PIN AC30  [get_ports {fmc_dvidp_dvio_reset_n}]      
# FMC1 - H35 (LA30_N)
set_property PACKAGE_PIN AB30  [get_ports {fmc_dvidp_dvio_de}]           
# FMC1 - G36 (LA33_P)
set_property PACKAGE_PIN AC29  [get_ports {fmc_dvidp_dvio_vsync}]        
# FMC1 - H37 (LA32_P)
set_property PACKAGE_PIN Y30  [get_ports {fmc_dvidp_dvio_hsync}]        
# FMC1 - G34 (LA31_N)
set_property PACKAGE_PIN AE29  [get_ports {fmc_dvidp_dvio_data[0]}]      
# FMC1 - G33 (LA31_P)
set_property PACKAGE_PIN AD29  [get_ports {fmc_dvidp_dvio_data[1]}]      
# FMC1 - H34 (LA30_P)
set_property PACKAGE_PIN AB29  [get_ports {fmc_dvidp_dvio_data[2]}]      
# FMC1 - H32 (LA28_N)
set_property PACKAGE_PIN AF30  [get_ports {fmc_dvidp_dvio_data[3]}]      
# FMC1 - G31 (LA29_N)
set_property PACKAGE_PIN AF28  [get_ports {fmc_dvidp_dvio_data[4]}]      
# FMC1 - G30 (LA29_P)
set_property PACKAGE_PIN AE28  [get_ports {fmc_dvidp_dvio_data[5]}]      
# FMC1 - H31 (LA28_P)
set_property PACKAGE_PIN AE30  [get_ports {fmc_dvidp_dvio_data[6]}]      
# FMC1 - H29 (LA24_N)
set_property PACKAGE_PIN AH30  [get_ports {fmc_dvidp_dvio_data[7]}]      
# FMC1 - H28 (LA24_P)
set_property PACKAGE_PIN AG30  [get_ports {fmc_dvidp_dvio_data[8]}]      
# FMC1 - G28 (LA25_N)
set_property PACKAGE_PIN AD26  [get_ports {fmc_dvidp_dvio_data[9]}]      
# FMC1 - C27 (LA27_N)
set_property PACKAGE_PIN AJ29  [get_ports {fmc_dvidp_dvio_data[10]}]     
# FMC1 - D27 (LA26_N)
set_property PACKAGE_PIN AK30  [get_ports {fmc_dvidp_dvio_data[11]}]     

# Bank  18 VCCO - VADJ_FPGA - IO_0_18 (Senter Push button)
set_property PACKAGE_PIN G12 [get_ports {reset_pin}]
set_property IOSTANDARD LVCMOS25 [get_ports {reset_pin}]

# Place dvii inputs into IO registers.
set_property IOB TRUE [get_ports fmc_dvidp_dvii_*]

create_pblock pblock_U_PR_A
add_cells_to_pblock pblock_U_PR_A [get_cells U_PR_A]
resize_pblock [get_pblocks pblock_U_PR_A] -add {SLICE_X36Y50:SLICE_X79Y99}
resize_pblock [get_pblocks pblock_U_PR_A] -add {DSP48_X2Y20:DSP48_X2Y39}
resize_pblock [get_pblocks pblock_U_PR_A] -add {RAMB18_X2Y20:RAMB18_X2Y39}
resize_pblock [get_pblocks pblock_U_PR_A] -add {RAMB36_X2Y10:RAMB36_X2Y19}
set_property HD.PARTPIN_RANGE {SLICE_X36Y50:SLICE_X37Y74} [get_pins U_PR_A/*]
set_property CONTAIN_ROUTING true [get_pblocks pblock_U_PR_A]

create_pblock pblock_U_PR_B
add_cells_to_pblock pblock_U_PR_B [get_cells U_PR_B]
resize_pblock [get_pblocks pblock_U_PR_B] -add {SLICE_X36Y0:SLICE_X79Y49}
resize_pblock [get_pblocks pblock_U_PR_B] -add {DSP48_X2Y0:DSP48_X2Y19}
resize_pblock [get_pblocks pblock_U_PR_B] -add {RAMB18_X2Y0:RAMB18_X2Y19}
resize_pblock [get_pblocks pblock_U_PR_B] -add {RAMB36_X2Y0:RAMB36_X2Y9}
set_property HD.PARTPIN_RANGE {SLICE_X36Y25:SLICE_X37Y49} [get_pins U_PR_B/*]
set_property CONTAIN_ROUTING true [get_pblocks pblock_U_PR_B]


# All BUFG will need LOC's for HD flow. hd_floorplan TCL script writes these LOCS as HD.CLK_SRC into the *_ooc_timing.xdc file
set_property LOC BUFGCTRL_X0Y0 [get_cells U_bufg_video_clk]
set_property LOC BUFGCTRL_X0Y1 [get_cells instance_name/inst/clkout1_buf]
set_property LOC BUFGCTRL_X0Y2 [get_cells instance_name/inst/clkf_buf]
