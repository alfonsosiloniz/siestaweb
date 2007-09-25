# Project: www-tools

# Programas a utilizar
CC    = mips-uclibc-gcc
CXX   = mips-uclibc-g++
STRIP = mips-uclibc-strip
RM    = rm -f

# Modulos del proyecto
OBJ    = main.o get-epg-long.o db2text.o text2xml.o text2html.o
BIN    = www-tools
#CFLAGS = -Wall -Os
#LFLAGS = -s -Wl,-warn-common
CFLAGS = -Wall -Os -static
LFLAGS = -s -Wl,-warn-common -Wl,-static

all: $(BIN)

$(BIN): $(OBJ)
	$(CC) $(LFLAGS) -s $(OBJ) -o $(BIN)
	$(STRIP) -s --remove-section=.note --remove-section=.comment $(BIN)
	chmod 755 $(BIN)
	ls -la $(BIN)

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o 

get-epg-long.o: get-epg-long.c
	$(CC) $(CFLAGS) -c get-epg-long.c -o get-epg-long.o 

db2text.o: db2text.c
	$(CC) $(CFLAGS) -c db2text.c -o db2text.o 

text2xml.o: text2xml.c
	$(CC) $(CFLAGS) -c text2xml.c -o text2xml.o 

text2html.o: text2html.c
	$(CC) $(CFLAGS) -c text2html.c -o text2html.o 

clean:
	${RM} $(OBJ) $(BIN)
