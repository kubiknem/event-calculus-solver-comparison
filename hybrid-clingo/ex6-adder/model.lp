% an adder machine (like a calculator with only the add operation)
% can be turned on and off
% while its on we can add(X) to the current result (functional fluent like result(X))
% there is no result while the machine is off
% the initial result is 0 when the machine is turned on
%
% --> example meant to test the encoding of functional fluents in clingo-lpx

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% TODO this is grounded (but only to as many values as there are input events...)
addDomain(X) :- happens(add(X), _).

% event(add(X)).
% event(turn_on).
% event(turn_off).

fluentF(result).
fluent(powered_on).

%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

% initiates(add(Add),  result(Res2), T) :- Add .>. 0, holdsAt(result(Res1), T), Res2 = Res1 + Add, time(T).
&sum{valueAtStep(result, S); Add} = valueAtStep(result, S+1) :- initiatedByAtStepF(add(Add), result, valueAtStep(result, S+1), S).
initiatesAtStepF(add(Add), result, valueAtStep(result, S+1), S) :- Add > 0, holdsAtStepF(result, valueAtStep(result, S), S), addDomain(Add).

% terminates(add(Add), result(OldRes), T) :- Add .>. 0, holdsAt(OldRes, T), time(T).
terminatesAtStepF(add(Add), result, valueAtStep(result, S), S) :- Add > 0, holdsAtStepF(result, valueAtStep(result, S), S), step(S), addDomain(Add).


% initiates(turn_on, powered_on, T) :- -holdsAt(powered_on, T), time(T).
initiatesAtStep(turn_on, powered_on, S) :- not holdsAtStep(powered_on, S), step(S).

% terminates(turn_off, powered_on, T) :- holdsAt(powered_on, T), time(T).
terminatesAtStep(turn_off, powered_on, S) :- holdsAtStep(powered_on, S).


% initiates(turn_on, result(0), T) :- time(T).
&sum{valueAtStep(result, S+1)} = 0 :- initiatedByAtStepF(turn_on, result, valueAtStep(result, S+1), S).
initiatesAtStepF(turn_on, result, valueAtStep(result, S+1), S) :- not holdsAtStep(powered_on, S), step(S).

% terminates(turn_off, result(_), T) :- holdsAt(powered_on, T), time(T).
terminatesAtStepF(turn_off, result, valueAtStep(result, S), S) :- holdsAtStep(powered_on, S), step(S).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(powered_on).
initiallyNF(result).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(turn_on,        5).
happens(add(5),         10).
happens(add(1000000),   20).
happens(turn_off,       25).

% conclude that result will be 1000005 after time 20
