
module fmc_dvidp_dvi_in(
    input clk,
    input ce,
    input de,
    input vsync,
    input hsync,
    input[7:0] red,
    input[7:0] green,
    input[7:0] blue,
    output reg de_o,
    output reg vsync_o,
    output reg hsync_o,
    output reg [7:0] red_o,
    output reg [7:0] green_o,
    output reg [7:0] blue_o
);


reg  de_r;
reg  vsync_r;
reg  hsync_r;
reg [7:0] red_r;
reg [7:0] green_r;
reg [7:0] blue_r;

  always @(posedge clk) begin
    de_r <= de;
    vsync_r <= vsync;
    hsync_r <= hsync;
    red_r <= red;
    green_r <= green;
    blue_r <= blue;
  end

  always @(posedge clk) begin
    de_o <= de_r;
    vsync_o <= vsync_r;
    hsync_o <= hsync_r;
    red_o <= red_r;
    green_o <= green_r;
    blue_o <= blue_r;
  end


endmodule
