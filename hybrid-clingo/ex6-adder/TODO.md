OV: In my opinion default FDEC cant represent this example faithfully
    FDEC-fh is needed where ffluents have a holdsAt and thus can also have -holdsAt


If we forget about release from inertia, then
a discrete fluent f(X) can have 3 possible "states" at any given time T:
  1) holdsAt(f(X), t) is not true for any X (i.e, -holdsAt(f(X), t) is true for all X)
     [e.g.: -holdsAt(f(1), 10), -holdsAt(f(2), 10), -holdsAt(f(3), 10)]
  2) holdsAt(f(X), t) is true for exactly one X
     [e.g.:  holdsAt(f(1), 10), -holdsAt(f(2), 10), -holdsAt(f(3), 10)]
  3) holdsAt(f(X), t) is true for more than one possible values of X
     [e.g.:  holdsAt(f(1), 10),  holdsAt(f(2), 10), -holdsAt(f(3), 10)]

f(X) can be converted to a functional fluent by moving X into its interpreted value
creating fluent f which then has a value for a given time T "&sum{(f, T)} = X"

clingo lpx allows only one value at any timepoint for interpreted atoms, therefore
f can now have only 2 possible "states" at any given time T:
  1) holdsAt(f(X), t) is not true for any X (i.e, -holdsAt(f(X), t) is true for all X)
     [e.g.: -holdsAt(f, 10) and "&sum{(f, T)} = undef"]
  2) holdsAt(f(X), t) is true for exactly one X
     [e.g.:  holdsAt(f, 10) and "&sum{(f, T)} = 0"]


When we introduce a constraint that a discrete fluent can only have one value at each timepoint,
then functional and discrete fluents are treated almost exactly the same.
The only difference is defining terminates when changing the value of the fluent:
  1) for discrete fluents
    - when changing the value, we define initiates(E, f(New), T) and terminates(E, f(Old), T)
    - when removing the value (not holdsAt for all values), we only define terminates(E, f(Old), T)
  2) for functional fluents
    - when changing the value, we only define initiates(E, f(New), T) (no terminates is used)
    - when removing the value (not holdsAt for all values), we only define terminates(E, f(Old), T)
This is a bit of a disconnect since terminates is not needed for changing values of func. fluents
but  then is needed for removing their values entirely



An alternative representation (the default one now) is to no track holdsAt for func. fluents 
and only consider one state for them:
  2) "&sum{fholdsAt(f, T)} = X" always has exactly one value X for any given T
     [e.g.: "&sum{fholdsAt(f, T)} = X"]
I.e., functional fluents always have exactly one value, since they are functions and clingo-lpx
defines a value for them for all timepoints anyways (the previous approach defines "undef" as zero).
