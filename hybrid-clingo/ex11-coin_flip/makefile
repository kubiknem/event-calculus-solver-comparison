TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=clingo-lpx --strict -n0 ./model.lp ../axioms/bec_steps-clingo_lpx.lp -c maxstep=$$MAXSTEP
LPX_CMD_M=clingo-lpx --strict -n0 ./model.lp ../axioms/bec_steps-clingo_lpx-merged.lp -c maxstep=$$MAXSTEP

run-lpx:
	MAXSTEP=3; ${TIME} ${LPX_CMD} | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)

run-lpx-merged:
	MAXSTEP=3; ${TIME} ${LPX_CMD_M} | ../utils/make-readable.sh



#-----------------------------------------------------------------------------------------------------------------------
# log the execution

# TODO how to check scaling? (maybe number of events --> steps?)
log:
	MAXSTEP=3;  ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP.log ; exit 0

	MAXSTEP=3;  ../../scripts/maketrace.sh "${LPX_CMD_M} | ../utils/make-readable.sh" ./logs/lpx-merged-s$$MAXSTEP.log ; exit 0
