% Robot walking on one-dimensional grid

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% we have a robot on grid: [0,100]

agent(my_robot).
#const grid_param=100.
gridLen(grid_param).

% robot has a position

fluentF(position(A)) :- agent(A).

%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

%% basic operation of the robot -> he moves left and right by MoveLen

% move_right implementation

&sum{ (position(A),S-1); MoveLen } = (position(A),S) :- 
    MoveLen > 0,
    &sum{ (position(A),S-1) } <= Boundary - MoveLen,
    gridLen(Boundary),
    happens_state(move_right(A, MoveLen), S).

defined((position(A),S)) :- 
    MoveLen > 0,
    &sum{ (position(A),S-1) } <= Boundary - MoveLen,
    gridLen(Boundary), 
    happens_state(move_right(A, MoveLen), S).

% move_left implementation

&sum{ (position(A),S-1); -MoveLen } = (position(A),S) :- 
    MoveLen > 0,
    &sum{ (position(A),S-1) } >= MoveLen,
    happens_state(move_left(A, MoveLen), S).

defined((position(A),S)) :- 
    MoveLen > 0,
    &sum{ (position(A),S-1) } >= MoveLen, 
    happens_state(move_left(A, MoveLen), S).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------
  
initiallyF(position(my_robot), 0).      

%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(move_right(my_robot, 2), 1).
happens(move_right(my_robot, 4), 2).
happens(move_left(my_robot, 1), 3).
% initiallyN(F) :- not initiallyP(F), fluent(F).

% --> conclude that
%   the robot will be at position 5 at time 4
% run-by:
% clingcon -n0 ./model-con.lp ../axioms/bec_steps-clingcon.lp -c maxstep=3