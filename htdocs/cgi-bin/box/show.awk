#!/bin/awk -f
#
# Lemmi @ m740.info/forum, 2005-08-22 -> GPL
#
# $9 == "."	{ next }

		{ img="unknown"; idx=9 }
 $1 ~ /^l/	{ img="link" }
 $1 ~ /^d/	{ img="dir" }
 $1 ~ /^b/	{ img="block-dev"; idx=10 }
 $1 ~ /^c/	{ img="char-dev"; idx=10 }
 $9 == ".."	{ img="dirup"; }

    {	name = substr($0,57);
	pos  = index(name,$idx)+56;
	info = substr($0,1,pos-1);
	name = substr($0,pos);
	if ( img == "link" )
	{
	    pos = index(name," -> ");
	    if ( pos > 0 )
	    {
		n1 = substr(name,1,pos-1);
		n2 = substr(name,pos+4);
		# Die folgende Zeile ist identisch mit unten
		printf("<img src=\"/sincro/img/%s.png\" alt=\"%s\"> ",img,img);
		printf("%s<a href=\"%s/%s\">%s</a> -> <a href=\"%s/%s\">%s</a>\n",
			info,uri,n1,n1,ENVIRON["SCRIPT_NAME"],n2,n2);
		next;
	    }
	}

	#if ( $1~ /^-/ )
	    printf("<a href=\"%s/%s?send\" title=\"Open/Download %s\"><img src=\"/sincro/img/%s.png\" alt=\"%s\" border=0></a> ",uri,name,name,img,img);
	#else
	#    printf("<img src=\"/sincro/img/%s.png\" alt=\"%s\"> ",img,img);

	#printf("|%u|%s|%s|\n",pos,info,name);
	printf("%s<a href=\"%s/%s\">%s</a>\n",info,uri,name,name);
    }
