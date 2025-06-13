TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

AXIOMS=../axioms/bec_clingo.pl
#AXIOMS=../axioms/dbec_clingo.pl
#AXIOMS=../axioms/dec_clingo.pl
#AXIOMS=../axioms/ec_clingo.pl

#-----------------------------------------------------------------------------------------------------------------------
# base

CMD=clingo -c maxtime=$$MAXTIME -c maxmoney=$$MAXMONEY -n 0 ${AXIOMS} ./model.pl
run:
	MAXTIME=10; MAXMONEY=20; ${TIME} ${CMD} 2> .tmp987654321.tmp | ../utils/format-output/format-output-rework 2; cat .tmp987654321.tmp 1>&2; rm -f .tmp987654321.tmp


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MAXTIME=10;  MAXMONEY=20;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME-m$$MAXMONEY.log ; exit 0
	MAXTIME=20;  MAXMONEY=20;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME-m$$MAXMONEY.log ; exit 0
	MAXTIME=40;  MAXMONEY=20;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME-m$$MAXMONEY.log ; exit 0
	MAXTIME=80;  MAXMONEY=20;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME-m$$MAXMONEY.log ; exit 0
	MAXTIME=160; MAXMONEY=20;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME-m$$MAXMONEY.log ; exit 0
	MAXTIME=320; MAXMONEY=20;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework 1" ./logs/t$$MAXTIME-m$$MAXMONEY.log ; exit 0
