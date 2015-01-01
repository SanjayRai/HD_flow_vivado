# Created : 13:18:43, Tue Oct 2, 2013 : Sanjay Rai

set DEVICE xc7k325tffg900-2
create_project project_X project_X -part $DEVICE

add_files -verbose {
../IP/clk_wiz/clk_wiz.xci
}
