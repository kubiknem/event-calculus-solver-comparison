% TODO possible modifications to implement:
% - shift effects of events?
%   - current impl.: happens@S causes holds@S   based on holds@S-1 (or also based on S-2, S-3, ...)
%   - should be:     happens@S causes holds@S+1 based on holds@S   (or also based on S-1, S-2, ...)
% - add release from inertia
% - add functional fluents being false/undefined (no value holds at S)
% - maybe add the constraint that says no steps without events?

% step(S): S is a step, ranges from 1 to maxstep                                                                               
%          step 0 is handled separately                                                                                        
step(1..maxstep).                                                                                                              

% time(S): the time of step S (and time(0) = 0)                                                                                
&sum{ time(0) } = 0.                                                                                                           
&sum{ time(S) } >  time(S-1) :- step(S).                                                                                       

% map(T, S): Map time point T to state S                                                                                       
  map(0, 0)                 :- happens(_, T), T = 0.                                                                           
{ map(T, S) : step(S) } = 1 :- happens(_, T), T > 0.                                                                           

% if T is mapped to S, then S is at time T                                                                                     
&sum{ time(S) } = T :- map(T, S).                                                                                              

% happens_state(E, S): event S happens at state S                                                                              
happens_state(E, S) :-  happens(E, T), map(T, S).                            

% TODO 
% :- not happens_state(_, S), step(S), S > 0. 


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
% for clingo-lpx, replace in
%   defined((F,S)) :- &sum{ (F,S) } = (F,S-1), fluentF(F), step(S).
% the theory atom
%   &sum{ (F,S) } = (F,S-1)
% by a normal atom
%   normal_atom((F,S), eq, (F,S-1))
%
defined((F,S)) :- normal_atom((F,S), eq, (F,S-1)), fluentF(F), step(S).
               :-              not defined((F,S)), fluentF(F), step(S).

comparison((F,S), (F,S-1)) :- fluentF(F), step(S).

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
#show  happens_state/2.
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