/*
 * db2text.h
 *
 * Definiciones para db2text
 *
 */

#ifndef _DB2TEXT_H_
#define	_DB2TEXT_H_

/* Declaracion funciones */
void	db2text_uso		(void);
int		db2text			(char *file_db);

LONG	x4				(void *p);
WORD	x2				(void *p);
BYTE	x1				(void *p);

#endif
