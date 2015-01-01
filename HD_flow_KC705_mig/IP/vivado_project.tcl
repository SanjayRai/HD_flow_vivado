# Created : 13:18:43, Tue Oct 2, 2012 : Sanjay Rai

set DEVICE xc7k325tffg900-2
create_project project_X project_X -part $DEVICE

add_files -verbose {
    ./mig_7series_0/mig_7series_0.xci
}

