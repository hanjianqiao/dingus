TOOLS_PATH = ../tools/
INCPATH  = include/

MAKE     = $(TOOLPATH)make.exe -r
NASK     = $(TOOLPATH)nask.exe
CC1      = $(TOOLPATH)cc1.exe -I$(INCPATH) -Os -Wall -quiet
GAS2NAS	 = $(TOOLPATH)gas2nas.exe -a
OBJ2BIM  = $(TOOLPATH)obj2bim.exe
MAKEFONT = $(TOOLPATH)makefont.exe
BIN2OBJ  = $(TOOLPATH)bin2obj.exe
BIM2HRB  = $(TOOLPATH)bim2hrb.exe
RULEFILE = $(TOOLPATH)dingus.rul
EDIMG    = $(TOOLPATH)edimg.exe
IMGTOL   = $(TOOLPATH)imgtol.com
GOLIB    = $(TOOLPATH)golib00.exe 
COPY     = copy
DEL      = del

RULEFILE = include/dingus.rul

OBJS_KERNEL = main/main.obj memory/memory.obj drivers/io.obj \
				graphic/graphic.obj graphic/ascii.obj

default:
	$(MAKE) dingus.kernel

setup.obj:	init/setup.nas
	$(MAKE) -C init setup.obj

dingus.hrb : dingus.bim Makefile
	$(BIM2HRB) dingus.bim dingus.hrb 0
	
dingus.kernel : setup.obj dingus.hrb
	$(COPY) /B init\setup.obj+dingus.hrb dingus.kernel
	
dingus.bim : $(OBJS_KERNEL) Makefile
	$(OBJ2BIM) @$(RULEFILE) out:dingus.bim stack:3136k map:dingus.map \
		$(OBJS_KERNEL)

.PHONY: full
full:
	$(MAKE) -C init
	$(MAKE) -C graphic
	$(MAKE) -C drivers
	$(MAKE) -C memory
	$(MAKE) -C main
	$(MAKE) dingus.bim
	$(MAKE) dingus.hrb
	$(MAKE) dingus.kernel

.PHONY: clean
clean:
	$(MAKE) -C init clean
	$(MAKE) -C graphic clean
	$(MAKE) -C drivers clean
	$(MAKE) -C memory clean
	$(MAKE) -C main clean
	$(DEL)	dingus.*

.PHONY: src_only
src_only:
	$(MAKE) -C init src_only
	$(MAKE) -C graphic src_only
	$(MAKE) -C drivers src_only
	$(MAKE) -C memory src_only
	$(MAKE) -C main src_only
	$(DEL)	dingus.*