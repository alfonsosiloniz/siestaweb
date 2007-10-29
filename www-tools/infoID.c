#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"
#include "infoID.h"

/* Obtener informacion de canal desde info_channels.txt */

/* Instruuciones de uso */
void infoID_uso(void){
	fprintf(stderr,"infoID ID info_channels\n");
	fprintf(stderr,"    ID              -> Identificador de canal a buscar\n");
	fprintf(stderr,"    info_channels   -> Fichero de datos de canales\n");
}

/* Funcion infoID */
int infoID(char *ID, char *file_info){
	int resultado;
	FILE *file;
	int found=0;				/* Marca de programa encontrado */
	BYTE search_ID[LBF_TXT+1];	/* Identificador de busqueda */
	int lon;					/* Tamaño campo a extraer */
	BYTE *posInfo;				/* Posicion de lectura en linea de canal */
	BYTE bf_in[LBF_PGM+1];		/* Linea datos canal */
	BYTE txt[LBF_TXT+1];		/* Buffer texto */
	int ch_num;					/* Nº de canal */
	int ch_cid;					/* cid de canal */
	BYTE ch_ID[LBF_TXT+1];		/* Identificador de canal */
	BYTE ch_Name[LBF_TXT+1];	/* Nombre de canal */

	/* Inicializar variables */
	sprintf(search_ID,":%s:",ID);
	resultado=-3;

//	printf("           ID: %s (%s)\n",ID,search_ID);
//	printf("info_channels: %s\n",file_info);

   	/* Abrir fichero */
	file=fopen(file_info,"rt");
	if ( file == NULL ) {
		fprintf (stderr, "No se puede abrir el fichero %s\n",file_info);
	} else {
		/* Recorrer datos */
		while ( (! found) && (fgets(bf_in,LBF_PGM,file) != NULL) ) {
			/* Eliminar LF al final de la linea */
			eliminarLF(bf_in);

			/* Comprobar ID en linea */
			if ( strstr(bf_in,search_ID) != NULL ) {
				/* Volcar linea */
//				printf("%s\n", bf_in);

				/* Obtener ch_num */
				posInfo=bf_in;
				lon=lon_campo(posInfo,':');
				strncpy(txt,posInfo,lon);
				txt[lon]='\x00';
				sscanf(txt,"%i",&ch_num);

				/* Obtener cid */
				posInfo+=lon+1;
				lon=lon_campo(posInfo,':');
				strncpy(txt,posInfo,lon);
				txt[lon]='\x00';
				sscanf(txt,"%i",&ch_cid);

				/* Obtener ch_ID */
				posInfo+=lon+1;
				lon=lon_campo(posInfo,':');
				strncpy(ch_ID,posInfo,lon);
				ch_ID[lon]='\x00';

				/* Obtener ch_Name */
				posInfo+=lon+1;
				lon=lon_campo(posInfo,':');
				strncpy(ch_Name,posInfo,lon);
				ch_Name[lon]='\x00';

				/* Generar resultado */
				fprintf(stdout,"numChannel=%i\n",ch_num);
				fprintf(stdout,"cid=%i\n",ch_cid);
				fprintf(stdout,"chID=\"%s\"\n",ch_ID);
				fprintf(stdout,"chName=\"%s\"\n",ch_Name);

				/* Terminar busqueda */
				found=-1;
			}
		}

		/* Cerrar fichero */
		fclose(file);

		/* Comprobar encontrado datos canal */
		if ( found ) {
			/* Final correcto */
			resultado=0;
		} else {
			/* Datos no encontrados */
			resultado=-5;
		}
	}

	return resultado;
}
