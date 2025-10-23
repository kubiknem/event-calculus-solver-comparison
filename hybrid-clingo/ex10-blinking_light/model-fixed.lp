
% ----- domain model -----

% event(turn_light_on).
% event(turn_light_off).

fluent(light_on).

initiatesAtStep(turn_light_on,  light_on, S) :- step(S).
terminatesAtStep(turn_light_off, light_on, S) :- step(S).


happensAtStep(turn_light_off, S) :- holdsAtStep(light_on, S), step(S).

happensAtStep(turn_light_on, S) :- not holdsAtStep(light_on, S), step(S),
    S > 1. % TODO to avoid triggering before the first event


% time epsilon to trigger on/off(A)
% TODO what if some other event happened in between S and S+1? --- probably need to ensure that epsilon is "small enough"?
epsilon("1.1"). % valid with clingo-lpx
&sum{ timeAtStep(S+1); -timeAtStep(S) } = E :- epsilon(E),
    happensAtStep(turn_light_on, S+1),
    step(S), step(S+1), 
    S > 0.
&sum{ timeAtStep(S+1); -timeAtStep(S) } = E :- epsilon(E),
    happensAtStep(turn_light_off, S+1),
    step(S), step(S+1), 
    S > 0.


% ----- narrative & queries  -----

happens(turn_light_on,      10).
