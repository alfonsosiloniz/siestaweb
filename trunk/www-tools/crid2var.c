#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"
#include "crid2var.h"

/* Obtener informacion de fichero crid */

/* Instruuciones de uso */
void crid2var_uso(void){
	fprintf(stderr,"crid2var fichero.crid [prefijo]\n");
	fprintf(stderr,"    fichero.crid    -> Fichero crid\n");
	fprintf(stderr,"    prefijo         -> Prefijo de linea, normalmente export\n");
}

/* Funcion crid2var */
int crid2var(char *file_crid, const char *prefijo){
	int resultado;
	FILE *file;
	char pre_lin[LBF_TXT+1];	/* Prefijo a utilizar */
	int bytesCrid;				/* Tamaño datos crid */
	int posCrid;				/* Posicion de lectura en crid */
	int n;						/* Contador fragmentos de grabacion */
	BYTE bf_in[LBF_CRID];		/* Datos crid sin procesar */
	BYTE txt[LBF_TEXTO_LONG+1];	/* Buffer texto para sanear */
	crid_info crid;				/* Datos crid */

	/* Inicializar variables */
	resultado=-3;
	if ( strlen(prefijo) != 0 && strlen(prefijo) < LBF_TXT ) {
		strcpy(pre_lin,prefijo);
		strcat(pre_lin," ");
	} else {
		pre_lin[0]='\x00';
	}

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
			crid.CRID_ID=x8(bf_in+4);
			crid.CRID_pid=crid.CRID_ID/100000LL;
			crid.CRID_cid=crid.CRID_ID%100000LL;
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
			crid.Grabacion_protegida=x2(bf_in+44);

			/* Titulo */
			posCrid=46;
			crid.bytesTitulo=x4(bf_in+posCrid);
			posCrid+=4;
			/* Comprobar si titulo cabe en el buffer */
			if ( crid.bytesTitulo > LBF_TXT ) {
				sprintf(txt,"## Sin titulo ##");
			} else {
				strncpy(txt,bf_in+posCrid,crid.bytesTitulo);
				txt[crid.bytesTitulo]='\x00';
			}
			sanear_txt(txt,crid.Titulo,LBF_TXT,FILTRO_CRLF);
			posCrid+=crid.bytesTitulo;

			/* nº de fragmentos de grabacion */
			crid.num_fmpg=x4(bf_in+posCrid);
			posCrid+=4;

			/* Volcar datos */
//			printf("         CRID_Version: %li\n",crid.CRID_Version);
//			DLONG2txt(crid.CRID_ID,txt);
//			printf("              CRID_ID: %s\n",txt);
//			DLONG2txt(crid.CRID_pid,txt);
//			printf("             CRID_pid: %s\n",txt);
//			printf("             CRID_cid: %li\n",crid.CRID_cid);
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
//			printf("  Grabacion_protegida: %i\n",crid.Grabacion_protegida);
//			printf("          bytesTitulo: %li\n",crid.bytesTitulo);
//			printf("               Titulo: %s\n",crid.Titulo);
//			printf("             num_fmpg: %li\n",crid.num_fmpg);

			/*-- 2ª seccion, fragmentos de grabacion (.fmpg)----*/
			for(n=0;n<crid.num_fmpg;n++) {
				/* Nombre de fichero */
				crid.fmpg[n].bytesNombre=x4(bf_in+posCrid);
				posCrid+=4;
				/* Comprobar si nombre de fichero cabe en el buffer */
				if ( crid.fmpg[n].bytesNombre > LBF_TXT ) {
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
				/* Los valores start_timestamp y end_timestamp se */
				/* almacenan en el fichero .crid como valores a 90kHz */
				crid.fmpg[n].start_timestamp=x8(bf_in+posCrid)/90000LL;
				posCrid+=8;
				crid.fmpg[n].end_timestamp=x8(bf_in+posCrid)/90000LL;
				posCrid+=8;

				/* Volcar datos */
//				printf("        bytesNombre[%02i]: %li\n",n,crid.fmpg[n].bytesNombre);
//				printf("             Nombre[%02i]: %s\n",n,crid.fmpg[n].Nombre);
//				printf("absolute_start_time[%02i]: %li\n",n,crid.fmpg[n].absolute_start_time);
//				DLONG2txt(crid.fmpg[n].start_timestamp,txt);
//				printf("    start_timestamp[%02i]: %s\n",n,txt);
//				DLONG2txt(crid.fmpg[n].end_timestamp,txt);
//				printf("      end_timestamp[%02i]: %s\n",n,txt);
			}

			/*-- 3ª seccion, datos EPG/Sincroguia --------------*/
			/* EPG_short */
			crid.bytesEPG_short=x4(bf_in+posCrid);
			posCrid+=4;
			/* Comprobar si descripcion corta cabe en el buffer */
			if ( crid.bytesEPG_short > LBF_TXT ) {
				sprintf(txt,"## Sin EPG_short ##");
			} else {
				strncpy(txt,bf_in+posCrid,crid.bytesEPG_short);
				txt[crid.bytesEPG_short]='\x00';
			}
			sanear_txt(txt,crid.EPG_short,LBF_TXT,FILTRO_CRLF|FILTRO_COMILLAS);
			posCrid+=crid.bytesEPG_short;

			/* EPG_long */
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

			/* Posicion visionado */
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
				fprintf(stdout,"%sCRID_Version=%li\n",pre_lin,crid.CRID_Version);
				DLONG2txt(crid.CRID_ID,txt);
				fprintf(stdout,"%sCRID_ID=%s\n",pre_lin,txt);
				DLONG2txt(crid.CRID_pid,txt);
				fprintf(stdout,"%sCRID_pid=%s\n",pre_lin,txt);
				fprintf(stdout,"%sCRID_cid=%li\n",pre_lin,crid.CRID_cid);
				fprintf(stdout,"%sRec_State=%li\n",pre_lin,crid.Rec_State);
				fprintf(stdout,"%sEPG_start_time=%li\n",pre_lin,crid.EPG_start_time);
				fprintf(stdout,"%sFMT_start_time=\"%s\"\n",pre_lin,crid.FMT_start_time);
				fprintf(stdout,"%sEPG_end_time=%li\n",pre_lin,crid.EPG_end_time);
				fprintf(stdout,"%sFMT_end_time=\"%s\"\n",pre_lin,crid.FMT_end_time);
				fprintf(stdout,"%sDuration=%i\n",pre_lin,crid.Duration);
				fprintf(stdout,"%suser_access_data=%li\n",pre_lin,crid.user_access_data);
				fprintf(stdout,"%srecording_pre_offset=%li\n",pre_lin,crid.recording_pre_offset);
				fprintf(stdout,"%srecording_post_offset=%li\n",pre_lin,crid.recording_post_offset);
				fprintf(stdout,"%sRec_Type=%li\n",pre_lin,crid.Rec_Type);
				fprintf(stdout,"%sIDserie=%li\n",pre_lin,crid.IDserie);
				fprintf(stdout,"%sGrabacion_protegida=%i\n",pre_lin,crid.Grabacion_protegida);
				fprintf(stdout,"%sTitulo=\"%s\"\n",pre_lin,crid.Titulo);
				fprintf(stdout,"%snum_fmpg=%li\n",pre_lin,crid.num_fmpg);
				for(n=0;n<crid.num_fmpg;n++) {
					fprintf(stdout,"%sfmpg%i=\"%s\"\n",pre_lin,n,crid.fmpg[n].Nombre);
					fprintf(stdout,"%sfmpg%i_absolute_start_time=%li\n",pre_lin,n,crid.fmpg[n].absolute_start_time);
					DLONG2txt(crid.fmpg[n].start_timestamp,txt);
					fprintf(stdout,"%sfmpg%i_start_timestamp=%s\n",pre_lin,n,txt);
					DLONG2txt(crid.fmpg[n].end_timestamp,txt);
					fprintf(stdout,"%sfmpg%i_end_timestamp=%s\n",pre_lin,n,txt);
				}
				fprintf(stdout,"%sEPG_short=\"%s\"\n",pre_lin,crid.EPG_short);
				fprintf(stdout,"%sEPG_long=\"%s\"\n",pre_lin,crid.EPG_long);
				fprintf(stdout,"%splayback_timestamp=%li\n",pre_lin,crid.playback_timestamp);

				/* Final correcto */
				resultado=0;
			}
		}

		/* Cerrar fichero */
		fclose(file);
	}

	return resultado;
}
