// Funciones ajax
// jotabe, (c) Grupo SIESTA, 17-01-2008


//-------------------------------------------------
// Variables de entorno
//-------------------------------------------------
var http_request	= false;	// Objeto XMLHttpRequest
var f_respuestaXML	= "";		// Funcion de respuesta
var f_procesoXML	= "";		// Funcion de procesado

//-------------------------------------------------
// Peticion GET ajax-xml
// p_url				URL del servidor a invocar (resultado en formato XML)
// [p_f_respuestaXML]	Funcion de respuesta a peticion ajax, se ejecuta al terminar el proceso en el servidor
//						Se le pasa un parametro con un objeto http_request.responseXML
// [p_f_procesoXML]		Funcion de procesado en curso, se ejecuta cuando se realiza la peticion al servidor
//-------------------------------------------------
function makeRequest(p_url, p_f_respuestaXML, p_f_procesoXML) {
	// Inicializar variables
	http_request	= false;
	f_respuestaXML	= p_f_respuestaXML;
	f_procesoXML	= p_f_procesoXML;

	// Crear objeto XMLHttpRequest
	if (window.XMLHttpRequest) { // Mozilla, Safari,...
		http_request = new XMLHttpRequest();
		if (http_request.overrideMimeType) {
			http_request.overrideMimeType('text/xml');
		}
	} else if (window.ActiveXObject) { // IE
		try {
			http_request = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
				http_request = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e) {
				http_request = false;
			}
		}
	}

	// Comprobar objeto creado
	if (!http_request) {
		alert('ERROR: No se pudo crear el objeto XMLHTTP');
		return false;
	}

	// Asignar funcion de gestion de eventos
	if (f_respuestaXML != null && f_respuestaXML.length > 0)
		http_request.onreadystatechange = getXML;

	// Añadimos la fecha a la peticion para evitar la caché de los navegadores
	var url_peticion = p_url;
	if (p_url.length > 0) {
		index = p_url.indexOf("?");
		if (index >= 0) {
			url_peticion = p_url + "&TS=" + new Date().getTime();
		} else {
			url_peticion = p_url + "?TS=" + new Date().getTime();
		}
	}
// 	alert(p_url + "\n" + url_peticion);

	// Peticion GET asincrona
	http_request.open('GET', url_peticion, true);
	http_request.send(null);
}

//-------------------------------------------------
// Peticion POST ajax-xml
// p_url				URL del servidor a invocar (resultado en formato XML)
// parameters			parametros a pasar al servidor
// [p_f_respuestaXML]	Funcion de respuesta a peticion ajax, se ejecuta al terminar el proceso en el servidor
//						Se le pasa un parametro con un objeto http_request.responseXML
// [p_f_procesoXML]		Funcion de procesado en curso, se ejecuta cuando se realiza la peticion al servidor
//-------------------------------------------------
function makePostRequest(p_url, parameters, p_f_respuestaXML, p_f_procesoXML) {
	// Inicializar variables
	http_request	= false;
	f_respuestaXML	= p_f_respuestaXML;
	f_procesoXML	= p_f_procesoXML;

	// Crear objeto XMLHttpRequest
	if (window.XMLHttpRequest) { // Mozilla, Safari,...
		http_request = new XMLHttpRequest();
		if (http_request.overrideMimeType) {
			http_request.overrideMimeType('text/xml');
		}
	} else if (window.ActiveXObject) { // IE
		try {
			http_request = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
				http_request = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e) {
				http_request = false;
			}
		}
	}

	// Comprobar objeto creado
	if (!http_request) {
		alert('ERROR: No se pudo crear el objeto XMLHTTP');
		return false;
	}

	// Asignar funcion de gestion de eventos
	if (f_respuestaXML != null && f_respuestaXML.length > 0)
		http_request.onreadystatechange = getXML;

	// Peticion POST asincrona
	http_request.open('POST', p_url, true);
	// Pasar parametro POST
	http_request.setRequestHeader("Content-length", parameters.length);
	http_request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	http_request.send(parameters);
}

//-------------------------------------------------
// Funcion de gestion de eventos
// Estado de objeto XMLHttpRequest
// 0 = sin inicializar
// 1 = cargando
// 2 = cargado
// 3 = interactivo
// 4 = completado
//-------------------------------------------------
function getXML() {
	// Estado cargando
	if (http_request.readyState == 1) {
		if (f_procesoXML != null && f_procesoXML.length > 0)
			eval(f_procesoXML)();
	}
	// Estado completado
	else if (http_request.readyState == 4) {
		// Respuesta HTML 200 OK
		if (http_request.status == 200) {
			// Obtener objeto XML
			var xmldoc = http_request.responseXML;
			eval(f_respuestaXML)(xmldoc);
		}
	}
}

//-------------------------------------------------
// Funciones no usadas
//-------------------------------------------------
// function getFormParameters(form) {
// 	params = "";
// 	for (var i=0; i < form.elements.length; i++) {
// 		if (params.length > 0)
// 			params += "&";
// 		params+= form.elements[i].name + "=";
// 		params+= encodeURI(form.elements[i].value);
// 	}
// 	return params;
// }
//-------------------------------------------------
// function innerXML(startObj,alwaysClosingTag) {
//  var i, collectTags, result="";
// 
//  if(!alwaysClosingTag) { alwaysClosingTag=false; }
// 
//  if(startObj&& startObj.length && startObj[0].parentNode) {
//   collectTags=startObj[0].nodeName;
//    startObj=startObj[0].parentNode
//   }
//  
//   if(startObj&& startObj.childNodes) {
//    for(i=0; i<startObj.childNodes.length; i++) {
//     if(!collectTags || startObj.childNodes[i].nodeName==collectTags) {
//      result+=outerXML(startObj.childNodes[i],alwaysClosingTag);
//     }
//    }
//   }
//   return result;
// }
//-------------------------------------------------
// function outerXML(node,alwaysClosingTag) {
//   var i, result="";
//  
//   if(!alwaysClosingTag) { alwaysClosingTag=false; }
//  
//   switch(node.nodeType) {
//    case 1: // ELEMENT_NODE
//     result+="<"+node.nodeName;
//     for(i=0; i<node.attributes.length; i++) {
//      if(node.attributes.item(i).nodeValue!=null) {
//       result+=' '+node.attributes.item(i).nodeName+'="'+node.attributes.item(i).nodeValue+'"';
//      }
//     }
//  
//     // Leere Elemente ggf. ohne Endtag schliessen (z.B. <br />)
//     if(!node.childNodes.length) {
//      result+=(alwaysClosingTag)?('></'+node.nodeName+'>'):' />';
//     } else {
//      result+='>'+innerXML(node,alwaysClosingTag)+'</'+node.nodeName+'>';
//     }
//     break;
//  
//    case 3: //TEXT_NODE
//     result+=node.nodeValue;
//     break;
//  
//    case 4: // CDATA_SECTION_NODE
//     result+='<![CDATA['+node.nodeValue+']]>';
//     break;
//  
//    case 5: // ENTITY_REFERENCE_NODE
//     result+='&'+node.nodeName+';'
//     break;
//  
//    case 8: // COMMENT_NODE
//     result+='<!--'+node.nodeValue+'-->';
//     break;
//  
//    case 9: // DOCUMENT_NODE
//     if(node.childNodes.length) {
//      result+=innerXML(node,alwaysClosingTag);
//     }
//     break;
//   }
//   return result;
// }
//-------------------------------------------------
// /* Hole Text eines Elements (und seiner Kinder) */
// function innerText(node) {
//   var i, result="";
//  
//   if(node && node.childNodes) {
//    for(i=0; i<node.childNodes.length; i++) {
//     child=node.childNodes.item(i);
//  
//     switch(child.nodeType) {
//      case (1): // ELEMENT_NODE
//      if(child.childNodes.length) {
//       result+=innerText(child);
//      }
//      break;
//  
//      case (3 || 4): //TEXT_NODE + CDATA_SECTION_NODE
//       result+=child.nodeValue;
//       break;
//     }
//  
//    }
//   }
// }
//-------------------------------------------------
// /** 
//  * Funcio que a partir d'un objecte XMLDocument retorna un string amb tot el xml concatenat
//  */
// function getXMLAsString(xmldoc) {
//     return outerXML(xmldoc,true);
// }
//-------------------------------------------------
