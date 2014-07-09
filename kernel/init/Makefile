include ../include/kernel_makefile

default:
	$(MAKE) setup.obj

setup.obj: setup.nas
	$(NASK) setup.nas setup.obj setup.lst

.PHONY:clean
clean:
	$(DEL) setup.lst

.PHONY:src_only
src_only:
	$(MAKE) clean
	$(DEL) setup.obj