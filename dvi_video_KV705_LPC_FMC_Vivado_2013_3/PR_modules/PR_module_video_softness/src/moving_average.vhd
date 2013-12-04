Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity moving_average is
    generic (
                ORDER : integer := 3
            );
    port (
            clk : in std_logic;
            reset : in std_logic;
            data_in : in integer range 0 to 255; 
            data_out : out integer range 0 to 255 
        );
end entity moving_average;

architecture arch_moving_average of moving_average is

constant SIZE : integer := 2**ORDER;
signal data_in_reg : integer range 0 to 255 := 0; 
signal i_acc_out : integer range -512 to 511 := 0; 
signal acc_out, scaled_out : integer range -((256*SIZE)) to ((256*SIZE)-1);

type pipe_move_ave_array is array (0 to (SIZE-1)) of integer range 0 to 255;
signal pipe_mov_ave : pipe_move_ave_array;

begin

    proc_in_out_reg: process(clk)
    begin
        if (clk'event and clk = '1') then
            if (reset = '1') then
                data_in_reg <= 0; 
                data_out <= 0;
            else
                data_in_reg <= data_in;
                data_out <= scaled_out;
            end if;
        end if;
    end process;

    proc_moving_ave : process(clk)
    begin
        if (clk'event and clk = '1') then
            if (reset = '1') then
                pipe_mov_ave <= (others => 0);
            else
                pipe_mov_ave(0) <= data_in_reg;
                for i in 1 to (SIZE -1) loop
                    pipe_mov_ave(i) <= pipe_mov_ave(i-1);
                end loop;
            end if;
        end if;
    end process;

    proc_acc: process(clk)
    begin
        if (clk'event and clk = '1') then
            if (reset = '1') then
                acc_out <= 0;
                scaled_out <= 0;
                i_acc_out <= 0;
            else
                i_acc_out <= (data_in_reg - pipe_mov_ave(SIZE-1));
                acc_out <= acc_out + i_acc_out;
                scaled_out <= acc_out/SIZE;
            end if;
        end if;
    end process;

end architecture arch_moving_average;



