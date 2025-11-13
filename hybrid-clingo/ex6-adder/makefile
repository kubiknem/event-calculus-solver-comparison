TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=clingo-lpx --strict -n0 ./model.lp ../axioms/dbec-clingo_lpx-choice.lp -c maxstep=$$MAXSTEP
LPX_CMD_EFF=clingo-lpx --strict -n0 ./model-efficient.lp ../axioms/clingo_lpx-efficient.lp -c maxstep=$$MAXSTEP

run-lpx:
	MAXSTEP=6; ${TIME} ${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-eff:
	MAXSTEP=6; ${TIME} ${LPX_CMD_EFF} | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP.log ; exit 0
#TODO#	MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD_EFF} | ../utils/make-readable.sh" ./logs/lpx-efficient-s$$MAXSTEP.log ; exit 0
