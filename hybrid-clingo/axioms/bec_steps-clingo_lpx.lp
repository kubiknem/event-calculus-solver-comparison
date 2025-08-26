% PREDICATES / NOTATION:
%   happensAtStep(E, S): event S happens at state S                                                                              
%   holdsAtStep(F, S): fluent F holds (is true) at step S
%   -holdsAtStep(F, S): fluent F does not hold (is false) at step S
%   (F,S) = V: functional fluent F at step S has value V


%-------------------------------------------------------------------------------
% mapping time to steps
%-------------------------------------------------------------------------------

% step(S): S is a step, ranges from 0 to maxstep                                                                               
step(0..maxstep).                                                                                                              

% timeAtStep(S): the time of step S (and timeAtStep(0) = 0)                                                                                
&sum{ timeAtStep(0) } = 0.                                                                                                           
&sum{ timeAtStep(S) } > timeAtStep(S-1) :- S > 0, step(S).                                                                                       
&sum{ timeAtStep(S) } >= 0 :- step(S).                                                                                       

% map(T, S): Map time point T to state S                                                                                       
  map(0, 0).                                                                           
{ map(T, S) : step(S) } = 1 :- happens(_, T), T > 0.                                                                           
%  map(inf, maxstep+1).                                                                           

% if T is mapped to S, then S is at time T                                                                                     
&sum{ timeAtStep(S) } = T :- map(T, S), step(S).                                                                                              

% mapping "happens at time" to "happens at step"
happensAtStep(E, S) :-  happens(E, T), map(T, S).                            


%-------------------------------------------------------------------------------
% discrete fluents -- without a interpreted value (fully grounded)
%-------------------------------------------------------------------------------

%% DBEC4* - HoldsAt(f,t)
% fluent F holds (is true) at step zero
holdsAtStep(F, 0) :- initiallyP(F).

%% DBEC5* - not HoldsAt(f,t)
% fluent F does not hold (is false) at step zero
-holdsAtStep(F, 0) :- initiallyN(F).

%% DBEC6* - HoldsAt(f,t)
% event effects: events can initiate discrete fluents
holdsAtStep(F, S+1) :- initiatesAtStep(E, F, S), happensAtStep(E, S), step(S).
% inertia: value of fluents persists unless changed
holdsAtStep(F, S+1) :- holdsAtStep(F, S), not terminated1(F, S), step(S).
terminated1(F, S) :- happensAtStep(E, S), terminatesAtStep(E, F, S).

%% DBEC7* - not HoldsAt(f,t)
% event effects: events can terminate discrete fluents
-holdsAtStep(F, S+1) :- terminatesAtStep(E, F, S), happensAtStep(E, S), step(S).
% inertia: value of fluents persists unless changed
-holdsAtStep(F, S+1) :- -holdsAtStep(F, S), not initiated1(F, S), step(S).
initiated1(F, S) :- happensAtStep(E, S), initiatesAtStep(E, F, S).


%-------------------------------------------------------------------------------
% functional fluents -- with an interpreted value (have a grounding-free value)
%-------------------------------------------------------------------------------

% functional fluent F has value V at step zero
&sum{ valueAtStep(Fluent,0) } = V :- initiallyF(Fluent, V).

% functional fluents
% for clingo-lpx, replace in
%   defined((F,S)) :- &sum{ (F,S) } = (F,S-1), fluentF(F), step(S).
% the theory atom
%   &sum{ (F,S) } = (F,S-1)
% by a normal atom
%   normal_atom((F,S), eq, (F,S-1))
%
% TODO still get confused about what this does
defined(valueAtStep(F,0)) :- fluentF(F).
defined(valueAtStep(F,S+1)) :- normal_atom(valueAtStep(F,S+1), eq, valueAtStep(F,S)), fluentF(F), step(S).
:- not defined(valueAtStep(F,S)), fluentF(F), step(S).
:- not defined(valueAtStep(F,maxstep+1)), fluentF(F).

comparison(valueAtStep(F,S+1), valueAtStep(F,S)) :- fluentF(F), step(S).

%
% Note: 
%   1. The last constraint requires that all fluents F are defined at all steps S
%   2. A fluent is defined if it persists, or if it is the effect of some event 
%      (this is derived by the domain-specific rules)
%   From 1 and 2, the fluents either persist, or are the effect of some event. 
%   This solves the frame problem in this setting.
%

% theory_atom(A,COMPARISON,B)
{ normal_atom(A, (lt;eq;gt), B) } = 1 :- comparison(A, B).
%
&sum{ A } < B :- normal_atom(A, lt, B).
&sum{ A } = B :- normal_atom(A, eq, B).
&sum{ A } > B :- normal_atom(A, gt, B).
%
normal_atom(A, leq, B) :- normal_atom(A, lt, B).
normal_atom(A, leq, B) :- normal_atom(A, eq, B).
normal_atom(A, geq, B) :- normal_atom(A, eq, B).
normal_atom(A, geq, B) :- normal_atom(A, gt, B).

% TODO add trajectories and release
%% DBEC1 - StoppedIn(t1,f,t2)
%% DBEC2 - StartedIn(t1,f,t2)
%% DBEC3 - HoldsAt(f,t)
%% new DBEC8
%% new DBEC9
%% new DBEC10
%% new DBEC11


%-------------------------------------------------------------------------------
% additional/helper predicates
%-------------------------------------------------------------------------------

% helper predicate to visualize fluent values between steps
holdsBetweenSteps(F, S, S+1) :- holdsAtStep(F, S+1).
-holdsBetweenSteps(F, S, S+1) :- -holdsAtStep(F, S+1).

definedBetweenSteps(F, S, S+1) :- defined(valueAtStep(F, S+1)).


%-------------------------------------------------------------------------------
% Show
%-------------------------------------------------------------------------------

% NOTE: using show to translate steps to times using map/2
#show.
%#show  happens(E, T) : happensAtStep(E, S), map(T, S).
#show  happens(E, T) : happens(E, T).
%#show  holdsAt(F,T) : holdsAtStep(F, S), map(T, S).
%#show  -holdsAt(F,T) : -holdsAtStep(F, S), map(T, S).
#show holdsAt(F, (T1, "< T =<", T2)) : holdsBetweenSteps(F, S, S+1), map(T1, S), map(T2, S+1).
#show -holdsAt(F, (T1, "< T =<", T2)) : -holdsBetweenSteps(F, S, S+1), map(T1, S), map(T2, S+1).
#show holdsAt(F, ("T >", T1)) : holdsBetweenSteps(F, maxstep, S), map(T1, maxstep).
#show -holdsAt(F, ("T >", T1)) : -holdsBetweenSteps(F, maxstep, S), map(T1, maxstep).

% to advise that this fluent has a value in the "assignment:" section of the solution
%#show  holdsAt(F, valueAtStep(F,S), T) : defined((F,S)), map(T, S).
% TODO any way to replace 'valueAtStep(F,S)' with its interpreted value? So that it is visible in the answer directly
#show holdsAt((F, valueAtStep(F,S)), (T1, "< T =<", T2)) : definedBetweenSteps(F, S-1, S), map(T1, S-1), map(T2, S).
#show holdsAt((F, valueAtStep(F,S)), ("T >", T1)) : definedBetweenSteps(F, maxstep, S), map(T1, maxstep).


% TODO triggered events at new timepoints do not have a mapping
#show  happensAtStep(F,S) : happensAtStep(F,S), not map(_, S).
#show  holdsAtStep(F,S) : holdsAtStep(F,S), not map(_, S).

%#show  happensAtStep(F,S) : happensAtStep(F,S).
%#show  holdsAtStep(F,S) : holdsAtStep(F,S).


%-------------------------------------------------------------------------------
% Defined
%-------------------------------------------------------------------------------

% TODO what does this do?
% define #const maxstep
#defined happens/2.
#defined initiallyP/1.
#defined initiallyN/1.
#defined initiallyF/2.
#defined fluentF/1.
#defined initiatesAtStep/3.
#defined terminatesAtStep/3.
