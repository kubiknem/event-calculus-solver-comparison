log-all:
	$(MAKE) -C ex1* log
	$(MAKE) -C ex2* log
	$(MAKE) -C ex3* log
	$(MAKE) -C ex4* log

log-all-parallel:
	$(MAKE) -C ex1* log &
	$(MAKE) -C ex2* log &
	$(MAKE) -C ex3* log &
	$(MAKE) -C ex4* log

build-format_output:
	$(MAKE) -C ./utils/format-output/