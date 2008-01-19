// Funciones manejo cookies
// (c) Grupo SIESTA, 09-01-2008


//-------------------------------------------------
// Leer valor cookie
//-------------------------------------------------
function getCookie(name) {
	var arg = name + "=";
	var alen = arg.length;
	var clen = document.cookie.length;
	var i = 0;
	while (i < clen) {
		var j = i + alen;
		if (document.cookie.substring(i, j) == arg)
			return getCookieVal (j);
		i = document.cookie.indexOf(" ", i) + 1;
		if (i == 0) break;
	}
	return null;
}

function getCookieVal(offset) {
	var endstr = document.cookie.indexOf (";", offset);
	if (endstr == -1)
		endstr = document.cookie.length;
	return unescape(document.cookie.substring(offset, endstr));
}

//-------------------------------------------------
// Establecer cookie
// name			nombre de la cookie
// value		valor de la cookie
// [expires]	fecha de caducidad de la cookie (por defecto, el final de la sesión)
// [path]		ruta para el cual la cookie es válida (por defecto, el camino del
//				documento que hace la llamada)
// [domain]		dominio para el cual la cookie es válida (por defecto, el dominio del 
//				documento que hace la llamada)
// [secure]		valor booleano que indica si la trasnmisión de la cookie requiere una 
//				transmisión segura
//-------------------------------------------------
function setCookie(name, value, expires, path, domain, secure) {
	document.cookie = name + "=" + escape(value) + 
	((expires == null) ? "" : "; expires=" + expires.toGMTString()) +
	((path == null) ? "" : "; path=" + path) +
	((domain == null) ? "" : "; domain=" + domain) +
	((secure == null) ? "" : "; secure");
}

//-------------------------------------------------
// Borrar cookie
// name			nombre de la cookie
// [path]		ruta de la cookie (debe ser el mismo camino que el 
//				especificado al crear la cookie)
// [domain]		dominio de la cookie (debe ser el mismo dominio que 
//				el especificado al crear la cookie)
//-------------------------------------------------
function deleteCookie(name, path, domain) {
	if (getCookie(name)) {
		document.cookie = name + "=" +
		"; expires=Thu, 01-Jan-70 00:00:01 GMT" +
		((path == null) ? "" : "; path=" + path) +
		((domain == null) ? "" : "; domain=" + domain);
	}
}

//-------------------------------------------------
// Calcular fecha validez cookie
// [minutos]	minutos de validez (60 minutos por defecto)
//-------------------------------------------------
function getExpire(minutos) {
	var caduca = new Date(); 
	if (minutos)
		caduca.setTime(caduca.getTime() + (minutos*60*1000));
	else
		caduca.setTime(caduca.getTime() + (60*60*1000));
	return caduca;
}

//-------------------------------------------------
