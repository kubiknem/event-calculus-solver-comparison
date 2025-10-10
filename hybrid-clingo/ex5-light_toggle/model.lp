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

% initiates(toggle_light,  light_on, T) :- -holdsAt(light_on, T), time(T).
initiatesAtStep(toggle_light,  light_on, S) :- not holdsAtStep(light_on, S), step(S).

% terminates(toggle_light, light_on, T) :- holdsAt(light_on, T), time(T).
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
