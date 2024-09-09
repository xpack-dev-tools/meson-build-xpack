meson:	meson.c.o
	$(CC) $(LDFLAGS) meson.c.o -o meson $(LIBS)

meson.exe:	meson.c.o
	$(CC) $(LDFLAGS) meson.c.o -o meson.exe $(LIBS)

meson.c.o: meson.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c meson.c -o meson.c.o
