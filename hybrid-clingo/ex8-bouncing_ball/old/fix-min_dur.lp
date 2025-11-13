
% ----- domain model -----

% fluents
fluent_Func(height).
fluent_Func(velocity).

fluent(falling).
fluent(rising).

fluent(constant_fall_rate(X)) :- initiallyP(constant_fall_rate(X)).         % simplified to a constant fall rate instead of accelerating over time
fluent(velocity_loss_portion(X)) :- initiallyP(velocity_loss_portion(X)).   % ball looses a portion of velocity on each bounce

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
releasesAtStep_Func(drop, height, valueAtStep(height, S+1), S) :- step(S), step(S+1).
releasesAtStep_Func(drop, velocity, valueAtStep(velocity, S+1), S) :- step(S), step(S+1).


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

initiatesAtStep_Func(catch, height, valueAtStep(height, S+1), S) :- step(S), step(S+1).
&sum{valueAtStep(height,S+1)} = valueAtStep(height,S) :-
    initiatedByAtStep_Func(catch, height, valueAtStep(height,S+1), S).
terminatesAtStep_Func(catch, height, valueAtStep(height, S), S) :- step(S).

initiatesAtStep_Func(catch, velocity, valueAtStep(velocity, S+1), S) :- step(S), step(S+1).
&sum{valueAtStep(velocity,S+1)} = 0 :-
    initiatedByAtStep_Func(catch, velocity, valueAtStep(velocity,S+1), S).
terminatesAtStep_Func(catch, velocity, valueAtStep(velocity, S), S) :- step(S).

% stop everything if the ball stops bouncing
initiatesAtStep_Func(stop_bouncing, height, valueAtStep(height, S+1), S) :- step(S), step(S+1).
&sum{valueAtStep(height,S+1)} = 0 :-
    initiatedByAtStep_Func(stop_bouncing, height, valueAtStep(height,S+1), S).
terminatesAtStep_Func(stop_bouncing, height, valueAtStep(height, S), S) :- step(S).

initiatesAtStep_Func(stop_bouncing, velocity, valueAtStep(velocity, S+1), S) :- step(S), step(S+1).
&sum{valueAtStep(velocity,S+1)} = 0 :-
    initiatedByAtStep_Func(stop_bouncing, velocity, valueAtStep(velocity,S+1), S).
terminatesAtStep_Func(stop_bouncing, velocity, valueAtStep(velocity, S), S) :- step(S).


% falling 
trajectory_Func(falling, S1, height, valueAtStep(height, S2), S2) :- step(S1), step(S2).
&sum{ valueAtStep(height,S); Rate*timeAtStep(S); -Rate*timeAtStep(S+1) } = valueAtStep(height,S+1) :-
    trajectoryAtStep_Func(falling, _, height, valueAtStep(height,S+1), S+1),
    initiallyP(constant_fall_rate(Rate)),
    step(S), step(S+1).

trajectory_Func(falling, S1, velocity, valueAtStep(velocity, S2), S2) :- step(S1), step(S2).
&sum{ valueAtStep(velocity,S); -Rate*timeAtStep(S); Rate*timeAtStep(S+1) } = valueAtStep(velocity,S+1) :-
    trajectoryAtStep_Func(falling, _, velocity, valueAtStep(velocity,S+1), S+1),
    initiallyP(constant_fall_rate(Rate)),
    step(S), step(S+1).


% rising
trajectory_Func(rising, S1, height, valueAtStep(height, S2), S2) :- step(S1), step(S2).
&sum{ valueAtStep(height,S); -Rate*timeAtStep(S); Rate*timeAtStep(S+1) } = valueAtStep(height,S+1) :-
    trajectoryAtStep_Func(rising, _, height, valueAtStep(height,S+1), S+1),
    initiallyP(constant_fall_rate(Rate)),
    step(S), step(S+1).

trajectory_Func(rising, S1, velocity, valueAtStep(velocity, S2), S2) :- step(S1), step(S2).
&sum{ (1-LossPortion)*valueAtStep(velocity,S); Rate*timeAtStep(S); -Rate*timeAtStep(S+1) } = valueAtStep(velocity,S+1) :-
    trajectoryAtStep_Func(rising, _, velocity, valueAtStep(velocity,S+1), S+1),
    initiallyP(constant_fall_rate(Rate)),
    initiallyP(velocity_loss_portion(LossPortion)),
    step(S), step(S+1).

minDuration(1).

happens(fall_down, T) :- happens(drop, T).

happensAtStep(hit_ground, S) :- 
    holdsAtStep(falling, S),
    normal_atom(valueAtStep(height, S), eq, 0).
%comparison(valueAtStep(height, S), 0) :- step(S).

happensAtStep(bounce_up, S) :- happensAtStep(hit_ground, S),
    holdsAtStep(falling, S),
    % only bounce if the falling trajectory took some minimum duration
    minDuration(MinDur),
    trajectoryAtStep_Func(falling, S1, velocity, valueAtStep(velocity, S), S),
    normal_atom(aux__fallDurAtStep(S), gt, MinDur),
    normal_atom(valueAtStep(velocity, S), gt, 0),
    step(S), step(S1).
%comparison(valueAtStep(velocity, S), 0) :- step(S).
comparison(aux__fallDurAtStep(S2), MinDur) :- minDuration(MinDur), step(S2).
    %comparison(aux__fallDurAtStep(S2), MinDur) :- minDuration(MinDur), trajectoryAtStep_Func(falling, S1, velocity, valueAtStep(velocity, S2), S2), step(S1), step(S2).
&sum{timeAtStep(S2) - timeAtStep(S1)} = aux__fallDurAtStep(S2) :- trajectoryAtStep_Func(falling, S1, velocity, valueAtStep(velocity, S2), S2), step(S1), step(S2).
defined(aux__fallDurAtStep(S2)) :- trajectoryAtStep_Func(falling, S1, velocity, valueAtStep(velocity, S2), S2), step(S1), step(S2).
&sum{0} = aux__fallDurAtStep(S2) :- not defined(aux__fallDurAtStep(S2)), step(S1), step(S2).


happensAtStep(stop_bouncing, S) :- happensAtStep(hit_ground, S),
    holdsAtStep(falling, S),
    % stop bouncing if the falling trajectory took shorter than some minimum duration
    minDuration(MinDur),
    trajectoryAtStep_Func(falling, S1, velocity, valueAtStep(velocity, S), S),
    normal_atom(aux__fallDurAtStep(S), leq, MinDur),
    step(S), step(S1).

happensAtStep(reach_apex, S) :-
    holdsAtStep(rising, S),
    normal_atom(valueAtStep(velocity, S), eq, 0).

happensAtStep(fall_down, S) :- happensAtStep(reach_apex, S).

% TODO not needed for this example but is needed in general
trigger_value(height, 0).
trigger_value(velocity, 0).


% NOTE
% do not need trigger_value for the aux__fallDurAtStep because it does not trigger any events on its own
% first hitGround is triggered based on height and then we check the duration to see if we should trigger a bounce at the same step