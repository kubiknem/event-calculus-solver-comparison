
% ----- domain model -----

% event(turn_light_on).       % start the fading process
% event(turn_light_off).
% event(fade_in_end).         % stop fading in and start fading out (dimming)
% event(fade_out_end).        % stop fading out (dimming) and starting fading in

fluent(light_on).
fluentF(brightness).      % range 0-10
fluent(fading_in).
fluent(fading_out).

terminatesAtStep(fade_in_end, fading_in, S) :- step(S).
initiatesAtStep(fade_in_end, fading_out, S) :- step(S).

terminatesAtStep(fade_out_end, fading_out, S) :- step(S).
initiatesAtStep(fade_out_end, fading_in, S) :- step(S).

initiatesAtStep(turn_light_on,  light_on, S) :- step(S).
initiatesAtStep(turn_light_on, fading_in, S) :- step(S).

terminatesAtStepF(turn_light_on, brightness, valueAtStep(brightness, S), S) :- step(S).
%releases(turn_light_on, brightness(X), S) :- step(S).

terminatesAtStep(turn_light_off, light_on, S) :- step(S).
terminatesAtStep(turn_light_off, fading_in, S) :- holdsAtStep(fading_in, S).
terminatesAtStep(turn_light_off, fading_out, S) :- holdsAtStep(fading_out, S).

initiatesAtStepF(turn_light_off, brightness, valueAtStep(brightness, S+1), S) :- step(S).
&sum{valueAtStep(brightness,S+1)} = 0 :-
    initiatedByAtStepF(turn_light_off, brightness, valueAtStep(brightness,S+1), S).
%terminates(turn_light_off, brightness(X), S) :- X .<>. 0.

trajectory(fading_in, S1, brightness, valueAtStep(brightness,S2), S2) :- step(S1), step(S2).
&sum{ valueAtStep(brightness,S); -timeAtStep(S); timeAtStep(S+1) } = valueAtStep(brightness,S+1) :-
    trajectoryAtStep(fading_in, _, brightness, valueAtStep(brightness,S+1), S+1),
    step(S), S < maxstep.

trajectory(fading_out, S1, brightness, valueAtStep(brightness,S2), S2) :- step(S1), step(S2).
&sum{ valueAtStep(brightness,S); timeAtStep(S); -timeAtStep(S+1) } = valueAtStep(brightness,S+1) :-
    trajectoryAtStep(fading_out, _, brightness, valueAtStep(brightness,S+1), S+1),
    step(S), S < maxstep.


happensAtStep(fade_in_end, S) :-
    holdsAtStep(fading_in, S),
    normal_atom(valueAtStep(brightness, S), eq, 10).
comparison(valueAtStep(brightness, S), 10) :- step(S). 


happensAtStep(fade_out_end, S) :-
    holdsAtStep(fading_out, S),
    normal_atom(valueAtStep(brightness, S), eq, 0).
comparison(valueAtStep(brightness, S), 0) :- step(S). 


% TODO this is a TMP workaround since releasedAt is not implemented yet 
terminatesAtStepF(fade_in_end, brightness, valueAtStep(brightness, S), S) :- step(S).
terminatesAtStepF(fade_out_end, brightness, valueAtStep(brightness, S), S) :- step(S).


% ----- narrative & queries  -----

initiallyPF(brightness, 0).
%initiallyN(light_on).
initiallyN(F) :- not initiallyP(F), fluent(F).

happens(turn_light_on,      10).
happens(turn_light_off,     45).

% ?- holdsAt(brightness(X),   10).    % 0
% 
% ?- happens(fade_in_end,     20).    % non-term. 
% ?- holdsAt(brightness(X),   20).    % non-term., 10
% 
% ?- happens(fade_out_end,    30).    % non-term.
% ?- holdsAt(brightness(X),   30).    % non-term., 0
% 
% ?- happens(fade_in_end,     40).    % non-term.
% ?- holdsAt(brightness(X),   40).    % non-term., 10
% 
% ?- happens(fade_in_end,     T).     % 20, 40
% ?- happens(fade_out_end,    T).     % 30

