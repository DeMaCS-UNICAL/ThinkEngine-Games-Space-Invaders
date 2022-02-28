%(0,1)(1,2)(2,3)(3,4)
possibleMove(left).
possibleMove(right).
max(N):-plannerSensor(planner,objectIndex(Index),planLenghtGenerator(n(N))).

number(0..1000).
even(0).
even(N):-even(N1), N=N1+2, N<=M, max(M).

step(N1):- number(N1), N1>=0, N1<=N, max(N).
applyAction(0,"FireAction").
applyAction(N,"FireAction"):-applyAction(N1,"FireAction"), N=N1+5, N<=N2, max(N2).

nextMove(N,left) :- applyAction(N,"FireAction"), even(N).
nextMove(N,right) :- applyAction(N,"FireAction"), not even(N).

applyAction(N,"MoveAction"):- not applyAction(N,"FireAction"), step(N).
nextMove(N) :- nextMove(N,_).

nNotToBeUsed(T,N):-step(T), nextMove(N), nextMove(N1), N1>N, N1<T.
nextToUse(T,N) :- step(T), nextMove(N), not nNotToBeUsed(T,N), N<T.


actionArgument(T,move,Move):- applyAction(T,"MoveAction"), nextMove(N,Move), nextToUse(T,N).

%#show nextToUse/2.
#show actionArgument/3.
%#show nextMove/2.
%#show nextMove1/2.
#show applyAction/2.