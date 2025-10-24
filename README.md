This is a repo for comparing the capabilities and limitations of ASP solvers on Event Calculus.
There are examples for Clingo and s(CASP) including execution logs for different domain sizes.


## How to
- directory for each solver contains a number of examples
- all solvers implemented the same examples so that they can be compared
- each example is in its own directory that features a `makefile`
- use the `makefile` to run the reasoning (or to see how to do it)
- each example also includes execution logs that show the result, runtime, and memory use


## TODO / QUESTIONS for clingo-lpx
- ? Querying values of fluents at an arbitrary timepoint is cumbersome. Currently hacked by introducing check events. Any better way to do this?
- ? Any way to map interpreted values into the answer using #show? (Place things from "Assignment:" directly into "Answer:" in the output)
- ? Any way to say steps with `[+-*]e` are not allowed? -- might help with the triggered events problem

## TODO
- comparison between hybrid-clingo and scasp (maybe examples with growing number of events/steps?)
- ? better benchmarking (currently just very basic one run, no averaging, no timeouts, ...)
- add even more examples?


## Notes about the examples
1) ex1-light_on_off
   - The most basic event calculus example. Included as a way to test the implementation of the axioms.
   - The grounding size is not too much of a problem here since there is only one boolean fluent (no parameters) and one non-parametric event.
2) ex2-bank_account_no_fee
   - Discrete fluents and changes. Slightly simplified version of ex4. Included to show the grounding explosion problem.
   - Grounding size becomes a problem fairly quickly since there is a fluent for the amount of money and an event with money as parameter.
3) ex3-falling_object
   - Basic example of continuous change (trajectory + continuous fluent). Included to show inaccuracy issues caused by discretization.
   - Grounding size is a problem.
4) ex4-bank_account
   - Discrete fluents and changes with a triggered event. Preventing repeated trigger becomes tricky when reasoning in continuous time.
   - Requires special techniques or remodeling to avoid zeno-like behavior (infinitely fast response / event occurrence infinitely close to a non-inclusive bound) in continuous time.
5) ex5-light_toggle
   - Very similar to ex1. Uses context dependent event effects via initiates/terminates with a body.
6) e6-adder
   - Testing functional fluents. 
7) ex7-pulsing_light 
   - Circular trajectories
8) ex8-bouncing_ball
   - Zeno behavior
9) ex9-water_tanks
   - Zeno behavior
10) ex10-blinking_light
   - Trivial zeno behavior (infinitely fast frequency)
11) ex11-coin_flip
   - Non-deterministic discrete fluent
12) ex12-dice_roll
   - Non-deterministic functional fluent