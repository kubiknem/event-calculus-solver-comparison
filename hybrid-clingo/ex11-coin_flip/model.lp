% toss a coin that will non-deterministically land as heads or tails
% testing release from inertia for discrete fluents

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% event(toss).
% event(land).

fluent(up(heads)).
fluent(up(tails)).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

releasesAtStep(toss,  up(X), S) :- fluent(up(X)), step(S).

initiatesAtStep(land, up(X), S) :- holdsAtStep(up(X), S), step(S).
terminatesAtStep(land, up(X), S) :- not holdsAtStep(up(X), S), step(S), fluent(up(X)).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% the coin must always be exactly one of the sides up
1{holdsAtStep(up(X), S) : fluent(up(X))}1 :- step(S).

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyP(up(heads)).
initiallyN(F) :- not initiallyP(F), fluent(F).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(toss,      10).
happens(land,      20). % TODO could be triggered
happens(check,     30). % just to see the value after

% --> two models heads or tails
