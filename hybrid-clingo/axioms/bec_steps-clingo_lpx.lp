% PREDICATES / NOTATION:
%   happensAtStep(E, S): event S happens at state S                                                                              
%   holdsAtStep(F, S): fluent F holds (is true) at step S
%   -holdsAtStep(F, S): fluent F does not hold (is false) at step S
%   (F,S) = V: functional fluent F at step S has value V


% OVERVIEW OF HOW IT WORKS:
%   there is a fixed number of discrete steps (grounded)
%   these is an equal number of interpreted timepoints (non-ground)
%   timepoints are mapped to steps via event occurrences
%      event occurrences in the narrative are specified using happens(E,T)
%      each T in happens(E,T) gets mapped to a step S in a ordered way (step S has a lower time than step S+1)
%      when S is mapped to T then the interpreted timepoint of S will be equal to T (forces the value of the interpreted timepoint)
%
%   all event calculus predicates operate (almost) as normal on the discrete steps
%
%   things get a bit complicated for triggered events [% TODO this is the hardest part of the encoding / the potential limitation]
%      we can specify more steps than there are events in the narrative
%      this results in free-floating steps that have no mapping
%      a trigger rule then can imply that an event occurs at some state and imply its interpreted timepoint
%      the free-floating step should then get mapped to this triggered event occurrence
%      such a step will not have a mapping to a ground timepoint, but will have an interpreted timepoint
%
%   fluents are divided into discrete (grounded) and functional (interpreted / non-ground)
%   discrete fluents are straight forward
%      operate (almost?) the same as normal
%      have ground values at ground steps
%   functional fluents are more complicated [% TODO this will likely get overhauled]
%      the general idea is the same as with discrete (being set by events, having inertia, ...)
%      have interpreted values (non-ground) associated with them
%      instead of saying holdsAtStep(F, S) we say defined(valueAtStep(F, S))
%      valueAtStep(F, S) is the name of the symbol that will then be interpreted later
%      these symbols then need to be compared to each other 


%-------------------------------------------------------------------------------
% mapping time to steps
%-------------------------------------------------------------------------------

% step(S): S is a step, ranges from 0 to maxstep                                                                               
step(0..maxstep).                                                                                                              

% timeAtStep(S): the time of step S (and timeAtStep(0) = 0)                                                                                
&sum{ timeAtStep(0) } = 0.                                                                                                           
&sum{ timeAtStep(S) } > timeAtStep(S-1) :- S > 0, step(S).                                                                                       
&sum{ timeAtStep(S) } >= 0 :- step(S).

% there can be no neighboring time steps such that the later one has a smaller time
% TODO had to add this for some examples
:- normal_atom(timeAtStep(S), gt, timeAtStep(S+1)), step(S), S < maxstep.
comparison(timeAtStep(S), timeAtStep(S+1)) :- step(S), S < maxstep.


% map(T, S): Map time point T to state S                                                                                       
  map(0, 0).                                                                           
{ map(T, S) : step(S) } = 1 :- happens(_, T), T > 0.                                                                       
%  map(inf, maxstep+1).       

% TODO this might be useful as a domain
inputTime(T) :- happens(_, T).

% restrict free floating steps:
% each step must either be mapped to an input time or it must have a triggered event
:- not map(_, S), not happensAtStep(_, S), step(S). 
% :- not happensAtStep(_, S), step(S), S > 0. % TODO alternatively we could say that there must be an event at all steps


% if T is mapped to S, then S is at time T                                                                                     
&sum{ timeAtStep(S) } = T :- map(T, S), step(S).                                                                                              

% mapping "happens at time" to "happens at step"
happensAtStep(E, S) :-  happens(E, T), map(T, S).                            

% no events can happen at step 0
:- happensAtStep(_, 0).

%-------------------------------------------------------------------------------
% discrete fluents -- without a interpreted value (fully grounded)
%-------------------------------------------------------------------------------

%% DBEC4* - HoldsAt(f,t)
% fluent F holds (is true) at step zero
holdsAtStep(F, 0) :- initiallyP(F).

%% DBEC5* - not HoldsAt(f,t)
% fluent F does not hold (is false) at step zero
-holdsAtStep(F, 0) :- initiallyN(F).

%% shorthand predicates (and for negations)
initiatedAtStep(F, S) :- happensAtStep(E, S), initiatesAtStep(E, F, S).
terminatedAtStep(F, S) :- happensAtStep(E, S), terminatesAtStep(E, F, S).

%% DBEC6* - HoldsAt(f,t)
% event effects: events can initiate discrete fluents
holdsAtStep(F, S+1) :- initiatedAtStep(F, S), step(S).
% inertia: value of fluents persists unless changed
holdsAtStep(F, S+1) :- holdsAtStep(F, S), not terminatedAtStep(F, S), step(S).

%% DBEC7* - not HoldsAt(f,t)
% event effects: events can terminate discrete fluents
-holdsAtStep(F, S+1) :- terminatedAtStep(F, S), step(S).
% inertia: value of fluents persists unless changed
-holdsAtStep(F, S+1) :- -holdsAtStep(F, S), not initiatedAtStep(F, S), step(S).


%-------------------------------------------------------------------------------
% functional fluents -- with an interpreted value (have a grounding-free value)
%-------------------------------------------------------------------------------

% designated using fluentF(X).
% they holdAtStep in the same way as discrete fluents using their own axioms/predicates
% but also have a valueAtStep(F,S) associated with them which is then interpreted do a non-ground value

%% DBEC4* - HoldsAtF(f,t)
% fluent F holds (is true) at step zero
holdsAtStepF(F, valueAtStep(F, 0), 0) :- initiallyPF(F, V).
&sum{ valueAtStep(F,0) } = V :- initiallyPF(F, V).

%% DBEC5* - not HoldsAtF(f,t) % TODO ?
% ...

%% shorthand predicates (and for negations)
initiatedAtStepF(F, valueAtStep(F, S1), S) :- happensAtStep(E, S), initiatesAtStepF(E, F, valueAtStep(F, S1), S).
terminatedAtStepF(F, valueAtStep(F, S1), S) :- happensAtStep(E, S), terminatesAtStepF(E, F, valueAtStep(F, S1), S).

%% DBEC6* - HoldsAt(f,t)
% event effects: events can initiate functional fluents
holdsAtStepF(F, valueAtStep(F, S+1), S+1) :- initiatedAtStepF(F, valueAtStep(F, S+1), S), step(S).
% inertia: value of fluents persists unless changed
holdsAtStepF(F, valueAtStep(F, S+1), S+1) :- holdsAtStepF(F, valueAtStep(F, S), S), not terminatedAtStepF(F, valueAtStep(F, S), S), not initiatedAtStepF(F, valueAtStep(F, S+1), S), step(S).
&sum{ valueAtStep(F,S+1) } = valueAtStep(F,S) :- holdsAtStepF(F, valueAtStep(F, S), S), not terminatedAtStepF(F, valueAtStep(F, S), S), not initiatedAtStepF(F, valueAtStep(F, S+1), S), step(S).

% when a functional fluent is false, then its value is zero
% TODO this is a trick to avoid listing of all possible values
&sum{ valueAtStep(F,S) } = 0 :- not holdsAtStepF(F, valueAtStep(F, S), S), fluentF(F), step(S).
&sum{ valueAtStep(F,maxstep+1) } = 0 :- not holdsAtStepF(F, valueAtStep(F, maxstep+1), maxstep+1), fluentF(F).

%% DBEC7* - not HoldsAt(f,t) % TODO ?
% ...

%% shorthand predicates
initiatedByAtStepF(E, F, valueAtStep(F, S1), S) :- happensAtStep(E, S), initiatesAtStepF(E, F, valueAtStep(F, S1), S).
terminatedByAtStepF(E, F, valueAtStep(F, S1), S) :- happensAtStep(E, S), terminatesAtStepF(E, F, valueAtStep(F, S1), S).

% TODO I think this generates a comparison(A,B) for each interpreted value of fluents at adjacent steps
% TODO and the choice rule for normal_atom below then says that each comparison leads to exactly one interpreted result of the comparison
comparison(valueAtStep(F,S+1), valueAtStep(F,S)) :- fluentF(F), step(S).

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


%% DBEC1 - StoppedIn(t1,f,t2)
stoppedInSteps(S1, F, S2) :-
    S1 < S, S < S2,
    terminatedAtStep(F, S),
    step(S1), step(S2).


%% DBEC2 - StartedIn(t1,f,t2)
startedInSteps(S1, F, S2) :-
    S1 < S, S < S2,
    initiatedAtStep(F, S),
    step(S1), step(S2).


%% DBEC3 - HoldsAt(f,t)
holdsAtStepF(Fluent2, valueAtStep(Fluent2, S2), S2) :-
  trajectoryAtStep(_, _, Fluent2, valueAtStep(Fluent2, S2), S2).

%% shorthand predicate
trajectoryAtStep(Fluent1, S1, Fluent2, valueAtStep(Fluent2, S2), S2) :-
  S1 < S2,
  initiatedAtStep(Fluent1, S1),
  trajectory(Fluent1, S1, Fluent2, valueAtStep(Fluent2, S2), S2),
  not stoppedInSteps(S1, Fluent1, S2).


% TODO add release? -- currently terminating a functional fluent is the same as releasing it (i.e., it has no value after it is terminated)
%% new DBEC8
%% new DBEC9
%% new DBEC10
%% new DBEC11


%-------------------------------------------------------------------------------
% additional/helper predicates
%-------------------------------------------------------------------------------

% helper predicate to visualize fluent values between steps
holdsBetweenSteps(F, S, S+1) :- holdsAtStep(F, S+1), step(S).
-holdsBetweenSteps(F, S, S+1) :- -holdsAtStep(F, S+1), step(S).

holdsBetweenStepsF(F, valueAtStep(F, S+1), S, S+1) :- holdsAtStepF(F, valueAtStep(F, S+1), S+1), step(S).


%-------------------------------------------------------------------------------
% Show
%-------------------------------------------------------------------------------

% NOTE: using #show to translate steps to times using map/2

%any_map(S) :- not map(T, S), step(S), inputTime(T).

#show.

% show all events that come as facts in the narrative
#show  happens(E, T) : happens(E, T).
% triggered events do not have a mapping of step to time
#show  happens(E,timeAtStep(S)) : happensAtStep(E,S), not map(_, S).

% discrete fluents have values between steps
#show  holdsAt(F, (T1, "< T =<", T2)) :  holdsBetweenSteps(F, S, S+1), map(T1, S), map(T2, S+1).
#show -holdsAt(F, (T1, "< T =<", T2)) : -holdsBetweenSteps(F, S, S+1), map(T1, S), map(T2, S+1).
% any of the steps might be free floating (triggered events)
#show  holdsAt(F, (timeAtStep(S), "< T =<", T2)) :  holdsBetweenSteps(F, S, S+1), not map(_, S), map(T2, S+1), step(S+1).
#show  holdsAt(F, (timeAtStep(S), "< T =<", T2)) :  holdsBetweenSteps(F, S, S+1), not map(_, S), map(T2, S+1), step(S+1).
#show -holdsAt(F, (timeAtStep(S), "< T =<", T2)) : -holdsBetweenSteps(F, S, S+1), not map(_, S), map(T2, S+1), step(S+1).
#show  holdsAt(F, (T1, "< T =<", timeAtStep(S+1))) :  holdsBetweenSteps(F, S, S+1), map(T1, S), not map(_, S+1), step(S+1).
#show -holdsAt(F, (T1, "< T =<", timeAtStep(S+1))) : -holdsBetweenSteps(F, S, S+1), map(T1, S), not map(_, S+1), step(S+1).
#show  holdsAt(F, (timeAtStep(S), "< T =<", timeAtStep(S+1))) :  holdsBetweenSteps(F, S, S+1), not map(_, S), not map(_, S+1), step(S+1).
#show -holdsAt(F, (timeAtStep(S), "< T =<", timeAtStep(S+1))) : -holdsBetweenSteps(F, S, S+1), not map(_, S), not map(_, S+1), step(S+1).
% discrete fluents have a value into infinity after the last step
#show  holdsAt(F, ("T >", T1)) :  holdsBetweenSteps(F, maxstep, _), map(T1, maxstep).
#show -holdsAt(F, ("T >", T1)) : -holdsBetweenSteps(F, maxstep, S), map(T1, maxstep).
% the last step might be free floating (triggered events)
#show  holdsAt(F, ("T >", timeAtStep(maxstep))) :  holdsBetweenSteps(F, maxstep, _), not map(_, maxstep).
#show -holdsAt(F, ("T >", timeAtStep(maxstep))) : -holdsBetweenSteps(F, maxstep, _), not map(_, maxstep).


% TODO any way to replace 'valueAtStep(F,S)' with its interpreted value? So that it is visible in the answer directly
% functional fluents have values between steps
#show holdsAt((F, valueAtStep(F,S+1)), (T1, "< T =<", T2)) : holdsBetweenStepsF(F, valueAtStep(F, S+1), S, S+1), map(T1, S), map(T2, S+1).
% any of the steps might be free floating (triggered events)
#show holdsAt((F, valueAtStep(F,S+1)), (timeAtStep(S), "< T =<", T2)) : holdsBetweenStepsF(F, valueAtStep(F, S+1), S, S+1), not map(_, S), map(T2, S+1), step(S+1).
#show holdsAt((F, valueAtStep(F,S+1)), (T1, "< T =<", timeAtStep(S+1))) : holdsBetweenStepsF(F, valueAtStep(F, S+1), S, S+1), map(T1, S), not map(_, S+1), step(S+1).
#show holdsAt((F, valueAtStep(F,S+1)), (timeAtStep(S), "< T =<", timeAtStep(S+1))) : holdsBetweenStepsF(F, valueAtStep(F, S+1), S, S+1), not map(_, S), not map(_, S+1), step(S+1).
% functional fluents have a value into infinity after the last step
#show holdsAt((F, valueAtStep(F,S)), ("T >", T1)) : holdsBetweenStepsF(F, valueAtStep(F, S), maxstep, S), map(T1, maxstep).
% the last step might be free floating (triggered events)
#show holdsAt((F, valueAtStep(F,S)), ("T >", timeAtStep(maxstep))) : holdsBetweenStepsF(F, valueAtStep(F, S), maxstep, S), not map(_, maxstep).


% show all for debug
%% #show  happensAtStep(E,S) : happensAtStep(E,S).
%% #show  holdsAtStep(F,S) : holdsAtStep(F,S).
%% #show  -holdsAtStep(F,S) : -holdsAtStep(F,S).
%% #show  holdsAtStepF(F,V,S) : holdsAtStepF(F,V,S).
%% #show  holdsAtStepF(F,V,S) : holdsAtStepF(F,V,S).
%% 
%% #show  holdsBetweenSteps(F, S1, S2) : holdsBetweenSteps(F, S1, S2).
%% #show  -holdsBetweenSteps(F, S1, S2) : -holdsBetweenSteps(F, S1, S2).
%% #show  holdsBetweenStepsF(F, V, S1, S2) : holdsBetweenStepsF(F, V, S1, S2).
%% 
%% #show  map(T, S) : map(T, S).


%-------------------------------------------------------------------------------
% Defined
%-------------------------------------------------------------------------------

% define #const maxstep
#defined happens/2.
#defined initiallyP/1.
#defined initiallyN/1.
#defined initiallyF/2.
#defined fluentF/1.
#defined initiatesAtStep/3.
#defined terminatesAtStep/3.
