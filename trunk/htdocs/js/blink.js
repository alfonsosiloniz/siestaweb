// Función que sirve para hacer que un texto aparezca parpadeando.
// Uso: <blink>texto que queremos que parpadee</blink>
// Autores: JP & Isi
// Fecha : 17/02/2005
blink = true;
window.setInterval("blinken()", 500);
function blinken() {
	if(navigator.appName.indexOf('Netscape') == -1){
		var i = document.getElementsByTagName("blink").length;
		for(var j=0;j<i;j++) {
			if (blink) {
				document.getElementsByTagName("blink")[j].style.visibility = "hidden";
			}
			else {
				document.getElementsByTagName("blink")[j].style.visibility = "visible";
			}
		}
		blink = !blink;
	}
}
