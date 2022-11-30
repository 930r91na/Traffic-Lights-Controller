--Controller of lights of the traffick light with green, yellow, red and turn.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

Use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TL4states is
Port (
COUNT :in STD_LOGIC_VECTOR (3 downto 0);
Tstate: in STD_LOGIC;
TstateTurn: in STD_LOGIC;
Lgreen: out STD_LOGIC;
Lred: out STD_LOGIC;
Lyellow: out STD_LOGIC;
Lturn: out STD_LOGIC
);
end TL4states;

architecture arch_TL4states of TL4states is  

begin

--Lgreen<= (Tstate and (not COUNT(3))) or (Tstate and (not COUNT(0))) or (Tstate and (not COUNT(2)) and (not COUNT(1)));
--Lyellow<=((not Tstate )and(not COUNT(3))and(not COUNT(2))) or (Tstate and(COUNT(3))and(COUNT(2))and(COUNT(1))and(COUNT(0)));
--Lred<=((not Tstate) and COUNT(2))or((not Tstate) and COUNT(3));
Lturn<=TstateTurn;

--Lgreen<=(Tstate and (not COUNT(3))) or (Tstate and (not COUNT(2)) and COUNT(0)) or (Tstate and COUNT(3) and COUNT(2) and COUNT(1) and COUNT(0));
--Lyellow<=(Tstate and COUNT(3) and COUNT(2) and (not COUNT(1))) or ((Tstate and COUNT(3) and COUNT(2) and  (not COUNT(0)))) ;
--Lred<= not Tstate;

Lgreen<=(Tstate and (not COUNT(3))) or (Tstate and (not COUNT(2)) and COUNT(0));
--Lyellow<=(Tstate and COUNT(3) and COUNT(2));
--Lred<= not Tstate;
Lyellow<=(Tstate and COUNT(3) and COUNT(2) and (not COUNT(1))) or (Tstate and COUNT(3) and COUNT(2) and (not COUNT(0)));
Lred<= not Tstate or ( Tstate and COUNT(3) and COUNT(2) and COUNT(1) and COUNT(0));

end arch_TL4states;