// Funciones generales m750
// jotabe, (c) Grupo SIESTA, 06-08-2007


//-------------------------------------------------
// Enviar pulsacion de tecla
//-------------------------------------------------
function enviarTecla(tecla) {
	// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
	makeRequest("/cgi-bin/run/irsim?" + tecla + "-" + new Date().getTime(), "noReply");
}

//-------------------------------------------------
// Cambio de canal
//-------------------------------------------------
function cambioCanal(num) {
	// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
	makeRequest("/cgi-bin/run/cambioCanal?" + num + "-" + new Date().getTime(), "noReply");
}

//-------------------------------------------------
// Mostrar detalle de programa
//-------------------------------------------------
function detallePrograma(id, img, long, channel, utc) {
	// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
	document.location.href="/cgi-bin/sincro/pgmdetail?" + parseInt(id, 16) + "-" + img + "-" + long + "-" + channel + "-" + utc + "-" + new Date().getTime();
}

//-------------------------------------------------
// Mostrar detalle de programa de InOut
//-------------------------------------------------
function detalleProgramaInOut(id) {
	pid=id.substring(0, 7);
	window.open("http://www.inout.tv/SincroGuia/ficha.php?id="+pid);
}

//-------------------------------------------------
// Mostrar detalle de grabacion pendiente (timer)
//-------------------------------------------------
function detalleTimer(id, crid) {
	document.location.href="/cgi-bin/crid/detalle-timer?" + parseInt(id, 16) + "-" + crid;
}

//-------------------------------------------------
// Mostrar detalle de grabacion realizada (.crid)
//-------------------------------------------------
function detalleCrid(crid) {
	document.location.href="/cgi-bin/crid/detalle-crid?" + crid;
}


//-------------------------------------------------
// Busqueda de programa
//-------------------------------------------------
function buscarPrograma() {
	f=document.forms['form_m750'];
	if (!isMobile)
	    mostrarMensajeProceso();
	document.location.href="/cgi-bin/sincro/buscarPrograma?" + f.querystr.value;
}

//-------------------------------------------------
// Busqueda de programa por horas
//-------------------------------------------------
function buscarProgramaFH() {
	f=document.forms['form_m750'];
	if (!isMobile)
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
// Recargar pagina
//-------------------------------------------------
function reload() {
	document.location.reload();
}

//-------------------------------------------------
// Recargar pagina con retraso
//-------------------------------------------------
function reloadDelayed() {
	setTimeout("reload()", 10000);
}

//-------------------------------------------------
// Generar cache sincroguia
//-------------------------------------------------
function actCacheCanales() {
	if (confirm("La generaci�n de la cach� de los canales tarda unos 2 minutos.\n\n�Confirma la actualizaci�n de dicha cach�?")) {
		makeRequest("/cgi-bin/cache/bg-gc-sincro.sh?" + new Date().getTime(), "noReply");
		alert("Se ha mandado la petici�n de actualizaci�n de la cach� de los canales.\n\nSigue el proceso en la p�gina de estado de la aplicaci�n.");
		document.location.href="/cgi-bin/box/estado?id_log=log_cache_sincro";
	}
}

//-------------------------------------------------
// Descargar imagenes sincroguia
//-------------------------------------------------
function downloadSincroImg() {
	if (confirm("El proceso de descarga de las im�genes tarda unos 5 minutos.\n\n�Confirma la descarga de las im�genes de la sincroguia?")) {
		makeRequest("/cgi-bin/box/bg-getsincroimg?" + new Date().getTime(), "noReply");
		alert("Se ha mandado la petici�n de Descarga.\n\nSigue el proceso en la p�gina de estado de la aplicaci�n.");
		document.location.href="/cgi-bin/box/estado?id_log=log_getsincroimg";
	}
}

//-------------------------------------------------
// Descargar images.txt
//-------------------------------------------------
function descargarImages() {
	// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
	document.location.href="/cgi-bin/box/descargarImages?" + new Date().getTime();
}

//-------------------------------------------------
// Recargar /var/etc/root.crontab
//-------------------------------------------------
function reloadCrontab() {
	if (confirm("�Confirma la recarga de /var/etc/root.crontab?")) {
		makeRequest("/cgi-bin/run/reloadCrontab?" + new Date().getTime(), "noReply");
		alert("Se ha mandado la petici�n de recarga de root.crontab\n\nA continuaci�n se mostraran los procesos planificados para comprobar el resultado.");
		document.location.href="/cgi-bin/box/estado?id_log=log_crontab";
	}
}

//-------------------------------------------------
// Reiniciar Gigaset
//-------------------------------------------------
function reboot() {
	if (confirm("�Confirma el reboot del Gigaset?")) {
		makeRequest("/cgi-bin/run/reboot?" + new Date().getTime(), "noReply");
		alert("Se ha mandado la petici�n de Reboot.\n\nEn unos segundos el sistema se reiniciar�");
	}
}

//-------------------------------------------------
// Comprobar particion
//-------------------------------------------------
function checkHD(partition, fstype) {
	if (confirm("El chequeo del disco implica realizar un apagado del gigaset para desmontar la unidad.\n\n�Confirma el chequeo de "+partition+"?")) {
		makeRequest("/cgi-bin/box/bg-checkDisk?"+ partition + "-" + fstype + "-" + new Date().getTime(), "noReply");
		alert("Se ha mandado la petici�n de chequeo de la unidad.\n\nSigue el proceso en la p�gina de estado de la aplicaci�n.");
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
	if (confirm("�Est� seguro de querer grabar " + enserie + "el programa " + titulo + "?")) {
		if (!isMobile)
		    mostrarMensajeProceso();
		// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
		makeRequest("/cgi-bin/run/programarGrabacion?" + parseInt(id, 16) + "-" + serie + "-" + new Date().getTime(), "RespuestaPeticionXML");
	}
}

//-------------------------------------------------
// Programar grabacion por PID
//-------------------------------------------------
function programarGrabacionPID(pid, serie) {
	enserie="";
	if (serie == 1)
		enserie="en serie ";
	if (confirm("�Est� seguro de querer grabar " + enserie + "este programa?")) {
		if (!isMobile)
		    mostrarMensajeProceso();
		// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
		makeRequest("/cgi-bin/run/programarGrabacion?" + pid + "-" + serie + "-" + new Date().getTime(), "RespuestaPeticionXML");
	}
}

//-------------------------------------------------
// Cancelar grabacion pendiente
//-------------------------------------------------
function cancelarGrabacion(id) {
	if (confirm("�Est� seguro de querer cancelar la grabaci�n seleccionada?")) {
		if (!isMobile)
		    mostrarMensajeProceso();
		// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
		makeRequest("/cgi-bin/run/cancelarGrabacion?" + parseInt(id, 16) + "-" + new Date().getTime(), "RespuestaPeticionXML");
	}
}

//-------------------------------------------------
// Cancelar grabacion pendiente por PID
//-------------------------------------------------
function cancelarGrabacionPID(pid) {
	if (confirm("�Est� seguro de querer cancelar esta grabaci�n?")) {
		if (!isMobile)
		    mostrarMensajeProceso();
		// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
		makeRequest("/cgi-bin/run/cancelarGrabacion?" + pid + "-" + new Date().getTime(), "RespuestaPeticionXML");
	}
}

//-------------------------------------------------
// Borrar grabacion
//-------------------------------------------------
function borrarGrabacion(crid) {
	if (confirm("�Est� seguro de querer eliminar definitivamente la grabaci�n seleccionada?")) {
		if (!isMobile)
		    mostrarMensajeProceso();
		// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
		makeRequest("/cgi-bin/run/borrarGrabacion?" + crid + "-" + new Date().getTime(), "RespuestaPeticionXML");
	}
}

function borrarGrabacionCompleta(crid) {
	if (confirm("�Est� seguro de querer eliminar definitivamente la grabaci�n seleccionada?")) {
		if (!isMobile)
		    mostrarMensajeProceso();
		// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
		makeRequest("/cgi-bin/run/borrarGrabacionCompleta?" + crid + "-" + new Date().getTime(), "RespuestaPeticionXML");
	}
}

//-------------------------------------------------
// Archivar grabacion
//-------------------------------------------------
function archivarGrabacion(crid) {
	if (confirm("�Est� seguro de querer archivar la grabaci�n seleccionada?")) {
		if (!isMobile)
		    mostrarMensajeProceso();
		// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
		makeRequest("/cgi-bin/run/archivarCrid?" + crid + "-" + new Date().getTime(), "RespuestaPeticionXML");
	}
}

//-------------------------------------------------
// Copiar/Mover grabacion
//-------------------------------------------------
function copiarGrabacion(crid) {
	directorio = prompt('Introduce el Directorio Destino','/var/media/PC1/Video'); 
	if (directorio == null) {
	    alert("Debe permitir la ejecuci�n de scripts");
	    return;
	}
	if (confirm("�Est� seguro de querer copiar la grabaci�n seleccionada al directorio " + directorio + "?")) {
		if (!isMobile)
		    mostrarMensajeProceso();
		// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
		makeRequest("/cgi-bin/run/cpmvCrid?" + crid + "&" + directorio + "&0&" + new Date().getTime(), "noReply");
		alert("Se ha mandado la orden de copia de la grabaci�n. Siga el proceso en la pantalla de estado.");
		document.location.href="/cgi-bin/box/estado?id_log=log_cpmv_record";
	}
}

function moverGrabacion(crid) {
	directorio = prompt('Introduce el Directorio Destino','/var/media/PC1/Video');
	if (directorio == null) {
	    alert("Debe permitir la ejecuci�n de scripts");
	    return;
	}
	if (confirm("�Est� seguro de querer mover la grabaci�n seleccionada al directorio " + directorio + "?")) {
		if (!isMobile)
		    mostrarMensajeProceso();
		// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
		makeRequest("/cgi-bin/run/cpmvCrid?" + crid + "&" + directorio + "&1&" + new Date().getTime(), "noReply");
		alert("Se ha mandado la orden de copia de la grabaci�n. Siga el proceso en la pantalla de estado.");
		document.location.href="/cgi-bin/box/estado?id_log=log_cpmv_record";
	}
}

//-------------------------------------------------
// Restaurar grabacion
//-------------------------------------------------
function restaurarGrabacion(crid) {
	if (confirm("�Est� seguro de querer restaurar la grabaci�n seleccionada?")) {
		if (!isMobile)
		    mostrarMensajeProceso();
		// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
		makeRequest("/cgi-bin/run/restaurarCrid?" + crid + "-" + new Date().getTime(), "RespuestaPeticionXML");
	}
}

//-------------------------------------------------
// Respuesta a peticiones de grabacion/cancelacion/borrado
//-------------------------------------------------
function RespuestaPeticionXML(xmldoc) {
	result = xmldoc.getElementsByTagName("RESULT");
	if (result[0].firstChild.data == "OK") {
		alert("Petici�n aceptada por el M750");
		document.location.reload();
	} else {
		alert("Petici�n NO aceptada por el M750");
	}
	if (!isMobile)
	    eliminarMensajeProceso();
}

//-------------------------------------------------
// No esperar respuesta a peticiones makeRequest
//-------------------------------------------------
function noReply(xmldoc) {}

//-------------------------------------------------
