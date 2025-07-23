% step(S): S is a step, ranges from 1 to maxstep
%          step 0 is handled separately
step(1..maxstep).

% time(S): the time of step S (and time(0) = 0)
&sum{ time(0) } = 0.
&sum{ time(S) } >  time(S-1) :- step(S).

% map((E,T), S): Event E happening at time point T is mapped to state S
  map((E,0), 0)                 :- happens(E, T), T = 0.
{ map((E,T), S) : step(S) } = 1 :- happens(E, T), T > 0.

% if (E,T) is mapped to S, then S is at time T
&sum{ time(S) } = T :- map((E,T), S).

% happens_state(E, S): event S happens at state S
happens_state(E, S) :-  happens(E, T), map((E,T), S).

%
% initial state
%

% holds(F, V, S): fluent F has value V at step S
holds(F,  true, 0) :- initiallyP(F).
holds(F, false, 0) :- initiallyN(F).

% (F,S) = V: functional fluent F at step S has value V
&sum{ (Fluent,0) } = V :- initiallyF(Fluent, V).

% Note: we assume the initial situation is complete

%
% inertia 
%

% boolean fluents
opposite(true, false). opposite(false, true).
%
holds(F, V, S) :- holds(F, V, S-1), step(S), 
                  opposite(V,VV), not holds(F, VV, S).

% functional fluents
defined((F,S)) :- &sum{ (F,S) } = (F,S-1), fluentF(F), step(S).
               :-      not defined((F,S)), fluentF(F), step(S).

%
% Note: 
%   1. The last constraint requires that all fluents F are defined at all steps S
%   2. A fluent is defined if it persists, or if it is the effect of some event 
%      (this is derived by the domain-specific rules)
%   From 1 and 2, the fluents either persist, or are the effect of some event. 
%   This solves the frame problem in this setting.
%

%
% Show
%
#show.
#show  holdsAt(F,S) : holds(F, true,S).
% #show -holdsAt(F,S) : holds(F,false,S).
% #show  holdsAt(E,S) : happens_state(E,S). %holds(F, true,S).

%
% Defined
%
% define #const maxstep
#defined happens/2.
#defined initiallyP/1.
#defined initiallyN/1.
#defined initiallyF/1.
#defined fluentF/1.
