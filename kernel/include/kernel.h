/* init */
#define ADR_BOOTINFO	0x00000ff0
#define ADR_DISKIMG		0x00100000
struct BOOTINFO { /* 0x0ff0-0x0fff */
	char cyls;
	char leds;
	char vmode;
	char reserve;
	short scrnx, scrny;
	char *vram;
};

/* drivers */
void io_hlt(void);
void io_cli(void);
void io_sti(void);
void io_stihlt(void);
int io_in8(int port);
int io_in16(int port);
int io_in32(int port);
void io_out8(int port, int data);
void io_out16(int port, int data);
void io_out32(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);
void load_gdtr(int limit, int addr);
void load_idtr(int limit, int addr);
int load_cr0(void);
void store_cr0(int cr0);
void load_tr(int tr);

/* memory */
#define MEMMAN_FREES		4090
#define MEMMAN_ADDR			0x003c0000
extern struct MEMMAN *memman;
struct FREE_UNIT{
	unsigned int addr, size;
};
struct MEMMAN{
	unsigned int frees, maxfrees, lostsize, losts;
	struct FREE_UNIT free[MEMMAN_FREES];
};
unsigned int memtest_sub(unsigned int start, unsigned int end);
unsigned int memtest(unsigned int start, unsigned int end);
void memman_init(struct MEMMAN *man);
unsigned int memman_total_free(struct MEMMAN *man);
unsigned int memman_alloc(struct MEMMAN *man, unsigned int size);
int memman_free(struct MEMMAN *man, unsigned int addr, unsigned int size);
unsigned int memman_alloc_4k(struct MEMMAN *man, unsigned int size);
int memman_free_4k(struct MEMMAN *man, unsigned int addr, unsigned int size);
