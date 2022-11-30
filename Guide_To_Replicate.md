# Project Traffic-Lights-Controller

This document is a guide to replicate a cruise in which is controll the Traffic Lights in a cruise.

The purpose of this project was to design, build and demonstrate the correct functioning of a traffic light cruise where cars, bicycles and pedestrians could interact without any troublesome, which meant no accidents or confusions for users

<!Image of finished project>
<img src="https://user-images.githubusercontent.com/93169706/204583413-05c93751-8418-4080-a862-bc4307ead1fb.jpg" width="200">

# Table of Contents
1. [1st STEP: ESTABLISH THE LOGIC OF THE TRAFFIC LIGHTS AND THE CRUISE](#one)
2. [2nd STEP: Establish the VHDL Design](#two)
3. [3rd STEP: Coding Components](#tre)
4. [4rd STEP: Unite Code ](#fou)
5. [5th STEP: Testing](#fiv)
6. [6th STEP: Implementig](#six)
7. [Extra: Mock-up](#ext)


## 1st STEP: ESTABLISH THE LOGIC OF THE TRAFFIC LIGHTS AND THE CRUISE <a name="one"></a>

>Note: The logic of the traffic lights and the cruise are different!!

### Logic of traffic lights:

- Identify the types of traffic lights that exist, how they work and its properties.
* Identify the number of states that has each type of traffic light (TL).
  * Those will be you outputs.
In this case were identified two types
- For cars:
  - Four states red/yellow/green/turn(on/off).
  - They change so that it is green, then the green blinks, it goes to yellow and then it goes to red, and from this state it goes directly to green.
  - The turn state is on when the cars are permited to turn and is off when not.
- For bikes and pedestrians: 
  - Two states red/green.
  - Green is that they are allowed to pass red is that they are not.
  
    <img src="https://user-images.githubusercontent.com/93169706/204663605-5d81a6ab-2a22-4e13-9484-fd755c7e11fc.jpg" width="200">

### Logic of the cruise:
To stablish the logic of the cruise you need to identify the relation between the traffic lights. This means to check that when the pedestrians of x street are passig, who should not to avoid accidents.

This can depend on the distribution of the rails of the cruise in interest. In this case it was stablished according to the following image.
<img src="https://user-images.githubusercontent.com/93169706/204575703-367b9495-d4b5-4141-a686-dd1acc255d37.png" width="600">


Then it was created a table calles strict ceros that represent the relationship between the TL.
<img src="https://user-images.githubusercontent.com/93169706/204583461-a0ff4477-a446-4595-a83c-3157b76f671d.png" width="800">


From that table it can be easily selected combination of states that avoid accidents.
<img src="https://user-images.githubusercontent.com/93169706/204583471-89f76a2d-336a-448e-a91f-3a7845e9ec9f.png" width="800">


In this case were selected the four combinations in which it was priorized that all the TL were at least at one moment on (allowed to pass) and using the combinaions that had more cars invloved because the flow of cars is greater than the pedestrians or bikes.


## 2nd STEP: Establish the VHDL Design <a name="two"></a>

The design established is in structural. There ia a controller for all the TL is the part when it changes from state to state or combination to combination. The second is a controller of the inner lights of a TL in case of the 2 states, green is on when 1 and red when 0, it is direct. But in the four state TL is needed a inner clock that coordinate the changes and the blink. Finally with those main components there is the next sketch of the relationship from input and outputs.

The following sketches gave the basic form of how it were gonna be interconnected the components also their inputs and outputs.

This sketch represents the interconnection of all the component the main box is the principal file were it is going to be called each component

<img src="https://user-images.githubusercontent.com/93169706/204663630-3f1ebabe-fbc7-4e58-b796-d9b3e708342a.jpg" width="400">

Here are Identified the components
  - Main Design 
  * Principal Controller (times called: 1)
  + Clock Divider (times called: 1)
  * Clock to 4 bits counter (times called: 2)
  * Clock to 3 bits counter (times called: 1)
  * TL2 states (times called: 7)
  + TL4 states (times called: 3)
  * BCD to 7segment display (times called: 1)
 
The zoom to the main parts:
<img src="https://user-images.githubusercontent.com/93169706/204663638-2e99fe0e-a2d4-41a8-be62-541ed657d5fc.jpg" width="400">

In this it can be seen that the TL2 state is unrequired because the output is mainly the input, and so that component is unnecesary.


## 3rd STEP: Coding Components <a name="tre"></a>

### Create Individual Components

Create each of the previous identified components
>Here are only the main parts of each code, to see all the code go to the complete folder

#### Clock Divider (times called: 1)
It is needed the following libraries to make the count that will divde
```
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
```

Here are declared the 3 used clock as outputs and the main clk as input.
```
entity Clock_Divider is 
port (clk,reset: in std_logic;
clock_out1: inout std_logic;
clock_out2: inout std_logic;
clock_out3: inout std_logic);
end Clock_Divider; 
```
Creation of auxiliar to divide the clock for each one
```
architecture bhv of Clock_Divider is 
--Use different auxiliars for each clk
signal count: integer:=1;
signal count1: integer:=1;
signal count2: integer:=1;
signal tmp2 : std_logic := '0'; 
signal tmp1 : std_logic := '0'; 
signal tmp : std_logic := '0'; 

```
CLOCK 2 Needed for the change of red, yellow and green inside a TL
```
begin 
--clock_out2 (for TL4 state)
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
```
CLOCK 3 Used for the display of the counter in regression
```
--clock_out3 (for display)
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
```
CLOCK 1 To change the states
```
--clock_out1 (for Principal controller)
--This depends from the clock_out2 and its relation is two (never changes)
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
```

#### Clock to 4 bits counter (times called: 2)
Input clock-> output a counter of 4 bits 
This is used to create the necessary combinations to change the states

```
process (COUNT,CLK,RST)
begin

if(RST='1')then 
COUNT<="0000";
elsif(rising_edge(CLK))then
COUNT <= COUNT+1;

end if;
end process;
```

#### Clock to 3 bits counter (times called: 1)
Input clock-> output a counter of 3 bits 
This is used to create the regression of the counter (7.6..5...4....3.....)


```
process (COUNT,CLK,RST)--para secuenciales procesos secuenciales solo las entradas
begin

if(RST='1')then 
COUNT<="000";
elsif(rising_edge(CLK))then
COUNT <= COUNT+1;

end if;
end process;
```

#### Principal Controller (times called: 1)
There is four states because it was used the relationship of a 4 bit counter created by the clock and the decision taken in the design.
```
process(COUNT)
  begin
  --Here is assigned the choosen combinations given by the table of stricted zeros
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
```
![statespcontroller](https://user-images.githubusercontent.com/93169706/204672199-22537bef-db8d-40d5-af22-19aaa88e621b.png)

#### TL4 states (times called: 3)

For the change of the states is needed as a input a counter made by Clock_out2, Tstate and TstateTurn which are the output of the principal conroller.
```
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
```

Given that it was created a truth table and from each output is is get the simplified function that are assigned.

![t4sta](https://user-images.githubusercontent.com/93169706/204676725-64b3e3ad-8662-41bc-b70d-fa4e53891540.png)

```
architecture arch_TL4states of TL4states is  
begin

--STATES ACCORDING TO SIMP.FUNCTIONS BY KARNAUGH MAPS
Lturn<=TstateTurn;
Lgreen<=(Tstate and (not COUNT(3))) or (Tstate and (not COUNT(2)) and COUNT(0));--Function G
Lyellow<=(Tstate and COUNT(3) and COUNT(2) and (not COUNT(1))) or (Tstate and COUNT(3) and COUNT(2) and (not COUNT(0)));--Function Y
Lred<= not Tstate or ( Tstate and COUNT(3) and COUNT(2) and COUNT(1) and COUNT(0)); --Function R

end arch_TL4states;
```

#### BCD to 7segment display (times called: 1)

The assigned outputs are the required for a display and he input is the counter of 3 bits created by the Clock_out3
```
entity display is
    port (
        a, b, c, d, e, f, g : out std_logic;--8 outputs as display requires
         x: inout std_logic_vector(2 downto 0)-- vector of counter 3 bits
    );
end entity;

```

The values associated with the counter are the opposite so it counts from 7 to 0

```
architecture arch of display is
begin
    -- Decode
    process (x)
        variable auxVectOut : std_logic_vector (6 downto 0);
    begin

        --It is assigned in decrease so it is a regresive counter
        if    x = "000" then auxVectOut := "0001111"; -- 7
        elsif x = "001" then auxVectOut := "0100000"; -- 6
        elsif x = "010" then auxVectOut := "0100100"; -- 5
        elsif x = "011" then auxVectOut := "1001100"; -- 4
        elsif x = "100" then auxVectOut := "0000110"; -- 3
        elsif x = "101" then auxVectOut := "0010010"; -- 2
        elsif x = "110" then auxVectOut := "1001111"; -- 1
        elsif x = "111" then auxVectOut := "0000001"; -- 0
        end if;
...
```
 
## 4rd STEP: Unite Code <a name="fou"></a>

With all the components ready the final step is to unite everything at the main vhdl file

First it will be declared the inputs which is only the main clock and its reset

```
--Declared i/o
entity Main is
Port (
--INPUT
--Clock
CLK,RST : in STD_LOGIC;
```
The outputs for each light as it is needed for the mockup
```
--OUTPUT
--Outputs for pedestrians
P113: out STD_LOGIC;
P213: out STD_LOGIC;
P124: out STD_LOGIC;
P224: out STD_LOGIC;
P113N: out STD_LOGIC;
P213N: out STD_LOGIC;
P124N: out STD_LOGIC;
P224N: out STD_LOGIC;
--Outputs for cars
C11green:out STD_LOGIC;
C11red:out STD_LOGIC;
C11yellow:out STD_LOGIC;
C21turn:out STD_LOGIC;
C12green:out STD_LOGIC;
C12red:out STD_LOGIC;
C12yellow:out STD_LOGIC;
C32turn:out STD_LOGIC;
C14green:out STD_LOGIC;
C14red:out STD_LOGIC;
C14yellow:out STD_LOGIC;
C24turn:out STD_LOGIC;
--Outputs for BIKES
B11:out STD_LOGIC;
B14:out STD_LOGIC;
B12:out STD_LOGIC;

```
Outputs for the display
```
--display
a1, b1, c1, d1, e1, f1, g1 : out std_logic;
activation, not_activation :out std_logic;
RSTL: in std_logic
);--vector de 4 
end Main;
```

Create the intermedary signals
```
architecture arch_Main of Main is  
--signals
signal CLK_1, CLK_2,CLK_3 : STD_LOGIC;
signal COUNT_controller : STD_LOGIC_VECTOR (3 downto 0);
signal COUNT_lights : STD_LOGIC_VECTOR (3 downto 0);
signal TP :  STD_LOGIC_VECTOR (3 downto 0);
signal TC :  STD_LOGIC_VECTOR (5 downto 0);
signal TB :  STD_LOGIC_VECTOR (2 downto 0);
signal temp :  STD_LOGIC_VECTOR (2 downto 0);

```
Calling each component
```
component Clock_Divider is 
Port ( clk,reset: in std_logic;
clock_out1: inout std_logic;
clock_out2: inout std_logic;
clock_out3: inout std_logic);
end component; 

--components
component SOURCE is
Port (CLK,RST : in STD_LOGIC;
COUNT :inout STD_LOGIC_VECTOR (3 downto 0)
);--vector de 4 
end component;

component Controller is
Port (
COUNT :in STD_LOGIC_VECTOR (3 downto 0);
TP : out std_logic_vector (3 downto 0);
TC : out std_logic_vector (5 downto 0);
TB : out std_logic_vector (2 downto 0)
); 
end component;

component TL4states is
Port (
COUNT :in STD_LOGIC_VECTOR (3 downto 0);
Tstate: in STD_LOGIC;
TstateTurn: in STD_LOGIC;
Lgreen: out STD_LOGIC;
Lred: out STD_LOGIC;
Lyellow: out STD_LOGIC;
Lturn: out std_logic
);
end component;

COMPONENT COUNTERD is
Port (CLK,RST : in STD_LOGIC;
COUNT :inout STD_LOGIC_VECTOR (2 downto 0)
);--vector de 3 
end COMPONENT;

COMPONENT display is
    port (
        a, b, c, d, e, f, g : out std_logic;
         x: inout std_logic_vector(2 downto 0)
    );
end COMPONENT;
```
Connecting the components

To use the display
```
begin
--display
activation <='0';
not_activation <='1';
```
Creation of the 3 clocks
```
U7: Clock_Divider port map(clk=>CLK,reset=>RST,clock_out1=>CLK_1,clock_out2=>CLK_2, clock_out3=>CLK_3);
```
Generation of two counters 
```
U1: SOURCE port map(CLK=>CLK_1,RST=>RST,COUNT=>COUNT_controller);
U2: SOURCE port map(CLK=>CLK_2,RST=>RST,COUNT=>COUNT_lights);
```

Principal Controller assignation
```
U3: Controller port map(COUNT=>COUNT_controller,TP=>TP,TC=>TC,TB=>TB);
```
The following assignations works as the TL2 states components
```
P113<=TP(3);
P213<=TP(2);
P124<=TP(1);
P224<=TP(0);
P113N<=not TP(3);
P213N<=not TP(2);
P124N<=not TP(1);
P224N<=not TP(0);
B11<= TB(2);
B14<= TB(0);
B12<= TB(1);

```
TL4 States assignation
```
U4: TL4states port map (COUNT=>COUNT_lights,Tstate=>TC(5),TstateTurn=>TC(4),Lgreen=>C11green,Lred=>C11red,Lyellow=>C11yellow,Lturn=>C21turn);
U5: TL4states port map(COUNT=>COUNT_lights,Tstate=>TC(3),TstateTurn=>TC(2),Lgreen=>C12green,Lred=>C12red,Lyellow=>C12yellow,Lturn=>C32turn);
U6: TL4states port map(COUNT=>COUNT_lights,Tstate=>TC(1),TstateTurn=>TC(0),Lgreen=>C14green,Lred=>C14red,Lyellow=>C14yellow,Lturn=>C24turn);
```
Display
```
--7SEGMENTDISPLAY
U8: COUNTERD port map (CLK=>CLK_3,RST=>RSTL,COUNT=>temp);
U9: display port map (a=>a1,b=>b1,c=>c1,d=>d1,e=>e1,f=>f1,g=>g1,x=>temp);
end arch_Main;
```

## 5th STEP: Testing <a name="fiv"></a>
### Testbench Code
```
```


## 6th STEP: Implementig <a name="six"></a>

## Extra: Mock-up <a name="ext"></a>
### 7th STEP: 





![maqueta terminada 2](https://user-images.githubusercontent.com/93169706/204583490-dc14ea5f-824b-4307-b178-f5c2a085b111.jpg)
<!![reloj](https://user-images.githubusercontent.com/93169706/204583514-d01c59f2-2551-43bf-9f53-a704f049d8de.png)>
