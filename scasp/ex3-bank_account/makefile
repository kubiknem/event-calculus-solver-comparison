TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# base

# non-terminating due to zeno-like behavior --> there fundamentally is no solution in continuous time
CMD=echo \"max_time($$MAXTIME).\" > ./maxtime.tmp ; scasp -s0 --ec ../axioms/bec_scasp.pl ./model.pl ./maxtime.tmp --timeout=3000
run-non_term:
	MAXTIME=10; ${TIME} ${CMD}
	@rm -f ./maxtime*.tmp


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)

# fixed by remodeling to a immediate reaction (instead of infinitely fast)
CMD_FIXIMMEDIATE=echo \"max_time($$MAXTIME).\" > ./maxtime.tmp ; scasp -s0 --ec ../axioms/bec_scasp.pl ./fix-immediate.pl ./maxtime.tmp ../utils/cache.pl
run-fixed_immediate:
	MAXTIME=10; ${TIME} ${CMD_FIXIMMEDIATE}
	@rm -f ./maxtime*.tmp
	
# fixed by inserting an epsilon (reaction with a delay instead of infinitely fast)
CMD_FIXEPSILON=echo \"max_time($$MAXTIME).\" > ./maxtime.tmp ; scasp -s0 --ec -r ../axioms/bec_scasp.pl ./fix-epsilon.pl ./maxtime.tmp ../utils/cache.pl
run-fixed_epsilon:
	MAXTIME=10; ${TIME} ${CMD_FIXEPSILON}
	@rm -f ./maxtime*.tmp


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MAXTIME=10;  ../../scripts/maketrace.sh "${CMD} --timeout=3000" ./logs/t$$MAXTIME.log
	
	MAXTIME=10;  ../../scripts/maketrace.sh "${CMD_FIXIMMEDIATE}" ./logs/fix_immediate-t$$MAXTIME.log
	MAXTIME=20;  ../../scripts/maketrace.sh "${CMD_FIXIMMEDIATE}" ./logs/fix_immediate-t$$MAXTIME.log
	MAXTIME=40;  ../../scripts/maketrace.sh "${CMD_FIXIMMEDIATE}" ./logs/fix_immediate-t$$MAXTIME.log
	MAXTIME=80;  ../../scripts/maketrace.sh "${CMD_FIXIMMEDIATE}" ./logs/fix_immediate-t$$MAXTIME.log
	MAXTIME=160; ../../scripts/maketrace.sh "${CMD_FIXIMMEDIATE}" ./logs/fix_immediate-t$$MAXTIME.log
	MAXTIME=320; ../../scripts/maketrace.sh "${CMD_FIXIMMEDIATE}" ./logs/fix_immediate-t$$MAXTIME.log

	MAXTIME=10;  ../../scripts/maketrace.sh "${CMD_FIXEPSILON}" ./logs/fix_epsilon-t$$MAXTIME.log
	MAXTIME=20;  ../../scripts/maketrace.sh "${CMD_FIXEPSILON}" ./logs/fix_epsilon-t$$MAXTIME.log
	MAXTIME=40;  ../../scripts/maketrace.sh "${CMD_FIXEPSILON}" ./logs/fix_epsilon-t$$MAXTIME.log
	MAXTIME=80;  ../../scripts/maketrace.sh "${CMD_FIXEPSILON}" ./logs/fix_epsilon-t$$MAXTIME.log
	MAXTIME=160; ../../scripts/maketrace.sh "${CMD_FIXEPSILON}" ./logs/fix_epsilon-t$$MAXTIME.log
	MAXTIME=320; ../../scripts/maketrace.sh "${CMD_FIXEPSILON}" ./logs/fix_epsilon-t$$MAXTIME.log

	@rm -f ./maxtime*.tmp