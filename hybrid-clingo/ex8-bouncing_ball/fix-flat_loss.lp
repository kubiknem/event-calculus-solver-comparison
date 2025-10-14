
% ----- domain model -----

% fluents
fluent_Func(height).
fluent_Func(velocity).

fluent(falling).
fluent(rising).

fluent(constant_fall_rate(X)) :- initiallyP(constant_fall_rate(X)).                         % simplified to a constant fall rate instead of accelerating over time
fluent(velocity_loss_portion(X)) :- initiallyP(velocity_loss_portion(X)).                   % ball looses a portion of velocity on each bounce
fluent(constant_velocity_loss_bounce(X)) :- initiallyP(constant_velocity_loss_bounce(X)).   % a flat amount of velocity lost at every bounce (heat, squish of the ball,...)

% input events
% event(drop).
% event(catch).

% triggered events
% event(fall_down).
% event(hit_ground).
% event(bounce_up).
% event(reach_apex).
% event(stop_bouncing).


% start by dropping the ball
releasesAtStep_Func(drop, height, valueAtStep(height, S+1), S) :- step(S).
releasesAtStep_Func(drop, velocity, valueAtStep(velocity, S+1), S) :- step(S).


% start by dropping the ball
initiatesAtStep(fall_down, falling, S) :- step(S).

% stop falling when hitting the ground
terminatesAtStep(hit_ground, falling, S) :- step(S).

% bounce back up
initiatesAtStep(bounce_up, rising, S) :- step(S).

% stop rising when reaching the apex
terminatesAtStep(reach_apex, rising, S) :- step(S).

% stop everything by catching the ball
terminatesAtStep(catch, falling, S) :- step(S).
terminatesAtStep(catch, rising, S) :- step(S).

initiatesAtStep_Func(catch, height, valueAtStep(height, S+1), S) :- step(S).
&sum{valueAtStep(height,S+1)} = valueAtStep(height,S) :- initiatedByAtStep_Func(catch, height, valueAtStep(height,S+1), S).
terminatesAtStep_Func(catch, height, valueAtStep(height, S), S) :- step(S).

initiatesAtStep_Func(catch, velocity, valueAtStep(velocity, S+1), S) :- step(S).
&sum{valueAtStep(velocity,S+1)} = 0 :- initiatedByAtStep_Func(catch, velocity, valueAtStep(velocity,S+1), S).
terminatesAtStep_Func(catch, velocity, valueAtStep(velocity, S), S) :- step(S).

% stop everything if the ball stops bouncing
initiatesAtStep_Func(stop_bouncing, height, valueAtStep(height, S+1), S) :- step(S).
&sum{valueAtStep(height,S+1)} = 0 :- initiatedByAtStep_Func(stop_bouncing, height, valueAtStep(height,S+1), S).
terminatesAtStep_Func(stop_bouncing, height, valueAtStep(height, S), S) :- step(S).

initiatesAtStep_Func(stop_bouncing, velocity, valueAtStep(velocity, S+1), S) :- step(S).
&sum{valueAtStep(velocity,S+1)} = 0 :- initiatedByAtStep_Func(stop_bouncing, velocity, valueAtStep(velocity,S+1), S).
terminatesAtStep_Func(stop_bouncing, velocity, valueAtStep(velocity, S), S) :- step(S).


% falling 
trajectory_Func(falling, S1, height, valueAtStep(height, S2), S2) :- step(S1), stepMax(S2).
&sum{ valueAtStep(height,S); Rate*timeAtStep(S); -Rate*timeAtStep(S+1) } = valueAtStep(height,S+1) :-
    trajectoryAtStep_Func(falling, _, height, valueAtStep(height,S+1), S+1),
    initiallyP(constant_fall_rate(Rate)),
    step(S), S < maxstep.

trajectory_Func(falling, S1, velocity, valueAtStep(velocity, S2), S2) :- step(S1), stepMax(S2).
&sum{ valueAtStep(velocity,S); -Rate*timeAtStep(S); Rate*timeAtStep(S+1) } = valueAtStep(velocity,S+1) :-
    trajectoryAtStep_Func(falling, _, velocity, valueAtStep(velocity,S+1), S+1),
    initiallyP(constant_fall_rate(Rate)),
    step(S), S < maxstep.


% rising
trajectory_Func(rising, S1, height, valueAtStep(height, S2), S2) :- step(S1), stepMax(S2).
&sum{ valueAtStep(height,S); -Rate*timeAtStep(S); Rate*timeAtStep(S+1) } = valueAtStep(height,S+1) :-
    trajectoryAtStep_Func(rising, _, height, valueAtStep(height,S+1), S+1),
    initiallyP(constant_fall_rate(Rate)),
    step(S), S < maxstep.

trajectory_Func(rising, S1, velocity, valueAtStep(velocity, S2), S2) :- step(S1), stepMax(S2).
&sum{ (1-LossPortion)*(valueAtStep(velocity,S) - FlatBounceLoss); Rate*timeAtStep(S); -Rate*timeAtStep(S+1) } = valueAtStep(velocity,S+1) :-
    trajectoryAtStep_Func(rising, _, velocity, valueAtStep(velocity,S+1), S+1),
    % loose some flat amount of velocity from the bounce (crop to zero velocity)
    initiallyP(constant_velocity_loss_bounce(FlatBounceLoss)),
    initiallyP(constant_fall_rate(Rate)),
    initiallyP(velocity_loss_portion(LossPortion)),
    step(S), S < maxstep.


happens(fall_down, T) :- happens(drop, T).

happensAtStep(hit_ground, S) :- 
    holdsAtStep(falling, S),
    normal_atom(valueAtStep(height, S), eq, 0).
comparison(valueAtStep(height, S), 0) :- step(S).

happensAtStep(bounce_up, S) :- happensAtStep(hit_ground, S),
    holdsAtStep(falling, S),
    normal_atom(valueAtStep(velocity, S), gt, 0),
    % only bounce up if there is enough velocity (more velocity than the flat loss from bounce)
    initiallyP(constant_velocity_loss_bounce(FlatBounceLoss)),
    normal_atom(valueAtStep(velocity, S), gt, FlatBounceLoss).
comparison(valueAtStep(velocity, S), 0) :- step(S).
comparison(valueAtStep(velocity, S), FlatBounceLoss) :- initiallyP(constant_velocity_loss_bounce(FlatBounceLoss)), step(S).

happensAtStep(stop_bouncing, S) :- happensAtStep(hit_ground, S),
    holdsAtStep(falling, S),
    % only bounce up if there is enough velocity (more velocity than the flat loss from bounce)
    initiallyP(constant_velocity_loss_bounce(FlatBounceLoss)),
    normal_atom(valueAtStep(velocity, S), leq, FlatBounceLoss).

happensAtStep(reach_apex, S) :-
    holdsAtStep(rising, S),
    normal_atom(valueAtStep(velocity, S), eq, 0).

happensAtStep(fall_down, S) :- happensAtStep(reach_apex, S).
