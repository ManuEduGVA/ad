/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
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
public class ConnexionDB {

    private Connection laConnexion = null;

    private String dbName;
    

    public ConnexionDB() {
        this.dbName="";
    }

    public ConnexionDB(String dbName) {
        this.dbName = dbName;
    }
    
    
    private void abrirConnexion() {

        if (laConnexion == null) {

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
                laConnexion = DriverManager.getConnection(connectionUrl, p);
                 
               // laConnexio = DriverManager.getConnection(connectionUrl, config);

                System.out.println("Connection to MySQL has been established with DB: " + dbName);

            } catch (FileNotFoundException fnfe) {
                fnfe.printStackTrace();
            } catch (IOException ioe) {
                ioe.printStackTrace();
            } catch (SQLException ex) {
                System.out.println("Error:" + ex.getMessage());
            } catch (ClassNotFoundException ex) {
                System.out.println(ex.getMessage());
            }
        }

    }

    public Connection getConnexion() {
        if (laConnexion == null) {
            abrirConnexion();
        }

        return laConnexion;

    }

    public void tancarConnexio() {
        if (laConnexion != null) {
            try {
                laConnexion.close();
            } catch (SQLException ex) {
                Logger.getLogger(ConnexionDB.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        laConnexion = null;
    }

}
