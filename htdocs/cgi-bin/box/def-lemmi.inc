#!/bin/sh

#--------------------------------------------------

function html_begin()
{
    cat <<- ---EOT---
	Content-type: text/html; charset=iso-8859-1
	Expires: `date -R`

	<html>
	<head>
	<title>$1</title>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="expires" content="1">
	<meta name="author" content="Lemmi @ m740.info/forum">
	<link href="/images/m740.ico" rel="shortcut icon">

	<style type="text/css">
	<!--

	h2, h3
	{
	    color:		#000060;
	    font-family:	Arial,Helvetica,san-serif;
	    font-size:		140%;
	    font-style:		normal;
	    font-weight:	bold;
	    font-variant:	normal;
	    text-align:		left;
	    text-decoration:	none;
	    margin-top:		1.5em;
	    margin-bottom:	0.8em;
	    padding:		0 0 0 0;
	}

	h3 { font-size: 120%; }

	p  { margin-top: 1.0ex; }

	ul, ol
	{
	    margin: 0;
	    padding: 0 0 0 30px;
	}

	li
	{
	    margin-left: 0.2em;
	    margin-top: 0.5em;
	    text-indent: 0.2em;
	}

	tt
	{
	    color:		#000060;
	    font-weight:	bold;
	    font-family:	'Courier New','monospace';
	    padding:		.2em;
	}

	pre, textarea
	{
	    background-color:	#e0e0ff;
	    padding:		.3em;
	}

	.info,.warn,.debug
	{
	    color:		#000000;
	    background-color:	#d0ffd0;
	    border-style:	solid;
	    border-width:	1px;
	    border-color:	#0000a0;
	    padding:		1px 0.3em;
	}

	.warn
	{
	    background-color:	#ffd0d0;
	    border-color:	#a00000;
	}

	.debug
	{
	    background-color:	#ff8000;
	    border-color:	#0000a0;
	}

	-->
	</style>
	</head>

	<body>
	<h1>$1</h1>
	---EOT---
}

#--------------------------------------------------

function html_end()
{
    [[ -f "$1" ]] && file="$1" || file="$0"
    day=`date -r "$file" +%d`
    daynum=$((10#$day))
    month=`date -r "$file" +%m`
    year=`date -r "$file" +%Y`

    case $month in
	01) mname=Januar ;;
	02) mname=Februar ;;
	03) mname=März ;;
	04) mname=April ;;
	05) mname=Mai ;;
	06) mname=Juni ;;
	07) mname=Juli ;;
	08) mname=August ;;
	09) mname=September ;;
	10) mname=Oktober ;;
	11) mname=November ;;
	12) mname=Dezember ;;
	*)  mname=$month
    esac

    cat <<- ---EOT---
	<p><hr><p>
	<div align="left">
	 <a href="/">Regresar al inicio</a>
	</div>
	<div align="right">
	 <a href="http://www.open7x0.org/wiki/Benutzer:Lemmi">Lemmi</a>,
	 <a href="http://de.wikipedia.org/wiki/$daynum._$mname">$year-$month-$day</a>,
	 <a href="http://www.gnu.de/gpl-ger.html">GPL</a>
	</div>
	</body>
	</html>
	---EOT---
}

#--------------------------------------------------

