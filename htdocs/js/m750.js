// Funciones generales m750
// jotabe, (c) Grupo SIESTA, 12-01-2008


//-------------------------------------------------
// Enviar pulsacion de tecla
//-------------------------------------------------
function enviarTecla(tecla) {
	makeRequest("/cgi-bin/run/irsim?" + tecla, "noReplyLogin");
}

//-------------------------------------------------
// Cambio de canal
//-------------------------------------------------
function cambioCanal(num) {
	makeRequest("/cgi-bin/run/cambioCanal?" + num, "noReplyLogin");
}

//-------------------------------------------------
// Mostrar detalle de programa
//-------------------------------------------------
function detallePrograma(id, img, long, channel, utc) {
	// Añadimos la fecha a la peticion para evitar la caché de los navegadores
	document.location.href="/cgi-bin/sincro/pgmdetail?" + parseInt(id, 16) + "-" + img + "-" + long + "-" + channel + "-" + utc + "-" + new Date().getTime();
}

//-------------------------------------------------
// Mostrar detalle de programa de InOut
//-------------------------------------------------
function detalleProgramaInOut(id) {
	pid=id.substring(0, 7);
	window.open("http://www.sincroguia.tv/?do=Programacion&accion=verficha&idevent="+pid);
}

//-------------------------------------------------
// Mostrar detalle de grabacion pendiente (timer)
//-------------------------------------------------
function detalleTimer(id, crid) {
	// Añadimos la fecha a la peticion para evitar la caché de los navegadores
	document.location.href="/cgi-bin/crid/detalle-timer?" + parseInt(id, 16) + "-" + crid + "-" + new Date().getTime();
}

//-------------------------------------------------
// Mostrar detalle de grabacion realizada (.crid)
//-------------------------------------------------
function detalleCrid(crid) {
	// Añadimos la fecha a la peticion para evitar la caché de los navegadores
	document.location.href="/cgi-bin/crid/detalle-crid?" + crid + "-" + new Date().getTime();
}


//-------------------------------------------------
// Busqueda de programa
//-------------------------------------------------
function buscarPrograma() {
	f=document.forms['form_m750'];
	if (!isMobile && !operaMini)
		mostrarMensajeProceso();
	document.location.href="/cgi-bin/sincro/buscarPrograma?" + f.querystr.value;
}

//-------------------------------------------------
// Busqueda de programa por horas
//-------------------------------------------------
function buscarProgramaFH() {
	f=document.forms['form_m750'];
	if (!isMobile && !operaMini)
		mostrarMensajeProceso();
	document.location.href="/cgi-bin/sincro/buscarPrograma?" + f.fecha.value + " " + f.hora.value;
}

//-------------------------------------------------
// Inicializar fecha-hora de busquedas
//-------------------------------------------------
function initFechas(fecha) {
	f=document.forms['form_m750'];
	var d = new Date();    
	dia=(""+d.getDate()).length == 1 ? "0" + d.getDate() : d.getDate();
	mes=(""+(d.getMonth()+1)).length == 1 ? "0" + (d.getMonth()+1) : (d.getMonth()+1);
	fullYear=""+d.getFullYear();
	year=fullYear.substring(2);
	f.fecha.length=7;
	f.fecha.options[0].text=dia+"."+mes+"."+fullYear;
	f.fecha.options[0].value=dia+"."+mes+"."+year;
	for(i=1; i < 7; ++i) {
		f.fecha.options[i].text=incDate(f.fecha.options[i-1].text);
		f.fecha.options[i].value=f.fecha.options[i].text.substring(0,6)+f.fecha.options[i].text.substring(8);
	}
}


//-------------------------------------------------
// Recargar pagina con retraso
//-------------------------------------------------
function reloadDelayed() {
	setTimeout("document.location.reload()", 10000);
}

//-------------------------------------------------
// Generar cache sincroguia
//-------------------------------------------------
function actCacheCanales() {
	if (confirm("La generación de la caché de los canales tarda unos 2 minutos.\n\n¿Confirma la actualización de dicha caché?")) {
		makeRequest("/cgi-bin/run/bg-gc-sincro");
		alert("Se ha mandado la petición de actualización de la caché de los canales.\n\nSigue el proceso en la página de estado de la aplicación.");
		document.location.href="/cgi-bin/box/estado?id_log=log_cache_sincro";
	}
}

//-------------------------------------------------
// Descargar imagenes sincroguia
//-------------------------------------------------
function downloadSincroImg() {
	if (confirm("El proceso de descarga de las imágenes tarda unos 5 minutos.\n\n¿Confirma la descarga de las imágenes de la sincroguia?")) {
		makeRequest("/cgi-bin/run/bg-getsincroimg");
		alert("Se ha mandado la petición de descarga.\n\nSigue el proceso en la página de estado de la aplicación.");
		document.location.href="/cgi-bin/box/estado?id_log=log_getsincroimg";
	}
}

//-------------------------------------------------
// Descargar images.txt
//-------------------------------------------------
function descargarImages() {
	// Añadimos la fecha a la peticion para evitar la caché de los navegadores
	document.location.href="/cgi-bin/box/descargarImages?" + new Date().getTime();
}

//-------------------------------------------------
// Recargar /var/etc/root.crontab
//-------------------------------------------------
function reloadCrontab() {
	if (confirm("¿Confirma la recarga de /var/etc/root.crontab?")) {
		makeRequest("/cgi-bin/run/reloadCrontab", "RespuestaReloadCrontabXML");
	}
}

// Respuesta ERROR_LOGIN -> Login incorrecto
function RespuestaReloadCrontabXML(xmldoc) {
	result = xmldoc.getElementsByTagName("RESULT");
	if (result[0].firstChild.data == "ERROR_LOGIN") {
		alert("Para tener acceso a esta aplicacion web antes debe validarse con su usuario y contraseña.\n\nAhora será redirigido a la página de login para introducir sus datos.");
		document.location.href="/index.html";
	} else {
		alert("Se ha mandado la petición de recarga de root.crontab\n\nA continuación se mostraran los procesos planificados para comprobar el resultado.");
		document.location.href="/cgi-bin/box/estado?id_log=log_crontab";
	}
}

//-------------------------------------------------
// Reiniciar Gigaset
//-------------------------------------------------
function reboot() {
	if (confirm("¿Confirma el reboot del Gigaset?")) {
		makeRequest("/cgi-bin/run/reboot");
		alert("Se ha mandado la petición de Reboot.\n\nEn unos segundos el sistema se reiniciará");
	}
}

//-------------------------------------------------
// Comprobar particion
//-------------------------------------------------
function checkHD(partition, fstype) {
	if (confirm("El chequeo del disco implica realizar un apagado del gigaset para desmontar la unidad.\n\n¿Confirma el chequeo de "+partition+"?")) {
		makeRequest("/cgi-bin/run/bg-checkDisk?"+ partition + "-" + fstype);
		alert("Se ha mandado la petición de chequeo de la unidad.\n\nSigue el proceso en la página de estado de la aplicación.");
		document.location.href="/cgi-bin/box/estado?id_log=log_checkdisk";
	}
}

//-------------------------------------------------
// Programar grabacion
//-------------------------------------------------
function programarGrabacion(id, serie, titulo) {
	enserie="";
	if (serie == 1)
		enserie="en serie ";
	if (!operaMini) {
	    if (confirm("¿Está seguro de querer grabar " + enserie + "el programa " + titulo + "?")) {
    		if (!isMobile && !operaMini)
    			mostrarMensajeProceso();
    		makeRequest("/cgi-bin/run/programarGrabacion?" + parseInt(id, 16) + "-" + serie, "RespuestaPeticionXML");
        }
	}
	else {
	    document.location.href="/cgi-bin/run/programarGrabacion?" + parseInt(id, 16) + "-" + serie;
	}
}

//-------------------------------------------------
// Programar grabacion por PID
//-------------------------------------------------
function programarGrabacionPID(pid, serie) {
	enserie="";
	if (serie == 1)
		enserie="en serie ";
    if (!operaMini) {
    	if (confirm("¿Está seguro de querer grabar " + enserie + "este programa?")) {
    		if (!isMobile && !operaMini)
    			mostrarMensajeProceso();
    		makeRequest("/cgi-bin/run/programarGrabacion?" + pid + "-" + serie, "RespuestaPeticionXML");
    	}
    }
    else {
        document.location.href="/cgi-bin/run/programarGrabacion?" + pid + "-" + serie;
    }
}

//-------------------------------------------------
// Cancelar grabacion pendiente
//-------------------------------------------------
function cancelarGrabacion(id) {
	if (!operaMini) {
    	if (confirm("¿Está seguro de querer cancelar la grabación seleccionada?")) {
    		if (!isMobile && !operaMini)
    			mostrarMensajeProceso();
    		makeRequest("/cgi-bin/run/cancelarGrabacion?" + parseInt(id, 16), "RespuestaPeticionXML");
    	}
    }
    else {
        document.location.href="/cgi-bin/run/cancelarGrabacion?" + parseInt(id, 16);
    }
}

//-------------------------------------------------
// Cancelar grabacion pendiente por PID
//-------------------------------------------------
function cancelarGrabacionPID(pid) {
    if (!operaMini) {
    	if (confirm("¿Está seguro de querer cancelar esta grabación?")) {
    		if (!isMobile && !operaMini)
    			mostrarMensajeProceso();
    		makeRequest("/cgi-bin/run/cancelarGrabacion?" + pid, "RespuestaPeticionXML");
    	}
    }
    else {
        document.location.href="/cgi-bin/run/cancelarGrabacion?" + pid;
    }
}

//-------------------------------------------------
// Borrar grabacion
//-------------------------------------------------
function borrarGrabacion(crid) {
	if (!operaMini) {
    	if (confirm("¿Está seguro de querer eliminar definitivamente la grabación seleccionada?")) {
    		if (!isMobile && !operaMini)
    			mostrarMensajeProceso();
    		makeRequest("/cgi-bin/run/borrarGrabacion?" + crid, "RespuestaPeticionXML");
    	}
    }
    else {
        document.location.href="/cgi-bin/run/borrarGrabacion?" + crid;
    }
}

function borrarGrabacionCompleta(crid) {
	var force;
	if (document.forms['form_m750'].ModoForce.value == 0) {
		force="";
	} else {
		force="-force";
	}
    if (!operaMini) {
    	if (confirm("¿Está seguro de querer eliminar definitivamente la grabación seleccionada?")) {
    		if (!isMobile && !operaMini)
    			mostrarMensajeProceso();
    		makeRequest("/cgi-bin/run/borrarGrabacionCompleta?" + crid + force, "RespuestaArchivoXML");
    	}
    }
    else {
        document.location.href="/cgi-bin/run/borrarGrabacionCompleta?" + crid + force;
    }
}

//-------------------------------------------------
// Programar apagado
//-------------------------------------------------
function sleep() {
    f=document.forms[0];
    if (parseInt(f.horas.value) == 0 && parseInt(f.minutos.value) == 0) {
        alert("Debe introducir un valor de Horas o Minutos");
        return;
    }
    if (parseInt(f.minutos.value) > 59) {
        alert("El valor de minutos supera el máximo permitido (59)");
        return;
    }
    //document.location.href="/cgi-bin/box/sleep?" + getFormParameters(f);
    if (!isMobile && !operaMini)
		mostrarMensajeProceso();
    f.action="/cgi-bin/box/sleep";
    f.submit();
}

function cancelarApagado() {
    if (confirm("¿Está seguro de querer cancelar el Apagado?")) {
        if (!isMobile && !operaMini)
		    mostrarMensajeProceso();
        document.location.href="/cgi-bin/box/sleep?cancelar";
    }
}

//-------------------------------------------------
// Archivar grabacion
//-------------------------------------------------
function archivarGrabacion(crid) {
	var force;
	if (document.forms['form_m750'].ModoForce.value == 0) {
		force="";
	} else {
		force="-force";
	}

	if (confirm("¿Está seguro de querer archivar la grabación seleccionada?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/run/archivarCrid?" + crid + force, "RespuestaArchivoXML");
	}
}

//-------------------------------------------------
// Copiar/Mover grabacion
//-------------------------------------------------
function copiarGrabacion(crid,nombre,carpeta) {
	var force="0";
	if (document.forms['form_m750'].ModoForce.value == 1) {
		force="1";
	}
	directorio = prompt('Introduce la carpeta de Destino para la grabación '+nombre,carpeta); 
	if (directorio == null) {
		alert("Debe permitir la ejecución de scripts");
		return;
	}
	if (confirm("¿Está seguro de querer copiar la grabación seleccionada al directorio " + directorio + "?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/run/cpmvCrid?" + crid + "&" + directorio + "&0&" + force);
		alert("Se ha mandado la orden de copia de la grabación.\n\nSigue el proceso en la página de estado.");
		document.location.href="/cgi-bin/box/estado?id_log=log_cpmv_record";
	}
}

function moverGrabacion(crid,nombre,carpeta) {
	var force="0";
	if (document.forms['form_m750'].ModoForce.value == 1) {
		force="1";
	}
	directorio = prompt('Introduce la carpeta de Destino para la grabación '+nombre,carpeta); 
	if (directorio == null) {
		alert("Debe permitir la ejecución de scripts");
		return;
	}
	if (confirm("¿Está seguro de querer mover la grabación seleccionada al directorio " + directorio + "?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/run/cpmvCrid?" + crid + "&" + directorio + "&1&" + force);
		alert("Se ha mandado la orden de movimiento de la grabación.\n\nSigue el proceso en la página de estado.");
		document.location.href="/cgi-bin/box/estado?id_log=log_cpmv_record";
	}
}

//-------------------------------------------------
// Restaurar grabacion
//-------------------------------------------------
function restaurarGrabacion(crid) {
	var force;
	if (document.forms['form_m750'].ModoForce.value == 0) {
		force="";
	} else {
		force="-force";
	}

	if (confirm("¿Está seguro de querer restaurar la grabación seleccionada?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/run/restaurarCrid?" + crid + force, "RespuestaArchivoXML");
	}
}

//-------------------------------------------------
// Detener copia/traspaso de grabacion
//-------------------------------------------------
function stopCpmv(crid) {
	if (confirm("¿Está seguro de querer detener la copia/traspaso de la grabacion?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/run/stopCpmv", "RespuestaPeticionXML");
	}
}

//-------------------------------------------------
// Montaje/desmontaje de USB2 en /var/media/SWAP
//-------------------------------------------------
function montarUSB2(accion) {
	if (confirm("¿Está seguro de querer " + accion + " el dispositivo USB2 en el directorio /var/media/SWAP?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/box/mount-usb2?id=" + accion, "RespuestaPeticionXML");
	}
}

//-------------------------------------------------
// Borrar ficheros fmpg huerfanos
//-------------------------------------------------
function borrarHuerfanos(carpeta) {
	if (confirm("¿Está seguro de querer borrar los fragmentos de grabación huerfanos de la carpeta " + carpeta + " ?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/run/borrarHuerfanos?" + carpeta);
		alert("Se ha mandado la orden de borrado de fragmentos de grabación huerfanos.\n\nSigue el proceso en la página de estado.");
		document.location.href="/cgi-bin/box/estado?id_log=log_fmpg_huerfanos";
	}
}


//-------------------------------------------------
// Respuesta a peticiones de grabacion/cancelacion/borrado
//-------------------------------------------------
function RespuestaPeticionXML(xmldoc) {
	result = xmldoc.getElementsByTagName("RESULT");
	switch(result[0].firstChild.data) {
	case "OK":
		alert("Petición aceptada por el M750");
		document.location.reload();
		break
	case "ERROR_LOGIN":
		alert("Para tener acceso a esta aplicacion web antes debe validarse con su usuario y contraseña.\n\nAhora será redirigido a la página de login para introducir sus datos.");
		document.location.href="/index.html";
		break
	default:
		alert("Petición NO aceptada por el M750");
	}
	if (!isMobile && !operaMini)
		eliminarMensajeProceso();
}

function RespuestaArchivoXML(xmldoc) {
	result = xmldoc.getElementsByTagName("RESULT");
	switch(result[0].firstChild.data) {
	case "OK":
		alert("Petición aceptada por el M750");
		document.location.reload();
		break
	case "ERROR_LOGIN":
		alert("Para tener acceso a esta aplicacion web antes debe validarse con su usuario y contraseña.\n\nAhora será redirigido a la página de login para introducir sus datos.");
		document.location.href="/index.html";
		break
	case "FALLO":
		alert("Petición NO aceptada por el M750.\n\nLos ficheros .fmpg son compartidos por varios .crid.")
		break
	default:
		alert("Petición NO aceptada por el M750");
	}
	if (!isMobile && !operaMini)
		eliminarMensajeProceso();
}

//-------------------------------------------------
// Respuestas a peticiones makeRequest
//-------------------------------------------------
// Respuesta ERROR_LOGIN -> Login incorrecto
function noReplyLogin(xmldoc) {
	result = xmldoc.getElementsByTagName("RESULT");
	if (result[0].firstChild.data == "ERROR_LOGIN") {
		alert("Para tener acceso a esta aplicacion web antes debe validarse con su usuario y contraseña.\n\nAhora será redirigido a la página de login para introducir sus datos.");
		document.location.href="/index.html";
	}
}

//-------------------------------------------------
