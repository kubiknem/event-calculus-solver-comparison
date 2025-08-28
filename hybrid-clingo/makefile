log-all:
	$(MAKE) -C ex1* log
	$(MAKE) -C ex2* log
	$(MAKE) -C ex3* log
	$(MAKE) -C ex4* log
	$(MAKE) -C ex5* log

log-all-parallel:
	$(MAKE) -C ex1* log &
	$(MAKE) -C ex2* log &
	$(MAKE) -C ex3* log &
	$(MAKE) -C ex4* log &
	$(MAKE) -C ex5* log

activate-clingo-lpx-env:
	conda activate clingo-lpx

build-format_output:
	$(MAKE) -C ./utils/format-output/