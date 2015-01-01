
`timescale 1ns/100fs

module test_patterns (
    input reset,
    input clk,
    input active_pixel,
    input hsync_in,
    input vsync_in,
    output reg [7:0] r_out,
    output reg [7:0] g_out,
    output reg [7:0] b_out);

reg [11:0] ramp = 12'd0;

always @ (posedge clk)
begin
    if (reset)
        ramp <= 8'd0;
    else if (hsync_in)
        ramp <= 8'd0;
    else
        ramp <= ramp + 1;

end

always @ (posedge clk)
begin
    r_out <= ramp[10:3];
    g_out <= ramp[10:3];
    b_out <= ramp[10:3];
end

endmodule
