include ../include/kernel_makefile


setup.bin: setup.nas
	$(NASK) setup.nas setup.bin setup.lst

.PHONY:clean
clean:
	$(DEL) setup.lst

.PHONY:src_only
src_only:
	$(MAKE) clean
	$(DEL) setup.bin