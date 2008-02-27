#!/usr/bin/awk -f
# jotabe, (c) Grupo SIESTA, 17-02-2008
#
# Insertar campo <CAMBIO_SERIE> en datos xsl

BEGIN {serie=0; serieAct=0}

{
	# Obtener serie
	pos0=index($0,"<SERIE_ID>")
	if ( pos0 != 0 ) {
		pos0+=10
		pos1=index($0,"</SERIE_ID>")
		if ( pos1 >= pos0 )
			serie=substr($0,pos0,pos1-pos0)
	}

	# comprobar cambio de serie
	cambio_serie=(serie != serieAct) ? 1 : 0

	# Volcar linea datos
	printf("\t\t<RECORD>\n\t\t\t<CAMBIO_SERIE>%i</CAMBIO_SERIE>\n\t\t\t%s\n\t\t</RECORD>\n",cambio_serie,$0)

	# Actualizar serie
	serieAct=serie
}
