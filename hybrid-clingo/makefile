log-all:
	$(MAKE) -C ex1* log
	$(MAKE) -C ex2* log
	$(MAKE) -C ex3* log
	$(MAKE) -C ex4* log
	$(MAKE) -C ex5* log
	$(MAKE) -C ex6* log

log-all-parallel:
	$(MAKE) -C ex1* log &
	$(MAKE) -C ex2* log &
	$(MAKE) -C ex3* log &
	$(MAKE) -C ex4* log &
	$(MAKE) -C ex5* log &
	$(MAKE) -C ex6* log

activate-clingo-lpx-env:
	@echo "run this manually: conda activate clingo-lpx"

build-format_output:
	$(MAKE) -C ./utils/format-output/