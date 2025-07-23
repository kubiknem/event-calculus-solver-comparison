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

## Extension for clingcon

* Added `hybrid_clingo.lp` in axioms
* Added for each `exi` one file `hybrid_model.lp`

Clingcon commands:
* `clingcon       ex1-light_on_off/hybrid_model.lp axioms/hybrid_clingo.lp -c maxstep=2`
* `clingcon ex2-bank_account_nofee/hybrid_model.lp axioms/hybrid_clingo.lp -c maxstep=2`
* `clingcon     ex3-falling_object/hybrid_model.lp axioms/hybrid_clingo.lp -c maxstep=2`
* `clingcon       ex4-bank_account/hybrid_model.lp axioms/hybrid_clingo.lp -c maxstep=6` 

The encodings assume that the initial situation is complete. 

Note that we need to fix the number of steps using constant `maxstep`.

## Extension for clingo-lpx

Maybe, in the future, the encodings for clingcon will work for clingo-lpx right away. 
But as of today (with clingo-lpx-1.3.0) the syntax of clingo-lpx is more restricted than the one of clingcon:
* theory atoms can only occur in the head
* operator `!=` is not allowed

To handle this restricted syntax, I 
* created a new `hybrid_clingo_lpx.lp` in axioms, and
* added for each exi (except ex1) one file `hybrid_model_lpx.lp`

These new files are derived from the original clingcon files:
* the theory atoms in the body are replaced by new normal atoms, and
* additional rules are introduced to map the new normal atoms to the original theory atoms.

Additional, to make use of rational numbers, 
in `ex4-bank_account/hybrid_model_lpx.lp`, 
I replaced the fact `epsilon(1).` by `epsilon("1.1").`. 

Clingo-lpx commands:
* `clingo-lpx --strict           ex1-light_on_off/hybrid_model.lp axioms/hybrid_clingo_lpx.lp -c maxstep=2` 
* `clingo-lpx --strict ex2-bank_account_nofee/hybrid_model_lpx.lp axioms/hybrid_clingo_lpx.lp -c maxstep=2`
* `clingo-lpx --strict     ex3-falling_object/hybrid_model_lpx.lp axioms/hybrid_clingo_lpx.lp -c maxstep=2`    
* `clingo-lpx --strict       ex4-bank_account/hybrid_model_lpx.lp axioms/hybrid_clingo_lpx.lp -c maxstep=6`

We can also run the clingo-lpx encodings with clingcon. 
Just replace `clingo-lpx --strict` by `clingcon` in the clingo-lpx commands. 

The only issue occurs at the fact `epsilon("1.1").` in `ex4-bank_account/hybrid_model_lpx.lp`, 
since in clingo-lpx this introduces the number "1.1".
In clingcon, this "1.1" is interpreted as the name of an integer variable.
Hence, its meaning is different than in clingo-lpx.
For example, if we replace "1.1" by "aeiou",
nothing else changes for clingcon 
(the answer sets are the same, except that variable "1.1" is now called "aeiou")
while in clingo-lpx this leads to different answer sets,
since instead of the number `1.1` we have a new variable "aeiou".


