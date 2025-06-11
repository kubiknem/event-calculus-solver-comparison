%% DISCRETIZED BASIC EVENT CALCULUS (BEC) THEORY
% - my own adaptation of BEC based on DEC (http://decreasoner.sourceforge.net/csr/ecasp/dec.lp)

time(0..maxtime).
{holdsAt(F,T)} :- fluent(F), time(T).
{releasedAt(F,T)} :- fluent(F), time(T).

%%%% below was added to make these axioms compatible with the BEC/DBEC examples without a need to modify the examples
:- releasedAt(F,0), fluent(F). % nothing is initially released from CLoI
%%%% end

%% DBEC1 - StoppedIn(t1,f,t2)
stoppedIn(T1, Fluent, T2) :-
    T1 < T, T < T2,
    terminates(Event, Fluent, T),
    happens(Event, T),
    event(Event), fluent(Fluent), time(T), time(T1), time(T2).

stoppedIn(T1, Fluent, T2) :-
    T1 < T, T < T2,
    releases(Event, Fluent, T),
    happens(Event, T),
    event(Event), fluent(Fluent), time(T), time(T1), time(T2).

%% DBEC2 - StartedIn(t1,f,t2)
startedIn(T1, Fluent, T2) :-
    T1 < T, T < T2,
    initiates(Event, Fluent, T),
    happens(Event, T),
    event(Event), fluent(Fluent), time(T), time(T1), time(T2).

startedIn(T1, Fluent, T2) :-
    T1 < T, T < T2,
    releases(Event, Fluent, T),
    happens(Event, T),
    event(Event), fluent(Fluent), time(T), time(T1), time(T2).

%% DBEC3 - HoldsAt(f,t)
holdsAt(Fluent2, T2) :-
    T1 < T2,
    initiates(Event, Fluent1, T1),
    happens(Event, T1),
    trajectory(Fluent1, T1, Fluent2, T2),
    not stoppedIn(T1, Fluent1, T2),
    event(Event), fluent(Fluent1), fluent(Fluent2), time(T1), time(T2).
    
%% DBEC4* - HoldsAt(f,t)
holdsAt(Fluent, 0) :-
    initiallyP(Fluent),
    fluent(Fluent).

%% DBEC5* - not HoldsAt(f,t)
:- holdsAt(Fluent, 0),
    initiallyN(Fluent),
    fluent(Fluent).

%% DBEC6* - HoldsAt(f,t)
holdsAt(Fluent, T + 1) :-
    initiates(Event, Fluent, T),
    happens(Event, T),
    event(Event), fluent(Fluent), time(T), T < maxtime.
holdsAt(Fluent, T + 1) :-
    holdsAt(Fluent, T),
    not releasedAt(Fluent, T + 1),
    not terminated1(Fluent, T),
    event(Event), fluent(Fluent), time(T), T < maxtime.

%% DBEC7* - not HoldsAt(f,t)
:- holdsAt(Fluent, T + 1),
    terminates(Event, Fluent, T),
    happens(Event, T),
    event(Event), fluent(Fluent), time(T), T < maxtime.
:- holdsAt(Fluent, T + 1),
    not holdsAt(Fluent, T),
    not releasedAt(Fluent, T + 1),
    not initiated1(Fluent, T),
    event(Event), fluent(Fluent), time(T), T < maxtime.

%% new DBEC8
releasedAt(Fluent, T + 1) :-
  releasedAt(Fluent, T),
  not initiated1(Fluent, T),
  not terminated1(Fluent, T),
  fluent(Fluent), time(T), T < maxtime.

%% new DBEC9
:- releasedAt(Fluent, T + 1),
  not releasedAt(Fluent, T),
  not released1(Fluent, T),
  fluent(Fluent), time(T), T < maxtime.

%% new DBEC10
releasedAt(Fluent, T +  1) :-
  happens(Event, T),
  releases(Event, Fluent, T),
  event(Event), fluent(Fluent), time(T), T < maxtime.

%% new DBEC11
:- releasedAt(Fluent, T + 1),
  happens(Event, T),
  initiates(Event, Fluent, T),
  event(Event), fluent(Fluent), time(T), T < maxtime.
:- releasedAt(Fluent, T + 1),
  happens(Event, T),
  terminates(Event, Fluent, T),
  event(Event), fluent(Fluent), time(T), T < maxtime.


%% helper predicates
initiated1(Fluent, T) :-
  happens(Event, T),
  initiates(Event, Fluent, T),
  event(Event), fluent(Fluent), time(T).
terminated1(Fluent, T) :-
  happens(Event, T),
  terminates(Event, Fluent, T),
  event(Event), fluent(Fluent), time(T).
released1(Fluent, T) :-
  happens(Event, T),
  releases(Event, Fluent, T),
  event(Event), fluent(Fluent), time(T).