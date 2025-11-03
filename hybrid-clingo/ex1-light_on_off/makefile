TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
CON_CMD=clingcon -n0 ./model-orig.lp ../axioms/bec_steps-clingcon.lp -c maxstep=$$MAXSTEP
LPX_CMD=clingo-lpx --strict -n0 ./model.lp ../axioms/dbec_steps-clingo_lpx.lp -c maxstep=$$MAXSTEP
LPX_CMD_M=clingo-lpx --strict -n0 ./model.lp ../axioms/dbec_steps-clingo_lpx-merged.lp -c maxstep=$$MAXSTEP
run-clingcon:
	MAXSTEP=2; ${TIME} ${CON_CMD}

run-lpx:
	MAXSTEP=2; ${TIME} ${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

# TODO how to check scaling? (maybe number of events --> steps?)
log:
#	MAXSTEP=2;  ../../scripts/maketrace.sh "${CON_CMD}" ./logs/con-s$$MAXSTEP.log ; exit 0
	
	MAXSTEP=2;  ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP.log ; exit 0
	MAXSTEP=2;  ../../scripts/maketrace.sh "${LPX_CMD_M} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-merged-s$$MAXSTEP.log ; exit 0
