% Robot walking on one-dimensional grid

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% money(0..maxmoney). 

agent(my_robot).
#const grid_param=100.
gridLen(grid_param).

% fluent(balance(A, M)) :- account(A), money(M).
fluentF(position(A)) :- agent(A).

%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

%% basic operation of the account -- next 4 rules
%% if balance of account A1 is greater equal to the amount to be transfered,
%% and the amount is transfered from A1 to account A2,
%% then the balance of A1 decreses and of A2 increases

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

%*
%% new balance of A1 (sends payment)
%initiates(transfer(A1, A2, TransM12), balance(A1, SrcM1 - TransM12), T) :-
%    holdsAt(balance(A2, DstM2), T),
%    holdsAt(balance(A1, SrcM1), T),
%    TransM12 > 0,
%    SrcM1 >= TransM12,
%    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).
%% terminate old balance of A1
%terminates(transfer(A1, A2, TransM12), balance(A1, SrcM1), T) :-
%    holdsAt(balance(A2, DstM2), T),
%    holdsAt(balance(A1, SrcM1), T),
%    TransM12 > 0,
%    SrcM1 >= TransM12,
%    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).
*%

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
%*
%% an account has a single unique balance at a time
%M1=M2 :- holdsAt(balance(A, M1), T), holdsAt(balance(A, M2), T),
%    account(A), time(T), money(M1), money(M2).
%
%% an account can only have a single unique minimumBalance at a time % modif -- added
%M1=M2 :- holdsAt(minimumBalance(A, M1), T), holdsAt(minimumBalance(A, M2), T),
%    account(A), time(T), money(M1), money(M2).
*%

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

% initiallyP(balance(account1, 10)).      
% initiallyP(balance(account2, 10)).      
initiallyF(position(my_robot), 0).      

%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(move_right(my_robot, 2), 1).
happens(move_right(my_robot, 4), 2).
happens(move_left(my_robot, 1), 3).
% initiallyN(F) :- not initiallyP(F), fluent(F).

% --> conclude that
%   the balance of account1 will be 4 at time 3
