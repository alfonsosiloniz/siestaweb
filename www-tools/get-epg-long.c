#include <stdio.h>
#include <stdlib.h>

#include "main.h"
#include "get-epg-long.h"

/* Obtencion texto largo de EPG */

/* Instruuciones de uso */
void get_epg_long_uso(void){
	fprintf(stderr,"get-epg-long EPGLong_ID.txt Desplazamiento\n");
	fprintf(stderr,"    EPGLong_ID.txt  -> Fichero de descripciones largas\n");
	fprintf(stderr,"    Desplazamiento  -> Desplazamiento en bytes del inicio de la descripcion\n");
}

/* Funcion get_epg_long */
int get_epg_long(char *fichero, long inicio){
	int resultado;
	FILE *file;
	BYTE txt_in[LBF_TEXTO_LONG+1];		/* Buffer texto para sanear */
	BYTE txt_out[LBF_TEXTO_LONG*2+1];	/* Texto saneado */

	/* Inicializar variables */
	resultado=-3;
	*txt_in='\x00';
	*txt_out='\x00';

//	printf("EPGLong_ID.txt: %s\n",fichero);
//	printf("Desplazamiento: %i\n",inicio);

   	/* Abrir fichero */
	file=fopen(fichero,"rb");
	if ( file == NULL ) {
		fprintf (stderr, "No se puede abrir el fichero %s\n",fichero);
	} else {
		/* Saltar inicio, leer bufer y cerrar fichero */
		fseek(file,inicio,SEEK_SET);
		fread(txt_in,1,LBF_TEXTO_LONG,file);
		fclose(file);

		/* Procesar caracteres especiales */
		sanear_txt(txt_in,txt_out,LBF_TEXTO_LONG*2,FILTRO_8A);

		/* Generar texto resultado */
		fprintf(stdout,"%s",txt_out);

		/* Final correcto */
		resultado=0;
	}

	return resultado;
}
