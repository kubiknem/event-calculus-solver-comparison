% Falling object example -- continuous change using trajectory
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 121, section 7.1.3
%
% An object is dropped, falls down via a constant speed, and then stops falling when it hits the floor.

#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.


%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

%% max_time(PARAMETER).     %% added on execution via an external file
%% initHeight(PARAMETER).   %% added on execution via an external file

agent(nathan).
object(apple).

fluent(height(O, H)).
fluent(falling(O)).

event(drop(A, O)).
event(hitGround(O)).

fGravity(2).


%-------------------------------------------------------------------------------
% domain description 
%-------------------------------------------------------------------------------

% [effect]
% if an agent drops an object, then the object will start falling and its height
% will be released from CLoI
initiates(drop(A,O), falling(O), T).
% [effect + CLoI]
releases(drop(A,O), height(O,H), T).

% [triggered event]
% an object hits the ground when its falling and its height becomes zero
happens(hitGround(O), T) :-
    holdsAt(height(O,0), T, falling(O)).

% [effect]
% if an object hits the ground, then it will stop falling
terminates(hitGround(O), falling(O), T).
% [effect + CLoI]
% if an object hits the ground then its height will no longer be released from CLoI
initiates(hitGround(O), height(O, H), T) :-
    holdsAt(height(O, H), T).


% motion of an object from the moment it is dropped to the moment it hits the ground
trajectory(falling(O), T1, height(O,SUM), T2) :-
    T1 .<. T2,
    fGravity(G),
    SUM .=. H - (G)*(T2-T1),
    holdsAt(height(O,H), T1).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

initiallyP(height(apple, H)) :- initHeight(H).  % apples height initially is something
initiallyN(F) :- not initiallyP(F).             % apple is initially not falling

happens(drop(nathan,apple), 1).                 % nathan drop the apple at time 1


% --> conclude that the apple will hit the ground at time (initHeight/2) + 1
?- happens(hitGround(apple), T).