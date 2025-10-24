% roll a dice with non-ground number of sides
% testing release from inertia for functional fluents

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% event(roll).
% event(land).

fluent_Func(sideUp).    % functional fluent

% the fluent can only have positive values
&sum{ valueAtStep(sideUp, S) } > 0 :- holdsAtStep_Func(sideUp, valueAtStep(sideUp, S), S), not releasedAtStep_Func(sideUp, valueAtStep(sideUp, S), S), stepMax(S).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

releasesAtStep_Func(roll, sideUp, valueAtStep(sideUp, S+1), S) :- step(S).

initiatesAtStep_Func(land, sideUp, valueAtStep(sideUp, S+1), S) :- holdsAtStep_Func(sideUp, valueAtStep(sideUp, S), S), step(S).
&sum{valueAtStep(sideUp,S)} = valueAtStep(sideUp,S+1) :-
    initiatedByAtStep_Func(land, sideUp, valueAtStep(sideUp,S+1), S).
terminatesAtStep_Func(land, sideUp, valueAtStep(sideUp, S), S) :- step(S).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% the dice must always be exactly one of the sides up
1{holdsAtStep_Func(sideUp, valueAtStep(sideUp, S), S)}1 :- step(S).

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyP_Func(sideUp, 1).
%initiallyN(F) :- not initiallyP(F), fluent(F).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(roll,      10).
happens(land,      20). % TODO could be triggered


% --> result is 3 models 1, e, or 1+e


% enforce a result that we are looking for
% (since its not really useful to list all non-ground values...)
&sum{ valueAtStep(sideUp, 3) } = X :- holdsAtStep_Func(sideUp, valueAtStep(sideUp, 3), 3), goal(X).

goal(6).

% goalDomain(1).
% goalDomain(2).
% goalDomain(3).
% goalDomain(4).
% goalDomain(5).
% goalDomain(6).
% 1{goal(X) : goalDomain(X)}1.

