TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=clingo-lpx --strict -n0 ../axioms/dbec-clingo_lpx-choice.lp -c maxstep=$$MAXSTEP
LPX_CMD_EFF=clingo-lpx --strict -n0 ../axioms/clingo_lpx-efficient.lp -c maxstep=$$MAXSTEP

run-lpx:
	MAXSTEP=6; ${TIME} ${LPX_CMD} ./model.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

# TODO this is very powerful -- can do 50 events in under 1 seconds
run-lpx-50:
	MAXSTEP=50; ${TIME} ${LPX_CMD} ./model.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-eff:
	MAXSTEP=6; ${TIME} ${LPX_CMD_EFF} ./model.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-50-eff:
	MAXSTEP=50; ${TIME} ${LPX_CMD_EFF} ./model.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)

run-lpx-fixed:
	MAXSTEP=6; ${TIME} ${LPX_CMD} ./model-fixed.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-fixed-eff:
	MAXSTEP=6; ${TIME} ${LPX_CMD_EFF} ./model-fixed.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MODEL=model; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
	MODEL=model; MAXSTEP=50;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0

	MODEL=model-fixed; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0


#TODO#	MODEL=model-efficient; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD_EFF} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log  ; exit 0
#TODO#	MODEL=model-efficient; MAXSTEP=50;  ../../scripts/maketrace.sh "${LPX_CMD_EFF} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log  ; exit 0
#TODO#
#TODO#	MODEL=model-fixed-efficient; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD_EFF} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log  ; exit 0

