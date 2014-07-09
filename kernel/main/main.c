void io_hlt(void);

#define XSIZE	320
#define point0(x, y) p[(y) * XSIZE + (x)] = 0
#define point1(x, y) p[(y) * XSIZE + (x)] = 1
#define point2(x, y) p[(y) * XSIZE + (x)] = 2
#define point3(x, y) p[(y) * XSIZE + (x)] = 3
#define point4(x, y) p[(y) * XSIZE + (x)] = 4
#define point5(x, y) p[(y) * XSIZE + (x)] = 5
#define point6(x, y) p[(y) * XSIZE + (x)] = 6
#define point7(x, y) p[(y) * XSIZE + (x)] = 7
#define point8(x, y) p[(y) * XSIZE + (x)] = 8
#define point9(x, y) p[(y) * XSIZE + (x)] = 9
#define pointa(x, y) p[(y) * XSIZE + (x)] = 10
#define pointb(x, y) p[(y) * XSIZE + (x)] = 11
#define pointc(x, y) p[(y) * XSIZE + (x)] = 12
#define pointd(x, y) p[(y) * XSIZE + (x)] = 13
#define pointe(x, y) p[(y) * XSIZE + (x)] = 14
#define pointf(x, y) p[(y) * XSIZE + (x)] = 15

extern __inline__ double sin(double x)
{
	double res;
	__asm__ ("fsin" : "=t" (res) : "0" (x));
	return res;
}

extern __inline__ double cos(double x)
{
	double res;
	__asm__ ("fcos" : "=t" (res) : "0" (x));
	return res;
}

extern __inline__ double sqrt(double x)
{
	double res;
	__asm__ ("fsqrt" : "=t" (res) : "0" (x));
	return res;
}

void entry(void)
{
	int i;
	char *p;
	p = (char *) 0xa0000;

	for (i = 0; i < 320; i++) {
		point8(i, 100);
	}
	
	for(i = 0; i < 200; i++){
		point9(160, i);
	}
	
	for(i = 0; i < 320; i++){
		pointa(i, (int)(-sin((i - 160)/10.0)*60) + 100);
	}
	for(i = 0; i < 320; i++){
		pointb(i, (int)(-cos((i - 160)/10.0)*60) + 100);
	}

	for (;;) {
		io_hlt();
	}
}
