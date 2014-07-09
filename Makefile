TOOLS_PATH = tools/
INCPATH  = kernel/include/

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

default:
	$(MAKE) run

dingus.img : ipl/ipl.bin kernel/dingus.kernel Makefile
	$(MAKE) full
	$(EDIMG)   imgin:$(INCPATH)fdimg0at.tek \
		wbinimg src:ipl/ipl.bin len:512 from:0 to:0 \
		copy from:kernel/dingus.kernel to:@: \
		imgout:dingus.img

blank.img:
	$(MAKE) full
	$(EDIMG)   imgin:$(INCPATH)fdimg0at.tek \
		wbinimg src:ipl/ipl.bin len:512 from:0 to:0 \
		imgout:blank.img
	
.PHONY: run
run :
	$(MAKE) dingus.img
	$(COPY) dingus.img tools\qemu\fdimage0.bin
	$(MAKE) -C $(TOOLS_PATH)qemu

.PHONY: full
full:
	$(MAKE) -C ipl
	$(MAKE) -C kernel full

.PHONY:full_run
full_run:
	$(MAKE) full
	$(MAKE) run

.PHONY: clean
clean:
	$(MAKE) -C ipl clean
	$(MAKE) -C kernel clean

.PHONY: src_only
src_only:
	$(MAKE) -C ipl src_only
	$(MAKE) -C kernel src_only
	$(DEL) dingus.img
