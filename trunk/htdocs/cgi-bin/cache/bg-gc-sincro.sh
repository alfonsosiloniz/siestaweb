#!/bin/bash
# pepper, (c) grupo SIESTA, 24-07-2007
#
# Script que lanza la generaci�n de la cach� de la sincroguia en background

# Configurar entorno
source ../fweb.shi

./gc-sincro.sh &

# Resultado OK
enviar_xml_ok
