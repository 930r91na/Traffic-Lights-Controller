library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

Use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Controller is
Port (
COUNT :in STD_LOGIC_VECTOR (3 downto 0);
TP : out std_logic_vector (3 downto 0);
TC : out std_logic_vector (5 downto 0);
TB : out std_logic_vector (2 downto 0)
); 
end Controller;

architecture arch_Controller of Controller is  

begin

process(COUNT)
  begin
  if(COUNT(3)='0' and COUNT(2)='0') then
  TP <= "0010"; TC <= "011010"; TB <= "001";
  elsif (COUNT(3)='0' and COUNT(2)='1') then
  TP <= "1000"; TC <= "110001"; TB <= "000";
  elsif (COUNT(3)='1' and COUNT(2)='0') then
  TP <= "0001"; TC <= "001101"; TB <= "010";
  elsif (COUNT(3)='1' and COUNT(2)='1') then
  TP <= "0100"; TC <= "100100"; TB <= "100";
  else 
  TP <= "1111"; TC <= "111111"; TB <= "111";
  end if;
end process;
  
end arch_Controller;