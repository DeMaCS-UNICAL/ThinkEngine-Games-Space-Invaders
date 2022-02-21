% For ASP programs:
% Predicates for Action invokation.
% applyAction(OrderOfExecution,ActionClassName).
% actionArgument(ActionOrder,ArgumentName, ArgumentValue).


player(X,Y,0):-playerSensor(ID,objectIndex(Index),intPair(x(X))),playerSensor(ID,objectIndex(Index),intPair(y(Y))).
player_move_speed(X):-playerSensor(_,_,player(increaseFactor(X))).
laser(X,Y,S,0):-laserSensor(ID,objectIndex(Index),intPair(x(X))),laserSensor(ID,objectIndex(Index),intPair(y(Y))),laserSensor(ID,objectIndex(Index),projectile(increaseFactor(S))).

invaders(X,Y,0):-invader01Sensor(ID,objectIndex(Index),intPair(x(X))),invader01Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders(X,Y,0):-invader02Sensor(ID,objectIndex(Index),intPair(x(X))),invader02Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders(X,Y,0):-invader03Sensor(ID,objectIndex(Index),intPair(x(X))),invader03Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders_direction("right"):-invadersSensor(_,_,invaders(direction(x("1")))).
invaders_direction("left"):-invadersSensor(_,_,invaders(direction(x("-1")))).
invaders_move_speed(X):-invadersSensor(_,_,invaders(increaseFactor(X))).

bunker(X,Y):-bunkerSensor(ID,objectIndex(Index),intPair(x(X))),bunkerSensor(ID,objectIndex(Index),intPair(y(Y))).
bunker(X,Y):-bunkerSensor0(ID,objectIndex(Index),intPair(x(X))),bunkerSensor0(ID,objectIndex(Index),intPair(y(Y))).
bunker(X,Y):-bunkerSensor01(ID,objectIndex(Index),intPair(x(X))),bunkerSensor01(ID,objectIndex(Index),intPair(y(Y))).
bunker(X,Y):-bunkerSensor012(ID,objectIndex(Index),intPair(x(X))),bunkerSensor012(ID,objectIndex(Index),intPair(y(Y))).
missile(X,Y,S,0):-missileSensor(ID,objectIndex(Index),intPair(x(X))),missileSensor(ID,objectIndex(Index),intPair(y(Y))),missileSensor(ID,objectIndex(Index),projectile(increaseFactor(S))).

% MAX PLAN LENGTH
maxTime(5).
%y(-20000..20000).
min_x_matrix(-14000).
max_x_matrix(14000).
action("MoveAction").
move("left").
move("right").
action("FireAction").

% ELABORAZIONE DEL PIANO
%% TIME STEP 0
1<={applyAction(0,A) : action(A)}<=1.
1<={actionArgument(0,"move",M) : move(M)}<=1 :- applyAction(0,"MoveAction").

%% PLANNED TIME STEP FOR T>0  
1<={applyAction(T_Next,A) : action(A)}<=1 :- applyAction(T,_), T_Next=T+1, T_Next<=TM, maxTime(TM).
1<={actionArgument(T,"move",M) : move(M)}<=1 :- applyAction(T,"MoveAction").


% ESTIMATE INVADERS' FUTURE POSITION 
invaders(X_Next,Y,T_Next) :- invaders(X,Y,T), T_Next=T+1, X>X_Min, X<X_Max, invaders_move_speed(S), X_Next=X+S, T_Next<=T_Max, maxTime(T_Max), min_x_matrix(X_Min), max_x_matrix(X_Max).

% ESTIMATE PLAYER'S FUTURE POSITION 
player(X_Next,Y,T_Next) :- player(X,Y,T), applyAction(T,"MoveAction"), actionArgument(T,"move","right"), player_move_speed(S), X_Next=X+S, X_Next<=X_Max, max_x_matrix(X_Max), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
player(X_Next,Y,T_Next) :- player(X,Y,T), applyAction(T,"MoveAction"), actionArgument(T,"move","left"), player_move_speed(S), X_Next=X-S, X_Next>=X_Min, min_x_matrix(X_Min), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
player(X,Y,T_Next) :- player(X,Y,T), applyAction(T,"FireAction"), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).

% ESTIMATE MISSILE'S FUTURE POSITION 
missile(X,Y_Next,S,T_Next) :- missile(X,Y,S,T), Y_Next=Y+S, T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).

% FIND ALL ENEMIES ON THE MOST LEFT/RIGHT COLUMN 
most_left_invader(X,T) :- #min{C: invaders(C,_,T)}=X, invaders(_,_,T).
most_right_invader(X,T) :- #max{C: invaders(C,_,T)}=X, invaders(_,_,T).

% FIND THE NEAREST W.R.T. TO THE PLAYER (ON X AND Y COORD)
min_y_invader(Y,T) :- #min{C: invaders(_,C,T)}=Y, invaders(_,_,T).
nearest_y_invader(X,Y,T) :- #min{C: invaders(C,Y,T)}=X, min_y_invader(Y,T).
invaders_near_player(T) :- invaders(_,Y1,T), player(_,Y2,T), Y1>=Y2, Y1-Y2<=12000.


% STRATEGIA DI MOVIMENTO
% NON ANDARE IN PUNTI ESTREMI (DESTRA/SINISTRA) DOVE NON CI SONO INVADERS
:-applyAction(T_Next,"MoveAction"), actionArgument(T_Next,"move","left"), player(X1,_,T), most_left_invader(X2,T), X1<=X2+1000, T_Next=T+1.
:-applyAction(T_Next,"MoveAction"), actionArgument(T_Next,"move","right"), player(X1,_,T), most_right_invader(X2,T), X1>=X2-1000, T_Next=T+1.

% SE POSSIBILE SPOSTATI VERSO UN INVADERS DELLE FILE PIù A SINISTRA (AD INIZIO GIOCO)
%:~not invaders_near_player(T), player(X1,_,T), most_left_invader(X2,T), X=X2-X1, X2>X1. [X@4,X1,X2]
distance_left_column(X,T) :- not invaders_near_player(T), player(X1,_,T), most_left_invader(X2,T), X=X1-X2, X1>=X2.
:~distance_left_column(X,T). [X@4,T]

% SE POSSIBILE SPOSTATI VERSO UN INVADERS DELLE FILE PIù BASSE QUANDO GLI INVADERS SONO VICINISSIMI AL PLAYER (IN ALTEZZA)
%:~invaders_near_player(T), player(X1,_,T), nearest_y_invader(X2,_,T), X=X2-X1, X2>X1. [X@4,X1,X2,T]
distance_player_invader(X,T) :- invaders_near_player(T), player(X1,_,T), nearest_y_invader(X2,_,T), X=X1-X2, X1>=X2.
:~distance_player_invader(X,T). [X@4,X,T]

% PREFERISCI SPOSTAMENTI CONTRARI RISPETTO LA DIREZIONE DEGLI INVADERS
%:~actionArgument(_,"move",M), invaders_direction(M). [1@3,M]

% PREFERISCI SPOSTAMENTI CONTINUI NELLA STESSA DIREZIONE
:~actionArgument(T1,"move",M1), actionArgument(T2,"move",M2), T2>T1, M1!=M2. [1@3,T1,M1,T2,M2]


% DIFESA
% PREFERISCI SPOSTARTI SE TI STANNO SPARANDO E NON TI TROVI SOTTO UN BUNKER
:~applyAction(T_Next,"FireAction"), missile(X1,Y1,_,T), player(X2,Y2,T), not bunker(X2,Y2), X1-1100<=X2, X2<=X1+1100, Y2<=Y1+8000, T_Next=T+1. [1@7,T,X1,X2,Y1,Y2]

% NON SPARARE A VUOTO
%:~applyAction(T_Next,"FireAction"), invaders(X,Y,T), y(Y), player(X,_,T), T_Next=T+1. [1@7,X,Y,T]
% --- DA DECOMMENTARE ---
%no_invaders_in_columns(X,T) :- #count{Y: invaders(X,Y,T)}=0, player(X,_,T).
%:~applyAction(T_Next,"FireAction"), player(X,_,T), no_invaders_in_columns(X,T), T_Next=T+1. [1@5,T_Next,X,T]


% NON SPARARE AI BUNKER
:~applyAction(T_Next,"FireAction"), player(X,_,T), bunker(X,_), T_Next=T+1. [1@5,X,T]

a.
:~a. [1@1]
:~a. [1@2]
:~a. [1@3]
:~a. [1@4]
:~a. [1@5]
:~a. [1@6]
:~a. [1@7]

% ATTACCO
% SPARA SE SEI SOTTO UN INVADERS
%:~applyAction(T_Next,"MoveAction"), nearest_y_invader(X,_,T), player(X,_,T), T_Next=T+1. [1@6,X,T]
%:~applyAction(T_Next,"MoveAction"), invaders(X1,_,T), player(X2,_,T), T_Next=T+1, X1>X2-500. [1@6,T,X1,X2]



#show applyAction/2. 
#show actionArgument/3.
%#show missile/4.
%#show invaders/3.
%#show distance_player_invader/2.
%#show min_y_invader/2.
%#show invaders_move_speed/1.
%#show laser/4.
%#show player/3.
%#show invadersSensor/3.
%#show bunker/2.
%#show nearest_y_invader/3.
%#show invaders_near_player/1.
%#show no_invaders_in_columns/2.


% STRATEGY:
% 1. DISTRUGGI PRIMA I NEMICI PER COLONNE PARTENDO DALLA SINISTRA --> SE LE COLONNE DIMINUISCONO, CI 
    % VOGLIONO PIù STEP PRIMA CHE POSSANO SCENDERE DI LIVELLO
% 2. DISTRUGGI I NEMICI SULLE RIGHE PIù IN BASSO
% 3. NON SPARARE SE SEI SOTTO UN BUNKER
% 4. NON SPARARE SE NON CI SONO NEMICI SOPRA DI TE (NON SPARARE A VUOTO)
% 5. SE TI TROVI SOTTO UN NEMICO è PREFERIBILE SPARARE 
% 6. QUANDO TI SPOSTI, CERCA DI SPOSTARTI VERSO I NEMICI DELLE FILE PIù IN BASSO O VERSO LE PRIME COLONNE

% SE IL NEMICO SI TROVA A 5 CELLE Y DA TE, è PREFERIBILE SPARARE A QUELLI PIù VICINI

% PROBLEMI DURANTE LA PIANIFICAZIONE PERCHè IL QUANDO CALCOLO LE FUTURE POSIZIONI DEL PLAYER CON LA CONVERSIONE DA FLOAT A INT
% HO GRAVI PERDITE: PER ME OGNI VOLTA CHE MI MUOVO MI TROVO IN UN POSIZIONE X_NEXT=X+1, NEL GIOCO CI SI SPOSTA DI +1 OGNI ~31 MOVE NELLA STESSA DIREZIONE!!!
