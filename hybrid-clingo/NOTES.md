
## Extension for clingcon

* Added `bec_steps-clingcon.lp` in axioms
* Added for each `exi` one file `model-con.lp`

Clingcon commands:
* `clingcon       ex1-light_on_off/model.lp axioms/bec_steps-clingcon.lp -c maxstep=2`
* `clingcon ex2-bank_account_nofee/model-con.lp axioms/bec_steps-clingcon.lp -c maxstep=2`
* `clingcon     ex3-falling_object/model-con.lp axioms/bec_steps-clingcon.lp -c maxstep=2`
* `clingcon       ex4-bank_account/model-con.lp axioms/bec_steps-clingcon.lp -c maxstep=6` 

The encodings assume that the initial situation is complete. 

Note that we need to fix the number of steps using constant `maxstep`.

## Extension for clingo-lpx

Maybe, in the future, the encodings for clingcon will work for clingo-lpx right away. 
But as of today (with clingo-lpx-1.3.0) the syntax of clingo-lpx is more restricted than the one of clingcon:
* theory atoms can only occur in the head
* operator `!=` is not allowed

To handle this restricted syntax, I 
* created a new `bec_steps-clingo_lpx.lp` in axioms, and
* added for each exi (except ex1) one file `model-lpx.lp`

These new files are derived from the original clingcon files:
* the theory atoms in the body are replaced by new normal atoms, and
* additional rules are introduced to map the new normal atoms to the original theory atoms.

Additionally, to make use of rational numbers, 
in `ex4-bank_account/model-lpx.lp`, 
I replaced the fact `epsilon(1).` by `epsilon("1.1").`. 

Clingo-lpx commands:
* `clingo-lpx --strict           ex1-light_on_off/model.lp axioms/bec_steps-clingo_lpx.lp -c maxstep=2` 
* `clingo-lpx --strict ex2-bank_account_nofee/model-lpx.lp axioms/bec_steps-clingo_lpx.lp -c maxstep=2`
* `clingo-lpx --strict     ex3-falling_object/model-lpx.lp axioms/bec_steps-clingo_lpx.lp -c maxstep=2`    
* `clingo-lpx --strict       ex4-bank_account/model-lpx.lp axioms/bec_steps-clingo_lpx.lp -c maxstep=6`

We can also run the clingo-lpx encodings with clingcon. 
Just replace `clingo-lpx --strict` by `clingcon` in the clingo-lpx commands. 

The only issue occurs at the fact `epsilon("1.1").` in `ex4-bank_account/model-lpx.lp`, 
since in clingo-lpx this introduces the number "1.1".
In clingcon, this "1.1" is interpreted as the name of an integer variable.
Hence, its meaning is different than in clingo-lpx.
For example, if we replace "1.1" by "aeiou",
nothing else changes for clingcon 
(the answer sets are the same, except that variable "1.1" is now called "aeiou")
while in clingo-lpx this leads to different answer sets,
since instead of the number `1.1` we have a new variable "aeiou".


## Notes on installing clingcon and clingo-lpx
- clingcon installed using `apt install clingcon` from potassco ppa (added using `add-apt-repository ppa:potassco/stable`)
- clingo-lpx installed using `conda create -n clingo-lpx python=3.8 potassco/label/dev::clingo-lpx`
  - version from ppa did not work for me
- alternatively feel free to use provided `hybrid-clingo/makefile`
  - run `make create-env-lpx` to setup clingo-lpx environment using conda
