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

/* graphic */
void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1);
void putfont8(char *vram, int xsize, int x, int y, char c, char *font);
void putfonts8_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s);
void putfonts8_asc_count(char *vram, int xsize, int x, int y, char c, unsigned char *s, int len);
void putHex(char *vram, int xsize, int x, int y, char c, unsigned char *s);
void putHexs(char *vram, int xsize, int x, int y, char c, unsigned char *s, int len);
#define COL8_000000		0
#define COL8_FF0000		1
#define COL8_00FF00		2
#define COL8_FFFF00		3
#define COL8_0000FF		4
#define COL8_FF00FF		5
#define COL8_00FFFF		6
#define COL8_FFFFFF		7
#define COL8_C6C6C6		8
#define COL8_840000		9
#define COL8_008400		10
#define COL8_848400		11
#define COL8_000084		12
#define COL8_840084		13
#define COL8_008484		14
#define COL8_848484		15
