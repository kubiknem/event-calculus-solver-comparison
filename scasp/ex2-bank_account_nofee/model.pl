% Bank account example
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 70, section 4.2
% - modified by removing the service fee

% There are multiple bank accounts and money can be transferred between them.

#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.


%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

%% max_time(PARAMETER).     %% added on execution via an external file

account(account1).
account(account2).

fluent(balance(A, M)).

event(transfer(A1, A2, M)).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

%% basic operation of the account -- next 4 rules
%% if balance of account A1 is greater equal to the amount to be transfered,
%% and the amount is transfered from A1 to account A2,
%% then the balance of A1 decreses and of A2 increases
% new balance of A2 (receives payment)
initiates(transfer(A1, A2, TransM12), balance(A2, SUM), T) :-
    TransM12 .>. 0,
    SrcM1 .>=. TransM12,
    SUM .=. DstM2 + TransM12,
    holdsAt(balance(A2, DstM2), T),
    holdsAt(balance(A1, SrcM1), T).
% terminate old balance of A2
terminates(transfer(A1, A2, TransM12), balance(A2, DstM2), T) :-
    TransM12 .>. 0,
    SrcM1 .>=. TransM12,
    holdsAt(balance(A2, DstM2), T),
    holdsAt(balance(A1, SrcM1), T).
% new balance of A1 (sends payment)
initiates(transfer(A1, A2, TransM12), balance(A1, SUM), T) :-
    TransM12 .>. 0,
    SrcM1 .>=. TransM12,
    SUM .=. SrcM1 - TransM12,
    holdsAt(balance(A2, DstM2), T),
    holdsAt(balance(A1, SrcM1), T).
% terminate old balance of A1
terminates(transfer(A1, A2, TransM12), balance(A1, SrcM1), T) :-
    TransM12 .>. 0,
    SrcM1 .>=. TransM12,
    holdsAt(balance(A2, DstM2), T),
    holdsAt(balance(A1, SrcM1), T).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% not needed ...


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyP(balance(account1, 10)).      
initiallyP(balance(account2, 10)).  
initiallyN(F) :- not initiallyP(F).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(transfer(account1, account2, 2), 10).
happens(transfer(account1, account2, 4), 20).

% --> conclude that
%   the balance of account1 will be 4 at time 30
?- holdsAt(balance(account1, X), 30).    % 4