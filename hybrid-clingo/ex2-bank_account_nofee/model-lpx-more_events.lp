% Bank account example
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 70, section 4.2
% - modified by removing the service fee

% There are multiple bank accounts and money can be transferred between them.

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% money(0..maxmoney). 

account(account1).
account(account2).

% fluent(balance(A, M)) :- account(A), money(M).
fluent_Func(balance(A)) :- account(A).

% event(transfer(A1, A2, M)) :- account(A1), account(A2), money(M).


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
%% terminate old balance of A2
%terminates(transfer(A1, A2, TransM12), balance(A2, DstM2), T) :-
%    holdsAt(balance(A2, DstM2), T),
%    holdsAt(balance(A1, SrcM1), T),
%    TransM12 > 0,
%    SrcM1 >= TransM12,
%    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).
*%
&sum{ (balance(A2),S-1); TransM12 } = (balance(A2),S) :- 
    TransM12 > 0,
    % &sum{ (balance(A1),S-1) } >= TransM12, 
    normal_atom((balance(A1),S-1), geq, TransM12),
    happens_state(transfer(A1, A2, TransM12), S).

defined((balance(A2),S)) :- 
    TransM12 > 0,
    % &sum{ (balance(A1),S-1) } >= TransM12, 
    normal_atom((balance(A1),S-1), geq, TransM12),
    happens_state(transfer(A1, A2, TransM12), S).

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

&sum{ (balance(A1),S-1); -TransM12 } = (balance(A1),S) :- 
    TransM12 > 0,
    % &sum{ (balance(A1),S-1) } >= TransM12, 
    normal_atom((balance(A1),S-1), geq, TransM12),
    happens_state(transfer(A1, A2, TransM12), S).

defined((balance(A1),S)) :- 
    TransM12 > 0,
    % &sum{ (balance(A1),S-1) } >= TransM12, 
    normal_atom((balance(A1),S-1), geq, TransM12),
    happens_state(transfer(A1, A2, TransM12), S).
    
comparison((balance(A1),S-1), TransM12) :- 
    TransM12 > 0,
    happens_state(transfer(A1, A2, TransM12), S).

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
initially_Func(balance(account1), 100).      
initially_Func(balance(account2), 100).      


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(transfer(account1, account2, 2), 1).
happens(transfer(account1, account2, 2), 2).
happens(transfer(account1, account2, 2), 3).
happens(transfer(account1, account2, 2), 4).
happens(transfer(account1, account2, 2), 5).
happens(transfer(account1, account2, 2), 6).    

% happens(transfer(account1, account2, 2), 7).
% happens(transfer(account1, account2, 2), 8).
% happens(transfer(account1, account2, 2), 9).
% happens(transfer(account1, account2, 2), 10).
% initiallyN(F) :- not initiallyP(F), fluent(F).

% --> conclude that
%   the balance of account1 will be ...
