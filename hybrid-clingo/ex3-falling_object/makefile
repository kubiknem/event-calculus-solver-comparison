TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
CON_CMD=clingcon -n0 ./model-con.lp ../axioms/bec_steps-clingcon.lp -c maxstep=$$MAXSTEP -c paramHeight=$$HEIGHT
LPX_CMD=clingo-lpx --strict -n0 ./model-lpx.lp ../axioms/bec_steps-clingo_lpx.lp -c maxstep=$$MAXSTEP -c paramHeight=$$HEIGHT
run-clingcon:
	MAXSTEP=2; HEIGHT=20; ${TIME} ${CON_CMD}

run-lpx:
	MAXSTEP=2; HEIGHT=20; ${TIME} ${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

# TODO how to check scaling? (maybe number of events --> steps?)
log:
#	MAXSTEP=2; HEIGHT=20;	../../scripts/maketrace.sh "${CON_CMD}" ./logs/con-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
#	MAXSTEP=2; HEIGHT=40;	../../scripts/maketrace.sh "${CON_CMD}" ./logs/con-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
#	MAXSTEP=2; HEIGHT=80;	../../scripts/maketrace.sh "${CON_CMD}" ./logs/con-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
#	MAXSTEP=2; HEIGHT=160;  ../../scripts/maketrace.sh "${CON_CMD}" ./logs/con-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
#	MAXSTEP=2; HEIGHT=320;  ../../scripts/maketrace.sh "${CON_CMD}" ./logs/con-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
#	MAXSTEP=2; HEIGHT=4;    ../../scripts/maketrace.sh "${CON_CMD}" ./logs/con-miss_ground-ok-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
#	MAXSTEP=2; HEIGHT=3;    ../../scripts/maketrace.sh "${CON_CMD}" ./logs/con-miss_ground-miss-s$$MAXSTEP-h$$HEIGHT.log ; exit 0

	MAXSTEP=2; HEIGHT=20;	../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	MAXSTEP=2; HEIGHT=40;	../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	MAXSTEP=2; HEIGHT=80;	../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	MAXSTEP=2; HEIGHT=160;  ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	MAXSTEP=2; HEIGHT=320;  ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	MAXSTEP=2; HEIGHT=4;    ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-miss_ground-ok-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	MAXSTEP=2; HEIGHT=3;    ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx-miss_ground-miss-s$$MAXSTEP-h$$HEIGHT.log ; exit 0