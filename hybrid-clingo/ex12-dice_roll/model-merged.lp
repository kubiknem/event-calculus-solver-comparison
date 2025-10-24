% roll a dice with non-ground number of sides
% testing release from inertia for functional fluents

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% event(roll).
% event(land).

fluent_Func(sideUp).    % functional fluent

% the fluent can only have positive values
&sum{ valueAtStep(sideUp, S) } > 0 :- holdsAtStep(sideUp, S), not releasedAtStep(sideUp, S), step(S).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

releasesAtStep(roll, sideUp, S) :- step(S).

initiatesValueAtStep(land, sideUp, S) :- holdsAtStep(sideUp, S), step(S).
&sum{valueAtStep(sideUp,S)} = valueAtStep(sideUp,S+1) :-
    initiatedValueByAtStep(land, sideUp, S),
    step(S+1).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% the dice must always be exactly one of the sides up
1{holdsAtStep(sideUp, S)}1 :- step(S).

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
happens(check,     30).


% enforce a result that we are looking for
% (since its not really useful to list all non-ground values...)
&sum{ valueAtStep(sideUp, 3) } = X :- holdsAtStep(sideUp, 3), goal(X).

% TODO the goal is grounded but the point of the example is to show a non-ground non-deterministic value during the roll
{goal(1;2;3;4;5;6)} = 1.
