/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dam;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Manu
 */
public class ConexionDB {

    private Connection laConexion = null;

    private String dbName = null;
    

    public ConexionDB() {
        this.dbName=null;
    }

    public ConexionDB(String dbName) {
        this.dbName = dbName;
    }
    
    
    private void abrirConnexion() {

        if (laConexion == null) {

            Properties config = new Properties();
            try {

                Class.forName("com.mysql.cj.jdbc.Driver");

                config.load(new FileInputStream("conexion.properties"));

                //System.out.println(config.toString());

                String port = config.getProperty("port");
                String server = config.getProperty("server");
                
                 if (dbName==null)
                     dbName=config.getProperty("dbName");

                String connectionUrl = "jdbc:mysql://" + server + ":" + port +"/" + dbName;

                
                Properties p = new Properties();
                
                p.put("user", config.getProperty("user"));
                p.put("password", config.getProperty("password"));
                p.put("allowMultiQueries", config.getProperty("allowMultiQueries"));
                laConexion = DriverManager.getConnection(connectionUrl, p);
                 
               // laConnexio = DriverManager.getConnection(connectionUrl, config);

                System.out.println("Connection to MySQL has been established with DB: " + dbName);

            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } catch (SQLException e) {
                System.out.println("Error:" + e.getMessage());
            } catch (ClassNotFoundException e) {
                System.out.println(e.getMessage());
            }
        }

    }

    public Connection getConexion() {
        if (laConexion == null) {
            abrirConnexion();
        }
        return laConexion;
    }

    public void closeConexion() {
        if (laConexion != null) {
            try {
                laConexion.close();
            } catch (SQLException e) {
                Logger.getLogger(ConexionDB.class.getName()).log(Level.SEVERE, null, e);
            }
        }
        laConexion = null;
    }

}
