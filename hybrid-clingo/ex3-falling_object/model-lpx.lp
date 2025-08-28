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
fluentF(height(O)) :- object(O).
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
% releases(drop(A,O), height(O,H), T) :-
%     agent(A), object(O), fHeight(H), time(T).

% [triggered event]
% an object hits the ground when its falling and its height becomes zero
happensAtStep(hitGround(O), S) :-
    holdsAtStep(falling(O), S),
    % &sum{ (height(O), S) } = 0,
    normal_atom(valueAtStep(height(O), S), eq, 0), 
    step(S).


% TODO the floating step needs to be bound to something
% it is impossible for the object to fall forever if it was dropped at some earlier time (without intervening drops in between)
:- happensAtStep(drop(_,O), S1), not eventually_stopped_falling(O,S1).
eventually_stopped_falling(O,S1) :- not interleaving_drop(O,S1,S2), -holdsAtStep(falling(O), S2), step(S1), S1 < S2.
interleaving_drop(O,S1,S2) :- step(S1), step(S2), S3 < S2, S3 > S1, happens(drop(_,O),S3).

    % TODO older alternatives
    %% can just add another event and increase step count by one
    %% maxstep=3 !
    %happens(end, 30).

    %% it is impossible for the object to not hit the ground
    %:- not happensAtStep(hitGround(O), _), object(O).

    %% it is impossible for the object to not hit the ground if it was dropped
    %:- happensAtStep(drop(_,O), _), not happensAtStep(hitGround(O), _), object(O).

    %% it is impossible for the object to not hit the ground if it was dropped at some earlier time
    %:- happensAtStep(drop(_,O), S1), not eventually_stopped_falling(O,S1).
    %eventually_stopped_falling(O,S1) :- happensAtStep(hitGround(O), S2), step(S1), S1 < S2.

    %% it is impossible for the object to not hit the ground or be caught if it was dropped at some earlier time
    %:- happensAtStep(drop(_,O), S1), not eventually_stopped_falling(O,S1).
    %eventually_stopped_falling(O,S1) :- happensAtStep(hitGround(O), S2), step(S1), S1 < S2.
    %eventually_stopped_falling(O,S1) :- happensAtStep(catch(_, O), S2), step(S1), S1 < S2.
    
    %% it is impossible for the object to fall forever if it was dropped at some earlier time
    %:- happensAtStep(drop(_,O), S1), not eventually_stopped_falling(O,S1).
    %eventually_stopped_falling(O,S1) :- -holdsAtStep(falling(O), S2), step(S1), S1 < S2.


% TODO the below seems to not quite work as intended
%  - still allows answers without the event and with one of these steps: timeAtStep(1)=10+-1*e ; timeAtStep(2)=20+-1/2*e
% capture when height(O) = 0
% restrict that there must exist a state where height is exactly equal to zero
% (by saying that there cannot be two subsequent states in which one is lt/gt and the next gt/lt, i.e. there is no state with exactly eq)
:- normal_atom(valueAtStep(height(O), S), gt, 0), normal_atom(valueAtStep(height(O), S+1), lt, 0), 
   step(S).
:- normal_atom(valueAtStep(height(O), S), lt, 0), normal_atom(valueAtStep(height(O), S+1), gt, 0), 
   step(S).
    
comparison(valueAtStep(height(O),S  ), 0) :- object(O), step(S). 


% [effect]
% if an object hits the ground, then it will stop falling
terminatesAtStep(hitGround(O), falling(O), S) :- object(O), step(S).

% [effect + CLoI]
% if an object hits the ground then its height will no longer be released from CLoI
&sum{ valueAtStep(height(O),S) } = valueAtStep(height(O),S+1) :- 
    happensAtStep(hitGround(O), S),
    step(S).

defined(valueAtStep(height(O),S+1)) :- 
    happensAtStep(hitGround(O), S),
    step(S).







% TODO % terminatesAtStep(catch(A, O), falling(O), S) :- agent(A), object(O), step(S).
% TODO % 
% TODO % &sum{ valueAtStep(height(O),S) } = valueAtStep(height(O),S+1) :- 
% TODO %     happensAtStep(catch(A, O), S),
% TODO %     agent(A), step(S).
% TODO % 
% TODO % defined(valueAtStep(height(O),S+1)) :- 
% TODO %     happensAtStep(catch(A, O), S),
% TODO %     agent(A), step(S).


% [state constraint]
% an object only has one unique height at a time
% H1 = H2 :- holdsAt(height(O,H1), T), holdsAt(height(O,H2), T),
%     agent(A), object(O), fHeight(H1), fHeight(H2), time(T).

% motion of an object from the moment it is dropped to the moment it hits the ground
%*
%trajectory(falling(O), T1, height(O,H - (G)*(T2-T1)), T2) :-
%    T1 < T2,
%    holdsAt(height(O,H), T1),
%    fGravity(G), object(O), fHeight(H), time(T1), time(T2).
*%

&sum{ valueAtStep(height(O),S); G*timeAtStep(S); -G*timeAtStep(S+1) } = valueAtStep(height(O),S+1) :-
    holdsAtStep(falling(O), S+1),
    fGravity(G), step(S),
    S < maxstep. % TODO not sure why this is needed (otherwise there will be one more timeAtStep in the answer)

defined(valueAtStep(height(O),S)) :-
    holdsAtStep(falling(O), S), step(S).

%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

% initiallyP(height(apple, H)) :- initHeight(H).  % apples height initially is something
initiallyF(height(apple), H) :- initHeight(H).  % apples height initially is something
initiallyN(F) :- not initiallyP(F), fluent(F).  % apple is initially not falling

happens(drop(nathan,apple), 10).                 % nathan drop the apple at time 10
% happens(check, 15).                   % TODO can add this to see value of height at time 15
% happens(catch(nathan,apple), 15).     % TODO could add this to prevent hitting the ground 

% --> conclude that the apple will hit the ground at time (initHeight/2) + 10


% TODO not sure what these are for --- probably a way to workaround the event trigger?
%&sum{ valueAtStep(height(O),S) }  = 0 :- object(O), S=maxstep.
% &sum{ (height(O),S) } != 0 :- object(O), S=0..maxstep-1. % comparison != is not allowed in clingo-lpx
% comparison(valueAtStep(height(O),S), 0) :- object(O), S=0..maxstep-1.
% :- object(O), S=0..maxstep-1, normal_atom(valueAtStep(height(O),S), eq, 0). 

