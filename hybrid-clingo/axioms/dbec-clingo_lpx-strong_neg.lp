% very similar to dbec-clingo_lpx-choice.lp
% the difference is that we use strong negation instead of negation as failure for holdsAtStep and releasedAtStep


%-------------------------------------------------------------------------------
% constants, declarations, initial stuff...
%-------------------------------------------------------------------------------

% maxstep -- number of distinct timepoints at which events occur

% holdsAtStep can be anything when released
0{holdsAtStep(F, S)}1 :- releasedAtStep(F, S), fluent(F), step(S).  

% TODO this would usually be part of the domain encoding
% nothing is initially released from inertia
-releasedAtStep(F,0) :- fluent(F).

% TODO maybe should also add this?
% :- holdsAtStep(F, S), -holdsAtStep(F, S), fluent(F), step(S).
% :- releasedAtStep(F, S), -releasedAtStep(F, S), fluent(F), step(S).


%-------------------------------------------------------------------------------
% mapping time to steps
%-------------------------------------------------------------------------------

% step(S): S is a step, ranges from 0 to maxstep
step(0..maxstep).

% timeAtStep(S): the time of step S
&sum{ timeAtStep(0) } = 0.                                    % step 0 is at time 0
&sum{ timeAtStep(S) } > timeAtStep(S-1) :- S > 0, step(S).    % consecutive steps must have greater time                                             
&sum{ timeAtStep(S) } >= 0 :- step(S).                        % there can be no negative time

% map(T, S): Map time point T to state S                                                                                       
  map(0, 0).                                                  % step 0 maps to time 0
{ map(T, S) : step(S) } = 1 :- happens(_, T), T > 0.          % steps map to occurrence times of input events (facts from the narrative)

% if T is mapped to S, then S is at time T                                                                                     
&sum{ timeAtStep(S) } = T :- map(T, S), step(S).                                                                                              

% mapping "happens at time" to "happens at step"
happensAtStep(E, S) :-  happens(E, T), map(T, S).                            

% restrict free floating steps:
% all steps must have an event or be a check step
:- not happensAtStep(_, S), not checkStep(S), step(S), S > 0. 
  % all steps must have an event
  %:- not happensAtStep(_, S), step(S), S > 0. 
  % TODO the "not map" was causing problems in some examples... [in ex7 with 5 steps and no off event: would see a duplicate model which had both normal_atom(valueAtStep(brightness,1),geq,0) and normal_atom(valueAtStep(brightness,1),gt,0)]
  % each step must either be mapped to an input time or it must have a triggered event
  %:- not map(_, S), not happensAtStep(_, S), step(S). 

% TODO maybe could be allowed
% no event can happen at the first step (at time zero)
:- happensAtStep(E, 0).

% there can be no neighboring time steps such that the later one has a smaller time
% TODO had to add this for some examples -- not sure if this is still needed...
:- normal_atom(timeAtStep(S), gt, timeAtStep(S+1)), step(S), S < maxstep.
comparison(timeAtStep(S), timeAtStep(S+1)) :- step(S), S < maxstep.
:- map(T1, S1), map(T2, S2), S1 < S2, T1 > T2. 


%-------------------------------------------------------------------------------
% Discrete Basic Event Calculus Axioms
%-------------------------------------------------------------------------------
% axioms are almost one to one, except that
%   - they use steps instead of time
%   - there are two new axioms for functional values of fluents (DBEC12 and DBEC13 in the next section)

%% utility predicates for negations
happensInitiatesAtStep(F, S) :- happensAtStep(E, S), initiatesAtStep(E, F, S).
happensTerminatesAtStep(F, S) :- happensAtStep(E, S), terminatesAtStep(E, F, S).
happensReleasesAtStep(F, S) :- happensAtStep(E, S), releasesAtStep(E, F, S).

%% DBEC1 - StoppedIn(t1,f,t2)
stoppedInSteps(S1, F, S2) :-
    S1 < S, S < S2,
    terminatesAtStep(E, F, S),
    happensAtStep(E, S),
    step(S1), step(S2).
stoppedInSteps(S1, F, S2) :-
    S1 < S, S < S2,
    releasesAtStep(E, F, S),
    happensAtStep(E, S),
    step(S1), step(S2).

% TODO was not needed so far
%% DBEC2 - StartedIn(t1,f,t2)
%startedInSteps(S1, F, S2) :-
%    S1 < S, S < S2,
%    initiatesAtStep(E, F, S),
%    happensAtStep(E, S),
%    step(S1), step(S2).
%startedInSteps(S1, F, S2) :-
%    S1 < S, S < S2,
%    releasesAtStep(E, F, S),
%    happensAtStep(E, S),
%    step(S1), step(S2).

%% DBEC3 - HoldsAt(f,t) trajectory
holdsAtStep(F2, S2) :-
  S1 < S2,
  initiatesAtStep(E, F1, S),
  happensAtStep(E, S),
  trajectory(F1, S1, F2, S2),
  not stoppedInSteps(S1, F1, S2),
  step(S2).

%% DBEC4* - HoldsAt(f,t)
% fluent F holds (is true) at step zero
holdsAtStep(F, 0) :- initiallyP(F).

%% DBEC5* - not HoldsAt(f,t)
% fluent F does not hold (is false) at step zero
-holdsAtStep(F, 0) :- initiallyN(F).

%% DBEC6* - HoldsAt(f,t)
% event effects: events can initiate discrete fluents
holdsAtStep(F, S+1) :-
  happensAtStep(E, S),
  initiatesAtStep(E, F, S),
  step(S+1).
% inertia: value of fluents persists unless changed
holdsAtStep(F, S+1) :-
  holdsAtStep(F, S),
  not happensTerminatesAtStep(F, S),
  -releasedAtStep(F, S+1),
  step(S+1).

%% DBEC7* - not HoldsAt(f,t)
% event effects: events can terminate discrete fluents
-holdsAtStep(F, S+1) :-
  terminatesAtStep(E, F, S),
  happensAtStep(E, S),
  step(S+1).
% inertia: value of fluents persists unless changed
-holdsAtStep(F, S+1) :- 
  -holdsAtStep(F, S),
  -releasedAtStep(F, S+1),
  not happensInitiatesAtStep(F, S),
  step(S), step(S+1).

%% DBEC8
% inertia of release
releasedAtStep(F, S+1) :-
  releasedAtStep(F, S),
  not happensInitiatesAtStep(F, S),
  not happensTerminatesAtStep(F, S),
  step(S+1).

%% DBEC9
% negative inertia of release
-releasedAtStep(F, S+1) :-
  -releasedAtStep(F, S),
  not happensReleasesAtStep(F, S),
  step(S), step(S+1).

%% DBEC10
releasedAtStep(F, S+1) :-
  happensAtStep(E, S),
  releasesAtStep(E, F, S),
  step(S+1).

%% DBEC11
-releasedAtStep(F, S+1) :- 
  happensAtStep(E, S),
  initiatesAtStep(E, F, S),
  step(S+1).
-releasedAtStep(F, S+1) :-
  terminatesAtStep(E, F, S),
  happensAtStep(E, S),
  step(S+1).


%-------------------------------------------------------------------------------
% axioms for functional values of fluents
%-------------------------------------------------------------------------------

% - designated using fluent_Func(X).
% - a functional fluent is subject to the same axioms for holdsAtStep as normal fluent
% - but when the func. fluent holds, then a valueAtStep(F,S) is associated with it which is then interpreted to a non-ground value
% - when the effect of an event is to only change the value of the func. fluent then use initiatesValueAtStep/3 instead
%   of a combination of initiatesAtStep/3 and terminatesAtStep/3 -- this will set the new value and break inertia of the old value
% - the transformation from discrete to functional looks like this:
%       discrete: height(X) ... holdsAtStep(height(X), S)
%           e.g.: holdsAtStep(height(5), 2)
%     functional: height    ... holdsAtStep(height, S) and &sum{valueAtStep(height, S)} = X
%           e.g.: holdsAtStep(height, 2) and &sum{valueAtStep(height, 2)} = 5

%% functional fluents are also fluents
fluent(F) :- fluent_Func(F).
%% initially positive functional also means initially positive discrete
initiallyP(F) :- initiallyP_Func(F, _).
%% initiating a value also initiates the fluent as a whole
initiatesAtStep(E, F, S) :- initiatesValueAtStep(E, F, S).

%% utility predicates for negations
happensInitiatesValueAtStep(F, S) :- happensAtStep(E, S), initiatesValueAtStep(E, F, S).

%% new DBEC12
% functional value of a fluent at step zero
&sum{ valueAtStep(F,0) } = V :- initiallyP_Func(F, V), fluent_Func(F).

%% new DBEC13
% event effects: events can initiate functional values of fluents
% TODO this currently needs to be specified inside of the domain model of the example
% &sum{valueAtStep(F,S); X ; -Y; ...} = valueAtStep(F,S+1)

% inertia: functional value of a fluent persists unless the fluent is terminated/released or a new value is set
&sum{ valueAtStep(F,S+1) } = valueAtStep(F,S) :-
  holdsAtStep(F, S),
  not happensTerminatesAtStep(F, S),
  -releasedAtStep(F, S+1),
  not happensInitiatesValueAtStep(F, S),  % additionally check that the value was not changed
  fluent_Func(F),
  step(S+1).


% when a functional fluent is false, then its value is zero
% NOTE: when released from inertia the fluent might either not hold and then have value zero, or it might hold as a derived/non-deterministic fluent with some other value (unaffected by this zero)
% TODO this is a trick to avoid listing of all possible values
&sum{ valueAtStep(F,S) } = 0 :- not holdsAtStep(F, S), fluent_Func(F), step(S).

%% shorthand predicate
initiatedValueByAtStep(E, F, S) :-
  happensAtStep(E, S),
  initiatesValueAtStep(E, F, S).
trajectoryAtStep(F1, S1, F2, S2) :-
  S1 < S2,
  initiatesAtStep(E, F1, S1),
  happensAtStep(E, S1),
  trajectory(F1, S1, F2, S2),
  not stoppedInSteps(S1, F1, S2),
  step(S2).


%-------------------------------------------------------------------------------
% comparing functional values
%-------------------------------------------------------------------------------

% TODO the comparison(...) is done manually in the model of each domain --- why would we need this here in the axioms?
% This generates a comparison(A,B) for each interpreted value of fluents at adjacent steps
% and the choice rule for normal_atom below then says that each comparison leads to exactly one interpreted result of the comparison
%%%comparison(valueAtStep(F,S+1), valueAtStep(F,S)) :- fluent_Func(F), step(S).

% predicates for comparing values of functional fluents
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

% TODO can we not just say that there must be a step at which it equals the trigger value?
% designating significant values of continuous fluents so that we do not miss them during trajectories
comparison(valueAtStep(F,S), Val) :- trigger_value(F, Val), step(S).
:- trigger_value(F, Val), normal_atom(valueAtStep(F, S), gt, Val), normal_atom(valueAtStep(F, S+1), lt, Val), step(S), step(S+1).
:- trigger_value(F, Val), normal_atom(valueAtStep(F, S), lt, Val), normal_atom(valueAtStep(F, S+1), gt, Val), step(S), step(S+1).
% same for timepoints 
comparison(timeAtStep(S), T) :- trigger_time(T), step(S).
%:- trigger_time(T), normal_atom(timeAtStep(S), gt, T), normal_atom(timeAtStep(S+1), lt, T), step(S), step(S+1). %% time never goes backwards
:- trigger_time(T), normal_atom(timeAtStep(S), lt, T), normal_atom(timeAtStep(S+1), gt, T), step(S), step(S+1).


%-------------------------------------------------------------------------------
% Show
%-------------------------------------------------------------------------------

%% define a fact "debug_prints." to switch to debug prints instead of fancy prints
%debug_prints.

%% define a fact "negated_prints." to show negated versions of fluent values
%negated_prints.

#show.

#show happens(E,timeAtStep(S)) : happensAtStep(E,S), not debug_prints.

%% discrete fluents have values between steps
#show holdsAt(F, (timeAtStep(S), "< T =<", timeAtStep(S+1))) :  holdsAtStep(F, S+1), not fluent_Func(F), step(S), step(S+1), not debug_prints.
#show -holdsAt(F, (timeAtStep(S), "< T =<", timeAtStep(S+1))) :  -holdsAtStep(F, S+1), step(S), step(S+1), fluent(F), not debug_prints, negated_prints.

%%% discrete fluents can be released between steps
#show releasedAt(F, (timeAtStep(S), "< T =<", timeAtStep(S+1))) :  releasedAtStep(F, S+1), step(S), step(S+1), not debug_prints.
#show -releasedAt(F, (timeAtStep(S), "< T =<", timeAtStep(S+1))) :  not releasedAtStep(F, S+1), step(S), step(S+1), fluent(F), not debug_prints, negated_prints.

%% functional fluents have values between steps
#show holdsAt_Func(F, valueAtStep(F,S+1), (timeAtStep(S), "< T =<", timeAtStep(S+1))) :  holdsAtStep(F, S+1), not anyTrajectoryAtStep(F, S+1), fluent_Func(F), step(S), step(S+1), not debug_prints.
anyTrajectoryAtStep(F, S) :- trajectoryAtStep(X, Y, F, S), not debug_prints.

%% functional fluents can be continuous with their value defined by a trajectory (continuous value between steps)
#show holdsAt_Func_Cont(F, (valueAtStep(F, S), "->", valueAtStep(F, S+1)), (timeAtStep(S), "< T =<", timeAtStep(S+1))) : trajectoryAtStep(_, _, F, S+1), step(S), step(S+1), not debug_prints.


% show all for debug
#show happensAtStep(E,S) : happensAtStep(E,S), debug_prints.
#show holdsAtStep(F,S) : holdsAtStep(F,S), debug_prints.
#show releasedAtStep(F,S) : releasedAtStep(F,S), debug_prints.
#show trajectoryAtStep(Fluent1, S1, Fluent2, S2) : trajectoryAtStep(Fluent1, S1, Fluent2, S2), debug_prints.

#show  map(T, S) : map(T, S), debug_prints.
#show  checkStep(S) : checkStep(S), debug_prints.


%-------------------------------------------------------------------------------
% Defined
%-------------------------------------------------------------------------------

% define #const maxstep
#defined happens/2.

#defined initiallyP/1.
#defined initiallyN/1.
#defined initiallyP_Func/2.

#defined fluent/1.
#defined fluent_Func/1.

#defined initiatesAtStep/3.
#defined terminatesAtStep/3.
#defined releasesAtStep/3.
#defined initiatesValueAtStep/3.


#defined trajectory/4.

#defined trigger_value/2.
#defined trigger_time/1.

#defined debug_prints/0.
#defined negated_prints/0.
