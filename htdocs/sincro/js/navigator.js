isW3C = (document.getElementById && !document.all) ? 1 : 0;
isNS4 = (document.layers) ? 1 : 0;
var agt=navigator.userAgent.toLowerCase();
var appVer = navigator.appVersion.toLowerCase();
var is_mac = (agt.indexOf("mac")!=-1);
var iePos  = appVer.indexOf('msie');
if (iePos !=-1) {
   if(is_mac) {
       var iePos = agt.indexOf('msie');
       is_minor = parseFloat(agt.substring(iePos+5,agt.indexOf(';',iePos)));
   }
   else is_minor = parseFloat(appVer.substring(iePos+5,appVer.indexOf(';',iePos)));
   is_major = parseInt(is_minor);
}
var is_opera = (agt.indexOf("opera") != -1);
var is_safari = ((agt.indexOf('safari')!=-1)&&(agt.indexOf('mac')!=-1))?true:false;
var is_khtml  = (is_safari || is_konq);
var is_konq = false;
var kqPos   = agt.indexOf('konqueror');
if (kqPos !=-1) {                 
   is_konq  = true;
   is_minor = parseFloat(agt.substring(kqPos+10,agt.indexOf(';',kqPos)));
   is_major = parseInt(is_minor);
}                                 
var is_ie   = ((iePos!=-1) && (!is_opera) && (!is_khtml));
