#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"
#include "db2text.h"
#include "text2xml.h"

/* Convertir datos sincroguia desde fichero text y pasarlos a xml */

/* Instruuciones de uso */
void text2xml_uso(void){
	fprintf(stderr,"text2xml channel_id cache.ID.text\n\n");
	fprintf(stderr,"    channel_id    -> Identificador de canal\n");
	fprintf(stderr,"    cache.ID.text -> Fichero de datos de sincroguia (.text)\n");
}

/* Funcion text2xml */
int text2xml(char *ch_id, char *file_text){
	int resultado;
	FILE *file;
	int posPgm;					/* Posicion de lectura en linea de programa */
	int lon;                    /* Tamaño campo a extraer */
	char bf_in[LON_BUF_PGM+1];	/* Linea datos programa sin procesar */
	char txt[LON_BUF_TXT+1];	/* Buffer texto */
	pgm_sincro pgm;				/* Datos programa */

	/* Inicializar variables */
	resultado=-3;

//	printf("   channel_id: %s\n",ch_id);
//	printf("     IO_ID.db: %s\n",file_text);

   	/* Abrir fichero */
	file=fopen(file_text,"rt");
	if ( file==NULL ){
		fprintf (stderr, "No se puede abrir el fichero %s\n",file_text);
	} else {
		/* Recorrer datos */
//		fgets(bf_in,LON_BUF_PGM,file); {
		while (fgets(bf_in,LON_BUF_PGM,file)!=NULL){
			/* Obtener date_utc */
			posPgm=0;
			lon=lon_campo(bf_in+posPgm);
			strncpy(txt,bf_in+posPgm,lon);
			txt[lon]='\x00';
			sscanf(txt,"%i",&pgm.date_utc);
//			printf("lon: %i\n",lon);

			/* Obtener pid */
			posPgm+=lon+1;
			lon=lon_campo(bf_in+posPgm);
			strncpy(txt,bf_in+posPgm,lon);
			txt[lon]='\x00';
			sscanf(txt,"%i",&pgm.pid);
//			printf("lon: %i\n",lon);

			/* Obtener pidcid */
			posPgm+=lon+1;
			lon=lon_campo(bf_in+posPgm);
			strncpy(txt,bf_in+posPgm,lon);
			txt[lon]='\x00';
			sscanf(txt,"%08X%08X",&pgm.pidcid1,&pgm.pidcid2);
//			printf("lon: %i\n",lon);

			/* Obtener date_str */
			posPgm+=lon+1;
			lon=lon_campo(bf_in+posPgm);
			strncpy(pgm.date_str,bf_in+posPgm,lon);
			pgm.date_str[lon]='\x00';
//			printf("lon: %i\n",lon);

			/* Obtener ix_long */
			posPgm+=lon+1;
			lon=lon_campo(bf_in+posPgm);
			strncpy(txt,bf_in+posPgm,lon);
			txt[lon]='\x00';
			sscanf(txt,"%i",&pgm.ix_long);
//			printf("lon: %i\n",lon);

			/* Obtener titulo */
			posPgm+=lon+1;
			lon=lon_campo(bf_in+posPgm);
			strncpy(pgm.titulo,bf_in+posPgm,lon);
			pgm.titulo[lon]='\x00';
//			printf("lon: %i\n",lon);

			/* Obtener subtitulo */
			posPgm+=lon+1;
			lon=lon_campo(bf_in+posPgm);
			strncpy(pgm.subtitulo,bf_in+posPgm,lon);
			pgm.subtitulo[lon]='\x00';
//			printf("lon: %i\n",lon);

			/* Obtener imagen */
			posPgm+=lon+1;
			lon=strlen(bf_in+posPgm)-1;
			strncpy(pgm.imagen,bf_in+posPgm,lon);
			pgm.imagen[lon]='\x00';
//			printf("lon: %i\n",lon);

//			printf("c: %c\n",*(bf_in+posPgm));

			/* Volcar datos */
//			printf("lin: %i,%s\n",strlen(bf_in),bf_in);
//			printf("pid: %i\n",pgm.pid);
//			printf("pidcid: %08X%08X\n",pgm.pidcid1,pgm.pidcid2);
//			printf("date_utc: %i\n",pgm.date_utc);
//			printf("date_str: %s\n",pgm.date_str);
//			printf("ix_long: %i\n",pgm.ix_long);
//			printf("Titulo: %i,%s\n",pgm.bytesTitulo,pgm.titulo);
//			printf("Subtitulo: %i,%s\n",pgm.bytesSubtitulo,pgm.subtitulo);
//			printf("Imagen: %i,%s\n",pgm.bytesImagen,pgm.imagen);

			/* Generar xml resultado */
			fprintf(stdout,"<PROGRAM id=\"%i\" pid=\"%08X%08X\" chid=\"%s\">\n", \
				pgm.pid,pgm.pidcid1,pgm.pidcid2,ch_id);
			fprintf(stdout,"\t<TITLE>%s</TITLE>\n",pgm.titulo);
			fprintf(stdout,"\t<SUBTITLE>%s</SUBTITLE>\n",pgm.subtitulo);
			fprintf(stdout,"\t<LONG>%i</LONG>\n",pgm.ix_long);
			fprintf(stdout,"\t<IMAGE>%s</IMAGE>\n",pgm.imagen);
			fprintf(stdout,"\t<DATE>%s</DATE>\n",pgm.date_str);
			fprintf(stdout,"\t<DATE_UTC>%i</DATE_UTC>\n",pgm.date_utc);
			fprintf(stdout,"\t<DATE_FIN></DATE_FIN>\n");
			fprintf(stdout,"</PROGRAM>\n");
		}

		/* Cerrar fichero */
		fclose(file);

		/* Final correcto */
		resultado=0;
	}

	return resultado;
}

/* Funcion lon_campo */
int lon_campo(const unsigned char *in){
	int lon;
	unsigned char *fin_campo;

	/* Buscar separador */
	fin_campo=strchr(in,'_');

	/* Obtener longitud campo */
	lon=(int)(fin_campo-in);

	return lon;
}
