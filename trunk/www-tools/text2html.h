/*
 * text2html.h
 *
 * Definiciones para text2html
 *
 */

#ifndef _TEXT2HTML_H_
#define	_TEXT2HTML_H_

/* Definiciones generales */
#define PORCENTAJE_ALTURA	4

/* Declaracion funciones */
void	text2html_uso	(void);
int		text2html		(char *ch_id, char *file_text, long horaUTCinicio, long mostrar_img);


#endif
