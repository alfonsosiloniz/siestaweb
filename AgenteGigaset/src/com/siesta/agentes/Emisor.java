package com.siesta.agentes;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

public class Emisor
{
    public static final int AGENTE_OK = 0;
    public static final int AGENTE_ERROR = 2;
    public static final int AGENTE_ERROR_ORDEN = 3;
    public static final int AGENTE_TRAZA = 4;
    public static final int AGENTE_RESULTADO = 5;
    private static Socket conexion;
    private static InputStream in;
    private static OutputStream out;
    private static ArrayList listaTrazas;
    private static ArrayList listaResultados;

    public static void main(String args[]) {
        try {
            conexion = new Socket(args[0], Integer.parseInt(args[1]));
            in = conexion.getInputStream();
            out = conexion.getOutputStream();
            listaTrazas = new ArrayList();
            listaResultados = new ArrayList();
            System.out.println("ORDEN = " + args[2]);
            int ret = transmitir(args[2]);
            //transmitir("FIN_TRANSMISION");
            out.close();
            in.close();
            conexion.close();
            if (ret != 0)
                escribirLog("FALLO EN LA ORDEN");
            guardarLogs(listaResultados);
        }
        catch (Exception e) {
            escribirLog("EXCEPCION " + e.getMessage());
        }
    }
    
    public Emisor() {
    }

    private static void escribirLog(String traza) {
        System.out.println("LOG");
        Calendar cal = Calendar.getInstance();
        Date ahora = cal.getTime();
        try {
            PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("trazaEmisor.log", true)), true);
            out.println(getFecha(ahora) + " . " + traza);
            out.close();
            System.out.println(getFecha(ahora) + " . " + traza);
        }
        catch (IOException e) {
            System.out.println("Imposible abrir el fichero de logs");
        }
    }

    private static int transmitir(String orden) {
        int ret = 0;
        boolean acabar = false;
        String ipOrigenOrden = "localhost";
        try {
            PrintWriter pw;
            if (orden.equals("FIN_TRANSMISION")) {
                pw = new PrintWriter(out, true);
                pw.println(ipOrigenOrden + " " + orden);
                return 0;
            }
            listaTrazas.clear();
            listaResultados.clear();
            pw = new PrintWriter(out, true);
            pw.println(ipOrigenOrden + " " + orden);
            BufferedReader buf = new BufferedReader(new InputStreamReader(in));
            
            while (!acabar) {
                String lista;
                for (lista = null; lista == null; lista = buf.readLine());
                System.out.println("RESULT = " + lista);
                ret = 0;
                acabar = true;
            }
        }
        catch (IOException e) {
            ret = 2;
            escribirLog("IOException; Clase:AgenteEmisor; Metodo:transmitir; " + e.getMessage());
        }
        return ret;
    }

    private static void guardarLogs(ArrayList logs) {
        for (int i = 0; i < logs.size(); i++)
            escribirLog("Traza Agente: " + logs.get(i));

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
}
