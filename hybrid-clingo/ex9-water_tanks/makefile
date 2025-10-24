TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=clingo-lpx --strict -n0 ./model.lp ../axioms/bec_steps-clingo_lpx.lp -c maxstep=$$MAXSTEP

run-lpx:
	MAXSTEP=6; ${TIME} ${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh

# TODO this is very powerful -- can do 50 events in under 5 seconds
run-lpx-50:
	MAXSTEP=50; ${TIME} ${LPX_CMD}


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

# TODO how to check scaling? (maybe number of events --> steps?)
log:
	MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP.log ; exit 0
	MAXSTEP=50;  ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP.log ; exit 0
