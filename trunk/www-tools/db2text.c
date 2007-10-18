#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"
#include "db2text.h"

/* Extraer datos sincroguia desde fichero db y pasarlos a text */

/* Instruuciones de uso */
void db2text_uso(void){
	fprintf(stderr,"db2text IO_ID.db\n");
	fprintf(stderr,"    IO_ID.db        -> Fichero de datos de sincroguia (.db)\n");
}

/* Funcion db2text */
int db2text(char *file_db){
	int resultado;
	FILE *file;
	int totalBytes;			/* Tamaño fichero db */
	int pos;				/* Posicion de lectura en fichero */
	int bytesPgm;			/* Tamaño datos programa */
	int posPgm;				/* Posicion de lectura en programa */
	BYTE bf_in[LBF_PGM];	/* Datos programa sin procesar */
	BYTE txt[LBF_TXT+1];	/* Buffer texto para sanear */
	pgm_sincro pgm;			/* Datos programa */

	/* Inicializar variables */
	resultado=-3;

//	printf("     IO_ID.db: %s\n",file_db);

   	/* Abrir fichero */
	file=fopen(file_db,"rb");
	if ( file == NULL ) {
		fprintf (stderr, "No se puede abrir el fichero %s\n",file_db);
	} else {
		/* Leer tamaño total */
		totalBytes=4+read_LONG(file);

		/* Recorrer datos */
		pos=4;
//		while ( pos < 500 ) {			// Limitar a 500 bytes para pruebas
		while ( pos < totalBytes ) {
			/* Tamaño programa */
			bytesPgm=read_LONG(file);
			pos+=4;

			/* Comprobar si datos programa caben en buffer */
			if ( bytesPgm > LBF_PGM ) break;
			/* Leer datos programa */
			fread(bf_in,1,bytesPgm,file);

			/* Extraer info programa */
			pgm.pid=x4(bf_in);
			pgm.pidcid1=x4(bf_in+4);
			pgm.pidcid2=x4(bf_in+8);
			pgm.date_utc=x4(bf_in+12);
			utc2str(pgm.date_utc,pgm.date_str);
			pgm.ix_long=x4(bf_in+16);

			posPgm=20;
			pgm.bytesTitulo=x1(bf_in+posPgm);
			/* Comprobar si titulo cabe en el buffer */
			if ( pgm.bytesTitulo > LBF_TXT ) break;
			strncpy(txt,bf_in+posPgm+1,pgm.bytesTitulo);
			txt[pgm.bytesTitulo]='\x00';
			sanear_txt(txt,pgm.titulo,LBF_TXT,FILTRO_CRLF);
            posPgm+=1+pgm.bytesTitulo;

			pgm.bytesSubtitulo=x2(bf_in+posPgm);
			/* Comprobar si subtitulo cabe en el buffer */
			if ( pgm.bytesSubtitulo > LBF_TXT ) break;
			strncpy(txt,bf_in+posPgm+2,pgm.bytesSubtitulo);
			txt[pgm.bytesSubtitulo]='\x00';
			sanear_txt(txt,pgm.subtitulo,LBF_TXT,FILTRO_CRLF);
            posPgm+=2+pgm.bytesSubtitulo;

			pgm.bytesImagen=x1(bf_in+posPgm);
			/* Comprobar si imagen cabe en el buffer */
			if ( pgm.bytesImagen > LBF_TXT ) break;
			strncpy(pgm.imagen,bf_in+posPgm+1,pgm.bytesImagen);
			pgm.imagen[pgm.bytesImagen]='\x00';
            posPgm+=1+pgm.bytesImagen+1;

			/* Volcar datos */
//			printf("pos,bytes: %i=0x%04X,%i\n",pos,pos,bytesPgm);
//			printf("pid: %i\n",pgm.pid);
//			printf("pidcid: %08X%08X\n",pgm.pidcid1,pgm.pidcid2);
//			printf("date_utc: %i\n",pgm.date_utc);
//			printf("date_str: %s\n",pgm.date_str);
//			printf("ix_long: %i\n",pgm.ix_long);
//			printf("Titulo: %i,%s\n",pgm.bytesTitulo,pgm.titulo);
//			printf("Subtitulo: %i,%s\n",pgm.bytesSubtitulo,pgm.subtitulo);
//			printf("Imagen: %i,%s\n",pgm.bytesImagen,pgm.imagen);
//			printf("posPgm: %i\n",posPgm);

			/* Generar texto resultado */
			fprintf(stdout,"%i_%i_%08X%08X_%s_%i_%s_%s_%s\n", \
				pgm.date_utc,pgm.pid,pgm.pidcid1,pgm.pidcid2,pgm.date_str, \
				pgm.ix_long,pgm.titulo,pgm.subtitulo,pgm.imagen);

/* En teoria posPgm debe ser igual a bytesPgm, en la practica siempre es      */
/* menor y se debe usar este ultimo valor para avanzar a lo largo del fichero */
/* de datos                                                                   */
			/* Actualizar posicion */
			pos+=bytesPgm;
		}

		/* Cerrar fichero */
		fclose(file);

		/* Comprobar lectura completa de fichero */
		if ( pos != totalBytes ) {
			/* Error en procesado de fichero */
			fprintf (stderr, "Error en procesado de fichero: %s\n",file_db);
			fprintf (stderr, "          Bytes fichero datos: %i\n",totalBytes);
			fprintf (stderr, "             Bytes procesados: %i\n",pos);
			resultado=-4;
		} else {
			/* Final correcto */
			resultado=0;
		}
	}

	return resultado;
}
