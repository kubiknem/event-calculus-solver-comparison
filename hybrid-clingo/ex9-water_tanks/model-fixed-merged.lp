
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
    minDuration(MinDur),
    trajectoryAtStep(right_filling, S1, water_left, S),
    normal_atom(aux__rightFillDurAtStep(S), geq, MinDur),
    normal_atom(valueAtStep(water_left, S), eq, 50). % target level
% trigger exactly after the minimum duration if the level is below 50
happensAtStep(switch_left, S) :-
    holdsAtStep(right_filling, S),
    minDuration(MinDur),
    trajectoryAtStep(right_filling, S1, water_left, S),
    normal_atom(aux__rightFillDurAtStep(S), eq, MinDur),
    normal_atom(valueAtStep(water_left, S), lt, 50). % target level
%comparison(valueAtStep(water_left, S), 50) :- step(S).

&sum{timeAtStep(S2) - timeAtStep(S1)} = aux__rightFillDurAtStep(S2) :- trajectoryAtStep(right_filling, S1, water_left, S2), step(S1), step(S2).
comparison(aux__rightFillDurAtStep(S2), MinDur) :- minDuration(MinDur), step(S2).
    %comparison(aux__rightFillDurAtStep(S2), MinDur) :- minDuration(MinDur), trajectoryAtStep(right_filling, S1, water_left, S2), step(S1), step(S2).
defined(aux__rightFillDurAtStep(S2)) :- trajectoryAtStep(right_filling, S1, water_left, S2), step(S1), step(S2).
&sum{0} = aux__rightFillDurAtStep(S2) :- not defined(aux__rightFillDurAtStep(S2)), step(S2).

% trigger exactly at 50 if the trajectory took at least the minimum duration
happensAtStep(switch_right, S) :-
    holdsAtStep(left_filling, S),
    minDuration(MinDur),
    trajectoryAtStep(left_filling, S1, water_right, S),
    normal_atom(aux__leftFillDurAtStep(S), geq, MinDur),
    normal_atom(valueAtStep(water_right, S), eq, 50). % target level
% trigger exactly after the minimum duration if the level is below 50
happensAtStep(switch_right, S) :-
    holdsAtStep(left_filling, S),
    minDuration(MinDur),
    trajectoryAtStep(left_filling, S1, water_right, S),
    normal_atom(aux__leftFillDurAtStep(S), eq, MinDur),
    normal_atom(valueAtStep(water_right, S), lt, 50). % target level
%comparison(valueAtStep(water_right, S), 50) :- step(S).

comparison(aux__leftFillDurAtStep(S2), MinDur) :- minDuration(MinDur), step(S2).
    %comparison(aux__leftFillDurAtStep(S2), MinDur) :- minDuration(MinDur), trajectoryAtStep(left_filling, S1, water_right, S2), step(S1), step(S2).
&sum{timeAtStep(S2) - timeAtStep(S1)} = aux__leftFillDurAtStep(S2) :- trajectoryAtStep(left_filling, S1, water_right, S2), step(S1), step(S2).
defined(aux__leftFillDurAtStep(S2)) :- trajectoryAtStep(left_filling, S1, water_right, S2), step(S1), step(S2).
&sum{0} = aux__leftFillDurAtStep(S2) :- not defined(aux__leftFillDurAtStep(S2)), step(S2).


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


% TODO this needs to be discussed -- we probably should have this constraint but it causes duplicate models 6 steps and "no models" at 7
% TODO this does not work, this example might miss stepping exactly at the duration...
%% :- holdsAtStep(right_filling, S+1), normal_atom(aux__rightFillDurAtStep(S), lt, MinDur), normal_atom(aux__rightFillDurAtStep(S+1), gt, MinDur), minDuration(MinDur), step(S), step(S+1).
%% happensAtStep(aux__no_switch_left_dur, S) :- step(S), holdsAtStep(right_filling, S), normal_atom(aux__rightFillDurAtStep(S), eq, MinDur), minDuration(MinDur), not happensAtStep(switch_left, S).
%% 
%% :- holdsAtStep(left_filling, S+1), normal_atom(aux__leftFillDurAtStep(S), lt, MinDur), normal_atom(aux__leftFillDurAtStep(S+1), gt, MinDur), minDuration(MinDur), step(S), step(S+1).
%% happensAtStep(aux__no_switch_right_dur, S) :- step(S), holdsAtStep(left_filling, S), normal_atom(aux__leftFillDurAtStep(S), eq, MinDur), minDuration(MinDur), not happensAtStep(switch_right, S).

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
