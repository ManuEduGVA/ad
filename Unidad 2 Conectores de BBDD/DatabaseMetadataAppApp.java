package DatabaseMeta;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author Manu
 */
public class App {

    public static void main(String[] args) {
         
  try {
            ConexionDB laConexionDB = new ConexionDB("BDJuegos");

            Connection con = laConexionDB.getConexion();

            DatabaseMetaData dbmd = con.getMetaData();

            System.out.println("\nDBMS information--------");
            System.out.println("DBMS:\t" + dbmd.getDatabaseProductName());
            System.out.println("DBMS:\t" + dbmd.getDriverName());
            System.out.println("DBMS:\t" + dbmd.getURL());
            System.out.println("DBMS:\t" + dbmd.getUserName());

            System.out.println(String.format("%-15s %-15s %-15s ", "Database", "Table", "Type"));
            System.out.println("-------------------------------------------------------");
            ResultSet rsmd = dbmd.getTables("BDJuegos", null, null, null);
            while (rsmd.next()) {
                System.out.println(String.format("%-15s %-15s %-15s", rsmd.getString(1), rsmd.getString(3), rsmd.getString(4)));
            }

            rsmd.close();

            String table = "Genero"; // we set the name of an existing table
            ResultSet columnas = dbmd.getColumns("BDJuegos", null, table, null);

            System.out.println(String.format("%-25s %-15s %-15s ", "Atributo/Claves", "Tipo", "¿Puede ser nulo?"));
            while (columnas.next()) {
                String columnName = columnas.getString(4);
                String tipo = columnas.getString(6);
                String nullable = columnas.getString(18);

                System.out.println(String.format("%-25s %-15s %-15s", columnName, tipo, nullable));
            }
            con.close();

        } catch (SQLException ex) {
            System.out.println(ex);
        }

    }
}
