`timescale  100 ps / 10 ps

module video_filter_PR (
            input reset,
            input clk,
            input active_pixel,
            input hsync_in,
            input vsync_in,
            input [7:0] r_in,
            input [7:0] g_in,
            input [7:0] b_in,
            output reg [7:0] r_out,
            output reg [7:0] g_out,
            output reg [7:0] b_out);

endmodule
