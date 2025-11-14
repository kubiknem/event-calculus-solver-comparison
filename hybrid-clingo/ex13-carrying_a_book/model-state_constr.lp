% Carrying a book example -- using release axioms and state constrains
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 96, section 6.3.1
%
% Demonstrates indirect effects using release axioms and state constrains
%
% Modified for clingo-lpx --> location is a continuous location instead of a room (non-ground value)

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

agent(nathan).
object(book).
%! could also use (bellow) to treat agents as objects
% object(A) :- agent(A).

fluent_Func(location(A)) :- agent(A).
fluent_Func(location(O)) :- object(O).
fluent(holding(A, O)) :- agent(A), object(O).

% event(pickUp(A, O)) :- agent(A), object(O).
% event(letGoOf(A, O)) :- agent(A), object(O).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

% if an agent walks from Location1 to Location2, then they will no longer be in Location1
% and will be in Location2
&sum{eventValueAtStep(walk(A),S)} = valueAtStep(location(A),S+1) :-
    initiatedValueByAtStep(walk(A), location(A), S),
    step(S+1).
initiatesValueAtStep(walk(A), location(A), S) :-
    agent(A), step(S).

% if an agent is in the same room as an object and picks it up, then they will be holding it
initiatesAtStep(pickUp(A, O), holding(A, O), S) :-
    holdsAtStep(location(A), S), holdsAtStep(location(O), S),
    normal_atom(valueAtStep(location(A), S), eq, valueAtStep(location(O), S)),
    agent(A), object(O), step(S).
comparison(valueAtStep(location(A), S), valueAtStep(location(O), S)) :- happensAtStep(pickUp(A, O), S).

%% % if an agent is holding an object and lets go of it, then they will no longer be holding it
terminatesAtStep(letGoOf(A, O), holding(A, O), S) :-
    holdsAtStep(holding(A, O), S),
    agent(A), object(O), step(S).

%! indirect effect
% if an agent lets go of an object while in a room, then the object will be
% in that room and will no longer be released from CLoI (caused by initiates)
&sum{valueAtStep(location(A),S)} = valueAtStep(location(O),S+1) :-
    initiatedValueByAtStep(letGoOf(A, O), location(O), S),
    step(S+1).
initiatesValueAtStep(letGoOf(A, O), location(O), S) :-
   agent(A), object(O), step(S).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% % an object can only be in one room at a time (same for agents...)
% R1=R2 :- holdsAtStep(location(O,R1), S), holdsAtStep(location(O,R2), S),
%     object(A), room(R1), room(R2), step(S).
% R1=R2 :- holdsAtStep(location(A,R1), S), holdsAtStep(location(A,R2), S),
%     agent(A), room(R1), room(R2), step(S).

%! indirect effect
% when an agent is in a room and holding an object, then the object is in the same room
holdsAtStep(location(O), S) :-
    holdsAtStep(holding(A,O), S),
    holdsAtStep(location(A), S),
    agent(A), object(O), step(S).
&sum{valueAtStep(location(A),S)} = valueAtStep(location(O),S) :-
    holdsAtStep(holding(A,O), S),
    holdsAtStep(location(A), S),
    agent(A), object(O), step(S).


%-------------------------------------------------------------------------------
% triggered events
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% release from CLoI
%-------------------------------------------------------------------------------

%! indirect effect
% when an agent pickups an object, then the location of that object will
% be released from CLoI
releasesAtStep(pickUp(A,O), location(O), S) :-
    agent(A), object(O), step(S).

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyP_Func(location(nathan), 0).
initiallyP_Func(location(book), 0).
initiallyN(F) :- not initiallyP(F), not initiallyP_Func(F, _), fluent(F).  % % nathan is initially not holding the book


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(pickUp(nathan, book), 10).

% nathan walks to position 100 with the book
happens(walk(nathan), 20).
% TODO an attempt at making a functional event
&sum{100} = eventValueAtStep(walk(nathan), S) :- happens(walk(nathan), 20), step(S), normal_atom(timeAtStep(S), eq, 20).
comparison(timeAtStep(S), T) :- step(S), happens(walk(A), T).

happens(letGoOf(nathan, book), 30).

% nathan walks to position 200 without the book
happens(walk(nathan), 40).
% TODO an attempt at making a functional event
&sum{200} = eventValueAtStep(walk(nathan), S) :- happens(walk(nathan), 40), step(S), normal_atom(timeAtStep(S), eq, 40).
comparison(timeAtStep(S), T) :- step(S), happens(walk(A), T).

{checkStep(S) : step(S)} = 1.
&sum{ timeAtStep(S) } = 100 :- checkStep(S).

% --> conclude that the book is at position 100 after time 20 and stays there 

