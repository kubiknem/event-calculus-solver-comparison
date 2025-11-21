
#const maxstep=6.
#const maxtime=1000.

% ----- domain model -----

event(turn_light_on).       % start the fading process
event(turn_light_off).
event(fade_in_end).         % stop fading in and start fading out (dimming)
event(fade_out_end).        % stop fading out (dimming) and starting fading in

dfluent(light_on).
ffluent(brightness).        % range 0-10
dfluent(fading_in).
dfluent(fading_out).

terminates(fade_in_end, fading_in, T) :- time(T).
initiates(fade_in_end, fading_out, T) :- time(T).

terminates(fade_out_end, fading_out, T) :- time(T).
initiates(fade_out_end, fading_in, T) :- time(T).

initiates(turn_light_on,  light_on, T) :- time(T).
initiates(turn_light_on, fading_in, T) :- time(T).

releases(turn_light_on, brightness, T) :- time(T).

terminates(turn_light_off, light_on, T) :- time(T).
terminates(turn_light_off, fading_in, T) :- holdsAt(fading_in, T).
terminates(turn_light_off, fading_out, T) :- holdsAt(fading_out, T).

initiates(turn_light_off, brightness, (0, 0, 0, brightness), T) :- time(T).

trajectory(fading_in, T1, brightness, (0, 1, 0, brightness, 1), T2) :- time(T1), time(T2).

trajectory(fading_out, T1, brightness, (0, 1, 0, brightness, -1), T2) :- time(T1), time(T2).


happens(fade_in_end, T) :-
    holdsAt(fading_in, T),
    normal_atom(fholdsAt(brightness, T), eq, 10),
    time(T).
    
trigger_value(brightness, fading_in, 10).

happens(fade_out_end, T) :-
    holdsAt(fading_out, T),
    normal_atom(fholdsAt(brightness, T), eq, 0),
    time(T).

trigger_value(brightness, fading_out, 0).
       

% ----- narrative & queries  -----

initiallyP(brightness, 0).
initiallyN(F) :- not initiallyP(F), fluent(F).

in_happens(turn_light_on,      10).
in_happens(turn_light_off,     45).

% ?- holdsAt(brightness(X),   10).    % 0
% 
% ?- in_happens(fade_in_end,     20).    % non-term. 
% ?- holdsAt(brightness(X),   20).    % non-term., 10
% 
% ?- in_happens(fade_out_end,    30).    % non-term.
% ?- holdsAt(brightness(X),   30).    % non-term., 0
% 
% ?- in_happens(fade_in_end,     40).    % non-term.
% ?- holdsAt(brightness(X),   40).    % non-term., 10
% 
% ?- in_happens(fade_in_end,     T).     % 20, 40
% ?- in_happens(fade_out_end,    T).     % 30

