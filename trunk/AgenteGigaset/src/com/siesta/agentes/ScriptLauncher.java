/*
 * Creado el 21/11/2007
 */
package com.siesta.agentes;

import java.io.IOException;

public class ScriptLauncher extends Thread
{
    public static final int ESTADO_READY = 0;
    public static final int ESTADO_RUNNING = 1;
    public static final int ESTADO_ENDOK = 2;
    public static final int ESTADO_ENDNOK = 3;
    
    public static final String TITULO_CMD = "RecompresionVideo";
    
    public static boolean blnWork = true; 
    private String scriptName = null;
    private String scriptParams = null;
    private int estado;
    
    public ScriptLauncher(String scriptName, String params) {
        this.scriptName = scriptName;
        this.scriptParams = params;
    }

    public void run() {
        this.estado = ESTADO_RUNNING;
        try {
            Process proc = null;
            if (System.getProperty("os.name").startsWith("Windows")) {
                String orden = "lanzador.cmd \"" + TITULO_CMD + "\" " + scriptName + " " + scriptParams;
                proc = Runtime.getRuntime().exec(orden);
                System.out.println("Proceso lanzado: [" + orden + "]");
            }
            else {
                String script = this.scriptName;
                if (!this.scriptName.startsWith("/") && !this.scriptName.startsWith("."))
                    script = "./" + script;
                proc = Runtime.getRuntime().exec(script + " " + this.scriptParams);
                System.out.println("Proceso lanzado: [" + script + " " + this.scriptParams + "]");
            }

            // Aquí el proceso se ha lanzado, y el thread continua
            boolean conversionEnded = false;
            while (blnWork && !conversionEnded) {
                Thread.sleep(1000); // Duerme 1 segundo
                // Chequea si el proceso ha terminado
                try {
                    proc.exitValue();
                    // Si el proceso no ha terminado, se lanza una excepción. Si ha terminado, continua el
                    conversionEnded = true;
                    this.estado = ESTADO_ENDOK;
                }
                catch (IllegalThreadStateException ie) {
                    this.estado = ESTADO_RUNNING;
                }
            } 
        }
        catch (Exception e) {
            System.out.println("Se ha producido un error lanzando el script ["+this.scriptName+"]");
            e.printStackTrace();
            this.estado = ESTADO_ENDNOK;
        }
    }
    
    public int kill() {
        blnWork = false;
        Runtime runtime = Runtime.getRuntime();
        try {
            Process proc = null;
            if (System.getProperty("os.name").startsWith("Windows")) {
                String orden = "taskkill /F /T /FI \"WINDOWTITLE eq " + TITULO_CMD + "*\" /IM cmd.exe";
                proc = runtime.exec(orden);
            }
            else {
                String orden = "pkill -9 " + scriptName;
                proc = runtime.exec(orden);
            }
            proc.waitFor();
            this.estado = ESTADO_ENDNOK;    // Marcamos el fin de la compresión como NOK
            
            System.out.println("Procesos de compresion finalizados correctamente");
            return ESTADO_ENDOK;            // La orden de kill ha ido OK
        }
        catch (Exception e) {
            System.out.println("Error finalizando procesos de compresion");
            return ESTADO_ENDNOK;
        }
    }

    public int getEstado() {
        return this.estado;
    }
}
