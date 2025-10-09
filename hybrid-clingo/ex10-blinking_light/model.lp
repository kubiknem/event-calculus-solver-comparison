
% ----- domain model -----

% event(turn_light_on).
% event(turn_light_off).

fluent(light_on).

initiatesAtStep(turn_light_on,  light_on, S) :- step(S).
terminatesAtStep(turn_light_off, light_on, S) :- step(S).


happensAtStep(turn_light_off, S) :- holdsAtStep(light_on, S), step(S).

happensAtStep(turn_light_on, S) :- -holdsAtStep(light_on, S), step(S).


% ----- narrative & queries  -----

% initiallyN(light_on). % no initial value means no triggers until the first event
happens(turn_light_on,      10).

% TODO clingo-lpx can automatically use 'e' (I assume 'epsilon') to represent an infinitely small time step
