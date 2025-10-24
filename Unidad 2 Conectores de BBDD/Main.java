package org.dam;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) throws SQLException {

        ConexionDB  con = new ConexionDB();
        if (con.getConexion()!=null) {
            System.out.println("Conexión establecida");
        }
        else System.out.println("Conexión no establecida");

        //with a previous connection
        String tabla="Juego";
        ResultSet rst = null;
        try {
            rst = con.getConexion().createStatement().executeQuery("SELECT * FROM " +tabla);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        System.out.println(Colores.Cyan);
        System.out.println("");
        System.out.println("Contenido de " + tabla);
        System.out.println("******************************");

        ResultSetMetaData rsmdQuery = null;
        try {
            rsmdQuery = rst.getMetaData();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

// print the colum
        for (int i = 1; i <= rsmdQuery.getColumnCount(); i++)
            System.out.print(String.format("%-25.25s",rsmdQuery.getColumnName(i)));

        System.out.println();
        System.out.println(Colores.Reset);

// print the values
        while (rst.next()) {
            for (int i = 1; i <= rsmdQuery.getColumnCount(); i++)
                System.out.print(String.format("%-25.25s ",rst.getString(i)));
            System.out.println();
        }
    }
}