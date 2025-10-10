
% ----- domain model -----

% fluents
fluentF(height).
fluentF(velocity).

fluent(falling).
fluent(rising).

fluentF(constant_fall_rate).        % simplified to a constant fall rate instead of accelerating over time
fluentF(velocity_loss_portion).     % ball looses a portion of velocity on each bounce

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
releasesAtStepF(drop, height, valueAtStep(height, S+1), S) :- step(S).
releasesAtStepF(drop, velocity, valueAtStep(velocity, S+1), S) :- step(S).


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

initiatesAtStepF(catch, height, valueAtStep(height, S+1), S) :- step(S).
&sum{valueAtStep(height,S+1)} = valueAtStep(height,S) :- initiatedByAtStepF(catch, height, valueAtStep(height,S+1), S).
terminatesAtStepF(catch, height, valueAtStep(height, S), S) :- step(S).

initiatesAtStepF(catch, velocity, valueAtStep(velocity, S+1), S) :- step(S).
&sum{valueAtStep(velocity,S+1)} = 0 :- initiatedByAtStepF(catch, velocity, valueAtStep(velocity,S+1), S).
terminatesAtStepF(catch, velocity, valueAtStep(velocity, S), S) :- step(S).

% stop everything if the ball stops bouncing
initiatesAtStepF(stop_bouncing, height, valueAtStep(height, S+1), S) :- step(S).
&sum{valueAtStep(height,S+1)} = 0 :- initiatedByAtStepF(stop_bouncing, height, valueAtStep(height,S+1), S).
terminatesAtStepF(stop_bouncing, height, valueAtStep(height, S), S) :- step(S).

initiatesAtStepF(stop_bouncing, velocity, valueAtStep(velocity, S+1), S) :- step(S).
&sum{valueAtStep(velocity,S+1)} = 0 :- initiatedByAtStepF(stop_bouncing, velocity, valueAtStep(velocity,S+1), S).
terminatesAtStepF(stop_bouncing, velocity, valueAtStep(velocity, S), S) :- step(S).


% falling 
trajectory(falling, S1, height, valueAtStep(height, S2), S2) :- step(S1), stepMax(S2).
&sum{ valueAtStep(height,S); Rate*timeAtStep(S); -Rate*timeAtStep(S+1) } = valueAtStep(height,S+1) :-
    trajectoryAtStep(falling, _, height, valueAtStep(height,S+1), S+1),
    initiallyPF(constant_fall_rate, Rate),
    step(S), S < maxstep.

trajectory(falling, S1, velocity, valueAtStep(velocity, S2), S2) :- step(S1), stepMax(S2).
&sum{ valueAtStep(velocity,S); -Rate*timeAtStep(S); Rate*timeAtStep(S+1) } = valueAtStep(velocity,S+1) :-
    trajectoryAtStep(falling, _, velocity, valueAtStep(velocity,S+1), S+1),
    initiallyPF(constant_fall_rate, Rate),
    step(S), S < maxstep.


% rising
trajectory(rising, S1, height, valueAtStep(height, S2), S2) :- step(S1), stepMax(S2).
&sum{ valueAtStep(height,S); -Rate*timeAtStep(S); Rate*timeAtStep(S+1) } = valueAtStep(height,S+1) :-
    trajectoryAtStep(rising, _, height, valueAtStep(height,S+1), S+1),
    initiallyPF(constant_fall_rate, Rate),
    step(S), S < maxstep.

trajectory(rising, S1, velocity, valueAtStep(velocity, S2), S2) :- step(S1), stepMax(S2).
&sum{ (1-LossPortion)*valueAtStep(velocity,S); Rate*timeAtStep(S); -Rate*timeAtStep(S+1) } = valueAtStep(velocity,S+1) :-
    trajectoryAtStep(rising, _, velocity, valueAtStep(velocity,S+1), S+1),
    initiallyPF(constant_fall_rate, Rate),
    initiallyPF(velocity_loss_portion, LossPortion),
    step(S), S < maxstep.


happens(fall_down, T) :- happens(drop, T).

happensAtStep(hit_ground, S) :- 
    holdsAtStep(falling, S),
    normal_atom(valueAtStep(height, S), eq, 0).
comparison(valueAtStep(height, S), 0) :- step(S).

happensAtStep(bounce_up, S) :- happensAtStep(hit_ground, S),
    holdsAtStep(falling, S),
    normal_atom(valueAtStep(velocity, S), gt, 0).
comparison(valueAtStep(velocity, S), 0) :- step(S).

happensAtStep(stop_bouncing, S) :- happensAtStep(hit_ground, S),
    holdsAtStep(falling, S),
    normal_atom(valueAtStep(velocity, S), eq, 0).

happensAtStep(reach_apex, S) :-
    holdsAtStep(rising, S),
    normal_atom(valueAtStep(velocity, S), eq, 0).

happensAtStep(fall_down, S) :- happensAtStep(reach_apex, S).


% ----- narrative & queries  -----

initiallyPF(height, 10).
initiallyPF(velocity, 0).
initiallyPF(constant_fall_rate, 1).
initiallyPF(velocity_loss_portion, "0.75").

initiallyN(F) :- not initiallyP(F), fluent(F).

happens(drop,                           10).

%?- happens(hit_ground,                  T).     % 20, 25, 26.25, 26.40625,...

%happens(catch,                          26).
%    ?- holdsAt(height(X),               30).    % 0.25
%    ?- holdsAt(velocity(X),             30).    % 0

%?- happens(hit_ground,                  T).     % 20, 25

