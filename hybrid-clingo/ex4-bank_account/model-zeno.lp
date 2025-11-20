% Bank account example
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 70, section 4.2
% - modified by removing the service fee

% There are multiple bank accounts and money can be transferred between them.

#const maxstep=6.
#const maxtime=1000.

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
ffluent(          balance(A)) :- account(A).
ffluent(   minimumBalance(A)) :- account(A).
ffluent(       serviceFee(A)) :- account(A).
dfluent(serviceFeeCharged(A)) :- account(A).

% event(transfer(A1, A2, M)) :- account(A1), account(A2), money(M).
event(transfer(A1, A2, M)) :- happens(transfer(A1, A2, M), T), account(A1), account(A2).
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
initiates(transfer(A1, A2, TransM12), balance(A2), (TransM12, 1, balance(A2)), T) :-
    TransM12 > 0,
    % &sum{ (balance(A1),T-1) } >= TransM12, 
    normal_atom(fholdsAt(balance(A1),T), geq, TransM12),
    account(A1), account(A2), time(T).

% needed for normal_atom
comparison(fholdsAt(balance(A1),T), TransM12) :- 
    TransM12 > 0,
    happens(transfer(A1, A2, TransM12), T),
    account(A1), account(A2), time(T).

%*
%% terminate old balance of A2
%terminates(transfer(A1, A2, TransM12), balance(A2, DstM2), T) :-
%    holdsAt(balance(A2, DstM2), T),
%    holdsAt(balance(A1, SrcM1), T),
%    TransM12 > 0,
%    SrcM1 >= TransM12,
%    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).
*%
% TODO this is meant to terminate the old functional value (break its inertia), this is already done by initiatesValue

%*
%% new balance of A1 (sends payment)
%initiates(transfer(A1, A2, TransM12), balance(A1, SrcM1 - TransM12), T) :-
%    holdsAt(balance(A2, DstM2), T),
%    holdsAt(balance(A1, SrcM1), T),
%    TransM12 > 0,
%    SrcM1 >= TransM12,
%    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).
*%
initiates(transfer(A1, A2, TransM12), balance(A1), (-TransM12, 1, balance(A1)), T) :-
    TransM12 > 0,
    % &sum{ (balance(A1),T-1) } >= TransM12, 
    normal_atom(fholdsAt(balance(A1),T), geq, TransM12),
    account(A1), account(A2), time(T).

% already defined with the initiates above
%comparison(fholdsAt(balance(A1),T), TransM12) :-  ...


%*
%% terminate old balance of A1
%terminates(transfer(A1, A2, TransM12), balance(A1, SrcM1), T) :-
%    holdsAt(balance(A2, DstM2), T),
%    holdsAt(balance(A1, SrcM1), T),
%    TransM12 > 0,
%    SrcM1 >= TransM12,
%    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).
*%
% TODO this is meant to terminate the old functional value (break its inertia), this is already done by initiatesValue



% when a service fee is charged, then a note is made to avoid repeated charging
initiates(chargeServiceFee(A), serviceFeeCharged(A), T) :- account(A), time(T).

% this is reset every month
% happens(monthlyReset(A), T) :- &sum{ time(T) } = T, endOfMonth(T), account(A), time(T).
happens(monthlyReset(A), T) :- normal_atom(ftimeAtStep(T), eq, TriggerT), endOfMonth(TriggerT), account(A), time(T).

terminates(monthlyReset(A), serviceFeeCharged(A), T):- account(A), time(T).

% restrict that there must exist a state with its ftimeAtStep exactly equal to endOfMonth
% (by saying that there cannot be two subsequent states in which one is lt/gt and the next gt/lt, i.e. there is no state with exactly eq)
trigger_time(T) :- endOfMonth(T).
    % :- normal_atom(ftimeAtStep(T), lt, TriggerT), normal_atom(ftimeAtStep(T+1), gt, TriggerT), endOfMonth(TriggerT), time(T), time(T+1).
    % :- normal_atom(ftimeAtStep(T), gt, TriggerT), normal_atom(ftimeAtStep(T+1), lt, TriggerT), endOfMonth(TriggerT), time(T), time(T+1).
    %
    % comparison(ftimeAtStep(T), TriggerT) :- endOfMonth(TriggerT), time(T).


% if a service fee is charged, then the balance of the account is decreased
% new balance
%*
%initiates(chargeServiceFee(A), balance(A, OldM - FeeM), T) :-
%    holdsAt(balance(A, OldM), T),
%    holdsAt(serviceFee(A, FeeM), T),
%    account(A), time(T), money(OldM), money(FeeM).
*%

initiates(chargeServiceFee(A), balance(A), (-fholdsAt(serviceFee(A),T), 1, balance(A)), T) :-
    time(T), account(A).

%*
%% terminate old balance
%terminates(chargeServiceFee(A), balance(A, OldM), T) :-
%    holdsAt(balance(A, OldM), T),
%    account(A), time(T), money(OldM).
*%
% TODO this is meant to terminate the old functional value (break its inertia), this is already done by initiates/4


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

happens(chargeServiceFee(A), T) :-
    % &sum{ (balance(A),T-1) } < (minimumBalance(A),T-1), 
    normal_atom(fholdsAt(balance(A),T), lt, fholdsAt(minimumBalance(A),T)), 
    not holdsAt(serviceFeeCharged(A), T),
    account(A), time(T).
    
comparison(fholdsAt(balance(A),T), fholdsAt(minimumBalance(A),T)) :- 
    account(A), time(T).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(serviceFeeCharged(account1)).
initiallyN(serviceFeeCharged(account2)).
initiallyP(balance(account1), 10).      
initiallyP(balance(account2), 10).      
initiallyP(minimumBalance(account1),  5).
initiallyP(minimumBalance(account2),  5).
initiallyP(    serviceFee(account1),  1).    
initiallyP(    serviceFee(account2),  1).    
initiallyN(F) :- not initiallyP(F), not initiallyP(F, _), fluent(F).
     


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

in_happens(transfer(account1, account2, 2), 10).
in_happens(transfer(account1, account2, 4), 20).

% --> conclude that
%   a service fee is charged to account1 "in response to transfer at time 20" due to the balance being 4
%   the balance of account1 will be 3 at time 40
%   the service fee flag is reset at time 50
%   a service fee is again charged to account1 "in response to reset at time 50"
%   the balance of account1 will be 2 after 
