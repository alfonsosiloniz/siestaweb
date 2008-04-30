#!/bin/bash
# jotabe, (c) Grupo SIESTA, 10-01-2008
#
# Pasar configuracion de siesta-settings.txt a www-settings.txt

# Configurar entorno
LocalBin=/usr/local/bin
source $LocalBin/siesta-setup.sh
FICHERO_WWW_SETTINGS=/var/etc/www-settings.txt

# Enlaces de botones
if [ "Z${SIESTA_LOGIN_HTTP}" = "Zcookie" ]; then
	TIPO_BOTONES="botonesConSalir"
else
	TIPO_BOTONES="botonesSinSalir"
fi
ln -sf ${TIPO_BOTONES}.js $SIESTA_HOME_HTTP/js/botones.js
ln -sf ${TIPO_BOTONES}.xsl $SIESTA_HOME_HTTP/xsl/botones.xsl

# Crear fichero www-settings.txt
cat <<- --EOF-- >$FICHERO_WWW_SETTINGS
Cache=$SIESTA_CACHE_HTTP
EPG_PATH=$SIESTA_EPG_HTTP
LOGIN_HTTP=$SIESTA_LOGIN_HTTP
LOGIN_COOKIE=`echo ${SIESTA_USUARIO_HTTP} | md5sum | cut -d" " -f1`
USUARIO=$SIESTA_USUARIO_HTTP
PAGINA_INICIO_WEB=$SIESTA_PAGINA_INICIO_WEB
MOSTRAR_MINI_IMG=$SIESTA_MOSTRAR_MINI_IMG
OBTENER_IMG_INET=$SIESTA_OBTENER_IMG_INET
DESCARGA_IMG=$SIESTA_ACTIVAR_DESCARGA_IMG
CACHE_EPG_LONG=$SIESTA_CACHE_EPG_LONG
ARCHIVO_GRABACIONES=$SIESTA_RUTA_ARCHIVO
--EOF--
