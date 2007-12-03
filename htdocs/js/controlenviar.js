var textoProceso = "PROCESSANT"; // traducir
var codInterval  = null;
var cont = 0;
var msgprocesando = false;
var url_1 = "";
var vueltas = 0;

function moveDiv(divName, divTop, divLeft) {
    if (document.all) {
        if (document.all[divName]!= null){
            if (document.all[divName].style!= null){
                document.all[divName].style.top=divTop+"px";
                document.all[divName].style.left=divLeft+"px";
           }
        }
    }
    else {
        if (document.getElementById(divName)!= null){
            if (document.getElementById(divName).style!= null){
                document.getElementById(divName).style.top=divTop+"px";
                document.getElementById(divName).style.left=divLeft+"px";
           }
        }
    }
}

function moveDivs() {
	d="mensajeproceso"; 
	t = parseInt(document.body.scrollTop)+parseInt(document.body.clientHeight);
	t = t-(parseInt(document.body.clientHeight)/2)-15;
	l = (parseInt(document.body.clientWidth)/2)-70;

	moveDiv(d,t,l);
	moveTapa();
}

function moveTapa() {
	d="divTapa";
	t = parseInt(document.body.scrollTop);
	l = 0;

	moveDiv(d,t,l);
}

function capaTrans() {
	mensajeTapa = document.createElement("div");
	mensajeTapa.setAttribute("id","divTapa");
	mensajeTapa.style.position        = 'absolute';
	mensajeTapa.style.width           = '100%';
	mensajeTapa.style.height          = '100%';
// 	mensajeTapa.style.clip            = 'rect(0,200,300,0)';
	mensajeTapa.style.zIndex          = '99';
	mensajeTapa.style.backgroundImage = 'url("/img/capa6.gif")';
	mensajeTapa.innerHTML= "&nbsp;";
	document.body.appendChild(mensajeTapa);
}

function desactivarEnviar(imgEnviar,linkEnviar,imgBotonInactivo) {
	imgEnviar.setAttribute("src",imgBotonInactivo.src);
	linkEnviar.removeAttribute("href");
}

function activarEnviar(imgEnviar,linkEnviar,imgBotonActivo) {
	imgEnviar.setAttribute("src",imgBotonActivo.src);
	linkEnviar.setAttribute("href","javascript:enviar()");
}

function mostrarMensajeProceso() {
	if (msgprocesando){
		return false;
	}

	msgprocesando = true;
	url_1 = getURL();
	checkURL();

	mensajeProceso = document.createElement("div");
	mensajeProceso.setAttribute("id","mensajeproceso");
	mensajeProceso.style.position        = 'absolute';
	mensajeProceso.style.width           = '160px';
	mensajeProceso.style.height          = '75px';
// 	mensajeProceso.style.clip            = 'rect(0,160,75,0)';
	mensajeProceso.style.zIndex          = '100';
	mensajeProceso.style.fontFamily      = 'arial';
	mensajeProceso.style.fontWeight      = 'bold';
	mensajeProceso.style.fontSize        = '14px';
	mensajeProceso.style.color           = '#ff0000';
	mensajeProceso.style.padding         = '4px';  
	mensajeProceso.style.height          = '2px';

	mensajeProceso.style.backgroundImage = 'url("/img/recuadro_procesando.gif")';
	textoProceso = "PROCESANDO";
	textoProceso = "<table width=100% height='70px' border=0 cellpadding=0 cellspacing=0><tr><td><table width=100% height='45px' border=0 cellpadding=0 cellspacing=0 ><tr><td align='center' style='font-family:Arial, Helvetica, sans-serif; color:#FF0000; font-weight:bold; font-size:15px'>" + textoProceso + "</td></tr><tr><td align='center'><img src='/img/ajax-loader.gif'></td></tr></table></td></tr></table>";
	mensajeProceso.appendChild(document.createTextNode(textoProceso));
	document.body.appendChild(mensajeProceso);
	mensajeProceso.innerHTML = textoProceso;
	capaTrans();
	moveDivs();
	window.onscroll = moveDivs;
	window.onresize = moveDivs;
}

function cambiarTextoMensajeProceso() {
	var car = "";

	switch (cont) {
	case 0:
		car = ".";
		break;
	case 1:
		car = "..";
		break;    
	case 2:
		car = "...";
		break;
	case 3:
		car = "";
		break;
	}
	mensajeProceso.innerHTML = textoProceso + car;
	cont ++;
	if (cont == 4){
		cont = 0;
	}
}

//funcion desconocida pero no la borramos
function eliminarMensajeProceso() {
	window.clearInterval(codInterval);
	if(document.getElementById("mensajeproceso")!=null){
		document.body.removeChild(document.getElementById("mensajeproceso"));
	}

	if(document.getElementById("divTapa")!=null){
		document.body.removeChild(document.getElementById("divTapa"));
	}

	cont = 0;
	msgprocesando = false;
}

function checkURL() {
	vueltas ++;
	url_2 = getURL();
	if(url_1==url_2 && vueltas < 20){
		window.setTimeout("checkURL()",100);
	}
	else{
		vueltas = 0;
		msgprocesando=false;
	}
}

function getURL() {
	return document.location.href;
}