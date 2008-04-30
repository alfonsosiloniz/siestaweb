// Funciones mensaje proceso
// jotabe, (c) Grupo SIESTA, 21-01-2008


//-------------------------------------------------
// Variables de entorno
//-------------------------------------------------
var textoProceso	= "";		// Mensaje a mostrar
var msgprocesando	= false;	// Marca de proceso en ejecucion
var url_1			= "";		// URL inicial
var vueltas			= 0;		// Contador

//-------------------------------------------------
// Mostrar mensaje proceso
//-------------------------------------------------
function mostrarMensajeProceso() {
	//Comprobar marca proceso
	if (msgprocesando)
		return false;

	// Inicializar variables
	msgprocesando = true;
	url_1 = getURL();
	vueltas = 0;
	checkURL();

	// Crear elemento 'mensajeproceso'
	mensajeProceso = document.createElement("div");
	mensajeProceso.setAttribute("id","mensajeproceso");
	mensajeProceso.style.position		= 'absolute';
	mensajeProceso.style.width			= '164px';
	mensajeProceso.style.height			= '79px';
// 	mensajeProceso.style.clip			= 'rect(0,160,75,0)';
	mensajeProceso.style.zIndex			= '100';
	mensajeProceso.style.fontFamily		= 'Arial, Helvetica, Sans-Serif';
	mensajeProceso.style.fontWeight		= 'Bold';
	mensajeProceso.style.fontSize		= '14px';
	mensajeProceso.style.color			= '#FF0000';
	mensajeProceso.style.padding		= '4px';  
	mensajeProceso.style.height			= '2px';

	// Texto a mostrar
	textoProceso = "<table width=100% height='70px' border=0 cellpadding=0 cellspacing=0 style='background-image:url(/img/recuadro_procesando.gif)'>" +
	"<tr>" +
		"<td>" +
			"<table width=100% height='45px' border=0 cellpadding=0 cellspacing=0 >" +
				"<tr>" +
					"<td align='center' style='color:#FF0000; font-weight:Bold; font-size:16px'>" + 
						"PROCESANDO" +
					"</td>" +
				"</tr>" +
				"<tr>" +
					"<td align='center'>" +
						"<img src='/img/ajax-loader.gif'>" +
					"</td>" +
				"</tr>" +
			"</table>" +
		"</td>" +
	"</tr>" +
"</table>";
	mensajeProceso.innerHTML = textoProceso;
	document.body.appendChild(mensajeProceso);

	// Crear capa semi-transparente
	capaTrans();

	// Colocar capas
	moveDivs();

	// Asignar eventos
	window.onscroll = moveDivs;
	window.onresize = moveDivs;
}

//-------------------------------------------------
// Eliminar mensaje proceso
//-------------------------------------------------
function eliminarMensajeProceso() {
	// Eliminar elemento 'mensajeproceso'
	if(document.getElementById("mensajeproceso")!=null) {
		document.body.removeChild(document.getElementById("mensajeproceso"));
	}

	// Eliminar elemento 'divTapa'
	if(document.getElementById("divTapa")!=null) {
		document.body.removeChild(document.getElementById("divTapa"));
	}

	// Quitar marca proceso
	msgprocesando = false;
}

//-------------------------------------------------
// Crear capa semi-transparente
//-------------------------------------------------
function capaTrans() {
	// Crear elemento 'divTapa'
	mensajeTapa = document.createElement("div");
	mensajeTapa.setAttribute("id","divTapa");
	mensajeTapa.style.position			= 'absolute';
	mensajeTapa.style.width				= '100%';
	mensajeTapa.style.height			= '100%';
// 	mensajeTapa.style.clip				= 'rect(0,200,300,0)';
	mensajeTapa.style.zIndex			= '99';
	mensajeTapa.style.backgroundImage	= 'url("/img/capa6.gif")';
	mensajeTapa.innerHTML				= "&nbsp;";
	document.body.appendChild(mensajeTapa);
}

//-------------------------------------------------
// Posicion capas
//-------------------------------------------------
function moveDivs() {
	// Elemento 'mensajeproceso' 
	d = "mensajeproceso"; 
	t = parseInt(document.body.scrollTop)+parseInt(document.body.clientHeight);
	t = t-(parseInt(document.body.clientHeight)/2)-15;
	l = (parseInt(document.body.clientWidth)/2)-70;

	// Posicion elemento y capa semi-transparente
	moveDiv(d,t,l);
	moveTapa();
}

//-------------------------------------------------
// Posicion capa semi-transparente
//-------------------------------------------------
function moveTapa() {
	// Elemento 'divTapa' 
	d = "divTapa";
	t = parseInt(document.body.scrollTop);
	l = 0;

	// Posicion elemento
	moveDiv(d,t,l);
}

//-------------------------------------------------
// Posicion elemento 'div'
// divName	Nombre elemento
// divTop	Valor top
// divLeft	Valor Left
//-------------------------------------------------
function moveDiv(divName, divTop, divLeft) {
	if (document.all) {
        if (document.all[divName] != null) {
            if (document.all[divName].style != null) {
                document.all[divName].style.top=divTop+"px";
                document.all[divName].style.left=divLeft+"px";
           }
        }
	} else {
        if (document.getElementById(divName) != null) {
            if (document.getElementById(divName).style != null) {
                document.getElementById(divName).style.top=divTop+"px";
                document.getElementById(divName).style.left=divLeft+"px";
           }
        }
	}
}

//-------------------------------------------------
// Comprobar cambio en URL actual y terminar proceso
//-------------------------------------------------
function checkURL() {
	vueltas ++;
	url_2 = getURL();
	if(url_1 == url_2 && vueltas < 20) {
		window.setTimeout("checkURL()",100);
	} else {
		vueltas = 0;
		msgprocesando=false;
	}
}

//-------------------------------------------------
// Obtener URL actual
//-------------------------------------------------
function getURL() {
	return document.location.href;
}

//-------------------------------------------------
// Guardar datos del formulario mostrando mensaje proceso
//-------------------------------------------------
function guardarDatosForm() {
	if (!isMobile)
		mostrarMensajeProceso();
	setTimeout("document.forms['form_m750'].submit()", 200);
}

//-------------------------------------------------
