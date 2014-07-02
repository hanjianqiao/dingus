; ipl.nas
; This is Initial program loader, responsible for load the system into memory. Futher, it may be able to check system status.

CYLS	EQU		20				; number of cylinders to read to memory
SECTOR	EQU		18				; Sectors per track
HEADER	EQU		2				; Number of heads

		ORG		0x7c00			; 0x00007c00 - 0x00007dff where ipl is loaded to by bios

		JMP		entry			; 0-2     Jump to bootstrap
		NOP
		
		DB		"DIY 0.0 "		; 3-10    OEM name/version
		
		DW		512				; 11-12   Number of bytes per sector (512)
		
		DB		1				; 13      Number of sectors per cluster (1)
		
		DW		1				; 14-15   Number of reserved sectors (1)
		
		DB		2				; 16      Number of FAT copies (2)
		
		DW		224				; 17-18   Number of root directory entries (224)
		
		DW		2880			; 19-20   Total number of sectors in the filesystem (2880)
		
		DB		0xf0			; 21      Media descriptor type (f0: 1.4 MB floppy, f8: hard disk;)
		
		DW		9				; 22-23   Number of sectors per FAT (9)
		
		DW		18				; 24-25   Number of sectors per track (12)
		
		DW		2				; 26-27   Number of heads (2, for a double-sided diskette)
		
		DD		0				; 28-31   Number of hidden sectors (0)
		
		DD		2880			; 32-35   Total number of sectors in the filesystem
		
		DB		0				; 36      Logical Drive Number (for use with INT 0x13, e.g. 0 or 0x80)
		
		DB		0				; 37      Reserved
		
		DB		0x29			; 38      Extended signature (0x29)
		
		DD		0xffffffff		; 39-42   Serial number of partition
		
		DB		"DIY OS     "	; 43-53   Volume label or "NO NAME    "
		
		DB		"FAT12   "		; 54-61   Filesystem type (E.g. "FAT12   ", "FAT16   ", "FAT     ", or all zero.)

entry:
		MOV		AX,0			; Initalize essential register so that we can run the code correctly.
		MOV		SS,AX			; Stack segement register, base address of stack
		MOV		SP,0x7c00
		MOV		DS,AX			; Data segement register, base address of data

; R/W sectors INT 0x13
; AH = 0x02 read£¬AH = 0x03 write£¬AH = 0x04 verify£¬AH = 0x0c seek
; AL = number of sectors to deal with£¨continous£©
; CH = Cylinder & 0xff
; CL = Sector£¨0-5 bit£©|£¨Cylinder & 0x300£©>> 2
; DH = head
; DL = driver
; ES:BX = buffer
;return value£ºFLAGS.CF == 0 no error£¬AH = 0£»FLAGS.CF == 1 error occurred£¬AH - error number

		MOV		AX,0x0820		; Read data to 0x08200, in 16-bit mode, ES:BX = ES*16+BX
		MOV		ES,AX
		MOV		CH,0
		MOV		DH,0
		MOV		CL,2			; Sector number start with 1, not 0; we don't need to read IPL.

readloop:
		MOV		SI,0			; Record fail time

retry:
		MOV		AH,0x02
		MOV		AL,1
		MOV		BX,0
		MOV		DL,0x00
		INT		0x13
		JNC		next			; Jump if not Carry
		
		ADD		SI,1			; Increase fail count
		CMP		SI,5			; SI>5?
		JAE		error			; SI >= 5 jump to error
		MOV		AH,0x00			; Retry
		MOV		DL,0x00
		INT		0x13			; BIOS, AH = 0x00£ºreset
		JMP		retry

next:
		MOV		AX,ES			; Buffer address increase by 0x200
		ADD		AX,0x0020		; 0x200 = 512
		MOV		ES,AX
		ADD		CL,1			; CL increase by 1
		CMP		CL,SECTOR
		JBE		readloop		; CL <= SECTOR read next sector
		
		MOV		CL,1			; read next track, initialize sector to 1
		ADD		DH,1			; each cylinder have HEADER heads, so head increase by 1
		CMP		DH,HEADER
		JB		readloop		; read next head
		
		MOV		DH,0			; read next cylinder, iniialize head to 0
		ADD		CH,1			; cylinder number add 1
		CMP		CH,CYLS			; read until CYLS cylinder
		JB		readloop

		MOV		[0x0ff0],CH		; write the number of cylinders read by IPL to 0xff0
		JMP		0xc200			; jump to eos.sys. The number is counted by 0x8000 + file location in the image.

error:
		MOV		SI,msg

putloop:
								;Display a char INT 0x10
								;AH = 0x0e£¬AL = charactor code£¬BH = 0£¬ BL = color code£¬return value:null
								
		MOV		AL,[SI]	
		ADD		SI,1
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e
		MOV		BX,15			; white
		INT		0x10

		JMP		putloop
fin:
		HLT
		JMP		fin
msg:
		DB		0x0a, 0x0a
		DB		"Unfortunately, load error. And this fault cannot be handled automatically."
		DB		0x0a
		DB		0

		RESB	0x7dfe-$		; 0x7c00+0x0200-0x0002, depends on previous ORG 0x7c00.

		DB		0x55, 0xaa
