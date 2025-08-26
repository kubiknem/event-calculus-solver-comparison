% light can be turned on and off using a single toggle event whose effect is 
% context dependent

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% event(toggle_light).

fluent(light_on).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

% initiates(turn_light_on,  light_on, T) :- time(T).
initiatesAtStep(toggle_light,  light_on, S) :- -holdsAtStep(light_on, S).

% terminates(turn_light_off, light_on, T) :- time(T).
terminatesAtStep(toggle_light, light_on, S) :- holdsAtStep(light_on, S).


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
