
% ----- domain model -----

% fluents
ffluent(height).
ffluent(velocity).

dfluent(falling).
dfluent(rising).

dfluent(constant_fall_rate(X)) :- initiallyP(constant_fall_rate(X)).                        % simplified to a constant fall rate instead of accelerating over time
dfluent(velocity_loss_portion(X)) :- initiallyP(velocity_loss_portion(X)).                  % ball looses a portion of velocity on each bounce
dfluent(constant_velocity_loss_bounce(X)) :- initiallyP(constant_velocity_loss_bounce(X)).   % a flat amount of velocity lost at every bounce (heat, squish of the ball,...)

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
trajectory(rising, T1, velocity, (0, "0.25", -FlatBounceLoss, velocity, -Rate), T2) :-
    % loose some flat amount of velocity from the bounce (crop to zero velocity)
    initiallyP(constant_velocity_loss_bounce(FlatBounceLoss)),
    initiallyP(constant_fall_rate(Rate)),
    %initiallyP(velocity_loss_portion(LossPortion)), % ... 1 - LossPortion
    time(T1), time(T2).

happens(fall_down, T) :- happens(drop, T).

happens(hit_ground, T) :- 
    holdsAt(falling, T),
    normal_atom(fholdsAt(height, T), eq, 0).

happens(bounce_up, T) :- happens(hit_ground, T),
    holdsAt(falling, T),
    normal_atom(fholdsAt(velocity, T), gt, 0),
    % only bounce up if there is enough velocity (more velocity than the flat loss from bounce)
    initiallyP(constant_velocity_loss_bounce(FlatBounceLoss)),
    normal_atom(fholdsAt(velocity, T), gt, FlatBounceLoss).
comparison(fholdsAt(velocity, T), FlatBounceLoss) :- initiallyP(constant_velocity_loss_bounce(FlatBounceLoss)), time(T).

happens(stop_bouncing, T) :- happens(hit_ground, T),
    holdsAt(falling, T),
    % only bounce up if there is enough velocity (more velocity than the flat loss from bounce)
    initiallyP(constant_velocity_loss_bounce(FlatBounceLoss)),
    normal_atom(fholdsAt(velocity, T), leq, FlatBounceLoss).

happens(reach_apex, T) :-
    holdsAt(rising, T),
    normal_atom(fholdsAt(velocity, T), eq, 0).

happens(fall_down, T) :- happens(reach_apex, T).

trigger_value(height, falling, 0).
trigger_value(velocity, rising, 0).
