TOOLPATH		= ../tools/

MAKE			= $(TOOLPATH)make.exe -r
NASK     		= $(TOOLPATH)nask.exe

default :
	$(MAKE) ipl.bin


ipl.bin : ipl.nas
	$(NASK) ipl.nas ipl.bin ipl.lst
			
clean:
	del *.lst
	
src_only:
	$(MAKE) clean
	del *.bin
