#!/usr/bin/awk -f
# jotabe, (c) Grupo SIESTA, 17-04-2008
#
# Insertar campo <CAMBIO_SERIE> en datos xsl
# cache		carpeta cache datos
# orden		time/serie

BEGIN {
	serie=0
	serieAct=0
	num_grabaciones=0
	id_orden=9999
	nombre_serie="Sin agrupar"
	INFO_SERIES=cache "/info_series.txt"
	INFO_SERIES_XML=cache "/info_series.xml"
	printf("") > INFO_SERIES
	printf("") > INFO_SERIES_XML
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
		printf("\t\t<SERIE>\n\t\t\t<ID_SERIE>%s</ID_SERIE><NUM_GRABACIONES>%i</NUM_GRABACIONES><NOMBRE_SERIE>%s</NOMBRE_SERIE>\n\t\t</SERIE>\n",serieAct,num_grabaciones,nombre_serie) >> INFO_SERIES_XML

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

	# Orden de registros
	if ( orden == "time" ) {
		# Ordenar por tiempo, ORDEN=UTC_TIME
		pos0=index($0,"<UTC_TIME>")
		if ( pos0 != 0 ) {
			pos0+=10
			pos1=index($0,"</UTC_TIME>")
			if ( pos1 >= pos0 )
				id_orden=substr($0,pos0,pos1-pos0)
		}
	} else {
		# Ordenar por serie, ORDEN=correlativo
		id_orden--	
	}

	# Contador de grabaciones
	num_grabaciones++

	# Volcar linea datos
	printf("\t\t<CRID>\n\t\t\t<CAMBIO_SERIE>%i</CAMBIO_SERIE><ORDEN>%i</ORDEN>\n\t\t\t%s\n\t\t</CRID>\n",cambio_serie,id_orden,$0)
}

END {
	# Completar ultima serie
	printf("%s_%i_%s\n",serieAct,num_grabaciones,nombre_serie) >> INFO_SERIES
	printf("\t\t<SERIE>\n\t\t\t<ID_SERIE>%s</ID_SERIE><NUM_GRABACIONES>%i</NUM_GRABACIONES><NOMBRE_SERIE>%s</NOMBRE_SERIE>\n\t\t</SERIE>\n",serieAct,num_grabaciones,nombre_serie) >> INFO_SERIES_XML
}
