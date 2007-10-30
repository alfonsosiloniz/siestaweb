#!/bin/bash 
# Martin Ostermann, 2005-08-21
# pepper, jotabe, (c) Grupo SIESTA, 29-10-2007
#
# Devolver informacion de fichero crid
# $1 Fichero .crid

# Obtener parametro
Cridfile=$1

# Configurar entorno
source ../www-setup.shi

# Obtener datos canal (numChannel, cid, chID, chName)
file=`basename $Cridfile .crid`
cid=${file: -5}
eval `www-tools infoID ${cid} ${Cache}/info_channels.txt`

# Procesar fichero crid, se usa source para respetar los finales de linea en EPG_long
TMP=${Cache}/crid2xml-$$.tmp
www-tools crid2var ${Cridfile} > $TMP
source $TMP
rm -f $TMP

# Volcar datos xml
echo "<CHANNEL_NAME>$chName</CHANNEL_NAME>
<CRID_FILE>$Cridfile</CRID_FILE>
<TITLE>$Titulo</TITLE>
<REC_STATE>$Rec_State</REC_STATE>
<INIT_TIME>$FMT_start_time</INIT_TIME>
<END_TIME>$FMT_end_time</END_TIME>
<DURATION>$Duration</DURATION>
<UTC_TIME>$EPG_start_time</UTC_TIME>
<SERIE_ID>$IDserie</SERIE_ID>
<IMPORTANT>$Grabacion_protegida</IMPORTANT>
<PLAYBACK_TS>$playback_timestamp</PLAYBACK_TS>
<EPG_SHORT>$EPG_short</EPG_SHORT>
<EPG_LONG>$EPG_long</EPG_LONG>
<NUM_FMPG>$num_fmpg</NUM_FMPG>
<FMPG>$fmpg0</FMPG>"
