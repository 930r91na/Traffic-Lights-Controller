# Project Traffic-Lights-Controller

This document is a guide to replicate a cruise in which is controll the Traffic Lights in a cruise.

The purpose of this project was to design, build and demonstrate the correct functioning of a traffic light cruise where cars, bicycles and pedestrians could interact without any troublesome, which meant no accidents or confusions for users

<!Image of finished project>
<img src="https://user-images.githubusercontent.com/93169706/204583413-05c93751-8418-4080-a862-bc4307ead1fb.jpg" width="200">


## 1st STEP: ESTABLISH THE LOGIC OF THE TRAFFIC LIGHTS AND THE CRUISE
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


## 2nd STEP: Establish the VHDL Design 

The design established is in structural. There ia a controller for all the TL is the part when it changes from state to state or combination to combination. The second is a controller of the inner lights of a TL in case of the 2 states, green is on when 1 and red when 0, it is direct. But in the four state TL is needed a inner clock that coordinate the changes and the blink. Finally with those main components there is the next sketch of the relationship from input and outputs.

The following sketches gave the basic form of how it were gonna be interconnected the components also their inputs and outputs.

This sketch represents the interconnection of all the component the main box is the principal file were it is going to be called each component

<img src="https://user-images.githubusercontent.com/93169706/204663630-3f1ebabe-fbc7-4e58-b796-d9b3e708342a.jpg" width="400">

Here are Identified the components
  - Main Design 
  * Principal Controller (times called: 1)
  + Clock Divider (times called: 3)
  * Clock to 4 bits counter (times called: 2)
  * Clock to 3 bits counter (times called: 1)
  * TL2 states (times called: 7)
  + TL4 states (times called: 3)
  * BCD to 7segment display (times called: 1)
 
The zoom to the main parts:
<img src="https://user-images.githubusercontent.com/93169706/204663638-2e99fe0e-a2d4-41a8-be62-541ed657d5fc.jpg" width="400">

In this it can be seen that the TL2 state is unrequired because the output is mainly the input, and so that component is unnecesary.


## 3rd STEP: Codig

```

```

## 4th STEP: Testing

## 5th STEP: Implementig

## Extra: Mock-up
### 6th STEP: 





![maqueta terminada 2](https://user-images.githubusercontent.com/93169706/204583490-dc14ea5f-824b-4307-b178-f5c2a085b111.jpg)
<!![reloj](https://user-images.githubusercontent.com/93169706/204583514-d01c59f2-2551-43bf-9f53-a704f049d8de.png)>
