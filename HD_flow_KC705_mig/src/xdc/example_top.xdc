set_property IOSTANDARD LVCMOS18 [get_ports init_calib_complete]
set_property IOSTANDARD LVCMOS18 [get_ports sys_rst]
set_property IOSTANDARD LVCMOS18 [get_ports tg_compare_error]

set_property PACKAGE_PIN AE26 [get_ports tg_compare_error]
set_property PACKAGE_PIN AK21 [get_ports sys_rst]
set_property PACKAGE_PIN AE20 [get_ports init_calib_complete]

create_pblock pblock_u_mig_7series_ip_top
add_cells_to_pblock [get_pblocks pblock_u_mig_7series_ip_top] [get_cells -quiet [list u_mig_7series_ip_top]]
resize_pblock [get_pblocks pblock_u_mig_7series_ip_top] -add {SLICE_X114Y150:SLICE_X153Y0}
resize_pblock [get_pblocks pblock_u_mig_7series_ip_top] -add {RAMB18_X4Y0:RAMB18_X6Y59}
resize_pblock [get_pblocks pblock_u_mig_7series_ip_top] -add {RAMB36_X4Y0:RAMB36_X6Y29}
set_property EXCLUDE_PLACEMENT 1 [get_pblocks pblock_u_mig_7series_ip_top]

create_pblock pblock_u_mig_7series_ip_top_HD_pins
resize_pblock [get_pblocks pblock_u_mig_7series_ip_top] -add {SLICE_X114Y11:SLICE_X115Y144}
