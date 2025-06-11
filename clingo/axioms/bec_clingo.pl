%% BASIC EVENT CALCULUS (BEC) THEORY

time(0..maxtime).
{holdsAt(F,T)} :- fluent(F), time(T).

%% BEC1 - StoppedIn(t1,f,t2)
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

%% BEC2 - StartedIn(t1,f,t2)
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

%% BEC3 - HoldsAt(f,t)
holdsAt(Fluent2, T2) :-
    T1 < T2,
    initiates(Event, Fluent1, T1),
    happens(Event, T1),
    trajectory(Fluent1, T1, Fluent2, T2),
    not stoppedIn(T1, Fluent1, T2),
    event(Event), fluent(Fluent1), fluent(Fluent2), time(T1), time(T2).
    
%% BEC4 - HoldsAt(f,t)
holdsAt(Fluent, T) :-
    initiallyP(Fluent),
    not stoppedIn(0, Fluent, T),
    fluent(Fluent), time(T).

%% BEC5 - not HoldsAt(f,t)
:- holdsAt(Fluent, T),
    initiallyN(Fluent),
    not startedIn(0, Fluent, T),
    fluent(Fluent), time(T).

%% BEC6 - HoldsAt(f,t)
holdsAt(Fluent, T) :-
    T1 < T,
    initiates(Event, Fluent, T1),
    happens(Event, T1),
    not stoppedIn(T1, Fluent, T),
    event(Event), fluent(Fluent), time(T), time(T1).

%% BEC7 - not HoldsAt(f,t)
:- holdsAt(Fluent, T),
    T1 < T,
    terminates(Event, Fluent, T1),
    happens(Event, T1),
    not startedIn(T1, Fluent, T),
    event(Event), fluent(Fluent), time(T), time(T1).

