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

event(add(X)) :- addDomain(X).
event(turn_on).
event(turn_off).

ffluent(result).
dfluent(powered_on).

%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

% initiates(add(Add),  result(Res2), T) :- Add .>. 0, holdsAt(result(Res1), T), Res2 = Res1 + Add, time(T).
initiates(add(Add), result, (Add, 1, 0, result), T) :-
    Add > 0,
    holdsAt(powered_on, T),
    % holdsAt(result, T),
    addDomain(Add), time(T).

% terminates(add(Add), result(OldRes), T) :- Add .>. 0, holdsAt(OldRes, T), time(T).
% TODO this is meant to terminate the old functional value (break its inertia), this is already done by initiates/4


% initiates(turn_on, powered_on, T) :- -holdsAt(powered_on, T), time(T).
initiates(turn_on, powered_on, T) :-
    not holdsAt(powered_on, T),
    time(T).

% terminates(turn_off, powered_on, T) :- holdsAt(powered_on, T), time(T).
terminates(turn_off, powered_on, T) :-
    holdsAt(powered_on, T).


% initiates(turn_on, result(0), T) :- time(T).
initiates(turn_on, result, (0, 0, 0, result), T) :-
    Add > 0,
    not holdsAt(powered_on, T),
    %not holdsAt(result, T),
    addDomain(Add), time(T).

% terminates(turn_off, result(_), T) :- holdsAt(powered_on, T), time(T).
% TODO in FDEC-fh ffluents can be terminated (terminate all values)
terminates(turn_off, result, T) :-
    holdsAt(powered_on, T),
    % holdsAt(result, T),
    time(T).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(powered_on).
initiallyN(result).     % TODO in FDEC-fh ffluents can be false (not holdsAt for all values)


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

in_happens(turn_on,        5).
in_happens(add(5),         10).
in_happens(add(1000000),   20).
in_happens(turn_off,       25).

% conclude that result will be 1000005 after time 20

% also show -holdsAt
negated_prints.