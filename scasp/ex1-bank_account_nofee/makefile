TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K" sh -c

#-----------------------------------------------------------------------------------------------------------------------
# base

CMD=echo \"max_time($$MAXTIME).\" > ./maxtime.tmp ; scasp -s0 --ec ../axioms/bec_scasp.pl ./model.pl ./maxtime.tmp ../utils/cache.pl
run:
	MAXTIME=10; ${TIME} "${CMD}"
	@rm -f ./maxtime*.tmp


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MAXTIME=10;  ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=20;  ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=40;  ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=80;  ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=160; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=320; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	MAXTIME=640; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log
	@rm -f ./maxtime*.tmp
