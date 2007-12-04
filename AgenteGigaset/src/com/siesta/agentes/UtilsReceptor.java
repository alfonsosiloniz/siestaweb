package com.siesta.agentes;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

public final class UtilsReceptor
{
    public static final int AGENTE_OK = 0;
    public static final int AGENTE_ERROR = 2;
    public static final int AGENTE_ERROR_ORDEN = 3;
    public static final int AGENTE_TRAZA = 4;
    public static final int AGENTE_RESULTADO = 5;
    public static final String AGENTE_TRAZA_RESULTADO = "RESULTADO: ";

    public UtilsReceptor() {
    }

    public static void escribirLog(String traza) {
        Calendar cal = Calendar.getInstance();
        Date ahora = cal.getTime();
        try {
            PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("trazaAgente.log", true)), true);
            String trazaOut = getFecha(ahora) + " . " + traza;
            out.println(trazaOut);
            out.flush();
            out.close();
            System.out.println(trazaOut);
        }
        catch (IOException ioexception) {
        }
    }

    public static void responder(OutputStream out, String mensaje) {
        PrintWriter pw = new PrintWriter(out, true);
        pw.println(mensaje);
        escribirLog(mensaje);
        pw.flush();
    }
    
    public static void responder(OutputStream out, long mensaje) {
        PrintWriter pw = new PrintWriter(out, true);
        pw.println("" + mensaje);
        escribirLog("" + mensaje);
        pw.flush();
    }

    public static void responder(OutputStream out, Throwable e) {
        StringWriter stringWriter = new StringWriter();
        PrintWriter printWriter = new PrintWriter(stringWriter);
        e.printStackTrace(printWriter);
        printWriter.flush();
        ByteArrayInputStream in = new ByteArrayInputStream(stringWriter.toString().getBytes());
        responder(out, ((InputStream) (in)));
    }

    public static void responder(OutputStream out, InputStream mensaje) {
        PrintWriter pw = new PrintWriter(out, true);
        BufferedReader buff = new BufferedReader(new InputStreamReader(mensaje));
        try {
            while (buff.ready()) {
                pw.println(buff.readLine());
                escribirLog(buff.readLine());
            }
        }
        catch (IOException e) {
            pw.println(e.toString());
            escribirLog(e.toString());
        }
        pw.flush();
    }

    public static void responder(OutputStream out, int codigo) {
        PrintWriter pw = new PrintWriter(out, true);
        pw.println(Integer.toString(codigo));
        escribirLog(Integer.toString(codigo));
        pw.flush();
    }
    

    public static String getParent(String dir) {
        File temp = new File(dir);
        String tempDir = temp.getParent();
        if (tempDir.charAt(tempDir.length() - 1) != File.separatorChar)
            tempDir = tempDir + File.separatorChar;
        return tempDir;
    }
    
    private static String getFecha(Date ent) {
        Calendar fecha = Calendar.getInstance();
        StringBuffer data = new StringBuffer("");
        if (ent != null) {
            fecha.setTime(ent);
            int dia = fecha.get(5);
            int mes = fecha.get(2) + 1;
            int aF1o = fecha.get(1);
            int hora = fecha.get(11);
            int minuto = fecha.get(12);
            int segundo = fecha.get(13);
            if (dia < 10)
                data.append("0" + dia + "/");
            else
                data.append(dia + "/");
            if (mes < 10)
                data.append("0" + mes + "/");
            else
                data.append(mes + "/");
            data.append(aF1o);
            if (hora < 10)
                data.append(" 0" + hora + ":");
            else
                data.append(" " + hora + ":");
            if (minuto < 10)
                data.append("0" + minuto + ":");
            else
                data.append(minuto + ":");
            if (segundo < 10)
                data.append("0" + segundo);
            else
                data.append(segundo);
        }
        return data.toString();
    }
    
    public static String replaceString(String cadena, String oldstr, String newstr) {
        StringBuffer sb = new StringBuffer();
        int lenstr = cadena.length();
        int lenold = oldstr.length();
        int ultimo = lenstr - lenold;
        for (int i = 0; i < lenstr; i++) {
            if (i <= ultimo && cadena.substring(i, i + lenold).compareTo(oldstr) == 0) {
                sb.append(newstr);
                i = i + lenold - 1;
            }
            else {
                sb.append(cadena.charAt(i));
            }
        }
        return sb.toString();
    }

}
