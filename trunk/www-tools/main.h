/*
 * main.h
 *
 * Definiciones generales xml-tools
 *
 */

#ifndef _MAIN_H_
#define	_MAIN_H_

/* Definiciones de tipos */
typedef unsigned char			BYTE;
typedef unsigned short			WORD;
typedef unsigned long int		LONG;
typedef unsigned long long int	DLONG;

/* Definiciones generales */
#define LBF_PGM			512
#define LBF_TMP			32
#define LBF_TXT			192
#define LBF_TEXTO_LONG	4096
#define LBF_CRID		4096
#define NUM_FMPG		8

/* Estructura datos programa sincroguia */
typedef struct {
	LONG pid;					/* Identificador de programa */
	DLONG pidcid;				/* Identificador de programa y canal */
	int date_utc;				/* Fecha/hora programa (UTC) */
	char date_str[LBF_TXT+1];	/* Fecha/hora programa (formato imprimible) */
	int ix_long;				/* Indice datos descripcion larga */
	BYTE bytesTitulo;			/* Longitud titulo */
	BYTE titulo[LBF_TXT+1];		/* Titulo */
	WORD bytesSubtitulo;		/* Longitud subtitulo */
	BYTE subtitulo[LBF_TXT+1];	/* Subtitulo */
	BYTE bytesImagen;			/* Longitud imagen */
	BYTE imagen[LBF_TXT+1];		/* Imagen */
} pgm_sincro;

/* Estructura datos fragmento de grabacion */
typedef struct {
	long bytesNombre;			/* Longitud nombre fichero de fragmento */
	BYTE Nombre[LBF_TXT+1];		/* Nombre fichero de fragmento */
	long absolute_start_time;	/* Posible comienzo del timeshift */
	DLONG start_timestamp;		/* 90 kHz. Nomalmente 0, otro valor para grabaciones */
								/* con timeshift o grabacion previa del mismo canal */
	DLONG end_timestamp;		/* 90 kHz. 0 con grabacion en curso o apagado */
								/* imprevisto, otro valor con grabacion terminada */
} fmpg_info;

/* Estructura datos grabacion (crid) */
typedef struct {
	long CRID_Version;					/* Siempre 2 */
	DLONG CRID_ID;						/* Identificador unico de crid */
	DLONG CRID_pid;						/* Identificador de programa */
	LONG CRID_cid;						/* Identificador de canal */
	long Rec_State;						/* Estado de la grabacion
											1	Pendiente
											2	Grabando
											3	Grabacion correcta
											4	Error de grabacion
											5	Grabacion cancelada
											8	Conflicto de grabacion
											9	Episodio borrado de serie */
	long EPG_start_time;				/* Fecha/hora inicio (UTC) */
	char FMT_start_time[LBF_TXT+1];		/* Fecha/hora inicio (formato imprimible) */
	long EPG_end_time;					/* Fecha/hora final (UTC) */
	char FMT_end_time[LBF_TXT+1];		/* Fecha/hora final (formato imprimible) */
	int Duration;						/* Duracion programada */
	long user_access_data;				/* No usado, siempre 0 */
	long recording_pre_offset;			/* No usado, siempre -1 */
	long recording_post_offset;			/* No usado, siempre -1 */
	long Rec_Type;						/* Tipo de grabacion
											1	EPG/Sincroguia
											2	Timer
											4	EPG/Sincroguia en serie
											8	Timer en serie
											32	Manual (en directo)*/
	long IDserie;						/* Identificador de serie, valor negativo del timestamp
											del momento de la creacion de la serie */
	short Grabacion_protegida;			/* 0 sin proteger / 1 protegido */
	long bytesTitulo;					/* Longitud titulo */
	BYTE Titulo[LBF_TXT+1];				/* Titulo */
	long num_fmpg;						/* Nº de fragmentos de grabacion (normalmente 1) */
	fmpg_info fmpg[NUM_FMPG];			/* Fragmentos de grabacion (fmpg) */
	long bytesEPG_short;				/* Longitud descripcion corta */
	BYTE EPG_short[LBF_TXT+1];			/* Descripcion corta */
	long bytesEPG_long;					/* Longitud descripcion larga */
	BYTE EPG_long[LBF_TEXTO_LONG+1];	/* Descripcion larga */
	long playback_timestamp;			/* Posicion de visionado */
} crid_info;

/* Flags de sanear_txt */
#define FILTRO_CRLF		0x0001
#define FILTRO_8A		0x0002
#define FILTRO_COMILLAS	0x0004

/* Declaracion funciones */
void	print_version		();
void	print_uso			();

/* Funciones generales */
LONG	read_LONG			(FILE *file);
//WORD	read_WORD			(FILE *file);
//BYTE	read_BYTE			(FILE *file);
size_t	write_LONG			(FILE *file, LONG valor);
size_t	write_WORD			(FILE *file, WORD valor);
DLONG	x8					(void *p);
LONG	x4					(void *p);
WORD	x2					(void *p);
BYTE	x1					(void *p);
void	DLONG2hex			(DLONG x, BYTE *out);
void	DLONG2txt			(DLONG x, BYTE *out);
void	utc2str				(const long utc_time, char *out);
void	sanear_txt			(const BYTE *in, BYTE *out, long max_lon, long flags);
int		eliminarLF			(BYTE *line);
int		lon_campo			(const BYTE *in, BYTE sep);
int		get_pgm				(const BYTE *line, pgm_sincro *pgm);

#endif
