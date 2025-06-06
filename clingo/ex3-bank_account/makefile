TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K" sh -c

#-----------------------------------------------------------------------------------------------------------------------
# base

CMD=clingo -c maxtime=$$MAXTIME -c maxmoney=$$MAXMONEY -n 0 ../axioms/bec_clingo.pl ./model.pl
run:
	MAXTIME=10; MAXMONEY=20; ${TIME} "${CMD} | ../utils/format-output/format-output-rework | ../utils/changes_only.sh"


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MAXTIME=10;  MAXMONEY=20;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework | ../utils/remove_grounding.sh" ./logs/t$$MAXTIME-m$$MAXMONEY.log ; exit 0
	MAXTIME=20;  MAXMONEY=20;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework | ../utils/remove_grounding.sh" ./logs/t$$MAXTIME-m$$MAXMONEY.log ; exit 0
	MAXTIME=40;  MAXMONEY=20;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework | ../utils/remove_grounding.sh" ./logs/t$$MAXTIME-m$$MAXMONEY.log ; exit 0
	MAXTIME=80;  MAXMONEY=20;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework | ../utils/remove_grounding.sh" ./logs/t$$MAXTIME-m$$MAXMONEY.log ; exit 0
	MAXTIME=160; MAXMONEY=20;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework | ../utils/remove_grounding.sh" ./logs/t$$MAXTIME-m$$MAXMONEY.log ; exit 0
	MAXTIME=320; MAXMONEY=20;  ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework | ../utils/remove_grounding.sh" ./logs/t$$MAXTIME-m$$MAXMONEY.log ; exit 0
