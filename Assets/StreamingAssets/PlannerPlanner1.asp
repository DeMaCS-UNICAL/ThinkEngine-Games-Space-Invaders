% For ASP programs:
% Predicates for Action invokation.
% applyAction(OrderOfExecution,ActionClassName).
% actionArgument(ActionOrder,ArgumentName, ArgumentValue).


player(X,Y,0):-playerSensor(ID,objectIndex(Index),intPair(x(X))),playerSensor(ID,objectIndex(Index),intPair(y(Y))).
invaders(X,Y,0):-invader01Sensor(ID,objectIndex(Index),intPair(x(X))),invader01Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders(X,Y,0):-invader02Sensor(ID,objectIndex(Index),intPair(x(X))),invader02Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders(X,Y,0):-invader03Sensor(ID,objectIndex(Index),intPair(x(X))),invader03Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders_direction("right"):-invadersSensor(_,_,invaders(direction(x("1")))).
invaders_direction("left"):-invadersSensor(_,_,invaders(direction(x("-1")))).
bunker(X,Y):-bunkerSensor(ID,objectIndex(Index),intPair(x(X))),bunkerSensor(ID,objectIndex(Index),intPair(y(Y))).
bunker(X,Y):-bunkerSensor0(ID,objectIndex(Index),intPair(x(X))),bunkerSensor0(ID,objectIndex(Index),intPair(y(Y))).
bunker(X,Y):-bunkerSensor01(ID,objectIndex(Index),intPair(x(X))),bunkerSensor01(ID,objectIndex(Index),intPair(y(Y))).
bunker(X,Y):-bunkerSensor012(ID,objectIndex(Index),intPair(x(X))),bunkerSensor012(ID,objectIndex(Index),intPair(y(Y))).
missile(X,Y,0):-missileSensor(ID,objectIndex(Index),intPair(x(X))),missileSensor(ID,objectIndex(Index),intPair(y(Y))).
laser(X,Y,0):-laserSensor(ID,objectIndex(Index),intPair(x(X))),laserSensor(ID,objectIndex(Index),intPair(y(Y))).

% MAX PLAN LENGTH
maxTime(1).
y(-20..20).
min_x_matrix(-14).
max_x_matrix(14).
action("MoveAction").
move("left").
move("right").
action("FireAction").

% EòABORAZIONE DEL PIANO
%% TIME STEP 0
1<={applyAction(0,A) : action(A)}<=1.
1<={actionArgument(0,"move",M) : move(M)}<=1 :- applyAction(0,"MoveAction").

%% PLANNED TIME STEP FOR T>0  
1<={applyAction(T_Next,A) : action(A)}<=1 :- applyAction(T,_), T_Next=T+1, T_Next<=TM, maxTime(TM).
1<={actionArgument(T,"move",M) : move(M)}<=1 :- applyAction(T,"MoveAction").



invaders(X_Next,Y,T_Next) :- invaders(X,Y,T), T_Next=T+1, X<X_Max, X_Next=X+1, invaders_direction("right"), T_Next<=T_Max, maxTime(T_Max), max_x_matrix(X_Max).
invaders(X_Next,Y,T_Next) :- invaders(X,Y,T), T_Next=T+1, X>X_Min, X_Next=X-1, invaders_direction("left"), T_Next<=T_Max, maxTime(T_Max), min_x_matrix(X_Min).
player(X_Next,Y,T_Next) :- player(X,Y,T), applyAction(T,"MoveAction"), actionArgument(T,"move","right"), X_Next=X+1, X_Next<=X_Max, max_x_matrix(X_Max), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
player(X_Next,Y,T_Next) :- player(X,Y,T), applyAction(T,"MoveAction"), actionArgument(T,"move","left"), X_Next=X-1, X_Next>=X_Min, min_x_matrix(X_Min), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
player(X,Y,T_Next) :- player(X,Y,T), applyAction(T,"FireAction"), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).

most_left_invader(X,Y,T) :- #min{C: invaders(C,Y,T)}=X, invaders(_,Y,T).
most_right_invader(X,Y,T) :- #max{C: invaders(C,Y,T)}=X, invaders(_,Y,T).

nearest_y_invader(X,Y,T) :- #min{C: invaders(_,C,T)}=Y, invaders(X,_,T).


% STRATEGIA DI MOVIMENTO
% NON ANDARE IN PUNTI ESTREMI (DESTRA/SINISTRA) DOVE NON CI SONO INVADERS
:-applyAction(T_Next,"MoveAction"), actionArgument(T_Next,"move","left"), player(X1,_,T), most_left_invader(X2,_,T), X1<=X2, T_Next=T+1.
:-applyAction(T_Next,"MoveAction"), actionArgument(T_Next,"move","right"), player(X1,_,T), most_right_invader(X2,_,T), X1>=X2, T_Next=T+1.

% SE POSSIBILE SPOSTATI VERSO UN INVADERS DELLE FILE PIù A SINISTRA
:~player(X1,_,T), most_left_invader(X2,_,T), X=X2-X1, X2>X1. [X@4,X1,X2]
distance_left_column(X,T):- player(X1,_,T), most_left_invader(X2,_,T), X=X1-X2, X1>=X2.
:~distance_left_column(X,T). [X@4,T]

% SE POSSIBILE SPOSTATI VERSO UN INVADERS DELLE FILE PIù BASSE
:~player(X1,_,T), nearest_y_invader(X2,_,T), X=X2-X1, X2>X1. [X@3,X1,X2]
distance_player_invader(X,T):- player(X1,_,T), nearest_y_invader(X2,_,T), X=X1-X2, X1>=X2.
:~distance_player_invader(X,T). [1@3,T]

% PREFERISCI SPOSTAMENTI CONTRARI RISPETTO LA DIREZIONE DEGLI INVADERS
:~actionArgument(_,"move",M), invaders_direction(M). [1@2,M]






#show applyAction/2. 
#show actionArgument/3.
#show most_left_invader/3.
#show player/3.