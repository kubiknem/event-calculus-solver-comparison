% JR: the encoding accepts only simple linear equations
%     with a fixed small number of arguments, 
%     this can be made more general

% OV: added the mapping of steps to time and some other auxiliary stuff (show, initially, constraints, ...)
% OV: the ffholds version implements holdsAt for functional fluents

% HOW TO CHANGE AN EXAMPLE FROM DEC TO FDEC
% - use in_happens(E,T) to define occurrences of input events (with T being a ground time point)
% - (optionally) use timeStep(T) instead of time(T)
% - define the constant maxstep instead of maxtime
% - divide fluents into discrete and functional
%   - discrete   --->   functional:
%     dfluent           ffluent
%     holdsAt/2         normal_atom(fholdsAt/2, op, V)
%     initiates/3       initiates/4
%     trajectory/4      trajectory/5
%     terminates/3      (nothing)
%     releases/3        releases/3 ??
%     initiallyP/1      initiallyP/2
%     initiallyN/1      (nothing)
% - use normal_atom/2 to refer to values of ffluents and define comparison/2 accordingly

%%%% OV: below was added to make these axioms compatible with the BEC/DBEC examples without a need to modify the examples
:- releasedAt(F,0), fluent(F). % nothing is initially released from CLoI
:- holdsAt(F, 0), initiallyN(F), fluent(F).    % TODO OV: changed to fluent
holdsAt(F, 0) :- initiallyP(F), fluent(F).     % TODO OV: changed to fluent
initiallyP(F) :- initiallyP(F, V), ffluent(F). % TODO OV: added
&sum{ fholdsAt(F,0) } = V :- initiallyP(F, V), ffluent(F).
%%%% end

%%% OV: to make it easier to transform DEC examples into FDEC
time(T) :- timeStep(T).

% JR: added 3 rules
initiates(E,F,T) :- initiates(E,F,EQ,T).
fluent(F) :- dfluent(F). %   discrete fluents are fluents
fluent(F) :- ffluent(F). % functional fluents are fluents
% OV: added 2 more
trajectory(F1,S1,F2,S2) :- trajectory(F1,S1,F2,EQ,S2).          % TODO OV: added
antiTrajectory(F1,S1,F2,S2) :- antiTrajectory(F1,S1,F2,EQ,S2).  % TODO OV: added

%time(0..maxtime). % OV: time replaced with timeStep (mapping after the axioms)
{holdsAt(F,T)} :- fluent(F), timeStep(T). % TODO OV: kept as fluent
{releasedAt(F,T)} :- fluent(F), timeStep(T).

% JR: normal rule heads of predicates holdsAt/2 or releasedAt/2 
%     can be shifted to the body

% DEC1
stoppedIn(T1,F,T2) :- happens(E,T), T1<T, T<T2,
  terminates(E,F,T), event(E), fluent(F), timeStep(T),
  timeStep(T1), timeStep(T2).

% DEC2
startedIn(T1,F,T2) :- happens(E,T), T1<T, T<T2,
  initiates(E,F,T), event(E), fluent(F), timeStep(T),
  timeStep(T1), timeStep(T2).

% JR: add trajectories where F1 is boolean and F2 is functional

% DEC3
holdsAt(F2,T2) :- happens(E,T1), initiates(E,F1,T1), T1<T2,
  trajectory(F1,T1,F2,T2), not stoppedIn(T1,F1,T2),
  event(E), fluent(F1), fluent(F2), timeStep(T1), timeStep(T2).
  %T1+T2<maxtime.  % TODO

% FDEC3
% JR: added
&sum{ A; B*(fholdsAt(F,T1) + C); INC*(ftimeAtStep(T2) - ftimeAtStep(T1)) } = fholdsAt(F2,T2) :-
  happens(E,T1), initiates(E,F1,T1), T1<T2,
  trajectory(F1,T1,F2,(A,B,C,F,INC),T2),
  not stoppedIn(T1,F1,T2),
  event(E), fluent(F1), ffluent(F2), timeStep(T1), timeStep(T2).  % TODO OV: changed to fluent(F1)
  %T1+T2<maxtime.  % TODO

% DEC4
holdsAt(F2,T2) :- happens(E,T1), terminates(E,F1,T1), T1<T2,
  antiTrajectory(F1,T1,F2,T2), not startedIn(T1,F1,T1+T2),
  event(E), fluent(F1), fluent(F2), timeStep(T1), timeStep(T2).
  %T1+T2<maxtime.  % TODO

% FDEC4
% JR: added
&sum{ A; B*(fholdsAt(F,T1) + C); INC*(ftimeAtStep(T2) - ftimeAtStep(T1)) } = fholdsAt(F2,T2) :-
  happens(E,T1), terminates(E,F1,T1), T1<T2,
  antiTrajectory(F1,T1,F2,(A,B,C,F,INC),T2),
  not startedIn(T1,F1,T2),
  event(E), fluent(F1), ffluent(F2), timeStep(T1), timeStep(T2).  % TODO OV: changed to fluent(F1)
  %T1+T2<maxtime.  % TODO

initiated1(F,T) :- happens(E,T), initiates(E,F,T), event(E),
  fluent(F), timeStep(T).
terminated1(F,T) :- happens(E,T), terminates(E,F,T), event(E),
  fluent(F), timeStep(T).
released1(F,T) :- happens(E,T), releases(E,F,T), event(E),
  fluent(F), timeStep(T).

% DEC5
holdsAt(F,T+1) :- holdsAt(F,T), not releasedAt(F,T+1),
  not terminated1(F,T), fluent(F), timeStep(T), T<maxstep.

% FDEC5
% JR: added for ffluents
% TODO OV: added holdsAt and terminated1
&sum{ fholdsAt(F,T) } = fholdsAt(F,T+1) :- holdsAt(F,T), not releasedAt(F,T+1),
  not terminated1(F,T), not initiated1(F,T), ffluent(F), timeStep(T), T<maxstep.

% DEC6
:- holdsAt(F,T+1), not holdsAt(F,T), not releasedAt(F,T+1),
  not initiated1(F,T), fluent(F), timeStep(T), T<maxstep.

% DEC7
releasedAt(F,T+1) :- releasedAt(F,T), not initiated1(F,T),
  not terminated1(F,T), fluent(F), timeStep(T), T<maxstep.

% DEC8
:- releasedAt(F,T+1), not releasedAt(F,T), not released1(F,T),
  fluent(F), timeStep(T), T<maxstep.

% DEC9
holdsAt(F,T+1) :- happens(E,T), initiates(E,F,T), event(E),
  fluent(F), timeStep(T), T<maxstep.  % TODO OV: kept as fluent

% FDEC9
% JR: added for ffluents
&sum{ A; B*(fholdsAt(F,T) + C) } = fholdsAt(F,T+1) :-
   happens(E,T), initiates(E,F,(A,B,C,F),T), event(E),
   ffluent(F), timeStep(T), T<maxstep.

% DEC10
:- holdsAt(F,T+1), happens(E,T), terminates(E,F,T), event(E),
  fluent(F), timeStep(T), T<maxstep.

% DEC11
releasedAt(F,T+1) :- happens(E,T), releases(E,F,T), event(E),
  fluent(F), timeStep(T), T<maxstep.

% DEC12
:- releasedAt(F,T+1), happens(E,T), initiates(E,F,T),
  event(E), fluent(F), timeStep(T), T<maxstep.
:- releasedAt(F,T+1), happens(E,T), terminates(E,F,T),
  event(E), fluent(F), timeStep(T), T<maxstep.

% TODO OV: added
% NOTE: when released from inertia the fluent might either not hold and then have value zero, or it might hold as a derived/non-deterministic fluent with some other value (unaffected by this zero)
% TODO this is a trick to avoid listing of all possible values
&sum{ fholdsAt(F,T) } = 0 :- not holdsAt(F, T), ffluent(F), timeStep(T).


%-------------------------------------------------------------------------------
% mapping time to steps
%-------------------------------------------------------------------------------

% timeStep(FT): FT is a time step, ranges from 0 to maxstep
timeStep(0..maxstep).

% ftimeAtStep(FT): the time of step FT
&sum{ ftimeAtStep(0) } = 0.                                           % step 0 is at time 0
&sum{ ftimeAtStep(FT) } > ftimeAtStep(FT-1) :- FT > 0, timeStep(FT).  % consecutive steps must have greater time                                             
&sum{ ftimeAtStep(FT) } >= 0 :- timeStep(FT).                         % there can be no negative time

% map(GT, FT): Map ground time point GT to time step FT                                                                                      
  map(0, 0).                                                      % step 0 maps to time 0
{ map(GT, FT) : timeStep(FT) } = 1 :- in_happens(_, GT), GT > 0.  % steps map to occurrence times of input events (facts from the narrative)
  map(maxtime, maxstep) :- not disable_laststep.                  % maxstep maps to maxtime (unless disabled)

% if GT is mapped to FT, then FT is at time GT                                                                                     
&sum{ ftimeAtStep(FT) } = GT :- map(GT, FT), timeStep(FT).                                                                                              

% mapping "happens at time" to "happens at step"
happens(E, FT) :-  in_happens(E, GT), map(GT, FT).                            

% restrict free floating steps:
% all steps must have an event or be a check step
%   except step 0
%   and step maxstep (optionally)
:- not anyHappens(FT), not checkStep(FT), timeStep(FT), FT > 0, FT < maxstep. % all steps between zero and max must always have an event or be a checkstep
:- disable_laststep, not anyHappens(maxstep), not checkStep(maxstep).         % maxstep must have an event only if its disabled (i.e, when maxstep is a normal step)
anyHappens(T) :- happens(E,T).

% TODO maybe could be allowed
% no event can happen at the first step (at time zero)
:- happens(E, 0).

% there can be no neighboring time steps such that the later one has a smaller time
% TODO had to add this for some examples -- not sure if this is still needed...
:- normal_atom(ftimeAtStep(FT), gt, ftimeAtStep(FT+1)), timeStep(FT), FT < maxstep.
comparison(ftimeAtStep(FT), ftimeAtStep(FT+1)) :- timeStep(FT), FT < maxstep.
:- map(T1, S1), map(T2, S2), S1 < S2, T1 > T2. 



%-------------------------------------------------------------------------------
% comparing functional values
%-------------------------------------------------------------------------------

% TODO the comparison(...) is done manually in the model of each domain --- why would we need this here in the axioms?
% This generates a comparison(A,B) for each interpreted value of fluents at adjacent steps
% and the choice rule for normal_atom below then says that each comparison leads to exactly one interpreted result of the comparison
%%%comparison(fholdsAt(F,T+1), fholdsAt(F,T)) :- ffluent(F), timeStep(T).

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
comparison(fholdsAt(F,T), Val) :- trigger_value(F, Val), timeStep(T).
:- trigger_value(F, Val), normal_atom(fholdsAt(F, T), gt, Val), normal_atom(fholdsAt(F, T+1), lt, Val), timeStep(T), timeStep(T+1).
:- trigger_value(F, Val), normal_atom(fholdsAt(F, T), lt, Val), normal_atom(fholdsAt(F, T+1), gt, Val), timeStep(T), timeStep(T+1).
comparison(fholdsAt(F,T), Val) :- trigger_value(F, _, Val), timeStep(T).
:- trigger_value(F, CF, Val), holdsAt(CF, T+1), normal_atom(fholdsAt(F, T), gt, Val), normal_atom(fholdsAt(F, T+1), lt, Val), timeStep(T), timeStep(T+1).
:- trigger_value(F, CF, Val), holdsAt(CF, T+1), normal_atom(fholdsAt(F, T), lt, Val), normal_atom(fholdsAt(F, T+1), gt, Val), timeStep(T), timeStep(T+1).
% same for timepoints 
comparison(ftimeAtStep(T), TriggT) :- trigger_time(TriggT), timeStep(T).
% :- trigger_time(TriggT), normal_atom(ftimeAtStep(T), gt, TriggT), normal_atom(ftimeAtStep(T+1), lt, TriggT), timeStep(T), timeStep(T+1). %% time never goes backwards
:- trigger_time(TriggT), normal_atom(ftimeAtStep(T), lt, TriggT), normal_atom(ftimeAtStep(T+1), gt, TriggT), timeStep(T), timeStep(T+1).


%-------------------------------------------------------------------------------
% Show
%-------------------------------------------------------------------------------

%% define a fact "debug_prints." to switch to debug prints instead of fancy prints
%debug_prints.

%% define a fact "negated_prints." to show negated versions of fluent values
%negated_prints.

#show.

#show happens(E,ftimeAtStep(T)) : happens(E,T), not debug_prints.

%% discrete fluents have values between steps
#show holdsAt(F, (ftimeAtStep(T), "< T =<", ftimeAtStep(T+1))) :  holdsAt(F, T+1), timeStep(T), timeStep(T+1), dfluent(F), not debug_prints.
#show -holdsAt(F, (ftimeAtStep(T), "< T =<", ftimeAtStep(T+1))) :  not holdsAt(F, T+1), timeStep(T), timeStep(T+1), dfluent(F), not debug_prints, negated_prints.

%%% discrete fluents can be released between steps
#show releasedAt(F, (ftimeAtStep(T), "< T =<", ftimeAtStep(T+1))) :  releasedAt(F, T+1), timeStep(T), timeStep(T+1), fluent(F), not debug_prints.
#show -releasedAt(F, (ftimeAtStep(T), "< T =<", ftimeAtStep(T+1))) :  not releasedAt(F, T+1), timeStep(T), timeStep(T+1), fluent(F), not debug_prints, negated_prints.
 
%% functional fluents have values between steps
#show fholdsAt(F, fholdsAt(F,T+1), (ftimeAtStep(T), "< T =<", ftimeAtStep(T+1))) :
  holdsAt(F, T+1),  % TODO OV: functional fluents can be false (not hold)
  not anyTrajectory(F, T+1), timeStep(T), timeStep(T+1), ffluent(F), not debug_prints.
anyTrajectory(F2, T2) :- not debug_prints,
  T1 < T2,
  initiates(E, F1, T1),
  happens(E, T1),
  trajectory(F1, T1, F2, _, T2),
  not stoppedIn(T1, F1, T2),
  timeStep(T1), timeStep(T2).
anyTrajectory(F2, T2) :- not debug_prints,
  T1 < T2,
  terminates(E, F1, T1),
  happens(E, T1),
  antiTrajectory(F1, T1, F2, _, T2),
  not stoppedIn(T1, F1, T2),
  timeStep(T1), timeStep(T2).
#show -fholdsAt(F, (ftimeAtStep(T), "< T =<", ftimeAtStep(T+1))) :
  not holdsAt(F, T+1), timeStep(T), timeStep(T+1), ffluent(F), not debug_prints, negated_prints.

%% functional fluents can be continuous with their value defined by a trajectory (continuous value between steps)
#show fholdsAtC(F2, (fholdsAt(F2, T), "->", fholdsAt(F2, T+1)), (ftimeAtStep(T), "< T =<", ftimeAtStep(T+1)), eq(off2(A), "+", koef(B), "*", (base(fholdsAt(F2,SStart)), "+", off1(C)), "+", inc(INC), "*", dur(ftimeAtStep(T+1), "-", ftimeAtStep(SStart)))) :
  SStart < T+1,
  initiates(E, F1, SStart),
  happens(E, SStart),
  trajectory(F1, SStart, F2, (A,B,C,F2,INC), T+1),
  not stoppedIn(SStart, F1, T+1),
  timeStep(T), timeStep(T+1), timeStep(SStart),
  not debug_prints.
#show fholdsAtC(F2, (fholdsAt(F2, T), "->", fholdsAt(F2, T+1)), (ftimeAtStep(T), "< T =<", ftimeAtStep(T+1)), eq(off2(A), "+", koef(B), "*", (base(fholdsAt(F2,SStart)), "+", off1(C)), "+", inc(INC), "*", dur(ftimeAtStep(T+1), "-", ftimeAtStep(SStart)))) :
  SStart < T+1,
  terminates(E, F1, SStart),
  happens(E, SStart),
  antiTrajectory(F1, SStart, F2, (A,B,C,F2,INC), T+1),
  not stoppedIn(SStart, F1, T+1),
  timeStep(T), timeStep(T+1), timeStep(SStart),
  not debug_prints.

% show all for debug
#show happens(E,T) : happens(E,T), debug_prints.
#show holdsAt(F,T) : holdsAt(F,T), debug_prints.
#show releasedAt(F,T) : releasedAt(F,T), debug_prints.

#show map(GT, FT) : map(GT, FT), debug_prints.


%-------------------------------------------------------------------------------
% Defined
%-------------------------------------------------------------------------------

% define #const maxstep
% define #const maxtime

#defined in_happens/2.

#defined time/1.

#defined initiallyP/1.
#defined initiallyN/1.
#defined initiallyP/2.

#defined fluent/1.
#defined ffluent/1.
#defined dfluent/1.

#defined initiates/3.
#defined terminates/3.
#defined releases/3.
#defined trajectory/4.
#defined antiTrajectory/4.

#defined initiates/4.
#defined trajectory/5.
#defined antiTrajectory/5.

#defined checkStep/1.

#defined trigger_value/2.
#defined trigger_value/3.
#defined trigger_time/1.

#defined disable_laststep/0.
#defined debug_prints/0.
#defined negated_prints/0.

#const disablelaststep=0.
disable_laststep :- disablelaststep = 1.
#const debugprints=0.
debug_prints :- debugprints = 1.
#const negprints=0.
negated_prints :- negprints = 1.