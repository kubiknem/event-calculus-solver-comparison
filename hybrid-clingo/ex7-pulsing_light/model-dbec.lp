
% ----- domain model -----

% event(turn_light_on).       % start the fading process
% event(turn_light_off).
% event(fade_in_end).         % stop fading in and start fading out (dimming)
% event(fade_out_end).        % stop fading out (dimming) and starting fading in

fluent(light_on).
fluent_Func(brightness).      % range 0-10
fluent(fading_in).
fluent(fading_out).

terminatesAtStep(fade_in_end, fading_in, S) :- step(S).
initiatesAtStep(fade_in_end, fading_out, S) :- step(S).

terminatesAtStep(fade_out_end, fading_out, S) :- step(S).
initiatesAtStep(fade_out_end, fading_in, S) :- step(S).

initiatesAtStep(turn_light_on,  light_on, S) :- step(S).
initiatesAtStep(turn_light_on, fading_in, S) :- step(S).

releasesAtStep(turn_light_on, brightness, S) :- step(S).

terminatesAtStep(turn_light_off, light_on, S) :- step(S).
terminatesAtStep(turn_light_off, fading_in, S) :- holdsAtStep(fading_in, S).
terminatesAtStep(turn_light_off, fading_out, S) :- holdsAtStep(fading_out, S).

initiatesValueAtStep(turn_light_off, brightness, S) :- step(S).
&sum{valueAtStep(brightness,S+1)} = 0 :-
    initiatedValueByAtStep(turn_light_off, brightness, S),
    step(S+1).

trajectory(fading_in, S1, brightness, S2) :- step(S1), step(S2).
&sum{ valueAtStep(brightness,S); -timeAtStep(S); timeAtStep(S+1) } = valueAtStep(brightness,S+1) :-
    trajectoryAtStep(fading_in, _, brightness, S+1),
    step(S), step(S+1).

trajectory(fading_out, S1, brightness, S2) :- step(S1), step(S2).
&sum{ valueAtStep(brightness,S); timeAtStep(S); -timeAtStep(S+1) } = valueAtStep(brightness,S+1) :-
    trajectoryAtStep(fading_out, _, brightness, S+1),
    step(S), step(S+1).


happensAtStep(fade_in_end, S) :-
    holdsAtStep(fading_in, S),
    normal_atom(valueAtStep(brightness, S), eq, 10).
%comparison(valueAtStep(brightness, S), 10) :- step(S). 

happensAtStep(fade_out_end, S) :-
    holdsAtStep(fading_out, S),
    normal_atom(valueAtStep(brightness, S), eq, 0).
%comparison(valueAtStep(brightness, S), 0) :- step(S). 

% TODO this is not needed for this particular example, but is needed in general
% TODO the usual formulation caused problems, had to break it down manually
%trigger_value(brightness, 0).
    comparison(valueAtStep(brightness, S), 0) :- step(S). 
    :- normal_atom(valueAtStep(brightness, S), gt, 0), normal_atom(valueAtStep(brightness, S+1), lt, 0), step(S), step(S+1).
    :- normal_atom(valueAtStep(brightness, S), lt, 0), normal_atom(valueAtStep(brightness, S+1), gt, 0), step(S), step(S+1).
%trigger_value(brightness, 10).
    comparison(valueAtStep(brightness, S), 10) :- step(S). 
    :- normal_atom(valueAtStep(brightness, S), lt, 10), normal_atom(valueAtStep(brightness, S+1), gt, 10), step(S), step(S+1).
    %! TODO this constraint would cause "no models" --> why?
    %:- normal_atom(valueAtStep(brightness, S), gt, 10), normal_atom(valueAtStep(brightness, S+1), lt, 10), step(S), step(S+1).

%% TODO possible alternative to the above?
% :- not stepAt(0).
% stepAt(10) :- normal_atom(valueAtStep(brightness, S), eq, 10).
% :- not stepAt(10).
% stepAt(0) :- normal_atom(valueAtStep(brightness, S), eq, 0).


% ----- narrative & queries  -----

initiallyP_Func(brightness, 0).
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

