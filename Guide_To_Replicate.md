# Project Traffic-Lights-Controller

This document is a *guide to replicate* a cruise in which it is controlled the Traffic Lights for bikes pedestrians and cars.

The purpose of this project is to design, build and demonstrate the correct functioning of a traffic light cruise where cars, bicycles and pedestrians could interact without any troublesome, which means no accidents or confusions for the users.

<!Image of finished project>
<img src="https://user-images.githubusercontent.com/93169706/204583413-05c93751-8418-4080-a862-bc4307ead1fb.jpg" width="200">

# Table of Contents <a name="zero"></a>
1. [1st STEP: Establish the logic of traffic lights and the cruise](#one)
2. [2nd STEP: Establish the VHDL Design](#two)
3. [3rd STEP: Coding Components](#tre)
4. [4th STEP: Unite Code ](#fou)
6. [5th STEP: Testing](#fiv)
7. [6th STEP: Implementig](#six)
8. [Extra: Mock-up](#ext)


## 1st STEP: Establish the logic of traffic lights and the cruise <a name="one"></a>

>Note: The logic of the traffic lights and the cruise are different!!

### Logic of traffic lights:

- Identify the types of traffic lights that exist, how they work and its properties.
* Identify the number of states that has each type of traffic light (TL).
  * Those will be you outputs.
In this case it was identified two types
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


Then it was created a **table called strict ceros** that represent the relationship between the TL.
<img src="https://user-images.githubusercontent.com/93169706/204583461-a0ff4477-a446-4595-a83c-3157b76f671d.png" width="800">


From that table it can be easily selected n combination of states that avoid accidents.
<img src="https://user-images.githubusercontent.com/93169706/204583471-89f76a2d-336a-448e-a91f-3a7845e9ec9f.png" width="800">


In this case were selected the four combinations in which it was priorized that all the TL were at least at one moment on (allowed to pass) and using the combinaions that had more cars invloved because the flow of cars is greater than the pedestrians or bikes in the context of the cruise.

[Return to Table of Contents](#zero)
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

[Return to Table of Contents](#zero)

## 3rd STEP: Coding Components <a name="tre"></a>

### Create Individual Components

Create each of the previous identified components
>Here are only the main parts of each code, to see all the code go to the complete folder

#### Clock Divider (times called: 1)
It is needed the following libraries to make the count that will divde.
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
Creation of auxiliar to divide the clock for each one.
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

The inside of the component with the functions is the following

![MicrosoftTeams-image (4)](https://user-images.githubusercontent.com/93169706/204679950-153277e8-2195-4d99-acb3-69ded9845413.png)


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
[Return to Table of Contents](#zero)
 
## 4th STEP: Unite Code <a name="fou"></a>

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

### The schematic
The schematic of the components is the following:


<img src="https://user-images.githubusercontent.com/93169706/204679453-b38c05a2-0094-45d4-885b-c1c07010ce78.png" width="900">
Here is clearly seen the inputs, outputs, components ah how everything is interwined.

[Return to Table of Contents](#zero)

## 5th STEP: Testing <a name="fiv"></a>
### Testbench Code

As the inputs are only two reset and a clock for the tesbench is only needed to simulate the clk and assign the resets to the default value given in the code
```
signal CLK ,RST, RSTL : STD_LOGIC :='1';
begin

uut: Main port map(
CLK => CLK,
RST=>RST,
RSTL=>RSTL);
clock: process

begin
RST <='0';
RSTL<= '0';
CLK <= '1';
wait for 5 ns;

CLK <= '0';
wait for 5 ns;
end process;
end tb;
```

The simulation can be seen in the following image
![MicrosoftTeams-image (5)](https://user-images.githubusercontent.com/93169706/204680019-0d43d1f7-3243-4c4a-982b-5126d3317622.png)
And it is seen how succefully the transitions are made in the 2 and 4 states TL

[Return to Table of Contents](#zero)

## 6th STEP: Implementig <a name="six"></a>
### Technical sepcifications
For the implementation it was used a Digilent Basys 3™ Artix-7 FPGA Trainer Board and the Vivado software

![fpga](https://user-images.githubusercontent.com/93169706/204681745-cf15b3b1-3c38-451b-8504-94f1d45a3c06.png)

Since Vivado can support several hardware description languajes, it is important to set it to VHDL on the settings window, located on the top left corner once you enter the workspace on Vivado. Also, make sure to check the box to generate a bin file.

For the Vivado software a Master xdc file is needed, these are basically the rules of the outputs and inputs given by your code to the basys. This is added as a constrain file. VHDL files that are part of the traffic light's design must be added as a source file to Vivado.
Check the complete master code [here](./TXT_version_files/master.txt)
Also to use the FPGA correctly it was useful the official manual of the FPGA check it [here](https://digilent.com/reference/programmable-logic/basys-3/reference-manual).

```
## Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK]
	set_property IOSTANDARD LVCMOS33 [get_ports CLK]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]
```

After declaring each physical input and output (each on an individual port of the basys), the program needs to run a synthesis, in a way, this means that Vivado will verifyt the accuracy of the code and, in this case, that each vhdl file is declared on the main one (since it was made on an structural aproach). IF there's any syntax mistake on any of the codes, Vivado will let you know by interrupting the synthesis process. After the synthesis is done, the next process is running the implementation, after waitng a while, a new window will appear; select the option Generate Bitstream. This is the time where the FPGA must be connected. Once the generation is completed, you can now close the window.

On the top of the screen there should be a green bar stating that "No hardware target is open", select Open Targent and then the code corresponding to the Basys 3, this way, Vivado will detect the FPGA and will be ready for any further instruction. On the right menu (Flow Navigator), look for the Program Device on the section "Program and Debug", once you click on this option, the FPGA will be programed with the codes on Vivado.

The whole implementation process needs to be ran everytime there's a change on any xdc or vhdl file, this way, we make sure that the newest and error-free version of our desing is being tested on the FPGA. A red message in the top right corner of the screeen stating "Implementation Out-of-date" will appear each time the implementation needs to be updated. Please be patient with the processes, since the whole implementation process usually takes more than 5 minutes to complete.

For more information about the implementation process on Artix-7 FPGA, please refere to [this link](https://docs.xilinx.com/r/en-US/ug949-vivado-design-methodology/Design-Implementation)

Also the tests were made using leds, as it can be seen in the next video:

https://user-images.githubusercontent.com/93169706/204967388-1761579a-dc66-4a0f-9218-e145b20e93a1.mp4


### JUST WTF with the FPGA CLOCK?
The FPGA clock has a frequency of 10000 Mhz 
Before, anything it were made tests of the frequency and what it was needed to use the FPGA clk. Therefore here you can [acces](./Extra_Tests/CLK) the vivado file of that unique segment.


https://user-images.githubusercontent.com/93169706/204967063-afad114b-449f-4d43-8769-16b62753f7b4.mp4



### DEBUGGING

The next warnings were really frequent when designing the traffic light's controller project, here's a quick review on how to solve them or what can be causing the problem:

* Failed synthesis with no syntax mistakes: There sould be an extra source automatically created by Vivado and the extension is dcp, to eliminate this critital warning, delete this file.

* Syntax error near...: There should be miswritten word, a missing character (. , ; ' ") or too many subsequential characters.

* WARNING: No ports matched... or CRITICAL WARNING: (Common 17-55) 'set_property' expects at least one object: Every input and output should be specified on the Master xdc file, if not all of them are explicity declared and with the name expressed on the VHDL files, this warning will come up.

* Combinatorial Loop Alert: This means some data is serving as a feedback, meaning that is an output and an input at the same time when it is only declared as one. Solutions include using keywords "buffer" or "inout" or, as it happened in this project, changing the conditions of counters, since this warning came up when we accidentally created an "infinite" counter.

[Return to Table of Contents](#zero)

## Extra: Mock-up <a name="ext"></a>
### Materials
* Red, yellow and green LED lights
* 3D printer 
* Resistors for every LED lights
* Welding plate 
* Welding kit
* Wooden planks 
* UTP cables
* Laser cutter
* Spray paint and glue
* MDF wood

### 

The main base of the mock-up was a 60x60 cms mdf wooden square, aditionally, rectangles were also obtained with the laser cutter; this was done to obtained a box-like base so that the cables and FPGA would be inside of it. All of the wooden pieces were glued with white glue, specifically the one labeled as useful for gluing wood, for arts and crafts.

The painting on the surface was done with spray paint, masking tape and white paint markers. The shapes and ground illustrations were made accoring to the original reference picture. Remember always use glue and spray paint on a opened and well ventilated space, preferably, combine it with self-protection equipment such as gloves, face masks and glasses.

As for the traffic lights, they were 3D printed; the front part (the one with holes for the corresponding LED lights) was attached to the pole; after the LED lights were placed and the cable was conducted into and out of the pole, the other half of the traffic light cabin was glued with fast drying glue. 

All of the cables that came from the LED lights were welded into a welding plate, where resistors for each individual LED light were also welded and therefore connected.For organization purposes, each cable corresponding to an LED light was welded to headers to make an easier connection with the PMOD ports on the Basys 3. After labeling each traffic light and checking, according to the Master xdc file, where each connection should be, the headers went into their corresponding ports.

![maqueta terminada 2](https://user-images.githubusercontent.com/93169706/204583490-dc14ea5f-824b-4307-b178-f5c2a085b111.jpg)

Also the used display was the FPGA one but for esthetic purposes  we recommend use an exernal one. For that keep in count that the FPGA display is of common anode, so it works with 0 (led on), 1 (led off). So if you use of common cathode you will need to change the BCD to 7segment display component.
And also using a external one you can avoid the outputs of activation wich are only necesaary for the FPGA display. Here is an image of the counter working.

<!![reloj](https://user-images.githubusercontent.com/93169706/204583514-d01c59f2-2551-43bf-9f53-a704f049d8de.png)>



https://user-images.githubusercontent.com/93169706/204967805-b91eac43-b0cf-4fd7-85d0-5406f2e4bc53.mp4


[Return to Table of Contents](#zero)

# THE END
Hope that this was of Help!!! :)
