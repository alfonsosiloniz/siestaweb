/*
 * main.h
 *
 * Definiciones generales xml-tools
 *
 */

#ifndef _MAIN_H_
#define	_MAIN_H_

/* Definiciones de tipos */
typedef unsigned char		BYTE;
typedef unsigned short		WORD;
typedef unsigned long		LONG;
typedef unsigned long long	DLONG;

/* Definiciones generales */
#define LON_BUF_PGM			512
#define LON_BUF_TXT			192
#define LON_BUF_TEXTO_LONG	4096

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

/* Flags de sanear_txt */
#define FILTRO_CRLF		0x0001
#define FILTRO_8A		0x0002

/* Declaracion funciones */
void	print_version		();
void	print_uso			();

/* Funciones generales */
LONG	read_LONG			(FILE *file);
//WORD	read_WORD			(FILE *file);
//BYTE	read_BYTE			(FILE *file);
void	utc2str				(const long utc_time, char *out);
void	sanear_txt			(const unsigned char *in, unsigned char *out, long max_lon, long flags);
int		eliminarLF			(char *line);
int		lon_campo			(const unsigned char *in);
int		get_pgm				(const unsigned char *line, pgm_sincro *pgm);

#endif
