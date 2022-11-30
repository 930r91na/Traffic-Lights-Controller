-- Decodificador BCD para display de leds.
library IEEE;
use IEEE.std_logic_1164.all;

entity display is
    port (
        a, b, c, d, e, f, g : out std_logic;
         x: inout std_logic_vector(2 downto 0)
    );
end entity;

architecture arch of display is
begin

    -- Decodificamos..
    process (x)
        variable auxVectOut : std_logic_vector (6 downto 0);
    begin

        -- Cargamos entradas al vector auxiliar.
 

        if    x = "000" then auxVectOut := "0001111"; -- 7
        elsif x = "001" then auxVectOut := "0100000"; -- 6
        elsif x = "010" then auxVectOut := "0100100"; -- 5
        elsif x = "011" then auxVectOut := "1001100"; -- 4
        elsif x = "100" then auxVectOut := "0000110"; -- 3
        elsif x = "101" then auxVectOut := "0010010"; -- 2
        elsif x = "110" then auxVectOut := "1001111"; -- 1
        elsif x = "111" then auxVectOut := "0000001"; -- 0
        end if;

        -- Cargamos salidas al vector auxiliar.
        a <= auxVectOut(6);
        b <= auxVectOut(5);
        c <= auxVectOut(4);
        d <= auxVectOut(3);
        e <= auxVectOut(2);
        f <= auxVectOut(1);
        g <= auxVectOut(0);

    end process;

end architecture;