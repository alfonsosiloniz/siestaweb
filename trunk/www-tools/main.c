#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#include "main.h"
#include "get-epg-long.h"
#include "db2text.h"
#include "text2xml.h"

/* Definiciones globales */
char *DiaSemana[]={"Dom","Lun","Mar","Mie","Jue","Vie","Sab"};

/* Ejecutable multi-herramienta www-gigaset */
int main(int argc, char *argv[]){
	int print_uso=-1;
	char *cmd=NULL;
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

/*	printf("     CHAR: %02i\n",sizeof(char));
	printf("    SHORT: %02i\n",sizeof(short));
	printf("      INT: %02i\n",sizeof(int));
	printf("     LONG: %02i\n",sizeof(long));
	printf("LONG LONG: %02i\n",sizeof(long long));*/

	/* Inicializar variables */
	resultado=-1;

	/* Comprobar linea de comando */
	if ( strstr(argv[0],"www-tools") == NULL ) {
		/* Invocado como funcion... */
		cmd=argv[0];
		num_par=argc-1;
		if ( argc > 1 ) par1=argv[1];
		if ( argc > 2 ) par2=argv[2];
		if ( argc > 3 ) par3=argv[3];
		if ( argc > 4 ) par4=argv[4];
	} else {
		/* Invocado como xml-tools funcion... */
		if ( argc > 1 ) cmd=argv[1];
		num_par=argc-2;
		if ( argc > 2 ) par1=argv[2];
		if ( argc > 3 ) par2=argv[3];
		if ( argc > 4 ) par3=argv[4];
		if ( argc > 5 ) par4=argv[5];
	}

	/* Comprobar nombre funcion */
	if ( cmd != NULL ) {
/*		printf("%s ",cmd);
		if ( par1 != NULL ) printf("%s ",par1);
		if ( par2 != NULL ) printf("%s ",par2);
		if ( par3 != NULL ) printf("%s ",par3);
		if ( par4 != NULL ) printf("%s ",par4);
		printf("num_par=%i \n",num_par);*/

		if ( ! strcasecmp(cmd,"get-epg-long") ) {
			/* Funcion get-epg-long */
			print_uso=0;
			resultado=-2;
			if ( num_par == 2 ) {
				/* Ejecutar funcion */
				resultado=get_epg_long(par1,strtol(par2,NULL,0));
			} else {
				/* Error parametros funcion */
				fprintf(stderr,"Uso: ");
				get_epg_long_uso();
			}
		} else if ( ! strcasecmp(cmd,"db2text") ) {
			/* Funcion db2text */
			print_uso=0;
			resultado=-2;
			if ( num_par == 1 ) {
				/* Ejecutar funcion */
				resultado=db2text(par1);
			} else {
				/* Error parametros funcion */
				fprintf(stderr,"Uso: ");
				db2text_uso();
			}
		} else if ( ! strcasecmp(cmd,"text2xml") ) {
			/* Funcion text2xml */
			print_uso=0;
			resultado=-2;
			if ( num_par == 2 ) {
				/* Ejecutar funcion */
				resultado=text2xml(par1,par2);
			} else {
				/* Error parametros funcion */
				fprintf(stderr,"Uso: ");
				text2xml_uso();
			}
		} else {
			fprintf(stderr,"Funcion %s no encontrada\n\n",cmd);
		}
	}

	/* Informacion de uso */
	if ( print_uso ) {
		fprintf(stderr,"www-tools v1.00 (2007-05-15)\n\n");
		fprintf(stderr,"  Uso: www-tools [funcion] [argumentos]...\n");
		fprintf(stderr,"    o: funcion [argumentos]...\n\n");
		fprintf(stderr,"Funciones definidas:\n\n");
		get_epg_long_uso();
		fprintf(stderr,"\n\n");
		db2text_uso();
		fprintf(stderr,"\n\n");
		text2xml_uso();
		fprintf(stderr,"\n\n");
	}

	/* Final y resultado */
	#ifdef MS_DOS
	fprintf(stderr,"\n\nResultado: %i\n",resultado);
	system("PAUSE");
	#endif
	return resultado;
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
void sanear_txt(const unsigned char *in, unsigned char *out, long max_lon, long flags){
	int lon=0;

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
		case '&':
			lon+=5;
			in++;
			*out++='&';
			*out++='a';
			*out++='m';
			*out++='p';
			*out++=';';
			break;

		/* '_' -> '-' */
		case '_':
			lon++,in++,*out++='-';
			break;

		/* Eliminar CR/LF */
		case '\x0D':
		case '\x0A':
			if ( flags & FILTRO_CRLF ) {
				in++;
			} else {
				lon++,*out++=*in++;
			}
			break;

		/* 0x8A -> 0x0A */
		case '\x8A':
			if ( flags & FILTRO_8A ) {
				lon++,in++,*out++='\x0A';
			} else {
				lon++,*out++=*in++;
			}
			break;

		default:
			lon++;
			*out++=*in++;
		}
	} while ( (*in != '\x00') & (lon < max_lon) );

	/* Asegurar final string */
	*out='\x00';
}

/* Funcion read_LONG */
LONG read_LONG(FILE *file){
	LONG tmp;

	/* Leer int */
	fread(&tmp,1,4,file);

	#ifdef MS_DOS
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

/* Funcion utc2str */
void utc2str(const long utc_time, char *out){
	struct tm *local_time;
	char tmp[LON_BUF_TXT+1];

	/* Convertir tiempo utc a local */
    local_time=localtime((time_t*)&utc_time);

	/* Obtener fecha en formato deseado*/
	strftime(tmp,LON_BUF_TXT,"%d.%m.%y %H:%M, ",local_time);

	/* Obtener dia de la semana */
	strcat(tmp,DiaSemana[local_time->tm_wday]);

	/* Devolver resultado */
	strcpy(out,tmp);
}
