#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"
#include "text2html.h"

/* Convertir datos sincroguia desde fichero text y pasarlos a html (parrilla) */

/* Instruuciones de uso */
void text2html_uso(void){
	fprintf(stderr,"text2html channel_id cache.ID.text horaUTCinicial mostrar_img\n");
	fprintf(stderr,"    channel_id     -> Identificador de canal\n");
	fprintf(stderr,"    cache.ID.text  -> Fichero de datos de sincroguia (.text)\n");
	fprintf(stderr,"    horaUTCinicial -> Hora UTC comienzo parrilla\n");
	fprintf(stderr,"    mostrar_img    -> 0 = No mostrar imagenes sincroguia\n");
	fprintf(stderr,"                   -> 1 = Mostrar imagenes sincroguia desde HD\n");
	fprintf(stderr,"                   -> 2 = Mostrar imagenes sincroguia desde Internet\n");
}

/* Funcion text2html */
int text2html(char *ch_id, char *file_text, long horaUTCinicio, long mostrar_img){
	int resultado;
	FILE *file;
	int primerPase=0;			/* Marca de primera pasada completada */
	int sync_top=0;				/* Marca de borde superior sincronizado */
	int seg_ajuste=0;			/* Segundos de ajuste */
	char bf_in[LON_BUF_PGM+1];	/* Linea datos programa sin procesar */
	pgm_sincro pgm0;			/* Datos programa anterior */
	pgm_sincro pgm1;			/* Datos programa actual */
	int duration;
	int height;
	char html[LON_BUF_TEXTO_LONG+1];	/* Buffer html */
	char txt[LON_BUF_TEXTO_LONG+1];		/* Buffer html */
	char img[LON_BUF_TXT+1];			/* Buffer url imagen */

	/* Inicializar variables */
	resultado=-3;

//	printf("    channel_id: %s\n",ch_id);
//	printf(" cache.ID.text: %s\n",file_text);
//	printf("horaUTCinicial: %li\n",horaUTCinicio);
//	printf("   mostrar_img: %li\n",mostrar_img);

   	/* Abrir fichero */
	file=fopen(file_text,"rt");
	if ( file == NULL ) {
		fprintf (stderr, "No se puede abrir el fichero %s\n",file_text);
	} else {
		/* Recorrer datos */
		while ( fgets(bf_in,LON_BUF_PGM,file) != NULL ) {
			/* Eliminar LF al final de la linea */
			eliminarLF(bf_in);

			/* Obtener programa contenido en linea */
			if ( get_pgm(bf_in,&pgm1) ) {
				/* Saltar primera linea */
				if ( primerPase ) {
					/* Comprobar comienzo programa mayor que horaUTCinicio */
					if ( pgm0.date_utc >= horaUTCinicio ) {
						/* Sincronizar con parrilla general el primer programa del canal */
						if ( ! sync_top ) {
							/* Calcular duracion de la sincronizacion + ajuste */
							duration=pgm0.date_utc-horaUTCinicio+seg_ajuste;
							/* Altura celda ajuste */
							height=(duration*PORCENTAJE_ALTURA)/100;
							/* Calcular ajuste */
							seg_ajuste=duration-((height*100)/PORCENTAJE_ALTURA);
							/* Celda de ajuste */
							if ( height > 0 ) {
//								printf("duration: %i\n",duration);
//								printf("height: %i\n",height);
//								printf("seg_ajuste: %i\n",seg_ajuste);
								fprintf(stdout,"<tr height=\"%i\">\n\t<td background=\"/img/capa6.gif\" class=\"borderFila txtMuyPeq\"></td>\n</tr>\n",height);
							}
							/* Marca de parrilla sincronizada */
                            sync_top=-1;
						}

						/* Calcular duracion del programa + ajuste */
						duration=pgm1.date_utc-pgm0.date_utc+seg_ajuste;

						/* Los programas de duracion inferior a 2,5 minutos, no caben en la parrilla */
						if ( duration < 150 ) {
							/* Se pasa la duracion del programa como ajuste para el siguiente */
							seg_ajuste=duration;
						} else {
							/* Calcular tamaño de la celda segun duracion del programa
							Cada minuto son 2.4 pixeles, por lo que se calcula tambien el
							tiempo de ajuste que corresponde a la parte decimal de los
							pìxeles para añadirlo al siguiente programa */
							height=(duration*PORCENTAJE_ALTURA)/100;
							seg_ajuste=duration-((height*100)/PORCENTAJE_ALTURA);

							/* Tamaño celda */
							fprintf(stdout,"<tr height=\"%i\">\n",height);

							/* Tamaño del texto segun duracion del programa */
							if ( duration < 600 ) {
								fprintf(stdout,"\t<td class=\"borderFila txtMuyPeq\" align=\"center\">\n");
							} else if ( duration < 1800 ) {
								fprintf(stdout,"\t<td class=\"borderFila txtPeq\" align=\"center\">\n");
							} else {
								fprintf(stdout,"\t<td class=\"borderFila txtNormal\" align=\"center\">\n");
							}

							/* Obtenemos contenido celda */
                            *html='\x00';

							/* Botones de grabacion */
							if ( duration > 2200 ) {
								sprintf(txt,"\t\t<a href='javascript:programarGrabacion(\"%08X%08X\", 0, \"%s\")' title=\"Grabar\"><img src=\"/img/red_ball.gif\" alt=\"Grabar\" width=\"18\" height=\"18\" border=\"0\"></a>&nbsp;\n",pgm0.pidcid1,pgm0.pidcid2,pgm0.titulo);
								strcat(html,txt);
								sprintf(txt,"\t\t<a href='javascript:programarGrabacion(\"%08X%08X\", 1, \"%s\")' title=\"Grabar en Serie\"><img src=\"/img/blue_ball.gif\" alt=\"Grabar en Serie\" width=\"18\" height=\"18\" border=\"0\"></a><br>\n",pgm0.pidcid1,pgm0.pidcid2,pgm0.titulo);
								strcat(html,txt);
							}

							/* Fecha-Hora del programa */
							if ( duration >= 1500 ) {
								sprintf(txt,"\t\t%s<br>\n",pgm0.date_str);
								strcat(html,txt);
							}

							/* Imagen. Por la noche HD apagado -> poner enlace a internet */
							if ( (duration > 3060) && (mostrar_img != 0) ) {
								if ( strlen(pgm0.imagen) != 0 ) {
									/* Comprobar si obtener imagen de internet */
									if ( mostrar_img == 2 ) {
										sprintf(img,"http://www.inout.tv/fotos/%s",pgm0.imagen);
									} else {
										sprintf(img,"/img/epg/%s",pgm0.imagen);
									}
								} else {
									sprintf(img,"/img/epg_long_img.png");
								}
								sprintf(txt,"\t\t<a href=\"javascript:detallePrograma('%08X%08X', '%s', '%i', '%s', '%i');\" title=\"%s - %s - %s\"><img src=\"%s\" width=77 height=52 border=2 alt=\"%s - %s - %s\"></a><br>\n",pgm0.pidcid1,pgm0.pidcid2,pgm0.imagen,pgm0.ix_long,ch_id,pgm0.date_utc,ch_id,pgm0.date_str,pgm0.titulo,img,ch_id,pgm0.date_str,pgm0.titulo);
								strcat(html,txt);
							}

							/* Nombre programa */
							sprintf(txt,"\t\t<a href=\"javascript:detallePrograma('%08X%08X', '%s', '%i', '%s', '%i');\" title=\"%s - %s - %s\">%s</a>",pgm0.pidcid1,pgm0.pidcid2,pgm0.imagen,pgm0.ix_long,ch_id,pgm0.date_utc,ch_id,pgm0.date_str,pgm0.titulo,pgm0.titulo);
							strcat(html,txt);

							/* Volcar celda */
							fprintf(stdout,"%s\n",html);

							/* Si el programa es muuuuy largo (más de 4 horas), ponemos la info 2 veces (a petición de Shark) */
							if ( duration >= 14400 ) {
								/* Separacion */
								fprintf(stdout,"\t\t<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>");
								if ( duration >= 18000 ) fprintf(stdout,"<br><br><br><br><br>");
								if ( duration > 36000 ) fprintf(stdout,"<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>");
								fprintf(stdout,"\n");
								/* Repetir contenido celda */
								fprintf(stdout,"%s\n",html);
							}

							/* Final programa */
							fprintf(stdout,"\t</td>\n</tr>\n");
						}
					}
				} else {
					primerPase=-1;
				}

				/* Guardar datos programa anterior */
				memcpy(&pgm0,&pgm1,sizeof(pgm_sincro));

				/* Generar xml resultado */
/*				fprintf(stdout,"<PROGRAM id=\"%i\" pid=\"%08X%08X\" chid=\"%s\">\n", \
					pgm.pid,pgm.pidcid1,pgm.pidcid2,ch_id);
				fprintf(stdout,"\t<TITLE>%s</TITLE>\n",pgm.titulo);
				fprintf(stdout,"\t<SUBTITLE>%s</SUBTITLE>\n",pgm.subtitulo);
				fprintf(stdout,"\t<LONG>%i</LONG>\n",pgm.ix_long);
				fprintf(stdout,"\t<IMAGE>%s</IMAGE>\n",pgm.imagen);
				fprintf(stdout,"\t<DATE>%s</DATE>\n",pgm.date_str);
				fprintf(stdout,"\t<DATE_UTC>%i</DATE_UTC>\n",pgm.date_utc);
				fprintf(stdout,"\t<DATE_FIN></DATE_FIN>\n");
				fprintf(stdout,"</PROGRAM>\n");*/
			}
		}

		/* Cerrar fichero */
		fclose(file);

		/* Final correcto */
		resultado=0;
	}

	return resultado;
}
