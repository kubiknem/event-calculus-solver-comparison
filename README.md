This is a repo for comparing the capabilities and limitations of ASP solvers on Event Calculus.
There are examples for clingo and s(CASP) including execution logs for different domain sizes.


## How to
- directory for each solver contains a number of examples
- all solvers implemented the same examples so that they can be compared
- each example is in its own directory that features a `makefile`
- use the `makefile` to run the reasoning (or to see how to do it)
- each example also includes execution logs that show the result, runtime, and memory use


## TODO
- add a hybrid clingo implementation -- clingo[LP]?
- add more examples (rest of ICLP25 paper and any other ones)
- ? better benchmarking (currently just very basic one run, no averaging, no timeouts, ...)
