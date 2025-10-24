TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=clingo-lpx --strict -n0 ../axioms/bec_steps-clingo_lpx.lp -c maxstep=$$MAXSTEP
LPX_CMD_M=clingo-lpx --strict -n0 ../axioms/bec_steps-clingo_lpx-merged.lp -c maxstep=$$MAXSTEP

run-lpx:
	MAXSTEP=6; ${TIME} ${LPX_CMD} ./model.lp ./narrative1.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

# TODO this is very powerful -- can do 50 events in under 5 seconds
run-lpx-nocatch:
	MAXSTEP=50; ${TIME} ${LPX_CMD} ./model.lp ./narrative2.lp

	
run-lpx-merged:
	MAXSTEP=6; ${TIME} ${LPX_CMD_M} ./model-merged.lp ./narrative1.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-nocatch-merged:
	MAXSTEP=50; ${TIME} ${LPX_CMD_M} ./model-merged.lp ./narrative2.lp



#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)

run-lpx-fix-flat_loss:
	MAXSTEP=6; ${TIME} ${LPX_CMD} ./fix-flat_loss.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh
	
run-lpx-fix-min_dur:
	MAXSTEP=6; ${TIME} ${LPX_CMD} ./fix-min_dur.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh
	

run-lpx-fix-flat_loss-merged:
	MAXSTEP=6; ${TIME} ${LPX_CMD_M} ./fix-flat_loss-merged.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh
	
run-lpx-fix-min_dur-merged:
	MAXSTEP=6; ${TIME} ${LPX_CMD_M} ./fix-min_dur-merged.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

# TODO how to check scaling? (maybe number of events --> steps?)
log:
	MODEL=model; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative1.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
	MODEL=model; MAXSTEP=50; ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0

	MODEL=fix-flat_loss; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
	MODEL=fix-min_dur; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0


	MODEL=model-merged; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD_M} ./$$MODEL.lp ./narrative1.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
	MODEL=model-merged; MAXSTEP=50; ../../scripts/maketrace.sh "${LPX_CMD_M} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0

	MODEL=fix-flat_loss-merged; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD_M} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
	MODEL=fix-min_dur-merged; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD_M} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
