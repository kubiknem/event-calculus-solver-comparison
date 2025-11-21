
% ----- domain model -----

% fluents
ffluent(height).
ffluent(velocity).

dfluent(falling).
dfluent(rising).

dfluent(constant_fall_rate(X)) :- initiallyP(constant_fall_rate(X)).         % simplified to a constant fall rate instead of accelerating over time
dfluent(velocity_loss_portion(X)) :- initiallyP(velocity_loss_portion(X)).   % ball looses a portion of velocity on each bounce

% input events
event(drop).
event(catch).

% triggered events
event(fall_down).
event(hit_ground).
event(bounce_up).
event(reach_apex).
event(stop_bouncing).


% start by dropping the ball
releases(drop, height, T) :- time(T).
releases(drop, velocity, T) :- time(T).


% start by dropping the ball
initiates(fall_down, falling, T) :- time(T).

% stop falling when hitting the ground
terminates(hit_ground, falling, T) :- time(T).

% bounce back up
initiates(bounce_up, rising, T) :- time(T).

% stop rising when reaching the apex
terminates(reach_apex, rising, T) :- time(T).

% stop everything by catching the ball
terminates(catch, falling, T) :- time(T).
terminates(catch, rising, T) :- time(T).
initiates(catch, height, (0, 1, 0, height), T) :- time(T).
initiates(catch, velocity, (0, 0, 0, velocity), T) :- time(T).

% stop everything if the ball stops bouncing
initiates(stop_bouncing, height, (0, 0, 0, height), T) :- time(T).
initiates(stop_bouncing, velocity, (0, 0, 0, velocity), T) :- time(T).

% falling 
trajectory(falling, T1, height, (0, 1, 0, height, -Rate), T2) :-
    initiallyP(constant_fall_rate(Rate)),
    time(T1), time(T2).
trajectory(falling, T1, velocity, (0, 1, 0, velocity, Rate), T2) :-
    initiallyP(constant_fall_rate(Rate)),
    time(T1), time(T2).

% rising
trajectory(rising, T1, height, (0, 1, 0, height, Rate), T2) :-
    initiallyP(constant_fall_rate(Rate)),
    time(T1), time(T2).
trajectory(rising, T1, velocity, (0, "0.25", 0, velocity, -Rate), T2) :-
    initiallyP(constant_fall_rate(Rate)),
    %initiallyP(velocity_loss_portion(LossPortion)), % ... 1 - LossPortion
    time(T1), time(T2).

happens(fall_down, T) :- happens(drop, T).

happens(hit_ground, T) :- 
    holdsAt(falling, T),
    normal_atom(fholdsAt(height, T), eq, 0).

happens(bounce_up, T) :- happens(hit_ground, T),
    holdsAt(falling, T),
    normal_atom(fholdsAt(velocity, T), gt, 0).

happens(stop_bouncing, T) :- happens(hit_ground, T),
    holdsAt(falling, T),
    normal_atom(fholdsAt(velocity, T), eq, 0).

happens(reach_apex, T) :-
    holdsAt(rising, T),
    normal_atom(fholdsAt(velocity, T), eq, 0).

happens(fall_down, T) :- happens(reach_apex, T).

trigger_value(height, falling, 0).
trigger_value(velocity, rising, 0).
