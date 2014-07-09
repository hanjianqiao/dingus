include ../include/kernel_makefile

default:
	$(MAKE) memory.obj

memory.obj: memory_c.obj memory_nas.obj
	$(GOLIB) out:$@ memory_c.obj memory_nas.obj

.PHONY:clean
clean:
	$(DEL) *.lst
	$(DEL) memory_nas.obj
	$(DEL) memory_c.obj

.PHONY:src_only
src_only:
	$(MAKE) clean
	$(DEL) memory.obj