#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#include "main.h"
#include "get-epg-long.h"
#include "db2text.h"
#include "text2xml.h"
#include "text2html.h"
#include "text2pgact.h"
#include "infoID.h"
#include "crid2var.h"

/* Definiciones globales */
char *DiaSemana[]={"Dom","Lun","Mar","Mie","Jue","Vie","Sab"};

/* Ejecutable multi-herramienta www-gigaset */
int main(int argc, char *argv[]){
	char *func=NULL;
	int print_funciones=-1;
	int num_par;
	char *par1=NULL;
	char *par2=NULL;
	char *par3=NULL;
	char *par4=NULL;
	int resultado;	/*  0 = resultado correcto */
					/* -1 = funcion no encontrada */
					/* -2 = parametros incorrectos */
					/* -3 = fichero no encontrado */
					/* -4 = error en procesado de fichero */
					/* -5 = datos no encontrados */

//	printf("     CHAR: %02i\n",sizeof(char));
//	printf("    SHORT: %02i\n",sizeof(short));
//	printf("      INT: %02i\n",sizeof(int));
//	printf("     LONG: %02i\n",sizeof(long int));
//	printf("LONG LONG: %02i\n",sizeof(long long int));

	/* Inicializar variables */
	resultado=-1;

	/* Comprobar linea de comando */
	if ( strstr(argv[0],"www-tools") == NULL ) {
		/* Invocado como funcion... */
		func=argv[0];
		num_par=argc-1;
		if ( argc > 1 ) par1=argv[1];
		if ( argc > 2 ) par2=argv[2];
		if ( argc > 3 ) par3=argv[3];
		if ( argc > 4 ) par4=argv[4];
	} else {
		/* Invocado como xml-tools funcion... */
		if ( argc > 1 ) func=argv[1];
		num_par=argc-2;
		if ( argc > 2 ) par1=argv[2];
		if ( argc > 3 ) par2=argv[3];
		if ( argc > 4 ) par3=argv[4];
		if ( argc > 5 ) par4=argv[5];
	}

	/* Comprobar funcion */
	if ( func != NULL ) {
		/* No imprimir funciones */
		print_funciones=0;
		/* Comprobar nombre funcion */
		if ( ! strcasecmp(func,"get-epg-long") ) {
			/* Funcion get-epg-long */
			resultado=-2;
			if ( num_par == 2 ) {
				/* Ejecutar funcion */
				resultado=get_epg_long(par1,strtol(par2,NULL,0));
			} else {
				/* Error parametros funcion */
				print_version();
				fprintf(stderr,"Uso: ");
				get_epg_long_uso();
			}
		} else if ( ! strcasecmp(func,"db2text") ) {
			/* Funcion db2text */
			resultado=-2;
			if ( num_par == 1 ) {
				/* Ejecutar funcion */
				resultado=db2text(par1);
			} else {
				/* Error parametros funcion */
				print_version();
				fprintf(stderr,"Uso: ");
				db2text_uso();
			}
		} else if ( ! strcasecmp(func,"text2xml") ) {
			/* Funcion text2xml */
			resultado=-2;
			if ( num_par == 2 ) {
				/* Ejecutar funcion */
				resultado=text2xml(par1,par2);
			} else {
				/* Error parametros funcion */
				print_version();
				fprintf(stderr,"Uso: ");
				text2xml_uso();
			}
		} else if ( ! strcasecmp(func,"text2html") ) {
			/* Funcion text2html */
			resultado=-2;
			if ( num_par == 4 ) {
				/* Ejecutar funcion */
				resultado=text2html(par1,par2,strtol(par3,NULL,0),strtol(par4,NULL,0));
			} else {
				/* Error parametros funcion */
				print_version();
				fprintf(stderr,"Uso: ");
				text2html_uso();
			}
		} else if ( ! strcasecmp(func,"text2pgact") ) {
			/* Funcion text2pgact */
			resultado=-2;
			if ( num_par == 3 ) {
				/* Ejecutar funcion */
				resultado=text2pgact(par1,par2,strtol(par3,NULL,0));
			} else {
				/* Error parametros funcion */
				print_version();
				fprintf(stderr,"Uso: ");
				text2pgact_uso();
			}
		} else if ( ! strcasecmp(func,"infoID") ) {
			/* Funcion infoID */
			resultado=-2;
			if ( num_par == 2 ) {
				/* Ejecutar funcion */
				resultado=infoID(par1,par2);
			} else {
				/* Error parametros funcion */
				print_version();
				fprintf(stderr,"Uso: ");
				infoID_uso();
			}
		} else if ( ! strcasecmp(func,"crid2var") ) {
			/* Funcion crid2var */
			resultado=-2;
			if ( num_par == 1 ) {
				/* Ejecutar funcion */
				resultado=crid2var(par1);
			} else {
				/* Error parametros funcion */
				print_version();
				fprintf(stderr,"Uso: ");
				crid2var_uso();
			}
		} else {
			print_version();
			print_uso();
			fprintf(stderr,"Funcion %s no encontrada\n\n",func);
		}
	}

	/* Informacion de funciones incluidas */
	if ( print_funciones ) {
		print_version();
		print_uso();
		fprintf(stderr,"Funciones definidas:\n\n");
		get_epg_long_uso();
		fprintf(stderr,"\n");
		db2text_uso();
		fprintf(stderr,"\n");
		text2xml_uso();
		fprintf(stderr,"\n");
		text2html_uso();
		fprintf(stderr,"\n");
		text2pgact_uso();
		fprintf(stderr,"\n");
		infoID_uso();
		fprintf(stderr,"\n");
		crid2var_uso();
		fprintf(stderr,"\n");
	}

	/* Final y resultado */
	#ifdef MS_DOS
	fprintf(stderr,"\n\nResultado: %i\n",resultado);
	system("PAUSE");
	#endif
	return resultado;
}

/* Imprimir version aplicacion */
void print_version(){
	fprintf(stderr,"www-tools v1.14b (2007-11-18)\n\n");
}

/* Imprimir uso de aplicacion */
void print_uso(){
	fprintf(stderr,"  Uso: www-tools [funcion] [argumentos] ...\n");
	fprintf(stderr,"    o: funcion [argumentos] ...\n\n");
}


/**************************************/
/*  Funciones generales               */
/**************************************/

/* Funcion read_LONG */
LONG read_LONG(FILE *file){
	LONG tmp;

	/* Leer int */
	fread(&tmp,1,4,file);

	#ifdef BINi386
	/* Convertir de mips a intel */
	int b1,b2,b3,b4;

	b1=(tmp&0xFF000000)>>24;
	b2=(tmp&0x00FF0000)>>16;
	b3=(tmp&0x0000FF00)>>8;
	b4=(tmp&0x000000FF);
	tmp=(((b4*256+b3)*256+b2)*256)+b1;
	#endif

	return tmp;
}

/* Funcion read_WORD */

/* Funcion read_BYTE */

/* Funcion x4 */
LONG x4(void *p){
	LONG tmp;

	/* Leer int */
	tmp=*(LONG *)p;

	#ifdef BINi386
	/* Convertir de mips a intel */
	int b1,b2,b3,b4;

	b1=(tmp&0xFF000000)>>24;
	b2=(tmp&0x00FF0000)>>16;
	b3=(tmp&0x0000FF00)>>8;
	b4=(tmp&0x000000FF);
	tmp=(((b4*256+b3)*256+b2)*256)+b1;
	#endif

	return tmp;
}

/* Funcion x2 */
WORD x2(void *p){
	WORD tmp;

	/* Leer short */
	tmp=*(WORD *)p;

	#ifdef BINi386
	/* Convertir de mips a intel */
	int b1,b2;

	b1=(tmp&0xFF00)>>8;
	b2=(tmp&0x00FF);
	tmp=(b2*256)+b1;
	#endif

	return tmp;
}

/* Funcion x1 */
BYTE x1(void *p){
	BYTE tmp;

	/* Leer char */
	tmp=*(BYTE *)p;

	return tmp;
}

/* Funcion utc2str */
void utc2str(const long utc_time, char *out){
	struct tm *local_time;
	char tmp[LBF_TXT+1];

	/* Convertir tiempo utc a local */
    local_time=localtime((time_t*)&utc_time);

	/* Obtener fecha en formato deseado*/
	strftime(tmp,LBF_TXT,"%d.%m.%y %H:%M, ",local_time);

	/* Obtener dia de la semana */
	strcat(tmp,DiaSemana[local_time->tm_wday]);

	/* Devolver resultado */
	strcpy(out,tmp);
}

/* Funcion sanear_txt.
Elimina codigo de tabla de caracteres (primer byte).
Sustituciones:
	'&'    -> '&amp'
	'_'    -> '-'

flags:
	0x0001 -> Eliminar CR/LF
	0x0002 -> Sustituir 0x8A por 0x0A
*/
void sanear_txt(const BYTE *in, BYTE *out, long max_lon, long flags){
	int lon=0;

	/* Comprobar si cadena de entrada es cadena vacia */
	if ( *in != '\x00' ) {
		/* Comprobar primer caracter con codigo de tabla de caracteres */
		if ( *in <= '\x1F' ) {
			/* Comprobar si es codigo extendido para saltar 2 posiciones mas*/
			if ( *in == '\x10' ) in+=2;

			/* Saltar codigo de tabla de caracteres */
			in++;
		}

		/* Recorrer entrada */
		do {
			switch (*in) {
			/* '&' -> '&amp;' */
			case (BYTE)'&':
				lon+=5;
				in++;
				*out++='&';
				*out++='a';
				*out++='m';
				*out++='p';
				*out++=';';
				break;

			/* '_' -> '-' */
			case (BYTE)'_':
				lon++,in++,*out++='-';
				break;

			/* Eliminar CR/LF */
			case (BYTE)'\x0D':
			case (BYTE)'\x0A':
				if ( flags & FILTRO_CRLF ) {
					in++;
				} else {
					lon++,*out++=*in++;
				}
				break;

			/* 0x8A -> 0x0A */
			case (BYTE)'\x8A':
				if ( flags & FILTRO_8A ) {
					lon++,in++,*out++='\x0A';
				} else {
					lon++,*out++=*in++;
				}
				break;

			/* '"' -> '\"' */
			case (BYTE)'"':
				if ( flags & FILTRO_COMILLAS ) lon++,*out++='\\';
				lon++,*out++=*in++;
				break;

			default:
				lon++,*out++=*in++;
			}
		} while ( (*in != '\x00') && (lon < max_lon) );
	}

	/* Asegurar final string */
	*out='\x00';
}

/* Funcion eliminarLF */
int eliminarLF(BYTE *line){
	int lon;			/* Longitud linea */

	/* Eliminar LF al final de la linea */
	lon=strlen(line)-1;
	while ( (lon >= 0) && (*(line+lon) == (BYTE)'\x0A') ) {
		*(line+lon--)='\x00';
	}

	return lon;
}

/* Funcion lon_campo */
int lon_campo(const BYTE *in, BYTE sep){
	BYTE *fin_campo;

	/* Buscar separador */
	fin_campo=strchr(in,sep);

	/* Obtener longitud campo */
	return (int)(fin_campo-in);
}

/* Funcion get_pgm */
int get_pgm(const BYTE *line, pgm_sincro *pgm){
	const BYTE *posPgm;		/* Posicion de lectura en linea de programa */
	int lon;				/* Tamaño campo a extraer */
	BYTE txt[LBF_TXT+1];	/* Buffer texto */

	/* Comprobar contenido linea */
	if ( strlen(line) > 0 ) {
		/* Obtener date_utc */
		posPgm=line;
		lon=lon_campo(posPgm,'_');
		strncpy(txt,posPgm,lon);
		txt[lon]='\x00';
		sscanf(txt,"%i",&pgm->date_utc);

		/* Obtener pid */
		posPgm+=lon+1;
		lon=lon_campo(posPgm,'_');
		strncpy(txt,posPgm,lon);
		txt[lon]='\x00';
		sscanf(txt,"%i",&pgm->pid);

		/* Obtener pidcid */
		posPgm+=lon+1;
		lon=lon_campo(posPgm,'_');
		strncpy(txt,posPgm,lon);
		txt[lon]='\x00';
		sscanf(txt,"%08X%08X",&pgm->pidcid1,&pgm->pidcid2);

		/* Obtener date_str */
		posPgm+=lon+1;
		lon=lon_campo(posPgm,'_');
		strncpy(pgm->date_str,posPgm,lon);
		pgm->date_str[lon]='\x00';

		/* Obtener ix_long */
		posPgm+=lon+1;
		lon=lon_campo(posPgm,'_');
		strncpy(txt,posPgm,lon);
		txt[lon]='\x00';
		sscanf(txt,"%i",&pgm->ix_long);

		/* Obtener titulo */
		posPgm+=lon+1;
		lon=lon_campo(posPgm,'_');
		strncpy(pgm->titulo,posPgm,lon);
		pgm->titulo[lon]='\x00';
		pgm->bytesTitulo=lon;

		/* Obtener subtitulo */
		posPgm+=lon+1;
		lon=lon_campo(posPgm,'_');
		strncpy(pgm->subtitulo,posPgm,lon);
		pgm->subtitulo[lon]='\x00';
		pgm->bytesSubtitulo=lon;

		/* Obtener imagen */
		posPgm+=lon+1;
		lon=strlen(posPgm);
		strncpy(pgm->imagen,posPgm,lon);
		pgm->imagen[lon]='\x00';
		pgm->bytesImagen=lon;

		/* Volcar datos */
//		printf("lin: %i,%s\n",strlen(line),line);
//		printf("pid: %i\n",pgm->pid);
//		printf("pidcid: %08X%08X\n",pgm->pidcid1,pgm->pidcid2);
//		printf("date_utc: %i\n",pgm->date_utc);
//		printf("date_str: %s\n",pgm->date_str);
//		printf("ix_long: %i\n",pgm->ix_long);
//		printf("Titulo: %i,%s\n",pgm->bytesTitulo,pgm->titulo);
//		printf("Subtitulo: %i,%s\n",pgm->bytesSubtitulo,pgm->subtitulo);
//		printf("Imagen: %i,%s\n",pgm->bytesImagen,pgm->imagen);

		/* Linea procesada correctamente */
		return -1;
	} else {
		/* Linea no procesada */
		return 0;
	}
}
