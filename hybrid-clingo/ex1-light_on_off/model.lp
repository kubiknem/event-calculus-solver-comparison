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

% initiates(turn_light_on,  light_on, T) :- time(T).
holds(light_on, true, S) :- happens_state(turn_light_on, S).

% terminates(turn_light_off, light_on, T) :- time(T).
holds(light_on, false, S) :- happens_state(turn_light_off, S).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(light_on).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(turn_light_on,      10/3).
happens(turn_light_off,     20).

% conclude that the light is on between 10 and 20
