# Project: www-tools

# Programas a utilizar
CC_mips		= mips-uclibc-gcc
CXX_mips	= mips-uclibc-g++
STRIP_mips	= mips-uclibc-strip
CC_i386		= gcc
CXX_i386	= g++
STRIP_i386	= strip
RM			= rm -f

# Modulos del proyecto
dirOBJ		= obj
dirBIN		= bin
OBJ_mips	= ${dirOBJ}/main.o ${dirOBJ}/get-epg-long.o \
			  ${dirOBJ}/db2text.o ${dirOBJ}/text2xml.o \
			  ${dirOBJ}/text2html.o ${dirOBJ}/text2pgact.o \
			  ${dirOBJ}/infoID.o ${dirOBJ}/crid2var.o \
			  ${dirOBJ}/var2crid.o
OBJ_i386	= ${dirOBJ}/main.o.i386 ${dirOBJ}/get-epg-long.o.i386 \
			  ${dirOBJ}/db2text.o.i386 ${dirOBJ}/text2xml.o.i386 \
			  ${dirOBJ}/text2html.o.i386 ${dirOBJ}/text2pgact.o.i386 \
			  ${dirOBJ}/infoID.o.i386 ${dirOBJ}/crid2var.o.i386 \
			  ${dirOBJ}/var2crid.o.i386
OBJ2_mips	= ${dirOBJ}/proccgi.o ${dirOBJ}/scan-param.o
OBJ2_i386	= ${dirOBJ}/proccgi.o.i386 ${dirOBJ}/scan-param.o.i386
BIN_mips	= ${dirBIN}/www-tools.mips
BIN_i386	= ${dirBIN}/www-tools.i386
CFLAGS_mips	= -DBINmips -Wall -Os
LFLAGS_mips	= -s -Wl,-warn-common
CFLAGS_i386	= -DBINi386 -Wall -Wno-pointer-sign -Os
LFLAGS_i386	= -s -Wl,-warn-common

# Objetivos
all: $(BIN_mips) $(BIN_i386)
# 	chmod 755 $(BIN_mips) $(BIN_i386)
# 	ls -la $(BIN_mips) $(BIN_i386)
	chmod 755 $(dirBIN)/*
	ls -la $(dirBIN)

$(BIN_mips): ${dirOBJ} ${dirBIN} $(OBJ_mips) $(OBJ2_mips)
	$(CC_mips) $(LFLAGS_mips) $(OBJ_mips) -o $(BIN_mips)
	$(STRIP_mips) -s --remove-section=.note --remove-section=.comment $(BIN_mips)

	$(CC_mips) $(LFLAGS_mips) ${dirOBJ}/proccgi.o -o ${dirBIN}/proccgi.mips
	$(STRIP_mips) -s --remove-section=.note --remove-section=.comment ${dirBIN}/proccgi.mips

	$(CC_mips) $(LFLAGS_mips) ${dirOBJ}/scan-param.o -o ${dirBIN}/scan-param.mips
	$(STRIP_mips) -s --remove-section=.note --remove-section=.comment ${dirBIN}/scan-param.mips


$(BIN_i386): ${dirOBJ} ${dirBIN} $(OBJ_i386) $(OBJ2_i386)
	$(CC_i386) $(LFLAGS_i386) $(OBJ_i386) -o $(BIN_i386)
	$(STRIP_i386) -s --remove-section=.note --remove-section=.comment $(BIN_i386)

	$(CC_i386) $(LFLAGS_i386) ${dirOBJ}/proccgi.o.i386 -o ${dirBIN}/proccgi.i386
	$(STRIP_i386) -s --remove-section=.note --remove-section=.comment ${dirBIN}/proccgi.i386

	$(CC_i386) $(LFLAGS_i386) ${dirOBJ}/scan-param.o.i386 -o ${dirBIN}/scan-param.i386
	$(STRIP_i386) -s --remove-section=.note --remove-section=.comment ${dirBIN}/scan-param.i386

${dirOBJ}:
	mkdir -p ${dirOBJ}
	chmod 777 $(dirOBJ)

${dirBIN}:
	mkdir -p ${dirBIN}
	chmod 777 $(dirBIN)

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

${dirOBJ}/var2crid.o: var2crid.c
	$(CC_mips) $(CFLAGS_mips) -c var2crid.c -o ${dirOBJ}/var2crid.o
${dirOBJ}/var2crid.o.i386: var2crid.c
	$(CC_i386) $(CFLAGS_i386) -c var2crid.c -o ${dirOBJ}/var2crid.o.i386

${dirOBJ}/proccgi.o: proccgi.c
	$(CC_mips) $(CFLAGS_mips) -c proccgi.c -o ${dirOBJ}/proccgi.o
${dirOBJ}/proccgi.o.i386: proccgi.c
	$(CC_i386) $(CFLAGS_i386) -c proccgi.c -o ${dirOBJ}/proccgi.o.i386

${dirOBJ}/scan-param.o: scan-param.c
	$(CC_mips) $(CFLAGS_mips) -c scan-param.c -o ${dirOBJ}/scan-param.o
${dirOBJ}/scan-param.o.i386: scan-param.c
	$(CC_i386) $(CFLAGS_i386) -c scan-param.c -o ${dirOBJ}/scan-param.o.i386

clean:
	${RM} $(OBJ_mips) $(OBJ_i386)
	${RM} $(BIN_mips) $(BIN_i386)
	${RM} $(OBJ2_mips) $(OBJ2_i386)
	${RM} ${dirBIN}/proccgi.mips ${dirBIN}/scan-param.mips
	${RM} ${dirBIN}/proccgi.i386 ${dirBIN}/scan-param.i386
