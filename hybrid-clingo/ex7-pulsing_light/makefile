TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=clingo-lpx --strict -n0 ./model.lp ../axioms/fdec.lp -c maxstep=$$MAXSTEP -c maxtime=$$MAXTIME
LPX_CMD_FH=clingo-lpx --strict -n0 ./model.lp ../axioms/fdec-ffholds.lp -c maxstep=$$MAXSTEP -c maxtime=$$MAXTIME

run-lpx:
	MAXSTEP=6; MAXTIME=1000; ${TIME} ${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-fh:
	MAXSTEP=6; MAXTIME=1000; ${TIME} ${LPX_CMD_FH} | ../utils/replace_assignments.sh | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# other versions
LPX_CMD_DBEC=clingo-lpx --strict -n0 ./model-dbec.lp ../axioms/dbec-clingo_lpx-choice.lp -c maxstep=$$MAXSTEP
LPX_CMD_EFF=clingo-lpx --strict -n0 ./model-efficient.lp ../axioms/clingo_lpx-efficient.lp -c maxstep=$$MAXSTEP

run-lpx-dbec:
	MAXSTEP=5; ${TIME} ${LPX_CMD_DBEC} | ../utils/replace_assignments.sh | ../utils/make-readable.sh

#TODO#run-lpx-eff:
#TODO#	MAXSTEP=5; ${TIME} ${LPX_CMD_EFF} | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	NAME=; 		MAXSTEP=6;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD} 		| ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP.log ; exit 0
	NAME=-fh; 	MAXSTEP=6;	MAXTIME=1000;	../../scripts/maketrace.sh "${LPX_CMD_FH} 	| ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP.log ; exit 0

	NAME=-dbec; MAXSTEP=5;	../../scripts/maketrace.sh "${LPX_CMD_DBEC} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP.log ; exit 0
#TODO#	NAME=-eff; 	MAXSTEP=5;	../../scripts/maketrace.sh "${LPX_CMD_EFF} 	| ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP.log ; exit 0
