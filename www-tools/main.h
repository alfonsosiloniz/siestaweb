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

/* Flags de sanear_txt */
#define FILTRO_CRLF		0x0001
#define FILTRO_8A		0x0002

/* Declaracion funciones */
void	sanear_txt	(const unsigned char *in, unsigned char *out, long max_lon, long flags);

LONG	read_LONG	(FILE *file);

void	utc2str		(const long utc_time, char *out);

#endif
