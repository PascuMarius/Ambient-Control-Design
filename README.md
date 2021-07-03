# Ambient-Control-Design

## Summary of DUT functionalities
###### 1. It becomes active at the touch of a button, and inactive the next time it is pressed;
###### 2. Receives data from temperature humidity and brightness sensors;
###### 3. Depending on the values received from the sensors, different devices are closed or opened;
###### 4. Upon receiving the reset signal, the DUT outputs change to 0.

## DUT ports
![Table](https://i.imgur.com/RzNLLx7.png)

## Finit State Machine
![FSM](https://i.imgur.com/GpfCju5.png)

## Design implemented with ready before valid protocol
![Protocol](https://i.imgur.com/PNPNNcW.png)
