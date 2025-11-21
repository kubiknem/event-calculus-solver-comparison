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



% happens(toggle_light,     30).                                      % < 1s
% happens(toggle_light,     40). happens(toggle_light,     50).       % < 1s
% happens(toggle_light,     60). happens(toggle_light,     70).       % < 1s
% happens(toggle_light,     80). happens(toggle_light,     90).       % < 1s
% happens(toggle_light,     100). happens(toggle_light,     110).     % < 1s
% happens(toggle_light,     120). happens(toggle_light,     130).     %
% happens(toggle_light,     140). happens(toggle_light,     150).     %
% happens(toggle_light,     160). happens(toggle_light,     170).     %
% happens(toggle_light,     180). happens(toggle_light,     190).     %
% happens(toggle_light,     200). happens(toggle_light,     210).     %
% happens(toggle_light,     220). happens(toggle_light,     230).     %
% happens(toggle_light,     240). happens(toggle_light,     250).     %
% happens(toggle_light,     260). happens(toggle_light,     270).     %
% happens(toggle_light,     280). happens(toggle_light,     290).     %
% happens(toggle_light,     300). happens(toggle_light,     310).     % 7s    (31 events)
% happens(toggle_light,     320). happens(toggle_light,     330).     % 
% happens(toggle_light,     340). happens(toggle_light,     350).     % 13s   (35 events)
% happens(toggle_light,     360). happens(toggle_light,     370).     % 
% happens(toggle_light,     380). happens(toggle_light,     390).     % 
% happens(toggle_light,     400). happens(toggle_light,     410).     % 30s   (41 events)
% happens(toggle_light,     420). happens(toggle_light,     430).     % 
% happens(toggle_light,     440). happens(toggle_light,     450).     % 
% happens(toggle_light,     460). happens(toggle_light,     470).     % 1min  (47 events)
