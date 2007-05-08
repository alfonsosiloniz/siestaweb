#/bin/bash
if [ $# != 0 ] ; then
	Autor=$1
else
	Autor=unknown
fi
if [ $# == 2 ] ; then
	Expire=$2
else
	Expire=300
fi

cat << header-EOT
 <meta name="author" content="${Autor}">
 <!-- meta http-equiv="expires" content="${Expire}" -->
 <meta http-equiv="content-type" content="text/html;charset=ISO-8859-1">
 <style type="text/css">
	body,img,p { margin 0; padding 0; }

	h2
	{
		color:			#000060;
		font-family:		Arial,Helvetica,san-serif;
		font-size:		120%;
		font-style:		normal;
		font-weight:		bold;
		font-variant:		normal;
		text-align:		left;
		text-decoration:	none;
		margin-top:		1.5em;
		margin-bottom:		0.2em;
		padding:		0 0 0 0;
	}

	p  { margin-top: 1.0ex; }

 </style>
header-EOT
