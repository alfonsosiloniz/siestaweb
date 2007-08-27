// Funcion que devuelve un parametro pasado en la url entre paginas html
function getparam(param_name, url) {
	if (url == null)
		url=document.location.href;
	index = url.indexOf("?");
	if (index >= 0) {
		paramsStr = url.substring(index+1);
		var params = paramsStr.split("&");
		for(i=0; i < params.length; ++i) {
		var param = params[i].split("=");
		if (param[0].toLowerCase() == param_name.toLowerCase()) {
			if (param.length == 2)
				return param[1];
			else
				return null;
			}
		}
	}
	return null;
}
