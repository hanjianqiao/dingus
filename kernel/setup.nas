[INSTRSET "i486p"]	; Declare to use instruction set till 486

VBEMODE		EQU		0x101			; 1024 x  768 x 8bit video mode
; VBE mode
;	0x100 :  640 x  400 x 8bit video mode
;	0x101 :  640 x  480 x 8bit video mode
;	0x103 :  800 x  600 x 8bit video mode
;	0x105 : 1024 x  768 x 8bit video mode
;	0x107 : 1280 x 1024 x 8bit video mode

BOTPAK		EQU		0x00280000		; where bootpack will be stored
DSKCAC		EQU		0x00100000		; Disk Image location
DSKCAC0		EQU		0x00008000		; Location when the image was first read
ADRIDT		EQU		0x0026f800		; IDT base
LIMITIDT	EQU		0x000007ff		; IDT limit
ADRGDT		EQU		0x00270000		; GDT base
LIMITGDT	EQU		0x0000ffff		; GDT limit

; BOOT_INFO
CYLS		EQU		0x0ff0			; Cylinders read into memory
LEDS		EQU		0x0ff1			; LED status
VMODE		EQU		0x0ff2			; Video mode
SCRNX		EQU		0x0ff4			; X size of screen
SCRNY		EQU		0x0ff6			; Y size of screen
VRAM		EQU		0x0ff8			; Video buffer base

	ORG		0xc200					; 0x8000 + 0x4200 = 0xc200

; VBE test

		MOV		AX,0x9000
		MOV		ES,AX
		MOV		DI,0
		MOV		AX,0x4f00
		INT		0x10
		CMP		AX,0x004f
		JNE		scrn320

; check VBE version

		MOV		AX,[ES:DI+4]
		CMP		AX,0x0200
		JB		scrn320			; if (AX < 0x0200) goto scrn320

; get mode infomation

		MOV		CX,VBEMODE
		MOV		AX,0x4f01
		INT		0x10
		CMP		AX,0x004f
		JNE		scrn320

; check again

		CMP		BYTE [ES:DI+0x19],8
		JNE		scrn320
		CMP		BYTE [ES:DI+0x1b],4
		JNE		scrn320
		MOV		AX,[ES:DI+0x00]
		AND		AX,0x0080
		JZ		scrn320

; switch mode

		MOV		BX,VBEMODE+0x4000
		MOV		AX,0x4f02
		INT		0x10
		MOV		BYTE [VMODE],8
		MOV		AX,[ES:DI+0x12]
		MOV		[SCRNX],AX
		MOV		AX,[ES:DI+0x14]
		MOV		[SCRNY],AX
		MOV		EAX,[ES:DI+0x28]
		MOV		[VRAM],EAX
		JMP		keystatus

scrn320:
		MOV		AL,0x13
		MOV		AH,0x00
		INT		0x10
		MOV		BYTE [VMODE],8
		MOV		WORD [SCRNX],320
		MOV		WORD [SCRNY],200
		MOV		DWORD [VRAM],0x000a0000

;

keystatus:
		MOV		AH,0x02
		INT		0x16
		MOV		[LEDS],AL

; Initialize PIC
		MOV		AL,0xff
		OUT		0x21,AL
		NOP						; give IO a break
		OUT		0xa1,AL
		CLI
		
		CALL	waitkbdout
		MOV		AL,0xd1
		OUT		0x64,AL
		CALL	waitkbdout
		MOV		AL,0xdf			; enable A20
		OUT		0x60,AL
		CALL	waitkbdout

; Switch to protection mode
		LGDT	[GDTR0]			; Set temporary GDT
		MOV		EAX,CR0
		AND		EAX,0x7fffffff	; disable paging
		OR		EAX,0x00000001	; switch to protection mode
		MOV		CR0,EAX
		JMP		pipelineflush	; protection mode uses pipeline，JMP in order to refresh 
		
pipelineflush:
		MOV		AX,1*8			; set segment register to seg one
		MOV		DS,AX
		MOV		ES,AX
		MOV		FS,AX
		MOV		GS,AX
		MOV		SS,AX

; move bootpack

		MOV		ESI,bootpack
		MOV		EDI,BOTPAK
		MOV		ECX,512*1024/4	; when bootpack is larger here should be modified
		CALL	memcpy

; move image
		MOV		ESI,0x7c00
		MOV		EDI,DSKCAC
		MOV		ECX,512/4
		CALL	memcpy

		MOV		ESI,DSKCAC0+512
		MOV		EDI,DSKCAC+512
		MOV		ECX,0
		MOV		CL,BYTE [CYLS]
		IMUL	ECX,512*18*2/4
		SUB		ECX,512/4		; ipl have already been moved
		CALL	memcpy


; boot bootpack
; prepare to run bootpack, it's depends on the format of disk
		MOV		EBX,BOTPAK
		MOV		ECX,[EBX+16]
		ADD		ECX,3
		SHR		ECX,2
		JZ		skip
		MOV		ESI,[EBX+20]
		ADD		ESI,EBX
		MOV		EDI,[EBX+12]
		CALL	memcpy
skip:
		MOV		ESP,[EBX+12]
		JMP		DWORD 2*8:0x0000001b

waitkbdout:
		IN		 AL,0x64
		AND		 AL,0x02
		IN		 AL,0x60 		; flush buffer
		JNZ		waitkbdout
		RET

memcpy:
		MOV		EAX,[ESI]
		ADD		ESI,4
		MOV		[EDI],EAX
		ADD		EDI,4
		SUB		ECX,1
		JNZ		memcpy
		RET

		ALIGNB	16
GDT0:
		RESB	8
		DW		0xffff,0x0000,0x9200,0x00cf
		DW		0xffff,0x0000,0x9a28,0x0047

		DW		0
GDTR0:
		DW		8*3-1	; limit = size - 1
		DD		GDT0

		ALIGNB	16
bootpack:
