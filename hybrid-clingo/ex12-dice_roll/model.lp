% roll a dice with non-ground number of sides
% testing release from inertia for functional fluents

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% event(roll).
% event(land).

fluentF(sideUp).    % functional fluent

% the fluent can only have positive values
&sum{ valueAtStep(sideUp, S) } > 0 :- holdsAtStepF(sideUp, valueAtStep(sideUp, S), S), -releasedAtStepF(sideUp, valueAtStep(sideUp, S), S), stepMax(S).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

releasesAtStepF(roll, sideUp, valueAtStep(sideUp, S+1), S) :- step(S).

initiatesAtStepF(land, sideUp, valueAtStep(sideUp, S+1), S) :- holdsAtStepF(sideUp, valueAtStep(sideUp, S), S), step(S).
terminatesAtStepF(land, sideUp, valueAtStep(sideUp, S), S) :- step(S).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% the dice must always be exactly one of the sides up
1{holdsAtStepF(sideUp, valueAtStep(sideUp, S), S)}1 :- step(S).

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyPF(sideUp, 1).
%initiallyN(F) :- not initiallyP(F), fluent(F).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(roll,      10).
happens(land,      20). % TODO could be triggered


% --> result is 'e'
% TODO I assume this means some positive value 


% enforce a result that we are looking for
% (since its not possible to list all non-ground values...)
%&sum{ valueAtStep(sideUp, 3) } = X :- holdsAtStepF(sideUp, valueAtStep(sideUp, 3), 3), goal(X).
%
%goal(6).

% goalDomain(1).
% goalDomain(2).
% goalDomain(3).
% goalDomain(4).
% goalDomain(5).
% goalDomain(6).
% 1{goal(X) : goalDomain(X)}1.

