% Robot walking on one-dimensional grid

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% money(0..maxmoney). 

agent(my_robot).
object(box).

#const grid_param=100.
gridLen(grid_param).

% fluent(balance(A, M)) :- account(A), money(M).
fluentF(position(A)) :- agent(A).
fluentF(position(O)) :- object(O).
fluent(holding(A, O)) :- agent(A), object(O).

% event(move_left(A, MoveLen)) :- agent(A).
% event(move_right(A, MoveLen)) :- agent(A).
event(pickUp(A, O)) :- agent(A), object(O).
event(letgooff(A, O)) :- agent(A), object(O).

%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

%% basic operation of the account -- next 4 rules
%% if balance of account A1 is greater equal to the amount to be transfered,
%% and the amount is transfered from A1 to account A2,
%% then the balance of A1 decreses and of A2 increases

&sum{ valueAtStep(position(A),S); MoveLen } = valueAtStep(position(A),S+1) :- 
    MoveLen > 0,
    normal_atom(valueAtStep(position(A),S), leq, Boundary-MoveLen),
    gridLen(Boundary),
    happensAtStep(move_right(A, MoveLen), S),
    step(S), agent(A).

defined(valueAtStep(position(A),S+1)) :- 
    MoveLen > 0,
    normal_atom(valueAtStep(position(A),S), leq, Boundary-MoveLen),
    gridLen(Boundary),
    happensAtStep(move_right(A, MoveLen), S),
    step(S), agent(A).

comparison(valueAtStep(position(A),S), Boundary-MoveLen) :- 
    MoveLen > 0,
    happensAtStep(move_right(A, MoveLen), S),
    gridLen(Boundary),
    step(S), agent(A).

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

&sum{ valueAtStep(position(A),S); -MoveLen } = valueAtStep(position(A),S+1) :- 
    MoveLen > 0,
    normal_atom(valueAtStep(position(A),S), geq, MoveLen),
    happensAtStep(move_left(A, MoveLen), S),
    step(S), agent(A).

defined(valueAtStep(position(A),S+1)) :- 
    MoveLen > 0,
    normal_atom(valueAtStep(position(A),S), geq, MoveLen),
    happensAtStep(move_left(A, MoveLen), S),
    step(S), agent(A).

comparison(valueAtStep(position(A),S), MoveLen) :- 
    MoveLen > 0,
    happensAtStep(move_left(A, MoveLen), S),
    step(S), agent(A).


initiatesAtStep(pickUp(A, O), holding(A, O), S) :- agent(A), object(O), step(S).

terminatesAtStep(letgooff(A, O), holding(A, O), S) :- agent(A), object(O), step(S).

agentChangePosition(A, S) :- agent(A), happensAtStep(move_left(A, MoveLen), S).
agentChangePosition(A, S) :- agent(A), happensAtStep(move_right(A, MoveLen), S).

&sum{ valueAtStep(position(O), S+1) } = valueAtStep(position(A),S+1) :-
    holdsAtStep(holding(A, O), S),
    agentChangePosition(A, S),
    agent(A),step(S), object(O).

defined(valueAtStep(position(O), S+1)) :-
    holdsAtStep(holding(A, O), S),
    agentChangePosition(A, S),
    agent(A),step(S), object(O).



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

:- happensAtStep(letgooff(A, O), S), not holdsAtStep(holding(A, O), S).
:- happensAtStep(pickUp(A, 0), S), agent(A), object(O), step(S),
    not normal_atom(valueAtStep(position(O), S), eq, valueAtStep(position(A), S)).

comparison(valueAtStep(position(O), S), valueAtStep(position(A), S)) :-
    agent(A), object(O), step(S).

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

% initiallyP(balance(account1, 10)).      
% initiallyP(balance(account2, 10)).      
initiallyF(position(my_robot), 6).
initiallyF(position(box), 10).

%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(move_left(my_robot, 2), 10).
happens(move_right(my_robot, 6), 20).
happens(pickUp(my_robot, box), 30).
happens(move_right(my_robot, 4), 40).
% happens(move_left(my_robot, 1), 3).
% initiallyN(F) :- not initiallyP(F), fluent(F).

% --> conclude that
%   the balance of account1 will be 4 at time 3
