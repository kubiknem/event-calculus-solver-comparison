
% ----- domain model -----

fluent_Func(water_left).
fluent_Func(water_right).
fluent(left_filling).
fluent(right_filling).  % replaced left_draining

event(start(left)).
event(start(right)).
% event(switch_left).
% event(switch_right).

initiatesAtStep(start(left), left_filling, S) :- step(S).
initiatesAtStep(start(right), right_filling, S) :- step(S).
releasesAtStep(start(LR), water_left, S) :- step(S), event(start(LR)).
releasesAtStep(start(LR), water_right, S) :- step(S), event(start(LR)).

initiatesAtStep(switch_left, left_filling, S) :- step(S).
terminatesAtStep(switch_left, right_filling, S) :- step(S).

terminatesAtStep(switch_right, left_filling, S) :- step(S).
initiatesAtStep(switch_right, right_filling, S) :- step(S).

trajectory(left_filling, S1, water_left, S2) :- step(S1), step(S2).
&sum{ valueAtStep(water_left,S); -TotalFlow*timeAtStep(S); TotalFlow*timeAtStep(S+1) } = valueAtStep(water_left,S+1) :-
    trajectoryAtStep(left_filling, _, water_left, S+1),
    TotalFlow = 30 - 20, % in rate 30, out rate 20
    step(S), step(S+1).

trajectory(right_filling, S1, water_left, S2) :- step(S1), step(S2).
&sum{ valueAtStep(water_left,S); TotalFlow*timeAtStep(S); -TotalFlow*timeAtStep(S+1) } = valueAtStep(water_left,S+1) :-
    trajectoryAtStep(right_filling, _, water_left, S+1),
    TotalFlow = 20, % out rate 20
    step(S), step(S+1).

trajectory(right_filling, S1, water_right, S2) :- step(S1), step(S2).
&sum{ valueAtStep(water_right,S); -TotalFlow*timeAtStep(S); TotalFlow*timeAtStep(S+1) } = valueAtStep(water_right,S+1) :-
    trajectoryAtStep(right_filling, _, water_right, S+1),
    TotalFlow = 30 - 20, % in rate 30, out rate 20
    step(S), step(S+1).

trajectory(left_filling, S1, water_right, S2) :- step(S1), step(S2).
&sum{ valueAtStep(water_right,S); TotalFlow*timeAtStep(S); -TotalFlow*timeAtStep(S+1) } = valueAtStep(water_right,S+1) :-
    trajectoryAtStep(left_filling, _, water_right, S+1),
    TotalFlow = 20, % out rate 20
    step(S), step(S+1).

minDuration(1).
% trigger exactly at 50 if the trajectory took at least the minimum duration
happensAtStep(switch_left, S) :-
    holdsAtStep(right_filling, S),
    trajectoryAtStep(right_filling, S1, water_left, S),
    happensAtStep(aux__endMinDurRightFilling(S1), S2), S1 < S2, S2 <= S,
    normal_atom(valueAtStep(water_left, S), eq, 50). % target level
% trigger exactly after the minimum duration if the level is below 50
happensAtStep(switch_left, S) :-
    holdsAtStep(right_filling, S),
    trajectoryAtStep(right_filling, S1, water_left, S),
    happensAtStep(aux__endMinDurRightFilling(S1), S),
    normal_atom(valueAtStep(water_left, S), lt, 50). % target level
%comparison(valueAtStep(water_left, S), 50) :- step(S).

% trigger exactly at 50 if the trajectory took at least the minimum duration
happensAtStep(switch_right, S) :-
    holdsAtStep(left_filling, S),
    trajectoryAtStep(left_filling, S1, water_right, S),
    happensAtStep(aux__endMinDurLeftFilling(S1), S2), S1 < S2, S2 <= S,
    normal_atom(valueAtStep(water_right, S), eq, 50). % target level
% trigger exactly after the minimum duration if the level is below 50
happensAtStep(switch_right, S) :-
    holdsAtStep(left_filling, S),
    trajectoryAtStep(left_filling, S1, water_right, S),
    happensAtStep(aux__endMinDurLeftFilling(S1), S),
    normal_atom(valueAtStep(water_right, S), lt, 50). % target level
%comparison(valueAtStep(water_right, S), 50) :- step(S).


% TODO had to break down the below manually because 50 is only significant in one direction (when draining the corresponding tank, not when filling)
%trigger_value(water_left, 50).
    comparison(valueAtStep(water_left, S), 50) :- step(S). 
    :- normal_atom(valueAtStep(water_left, S), gt, 50), normal_atom(valueAtStep(water_left, S+1), lt, 50), step(S), step(S+1).
    %:- normal_atom(valueAtStep(water_left, S), lt, 50), normal_atom(valueAtStep(water_left, S+1), gt, 50), step(S), step(S+1).
%trigger_value(water_right, 50).
    comparison(valueAtStep(water_right, S), 50) :- step(S). 
    :- normal_atom(valueAtStep(water_right, S), gt, 50), normal_atom(valueAtStep(water_right, S+1), lt, 50), step(S), step(S+1).
    %:- normal_atom(valueAtStep(water_right, S), lt, 50), normal_atom(valueAtStep(water_right, S+1), gt, 50), step(S), step(S+1).

% TODO this needs to be discussed -- the constraint below seems to be needed in general, but will be a problem here since we dont allow steps with no events
%! the above forces a step with exactly 50, which would not work for the zeno-free version since there might be no event at step 50 
% TODO this does hack around the restriction... 
happensAtStep(aux__no_switch_right, S) :- step(S), holdsAtStep(left_filling, S), normal_atom(valueAtStep(water_right, S), eq, 50), not happensAtStep(switch_right, S).
happensAtStep(aux__no_switch_left, S) :- step(S), holdsAtStep(right_filling, S), normal_atom(valueAtStep(water_left, S), eq, 50), not happensAtStep(switch_left, S).


% TODO this needs to be discussed
% TODO this works but requires steps to be incremented by 2 (model at N, no model at N+1, model at N+2)
% trying to trigger an event MinDur time after switch_left/right happens
{happensAtStep(aux__endMinDurRightFilling(S1), S2) : step(S2), S2 > S1} = 1 :- happensAtStep(switch_right, S1), S1 < maxstep.
{happensAtStep(aux__endMinDurRightFilling(S1), S2) : step(S2), S2 > S1} = 1 :- happensAtStep(start(right), S1), S1 < maxstep.
&sum{timeAtStep(S1) + MinDur} = timeAtStep(S2) :- minDuration(MinDur), happensAtStep(switch_right, S1), S1 < maxstep, happensAtStep(aux__endMinDurRightFilling(S1), S2).
&sum{timeAtStep(S1) + MinDur} = timeAtStep(S2) :- minDuration(MinDur), happensAtStep(start(right), S1), S1 < maxstep, happensAtStep(aux__endMinDurRightFilling(S1), S2).

{happensAtStep(aux__endMinDurLeftFilling(S1), S2) : step(S2), S2 > S1} = 1 :- happensAtStep(switch_left, S1), S1 < maxstep.
{happensAtStep(aux__endMinDurLeftFilling(S1), S2) : step(S2), S2 > S1} = 1 :- happensAtStep(start(left), S1), S1 < maxstep.
&sum{timeAtStep(S1) + MinDur} = timeAtStep(S2) :- minDuration(MinDur), happensAtStep(switch_left, S1), S1 < maxstep, happensAtStep(aux__endMinDurLeftFilling(S1), S2).
&sum{timeAtStep(S1) + MinDur} = timeAtStep(S2) :- minDuration(MinDur), happensAtStep(start(left), S1), S1 < maxstep, happensAtStep(aux__endMinDurLeftFilling(S1), S2).


% ----- narrative & queries  -----

initiallyP_Func(water_left, 100).
initiallyP_Func(water_right, 100).
initiallyN(F) :- not initiallyP(F), fluent(F).

happens(start(right),           10).

% ?- happens(switch_left,         25/2).%(12.5)
% 
% ?- happens(switch_right,        65/4).%(16.25)
% 
% ?- happens(switch_left,         145/8).%(18.125)
% 
% ?- happens(switch_right,        153/8).
% 
% ?- happens(switch_left,         161/8)).
% 
