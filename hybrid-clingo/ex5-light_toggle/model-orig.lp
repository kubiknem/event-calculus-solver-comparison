% light can be turned on and off

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% event(turn_light_on).
% event(turn_light_off).

fluent(light_on).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

% TODO this feels strange because the effect of an event is defined based on "holds" from the previous step instead of the current step
% initiates(turn_light_on,  light_on, T) :- time(T).
holds(light_on, true, S) :- happens_state(turn_light_on, S), holds(light_on, false, S-1).

% terminates(turn_light_off, light_on, T) :- time(T).
holds(light_on, false, S) :- happens_state(turn_light_off, S), holds(light_on, true, S-1).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(light_on).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(turn_light_on,      10).
happens(turn_light_off,     20).

% conclude that the light is on between 10 and 20
