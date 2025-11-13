
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

happensAtStep(switch_left, S) :-
    holdsAtStep(right_filling, S),
    normal_atom(valueAtStep(water_left, S), leq, 50). % target level
%comparison(valueAtStep(water_left, S), 50) :- step(S).

happensAtStep(switch_right, S) :-
    holdsAtStep(left_filling, S),
    normal_atom(valueAtStep(water_right, S), leq, 50). % target level
%comparison(valueAtStep(water_right, S), 50) :- step(S).

% this is needed bc of the leq above
trigger_value(water_left, 50).
trigger_value(water_right, 50).


% ----- narrative & queries  -----

initiallyP_Func(water_left, 100).
initiallyP_Func(water_right, 100).
initiallyN(F) :- not initiallyP(F), fluent(F).

happens(start(right),           10).

% ?- happens(switch_left,         25/2).%(12.5)       % non-term., should be yes
% ?- holdsAt(water_left(X),       25/2).%(12.5)       % non-term., should be 50
% ?- holdsAt(water_right(X),      25/2).%(12.5)       % non-term., should be 125
% 
% ?- happens(switch_right,        65/4).%(16.25)      % non-term., should be yes
% ?- holdsAt(water_left(X),       65/4).%(16.25)      % non-term., should be 87.5 (175/2)
% ?- holdsAt(water_right(X),      65/4).%(16.25)      % non-term., should be 50
% 
% ?- happens(switch_left,         145/8).%(18.125)    % non-term., should be yes
% ?- holdsAt(water_left(X),       145/8).%(18.125)    % non-term., should be 50
% ?- holdsAt(water_right(X),      145/8).%(18.125)    % non-term., should be 68.75 (275/4)
% 
% ?- happens(switch_right,        305/16).%(19.0625)  % non-term., should be yes
% ?- holdsAt(water_left(X),       305/16).%(19.0625)  % non-term., should be 59.375 (475/8)
% ?- holdsAt(water_right(X),      305/16).%(19.0625)  % non-term., should be 50
% 
% ?- happens(switch_left,         625/32).%(19.53125) % non-term., should be yes
% ?- holdsAt(water_left(X),       625/32).%(19.53125) % non-term., should be 50
% ?- holdsAt(water_right(X),      625/32).%(19.53125) % non-term., should be 54.6875 (875/16)
% 
% ?- T .=<. 19.5, happens(switch_left,  T).           % non-term., should be % 25/2 (12.5), 145/8 (18.125)
% ?- T .=<. 19.5, happens(switch_right, T).           % non-term., should be 65/4 (16.25), 305/16 (19.0625)
% ?- holdsAt(water_right(X),      19.5).              % non-term., should be 435/8 (54.375)
% ?- holdsAt(water_left(X),       19.5).              % non-term., should be 405/8 (50.625)

