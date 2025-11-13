TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=clingo-lpx --strict -n0 ../axioms/dbec-clingo_lpx-choice.lp -c maxstep=$$MAXSTEP
LPX_CMD_EFF=clingo-lpx --strict -n0 ../axioms/clingo_lpx-efficient.lp -c maxstep=$$MAXSTEP


run-lpx:
	MAXSTEP=6; ${TIME} ${LPX_CMD} ./model.lp ./narrative1.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

# TODO this is very powerful -- can do 50 events in under 5 seconds
run-lpx-nocatch:
	MAXSTEP=50; ${TIME} ${LPX_CMD} ./model.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh


run-lpx-eff:
	MAXSTEP=6; ${TIME} ${LPX_CMD_EFF} ./model-efficient.lp ./narrative1.lp | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)

run-lpx-fix-flat_loss:
	MAXSTEP=6; ${TIME} ${LPX_CMD} ./fix-flat_loss.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh
	
run-lpx-fix-min_dur:
	MAXSTEP=6; ${TIME} ${LPX_CMD} ./fix-min_dur.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh
	

run-lpx-fix-flat_loss-eff:
	MAXSTEP=6; ${TIME} ${LPX_CMD_EFF} ./fix-flat_loss-efficient.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh
	
run-lpx-fix-min_dur-eff:
	MAXSTEP=6; ${TIME} ${LPX_CMD_EFF} ./fix-min_dur-efficient.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MODEL=model; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative1.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
	MODEL=model; MAXSTEP=50; ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0

	MODEL=fix-flat_loss; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
	MODEL=fix-min_dur; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0


#TODO#	MODEL=model-efficient; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD_EFF} ./$$MODEL.lp ./narrative1.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
#TODO#	MODEL=model-efficient; MAXSTEP=50; ../../scripts/maketrace.sh "${LPX_CMD_EFF} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
#TODO#
#TODO#	MODEL=fix-flat_loss-efficient; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD_EFF} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
#TODO#	MODEL=fix-min_dur-efficient; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD_EFF} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
