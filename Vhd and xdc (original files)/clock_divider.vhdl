library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Clock_Divider is 
port (clk,reset: in std_logic;
clock_out1: inout std_logic;
clock_out2: inout std_logic;
clock_out3: inout std_logic);
end Clock_Divider; 

architecture bhv of Clock_Divider is 
signal count: integer:=1;
signal count1: integer:=1;
signal count2: integer:=1;
signal tmp2 : std_logic := '0'; 
signal tmp1 : std_logic := '0'; 
signal tmp : std_logic := '0'; 
begin 
process(clk,reset) 
begin 
if(reset='1') then 
count<=1;
tmp<='0';
elsif(rising_edge(clk)) then count <=count+1;
if (count = 24400000) then
tmp <= NOT tmp;
count <= 1;
end if;
end if;
clock_out2 <= tmp;
end process; 

process(clk,reset) 
begin 
if(reset='1') then 
count2<=1;
tmp2<='0';
elsif(rising_edge(clk)) then count2 <=count2+1;
if (count2 = 48400000) then
tmp2 <= NOT tmp2;
count2 <= 1;
end if;
end if;
clock_out3 <= tmp2;
end process; 

process(clock_out2,reset) 
begin 
if(reset='1') then 
count1<=1;tmp1<='0';
elsif(falling_edge(clock_out2)) then count1 <=count1+1;
if (count1= 2)then 
tmp1 <= NOT tmp1;
count1 <= 1;
end if;
end if;
clock_out1 <= tmp1;
end process; 

end bhv;