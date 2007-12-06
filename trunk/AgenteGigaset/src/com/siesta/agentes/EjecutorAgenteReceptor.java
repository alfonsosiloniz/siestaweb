// Decompiled by Jad v1.5.8e. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/kpdus/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   EjecutorAgenteReceptor.java

package com.siesta.agentes;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.StringTokenizer;

public class EjecutorAgenteReceptor extends Thread
{
    public static final int PING = 99;
    public static final int AVI2MPEG2 = 1;
    public static final int ESTADO = 2;
    public static final int CMD = 3;
    private Socket conexion;
    private OutputStream out;
    private InputStream comando;

    public EjecutorAgenteReceptor(Socket s) {
        conexion = s;
    }

    public void run() {
        try {
            comando = conexion.getInputStream();
            out = conexion.getOutputStream();
            boolean acabar = false;
            long timestampInicio = Calendar.getInstance().getTime().getTime();
            while (!acabar) {
                ArrayList listaOrdenes = desglosarOrden(comando);
                if (listaOrdenes == null) {
                    UtilsReceptor.responder(out, AgenteReceptor.AGENTE_ERROR);
                    break;
                }
                System.out.println("Ordenes desglosadas OK.");
                int orden = buscarPeticion((String) listaOrdenes.get(1));
                System.out.println("Orden traducida: " + orden);
                System.out.println("Orden recibida : " + listaOrdenes.toString());
                timestampInicio = Calendar.getInstance().getTime().getTime();
                switch (orden) {
                case PING:
                    ping();
                    acabar = true;
                    break;

                case AVI2MPEG2:
                    avi2mpeg(listaOrdenes);
                    acabar = true;
                    break;

                case ESTADO:
                    estado();
                    acabar = true;
                    break;

                case CMD:
                    ejecutarComando(listaOrdenes);
                    acabar = true;
                    break;
                default:
                    UtilsReceptor.responder(out, "NOK");
                    acabar = true;
                    break;
                }
                long timestampActual = Calendar.getInstance().getTime().getTime();
                if (timestampActual > timestampInicio + 0xdbba0L) {
                    acabar = true;
                    System.out.println("Thread finalizado por timeout. Petici\363n de origen : " + conexion.getInetAddress().getHostAddress() + ":" + conexion.getPort());
                }
            }
            System.out.println("Thread finalizado. Petici\363n de origen : " + conexion.getInetAddress().getHostAddress() + ":" + conexion.getPort());
        }
        catch (IOException e) {
            System.out.println("IOException : " + e.toString() + " .... Petici\363n de origen : " + conexion.getInetAddress().getHostAddress() + ":" + conexion.getPort());
            e.printStackTrace();
        }
        catch (Throwable e) {
            System.out.println("Exception : " + e.toString() + ".... Petici\363n de origen : " + conexion.getInetAddress().getHostAddress() + ":" + conexion.getPort());
            UtilsReceptor.responder(out, 2);
            e.printStackTrace();
        }
        finally {
            try {
                if (out != null)
                    out.close();
                if (comando != null)
                    comando.close();
                if (conexion != null)
                    conexion.close();
            }
            catch (IOException ioexception) {
            }
        }
        return;
    }

    private int buscarPeticion(String primerParametro) {
        if (primerParametro.equalsIgnoreCase("PING"))
            return PING;
        else if (primerParametro.equalsIgnoreCase("AVI2MPEG"))
            return AVI2MPEG2;
        else if (primerParametro.equalsIgnoreCase("ESTADO"))
            return ESTADO;
        else if (primerParametro.equalsIgnoreCase("CMD"))
            return CMD;
        return -1;
    }

    private ArrayList desglosarOrden(InputStream comando) throws Exception {
        ArrayList listaOrdenes = new ArrayList();
        try {
            BufferedReader buf = new BufferedReader(new InputStreamReader(comando));
            String lista = buf.readLine();
            if (lista == null) {
                listaOrdenes.add("FIN_TRANSMISION");
                return listaOrdenes;
            }
            StringTokenizer listaTokens = new StringTokenizer(lista);
            StringBuffer stringOrdenes = new StringBuffer();
            while (listaTokens.hasMoreElements()) {
                String temp = (String) listaTokens.nextElement();
                if (temp != null && temp.length() > 0) {
                    listaOrdenes.add(temp);
                    stringOrdenes.append(" ").append(temp);
                }
            }
            String log = "COMANDO " + stringOrdenes.toString();
            System.out.println(log);
            // UtilsReceptor.responder(out, 4, log);
        }
        catch (IOException e) {
            listaOrdenes.add("FIN_TRANSMISION");
        }
        return listaOrdenes;
    }

    private void ping() {
        String extensiones = AgenteReceptor.getConfig().getProperty("EXTENSIONES");
        UtilsReceptor.responder(out, extensiones);
    }

    private void ejecutarComando(ArrayList listaOrdenes) {
        String sourceFile = "", sourceFilePC = "";
        for (int i = 2; i < listaOrdenes.size(); ++i) {
            sourceFile += (String) listaOrdenes.get(i) + " ";
        }
        sourceFile = sourceFile.trim();
        if (sourceFile.length() > 0) {
            sourceFilePC = conversionPath(sourceFile);
            if (sourceFilePC != null) {
                File file = new File(sourceFilePC);
                if (file.exists()) {
                    try {
                        UtilsReceptor.escribirLog("[CMD]; Script = " + sourceFilePC);

                        ScriptLauncher scriptLauncher = new ScriptLauncher(sourceFilePC, "");
                        scriptLauncher.start();
                        Thread.sleep(1000);
                        if (scriptLauncher.getEstado() == ScriptLauncher.ESTADO_RUNNING)
                            UtilsReceptor.responder(out, "OK");
                        else if (scriptLauncher.getEstado() == ScriptLauncher.ESTADO_ENDOK)
                            UtilsReceptor.responder(out, "OK");
                        else
                            UtilsReceptor.responder(out, "NOK [Error lanzando script "+sourceFile+"]");
                    }
                    catch (Exception e) {
                        e.printStackTrace();
                        UtilsReceptor.responder(out, "NOK [Error lanzando script "+sourceFile+"]");
                    }
                }
                else {
                    // El AVI no existe
                    finalizarProcesoActual();
                    UtilsReceptor.responder(out, "NOK [File not found]");
                }
            }
            else {
                // No se ha configurado la unidad PCn en el fichero de
                // properties
                UtilsReceptor.responder(out, "NOK [La unidad del Gigaset no esta configurada en el ficheros de propiedades]");
            }
        }
        else {
            // No se ha pasado nombre de fichero a la orden
            UtilsReceptor.responder(out, "NOK");
        }
    }

    private void avi2mpeg(ArrayList listaOrdenes) {
        String sourceFile = "", sourceFilePC = "";
        for (int i = 2; i < listaOrdenes.size(); ++i) {
            sourceFile += (String) listaOrdenes.get(i) + " ";
        }
        sourceFile = sourceFile.trim();
        if (sourceFile.length() > 0) {
            if (sourceFile.equalsIgnoreCase("END")) {
                finalizarProcesoActual();
                UtilsReceptor.responder(out, "OK");
            }
            else {
                sourceFilePC = conversionPath(sourceFile);
                if (sourceFilePC != null) {
                    File file = new File(sourceFilePC);
                    if (file.exists()) {
                        try {
                            UtilsReceptor.escribirLog("[AVI2MPEG]; Source File = " + sourceFilePC);
                            String scriptName = AgenteReceptor.getConfig().getProperty("SCRIPT_NAME");

                            // Antes de lanzar la compresion del video,
                            // comprobamos si hay otro video comprimiendos y lo
                            // matamos.
                            finalizarProcesoActual();

                            ScriptLauncher scriptLauncher = new ScriptLauncher(scriptName, "\"" + sourceFilePC + "\"");
                            AgenteReceptor.setRunningProcess(scriptLauncher);
                            scriptLauncher.start();
                            Thread.sleep(1000);
                            if (scriptLauncher.getEstado() == ScriptLauncher.ESTADO_RUNNING)
                                UtilsReceptor.responder(out, "OK " + sourceFile + ".mpg");
                            else if (scriptLauncher.getEstado() == ScriptLauncher.ESTADO_ENDOK)
                                UtilsReceptor.responder(out, "OK " + sourceFile + ".mpg");
                            else
                                UtilsReceptor.responder(out, "NOK [Error lanzando script de conversion]");
                        }
                        catch (Exception e) {
                            e.printStackTrace();
                            UtilsReceptor.responder(out, "NOK [Error lanzando script de conversion]");
                        }
                    }
                    else {
                        // El AVI no existe
                        finalizarProcesoActual();
                        UtilsReceptor.responder(out, "NOK [File not found]");
                    }
                }
                else {
                    // No se ha configurado la unidad PCn en el fichero de
                    // properties
                    UtilsReceptor.responder(out, "NOK [La unidad del Gigaset no esta configurada en el ficheros de propiedades]");
                }
            }
        }
        else {
            // No se ha pasado nombre de fichero a la orden
            UtilsReceptor.responder(out, "NOK");
        }
    }

    private void finalizarProcesoActual() {
        if (AgenteReceptor.getRunningProcess() != null /*
                                                         * &&
                                                         * AgenteReceptor.getRunningProcess().getEstado() ==
                                                         * ScriptLauncher.ESTADO_RUNNING
                                                         */) {
            AgenteReceptor.getRunningProcess().kill();
        }
    }

    private void estado() {
        if (AgenteReceptor.getRunningProcess() != null) {
            switch (AgenteReceptor.getRunningProcess().getEstado()) {
            case ScriptLauncher.ESTADO_READY:
            case ScriptLauncher.ESTADO_RUNNING:
                UtilsReceptor.responder(out, "RUNNING");
                break;
            case ScriptLauncher.ESTADO_ENDOK:
                UtilsReceptor.responder(out, "END_OK");
                break;
            case ScriptLauncher.ESTADO_ENDNOK:
                UtilsReceptor.responder(out, "END_NOK");
                break;
            default:
                UtilsReceptor.responder(out, "END_OK");
            }
        }
        else {
            UtilsReceptor.responder(out, "END_OK");
        }
    }

    private String conversionPath(String sourceFile) {
        String unidadPC = null;
        if (sourceFile.startsWith("/var/media/PC1") || sourceFile.startsWith("/pvr/media/PC1")) {
            unidadPC = AgenteReceptor.getConfig().getProperty("PC1");
        }
        else if (sourceFile.startsWith("/var/media/PC2") || sourceFile.startsWith("/pvr/media/PC2")) {
            unidadPC = AgenteReceptor.getConfig().getProperty("PC2");
        }
        else if (sourceFile.startsWith("/var/media/PC3") || sourceFile.startsWith("/pvr/media/PC3")) {
            unidadPC = AgenteReceptor.getConfig().getProperty("PC3");
        }
        else if (sourceFile.startsWith("/var/media/PC4") || sourceFile.startsWith("/pvr/media/PC4")) {
            unidadPC = AgenteReceptor.getConfig().getProperty("PC4");
        }
        else if (sourceFile.startsWith("/var/media/PC5") || sourceFile.startsWith("/pvr/media/PC5")) {
            unidadPC = AgenteReceptor.getConfig().getProperty("PC5");
        }
        else if (sourceFile.startsWith("/var/media/USB-HDD") || sourceFile.startsWith("/pvr/media/USB-HDD")) {
            unidadPC = AgenteReceptor.getConfig().getProperty("USB-HDD");
        }
        if (unidadPC == null)
            return null;
        sourceFile = sourceFile.substring(15);
        if (!unidadPC.endsWith("/") && !unidadPC.endsWith("\\"))
            unidadPC += File.separator;

        String fileName = unidadPC + sourceFile;

        if (System.getProperty("os.name").startsWith("Windows")) {
            fileName = UtilsReceptor.replaceString(fileName, "/", "\\");
        }
        System.out.println("Nombre traducido a PC: " + fileName);
        return fileName;
    }
}
