log-all:
	$(MAKE) -C clingo log-all &
	$(MAKE) -C scasp log-all

log-all-parallel:
	$(MAKE) -C clingo log-all-parallel &
	$(MAKE) -C scasp log-all-parallel
