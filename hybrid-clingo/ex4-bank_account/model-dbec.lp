% Bank account example
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 70, section 4.2

% There are multiple bank accounts and money can be transferred between them. If the balance is below a specified minimum, then a monthly fee is charged.

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

endOfMonth(50).
% money(0..maxmoney). 

account(account1).
account(account2).

% fluent(balance(A, M)) :- account(A), money(M).
% fluent(minimumBalance(A, M)) :- account(A), money(M).
% fluent(serviceFee(A, M)) :- account(A), money(M).
fluent_Func(         balance(A)) :- account(A).
fluent_Func(  minimumBalance(A)) :- account(A).
fluent_Func(      serviceFee(A)) :- account(A).
fluent(serviceFeeCharged(A)) :- account(A).

event(transfer(A1, A2)) :- account(A1), account(A2).
event(chargeServiceFee(A)) :- account(A).
event(monthlyReset(A)) :- account(A).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

%% basic operation of the account -- next 4 rules
%% if balance of account A1 is greater equal to the amount to be transfered,
%% and the amount is transfered from A1 to account A2,
%% then the balance of A1 decreses and of A2 increases

%*
%% new balance of A2 (receives payment)
%initiates(transfer(A1, A2, TransM12), balance(A2, DstM2 + TransM12), T) :-
%    holdsAt(balance(A2, DstM2), T),
%    holdsAt(balance(A1, SrcM1), T),
%    TransM12 > 0,
%    SrcM1 >= TransM12,
%    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).
*%
&sum{valueAtStep(balance(A2),S); TransM12} = valueAtStep(balance(A2),S+1) :-
    initiatedValueByAtStep(transfer(A1, A2, TransM12), balance(A2), S),
    step(S+1).
initiatesValueAtStep(transfer(A1, A2, TransM12), balance(A2), S) :-
    TransM12 > 0,
    % &sum{ (balance(A1),S-1) } >= TransM12, 
    holdsAtStep(balance(A2), S),
    holdsAtStep(balance(A1), S),
    normal_atom(valueAtStep(balance(A1),S), geq, TransM12),
    account(A2),
    step(S).

% needed for normal_atom
comparison(valueAtStep(balance(A1),S), TransM12) :- 
    TransM12 > 0,
    happensAtStep(transfer(A1, A2, TransM12), S),
    step(S).

%*
%% terminate old balance of A2
%terminates(transfer(A1, A2, TransM12), balance(A2, DstM2), T) :-
%    holdsAt(balance(A2, DstM2), T),
%    holdsAt(balance(A1, SrcM1), T),
%    TransM12 > 0,
%    SrcM1 >= TransM12,
%    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).
*%
% TODO this is meant to terminate the old functional value (break its inertia), this is already done by initiatesValueAtStep

%*
%% new balance of A1 (sends payment)
%initiates(transfer(A1, A2, TransM12), balance(A1, SrcM1 - TransM12), T) :-
%    holdsAt(balance(A2, DstM2), T),
%    holdsAt(balance(A1, SrcM1), T),
%    TransM12 > 0,
%    SrcM1 >= TransM12,
%    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).
*%
&sum{valueAtStep(balance(A1),S); -TransM12} = valueAtStep(balance(A1),S+1) :-
    initiatedValueByAtStep(transfer(A1, A2, TransM12), balance(A1), S),
    step(S+1).
initiatesValueAtStep(transfer(A1, A2, TransM12), balance(A1), S) :-
    TransM12 > 0,
    % &sum{ (balance(A1),S-1) } >= TransM12, 
    holdsAtStep(balance(A2), S),
    holdsAtStep(balance(A1), S),
    normal_atom(valueAtStep(balance(A1),S), geq, TransM12),
    account(A2),
    step(S).

% already defined with the initiates above
%comparison(valueAtStep(balance(A1),S), TransM12) :-  ...


%*
%% terminate old balance of A1
%terminates(transfer(A1, A2, TransM12), balance(A1, SrcM1), T) :-
%    holdsAt(balance(A2, DstM2), T),
%    holdsAt(balance(A1, SrcM1), T),
%    TransM12 > 0,
%    SrcM1 >= TransM12,
%    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).
*%
% TODO this is meant to terminate the old functional value (break its inertia), this is already done by initiatesValueAtStep



% when a service fee is charged, then a note is made to avoid repeated charging
initiatesAtStep(chargeServiceFee(A), serviceFeeCharged(A), S) :- account(A), step(S).

% this is reset every month
% happensAtStep(monthlyReset(A), S) :- &sum{ time(S) } = T, endOfMonth(T), account(A), step(S).
happensAtStep(monthlyReset(A), S) :- normal_atom(timeAtStep(S), eq, T), endOfMonth(T), account(A), step(S).

terminatesAtStep(monthlyReset(A), serviceFeeCharged(A), S):- account(A), step(S).

% TODO this is not needed for this particular example, but is needed in general
% restrict that there must exist a state with its timeAtStep exactly equal to endOfMonth
% (by saying that there cannot be two subsequent states in which one is lt/gt and the next gt/lt, i.e. there is no state with exactly eq)
trigger_time(T) :- endOfMonth(T).
    % :- normal_atom(timeAtStep(S), lt, T), normal_atom(timeAtStep(S+1), gt, T), endOfMonth(T), step(S), step(S+1).
    % :- normal_atom(timeAtStep(S), gt, T), normal_atom(timeAtStep(S+1), lt, T), endOfMonth(T), step(S), step(S+1).
    %
    % comparison(timeAtStep(S), T) :- endOfMonth(T), step(S).


% if a service fee is charged, then the balance of the account is decreased
% new balance
%*
%initiates(chargeServiceFee(A), balance(A, OldM - FeeM), T) :-
%    holdsAt(balance(A, OldM), T),
%    holdsAt(serviceFee(A, FeeM), T),
%    account(A), time(T), money(OldM), money(FeeM).
*%
&sum{ valueAtStep(balance(A),S); -valueAtStep(serviceFee(A),S) } = valueAtStep(balance(A),S+1) :-
    initiatedValueByAtStep(chargeServiceFee(A), balance(A), S),
    step(S+1).
initiatesValueAtStep(chargeServiceFee(A), balance(A), S) :-
    step(S), account(A).

%*
%% terminate old balance
%terminates(chargeServiceFee(A), balance(A, OldM), T) :-
%    holdsAt(balance(A, OldM), T),
%    account(A), time(T), money(OldM).
*%
% TODO this is meant to terminate the old functional value (break its inertia), this is already done by initiatesValueAtStep


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
%
%% an account can only have a single unique serviceFee at a time % modif -- added
%M1=M2 :- holdsAt(serviceFee(A, M1), T), holdsAt(serviceFee(A, M2), T),
%    account(A), time(T), money(M1), money(M2).
*%
% TODO these state constraints are not needed since lpx only allows one value at a time for functional fluents


%-------------------------------------------------------------------------------
% triggered events
%-------------------------------------------------------------------------------

% if the balance of an account falls below the minimum
% and a service fee has not yet been charged
% then a service fee will be charged
%*
%happens(chargeServiceFee(A), T) :-
%    holdsAt(balance(A,AccM), T), holdsAt(minimumBalance(A, MinM), T), AccM < MinM,
%    not holdsAt(serviceFeeCharged(A), T),
%    account(A), time(T), money(AccM), money(MinM).
*%

happensAtStep(chargeServiceFee(A), S) :-
    % &sum{ (balance(A),S-1) } < (minimumBalance(A),S-1), 
    holdsAtStep(balance(A), S),
    holdsAtStep(minimumBalance(A), S),
    normal_atom(valueAtStep(balance(A),S), lt, valueAtStep(minimumBalance(A),S)), 
    not holdsAtStep(serviceFeeCharged(A), S),
    account(A), step(S).
    
comparison(valueAtStep(balance(A),S), valueAtStep(minimumBalance(A),S)) :- 
    account(A), step(S).

% time epsilon to trigger chargeServiceFee(A)
% TODO what if some other event happened in between S and S+1? --- probably need to ensure that epsilon is "small enough"?
epsilon("1.1"). % valid with clingo-lpx
&sum{ timeAtStep(S+1); -timeAtStep(S) } = E :- epsilon(E),
    % &sum{ (balance(A),S-1) } < (minimumBalance(A),S-1), 
    normal_atom(valueAtStep(balance(A),S+1), lt, valueAtStep(minimumBalance(A),S+1)), 
    not holdsAtStep(serviceFeeCharged(A), S+1),
    happensAtStep(chargeServiceFee(A), S+1),
    account(A), step(S), step(S+1).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------


initiallyN(serviceFeeCharged(account1)).
initiallyN(serviceFeeCharged(account2)).
%*
%initiallyP(balance(account1, 10)).      
%initiallyP(balance(account2, 10)).      
%initiallyP(minimumBalance(account1, 5)).
%initiallyP(minimumBalance(account2, 5)).
%initiallyP(serviceFee(account1, 1)).    
%initiallyP(serviceFee(account2, 1)).    
*%
initiallyP_Func(       balance(account1), 10).      
initiallyP_Func(       balance(account2), 10).      
initiallyP_Func(minimumBalance(account1),  5).
initiallyP_Func(minimumBalance(account2),  5).
initiallyP_Func(    serviceFee(account1),  1).    
initiallyP_Func(    serviceFee(account2),  1).    
initiallyN(F) :- not initiallyP(F), not initiallyP_Func(F, _), fluent(F).

%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(transfer(account1, account2, 2), 10).
happens(transfer(account1, account2, 4), 20).

% --> conclude that
%   a service fee is charged to account1 "in response to transfer at time 20" due to the balance being 4
%   the balance of account1 will be 3 at time 40
%   the service fee flag is reset at time 50
%   a service fee is again charged to account1 "in response to reset at time 50"
%   the balance of account1 will be 2 after 

% this forces the last step to have time 100 creating a new step so that we can check the values of fluents at time 100
% the step will have no event and therefore must be declared as a checkStep
checkStep(maxstep).
&sum{ timeAtStep(maxstep) } = 100.

% TODO alternatively we could just introduce a new event just to check the values 
%happens(check, 100).