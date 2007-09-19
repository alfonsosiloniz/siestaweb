/*
 * db2text.h
 *
 * Definiciones para db2text
 *
 */

#ifndef _DB2TEXT_H_
#define	_DB2TEXT_H_

/* Definiciones generales */
#define LON_BUF_PGM 512
#define LON_BUF_TXT 192

/* Estructura datos programa sincroguia */
typedef struct {
	int pid;
	int pidcid1;
	int pidcid2;
	int date_utc;
	char date_str[LON_BUF_TXT+1];
	int ix_long;
	unsigned char bytesTitulo;
	unsigned char titulo[LON_BUF_TXT+1];
	unsigned char bytesSubtitulo;
	unsigned char subtitulo[LON_BUF_TXT+1];
	unsigned char bytesImagen;
	unsigned char imagen[LON_BUF_TXT+1];
} pgm_sincro;

/* Declaracion funciones */
void	db2text_uso	(void);
int		db2text		(char *file_db);

LONG	x4			(void *p);
WORD	x2			(void *p);
BYTE	x1			(void *p);


#endif
