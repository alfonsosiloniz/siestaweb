# Project: www-tools

# Programas a utilizar
CC_mips    = mips-uclibc-gcc
CXX_mips   = mips-uclibc-g++
STRIP_mips = mips-uclibc-strip
CC_i386    = gcc
CXX_i386   = g++
STRIP_i386 = strip
RM         = rm -f

# Modulos del proyecto
dirOBJ      = obj
OBJ_mips    = ${dirOBJ}/main.o ${dirOBJ}/get-epg-long.o \
              ${dirOBJ}/db2text.o ${dirOBJ}/text2xml.o \
			  ${dirOBJ}/text2html.o ${dirOBJ}/text2pgact.o \
			  ${dirOBJ}/infoID.o ${dirOBJ}/crid2var.o
OBJ_i386    = ${dirOBJ}/main.o.i386 ${dirOBJ}/get-epg-long.o.i386 \
              ${dirOBJ}/db2text.o.i386 ${dirOBJ}/text2xml.o.i386 \
			  ${dirOBJ}/text2html.o.i386 ${dirOBJ}/text2pgact.o.i386 \
			  ${dirOBJ}/infoID.o.i386 ${dirOBJ}/crid2var.o.i386
BIN_i386    = www-tools.i386
BIN_mips    = www-tools.mips
CFLAGS_mips = -DBINmips -Wall -Os
LFLAGS_mips = -s -Wl,-warn-common
CFLAGS_i386 = -DBINi386 -Wall -Wno-pointer-sign -Os
LFLAGS_i386 = -s -Wl,-warn-common
#CFLAGS = -static
#LFLAGS = -Wl,-static

# Objetivos
all: $(BIN_mips) $(BIN_i386)
	chmod 755 $(BIN_mips) $(BIN_i386)
	ls -la $(BIN_mips) $(BIN_i386)

$(BIN_mips): ${dirOBJ} $(OBJ_mips)
	$(CC_mips) $(LFLAGS_mips) $(OBJ_mips) -o $(BIN_mips)
	$(STRIP_mips) -s --remove-section=.note --remove-section=.comment $(BIN_mips)
$(BIN_i386): ${dirOBJ} $(OBJ_i386)
	$(CC_i386) $(LFLAGS_i386) $(OBJ_i386) -o $(BIN_i386)
	$(STRIP_i386) -s --remove-section=.note --remove-section=.comment $(BIN_i386)

${dirOBJ}/main.o: main.c
	$(CC_mips) $(CFLAGS_mips) -Wno-format-y2k -c main.c -o ${dirOBJ}/main.o
${dirOBJ}/main.o.i386: main.c
	$(CC_i386) $(CFLAGS_i386) -Wno-format-y2k -c main.c -o ${dirOBJ}/main.o.i386

${dirOBJ}/get-epg-long.o: get-epg-long.c
	$(CC_mips) $(CFLAGS_mips) -c get-epg-long.c -o ${dirOBJ}/get-epg-long.o
${dirOBJ}/get-epg-long.o.i386: get-epg-long.c
	$(CC_i386) $(CFLAGS_i386) -c get-epg-long.c -o ${dirOBJ}/get-epg-long.o.i386

${dirOBJ}/db2text.o: db2text.c
	$(CC_mips) $(CFLAGS_mips) -c db2text.c -o ${dirOBJ}/db2text.o
${dirOBJ}/db2text.o.i386: db2text.c
	$(CC_i386) $(CFLAGS_i386) -c db2text.c -o ${dirOBJ}/db2text.o.i386

${dirOBJ}/text2xml.o: text2xml.c
	$(CC_mips) $(CFLAGS_mips) -c text2xml.c -o ${dirOBJ}/text2xml.o
${dirOBJ}/text2xml.o.i386: text2xml.c
	$(CC_i386) $(CFLAGS_i386) -c text2xml.c -o ${dirOBJ}/text2xml.o.i386

${dirOBJ}/text2html.o: text2html.c
	$(CC_mips) $(CFLAGS_mips) -c text2html.c -o ${dirOBJ}/text2html.o
${dirOBJ}/text2html.o.i386: text2html.c
	$(CC_i386) $(CFLAGS_i386) -c text2html.c -o ${dirOBJ}/text2html.o.i386

${dirOBJ}/text2pgact.o: text2pgact.c
	$(CC_mips) $(CFLAGS_mips) -c text2pgact.c -o ${dirOBJ}/text2pgact.o
${dirOBJ}/text2pgact.o.i386: text2pgact.c
	$(CC_i386) $(CFLAGS_i386) -c text2pgact.c -o ${dirOBJ}/text2pgact.o.i386

${dirOBJ}/infoID.o: infoID.c
	$(CC_mips) $(CFLAGS_mips) -c infoID.c -o ${dirOBJ}/infoID.o
${dirOBJ}/infoID.o.i386: infoID.c
	$(CC_i386) $(CFLAGS_i386) -c infoID.c -o ${dirOBJ}/infoID.o.i386

${dirOBJ}/crid2var.o: crid2var.c
	$(CC_mips) $(CFLAGS_mips) -c crid2var.c -o ${dirOBJ}/crid2var.o
${dirOBJ}/crid2var.o.i386: crid2var.c
	$(CC_i386) $(CFLAGS_i386) -c crid2var.c -o ${dirOBJ}/crid2var.o.i386

${dirOBJ}:
	mkdir -p ${dirOBJ}
	chmod 777 $(dirOBJ)

clean:
	${RM} $(OBJ_mips) $(OBJ_i386) $(BIN_mips) $(BIN_i386)
