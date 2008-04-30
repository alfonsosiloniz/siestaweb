// Funciones generales m750
// jotabe, (c) Grupo SIESTA, 10-04-2008


//-------------------------------------------------
// Marcar todos los checkbox de pagina
//-------------------------------------------------
function MarcarTodos(id_checkbox, estado) {
	var items = document.getElementsByTagName('input');
	var len_id;
	var i;
	var checkbox;

	// Verificar parametros
	if (id_checkbox == null)
		id_checkbox = "CRID_";
	if (estado == null)
		estado = true;
	len_id = id_checkbox.length;

	// Recorrer elementos
	for (i=0;i<items.length;i++) {
		checkbox = items[i];
		if (checkbox && checkbox.type == 'checkbox') {
// 			alert("Elemento: " + checkbox.name);
			if (checkbox.name.substring(0,len_id) == id_checkbox) {
				checkbox.checked = estado;
			}
		}
	}
}

//-------------------------------------------------
// Obtener relacion de checkbox de pagina
//-------------------------------------------------
function getSeleccion(id_checkbox, nombre, separador, aviso) {
	var sel = '';
	var num = 1
	var items = document.getElementsByTagName('input');
	var len_id;
	var i;
	var checkbox;

	// Verificar parametros
	if (id_checkbox == null)
		id_checkbox = "CRID_";
	if (nombre == null)
		nombre = "";
	if (separador == null)
		separador = "&";
	if (aviso == null)
		aviso = "";
	len_id = id_checkbox.length;

	// Recorrer elementos
	for (i=0;i<items.length;i++) {
		checkbox = items[i];
		if (checkbox && checkbox.type == 'checkbox') {
			if (checkbox.name.substring(0,len_id) == id_checkbox && checkbox.checked) {
				if (sel.length != 0)
					sel = sel + separador;
				if (nombre.length != 0)
					sel = sel + nombre + num++ + '=';
				sel = sel + checkbox.value;
			}
		}
	}

	// Incluir numero resultados
	if (sel.length != 0 && nombre.length != 0)
		sel = 'num_' + nombre + '=' + (num-1) + '&' + sel;

	// Mostrar aviso
	if (sel.length == 0 && aviso.length != 0)
		alert(aviso);

	// Devolver resultado
	return sel;
}

//-------------------------------------------------
// Redirigir a URL despues de confirmar
//-------------------------------------------------
// function ConfirmarURL(texto, url) {
// 	if (texto != null) {
// 		if (confirm(texto)) {
// 			if (url == null) {
// 				document.location.reload();
// 			} else {
// 				document.location.href = url;
// 			}
// 		}
// 	}
// }

//-------------------------------------------------
// Confirmar borrado
//-------------------------------------------------
function ConfirmarBorradoURL(texto, url) {
	if (texto != null) {
		if (confirm("�Est� seguro de querer eliminar " + texto + "?")) {
			if (url == null) {
				document.location.reload();
			} else {
				document.location.href = url;
			}
		}
	}
}

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
function detallePrograma(pidcid, img, long, chID, utc) {
	// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
	document.location.href = "/cgi-bin/sincro/pgmdetail?" + pidcid + "&" + img + "&" + long + "&" + chID + "&" + utc + "&TS=" + new Date().getTime();
}

//-------------------------------------------------
// Mostrar detalle de programa de InOut
//-------------------------------------------------
function detalleProgramaInOut(pidcid) {
	window.open("http://www.sincroguia.tv/?do=Programacion&accion=verficha&idevent=" + Math.floor(pidcid/100000));
}

//-------------------------------------------------
// Mostrar detalle de grabacion pendiente (timer)
//-------------------------------------------------
function detalleTimer(pidcid, crid) {
	// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
	document.location.href = "/cgi-bin/crid/edit-crid?" + crid + "&timer&" + pidcid + "&TS=" + new Date().getTime();
}

//-------------------------------------------------
// Mostrar detalle de grabacion realizada (.crid)
//-------------------------------------------------
function detalleCrid(crid) {
	// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
	document.location.href = "/cgi-bin/crid/edit-crid?" + crid + "&show&TS=" + new Date().getTime();
}

//-------------------------------------------------
// Edicion de grabacion realizada (.crid)
//-------------------------------------------------
function editCrid(crid) {
	// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
	document.location.href = "/cgi-bin/crid/edit-crid?" + crid + "&edit&TS=" + new Date().getTime();
}

//-------------------------------------------------
// Busqueda de programa
//-------------------------------------------------
function buscarPrograma() {
	var f = document.forms['form_m750'];
	if (!isMobile && !operaMini)
		mostrarMensajeProceso();
	document.location.href = "/cgi-bin/sincro/buscarPrograma?" + f.querystr.value;
}

//-------------------------------------------------
// Busqueda de programa por horas
//-------------------------------------------------
function buscarProgramaFH() {
	var f = document.forms['form_m750'];
	if (!isMobile && !operaMini)
		mostrarMensajeProceso();
	document.location.href = "/cgi-bin/sincro/buscarPrograma?" + f.fecha.value + " " + f.hora.value;
}

//-------------------------------------------------
// Inicializar fecha-hora de busquedas
//-------------------------------------------------
function initFechas(fecha) {
	var f = document.forms['form_m750'];
	var d = new Date();

	dia = (""+d.getDate()).length == 1 ? "0" + d.getDate() : d.getDate();
	mes = (""+(d.getMonth()+1)).length == 1 ? "0" + (d.getMonth()+1) : (d.getMonth()+1);
	fullYear = "" + d.getFullYear();
	year = fullYear.substring(2);
	f.fecha.length = 7;
	f.fecha.options[0].text = dia+"."+mes+"."+fullYear;
	f.fecha.options[0].value = dia+"."+mes+"."+year;
	for(i=1;i<7;++i) {
		f.fecha.options[i].text = incDate(f.fecha.options[i-1].text);
		f.fecha.options[i].value = f.fecha.options[i].text.substring(0,6)+f.fecha.options[i].text.substring(8);
	}
}


//-------------------------------------------------
// Recargar pagina con retraso
//-------------------------------------------------
function reloadDelayed() {
	setTimeout("document.location.reload()",10000);
}

//-------------------------------------------------
// Generar cache sincroguia
//-------------------------------------------------
function actCacheCanales() {
	if (confirm("La generaci�n de la cach� de los canales tarda unos 2 minutos.\n\n�Confirma la actualizaci�n de dicha cach�?")) {
		makeRequest("/cgi-bin/run/bg-gc-sincro");
		alert("Se ha mandado la petici�n de actualizaci�n de la cach� de los canales.\n\nSigue el proceso en la p�gina de estado de la aplicaci�n.");
		document.location.href = "/cgi-bin/box/estado?id_log=log_cache_sincro";
	}
}

//-------------------------------------------------
// Descargar imagenes sincroguia
//-------------------------------------------------
function downloadSincroImg() {
	if (confirm("El proceso de descarga de las im�genes tarda unos 5 minutos.\n\n�Confirma la descarga de las im�genes de la sincroguia?")) {
		makeRequest("/cgi-bin/run/bg-getsincroimg");
		alert("Se ha mandado la petici�n de descarga.\n\nSigue el proceso en la p�gina de estado de la aplicaci�n.");
		document.location.href = "/cgi-bin/box/estado?id_log=log_getsincroimg";
	}
}

//-------------------------------------------------
// Descargar images.txt
//-------------------------------------------------
function descargarImages() {
	// A�adimos la fecha a la peticion para evitar la cach� de los navegadores
	document.location.href = "/cgi-bin/box/descargarImages?TS" + new Date().getTime();
}

//-------------------------------------------------
// Recargar /var/etc/root.crontab
//-------------------------------------------------
function reloadCrontab() {
	if (confirm("�Confirma la recarga de /var/etc/root.crontab?")) {
		makeRequest("/cgi-bin/run/reloadCrontab", "RespuestaReloadCrontabXML");
	}
}

// Respuesta ERROR_LOGIN -> Login incorrecto
function RespuestaReloadCrontabXML(xmldoc) {
	result = xmldoc.getElementsByTagName("RESULT");
	if (result[0].firstChild.data == "ERROR_LOGIN") {
		alert("Para tener acceso a esta aplicacion web antes debe validarse con su usuario y contrase�a.\n\nAhora ser� redirigido a la p�gina de login para introducir sus datos.");
		document.location.href = "/index.html";
	} else {
		alert("Se ha mandado la petici�n de recarga de root.crontab\n\nA continuaci�n se mostraran los procesos planificados para comprobar el resultado.");
		document.location.href = "/cgi-bin/box/estado?id_log=log_crontab";
	}
}

//-------------------------------------------------
// Reiniciar Gigaset
//-------------------------------------------------
function reboot() {
	if (confirm("�Confirma el reboot del Gigaset?")) {
		makeRequest("/cgi-bin/run/reboot");
		alert("Se ha mandado la petici�n de Reboot.\n\nEn unos segundos el sistema se reiniciar�");
	}
}

//-------------------------------------------------
// Comprobar particion
//-------------------------------------------------
function checkHD(partition, fstype) {
	if (confirm("El chequeo del disco implica realizar un apagado del gigaset para desmontar la unidad.\n\n�Confirma el chequeo de "+partition+"?")) {
		makeRequest("/cgi-bin/run/bg-checkDisk?"+ partition + "&" + fstype);
		alert("Se ha mandado la petici�n de chequeo de la unidad.\n\nSigue el proceso en la p�gina de estado de la aplicaci�n.");
		document.location.href = "/cgi-bin/box/estado?id_log=log_checkdisk";
	}
}

//-------------------------------------------------
// Programar grabacion
//-------------------------------------------------
function programarGrabacion(pidcid, serie, titulo, reload) {
	var enserie = "";
	var programa = "";

	// Verificar parametros
	if (serie == 1)
		enserie = "en serie ";
	if (titulo == null) {
		programa = "este programa";
	} else {
		programa = "el programa '" + titulo + "'";
	}
	if (reload == null)
		reload = false;

	if (!operaMini) {
		if (confirm("�Est� seguro de querer grabar " + enserie + programa + "?")) {
			if (!isMobile && !operaMini)
				mostrarMensajeProceso();
			if (reload)
				makeRequest("/cgi-bin/run/programarGrabacion?" + pidcid + "&" + serie, "RespuestaPeticionXML");
			else
				makeRequest("/cgi-bin/run/programarGrabacion?" + pidcid + "&" + serie, "RespuestaPeticionXML_NR");
		}
	} else {
		document.location.href = "/cgi-bin/run/programarGrabacion?" + pidcid + "&" + serie;
	}
}

//-------------------------------------------------
// Cancelar grabacion pendiente
//-------------------------------------------------
function cancelarGrabacion(pidcid, titulo) {
	var programa = "";

	// Verificar parametros
	if (titulo == null) {
		programa = "esta grabaci�n";
	} else {
		programa = "la grabaci�n '" + titulo + "'";
	}

	if (!operaMini) {
		if (confirm("�Est� seguro de querer cancelar " + programa + "?")) {
			if (!isMobile && !operaMini)
				mostrarMensajeProceso();
			makeRequest("/cgi-bin/run/cancelarGrabacion?" + pidcid, "RespuestaPeticionXML");
		}
	} else {
		document.location.href = "/cgi-bin/run/cancelarGrabacion?" + pidcid;
	}
}

//-------------------------------------------------
// Borrar grabacion
//-------------------------------------------------
function borrarGrabacion(crid, titulo) {
	if (!operaMini) {
		if (confirm("�Est� seguro de querer eliminar definitivamente la grabaci�n '" + titulo + "'?")) {
			if (!isMobile && !operaMini)
				mostrarMensajeProceso();
			makeRequest("/cgi-bin/run/borrarGrabacion?num_CRIDFILE=1&CRIDFILE1=" + crid, "RespuestaPeticionXML");
		}
	} else {
		document.location.href = "/cgi-bin/run/borrarGrabacion?num_CRIDFILE=1&CRIDFILE1=" + crid;
	}
}

function borrarGrabacionMarcada(id_checkbox) {
	var crids = getSeleccion(id_checkbox, 'CRIDFILE', '&', 'Debe seleccionar alguna grabaci�n');

	if (crids.length != 0) {
		if (!operaMini) {
			if (confirm("�Est� seguro de querer eliminar definitivamente las grabaciones seleccionadas?")) {
				if (!isMobile && !operaMini)
					mostrarMensajeProceso();
				makeRequest("/cgi-bin/run/borrarGrabacion?" + crids, "RespuestaPeticionXML");
			}
		} else {
			document.location.href = "/cgi-bin/run/borrarGrabacion?" + crids;
		}
	}
}

function borrarGrabacionCompleta(crid, titulo) {
	var force = "";

	if (document.forms['form_m750'].ModoForce.value != 0) {
		force="&force";
	}

	if (!operaMini) {
		if (confirm("�Est� seguro de querer eliminar definitivamente la grabaci�n '" + titulo + "'?")) {
			if (!isMobile && !operaMini)
				mostrarMensajeProceso();
			makeRequest("/cgi-bin/run/borrarGrabacionCompleta?num_CRIDFILE=1&CRIDFILE1=" + crid + force, "RespuestaArchivoXML");
		}
	} else {
		document.location.href = "/cgi-bin/run/borrarGrabacionCompleta?num_CRIDFILE=1&CRIDFILE1=" + crid + force;
	}
}

function borrarGrabacionCompletaMarcada(id_checkbox) {
	var force = "";
	var crids = getSeleccion(id_checkbox, 'CRIDFILE', '&', 'Debe seleccionar alguna grabaci�n');

	if (document.forms['form_m750'].ModoForce.value != 0) {
		force="&force";
	}

	if (crids.length != 0) {
		if (!operaMini) {
			if (confirm("�Est� seguro de querer eliminar definitivamente las grabaciones seleccionadas?")) {
				if (!isMobile && !operaMini)
					mostrarMensajeProceso();
				makeRequest("/cgi-bin/run/borrarGrabacionCompleta?" + crids + force, "RespuestaArchivoXML");
			}
		} else {
			document.location.href = "/cgi-bin/run/borrarGrabacionCompleta?" + crids + force;
		}
	}
}

//-------------------------------------------------
// Programar apagado
//-------------------------------------------------
function sleep() {
	var f = document.forms[0];

	if (parseInt(f.horas.value) == 0 && parseInt(f.minutos.value) == 0) {
		alert("Debe introducir un valor de Horas o Minutos");
		return;
	}
	if (parseInt(f.minutos.value) > 59) {
		alert("El valor de minutos supera el m�ximo permitido (59)");
		return;
	}
	//document.location.href="/cgi-bin/box/sleep?" + getFormParameters(f);
	if (!isMobile && !operaMini)
		mostrarMensajeProceso();
	f.action = "/cgi-bin/box/sleep";
	f.submit();
}

function cancelarApagado() {
	if (confirm("�Est� seguro de querer cancelar el Apagado?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		document.location.href = "/cgi-bin/box/sleep?cancelar";
	}
}

//-------------------------------------------------
// Archivar grabacion
//-------------------------------------------------
function archivarGrabacion(crid, titulo) {
	var force = "";

	if (document.forms['form_m750'].ModoForce.value != 0) {
		force="&force";
	}
	if (confirm("�Est� seguro de querer archivar la grabaci�n '" + titulo + "'?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/run/archivarCrid?num_CRIDFILE=1&CRIDFILE1=" + crid + force, "RespuestaArchivoXML");
	}
}

function archivarGrabacionMarcada(id_checkbox) {
	var force = "";
	var crids = getSeleccion(id_checkbox, 'CRIDFILE', '&', 'Debe seleccionar alguna grabaci�n');

	if (document.forms['form_m750'].ModoForce.value != 0) {
		force="&force";
	}

	if (crids.length != 0) {
		if (!operaMini) {
			if (confirm("�Est� seguro de querer archivar las grabaciones seleccionadas?")) {
				if (!isMobile && !operaMini)
					mostrarMensajeProceso();
				makeRequest("/cgi-bin/run/archivarCrid?" + crids + force, "RespuestaArchivoXML");
			}
		} else {
			document.location.href = "/cgi-bin/run/archivarCrid?" + crids + force;
		}
	}
}

//-------------------------------------------------
// Restaurar grabacion
//-------------------------------------------------
function restaurarGrabacion(crid, titulo) {
	var force = "";

	if (document.forms['form_m750'].ModoForce.value != 0) {
		force="&force";
	}
	if (confirm("�Est� seguro de querer restaurar la grabaci�n '" + titulo + "'?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/run/restaurarCrid?num_CRIDFILE=1&CRIDFILE1=" + crid + force, "RespuestaArchivoXML");
	}
}

function restaurarGrabacionMarcada(id_checkbox) {
	var force = "";
	var crids = getSeleccion(id_checkbox, 'CRIDFILE', '&', 'Debe seleccionar alguna grabaci�n');

	if (document.forms['form_m750'].ModoForce.value != 0) {
		force="&force";
	}

	if (crids.length != 0) {
		if (!operaMini) {
			if (confirm("�Est� seguro de querer restaurar las grabaciones seleccionadas?")) {
				if (!isMobile && !operaMini)
					mostrarMensajeProceso();
				makeRequest("/cgi-bin/run/restaurarCrid?" + crids + force, "RespuestaArchivoXML");
			}
		} else {
			document.location.href = "/cgi-bin/run/restaurarCrid?" + crids + force;
		}
	}
}

//-------------------------------------------------
// Copiar/Mover grabacion
//-------------------------------------------------
function copiarGrabacion(crid, titulo, carpeta) {
	var force = "";

	if (document.forms['form_m750'].ModoForce.value != 0) {
		force="&force";
	}

	directorio = prompt("Introduce la carpeta de Destino para la grabaci�n '" + titulo + "'", carpeta);
	if (directorio == null) {
		alert("Debe permitir la ejecuci�n de scripts");
		return;
	}

	if (confirm("�Est� seguro de querer copiar la grabaci�n '" + titulo + "' al directorio " + directorio + "?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/run/cpmvCrid?num_CRIDFILE=1&CRIDFILE1=" + crid + "&DIR=" + directorio + "&MODO=copiar" + force);
		alert("Se ha mandado la orden de copia de la grabaci�n.\n\nSigue el proceso en la p�gina de estado.");
		setTimeout('document.location.href="/cgi-bin/box/estado?id_log=log_cpmv_record"',2000);
	}
}

function copiarGrabacionMarcada(id_checkbox, carpeta) {
	var force = "";
	var crids = getSeleccion(id_checkbox, 'CRIDFILE', '&', 'Debe seleccionar alguna grabaci�n');

	if (document.forms['form_m750'].ModoForce.value != 0) {
		force="&force";
	}

	if (crids.length != 0) {
		directorio = prompt("Introduce la carpeta de Destino para las grabaciones seleccionadas", carpeta);
		if (directorio == null) {
			alert("Debe permitir la ejecuci�n de scripts");
			return;
		}

		if (confirm("�Est� seguro de querer copiar las grabaciones seleccionadas?")) {
			if (!isMobile && !operaMini)
				mostrarMensajeProceso();
			makeRequest("/cgi-bin/run/cpmvCrid?" + crids + "&DIR=" + directorio + "&MODO=copiar" + force);
			alert("Se ha mandado la orden de copia de las grabaciones seleccionadas.\n\nSigue el proceso en la p�gina de estado.");
			setTimeout('document.location.href="/cgi-bin/box/estado?id_log=log_cpmv_record"',2000);
		}
	}
}

function moverGrabacion(crid, titulo, carpeta) {
	var force = "";

	if (document.forms['form_m750'].ModoForce.value != 0) {
		force="&force";
	}

	directorio = prompt("Introduce la carpeta de Destino para la grabaci�n '" + titulo + "'", carpeta);
	if (directorio == null) {
		alert("Debe permitir la ejecuci�n de scripts");
		return;
	}

	if (confirm("�Est� seguro de querer mover la grabaci�n '" + titulo + "' al directorio " + directorio + "?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/run/cpmvCrid?num_CRIDFILE=1&CRIDFILE1=" + crid + "&DIR=" + directorio + "&MODO=mover" + force);
		alert("Se ha mandado la orden de movimiento de la grabaci�n.\n\nSigue el proceso en la p�gina de estado.");
		setTimeout('document.location.href="/cgi-bin/box/estado?id_log=log_cpmv_record"',2000);
	}
}

function moverGrabacionMarcada(id_checkbox, carpeta) {
	var force = "";
	var crids = getSeleccion(id_checkbox, 'CRIDFILE', '&', 'Debe seleccionar alguna grabaci�n');

	if (document.forms['form_m750'].ModoForce.value != 0) {
		force="&force";
	}

	if (crids.length != 0) {
		directorio = prompt("Introduce la carpeta de Destino para las grabaciones seleccionadas", carpeta);
		if (directorio == null) {
			alert("Debe permitir la ejecuci�n de scripts");
			return;
		}

		if (confirm("�Est� seguro de querer mover las grabaciones seleccionadas?")) {
			if (!isMobile && !operaMini)
				mostrarMensajeProceso();
			makeRequest("/cgi-bin/run/cpmvCrid?" + crids + "&DIR=" + directorio + "&MODO=mover" + force);
			alert("Se ha mandado la orden de movimiento de las grabaciones seleccionadas.\n\nSigue el proceso en la p�gina de estado.");
			setTimeout('document.location.href="/cgi-bin/box/estado?id_log=log_cpmv_record"',2000);
		}
	}
}

//-------------------------------------------------
// Detener copia/traspaso de grabacion
//-------------------------------------------------
function stopCpmv(crid) {
	if (confirm("�Est� seguro de querer detener la copia/traspaso de la grabaci�n?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/run/stopCpmv", "RespuestaPeticionXML");
	}
}

//-------------------------------------------------
// Agrupar grabaciones en serie
//-------------------------------------------------
function agruparGrabacionMarcada(id_checkbox) {
	var new_IDserie = document.forms['form_m750'].IDserie.value;
	var crids = getSeleccion(id_checkbox, 'CRIDFILE', '&', 'Debe seleccionar alguna grabaci�n');

	if (crids.length != 0) {
		// Gestion nueva serie: generar IDserie (no se a�ade a info_series.txt/xml porque se regenera a continuacion)
		if (new_IDserie == -1 ) {
			new_IDserie = - Math.floor(new Date().getTime()/1000);
		}

		if (!operaMini) {
			if (confirm("�Est� seguro de querer agrupar las grabaciones seleccionadas?")) {
				if (!isMobile && !operaMini)
					mostrarMensajeProceso();
				makeRequest("/cgi-bin/run/agruparCrid?id_serie=" + new_IDserie + "&" + crids, "RespuestaPeticionXML");
			}
		} else {
			document.location.href = "/cgi-bin/run/agruparCrid?" + crids;
		}
	}
}

//-------------------------------------------------
// Descargar grabacion
//-------------------------------------------------
function descargarGrabacion(crid) {
	document.location.href = "/cgi-bin/box/ctl-dlCrid?num_CRIDFILE=1&CRIDFILE1=" + crid;
}

function descargarGrabacionMarcada(id_checkbox) {
	var crids = getSeleccion(id_checkbox, 'CRIDFILE', '&', 'Debe seleccionar alguna grabaci�n');

	if (crids.length != 0) {
		document.location.href = "/cgi-bin/box/ctl-dlCrid?" + crids;
	}
}
 
//-------------------------------------------------
// Montaje/desmontaje de USB2 en /var/media/SWAP
//-------------------------------------------------
function montarUSB2(accion) {
	if (confirm("�Est� seguro de querer " + accion + " el dispositivo USB2 en el directorio /var/media/SWAP?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/box/mount-usb2?id=" + accion, "RespuestaPeticionXML");
	}
}

//-------------------------------------------------
// Borrar ficheros fmpg huerfanos
//-------------------------------------------------
function borrarHuerfanos(carpeta) {
	if (confirm("�Est� seguro de querer borrar los fragmentos de grabaci�n huerfanos de la carpeta " + carpeta + " ?")) {
		if (!isMobile && !operaMini)
			mostrarMensajeProceso();
		makeRequest("/cgi-bin/run/borrarHuerfanos?" + carpeta);
		alert("Se ha mandado la orden de borrado de fragmentos de grabaci�n huerfanos.\n\nSigue el proceso en la p�gina de estado.");
		document.location.href = "/cgi-bin/box/estado?id_log=log_fmpg_huerfanos";
	}
}


//-------------------------------------------------
// Respuesta a peticiones de grabacion/cancelacion/borrado
//-------------------------------------------------
function RespuestaPeticionXML(xmldoc) {
	var result=xmldoc.getElementsByTagName("RESULT");
	switch(result[0].firstChild.data) {
	case "OK":
		alert("Petici�n aceptada por el M750");
		document.location.reload();
		break
	case "ERROR_LOGIN":
		alert("Para tener acceso a esta aplicacion web antes debe validarse con su usuario y contrase�a.\n\nAhora ser� redirigido a la p�gina de login para introducir sus datos.");
		document.location.href = "/index.html";
		break
	default:
		alert("Petici�n NO aceptada por el M750");
	}
	if (!isMobile && !operaMini)
		eliminarMensajeProceso();
}

function RespuestaPeticionXML_NR(xmldoc) {
	var result=xmldoc.getElementsByTagName("RESULT");
	switch(result[0].firstChild.data) {
	case "OK":
		alert("Petici�n aceptada por el M750");
		break
	case "ERROR_LOGIN":
		alert("Para tener acceso a esta aplicacion web antes debe validarse con su usuario y contrase�a.\n\nAhora ser� redirigido a la p�gina de login para introducir sus datos.");
		document.location.href = "/index.html";
		break
	default:
		alert("Petici�n NO aceptada por el M750");
	}
	if (!isMobile && !operaMini)
		eliminarMensajeProceso();
}

function RespuestaArchivoXML(xmldoc) {
	var result=xmldoc.getElementsByTagName("RESULT");
	switch(result[0].firstChild.data) {
	case "OK":
		alert("Petici�n aceptada por el M750");
		document.location.reload();
		break
	case "ERROR_LOGIN":
		alert("Para tener acceso a esta aplicacion web antes debe validarse con su usuario y contrase�a.\n\nAhora ser� redirigido a la p�gina de login para introducir sus datos.");
		document.location.href = "/index.html";
		break
	case "FALLO":
		alert("Petici�n NO aceptada por el M750.\n\nLos ficheros .fmpg son compartidos por varios .crid.")
		break
	default:
		alert("Petici�n NO aceptada por el M750");
	}
	if (!isMobile && !operaMini)
		eliminarMensajeProceso();
}

//-------------------------------------------------
// Respuestas a peticiones makeRequest
//-------------------------------------------------
// Respuesta ERROR_LOGIN -> Login incorrecto
function noReplyLogin(xmldoc) {
	var result=xmldoc.getElementsByTagName("RESULT");
	if (result[0].firstChild.data == "ERROR_LOGIN") {
		alert("Para tener acceso a esta aplicacion web antes debe validarse con su usuario y contrase�a.\n\nAhora ser� redirigido a la p�gina de login para introducir sus datos.");
		document.location.href = "/index.html";
	}
}

//-------------------------------------------------
