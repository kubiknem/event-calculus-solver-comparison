TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=clingo-lpx --strict -n0 ./model.lp ../axioms/dbec-clingo_lpx-choice.lp -c maxstep=$$MAXSTEP -c paramHeight=$$HEIGHT
LPX_CMD_EFF=clingo-lpx --strict -n0 ./model-efficient.lp ../axioms/clingo_lpx-efficient.lp -c maxstep=$$MAXSTEP -c paramHeight=$$HEIGHT

run-lpx:
	MAXSTEP=2; HEIGHT=20; ${TIME} ${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-eff:
	MAXSTEP=2; HEIGHT=20; ${TIME} ${LPX_CMD_EFF} | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	MAXSTEP=2; HEIGHT=20;	../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	MAXSTEP=2; HEIGHT=40;	../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	MAXSTEP=2; HEIGHT=80;	../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	MAXSTEP=2; HEIGHT=160;  ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	MAXSTEP=2; HEIGHT=320;  ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	MAXSTEP=2; HEIGHT=4;    ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-miss_ground-ok-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	MAXSTEP=2; HEIGHT=3;    ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-miss_ground-miss-s$$MAXSTEP-h$$HEIGHT.log ; exit 0

	MAXSTEP=2; HEIGHT=20;	../../scripts/maketrace.sh "${LPX_CMD_EFF} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-efficient-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
