#include "../include/kernel.h"

void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1){
	int x, y;
	for (y = y0; y <= y1; y++) {
		for (x = x0; x <= x1; x++)
			vram[y * xsize + x] = c;
	}
	return;
}

void putfont8(char *vram, int xsize, int x, int y, char c, char *font)
{
	int i;
	char *p, d /* data */;
	for (i = 0; i < 16; i++) {
		p = vram + (y + i) * xsize + x;
		d = font[i];
		if ((d & 0x80) != 0) { p[0] = c; }
		if ((d & 0x40) != 0) { p[1] = c; }
		if ((d & 0x20) != 0) { p[2] = c; }
		if ((d & 0x10) != 0) { p[3] = c; }
		if ((d & 0x08) != 0) { p[4] = c; }
		if ((d & 0x04) != 0) { p[5] = c; }
		if ((d & 0x02) != 0) { p[6] = c; }
		if ((d & 0x01) != 0) { p[7] = c; }
	}
	return;
}

void putfonts8_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s)
{
	extern char ascii[4096];

	for (; *s != 0x00; s++) {
		putfont8(vram, xsize, x, y, c, ascii + *s * 16);
		x += 8;
	}
	return;
}

void putfonts8_asc_count(char *vram, int xsize, int x, int y, char c, unsigned char *s, int len)
{
	extern char ascii[4096];
	unsigned int i;
	for (i = 0; i < len; i++, s++) {
		putfont8(vram, xsize, x, y, c, ascii + *s * 16);
		x += 8;
	}
	return;
}

void putHex(char *vram, int xsize, int x, int y, char c, unsigned char *s){
	extern char ascii[4096];
	if((*s)/16 < 10){
		putfont8(vram, xsize, x, y, c, ascii + '0' * 16 + (*s)/16 * 16);
	}else{
		putfont8(vram, xsize, x, y, c, ascii + ('A' - 10) * 16 + (*s)/16 * 16);
	}
	x += 8;
	if((*s)%16 < 10){
		putfont8(vram, xsize, x, y, c, ascii + '0' * 16 + (*s)%16 * 16);
	}else{
		putfont8(vram, xsize, x, y, c, ascii + ('A' - 10) * 16 + (*s++)%16 * 16);
	}
}

void putHexs(char *vram, int xsize, int x, int y, char c, unsigned char *s, int len){
	extern char ascii[4096];
	for (; len > 0x00; len--) {
		putHex(vram, xsize, x, y, c, s++);
		x += 16;
		putfont8(vram, xsize, x, y, c, ascii + ' ' * 16);
		x += 8;
		if(len % 27 == 0){
			y += 24;
			x = 0;
		}
	}
}
