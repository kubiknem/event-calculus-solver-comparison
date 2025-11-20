% light can be turned on and off

#const maxstep=3.
#const maxtime=1000.


%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

event(turn_light_on).
event(turn_light_off).

dfluent(light_on).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

initiates(turn_light_on,  light_on, T) :- time(T).

terminates(turn_light_off, light_on, T) :- time(T).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(light_on).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

in_happens(turn_light_on,   10).
in_happens(turn_light_off,  20).

% conclude that the light is on between 10 and 20

% enables showing of -holdsAt and -releasedAt
negated_prints.