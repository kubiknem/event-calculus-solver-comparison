TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
CON_CMD=clingcon -n0 ./model-con.lp ../axioms/bec_steps-clingcon.lp -c maxstep=$$MAXSTEP
LPX_CMD=clingo-lpx --strict -n0 ./model-lpx.lp ../axioms/bec_steps-clingo_lpx.lp -c maxstep=$$MAXSTEP
run-clingcon:
	MAXSTEP=6; ${TIME} ${CON_CMD}

run-lpx:
	MAXSTEP=6; ${TIME} ${LPX_CMD}


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

# TODO how to check scaling? (maybe number of events --> steps?)
log:
	MAXSTEP=6;  ../../scripts/maketrace.sh "${CON_CMD}" ./logs/con-s$$MAXSTEP.log ; exit 0
	
	MAXSTEP=6;  ../../scripts/maketrace.sh "${LPX_CMD}" ./logs/lpx-s$$MAXSTEP.log ; exit 0
