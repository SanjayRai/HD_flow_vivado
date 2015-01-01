Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
Library unisim;
use unisim.vcomponents.all;

entity video_mux is
    port (
            reset : in std_logic;
            clk   : in std_logic;
            win_in : in std_logic;
            r_in_A : in integer range 0 to 255;
            g_in_A : in integer range 0 to 255;
            b_in_A : in integer range 0 to 255;
            r_in_B : in integer range 0 to 255;
            g_in_B : in integer range 0 to 255;
            b_in_B : in integer range 0 to 255;
            r_out  : out integer range 0 to 255;
            g_out  : out integer range 0 to 255;
            b_out  : out integer range 0 to 255);
end entity video_mux;

architecture arch_video_mux of video_mux is

begin
    proc_mux : process(clk)
    begin
        if (clk'event and clk = '1') then
            if (reset = '1') then
                r_out <= 0;
                g_out <= 0;
                b_out <= 0;
            else
                case win_in is
                    when '0' => 
                        r_out <= r_in_A;
                        g_out <= g_in_A;
                        b_out <= b_in_A;
                    when others =>
                        r_out <= r_in_B;
                        g_out <= g_in_B;
                        b_out <= b_in_B;
                end case;
            end if;
        end if;
    end process;
end architecture arch_video_mux;

                


