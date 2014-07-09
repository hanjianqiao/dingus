include ../include/kernel_makefile

default:
	$(MAKE) io.obj

io.obj: io.nas
	$(NASK) io.nas io.obj io.lst

.PHONY:clean
clean:
	$(DEL) *.lst

.PHONY:src_only
src_only:
	$(MAKE) clean
	$(DEL) io.obj