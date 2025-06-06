TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K" sh -c

#-----------------------------------------------------------------------------------------------------------------------
# base

CMD=echo \"max_time($$MAXTIME).\ninitHeight($$HEIGHT).\" > ./maxtime_height.tmp ; scasp -s0 --ec ../axioms/bec_scasp.pl ./model.pl ./maxtime_height.tmp ../utils/cache.pl
run:
	MAXTIME=15; HEIGHT=20; ${TIME} "${CMD}"
	@rm -f ./maxtime_height*.tmp


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MAXTIME=15;  HEIGHT=20;	 ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME-h$$HEIGHT.log
	MAXTIME=25;  HEIGHT=40;	 ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME-h$$HEIGHT.log
	MAXTIME=45;  HEIGHT=80;	 ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME-h$$HEIGHT.log
	MAXTIME=85;  HEIGHT=160; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME-h$$HEIGHT.log
	MAXTIME=165; HEIGHT=320; ../../scripts/maketrace.sh "${CMD}" ./logs/t$$MAXTIME-h$$HEIGHT.log
	@rm -f ./maxtime_height*.tmp
