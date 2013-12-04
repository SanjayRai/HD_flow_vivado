Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
Library unisim;
use unisim.vcomponents.all;

entity video_filter_PR is
    port (
            reset : in std_logic;
            clk   : in std_logic;
            active_pixel : in std_logic;
            hsync_in : in std_logic;
            vsync_in : in std_logic;
            r_in : in integer range 0 to 255;
            g_in : in integer range 0 to 255;
            b_in : in integer range 0 to 255;
            r_out  : out integer range 0 to 255;
            g_out  : out integer range 0 to 255;
            b_out  : out integer range 0 to 255);
end entity video_filter_PR;

architecture arch_video_filter_PR of video_filter_PR is


component moving_average is
    generic (
                ORDER : integer := 3
            );
    port (
            clk : in std_logic;
            reset : in std_logic;
            data_in : in integer range 0 to 255; 
            data_out : out integer range 0 to 255 
        );
end component moving_average;

signal active_pixel_reg : std_logic := '0';
signal hsync_in_reg : std_logic := '0';
signal vsync_in_reg : std_logic := '0';
signal r_in_reg : integer range 0 to 255 := 0;
signal g_in_reg : integer range 0 to 255 := 0;
signal b_in_reg : integer range 0 to 255 := 0;
signal r_out_reg  : integer range 0 to 255 := 0;
signal g_out_reg  : integer range 0 to 255 := 0;
signal b_out_reg  : integer range 0 to 255 := 0;

signal mov_ave_reset : std_logic := '1';

begin
    proc_in_reg: process(clk)
    begin
        if (clk'event and clk = '1') then
            active_pixel_reg <= active_pixel;
            hsync_in_reg <= hsync_in;
            vsync_in_reg <= vsync_in;
            r_in_reg <= r_in;
            g_in_reg <= g_in;
            b_in_reg <= b_in;
        end if;
    end process;


------------------------------------------------------------------------------------

mov_ave_reset <= '1' when ((reset = '1') or (hsync_in_reg = '1') or (vsync_in_reg = '1')) else '0';

U_moving_ave_r: moving_average
    generic map (
                ORDER => 4
            )
    port map(
            clk  => clk,
            reset => mov_ave_reset, 
            data_in => r_in_reg,  
            data_out => r_out_reg 
        );

U_moving_ave_g: moving_average
    generic map (
                ORDER => 4
            )
    port map(
            clk  => clk,
            reset => mov_ave_reset, 
            data_in => g_in_reg,  
            data_out => g_out_reg 
        );

U_moving_ave_b: moving_average
    generic map (
                ORDER => 4
            )
    port map (
            clk  => clk,
            reset => mov_ave_reset, 
            data_in => b_in_reg,  
            data_out => b_out_reg 
        );



------------------------------------------------------------------------------------

    proc_out_reg: process(clk)
    begin
        if (clk'event and clk = '1') then
            r_out <= r_out_reg;
            g_out <= g_out_reg;
            b_out <= b_out_reg;
        end if;
    end process;
end architecture arch_video_filter_PR;

                


