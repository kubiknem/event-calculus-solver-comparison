#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.


%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

%% max_time(PARAMETER).     %% added on execution via an external file

event(turn_light_on).
event(turn_light_off).

fluent(light_on).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

initiates(turn_light_on,  light_on, T).
terminates(turn_light_off, light_on, T).


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
?- holdsAt(light_on,        T).     % T #> 10,T #=< 20
