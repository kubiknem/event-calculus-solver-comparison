% Robot walking and moving a box on one-dimensional grid
% In this extended version i try to let abduction find me the best
% order of moves for the robot to take to transport box from starting position
% to goal position. TODO: try #minimaze (and other optimisations)

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% we have a robot and a box on grid: [0,100]

agent(my_robot).
object(box).

#const grid_param=100.
gridLen(grid_param).

% robot and box has position, robot can hold the box
fluent_Func(position(A)) :- agent(A).
fluent_Func(position(O)) :- object(O).
fluent(holding(A, O)) :- agent(A), object(O).

% event(move_left(A, MoveLen)) :- agent(A).
% event(move_right(A, MoveLen)) :- agent(A).
event(pickUp(A, O)) :- agent(A), object(O).
event(letgooff(A, O)) :- agent(A), object(O).

%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

%% basic operation of the robot -> he moves left and right by MoveLen
%% now extended of possibility for the robot to hold the box and move it

% robot move_right

&sum{ valueAtStep(position(A),S); MoveLen } = valueAtStep(position(A),S+1) :- 
    initiatedByAtStep_Func(move_right(A, MoveLen), position(A), valueAtStep(position(A), S+1), S).
initiatesAtStep_Func(move_right(A, MoveLen), position(A), valueAtStep(position(A), S+1), S) :- 
    MoveLen > 0,
    happensAtStep(move_right(A, MoveLen), S),
    holdsAtStep_Func(position(A), valueAtStep(position(A), S), S),
    gridLen(Boundary), % escaping grid forbidden
    step(S), agent(A).


terminatesAtStep_Func(move_right(A, MoveLen), position(A), valueAtStep(position(A), S), S) :- 
    MoveLen > 0,
    happensAtStep(move_right(A, MoveLen), S),
    holdsAtStep_Func(position(A), valueAtStep(position(A), S), S),
    gridLen(Boundary), % escaping grid forbidden
    step(S), agent(A).

% robot move_left

&sum{ valueAtStep(position(A),S); -MoveLen } = valueAtStep(position(A),S+1) :- 
    initiatedByAtStep_Func(move_left(A, MoveLen), position(A), valueAtStep(position(A), S+1), S).
initiatesAtStep_Func(move_left(A, MoveLen), position(A), valueAtStep(position(A), S+1), S) :- 
    MoveLen > 0,
    happensAtStep(move_left(A, MoveLen), S),
    holdsAtStep_Func(position(A), valueAtStep(position(A), S), S),  % escaping grid forbidden
    step(S), agent(A).

% defined(valueAtStep(position(A),S+1)) :- 
%     MoveLen > 0,
%     normal_atom(valueAtStep(position(A),S), geq, MoveLen),
%     happensAtStep(move_left(A, MoveLen), S),
%     step(S), agent(A).


terminatesAtStep_Func(move_left(A, MoveLen), position(A), valueAtStep(position(A), S), S) :- 
    MoveLen > 0,
    happensAtStep(move_left(A, MoveLen), S),
    holdsAtStep_Func(position(A), valueAtStep(position(A), S), S),  % escaping grid forbidden
    step(S), agent(A).

%% TODO: add energy and speed...

% robot can hold a box

initiatesAtStep(pickUp(A, O), holding(A, O), S) :- agent(A), object(O), step(S).

terminatesAtStep(letgooff(A, O), holding(A, O), S) :- agent(A), object(O), step(S).

% implementation of box moving with the robot

happensAtStep(agentChangePosition(A, S), S) :- agent(A), happensAtStep(move_left(A, MoveLen), S).
happensAtStep(agentChangePosition(A, S), S) :- agent(A), happensAtStep(move_right(A, MoveLen), S).


&sum{ valueAtStep(position(O), S+1) } = valueAtStep(position(A),S+1) :-
    initiatedByAtStep_Func(agentChangePosition(A, S), position(O), valueAtStep(position(O), S+1), S), holdsAtStep(holding(A, O), S).

initiatesAtStep_Func(agentChangePosition(A, S), position(O), valueAtStep(position(O), S+1), S) :-
    holdsAtStep(holding(A, O), S),
    holdsAtStep_Func(position(O), valueAtStep(position(O), S), S),
    agent(A), step(S), object(O).

terminatesAtStep_Func(agentChangePosition(A, S), position(O), valueAtStep(position(O), S), S) :-
    holdsAtStep(holding(A, O), S),
    holdsAtStep_Func(position(O), valueAtStep(position(O), S), S),
    agent(A), step(S), object(O).


% defined(valueAtStep(position(O), S+1)) :-
%     holdsAtStep(holding(A, O), S),
%     agentChangePosition(A, S),
%     agent(A),step(S), object(O).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% cant letgooff a box im not holding
:- happensAtStep(letgooff(A, O), S), not holdsAtStep(holding(A, O), S).

% cant pickup a box if im not on a same position
:- happensAtStep(pickUp(A, O), S), agent(A), object(O), step(S),
    not normal_atom(valueAtStep(position(O), S), eq, valueAtStep(position(A), S)).

comparison(valueAtStep(position(O), S), valueAtStep(position(A), S)) :-
    agent(A), object(O), step(S).

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------
     
initiallyP_Func(position(my_robot), 6).
initiallyP_Func(position(box), 10).
initiallyN(holding(A, O)) :- agent(A), object(O).

%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

% debug_prints.

%--------------------------------

%---------&minimaze-------------

% fluent_Func(total_move_cost).
% &sum{ valueAtStep(total_move_cost, S); MoveLen } = valueAtStep(total_move_cost,S+1) :-
%     initiatedByAtStep_Func(agentChangePosition(A, MoveLen, S), total_move_cost, valueAtStep(total_move_cost, S+1), S).

% initiatesAtStep_Func(agentChangePosition(A, MoveLen, S), total_move_cost, valueAtStep(total_move_cost, S+1), S) :-
%     holdsAtStep_Func(total_move_cost, valueAtStep(total_move_cost, S), S),
%     agent(A), step(S), object(O).

% terminatesAtStep_Func(agentChangePosition(A, MoveLen, S), total_move_cost, valueAtStep(total_move_cost, S), S) :-
%     holdsAtStep_Func(total_move_cost, valueAtStep(total_move_cost, S), S),
%     agent(A), step(S), object(O).
% &dom{ 0..100 } = MoveLen.

show_moveLen(MoveLen) :- happens(move_right(my_robot, MoveLen), T).
show_moveLen(MoveLen) :- happens(move_left(my_robot, MoveLen), T).
#show show_moveLen/1.

% box start_position = 10
% robot start_position = 6
moveLen(0..grid_param).

happens(move_right(my_robot, curr_move1), 10).
happens(pickUp(my_robot, box), 20).


happens(move_right(my_robot, curr_move2), 30). % MoveLen = curr_move
happens(move_left(my_robot, curr_move3), 40).
happens(letgooff(my_robot, box), 50).
happens(move_right(my_robot, 6), 60).


% &minimize {valueAtStep(position(my_robot),4)}.

&dom{ 0..grid_param } = valueAtStep(position(O), S):- object(O), step(S).
&dom{ 0..grid_param } = valueAtStep(position(A), S):- agent(A), step(S).

&dom{ 0..grid_param }=curr_move1.
&dom{ 0..grid_param }=curr_move2.
&dom{ 0..grid_param }=curr_move3.

% &dom{ 0..grid_param }=curr_move4.
&minimize {-curr_move2; -curr_move1; -curr_move3}.

cost_movelen( MoveLen, S ) :- happensAtStep(move_right(my_robot, MoveLen), S), step(S).
cost_movelen( MoveLen, S ) :- happensAtStep(move_left(my_robot, MoveLen), S), step(S).
#show cost_movelen/2.

#const goal_place=25.
:- not normal_atom(valueAtStep(position(box), maxstep), eq, goal_place).
comparison(valueAtStep(position(box), maxstep), goal_place).

% run by:
% clingo-lpx --strict -n0 ./model-lpx-minimaze.lp ../axioms/bec_steps-clingo_lpx.lp -c maxstep=6 | ../utils/replace_assignments.sh | ../utils/make-readable.sh

%-------------------------

% happens(move_right(my_robot, MoveLen), 20) :- moveLen(MoveLen).
% happens(pickUp(my_robot, box), 30) :- moveLen(MoveLen).
% happens(move_right(my_robot, MoveLen), 40) :- moveLen(MoveLen).
% happens(move_left(my_robot, MoveLen), 50) :- moveLen(MoveLen).

% #const goal=33.
% :- step(maxstep), step(S), object(O), not normal_atom(valueAtStep(position(O), S), eq, 0).

% comparison(valueAtStep(position(O), S), 0) :-
%     object(O), step(S).
% happens(move_left(my_robot, 1), 3).
% initiallyN(F) :- not initiallyP(F), fluent(F).

% --> conclude all possible ways to transfer the box from START to GOAl
%   then try to optimize it, (currently not working)
%   TODO: finish script for multiple answer sets
%   TODO: add more functionality: energy, speed, acceleration, 2D grid...
% run-by:
% clingo-lpx --strict -n1 ./model-lpx-extended.lp ../axioms/bec_steps-clingo_lpx.lp -c maxstep=5
% or (with make-readable scripts)
% clingo-lpx --strict -n1 ./model-lpx-extended.lp ../axioms/bec_steps-clingo_lpx.lp -c maxstep=5 | ../utils/replace_assignments.sh | ../utils/make-readable.sh

% pohrat si s show
