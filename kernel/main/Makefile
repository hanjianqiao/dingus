include ../include/kernel_makefile

default:
	$(MAKE) main.obj

main.obj: main.c

.PHONY:clean
clean:
	$(DEL) *.lst

.PHONY:src_only
src_only:
	$(MAKE) clean
	$(DEL) main.obj