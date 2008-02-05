
package com.siesta.agentes;

import java.io.FileInputStream;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Properties;

import javax.net.ServerSocketFactory;

public class AgenteReceptor
{
    public static final int AGENTE_OK = 0;
    public static final int AGENTE_ERROR_ORDEN = 3;
    public static final int AGENTE_ERROR = 2;
    public static final int AGENTE_TRAZA = 4;
    public static final int AGENTE_RESULTADO = 5;
    
    public static int serverPort = 10000;
    private static Properties config = null;
    private static ScriptLauncher runningProcess = null;

    public static void main(String args[]) {
        UtilsReceptor.escribirLog("ARRANQUE DEL AGENTE GIGASET M750 (c) Grupo SIESTA, ver. 1.1");
        UtilsReceptor.escribirLog("os.arch = " + System.getProperty("os.arch"));
        UtilsReceptor.escribirLog("os.name = " + System.getProperty("os.name"));
        UtilsReceptor.escribirLog("os.version = " + System.getProperty("os.version"));
        
        config = new Properties();
        try {
            FileInputStream in = new FileInputStream("AgenteConfig.prop");
            config.load(in);
            in.close();
            serverPort = Integer.parseInt(config.getProperty("PUERTO").trim());
        }
        catch (IOException e) {
            UtilsReceptor.escribirLog("Problemas en el fichero de configuraciones : " + e.getMessage());
            System.exit(-1);
        }
        try {
            ServerSocket conexion = new ServerSocket(serverPort);
            UtilsReceptor.escribirLog("Socket abierto en puerto = " + conexion.getLocalPort());
            do {
                Socket peticion = conexion.accept();
                java.io.OutputStream out = peticion.getOutputStream();
                String ipSession = peticion.getInetAddress().getHostAddress();
                UtilsReceptor.escribirLog("PETICION RECIBIDA DE " + ipSession + ":" + peticion.getPort());
            
                EjecutorAgenteReceptor agente = new EjecutorAgenteReceptor(peticion);
                agente.start();
            }
            while (true);
        }
        catch (IOException e) {
            UtilsReceptor.escribirLog("IOException en el socket " + e.getMessage());
        }
        System.exit(-1);
    }
    
    public static Properties getConfig() {
        return config;
    }

    public static ScriptLauncher getRunningProcess() {
        return runningProcess;
    }

    public static void setRunningProcess(ScriptLauncher runningProcess) {
        AgenteReceptor.runningProcess = runningProcess;
    }
}
