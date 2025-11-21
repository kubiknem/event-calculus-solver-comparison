TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=clingo-lpx --strict -n0 ../axioms/fdec.lp -c maxstep=$$MAXSTEP -c maxtime=$$MAXTIME
LPX_CMD_FH=clingo-lpx --strict -n0 ../axioms/fdec-ffholds.lp -c maxstep=$$MAXSTEP -c maxtime=$$MAXTIME

run-lpx:
	MAXSTEP=7; MAXTIME=1000; ${TIME} ${LPX_CMD} ./model.lp ./narrative1.lp  | ../utils/replace_assignments.sh | ../utils/make-readable.sh

# takes around 50sec, need to disable last step because zeno behavior never exceeds the zeno timepoint
run-lpx-nocatch:
	MAXSTEP=50; MAXTIME=1000; ${TIME} ${LPX_CMD} ./model.lp ./narrative2.lp -c disablelaststep=1 | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-fh:
	MAXSTEP=7; MAXTIME=1000; ${TIME} ${LPX_CMD_FH} ./model.lp ./narrative1.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# fixed zeno

run-lpx-fix-flat_loss:
	MAXSTEP=7; MAXTIME=1000; ${TIME} ${LPX_CMD} ./fix-flat_loss.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh
	
run-lpx-fix-min_dur:
	MAXSTEP=7; MAXTIME=1000; ${TIME} ${LPX_CMD} ./fix-min_dur.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh
	

run-lpx-fix-flat_loss-fh:
	MAXSTEP=7; MAXTIME=1000; ${TIME} ${LPX_CMD_FH} ./fix-flat_loss.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh
	
run-lpx-fix-min_dur-fh:
	MAXSTEP=7; MAXTIME=1000; ${TIME} ${LPX_CMD_FH} ./fix-min_dur.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# other versions
LPX_CMD_DBEC=clingo-lpx --strict -n0 ../axioms/dbec-clingo_lpx-choice.lp -c maxstep=$$MAXSTEP
LPX_CMD_EFF=clingo-lpx --strict -n0 ../axioms/clingo_lpx-efficient.lp -c maxstep=$$MAXSTEP

run-lpx-dbec:
	MAXSTEP=6; ${TIME} ${LPX_CMD_DBEC} ./model-dbec.lp ./narrative1-dbec.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh
run-lpx-fix-flat_loss-dbec:
	MAXSTEP=6; ${TIME} ${LPX_CMD_DBEC} ./fix-flat_loss-dbec.lp ./narrative2-dbec.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh
run-lpx-fix-min_dur-dbec:
	MAXSTEP=6; ${TIME} ${LPX_CMD_DBEC} ./fix-min_dur-dbec.lp ./narrative2-dbec.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh

#TODO#run-lpx-eff:
#TODO#	MAXSTEP=6; ${TIME} ${LPX_CMD_EFF} ./model-efficient.lp ./narrative1.lp | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MODEL=model; 			NAME=;		MAXSTEP=7;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative1.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL$$NAME-s$$MAXSTEP.log ; exit 0
	MODEL=model; 			NAME=;		MAXSTEP=50;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative2.lp -c disablelaststep=1 | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL$$NAME-s$$MAXSTEP.log ; exit 0
	MODEL=fix-flat_loss; 	NAME=;		MAXSTEP=7;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL$$NAME-s$$MAXSTEP.log ; exit 0
	MODEL=fix-min_dur; 	 	NAME=;		MAXSTEP=7;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL$$NAME-s$$MAXSTEP.log ; exit 0

	MODEL=model; 			NAME=-fh;	MAXSTEP=7;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD_FH} ./$$MODEL.lp ./narrative1.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL$$NAME-s$$MAXSTEP.log ; exit 0
	MODEL=model; 			NAME=-fh;	MAXSTEP=50;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD_FH} ./$$MODEL.lp ./narrative2.lp -c disablelaststep=1 | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL$$NAME-s$$MAXSTEP.log ; exit 0
	MODEL=fix-flat_loss; 	NAME=-fh;	MAXSTEP=7;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD_FH} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL$$NAME-s$$MAXSTEP.log ; exit 0
	MODEL=fix-min_dur; 	 	NAME=-fh;	MAXSTEP=7;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD_FH} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL$$NAME-s$$MAXSTEP.log ; exit 0

	MODEL=model; 			NAME=-dbec;	MAXSTEP=6;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD_DBEC} ./$$MODEL$$NAME.lp ./narrative1$$NAME.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL$$NAME-s$$MAXSTEP.log ; exit 0
	MODEL=model; 			NAME=-dbec;	MAXSTEP=50;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD_DBEC} ./$$MODEL$$NAME.lp ./narrative2$$NAME.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL$$NAME-s$$MAXSTEP.log ; exit 0
	MODEL=fix-flat_loss; 	NAME=-dbec;	MAXSTEP=6;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD_DBEC} ./$$MODEL$$NAME.lp ./narrative2$$NAME.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL$$NAME-s$$MAXSTEP.log ; exit 0
	MODEL=fix-min_dur; 	 	NAME=-dbec;	MAXSTEP=6;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD_DBEC} ./$$MODEL$$NAME.lp ./narrative2$$NAME.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL$$NAME-s$$MAXSTEP.log ; exit 0

#TODO#	MODEL=model-efficient; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD_EFF} ./$$MODEL.lp ./narrative1.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
#TODO#	MODEL=model-efficient; MAXSTEP=50; ../../scripts/maketrace.sh "${LPX_CMD_EFF} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
#TODO#
#TODO#	MODEL=fix-flat_loss-efficient; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD_EFF} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
#TODO#	MODEL=fix-min_dur-efficient; MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD_EFF} ./$$MODEL.lp ./narrative2.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-$$MODEL-s$$MAXSTEP.log ; exit 0
