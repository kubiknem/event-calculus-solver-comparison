Using Clingo based on encoding techniques / style from http://decreasoner.sourceforge.net/csr/ecasp/ and https://azreasoners.github.io/f2lp/index.html


## Note about the axioms
There are 4 versions of the axioms. In s(CASP) we use BEC and, therefore, it is the default one used here in Clingo as well.
The other 3 versions are included in case that they might be interesting or relevant.
All the versions give the same results and all seem to have very similar execution times and memory consumption.

- BEC -- Basic event calculus. Shanahan's version of EC (although he made many versions).
- DBEC -- Discrete BEC. My adaptation of BEC to make it explicitly discrete, inspired by DEC (below).
- EC -- (Full) event calculus. This is Mueller's version of EC. 
- DEC -- Discrete event calculus. Mueller's discrete version of EC. Used in his DEC Reasoner.

## Note about output
I use "format-output" from http://reasoning.eas.asu.edu/ecasp/ec2asp_linux_files/page0004.htm to reformat the output of clingo.
This sorts predicates chronologically based on time and highlights fluents which changed their value between timesteps.
NOTE that this introduces a time overhead (seems to be most significant for the "EC" version of the axioms).
But the execution time measured in the logs only includes clingo and not the formatter.