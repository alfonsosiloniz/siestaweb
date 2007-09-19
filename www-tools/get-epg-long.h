/*
 * get-epg-long.h
 *
 * Definiciones para get-epg-long
 *
 */

#ifndef _GET_EPG_LONG_H_
#define	_GET_EPG_LONG_H_

/* Definiciones generales */
#define LON_BUF_TEXTO_LONG	4096

/* Declaracion funciones */
void	get_epg_long_uso	(void);
int		get_epg_long		(char *fichero, long inicio);

#endif
