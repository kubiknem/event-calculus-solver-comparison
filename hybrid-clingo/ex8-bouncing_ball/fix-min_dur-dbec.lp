
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
releasesAtStep(drop, height, S) :- step(S).
releasesAtStep(drop, velocity, S) :- step(S).


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

initiatesValueAtStep(catch, height, S) :- step(S).
&sum{valueAtStep(height,S+1)} = valueAtStep(height,S) :-
    initiatedValueByAtStep(catch, height, S),
    step(S+1).

initiatesValueAtStep(catch, velocity, S) :- step(S).
&sum{valueAtStep(velocity,S+1)} = 0 :-
    initiatedValueByAtStep(catch, velocity, S),
    step(S+1).

% stop everything if the ball stops bouncing
initiatesValueAtStep(stop_bouncing, height, S) :- step(S).
&sum{valueAtStep(height,S+1)} = 0 :-
    initiatedValueByAtStep(stop_bouncing, height, S),
    step(S+1).

initiatesValueAtStep(stop_bouncing, velocity, S) :- step(S).
&sum{valueAtStep(velocity,S+1)} = 0 :-
    initiatedValueByAtStep(stop_bouncing, velocity, S),
    step(S+1).


% falling 
trajectory(falling, S1, height, S2) :- step(S1), step(S2).
&sum{ valueAtStep(height,S); Rate*timeAtStep(S); -Rate*timeAtStep(S+1) } = valueAtStep(height,S+1) :-
    trajectoryAtStep(falling, _, height, S+1),
    initiallyP(constant_fall_rate(Rate)),
    step(S), step(S+1).

trajectory(falling, S1, velocity, S2) :- step(S1), step(S2).
&sum{ valueAtStep(velocity,S); -Rate*timeAtStep(S); Rate*timeAtStep(S+1) } = valueAtStep(velocity,S+1) :-
    trajectoryAtStep(falling, _, velocity, S+1),
    initiallyP(constant_fall_rate(Rate)),
    step(S), step(S+1).


% rising
trajectory(rising, S1, height, S2) :- step(S1), step(S2).
&sum{ valueAtStep(height,S); -Rate*timeAtStep(S); Rate*timeAtStep(S+1) } = valueAtStep(height,S+1) :-
    trajectoryAtStep(rising, _, height, S+1),
    initiallyP(constant_fall_rate(Rate)),
    step(S), step(S+1).

trajectory(rising, S1, velocity, S2) :- step(S1), step(S2).
&sum{ (1-LossPortion)*valueAtStep(velocity,S); Rate*timeAtStep(S); -Rate*timeAtStep(S+1) } = valueAtStep(velocity,S+1) :-
    trajectoryAtStep(rising, _, velocity, S+1),
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
    trajectoryAtStep(falling, S1, velocity, S),
    normal_atom(aux__fallDurAtStep(S), gt, MinDur),
    normal_atom(valueAtStep(velocity, S), gt, 0),
    step(S), step(S1).
%comparison(valueAtStep(velocity, S), 0) :- step(S).
comparison(aux__fallDurAtStep(S2), MinDur) :- minDuration(MinDur), step(S2).
    %comparison(aux__fallDurAtStep(S2), MinDur) :- minDuration(MinDur), trajectoryAtStep(falling, S1, velocity, S2), step(S1), step(S2).
&sum{timeAtStep(S2) - timeAtStep(S1)} = aux__fallDurAtStep(S2) :- trajectoryAtStep(falling, S1, velocity, S2), step(S1), step(S2).
defined(aux__fallDurAtStep(S2)) :- trajectoryAtStep(falling, S1, velocity, S2), step(S1), step(S2).
&sum{0} = aux__fallDurAtStep(S2) :- not defined(aux__fallDurAtStep(S2)), step(S1), step(S2).

happensAtStep(stop_bouncing, S) :- happensAtStep(hit_ground, S),
    holdsAtStep(falling, S),
    % stop bouncing if the falling trajectory took shorter than some minimum duration
    minDuration(MinDur),
    trajectoryAtStep(falling, S1, velocity, S),
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