TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

AXIOMS=../axioms/bec_clingo.pl
#AXIOMS=../axioms/dbec_clingo.pl
#AXIOMS=../axioms/dec_clingo.pl
#AXIOMS=../axioms/ec_clingo.pl

#-----------------------------------------------------------------------------------------------------------------------
# base

CMD=clingo -c maxtime=$$MAXTIME -c paramHeight=$$HEIGHT -n 0 ${AXIOMS} ./model.pl
run:
	MAXTIME=15; HEIGHT=20; ${TIME} ${CMD} | ../utils/format-output/format-output-rework 1 | ../utils/changes_only.sh


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)

# demonstration of "missing the ground"
run-miss_ground:
	MAXTIME=5; HEIGHT=4; ${TIME} ${CMD} | ../utils/format-output/format-output-rework 1 | ../utils/changes_only.sh		# this is fine
	MAXTIME=4; HEIGHT=3; ${TIME} ${CMD} | ../utils/format-output/format-output-rework 1 | ../utils/changes_only.sh		# this misses due to 3 not being divisible by 2

#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MAXTIME=15;  HEIGHT=20;	 ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME-h$$HEIGHT.log ; exit 0
	MAXTIME=25;  HEIGHT=40;	 ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME-h$$HEIGHT.log ; exit 0
	MAXTIME=45;  HEIGHT=80;	 ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME-h$$HEIGHT.log ; exit 0
	MAXTIME=85;  HEIGHT=160; ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME-h$$HEIGHT.log ; exit 0
	MAXTIME=165; HEIGHT=320; ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME-h$$HEIGHT.log ; exit 0
	
	MAXTIME=5;   HEIGHT=4;   ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/miss_ground-ok-t$$MAXTIME-h$$HEIGHT.log ; exit 0
	MAXTIME=4;   HEIGHT=3;   ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/miss_ground-miss-t$$MAXTIME-h$$HEIGHT.log ; exit 0