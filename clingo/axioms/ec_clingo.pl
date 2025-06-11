% copied from http://reasoning.eas.asu.edu/f2lp/Event%20Calculus/EC.lp
%! modified to be usable by clingo -- had to remove "#..." and add fluent(F), time(T), event(E),...
%! modification -- T2 in trajectory changed to timepoint instead of duration (T1->T2 instead of T1->T1+T2)

%%%% below was added to make these axioms compatible with the BEC/DBEC examples without a need to modify the examples
:- releasedAt(F,0), fluent(F). % nothing is initially released from CLoI
holdsAt(F, 0) :- initiallyP(F), fluent(F).
:- holdsAt(F, 0), initiallyN(F), fluent(F).
%%%% end

% EC.lp

%X% #domain fluent(F;F1;F2), event(E), timepoint(T;T1;T2).

time(0..maxtime).

% choice rules
{holdsAt(F,T)} :- fluent(F), time(T).
{releasedAt(F,T)} :- fluent(F), time(T).
%0 {persistsBetween(T1,F,T2)}1.

% EC 1
clipped(T1,F,T2) :-
   happens(E,T),
   T1<=T, T<T2,
   terminates(E,F,T),
   event(E), fluent(F), time(T), time(T1), time(T2).

% EC 2
declipped(T1,F,T2) :-
   happens(E,T),
   T1<=T, T<T2,
   initiates(E,F,T),
   event(E), fluent(F), time(T), time(T1), time(T2).

% EC 3 (as same as DEC 1)
stoppedIn(T1,F,T2) :-
   happens(E,T),
   T1<T, T<T2,
   terminates(E,F,T),
   event(E), fluent(F), time(T), time(T1), time(T2).
 
% EC 4 (as same as DEC 2)
startedIn(T1,F,T2) :-
   happens(E,T),
   T1<T, T<T2,
   initiates(E,F,T),
   event(E), fluent(F), time(T), time(T1), time(T2).

% EC 5 (as same as DEC 3)
holdsAt(F2,T2) :-
   happens(E,T1),
   initiates(E,F1,T1),
   T1<T2,
   trajectory(F1,T1,F2,T2),
   not stoppedIn(T1,F1,T2), 
   event(E), fluent(F1), fluent(F2), time(T1), time(T2).

% EC 6 (as same as DEC 4)
holdsAt(F2,T2) :-
   happens(E,T1),
   terminates(E,F1,T1),
   T1<T2,
   antiTrajectory(F1,T1,F2,T2),
   not startedIn(T1,F1,T2),
   event(E), fluent(F1), fluent(F2), time(T1), time(T2).

% EC 7
releasedAtBetween(T1,F,T2) :-
   releasedAt(F,T),
   T1<T, T<=T2,
   fluent(F), time(T), time(T1), time(T2).
persistsBetween(T1,F,T2) :-
   not releasedAtBetween(T1,F,T2),
   fluent(F), time(T1), time(T2).
%:- persistsBetween(T1,F,T2), releasedAt(F,T), T1<T, T<=T2. % not sure what this is (maybe an alternative way to write thiw rule?)

% EC 8
releasedBetween(T1,F,T2) :-
   happens(E,T),
   T1<=T, T<T2,
   releases(E,F,T),
   fluent(F), time(T), time(T1), time(T2).

% EC 9 (similar to DEC 5)
holdsAt(F,T2) :-
   holdsAt(F,T1),
   T1<T2,
   persistsBetween(T1,F,T2),
   not clipped(T1,F,T2),
   fluent(F), time(T1), time(T2).

% EC 10 (similar to DEC 6)
:- holdsAt(F,T2),
   not holdsAt(F,T1),
   T1<T2,
   persistsBetween(T1,F,T2),
   not declipped(T1,F,T2),
   fluent(F), time(T1), time(T2).

% EC 11 (similar to DEC 7)
releasedAt(F,T2) :-
   releasedAt(F,T1),
   T1<T2,
   not clipped(T1,F,T2),
   not declipped(T1,F,T2),
   fluent(F), time(T1), time(T2).

% EC 12 (similar to DEC 8)
:- releasedAt(F,T2),
   not releasedAt(F,T1),
   T1<T2,
   not releasedBetween(T1,F,T2),
   fluent(F), time(T1), time(T2).

% EC 13 
releasedIn(T1,F,T2) :- 
   happens(E,T),
   T1<T, T<T2,
   releases(E,F,T),
   event(E), fluent(F), time(T1), time(T2).

% EC 14 (similar to DEC 9)
holdsAt(F,T2) :-
   happens(E,T1),
   initiates(E,F,T1),
   T1<T2,
   not stoppedIn(T1,F,T2),
   not releasedIn(T1,F,T2),
   event(E), fluent(F), time(T1), time(T2).

% EC 15 (similar to DEC 10)
:- holdsAt(F,T2),
   happens(E,T1),
   terminates(E,F,T1),
   T1<T2,
   not startedIn(T1,F,T2),
   not releasedIn(T1,F,T2),
   event(E), fluent(F), time(T1), time(T2).

% EC 16 (similar to DEC 11)
releasedAt(F,T2) :-
   happens(E,T1),
   releases(E,F,T1),T1<T2,
   not stoppedIn(T1,F,T2),
   not startedIn(T1,F,T2),
   event(E), fluent(F), time(T1), time(T2).

% EC 17 (similar to DEC 12)
:- releasedAt(F,T2),
   happens(E,T1),
   initiates(E,F,T1),
   T1<T2,
   not releasedIn(T1,F,T2),
   releasedAt(F,T2),
   event(E), fluent(F), time(T1), time(T2).

:- releasedAt(F,T2),
   happens(E,T1),
   terminates(E,F,T1),
   T1<T2,
   not releasedIn(T1,F,T2),
   event(E), fluent(F), time(T1), time(T2).


%X% #hide.
%X% #show happens(E,T).
%X% #show happens3(E1,E2,T).
%X% #show holdsAt(F,T).