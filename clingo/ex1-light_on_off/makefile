TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

AXIOMS=../axioms/bec_clingo.pl
#AXIOMS=../axioms/dbec_clingo.pl
#AXIOMS=../axioms/dec_clingo.pl
#AXIOMS=../axioms/ec_clingo.pl

#-----------------------------------------------------------------------------------------------------------------------
# base

CMD=clingo -c maxtime=$$MAXTIME -n 0 ${AXIOMS} ./model.pl
run:
	MAXTIME=30; ${TIME} ${CMD} 2> .tmp987654321.tmp | ../utils/format-output/format-output-rework 1; cat .tmp987654321.tmp 1>&2; rm -f .tmp987654321.tmp


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MAXTIME=30;   ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME.log ; exit 0
	MAXTIME=60;   ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME.log ; exit 0
	MAXTIME=120;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME.log ; exit 0
	MAXTIME=240;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME.log ; exit 0
	MAXTIME=480;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME.log ; exit 0
	MAXTIME=1000; ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME.log ; exit 0
