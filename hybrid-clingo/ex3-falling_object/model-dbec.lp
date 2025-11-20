% Falling object example -- continuous change using trajectory
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 121, section 7.1.3
%
% An object is dropped, falls down via a constant speed, and then stops falling when it hits the floor.


%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

agent(nathan).
object(apple).
% fHeight(-paramHeight..paramHeight).

% fluent(height(O, H)) :- object(O), fHeight(H).
fluent_Func(height(O)) :- object(O).
fluent(falling(O)) :- object(O).

% event(drop(A, O)) :- agent(A), object(O).
% event(hitGround(O)) :- object(O).

#const paramHeight=100.
initHeight(paramHeight).
fGravity(2).


%-------------------------------------------------------------------------------
% domain description 
%-------------------------------------------------------------------------------

% [effect]
% if an agent drops an object, then the object will start falling and its height
% will be released from CLoI
initiatesAtStep(drop(A,O), falling(O), S) :- agent(A), object(O), step(S).

% [effect + CLoI]
releasesAtStep(drop(A,O), height(O), S) :- agent(A), object(O), step(S).

% [triggered event]
% an object hits the ground when its falling and its height becomes zero
happensAtStep(hitGround(O), S) :-
    holdsAtStep(falling(O), S),
    % &sum{ (height(O), S) } = 0,
    normal_atom(valueAtStep(height(O), S), eq, 0), 
    step(S).


% TODO this is not needed for this particular example, but is needed in general
% capture when height(O) = 0
% restrict that there must exist a state where height is exactly equal to zero
% (by saying that there cannot be two subsequent states in which one is lt/gt and the next gt/lt, i.e. there is no state with exactly eq)
trigger_value(height(O), 0) :- object(O).
    % :- normal_atom(valueAtStep(height(O), S), gt, 0), normal_atom(valueAtStep(height(O), S+1), lt, 0), 
    %    step(S), step(S+1).
    % :- normal_atom(valueAtStep(height(O), S), lt, 0), normal_atom(valueAtStep(height(O), S+1), gt, 0), 
    %    step(S), step(S+1).
    % 
    % comparison(valueAtStep(height(O),S  ), 0) :- object(O), step(S). 


% [effect]
% if an object hits the ground, then it will stop falling
terminatesAtStep(hitGround(O), falling(O), S) :- object(O), step(S).

% [effect + CLoI]
% if an object hits the ground then its height will no longer be released from CLoI
&sum{valueAtStep(height(O),S)} = valueAtStep(height(O),S+1) :-
    initiatedValueByAtStep(hitGround(O), height(O), S),
    step(S+1).
initiatesValueAtStep(hitGround(O), height(O), S) :- step(S), object(O).


terminatesAtStep(catch(A, O), falling(O), S) :- agent(A), object(O), step(S).
&sum{valueAtStep(height(O),S)} = valueAtStep(height(O),S+1) :-
    initiatedValueByAtStep(catch(A, O), height(O), S),
    step(S+1).
initiatesValueAtStep(catch(A, O), height(O), S) :- step(S), object(O), agent(A).



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
&sum{ valueAtStep(height(O),S); G*timeAtStep(S); -G*timeAtStep(S+1) } = valueAtStep(height(O),S+1) :-
    trajectoryAtStep(falling(O), _, height(O), S+1),
    fGravity(G), step(S), step(S+1).
trajectory(falling(O), S1, height(O), S2) :- object(O), step(S1), step(S2).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

% initiallyP(height(apple, H)) :- initHeight(H).  % apples height initially is something
initiallyP_Func(height(apple), H) :- initHeight(H).  % apples height initially is something
initiallyN(F) :- not initiallyP(F), not initiallyP_Func(F, _), fluent(F).  % apple is initially not falling

happens(drop(nathan,apple), 10).        % nathan drop the apple at time 10
%happens(catch(nathan,apple), 15).      % TODO could add this to prevent hitting the ground 

% --> conclude that the apple will hit the ground at time (initHeight/2) + 10
% &sum{ valueAtStep(height(O),S) }  = 0 :- object(O), S=maxstep.

happens(checkEnd, 100).                 % TODO this helps enforcing "unsat / no models" when we dont have enough steps

% TODO not sure what these were for --- probably a way to workaround the event trigger?
% &sum{ (height(O),S) } != 0 :- object(O), S=0..maxstep-1. % comparison != is not allowed in clingo-lpx
% comparison(valueAtStep(height(O),S), 0) :- object(O), S=0..maxstep-1.
% :- object(O), S=0..maxstep-1, normal_atom(valueAtStep(height(O),S), eq, 0). 
