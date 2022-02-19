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
invaders_near_player(T) :- invaders(_,Y1,T), player(_,Y2,T), Y1>=Y2, Y1-Y2<=5.


% STRATEGIA DI MOVIMENTO
% NON ANDARE IN PUNTI ESTREMI (DESTRA/SINISTRA) DOVE NON CI SONO INVADERS
%:-applyAction(T_Next,"MoveAction"), actionArgument(T_Next,"move","left"), player(X1,_,T), most_left_invader(X2,_,T), X1<=X2, T_Next=T+1.
%:-applyAction(T_Next,"MoveAction"), actionArgument(T_Next,"move","right"), player(X1,_,T), most_right_invader(X2,_,T), X1>=X2, T_Next=T+1.

% SE POSSIBILE SPOSTATI VERSO UN INVADERS DELLE FILE PIù A SINISTRA (AD INIZIO GIOCO)
:~not invaders_near_player(T), player(X1,_,T), most_left_invader(X2,_,T), X=X2-X1, X2>X1. [X@4,X1,X2]
distance_left_column(X,T) :- not invaders_near_player(T), player(X1,_,T), most_left_invader(X2,_,T), X=X1-X2, X1>=X2.
:~distance_left_column(X,T). [X@4,T]

% SE POSSIBILE SPOSTATI VERSO UN INVADERS DELLE FILE PIù BASSE QUANDO GLI INVADERS SONO VICINISSIMI AL PLAYER (IN ALTEZZA)
:~invaders_near_player(T), player(X1,_,T), nearest_y_invader(X2,_,T), X=X2-X1, X2>X1. [X@4,X1,X2]
distance_player_invader(X,T) :- invaders_near_player(T), player(X1,_,T), nearest_y_invader(X2,_,T), X=X1-X2, X1>=X2.
:~distance_player_invader(X,T). [1@4,T]

% PREFERISCI SPOSTAMENTI CONTRARI RISPETTO LA DIREZIONE DEGLI INVADERS
:~actionArgument(_,"move",M), invaders_direction(M). [1@2,M]

% PREFERISCI SPOSTAMENTI CONTINUI NELLA STESSA DIREZIONE
:~actionArgument(T1,"move",M1), actionArgument(T2,"move",M2), T2=T1+1, M1!=M2. [1@2,T1,M1,T2,M2]

no_invaders_in_columns(X,T) :- #count{Y: invaders(X,Y,T)}=0, invaders(X,_,T).
:~applyAction(T_Next,"FireAction"), player(X,_,T), no_invaders_in_columns(X,T), T_Next=T+1. [1@5,T_Next,X,T]

% DIFESA
% PREFERISCI SPOSTARTI SE TI STANNO SPARANDO E NON TI TROVI SOTTO UN BUNKER
%:~applyAction(T_Next,"FireAction"), missile(X,Y1,T), player(X,Y2,T), not bunker(X,Y2), Y2<=Y1-6, T_Next=T+1. [1@5,T,X,Y1,Y2]

% NON SPARARE A VUOTO ---- ATTENZIONE, NON FUNZIONA PERCHè CI VORREBBE UN TRIGGER CHE MI FA RICALCOLARE IL PIANO QUANDO UN NEMICO
    % MUORE, ALTRIMENTI LUI CREDE CHE SOPRA CI SIAMO NEMICI DATO CHE NON AGGIORNO IL LORO STATO A "KILLED"
%:~applyAction(T_Next,"FireAction"), invaders(X,Y,T), y(Y), player(X,_,T), T_Next=T+1. [1@1,X,Y,T]


% NON SPARARE AI BUNKER ---- ATTENZIONE, NON FUNZIONA PER VIA DEI PROBLEMI DI CONVERSIONE IN INT (BUNKER IN POS (3,_), PLAYER IN POS (2,_)
    % IL PLAYER SPARA MA DISTRUGGE UGUALMENTE IL BUNKER PERCHè è PIù GRANDE)
%:~applyAction(T_Next,"FireAction"), player(X,_,T), bunker(X,_), T_Next=T+1. [1@5,X,T]



% ATTACCO
% SPARA SE SEI SOTTO UN INVADERS
%:~applyAction(T,"MoveAction"), nearest_y_invader(X,_,T), player(X,_,T). [1@6,T,X]
%:~applyAction(T,"MoveAction"), invaders(X,_,T), player(X,_,T). [1@1,T,X]



#show applyAction/2. 
#show actionArgument/3.
%#show most_left_invader/3.
%#show player/3.


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
