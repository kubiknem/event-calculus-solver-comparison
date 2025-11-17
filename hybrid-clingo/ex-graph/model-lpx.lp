
node(a). %1
node(b). %2
node(c). %3
fluent(excited(X)) :- node(X).
fluent(reach(X,Y)) :- node(X), node(Y).
fluent(edge(X,Y)) :- node(X), node(Y).
fluent(light_on).
event(send_on(X,Y)) :- node(X), node(Y).


% happensAtStep(send_on(X,Y), S) :-
%     holdsAtStep(edge(X,Y), S),
%     step(S),
%     S > 0,
%     node(X), node(Y).

% happensAtStep(send_on(X,Y), S) :-
%     holdsAtStep(edge(X,Z), S),
%     holdsAtStep(reach(Z,Y), S),
%     node(X), node(Y), node(Z).

% :- happensAtStep(send_on(X,Y), S1), holdsAtStep(reach(X,Y), S2),
%     step(S1), step(S2), S2 < S1, node(X), node(Y).

initiatesAtStep(send_on(X,Y), reach(X,Y), S) :- node(X), node(Y), step(S).

not happensAtStep(send_on(X,Y), S) :-
    not holdsAtStep(edge(X,Y), S),
    initiatesAtStep(send_on(X,Y), reach(X,Y), S),
    step(S),
    S > 0,
    node(X), node(Y).

not happensAtStep(send_on(X,Y), S) :-
    not holdsAtStep(edge(X,Z), S),
    holdsAtStep(reach(Z,Y), S),
    step(S).
    node(X), node(Y), node(Z).

initiatesAtStep(turn_light_on,  light_on, S) :- step(S).

terminatesAtStep(turn_light_off, light_on, S) :- step(S).

% ----- narative ------
initiallyP(edge(a,b)).
initiallyP(edge(b,a)).
initiallyP(edge(c,c)).

happens(send_on(a,b), 10).
happens(turn_light_on,      20).
happens(turn_light_off,     30).

% s(CASP) model
% reach(X,Y) :- edge(X,Y).
% reach(X,Y) :- edge(X,Z), reach(Z,Y).
% edge(1,2).
% edge(2,1).
% edge(3,3).