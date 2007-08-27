var http_request = false;
var funcio_parse_XML = "";
var funcio_procesando = "";

function getXML() {
	if (http_request.readyState == 1) {
		if (funcio_procesando != null && funcio_procesando.length > 0)
			eval(funcio_procesando)();
	}
	else if (http_request.readyState == 4) {
		if (http_request.status == 200) {
			var xmldoc = http_request.responseXML;
			eval(funcio_parse_XML)(xmldoc);
		}
	}
}

/*
 * Funcio a invocar per fer la crida al servidor
 *
 * Parametres :
 *
 *  p_url : URL del servidor a invocar (ha de retornar el resultat en format XML)
 *  p_funcio_parse_XML : funcio jscript que es cridara un cop executada la peticio al servidor. Aquesta funcio ha d'estar definida dins de la pagina html que fa la crida
 *  			 La funcio rebra un objecte que conte el xml de resposta (XMLDocument http_request.responseXML)
 *
*/
function makeRequest(p_url, p_funcio_parse_XML, p_funcio_procesando) {
	http_request = false;
	funcio_parse_XML = p_funcio_parse_XML;
    funcio_procesando = p_funcio_procesando;
	
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
	
	if (!http_request) {
	    alert('ERROR :( Cannot create an XMLHTTP instance');
	    return false;
	}
	http_request.onreadystatechange = getXML;
	http_request.open('GET', p_url, true);
	http_request.send(null);
}

function makePostRequest(p_url, p_funcio_parse_XML, parameters, p_funcio_procesando) {
	http_request = false;
	funcio_parse_XML = p_funcio_parse_XML;
    funcio_procesando = p_funcio_procesando;
	
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
	        } catch (e) {}
	    }
	}
	
	if (!http_request) {
	    alert('ERROR :( Cannot create an XMLHTTP instance');
	    return false;
	}
	http_request.onreadystatechange = getXML;
	http_request.open('POST', p_url, true);
    http_request.setRequestHeader("Content-length", parameters.length);
    http_request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	http_request.send(parameters);
}

function getFormParameters(form) {
    params = "";
    for (var i=0; i < form.elements.length; i++) {
        if (params.length > 0)
            params += "&";
        params+= form.elements[i].name + "=";
        params+= encodeURI(form.elements[i].value);
    }
    return params;
}

function innerXML(startObj,alwaysClosingTag) {
 var i, collectTags, result="";

 if(!alwaysClosingTag) { alwaysClosingTag=false; }

 if(startObj&& startObj.length && startObj[0].parentNode) {
  collectTags=startObj[0].nodeName;
   startObj=startObj[0].parentNode
  }
 
  if(startObj&& startObj.childNodes) {
   for(i=0; i<startObj.childNodes.length; i++) {
    if(!collectTags || startObj.childNodes[i].nodeName==collectTags) {
     result+=outerXML(startObj.childNodes[i],alwaysClosingTag);
    }
   }
  }
  return result;
}
 
 // --------------------------------------------------------------------------
 
 function outerXML(node,alwaysClosingTag) {
  var i, result="";
 
  if(!alwaysClosingTag) { alwaysClosingTag=false; }
 
  switch(node.nodeType) {
   case 1: // ELEMENT_NODE
    result+="<"+node.nodeName;
    for(i=0; i<node.attributes.length; i++) {
     if(node.attributes.item(i).nodeValue!=null) {
      result+=' '+node.attributes.item(i).nodeName+'="'+node.attributes.item(i).nodeValue+'"';
     }
    }
 
    // Leere Elemente ggf. ohne Endtag schliessen (z.B. <br />)
    if(!node.childNodes.length) {
     result+=(alwaysClosingTag)?('></'+node.nodeName+'>'):' />';
    } else {
     result+='>'+innerXML(node,alwaysClosingTag)+'</'+node.nodeName+'>';
    }
    break;
 
   case 3: //TEXT_NODE
    result+=node.nodeValue;
    break;
 
   case 4: // CDATA_SECTION_NODE
    result+='<![CDATA['+node.nodeValue+']]>';
    break;
 
   case 5: // ENTITY_REFERENCE_NODE
    result+='&'+node.nodeName+';'
    break;
 
   case 8: // COMMENT_NODE
    result+='<!--'+node.nodeValue+'-->';
    break;
 
   case 9: // DOCUMENT_NODE
    if(node.childNodes.length) {
     result+=innerXML(node,alwaysClosingTag);
    }
    break;
  }
  return result;
 }


/* Hole Text eines Elements (und seiner Kinder) */
 function innerText(node) {
  var i, result="";
 
  if(node && node.childNodes) {
   for(i=0; i<node.childNodes.length; i++) {
    child=node.childNodes.item(i);
 
    switch(child.nodeType) {
     case (1): // ELEMENT_NODE
     if(child.childNodes.length) {
      result+=innerText(child);
     }
     break;
 
     case (3 || 4): //TEXT_NODE + CDATA_SECTION_NODE
      result+=child.nodeValue;
      break;
    }
 
   }
  }
}

/** 
 * Funcio que a partir d'un objecte XMLDocument retorna un string amb tot el xml concatenat
 */
function getXMLAsString(xmldoc) {
    return outerXML(xmldoc,true);
}
