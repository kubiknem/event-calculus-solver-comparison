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

create-env-lpx:
	@(conda env create -f ./utils/clingo_lpx_env.yaml || \
	conda env update -f ./utils/clingo_lpx_env.yaml) > /dev/null 2>&1

activate-clingo-lpx-env:
	conda activate clingo-lpx

build-format_output:
	$(MAKE) -C ./utils/format-output/
