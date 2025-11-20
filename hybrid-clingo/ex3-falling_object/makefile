TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=clingo-lpx --strict -n0 ./model.lp ../axioms/fdec.lp -c maxstep=$$MAXSTEP -c paramHeight=$$HEIGHT
LPX_CMD_FH=clingo-lpx --strict -n0 ./model.lp ../axioms/fdec-ffholds.lp -c maxstep=$$MAXSTEP -c paramHeight=$$HEIGHT

run-lpx:
	MAXSTEP=2; HEIGHT=20; ${TIME} ${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-fh:
	MAXSTEP=2; HEIGHT=20; ${TIME} ${LPX_CMD_FH} | ../utils/replace_assignments.sh | ../utils/make-readable.sh


run-lpx-queries:
	MAXSTEP=5; HEIGHT=20; ${TIME} ${LPX_CMD} ./extra-queries.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# other versions
LPX_CMD_DBEC=clingo-lpx --strict -n0 ./model-dbec.lp ../axioms/dbec-clingo_lpx-choice.lp -c maxstep=$$MAXSTEP -c paramHeight=$$HEIGHT
LPX_CMD_EFF=clingo-lpx --strict -n0 ./model-efficient.lp ../axioms/clingo_lpx-efficient.lp -c maxstep=$$MAXSTEP -c paramHeight=$$HEIGHT

run-lpx-dbec:
	MAXSTEP=3; HEIGHT=20; ${TIME} ${LPX_CMD_DBEC} | ../utils/replace_assignments.sh | ../utils/make-readable.sh

run-lpx-eff:
	MAXSTEP=2; HEIGHT=20; ${TIME} ${LPX_CMD_EFF} | ../utils/make-readable.sh


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	NAME=; 		MAXSTEP=2;	HEIGHT=20;	../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	NAME=; 		MAXSTEP=2;	HEIGHT=40;	../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	NAME=; 		MAXSTEP=2;	HEIGHT=80;	../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	NAME=; 		MAXSTEP=2;	HEIGHT=160; ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	NAME=; 		MAXSTEP=2;	HEIGHT=320; ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	NAME=-hit; 	MAXSTEP=2; 	HEIGHT=4;   ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	NAME=-miss;	MAXSTEP=2; 	HEIGHT=3;   ../../scripts/maketrace.sh "${LPX_CMD} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	
	NAME=-fh; 		MAXSTEP=2;	HEIGHT=20;	../../scripts/maketrace.sh "${LPX_CMD_FH} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	NAME=-fh; 		MAXSTEP=2;	HEIGHT=40;	../../scripts/maketrace.sh "${LPX_CMD_FH} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	NAME=-fh; 		MAXSTEP=2;	HEIGHT=80;	../../scripts/maketrace.sh "${LPX_CMD_FH} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	NAME=-fh; 		MAXSTEP=2;	HEIGHT=160; ../../scripts/maketrace.sh "${LPX_CMD_FH} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	NAME=-fh; 		MAXSTEP=2;	HEIGHT=320; ../../scripts/maketrace.sh "${LPX_CMD_FH} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	NAME=-fh-hit; 	MAXSTEP=2; 	HEIGHT=4;   ../../scripts/maketrace.sh "${LPX_CMD_FH} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	NAME=-fh-miss;	MAXSTEP=2; 	HEIGHT=3;   ../../scripts/maketrace.sh "${LPX_CMD_FH} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0

	NAME=-queries;	MAXSTEP=5;	HEIGHT=20;	../../scripts/maketrace.sh "${LPX_CMD} ./extra-queries.lp | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0

	NAME=-dbec;	MAXSTEP=2;	HEIGHT=20;	../../scripts/maketrace.sh "${LPX_CMD_DBEC} | ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
	NAME=-eff;	MAXSTEP=2;	HEIGHT=20;	../../scripts/maketrace.sh "${LPX_CMD_EFF} 	| ../utils/replace_assignments.sh | ../utils/make-readable.sh" ./logs/lpx$$NAME-s$$MAXSTEP-h$$HEIGHT.log ; exit 0
