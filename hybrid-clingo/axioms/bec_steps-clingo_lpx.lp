% PREDICATES / NOTATION:
%   input narrative:
%     happens(E, T)
%     initiallyP(F)
%     initiallyN(F)
%     initiallyPF(F, V)
%     initiallyNF(F)
%
%   input domain:
%     fluent(F)
%     fluentF(F)
%
%     initiatesAtStep(E, F, S)
%     terminatesAtStep(E, F, S)
%     releasesAtStep(E, F, S)
%
%     initiatesAtStepF(E, F, V@S+1, S)
%     terminatesAtStepF(E, F, V@S, S)
%     releasesAtStepF(E, F, V@S+1, S)
%
%     trajectory(F1, S1, F2, V@S2, S2)
%
%   general predicates:
%     happensAtStep(E, S): event S happens at state S                                                                              
%     holdsAtStep(F, S): fluent F holds (is true) at step S
%     holdsAtStepF(F, V@S, S) = V: functional fluent F at step S has value V
%
%   utility predicates
%     happensInitiatesAtStep(F, S)
%     happensTerminatesAtStep(F, S)
%     happensReleasesAtStep(F, S)
%
%     happensInitiatesAtStepF(F, V@S+1, S)
%     happensTerminatesAtStepF(F, V@S, S)
%     happensReleasesAtStepF(F, V@S+1, S)
%
%     initiatedByAtStepF(E, F, V@S+1, S)
%     trajectoryAtStep(F1, S1, F2, V@S2, S2)
%
%   output predicates:
%     happens(E, T)
%     holdsAt(F, T)
%     holdsAtF(F, V, T)
%     holdsAtCF(F, (V1 -> V2), T)
%     releasedAt(F, T)
%     releasedAtF(F, T)

% OVERVIEW OF HOW IT WORKS:
%   `there is a fixed number of discrete steps (grounded)
%   `these is an equal number of interpreted timepoints (non-ground)
%   `timepoints are mapped to steps via event occurrences
%      event occurrences in the narrative are specified using happens(E,T)
%      each T in happens(E,T) gets mapped to a step S in a ordered way (step S has a lower time than step S+1)
%      when S is mapped to T then the interpreted timepoint of S will be equal to T (forces the value of the interpreted timepoint)
%
%   all event calculus predicates operate as normal on the discrete steps
%
%   things get a bit complicated for triggered events
%      we can specify more steps than there are events in the narrative
%      this results in free-floating steps that have no mapping
%      a trigger rule then can imply that an event occurs at some state and imply its interpreted timepoint
%      the free-floating then gets mapped to this triggered event occurrence
%      such a step will not have a mapping to a ground timepoint, but will have an interpreted timepoint
%      there is also a restriction that there must be an event occurrence at every timepoint
%         this ensures binding of triggered events to the free floating timepoints
%         and means that specifying more steps than needed will cause no models, while specifying less currently gives models where the triggered events do no happen
%         TODO this might need adjustment but the workflow of running with more and more steps while getting bigger and bigger models until we get no model seems to work well
%
%   fluents are divided into discrete (grounded) and functional (interpreted / non-ground)
%   discrete fluents are straight forward
%      operate the same as normal
%      have ground values at ground steps
%   functional fluents are more complicated
%      the general idea is the same as with discrete (being set by events, having inertia, ...)
%      have interpreted values (non-ground) associated with them
%      instead of saying holdsAtStep(F, S) we say holdsAtStep(F, valueAtStep(F, S), S)
%      instead of initiatedAtStep(F, S) we say initiatedAtStepF(F, valueAtStep(F, S+1), S), similar for terminates and releases
%      a initiatedAtStepF(F, valueAtStep(F, S+1), S) needs to also be paired with a "&sum{ ... } = valueAtStep(F, S+1) :- ..."
%      valueAtStep(F, S) is the name of the symbol that will then be interpreted later
%      these symbols can be compared using normal_atom(X, ..., Y), but their their comparison must also be defined using comparison(X,Y)
%
% TODO
%  - functional value zero now represents no value
%  - releasedAtStepF and terminatesAtStepF maybe dont need the value argument (only makes sense for initiatesAtStepF?)
%
%  - integrating assignments into the model in the output (currently using a post-processing script)
%

%-------------------------------------------------------------------------------
% mapping time to steps
%-------------------------------------------------------------------------------

% step(S): S is a step, ranges from 0 to maxstep                                                                               
step(0..maxstep).                                                                                                              
stepMax(0..maxstep+1).                                                                                                              

% timeAtStep(S): the time of step S (and timeAtStep(0) = 0)                                                                                
&sum{ timeAtStep(0) } = 0.                                                                                                           
&sum{ timeAtStep(S) } > timeAtStep(S-1) :- S > 0, step(S).                                                                                       
&sum{ timeAtStep(S) } >= 0 :- step(S).

% there can be no neighboring time steps such that the later one has a smaller time
% TODO had to add this for some examples -- not sure if this is still needed...
:- normal_atom(timeAtStep(S), gt, timeAtStep(S+1)), step(S), S < maxstep.
comparison(timeAtStep(S), timeAtStep(S+1)) :- step(S), S < maxstep.


% map(T, S): Map time point T to state S                                                                                       
  map(0, 0).                                                                           
{ map(T, S) : step(S) } = 1 :- happens(_, T), T > 0.                                                                       


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
:- holdsAtStep(F, 0), initiallyN(F).

%% shorthand predicates (and for negations)
happensInitiatesAtStep(F, S) :- happensAtStep(E, S), initiatesAtStep(E, F, S).
happensTerminatesAtStep(F, S) :- happensAtStep(E, S), terminatesAtStep(E, F, S).
happensReleasesAtStep(F, S) :- happensAtStep(E, S), releasesAtStep(E, F, S).

%% DBEC6* - HoldsAt(f,t)
% event effects: events can initiate discrete fluents
holdsAtStep(F, S+1) :- happensInitiatesAtStep(F, S), step(S).
% inertia: value of fluents persists unless changed
holdsAtStep(F, S+1) :- holdsAtStep(F, S), not happensTerminatesAtStep(F, S), not releasedAtStep(F, S+1), step(S).

%% DBEC7* - not HoldsAt(f,t)
% event effects: events can terminate discrete fluents
:- holdsAtStep(F, S+1), happensTerminatesAtStep(F, S), step(S).
% inertia: value of fluents persists unless changed
:- holdsAtStep(F, S+1), not holdsAtStep(F, S), not happensInitiatesAtStep(F, S), not releasedAtStep(F, S+1), step(S).


% TODO nothing is initially released from inertia
:- releasedAtStep(F,0), fluent(F).
% TODO holdsAtStep can be anything when released
0{holdsAtStep(F, S)}1 :- releasedAtStep(F, S), fluent(F).  


%% new DBEC8
releasedAtStep(Fluent, S+1) :-
  releasedAtStep(Fluent, S),
  not happensInitiatesAtStep(Fluent, S),
  not happensTerminatesAtStep(Fluent, S),
  fluent(Fluent), step(S).

%% new DBEC9
:- releasedAtStep(Fluent, S+1),
  not releasedAtStep(Fluent, S),
  not happensReleasesAtStep(Fluent, S),
  fluent(Fluent), step(S).

%% new DBEC10
releasedAtStep(Fluent, S+1) :-
  happensReleasesAtStep(Fluent, S),
  fluent(Fluent), step(S).

%% new DBEC11
:- releasedAtStep(Fluent, S+1),
  happensInitiatesAtStep(Fluent, S),
  fluent(Fluent), step(S).
:- releasedAtStep(Fluent, S+1),
  happensTerminatesAtStep(Fluent, S),
  fluent(Fluent), step(S).

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

%% DBEC5* - not HoldsAtF(f,t)
:- holdsAtStepF(F, _, 0), initiallyNF(F).

%% shorthand predicates (and for negations)
happensInitiatesAtStepF(F, valueAtStep(F, S1), S) :- happensAtStep(E, S), initiatesAtStepF(E, F, valueAtStep(F, S1), S).
happensTerminatesAtStepF(F, valueAtStep(F, S1), S) :- happensAtStep(E, S), terminatesAtStepF(E, F, valueAtStep(F, S1), S).
happensReleasesAtStepF(F, valueAtStep(F, S1), S) :- happensAtStep(E, S), releasesAtStepF(E, F, valueAtStep(F, S1), S).

%% DBEC6* - HoldsAt(f,t)
% event effects: events can initiate functional fluents
holdsAtStepF(F, valueAtStep(F, S+1), S+1) :- happensInitiatesAtStepF(F, valueAtStep(F, S+1), S), step(S).
% inertia: value of fluents persists unless changed
holdsAtStepF(F, valueAtStep(F, S+1), S+1) :- holdsAtStepF(F, valueAtStep(F, S), S), not happensTerminatesAtStepF(F, valueAtStep(F, S), S), not releasedAtStepF(F, valueAtStep(F, S+1), S+1), step(S).
&sum{ valueAtStep(F,S+1) } = valueAtStep(F,S) :- holdsAtStepF(F, valueAtStep(F, S), S), not happensTerminatesAtStepF(F, valueAtStep(F, S), S), not releasedAtStepF(F, valueAtStep(F, S+1), S+1), step(S).

%% DBEC7* - not HoldsAt(f,t)
% event effects: events can terminate functional fluents
% TODO this is rule would be useless -- old valueAtStep does not need to be terminated since it will be replaced by the new one automatically, and happensTerminates will break positive inertia 
% :- holdsAtStepF(F, valueAtStep(F, S), S+1), happensTerminatesAtStepF(F, valueAtStep(F, S), S), step(S).
% inertia: value of fluents persists unless changed
:- holdsAtStepF(F, _, S+1), not holdsAtStepF(F, _, S), not happensInitiatesAtStepF(F, valueAtStep(F, S+1), S), not releasedAtStepF(F, valueAtStep(F, S+1), S+1), step(S).

% when a functional fluent is false, then its value is zero
% TODO this is a trick to avoid listing of all possible values
&sum{ valueAtStep(F,S) } = 0 :- not holdsAtStepF(F, valueAtStep(F, S), S), fluentF(F), stepMax(S).

%% shorthand predicates
initiatedByAtStepF(E, F, valueAtStep(F, S1), S) :- happensAtStep(E, S), initiatesAtStepF(E, F, valueAtStep(F, S1), S).

% TODO I think this generates a comparison(A,B) for each interpreted value of fluents at adjacent steps
% TODO and the choice rule for normal_atom below then says that each comparison leads to exactly one interpreted result of the comparison
comparison(valueAtStep(F,S+1), valueAtStep(F,S)) :- fluentF(F), step(S), S < maxstep.

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
    happensTerminatesAtStep(F, S),
    step(S1), stepMax(S2).
stoppedInSteps(S1, F, S2) :-
    S1 < S, S < S2,
    happensReleasesAtStep(F, S),
    step(S1), stepMax(S2).


%% DBEC2 - StartedIn(t1,f,t2)
startedInSteps(S1, F, S2) :-
    S1 < S, S < S2,
    happensInitiatesAtStep(F, S),
    step(S1), stepMax(S2).
startedInSteps(S1, F, S2) :-
    S1 < S, S < S2,
    happensReleasesAtStep(F, S),
    step(S1), stepMax(S2).


%% DBEC3 - HoldsAt(f,t)
holdsAtStepF(Fluent2, valueAtStep(Fluent2, S2), S2) :-
  trajectoryAtStep(_, _, Fluent2, valueAtStep(Fluent2, S2), S2).

%% shorthand predicate
trajectoryAtStep(Fluent1, S1, Fluent2, valueAtStep(Fluent2, S2), S2) :-
  S1 < S2,
  happensInitiatesAtStep(Fluent1, S1),
  trajectory(Fluent1, S1, Fluent2, valueAtStep(Fluent2, S2), S2),
  not stoppedInSteps(S1, Fluent1, S2).


% TODO nothing is initially released from inertia
:- releasedAtStepF(F, valueAtStep(F, 0), 0), fluentF(F).
% TODO holdsAtStep can be anything when released
0{holdsAtStepF(F, valueAtStep(F, S), S)}1 :- releasedAtStepF(F, valueAtStep(F, S), S), fluentF(F).  


%% new DBEC8
releasedAtStepF(Fluent, valueAtStep(Fluent, S+1), S+1) :-
  releasedAtStepF(Fluent, valueAtStep(Fluent, S), S),
  not happensInitiatesAtStepF(Fluent, valueAtStep(Fluent, S+1), S),
  not happensTerminatesAtStepF(Fluent, valueAtStep(Fluent, S), S),
  fluentF(Fluent), step(S).

%% new DBEC9
:- releasedAtStepF(Fluent, valueAtStep(Fluent, S+1), S+1),
  not releasedAtStepF(Fluent, valueAtStep(Fluent, S), S),
  not happensReleasesAtStepF(Fluent, valueAtStep(Fluent, S+1), S),
  fluentF(Fluent), step(S).

%% new DBEC10
releasedAtStepF(Fluent, valueAtStep(Fluent, S+1), S+1) :-
  happensReleasesAtStepF(Fluent, valueAtStep(Fluent, S+1), S),
  fluentF(Fluent), step(S).

%% new DBEC11
:- releasedAtStepF(Fluent, valueAtStep(Fluent, S+1), S+1),
  happensInitiatesAtStepF(Fluent, valueAtStep(Fluent, S+1), S),
  fluentF(Fluent), step(S).
:- releasedAtStepF(Fluent, valueAtStep(Fluent, S+1), S+1), 
  happensTerminatesAtStepF(Fluent, valueAtStep(Fluent, S), S),
  fluentF(Fluent), step(S).


%-------------------------------------------------------------------------------
% additional/helper predicates
%-------------------------------------------------------------------------------

% helper predicate to visualize fluent values between steps
holdsBetweenSteps(F, S, S+1) :- holdsAtStep(F, S+1), step(S).
holdsBetweenStepsF(F, valueAtStep(F, S+1), S, S+1) :- holdsAtStepF(F, valueAtStep(F, S+1), S+1), not trajectoryAtStep(_, _, F, valueAtStep(F, S+1), S+1), step(S).

releasedBetweenSteps(F, S, S+1) :- releasedAtStep(F, S+1), step(S).
releasedBetweenStepsF(F, valueAtStep(F, S+1), S, S+1) :- releasedAtStepF(F, valueAtStep(F, S+1), S+1), step(S).

trajectoryBetweenSteps(F1, F2, valueAtStep(F2, S), valueAtStep(F2, S+1), S, S+1) :- trajectoryAtStep(F1, _, F2, valueAtStep(F2, S+1), S+1), step(S).

%-------------------------------------------------------------------------------
% Show
%-------------------------------------------------------------------------------

% NOTE: using #show to translate steps to times using map/2

#show.

% show all events that come as facts in the narrative
#show  happens(E, T) : happens(E, T).
% triggered events do not have a mapping of step to time
#show  happens(E,timeAtStep(S)) : happensAtStep(E,S), not map(_, S).

% discrete fluents have values between steps
#show  holdsAt(F, (T1, "< T =<", T2)) :  holdsBetweenSteps(F, S, S+1), map(T1, S), map(T2, S+1).
% any of the steps might be free floating (triggered events)
#show  holdsAt(F, (timeAtStep(S), "< T =<", T2)) :  holdsBetweenSteps(F, S, S+1), not map(_, S), map(T2, S+1), step(S+1).
#show  holdsAt(F, (timeAtStep(S), "< T =<", T2)) :  holdsBetweenSteps(F, S, S+1), not map(_, S), map(T2, S+1), step(S+1).
#show  holdsAt(F, (T1, "< T =<", timeAtStep(S+1))) :  holdsBetweenSteps(F, S, S+1), map(T1, S), not map(_, S+1), step(S+1).
#show  holdsAt(F, (timeAtStep(S), "< T =<", timeAtStep(S+1))) :  holdsBetweenSteps(F, S, S+1), not map(_, S), not map(_, S+1), step(S+1).
% discrete fluents have a value into infinity after the last step
#show  holdsAt(F, ("T >", T1)) :  holdsBetweenSteps(F, maxstep, _), map(T1, maxstep).
% the last step might be free floating (triggered events)
#show  holdsAt(F, ("T >", timeAtStep(maxstep))) :  holdsBetweenSteps(F, maxstep, _), not map(_, maxstep).

% TODO any way to replace 'valueAtStep(F,S)' with its interpreted value? So that it is visible in the answer directly
% functional fluents have values between steps
#show holdsAtF(F, valueAtStep(F,S+1), (T1, "< T =<", T2)) : holdsBetweenStepsF(F, valueAtStep(F, S+1), S, S+1), map(T1, S), map(T2, S+1).
% any of the steps might be free floating (triggered events)
#show holdsAtF(F, valueAtStep(F,S+1), (timeAtStep(S), "< T =<", T2)) : holdsBetweenStepsF(F, valueAtStep(F, S+1), S, S+1), not map(_, S), map(T2, S+1), step(S+1).
#show holdsAtF(F, valueAtStep(F,S+1), (T1, "< T =<", timeAtStep(S+1))) : holdsBetweenStepsF(F, valueAtStep(F, S+1), S, S+1), map(T1, S), not map(_, S+1), step(S+1).
#show holdsAtF(F, valueAtStep(F,S+1), (timeAtStep(S), "< T =<", timeAtStep(S+1))) : holdsBetweenStepsF(F, valueAtStep(F, S+1), S, S+1), not map(_, S), not map(_, S+1), step(S+1).
% functional fluents have a value into infinity after the last step
#show holdsAtF(F, valueAtStep(F,S), ("T >", T1)) : holdsBetweenStepsF(F, valueAtStep(F, S), maxstep, S), map(T1, maxstep).
% the last step might be free floating (triggered events)
#show holdsAtF(F, valueAtStep(F,S), ("T >", timeAtStep(maxstep))) : holdsBetweenStepsF(F, valueAtStep(F, S), maxstep, S), not map(_, maxstep).


% functional fluents have values between steps
#show holdsAtCF(F, (valueAtStep(F, S), "->", valueAtStep(F, S+1)), (T1, "< T =<", T2)) : trajectoryBetweenSteps(_, F, valueAtStep(F, S), valueAtStep(F, S+1), S, S+1), map(T1, S), map(T2, S+1).
% any of the steps might be free floating (triggered events)
#show holdsAtCF(F, (valueAtStep(F, S), "->", valueAtStep(F, S+1)), (timeAtStep(S), "< T =<", T2)) : trajectoryBetweenSteps(_, F, valueAtStep(F, S), valueAtStep(F, S+1), S, S+1), not map(_, S), map(T2, S+1), step(S+1).
#show holdsAtCF(F, (valueAtStep(F, S), "->", valueAtStep(F, S+1)), (T1, "< T =<", timeAtStep(S+1))) : trajectoryBetweenSteps(_, F, valueAtStep(F, S), valueAtStep(F, S+1), S, S+1), map(T1, S), not map(_, S+1), step(S+1).
#show holdsAtCF(F, (valueAtStep(F, S), "->", valueAtStep(F, S+1)), (timeAtStep(S), "< T =<", timeAtStep(S+1))) : trajectoryBetweenSteps(_, F, valueAtStep(F, S), valueAtStep(F, S+1), S, S+1), not map(_, S), not map(_, S+1), step(S+1).
% functional fluents have a value into infinity after the last step
#show holdsAtCF(F, (valueAtStep(F, S), "-> X"), ("T >", T1)) : trajectoryBetweenSteps(_, F, valueAtStep(F, maxstep), valueAtStep(F, S), maxstep, S), map(T1, maxstep).
% the last step might be free floating (triggered events)
#show holdsAtCF(F,(valueAtStep(F, S), "-> X"), ("T >", timeAtStep(maxstep))) : trajectoryBetweenSteps(_, F, valueAtStep(F, maxstep), valueAtStep(F, S), maxstep, S), not map(_, maxstep).

% discrete fluents can be released between steps
#show  releasedAt(F, (T1, "< T =<", T2)) :  releasedBetweenSteps(F, S, S+1), map(T1, S), map(T2, S+1).
% any of the steps might be free floating (triggered events)
#show  releasedAt(F, (timeAtStep(S), "< T =<", T2)) :  releasedBetweenSteps(F, S, S+1), not map(_, S), map(T2, S+1), step(S+1).
#show  releasedAt(F, (timeAtStep(S), "< T =<", T2)) :  releasedBetweenSteps(F, S, S+1), not map(_, S), map(T2, S+1), step(S+1).
#show  releasedAt(F, (T1, "< T =<", timeAtStep(S+1))) :  releasedBetweenSteps(F, S, S+1), map(T1, S), not map(_, S+1), step(S+1).
#show  releasedAt(F, (timeAtStep(S), "< T =<", timeAtStep(S+1))) :  releasedBetweenSteps(F, S, S+1), not map(_, S), not map(_, S+1), step(S+1).
% discrete fluents have a value into infinity after the last step
#show  releasedAt(F, ("T >", T1)) :  releasedBetweenSteps(F, maxstep, _), map(T1, maxstep).
% the last step might be free floating (triggered events)
#show  releasedAt(F, ("T >", timeAtStep(maxstep))) :  releasedBetweenSteps(F, maxstep, _), not map(_, maxstep).

% functional fluents can be released between steps
#show releasedAtF(F, (T1, "< T =<", T2)) : releasedBetweenStepsF(F, valueAtStep(F, S+1), S, S+1), map(T1, S), map(T2, S+1).
% any of the steps might be free floating (triggered events)
#show releasedAtF(F, (timeAtStep(S), "< T =<", T2)) : releasedBetweenStepsF(F, valueAtStep(F, S+1), S, S+1), not map(_, S), map(T2, S+1), step(S+1).
#show releasedAtF(F, (T1, "< T =<", timeAtStep(S+1))) : releasedBetweenStepsF(F, valueAtStep(F, S+1), S, S+1), map(T1, S), not map(_, S+1), step(S+1).
#show releasedAtF(F, (timeAtStep(S), "< T =<", timeAtStep(S+1))) : releasedBetweenStepsF(F, valueAtStep(F, S+1), S, S+1), not map(_, S), not map(_, S+1), step(S+1).
% functional fluents have a value into infinity after the last step
#show releasedAtF(F, ("T >", T1)) : releasedBetweenStepsF(F, valueAtStep(F, S), maxstep, S), map(T1, maxstep).
% the last step might be free floating (triggered events)
#show releasedAtF(F, ("T >", timeAtStep(maxstep))) : releasedBetweenStepsF(F, valueAtStep(F, S), maxstep, S), not map(_, maxstep).


%%% % show all for debug
%%% #show  happensAtStep(E,S) : happensAtStep(E,S).
%%% #show  holdsAtStep(F,S) : holdsAtStep(F,S).
%%% #show  releasedAtStep(F,S) : releasedAtStep(F,S).
%%% #show  holdsAtStepF(F,V,S) : holdsAtStepF(F,V,S).
%%% #show  releasedAtStepF(F,V,S) : releasedAtStepF(F,V,S).
%%% 
%%% #show  holdsBetweenSteps(F, S1, S2) : holdsBetweenSteps(F, S1, S2).
%%% #show  holdsBetweenStepsF(F, V, S1, S2) : holdsBetweenStepsF(F, V, S1, S2).
%%% 
%%% #show  map(T, S) : map(T, S).
%%% 
%%% #show trajectoryAtStep(Fluent1, S1, Fluent2, valueAtStep(Fluent2, S2), S2) : trajectoryAtStep(Fluent1, S1, Fluent2, valueAtStep(Fluent2, S2), S2).
%%% #show trajectoryBetweenSteps(F1, F2, valueAtStep(F2, S), valueAtStep(F2, S+1), S, S+1) : trajectoryBetweenSteps(F1, F2, valueAtStep(F2, S), valueAtStep(F2, S+1), S, S+1).


%-------------------------------------------------------------------------------
% Defined
%-------------------------------------------------------------------------------

% define #const maxstep
#defined happens/2.

#defined initiallyP/1.
#defined initiallyN/1.
#defined initiallyPF/2.
#defined initiallyNF/1.

#defined fluent/1.
#defined fluentF/1.

#defined initiatesAtStep/3.
#defined terminatesAtStep/3.
#defined releasesAtStep/3.
#defined initiatesAtStepF/4.
#defined terminatesAtStepF/4.
#defined releasesAtStepF/4.

#defined trajectory/5.