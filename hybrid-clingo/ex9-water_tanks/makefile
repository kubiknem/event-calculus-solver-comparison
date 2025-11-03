TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=clingo-lpx --strict -n0 ../axioms/dbec_steps-clingo_lpx.lp -c maxstep=$$MAXSTEP
LPX_CMD_M=clingo-lpx --strict -n0 ../axioms/dbec_steps-clingo_lpx-merged.lp -c maxstep=$$MAXSTEP

run-lpx:
	MAXSTEP=6; ${TIME} ${LPX_CMD} ./model.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

# TODO this is very powerful -- can do 50 events in under 5 seconds
run-lpx-50:
	MAXSTEP=50; ${TIME} ${LPX_CMD} ./model.lp


run-lpx-merged:
	MAXSTEP=6; ${TIME} ${LPX_CMD_M} ./model-merged.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

# TODO this is very powerful -- can do 50 events in under 5 seconds
run-lpx-50-merged:
	MAXSTEP=50; ${TIME} ${LPX_CMD_M} ./model-merged.lp


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)

run-lpx-fixed:
	MAXSTEP=10; ${TIME} ${LPX_CMD} ./model-fixed.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-fixed2:
	MAXSTEP=13; ${TIME} ${LPX_CMD} ./model-fixed2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh


run-lpx-fixed-merged:
	MAXSTEP=10; ${TIME} ${LPX_CMD_M} ./model-fixed-merged.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-fixed2-merged:
	MAXSTEP=13; ${TIME} ${LPX_CMD_M} ./model-fixed2-merged.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

# TODO how to check scaling? (maybe number of events --> steps?)
log:
	MODEL=model; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
	MODEL=model; MAXSTEP=50;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0

	MODEL=model-fixed; MAXSTEP=10;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
	MODEL=model-fixed2; MAXSTEP=13;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
	

	MODEL=model-merged; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD_M} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-merged-$$MODEL-s$$MAXSTEP.log ; exit 0
	MODEL=model-merged; MAXSTEP=50;  ../../scripts/maketrace.sh "${LPX_CMD_M} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-merged-$$MODEL-s$$MAXSTEP.log ; exit 0

	MODEL=model-fixed-merged; MAXSTEP=10;  ../../scripts/maketrace.sh "${LPX_CMD_M} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-merged-$$MODEL-s$$MAXSTEP.log ; exit 0
	MODEL=model-fixed2-merged; MAXSTEP=13;  ../../scripts/maketrace.sh "${LPX_CMD_M} ./$$MODEL.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-merged-$$MODEL-s$$MAXSTEP.log ; exit 0

