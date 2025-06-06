TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K" sh -c

#-----------------------------------------------------------------------------------------------------------------------
# base

CMD=clingo -c maxtime=$$MAXTIME -c paramHeight=$$HEIGHT -n 0 ../axioms/bec_clingo.pl ./model.pl
run:
	MAXTIME=10; HEIGHT=20; ${TIME} "${CMD} | ../utils/format-output/format-output-rework | ../utils/changes_only.sh"


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MAXTIME=15;  HEIGHT=20;	 ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework | ../utils/remove_grounding.sh" ./logs/t$$MAXTIME-h$$HEIGHT.log ; exit 0
	MAXTIME=25;  HEIGHT=40;	 ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework | ../utils/remove_grounding.sh" ./logs/t$$MAXTIME-h$$HEIGHT.log ; exit 0
	MAXTIME=45;  HEIGHT=80;	 ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework | ../utils/remove_grounding.sh" ./logs/t$$MAXTIME-h$$HEIGHT.log ; exit 0
	MAXTIME=85;  HEIGHT=160; ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework | ../utils/remove_grounding.sh" ./logs/t$$MAXTIME-h$$HEIGHT.log ; exit 0
	MAXTIME=165; HEIGHT=320; ../../scripts/maketrace.sh "${CMD} | ../utils/format-output/format-output-rework | ../utils/remove_grounding.sh" ./logs/t$$MAXTIME-h$$HEIGHT.log ; exit 0