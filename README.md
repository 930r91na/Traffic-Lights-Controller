# Project Traffic-Lights-Controller

This document is a guide to replicate a cruise in which is controll the Traffic Lights in a cruise.

The purpose of this project was to design, build and demonstrate the correct functioning of a traffic light cruise where cars, bicycles and pedestrians could interact without any troublesome, which meant no accidents or confusions for users

<!Image of finished project>


## 1st STEP: ESTABLISH THE LOGIC OF THE TRAFFIC LIGHTS AND THE CRUISE
>Note: The logic of the traffic lights and the cruise are different!!

### Logic of traffic lights:

- Identify the types of traffic lights that exist, how they work and its properties.
* Identify the number of states that has each type of traffic light (TL)

In this case were identified two types
- For cars:
  - Four states red/yellow/green/turn(on/off)
  - They change so that it is green, then the green blinks, it goes to yellow and then it goes to red, and from this state it goes directly to green
  - The turn state is on when the cars are permited to turn and is off when not
- For bikes and pedestrians: 
  - Two states red/green
  - Green is that they are allowed to pass red is that they are not

### Logic of the cruise:
To stablish the logic of the cruise you need to identify the relation between the traffic lights. This means to check that when the pedestrians of x street are passig, who should not to avoid accidents.

This can depend on the distribution of the rails of the cruise in interest. In this case it was stablished according to the following image.
![street](https://user-images.githubusercontent.com/93169706/204575703-367b9495-d4b5-4141-a686-dd1acc255d37.png)

Then it was created a table calles strict ceros that represent the relationship between the TL


Note 

Acording to the 


## CLOCK 

```

```
