TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=clingo-lpx --strict -n0 ../axioms/dbec-clingo_lpx-choice.lp -c maxstep=$$MAXSTEP
#TODO# LPX_CMD_EFF=clingo-lpx --strict -n0 ../axioms/clingo_lpx-efficient.lp -c maxstep=$$MAXSTEP

run-lpx-effect:
	MAXSTEP=5; ${TIME} ${LPX_CMD} ./model-effect_constr.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-state:
	MAXSTEP=5; ${TIME} ${LPX_CMD} ./model-state_constr.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-state-cont:
	MAXSTEP=9; ${TIME} ${LPX_CMD} ./model-state_constr-continuous.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MODEL=model-effect_constr; MAXSTEP=5;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
	MODEL=model-state_constr; MAXSTEP=5;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
	MODEL=model-state_constr-continuous; MAXSTEP=9;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
