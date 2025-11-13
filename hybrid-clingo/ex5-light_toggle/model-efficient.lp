% light can be turned on and off

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% event(toggle_light).

fluent(light_on).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

% TODO this feels strange because the effect of an event is defined based on "holds" from the previous step instead of the current step
% initiates(toggle_light,  light_on, T) :- time(T).
holds(light_on, true, S) :- happens_state(toggle_light, S), holds(light_on, false, S-1).

% terminates(toggle_light, light_on, T) :- time(T).
holds(light_on, false, S) :- happens_state(toggle_light, S), holds(light_on, true, S-1).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(light_on).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(toggle_light,      10).
happens(toggle_light,      20).

% conclude that the light is on between 10 and 20
