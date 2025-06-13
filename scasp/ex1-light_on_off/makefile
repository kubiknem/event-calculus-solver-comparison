TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

#-----------------------------------------------------------------------------------------------------------------------
# base

SETUP=echo "max_time($$MAXTIME)." > ./.maxtime.tmp
CMD=scasp -s0 --ec ../axioms/bec_scasp.pl ./model.pl ./.maxtime.tmp #../utils/cache.pl
run:
	MAXTIME=30; ${SETUP}; ${TIME} ${CMD}
	@rm -f ./.maxtime*.tmp


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MAXTIME=30;   ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=60;   ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=120;  ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=240;  ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=480;  ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=1000; ${SETUP}; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	@rm -f ./.maxtime.tmp
