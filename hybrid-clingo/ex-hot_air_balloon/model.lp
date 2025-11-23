% Falling object example -- continuous change using trajectory
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 121, section 7.1.3
%
% An object is dropped, falls down via a constant speed, and then stops falling when it hits the floor.

#const maxstep=5.
#const maxtime=1000.


%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

agent(nathan).
object(balloon).
% fHeight(-paramHeight..paramHeight).

% fluent(height(O, H)) :- object(O), fHeight(H).
ffluent(height(O)) :- object(O).
dfluent(heaterOn(O)) :- object(O).
dfluent(onGround(O)) :- object(O).

event(turnOnHeater(A, O)) :- agent(A), object(O).
event(turnOffHeater(A, O)) :- agent(A), object(O).
event(hitGround(O)) :- object(O).

#const paramHeight=100.
initHeight(0).
fGravity(2).


%-------------------------------------------------------------------------------
% domain description 
%-------------------------------------------------------------------------------

% [effect]
% if an agent drops an object, then the object will start falling and its height
% will be released from CLoI
initiates(turnOnHeater(A,O), heaterOn(O), T) :- agent(A), object(O), time(T).
terminates(turnOffHeater(A,O), heaterOn(O), T) :- agent(A), object(O), time(T).

% [effect + CLoI]


% [triggered event]
% an object hits the ground when its falling and its height becomes zero
happens(hitGround(O), T) :-
    not holdsAt(heaterOn(O), T),
    not holdsAt(onGround(O), T),
    % &sum{ (height(O), T) } = 0,
    normal_atom(fholdsAt(height(O), T), eq, 0), 
    time(T).

% :- trigger_value(F, heaterOn(O), Val), not holdsAt(heaterOn(O), T+1), normal_atom(fholdsAt(F, T), gt, Val), normal_atom(fholdsAt(F, T+1), lt, Val), timeStep(T), timeStep(T+1).
% :- trigger_value(F, heaterOn(O), Val), not holdsAt(heaterOn(O), T+1), normal_atom(fholdsAt(F, T), lt, Val), normal_atom(fholdsAt(F, T+1), gt, Val), timeStep(T), timeStep(T+1).


% capture when height(O) = 0
% restrict that there must exist a state where height is exactly equal to zero
% (by saying that there cannot be two subsequent states in which one is lt/gt and the next gt/lt, i.e. there is no state with exactly eq)
trigger_value(height(O), 0) :- object(O).


% [effect]
% if an object hits the ground, then it will stop falling
% terminates(hitGround(O), falling(O), T) :- object(O), time(T).
releases(turnOnHeater(A,O), height(O), T) :- agent(A), object(O), time(T).
releases(turnOffHeater(A,O), height(O), T) :- agent(A), object(O), time(T).

% [effect + CLoI]
% if an object hits the ground then its height will no longer be released from CLoI
initiates(hitGround(O), height(O), (0, 1, 0, height(O)), T) :- time(T), object(O).

initiates(hitGround(O), onGround(O), T) :- time(T), object(O).
terminates(turnOnHeater(A, O), onGround(O), T) :- agent(A), object(O), time(T).


% TODO % terminates(catch(A, O), falling(O), T) :- agent(A), object(O), time(T).
% TODO % 
% TODO % &sum{ fholdsAt(height(O),T) } = fholdsAt(height(O),T+1) :- 
% TODO %     happens(catch(A, O), T),
% TODO %     agent(A), time(T).
% TODO % 
% TODO % defined(fholdsAt(height(O),T+1)) :- 
% TODO %     happens(catch(A, O), T),
% TODO %     agent(A), time(T).


% [state constraint]
% an object only has one unique height at a time
% H1 = H2 :- holdsAt(height(O,H1), T), holdsAt(height(O,H2), T),
%     agent(A), object(O), fHeight(H1), fHeight(H2), time(T).
% TODO not needed since clingo lpx only allows one functional value at a time

% motion of an object from the moment it is dropped to the moment it hits the ground
%*
%trajectory(falling(O), T1, height(O,H - (G)*(T2-T1)), T2) :-
%    T1 < T2,
%    holdsAt(height(O,H), T1),
%    fGravity(G), object(O), fHeight(H), time(T1), time(T2).
*%
trajectory(heaterOn(O), T1, height(O), (0, 1, 0, height(O), 2), T2) :- object(O), time(T1), time(T2).
antiTrajectory(heaterOn(O), T1, height(O), (0, 1, 0, height(O), -4), T2) :- object(O), time(T1), time(T2), not startedIn(T1, onGround(O), T2).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

% initiallyP(height(apple, H)) :- initHeight(H).  % apples height initially is something
initiallyP(height(balloon), H) :- initHeight(H).  % apples height initially is something
initiallyN(heaterOn(balloon)).
initiallyP(onGround(balloon)).
%initiallyN(F) :- not initiallyP(F), not initiallyP(F, _), fluent(F).  % apple is initially not falling

in_happens(turnOnHeater(nathan,balloon), 10).        % nathan drop the apple at time 10
in_happens(turnOffHeater(nathan,balloon), 600).     % TODO could add this to prevent hitting the ground 
in_happens(turnOnHeater(nathan,balloon), 900).  

% run-by:
% clingo-lpx --strict -n0 ./model.lp ../axioms/fdec-ffholds.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh


% debug_prints.
% --> conclude that the apple will hit the ground at time (initHeight/2) + 10
% &sum{ fholdsAt(height(O),T) }  = 0 :- object(O), T=maxstep.

% TODO not sure what these were for --- probably a way to workaround the event trigger?
% &sum{ (height(O),T) } != 0 :- object(O), T=0..maxstep-1. % comparison != is not allowed in clingo-lpx
% comparison(fholdsAt(height(O),T), 0) :- object(O), T=0..maxstep-1.
% :- object(O), T=0..maxstep-1, normal_atom(fholdsAt(height(O),T), eq, 0). 

 