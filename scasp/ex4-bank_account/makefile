TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# base

SETUP=echo "max_time($$MAXTIME)." > ./.maxtime.tmp

# non-terminating due to zeno-like behavior --> there fundamentally is no solution in continuous time
CMD=oscasp -s0 --ec ../axioms/bec_scasp.pl ./model.pl ./.maxtime.tmp --zeno_halt # --tree
run-non_term:
	MAXTIME=80; ${SETUP}; ${TIME} ${CMD}
	@rm -f ./.maxtime*.tmp


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)

# fixed by remodeling to a immediate reaction (instead of infinitely fast)
CMD_FIXIMMEDIATE=oscasp -s0 --ec ../axioms/bec_scasp.pl ./fix-immediate.pl ./.maxtime.tmp ../utils/cache.pl # --tree
run-fixed_immediate:
	MAXTIME=80; ${SETUP}; ${TIME} ${CMD_FIXIMMEDIATE}
	@rm -f ./.maxtime*.tmp
	
# fixed by inserting an epsilon (reaction with a delay instead of infinitely fast)
CMD_FIXEPSILON=oscasp -s0 --ec -r ../axioms/bec_scasp.pl ./fix-epsilon.pl ./.maxtime.tmp ../utils/cache.pl # --tree
run-fixed_epsilon:
	MAXTIME=80; ${SETUP}; ${TIME} ${CMD_FIXEPSILON}
	@rm -f ./.maxtime*.tmp


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MAXTIME=80;  ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	
	MAXTIME=80;  ${SETUP}; ../../scripts/maketrace.sh "${CMD_FIXIMMEDIATE}" ./logs/fix_immediate-t$$MAXTIME.log
	MAXTIME=160; ${SETUP}; ../../scripts/maketrace.sh "${CMD_FIXIMMEDIATE}" ./logs/fix_immediate-t$$MAXTIME.log
	MAXTIME=320; ${SETUP}; ../../scripts/maketrace.sh "${CMD_FIXIMMEDIATE}" ./logs/fix_immediate-t$$MAXTIME.log

	MAXTIME=80;  ${SETUP}; ../../scripts/maketrace.sh "${CMD_FIXEPSILON}" ./logs/fix_epsilon-t$$MAXTIME.log
	MAXTIME=160; ${SETUP}; ../../scripts/maketrace.sh "${CMD_FIXEPSILON}" ./logs/fix_epsilon-t$$MAXTIME.log
	MAXTIME=320; ${SETUP}; ../../scripts/maketrace.sh "${CMD_FIXEPSILON}" ./logs/fix_epsilon-t$$MAXTIME.log

	@rm -f ./.maxtime.tmp