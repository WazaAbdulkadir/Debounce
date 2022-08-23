# Debounce

In the following figure we could see switch bounce in digital logic: 

![](https://github.com/WazaAbdulkadir/Debounce/blob/main/images/debounce.jpg)

In digital circuits debounce is necessary for robustness. Because switch may not be really asserted or negated as in the above figure. It could be just bouncing. Our digital logic may detect these bounces as rising or falling edge. We should avoid from this situation.
To control this issue debounce logic could be add to RTL project. 

Debounce logic works as following: 
-	We introduce a timer to project.
-	Timer should be able to count until designated time 
-	We divide high and low logic to states as:
    o	Initial, zero, zero to one, one, and one to zero
        
        - Initial is initial state of the input signal. If it is zero we are moving to zero state. Else we are starting from state one. Assume initial state is zero.
        
        - We are moving from zero to one state if, rising edge detected. In this state timer enabled and if timer counts until designated time we are moving to state one.  
        - Reverse logic is applied to move from “one to zero” state and “zero” state
