--Controller of lights of the traffick light with green
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

Use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TL2states is
Port (
Tstate: in STD_LOGIC;
Lgreen: out STD_LOGIC;
Lred: out std_logic
); 
end TL2states;

architecture arch_TL2states of TL2states is  

begin
process(Tstate)
begin
if Tstate='1' then
Lgreen<='1';
Lred<='0';
else
Lgreen<='0';
Lred<='1';
end if;
end process;
end arch_TL2states;