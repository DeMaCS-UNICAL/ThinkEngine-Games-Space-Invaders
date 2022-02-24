step(0..1000).
multFire(1..250).
multMove(1..500).
applyAction(T,"FireAction"):- step(T), multFire(M), T=M*4.
applyAction(T,"MoveAction"):- step(T), not applyAction(T,"FireAction").
argumentAction(T,move,left):- applyAction(T,"MoveAction"), multMove(M), T=M*2.
argumentAction(T,move,right):- applyAction(T,"MoveAction"), not argumentAction(T,move,left).
#show argumentAction/3.