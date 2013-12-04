Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
Library unisim;
use unisim.vcomponents.all;

entity window is
    generic (
        X0 : integer := 100;
        Y0 : integer := 60;
        Xn : integer := 500;
        Yn : integer := 300);
    port (
        reset : in std_logic;
        clk   : in std_logic;
        hsync : in std_logic;
        vsync : in std_logic;
        win_out : out std_logic);
end entity window;

architecture arch_window of window is

signal h_pulse, i0_hsync, i1_hsync : std_logic := '0';
signal v_pulse, i0_vsync, i1_vsync : std_logic := '0';
signal h_range, v_range : std_logic := '0';
signal h_count, v_count : integer range 0 to 4095 := 0;

begin

proc_edge_det: process(clk)
begin
    if (clk'event and clk = '1') then
        if (reset = '1') then
            i0_hsync <= '0';
            i1_hsync <= '0';
            i0_vsync <= '0';
            i1_vsync <= '0';
        else
            i0_hsync <= hsync;
            i1_hsync <= i0_hsync;
            i0_vsync <= vsync;
            i1_vsync <= i0_vsync;
        end if;
    end if;
end process;

h_pulse <= (i0_hsync and not(i1_hsync));
v_pulse <= (i0_vsync and not(i1_vsync));

proc_window : process (clk)
begin
    if (clk'event and clk = '1') then
        if (reset = '1') then
            win_out <= '0';
        elsif (h_range = '1') and (v_range = '1') then
            win_out <= '1';
        else
            win_out <= '0';
        end if;
    end if;
end process;

prov_h_range : process (clk)
begin
    if (clk'event and clk = '1') then
        if (reset = '1') then
            h_count <= 0;
            h_range <= '0';
            v_range <= '0';
        else
            if (h_pulse = '1') then
                h_count <= 0;
            else
                h_count <= h_count + 1;
            end if;

            if (v_pulse = '1') then
                v_count <= 0;
            elsif (h_pulse = '1') then
                v_count <= v_count + 1;
            end if;

            if ((h_count > X0) and (h_count < Xn)) then
                h_range <= '1';
            else
                h_range <= '0';
            end if;
            if ((v_count > Y0) and (v_count < Yn)) then
                v_range <= '1';
            else
                v_range <= '0';
            end if;
        end if;

    end if;
end process;


end architecture arch_window;

