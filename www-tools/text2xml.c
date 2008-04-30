#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"
#include "text2xml.h"

/* Convertir datos sincroguia desde fichero text y pasarlos a xml */

/* Instruuciones de uso */
void text2xml_uso(void){
	fprintf(stderr,"text2xml channel_id cache.ID.text\n");
	fprintf(stderr,"    channel_id      -> Identificador de canal\n");
	fprintf(stderr,"    cache.ID.text   -> Fichero de datos de sincroguia (.text)\n");
}

/* Funcion text2xml */
int text2xml(char *ch_id, char *file_text){
	int resultado;
	FILE *file;
	BYTE bf_in[LBF_PGM+1];	/* Linea datos programa sin procesar */
	BYTE tmp[LBF_TMP+1];	/* Buffer temporal pidcid */
	pgm_sincro pgm;			/* Datos programa */

	/* Inicializar variables */
	resultado=-3;

//	printf("   channel_id: %s\n",ch_id);
//	printf("cache.ID.text: %s\n",file_text);

	/* Abrir fichero */
	file=fopen(file_text,"rt");
	if ( file == NULL ) {
		fprintf (stderr, "No se puede abrir el fichero %s\n",file_text);
	} else {
		/* Recorrer datos */
//		fgets(bf_in,LON_BUF_PGM,file); {	// Solo primera linea para pruebas
		while ( fgets(bf_in,LBF_PGM,file) != NULL ) {
			/* Eliminar LF al final de la linea */
			eliminarLF(bf_in);

			/* Obtener programa contenido en linea */
			if ( get_pgm(bf_in,&pgm) ) {
				/* Generar xml resultado */
				DLONG2txt(pgm.pidcid,tmp);
				fprintf(stdout,"<PROGRAM pid=\"%li\" pidcid=\"%s\" chID=\"%s\">\n",pgm.pid,tmp,ch_id);
				fprintf(stdout,"\t<TITLE>%s</TITLE>\n",pgm.titulo);
				fprintf(stdout,"\t<SUBTITLE>%s</SUBTITLE>\n",pgm.subtitulo);
				fprintf(stdout,"\t<LONG>%i</LONG>\n",pgm.ix_long);
				fprintf(stdout,"\t<IMAGE>%s</IMAGE>\n",pgm.imagen);
				fprintf(stdout,"\t<DATE>%s</DATE>\n",pgm.date_str);
				fprintf(stdout,"\t<DATE_UTC>%i</DATE_UTC>\n",pgm.date_utc);
				fprintf(stdout,"\t<DATE_FIN></DATE_FIN>\n");
				fprintf(stdout,"</PROGRAM>\n");
			}
		}

		/* Cerrar fichero */
		fclose(file);

		/* Final correcto */
		resultado=0;
	}

	return resultado;
}
