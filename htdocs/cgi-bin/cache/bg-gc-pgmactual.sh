#!/bin/bash
# pepper, (c) grupo SIESTA, 24-07-2007
#
# Script que lanza la generación de la caché de programa actual en background

# Configurar entorno
source ../fweb.shi

./gc-pgmactual.sh &

# Resultado OK
enviar_xml_ok
