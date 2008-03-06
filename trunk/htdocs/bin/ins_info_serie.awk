#!/usr/bin/awk -f
# jotabe, (c) Grupo SIESTA, 17-02-2008
#
# Insertar campo <CAMBIO_SERIE> en datos xsl
# cache		carpeta cache datos

BEGIN {
	serie=0
	serieAct=0
	num_grabaciones=0
	nombre_serie="Sin agrupar"
	INFO_SERIES=cache "/info_series.txt"
	printf("") > INFO_SERIES
}

{
	# Obtener serie
	pos0=index($0,"<SERIE_ID>")
	if ( pos0 != 0 ) {
		pos0+=10
		pos1=index($0,"</SERIE_ID>")
		if ( pos1 >= pos0 )
			serie=substr($0,pos0,pos1-pos0)
	}

	# Comprobar cambio de serie
	cambio_serie=(serie != serieAct) ? 1 : 0
	if ( cambio_serie == 1) {
		# Guardar datos serie actual
		printf("%s_%i_%s\n",serieAct,num_grabaciones,nombre_serie) >> INFO_SERIES

		# Nueva serie
		serieAct=serie
		num_grabaciones=0
		pos0=index($0,"<TITLE>")
		if ( pos0 != 0 ) {
			pos0+=7
			pos1=index($0,"</TITLE>")
			if ( pos1 >= pos0 )
				nombre_serie=substr($0,pos0,pos1-pos0)
		}
	}

	# Contador de grabaciones
	num_grabaciones++

	# Volcar linea datos
	printf("\t\t<RECORD>\n\t\t\t<CAMBIO_SERIE>%i</CAMBIO_SERIE>\n\t\t\t%s\n\t\t</RECORD>\n",cambio_serie,$0)
}

END {
	# Completar ultima serie
	printf("%s_%i_%s\n",serieAct,num_grabaciones,nombre_serie) >> INFO_SERIES
}
