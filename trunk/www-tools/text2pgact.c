#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"
#include "text2pgact.h"

/* Obtener programa actual desde fichero text, resultado en XML */

/* Instruuciones de uso */
void text2pgact_uso(void){
	fprintf(stderr,"text2pgact cache.ID.text horaUTC\n");
	fprintf(stderr,"    channel_id      -> Identificador de canal\n");
	fprintf(stderr,"    cache.ID.text   -> Fichero de datos de sincroguia (.text)\n");
	fprintf(stderr,"    horaUTC         -> Hora UTC programa actual\n");
}

/* Funcion text2pgact */
int text2pgact(char *ch_id, char *file_text, long horaUTC){
	int resultado;
	FILE *file;
	int found=0;			/* Marca de programa encontrado */
	int primerPase=0;		/* Marca de primera pasada completada */
	char bf_in[LBF_PGM+1];	/* Linea datos programa sin procesar */
	BYTE tmp[LBF_TMP+1];	/* Buffer temporal pidcid */
	pgm_sincro pgm0;		/* Datos programa anterior */
	pgm_sincro pgm1;		/* Datos programa actual */

	/* Inicializar variables */
	resultado=-3;

//	printf("   channel_id: %s\n",ch_id);
//	printf("cache.ID.text: %s\n",file_text);
//	printf("      horaUTC: %li\n",horaUTC);

	/* Abrir fichero */
	file=fopen(file_text,"rt");
	if ( file == NULL ) {
		fprintf (stderr, "No se puede abrir el fichero %s\n",file_text);
	} else {
		/* Recorrer datos */
		while ( (! found) && (fgets(bf_in,LBF_PGM,file) != NULL) ) {
			/* Eliminar LF al final de la linea */
			eliminarLF(bf_in);

			/* Obtener programa contenido en linea */
			if ( get_pgm(bf_in,&pgm1) ) {
				/* Saltar primera linea */
				if ( primerPase ) {
					/* Volcar datos */
//					printf("pid: %i\n",pgm0.pid);
//					printf("date_utc: %i\n",pgm0.date_utc);
//					printf("date_str: %s\n",pgm0.date_str);
//					printf("Titulo: %i,%s\n",pgm0.bytesTitulo,pgm0.titulo);

					/* Comprobar comienzo programa mayor que horaUTC */
					if ( pgm1.date_utc > horaUTC ) {
						/* Generar xml resultado */
						DLONG2txt(pgm0.pidcid,tmp);
						fprintf(stdout,"<PROGRAM pid=\"%li\" pidcid=\"%s\" chID=\"%s\">\n",pgm0.pid,tmp,ch_id);
						fprintf(stdout,"\t<TITLE>%s</TITLE>\n",pgm0.titulo);
						fprintf(stdout,"\t<SUBTITLE>%s</SUBTITLE>\n",pgm0.subtitulo);
						fprintf(stdout,"\t<LONG>%i</LONG>\n",pgm0.ix_long);
						fprintf(stdout,"\t<IMAGE>%s</IMAGE>\n",pgm0.imagen);
						fprintf(stdout,"\t<DATE>%s</DATE>\n",pgm0.date_str);
						fprintf(stdout,"\t<DATE_UTC>%i</DATE_UTC>\n",pgm0.date_utc);
						fprintf(stdout,"\t<DATE_FIN>%s</DATE_FIN>\n",pgm1.date_str);
						fprintf(stdout,"</PROGRAM>\n");

						/* Terminar busqueda */
						found=-1;
					}
				} else {
					primerPase=-1;
				}

				/* Guardar datos programa anterior */
				memcpy(&pgm0,&pgm1,sizeof(pgm_sincro));
			}
		}

		/* Cerrar fichero */
		fclose(file);

		/* Final correcto */
		resultado=0;
	}

	return resultado;
}
