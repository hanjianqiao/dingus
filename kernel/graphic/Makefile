include ../include/kernel_makefile

default:
	$(MAKE) ascii.obj
	$(MAKE) graphic.obj

ascii.bin : ascii.txt Makefile
	$(MAKEFONT) ascii.txt ascii.bin

ascii.obj : ascii.bin Makefile
	$(BIN2OBJ) ascii.bin ascii.obj _ascii

.PHONY:clean
clean:
	$(DEL) *.lst
	$(DEL) ascii.bin

.PHONY:src_only
src_only:
	$(MAKE) clean
	$(DEL) *.obj