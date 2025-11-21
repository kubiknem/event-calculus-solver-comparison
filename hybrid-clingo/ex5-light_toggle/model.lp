% light can be turned on and off

#const maxstep=3.
#const maxtime=1000.


%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

event(toggle_light).

dfluent(light_on).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

initiates(toggle_light,  light_on, T) :- not holdsAt(light_on, T), time(T).

terminates(toggle_light, light_on, T) :- holdsAt(light_on, T), time(T).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(light_on).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

in_happens(toggle_light,   10).
in_happens(toggle_light,  20).

% conclude that the light is on between 10 and 20

% enables showing of -holdsAt and -releasedAt
negated_prints.