#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"
#include "crid2var.h"

/* Obtener informacion de fichero crid */

/* Instruuciones de uso */
void crid2var_uso(void){
	fprintf(stderr,"crid2var fichero.crid\n");
	fprintf(stderr,"    fichero.crid    -> Fichero crid\n");
}

/* Funcion crid2var */
int crid2var(char *file_crid){
	int resultado;
	FILE *file;
	int bytesCrid;				/* Tamaño datos crid */
	int posCrid;				/* Posicion de lectura en crid */
	int n;						/* Contador fragmentos de grabacion */
	BYTE bf_in[LBF_CRID];		/* Datos crid sin procesar */
	BYTE txt[LBF_TEXTO_LONG+1];	/* Buffer texto para sanear */
	crid_info crid;				/* Datos crid */

	/* Inicializar variables */
	resultado=-3;

//	printf("  fichero.crid: %s\n",file_crid);

   	/* Abrir fichero */
	file=fopen(file_crid,"rb");
	if ( file == NULL ) {
		fprintf (stderr, "No se puede abrir el fichero %s\n",file_crid);
	} else {
		/* Obtener tamaño fichero */
		fseek( file,0,SEEK_END);
		bytesCrid=ftell(file);
		fseek( file,0,SEEK_SET);
//		printf("Tamaño fichero: %i (Max %i)\n",bytesCrid,LBF_CRID);

		/* Comprobar si datos programa caben en buffer */
		if ( bytesCrid > LBF_CRID ) {
			/* Error en procesado de fichero */
			fprintf (stderr, "Error en procesado de fichero: %s\n",file_crid);
			fprintf (stderr, "          Bytes fichero datos: %i\n",bytesCrid);
			resultado=-4;
		} else {
			/* Leer datos crid */
			fread(bf_in,1,bytesCrid,file);

			/*-- 1ª seccion ------------------------------------*/
			/* Identificador y estado */
			crid.CRID_Version=x4(bf_in);
			crid.CRID_ID1=x4(bf_in+4);
			crid.CRID_ID2=x4(bf_in+8);
			crid.Rec_State=x4(bf_in+12);

			/* Inicio, final y duracion */
			crid.EPG_start_time=x4(bf_in+16);
			utc2str(crid.EPG_start_time,crid.FMT_start_time);
			crid.EPG_end_time=x4(bf_in+20);
			utc2str(crid.EPG_end_time,crid.FMT_end_time);
			crid.Duration=(crid.EPG_end_time-crid.EPG_start_time)/60;

			/* No usados */
			crid.user_access_data=x4(bf_in+24);
			crid.recording_pre_offset=x4(bf_in+28);
			crid.recording_post_offset=x4(bf_in+32);

			/* Tipo de grabacion, identificador serie y marca protegido */
			crid.Rec_Type=x4(bf_in+36);
			crid.IDserie=x4(bf_in+40);
			crid.Grabacion_protegida=x4(bf_in+44);

			/* Obtener titulo */
			posCrid=46;
			crid.bytesTitulo=x4(bf_in+posCrid);
			posCrid+=4;
			/* Comprobar si titulo cabe en el buffer */
			if ( crid.bytesTitulo > LBF_TEXTO_LONG ) {
				sprintf(txt,"## Sin titulo ##");
            } else {
				strncpy(txt,bf_in+posCrid,crid.bytesTitulo);
				txt[crid.bytesTitulo]='\x00';
			}
			sanear_txt(txt,crid.Titulo,LBF_TXT,FILTRO_CRLF);
			posCrid+=crid.bytesTitulo;

			/* Obtener nº de fragmentos de grabacion */
			crid.num_fmpg=x4(bf_in+posCrid);
			posCrid+=4;

			/* Volcar datos */
//			printf("         CRID_Version: %li\n",crid.CRID_Version);
//			printf("              CRID_ID: 0x%08lX%08lX\n",crid.CRID_ID1,crid.CRID_ID2);
//			printf("            Rec_State: %li\n",crid.Rec_State);
//			printf("       EPG_start_time: %li\n",crid.EPG_start_time);
//			printf("       FMT_start_time: %s\n",crid.FMT_start_time);
//			printf("         EPG_end_time: %li\n",crid.EPG_end_time);
//			printf("         FMT_end_time: %s\n",crid.FMT_end_time);
//			printf("             Duration: %i\n",crid.Duration);
//			printf("     user_access_data: %li\n",crid.user_access_data);
//			printf(" recording_pre_offset: %li\n",crid.recording_pre_offset);
//			printf("recording_post_offset: %li\n",crid.recording_post_offset);
//			printf("             Rec_Type: %li\n",crid.Rec_Type);
//			printf("              IDserie: %li\n",crid.IDserie);
//			printf("  Grabacion_protegida: %li\n",crid.Grabacion_protegida);
//			printf("          bytesTitulo: %li\n",crid.bytesTitulo);
//			printf("               Titulo: %s\n",crid.Titulo);
//			printf("             num_fmpg: %li\n",crid.num_fmpg);

			/*-- 2ª seccion, fragmentos de grabacion (.fmpg)----*/
			for(n=0;n<crid.num_fmpg;n++) {
				/* Obtener nombre de fichero */
				crid.fmpg[n].bytesNombre=x4(bf_in+posCrid);
				posCrid+=4;
				/* Comprobar si nombre de fichero cabe en el buffer */
				if ( crid.fmpg[n].bytesNombre > LBF_TEXTO_LONG ) {
					sprintf(txt,"## Sin fichero ##");
	            } else {
					strncpy(txt,bf_in+posCrid,crid.fmpg[n].bytesNombre);
					txt[crid.fmpg[n].bytesNombre]='\x00';
				}
				strcpy(crid.fmpg[n].Nombre,txt);
				posCrid+=crid.fmpg[n].bytesNombre;

				/* Datos de fragmento */
				crid.fmpg[n].absolute_start_time=x4(bf_in+posCrid);
				posCrid+=4;
				crid.fmpg[n].start_timestamp1=x4(bf_in+posCrid);
				posCrid+=4;
				crid.fmpg[n].start_timestamp2=x4(bf_in+posCrid);
				posCrid+=4;
				crid.fmpg[n].end_timestamp1=x4(bf_in+posCrid);
				posCrid+=4;
				crid.fmpg[n].end_timestamp2=x4(bf_in+posCrid);
				posCrid+=4;

				/* Volcar datos */
//				printf("        bytesNombre[%02i]: %li\n",n,crid.fmpg[n].bytesNombre);
//				printf("             Nombre[%02i]: %s\n",n,crid.fmpg[n].Nombre);
//				printf("absolute_start_time[%02i]: %li\n",n,crid.fmpg[n].absolute_start_time);
//				printf("    start_timestamp[%02i]: 0x%08lX%08lX\n",n,crid.fmpg[n].start_timestamp1,crid.fmpg[n].start_timestamp2);
//				printf("      end_timestamp[%02i]: 0x%08lX%08lX\n",n,crid.fmpg[n].end_timestamp1,crid.fmpg[n].end_timestamp2);
			}

			/*-- 3ª seccion, datos EPG/Sincroguia --------------*/
			/* Obtener EPG_short */
			crid.bytesEPG_short=x4(bf_in+posCrid);
			posCrid+=4;
			/* Comprobar si descripcion corta cabe en el buffer */
			if ( crid.bytesEPG_short > LBF_TEXTO_LONG ) {
				sprintf(txt,"## Sin EPG_short ##");
            } else {
				strncpy(txt,bf_in+posCrid,crid.bytesEPG_short);
				txt[crid.bytesEPG_short]='\x00';
			}
			sanear_txt(txt,crid.EPG_short,LBF_TXT,FILTRO_CRLF|FILTRO_COMILLAS);
			posCrid+=crid.bytesEPG_short;

			/* Obtener EPG_long */
			crid.bytesEPG_long=x4(bf_in+posCrid);
			posCrid+=4;
			/* Comprobar si descripcion larga cabe en el buffer */
			if ( crid.bytesEPG_long > LBF_TEXTO_LONG ) {
				sprintf(txt,"## Sin EPG_long ##");
            } else {
				strncpy(txt,bf_in+posCrid,crid.bytesEPG_long);
				txt[crid.bytesEPG_long]='\x00';
			}
			sanear_txt(txt,crid.EPG_long,LBF_TEXTO_LONG,FILTRO_8A|FILTRO_COMILLAS);
			posCrid+=crid.bytesEPG_long;

			/* Obtener posicion visionado */
			crid.playback_timestamp=x4(bf_in+posCrid);
			posCrid+=4;

			/* Volcar datos */
//			printf("       bytesEPG_short: %li\n",crid.bytesEPG_short);
//			printf("            EPG_short: %s\n",crid.EPG_short);
//			printf("        bytesEPG_long: %li\n",crid.bytesEPG_long);
//			printf("             EPG_long: %s\n",crid.EPG_long);
//			printf("   playback_timestamp: %li\n",crid.playback_timestamp);

			/* Comprobar lectura completa de fichero */
			if ( posCrid != bytesCrid ) {
				/* Error en procesado de fichero */
				fprintf (stderr, "Error en procesado de fichero: %s\n",file_crid);
				fprintf (stderr, "          Bytes fichero datos: %i\n",bytesCrid);
				fprintf (stderr, "             Bytes procesados: %i\n",posCrid);
				resultado=-4;
			} else {
				/* Generar resultado */
				fprintf(stdout,"CRID_Version=%li\n",crid.CRID_Version);
				fprintf(stdout,"CRID_ID=%08lX%08lX\n",crid.CRID_ID1,crid.CRID_ID2);
				fprintf(stdout,"Rec_State=%li\n",crid.Rec_State);
				fprintf(stdout,"EPG_start_time=%li\n",crid.EPG_start_time);
				fprintf(stdout,"FMT_start_time=\"%s\"\n",crid.FMT_start_time);
				fprintf(stdout,"EPG_end_time=%li\n",crid.EPG_end_time);
				fprintf(stdout,"FMT_end_time=\"%s\"\n",crid.FMT_end_time);
				fprintf(stdout,"Duration=%i\n",crid.Duration);
				fprintf(stdout,"user_access_data=%li\n",crid.user_access_data);
				fprintf(stdout,"recording_pre_offset=%li\n",crid.recording_pre_offset);
				fprintf(stdout,"recording_post_offset=%li\n",crid.recording_post_offset);
				fprintf(stdout,"Rec_Type=%li\n",crid.Rec_Type);
				fprintf(stdout,"IDserie=%li\n",crid.IDserie);
				fprintf(stdout,"Grabacion_protegida=%li\n",crid.Grabacion_protegida);
				fprintf(stdout,"Titulo=\"%s\"\n",crid.Titulo);
				fprintf(stdout,"num_fmpg=%li\n",crid.num_fmpg);
				for(n=0;n<crid.num_fmpg;n++) {
					fprintf(stdout,"fmpg%i=\"%s\"\n",n,crid.fmpg[n].Nombre);
					fprintf(stdout,"fmpg%i_absolute_start_time=%li\n",n,crid.fmpg[n].absolute_start_time);
					fprintf(stdout,"fmpg%i_start_timestamp=%08lX%08lX\n",n,crid.fmpg[n].start_timestamp1,crid.fmpg[n].start_timestamp2);
					fprintf(stdout,"fmpg%i_end_timestamp=%08lX%08lX\n",n,crid.fmpg[n].end_timestamp1,crid.fmpg[n].end_timestamp2);
				}
				fprintf(stdout,"EPG_short=\"%s\"\n",crid.EPG_short);
				fprintf(stdout,"EPG_long=\"%s\"\n",crid.EPG_long);
				fprintf(stdout,"playback_timestamp=%li\n",crid.playback_timestamp);

				/* Final correcto */
				resultado=0;
			}
		}

		/* Cerrar fichero */
		fclose(file);
	}

	return resultado;
}
