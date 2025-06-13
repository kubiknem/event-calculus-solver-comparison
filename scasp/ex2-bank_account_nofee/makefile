TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# base

SETUP=echo "max_time($$MAXTIME)." > ./.maxtime.tmp
CMD=scasp -s0 --ec ../axioms/bec_scasp.pl ./model.pl ./.maxtime.tmp ../utils/cache.pl
run:
	MAXTIME=10; ${SETUP}; ${TIME} ${CMD}
	@rm -f ./.maxtime*.tmp


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MAXTIME=10;  ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=20;  ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=40;  ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=80;  ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=160; ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=320; ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=640; ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	@rm -f ./.maxtime.tmp
