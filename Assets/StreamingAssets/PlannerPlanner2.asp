player(X,Y,0):-playerSensor(ID,objectIndex(Index),intPair(x(X))),playerSensor(ID,objectIndex(Index),intPair(y(Y))).
player_move_speed(X):-playerSensor(_,_,player(increaseFactor(X))).
laser(X,Y,S,0):-laserSensor(ID,objectIndex(Index),intPair(x(X))),laserSensor(ID,objectIndex(Index),intPair(y(Y))),laserSensor(ID,objectIndex(Index),projectile(increaseFactor(S))).

invaders(X,Y,0):-invader01Sensor(ID,objectIndex(Index),intPair(x(X))),invader01Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders(X,Y,0):-invader02Sensor(ID,objectIndex(Index),intPair(x(X))),invader02Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders(X,Y,0):-invader03Sensor(ID,objectIndex(Index),intPair(x(X))),invader03Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders_direction("right"):-invadersSensor(_,_,invaders(direction(x("1")))).
invaders_direction("left"):-invadersSensor(_,_,invaders(direction(x("-1")))).
invaders_move_speed(X):-invadersSensor(_,_,invaders(increaseFactor(X))).


%bunkerSensor0(bunker,objectIndex(Index),).
%bunkerSensor0(bunker,objectIndex(Index),bunker(xRight(Value))).

bunker(X,Y):-bunkerSensor(ID,objectIndex(Index),bunker(xLeft(X))),bunkerSensor(ID,objectIndex(Index),bunker(xRight(Y))).
bunker(X,Y):-bunkerSensor0(ID,objectIndex(Index),bunker(xLeft(X))),bunkerSensor0(ID,objectIndex(Index),bunker(xRight(Y))).
bunker(X,Y):-bunkerSensor01(ID,objectIndex(Index),bunker(xLeft(X))),bunkerSensor01(ID,objectIndex(Index),bunker(xRight(Y))).
bunker(X,Y):-bunkerSensor012(ID,objectIndex(Index),bunker(xLeft(X))),bunkerSensor012(ID,objectIndex(Index),bunker(xRight(Y))).
missile(X_Left,X_Right,Y,S,0):-missileSensor(ID,objectIndex(Index),projectile(xLeft(X_Left))),missileSensor(ID,objectIndex(Index),projectile(xRight(X_Right))),missileSensor(ID,objectIndex(Index),intPair(y(Y))),missileSensor(ID,objectIndex(Index),projectile(increaseFactor(S))).


% MAX PLAN LENGTH
maxTime(10).
min_x_matrix(-14000).
max_x_matrix(14000).
action("MoveAction").
move("left").
move("right").
action("FireAction").

% START PLANNING
1<={applyAction(0,A) : action(A)}<=1.
1<={actionArgument(0,"move",M) : move(M)}<=1 :- applyAction(0,"MoveAction").

%% PLANNED TIME STEP FOR T>0  
1<={applyAction(T_Next,A) : action(A)}<=1 :- applyAction(T,_), T_Next=T+1, T_Next<=TM, maxTime(TM).
1<={actionArgument(T,"move",M) : move(M)}<=1 :- applyAction(T,"MoveAction").

%% GET PLAYER PREVIOUS DIRECTION
previous_direction(D):-playerSensor(ID,objectIndex(Index),player(previousDirection(D))).

% ESTIMATE INVADERS' FUTURE POSITION 
invaders(X_Next,Y,T_Next) :- invaders(X,Y,T), T_Next=T+1, X>X_Min, X<X_Max, invaders_move_speed(S), X_Next=X+S, T_Next<=T_Max, maxTime(T_Max), min_x_matrix(X_Min), max_x_matrix(X_Max).

% ESTIMATE PLAYER'S FUTURE POSITION 
player(X_Next,Y,T_Next) :- player(X,Y,T), applyAction(T,"MoveAction"), actionArgument(T,"move","right"), player_move_speed(S), X_Next=X+S, X_Next<=X_Max, max_x_matrix(X_Max), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
player(X_Next,Y,T_Next) :- player(X,Y,T), applyAction(T,"MoveAction"), actionArgument(T,"move","left"), player_move_speed(S), X_Next=X-S, X_Next>=X_Min, min_x_matrix(X_Min), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
player(X,Y,T_Next) :- player(X,Y,T), applyAction(T,"FireAction"), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).

% ESTIMATE MISSILE'S FUTURE POSITION 
missile(X_Left,X_Right,Y_Next,S,T_Next) :- missile(X_Left,X_Right,Y,S,T), Y_Next=Y+S, T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).

% ESTIMATE LASER'S FUTURE POSITION 
laser(X,Y_Next,S,T_Next) :- laser(X,Y,S,T), Y_Next=Y+S, T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
laser(X,Y,200,T):-player(X,Y,T), applyAction(T,"FireAction").

% FIND ALL ENEMIES ON THE MOST LEFT/RIGHT COLUMN 
most_left_invader(X,T) :- #min{C: invaders(C,_,T)}=X, invaders(_,_,T).
most_right_invader(X,T) :- #max{C: invaders(C,_,T)}=X, invaders(_,_,T).

% FIND THE NEAREST W.R.T. TO THE PLAYER (ON X AND Y COORD)
min_y_invader(Y,T) :- #min{C: invaders(_,C,T)}=Y, invaders(_,_,T).
nearest_y_invader(X,Y,T) :- #min{C: invaders(C,Y,T)}=X, min_y_invader(Y,T).
invaders_near_player(T) :- invaders(_,Y1,T), player(_,Y2,T), Y1>=Y2, Y1-Y2<=12000.

% DO NOT FIRE IF THERE IS ALREADY AN ACTIVE LASER 
:-applyAction(T_Next,"FireAction"), laser(_,_,_,T), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
:-applyAction(T1,"FireAction"), applyAction(T2,"FireAction"), T2>T1+1.

% STRATEGIA DI MOVIMENTO
% NON ANDARE IN PUNTI ESTREMI (DESTRA/SINISTRA) DOVE NON CI SONO INVADERS
:-applyAction(T_Next,"MoveAction"), actionArgument(T_Next,"move","left"), player(X1,_,T), most_left_invader(X2,T), X1<=X2+100, T_Next=T+1.
:-applyAction(T_Next,"MoveAction"), actionArgument(T_Next,"move","right"), player(X1,_,T), most_right_invader(X2,T), X1>=X2-100, T_Next=T+1.

%%%%%%%%%%% WEAK CONSTRAINTS %%%%%%%%%%%

%%%%%%%%%%% UPDATE STRATEGY DEPENDING ON INVADERS HEIGHT %%%%%%%%%%%
% SE POSSIBILE SPOSTATI VERSO UN INVADERS DELLE FILE PIù A SINISTRA (AD INIZIO GIOCO)
distance_left_column(X,T) :- not invaders_near_player(T), player(X1,_,T), most_left_invader(X2,T), X=X1-X2, X1>=X2.
distance_left_column(X,T) :- not invaders_near_player(T), player(X1,_,T), most_left_invader(X2,T), X=X2-X1, X1<X2.
:~distance_left_column(X,T). [X@2,T]

% SE POSSIBILE SPOSTATI VERSO UN INVADERS DELLE FILE PIù BASSE QUANDO GLI INVADERS SONO VICINISSIMI AL PLAYER (IN ALTEZZA)
distance_player_invader(X,T) :- invaders_near_player(T), player(X1,_,T), nearest_y_invader(X2,_,T), X=X1-X2, X1>=X2.
distance_player_invader(X,T) :- invaders_near_player(T), player(X1,_,T), nearest_y_invader(X2,_,T), X=X2-X1, X1<X2.
:~distance_player_invader(X,T). [X@2,X,T]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% WHEN MOVE, PREFER THE SAME DIRECTION OF PREVIOUS ACTIONS (AVOID LEFT AND RIGHT CONTINUOUS MOVE) 
:~actionArgument(T1,"move",M1), actionArgument(T2,"move",M2), T2=T1+1, M1!=M2. [1@3,T1,M1,T2,M2]
:~actionArgument(T1,"move",M1), actionArgument(T2,"move",M2), T1=T2+1, M1!=M2. [1@3,T1,M1,T2,M2]
:~actionArgument(T1,"move",M1), previous_direction(M2), M1!=M2. [1@2,M1,M2,T1]

% WHEN MOVE, GO TOWARDS INVADERS
:~actionArgument(_,"move",M), invaders_direction(M). [1@1,M]

% ATTACK
% FIRE WHEN THERE IS AN INVADER UP TO THE PLAYER
:~applyAction(T_Next,"MoveAction"), nearest_y_invader(X,_,T), player(X,_,T), T_Next=T+1. [1@4,X,T]
:~applyAction(T_Next,"MoveAction"), invaders_near_player(T_Next), invaders(X1,_,T), player(X2,_,T), T_Next=T+1. [1@4,T,X1,X2]

% DEFEND
% IF THERE IS A MISSILE UP TO THE PLAYER, MOVE OUTSIDE ITS RANGE
player_under_bunker(T) :- player(X,Y,T), bunker(X_Left,X_Right), X>=X_Left, X<=X_Right.
:~applyAction(T_Next,"FireAction"), actionArgument(T_Next,"move", "right"), missile(X_Left,X_Right,Y1,_,T), player(X,Y2,T), X>=X_Left, X<=X_Right,T_Next=T+1. [1@5,T,Y1,Y2]


#show applyAction/2. 
#show actionArgument/3.
