#!/bin/bash
# (c) Grupo SIESTA, 27-11-2007
#
# Poner permisos correctos en servidor web

# Funciones
function ch_www () {
	for file in $*; do
		echo "--> Eliminar svn: $file"
		find $file | grep .svn | awk '{print "rm -rf "$0}' | sh
		echo "--> Permisos (644): $file"
		[ -e $file ] && chown -R root.root $file
		[ -e $file ] && chmod -R 644 $file
		[ -d $file ] && chmod 755 $file
	done
}
function ch_exe () {
	echo "--> Permisos (755): $*"
	for file in $*; do
		[ -e $file ] && chown -R root.root $file
		[ -e $file ] && chmod -R 755 $file
	done
}
function ch_dir () {
	echo "--> Permisos (755): $*"
	for file in $*; do
		[ -d $file ] && chmod 755 $file
	done
}

# Configurar entorno
SIESTA_HOME_HTTP=.

# Regularizar permisos
echo "--> Regularizar permisos $SIESTA_HOME_HTTP"
ch_www $SIESTA_HOME_HTTP
ch_exe $SIESTA_HOME_HTTP/bin
ch_dir $SIESTA_HOME_HTTP/cfg
ch_exe $SIESTA_HOME_HTTP/cgi-bin
ch_dir $SIESTA_HOME_HTTP/css
ch_dir $SIESTA_HOME_HTTP/html
ch_dir $SIESTA_HOME_HTTP/img
ch_dir $SIESTA_HOME_HTTP/img/tv
ch_dir $SIESTA_HOME_HTTP/js
ch_dir $SIESTA_HOME_HTTP/util
ch_dir $SIESTA_HOME_HTTP/xsl
ch_exe $SIESTA_HOME_HTTP/unix.sh
