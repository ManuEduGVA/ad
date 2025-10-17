# 6. Statements and CRUD operations

En esta sección estudiaremos el principal objetivo de trabajar con bases de datos: manipular datos. Siempre trabajaremos con la misma plantilla:

1. Conectar a la base de datos.
2. Preparar la consulta.
3. Ejecutar la consulta.
4. Procesamiento de los datos, si es necesario.

El punto 1 se ha estudiado en las secciones anteriores.

Para crear las consultas, deberemos utilizar las siguientes clases/interfaces:

- `Statement` → Se utiliza de forma general y es útil cuando queremos realizar **sentencias SQL estáticas**, ya que no acepta parámetros. Creamos un `Statement` con el método `createStatement()` de la clase `Connection`.
- `PreparedStatement` → Se utiliza cuando queremos lanzar varias consultas y, además, se permite realizar **sentencias dinámicas**. Creamos un `PreparedStatement` con el método `prepareStatement()` de la clase `Connection`.
- `CallableStatement` → Se utiliza para acceder a procedimientos almacenados en la base de datos y también acepta parámetros de entrada. Creamos un `CallableStatement` con el método `prepareCall()` de la clase `Connection`.


Cuando la sentencia está preparada, podemos ejecutarla con:

- `executeQuery` → Ejecuta sentencias que **esperamos que devuelvan datos** (consultas SELECT). El valor de retorno de esta ejecución es, como ya supondrá, un ResultSet.
- `executeUpdate` → Ejecuta sentencias que **no se espera que devuelvan datos**, pero que se utilizarán para modificar la base de datos conectada (consultas INSERT, DELETE, UPDATE y CREATE TABLE).

## 6.1. Create (Insert)

Vamos a ver un ejemplo sencillo de declaración `INSERT`.

```java
ConnexionDB conDB=new ConnexioDB("BDJuegos");
Connection con=conDB.getConnexio();

String SQL="INSERT INTO Juego VALUES (1, 'Double Dragon', 'Dos hermanos gemelos expertos en artes marciales deben hacerse camino en un escenario urbano donde miembros de bandas rivales quieren dejarlos fuera de combate.', 1);";

Statement st=con.createStatement();

int affectedRows=st.executeUpdate(SQL);

System.out.println(affectedRows+ "row has been inserted");
```

Como puede ver, es muy fácil de entender el código. Creamos una declaración vacía y después ejecutamos el SQL "per se". La ejecución devuelve el número de filas insertadas. Veremos mejores formas de insertar datos, utilizando scripts.

!!! info 
Este código es una versión reducida, puesto que cuando trabajamos con bases de datos pueden aparecer `SQLException`. Supongamos que el proceso de conexión ya se ha realizado.

## 6.2. Read (Select)

La lectura es el proceso más importante que realizaremos, ya que sólo con el proceso de inicio de sesión dentro de una aplicación estamos recuperando información de una base de datos. En todos los casos, debemos escribir la sentencia (SQL), ejecutarla y finalmente procesar los datos devueltos. Dependiendo de cómo preparamos la sentencia, podemos distinguir entre:

1. Sentencias fijas
2. Sentencias variables
3. Sentencias preparadas

Veremos con detalle ambos modos. Utilizaremos para ello el script `instituto`  en el siguiente [enlace](./instituto.sql).

### 6.2.1. Sentencias fijas

Estas sentencias, como su nombre indica, son sentencias fijas o constantes. SQL es fija y no tiene ninguna variable.

```java
package org.dam;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) throws SQLException {

        ConexionDB conDB = new ConexionDB("instituto");
        Connection con = conDB.getConexion();
        String SQL = "Select * from persona";
        // The statement
        Statement st = con.createStatement();
        // The execution
        ResultSet rst = st.executeQuery(SQL);

        // processing
        while (rst.next()) {
            System.out.print(Colores.Bright_Blue + "Person: " + Colores.Reset);
            /*
            System.out.println(
            rst.getString(3)+ ", "+
            rst.getString(2)+ " - "+
            rst.getInt(4));
            */
            System.out.println(
                    rst.getString("apellidos") + ", " +
                            rst.getString("nombre") + " - " +
                            rst.getInt("edad"));
        }

        rst.close();
    }
}
```

En el procesamiento de la información, ResultSet tiene:

- `type getType(int columnIndex)` → método sobrecargado que devuelve el tipo de datos dado, utilizando el índice de columna del ResultSet. Recuerda que la primera columna es 1 en lugar de 0. El tipo puede ser Int, String, Double, etc. si conoces el tipo. Para columnas desconocidas, puedes utilizar `Object` como tipo genérico.
- `type getType(String columnName)` → mismo que el método anterior, pero accediendo a la columna con el nombre que hemos seleccionado en la consulta o el nombre en la tabla.

### 6.2.2. Sentencias variables


Imagina que quieres recuperar nombres que contengan la cadena `Ma` en su interior.

```sql
String SQL="Select * from persona where nombre like '%Ma%'";
```

En ese caso, esta consulta está codificada directamente, y si quieres cambiar la parte del texto, debes modificar tu código. Para evitar la codificación directa, podemos escribir:

```java
ConexionDB conDB = new ConexionDB("instituto");
        Connection con = conDB.getConexion();
        // hardcoded String
        // String SQL="Select * from persona where nombre like '%Ma%'";

        String nombre=Utilidades.leerTextoC("Introduce una parte del nombre: ");
        // The query
        String SQL="Select * from persona where nombre like '%" + nombre + "%'";
        // The statement
        Statement st=con.createStatement();
        // The execution
        ResultSet rst=st.executeQuery(SQL);

        // processing
        while(rst.next()){
            System.out.print(Colores.Bright_Blue+ "Personas con " +nombre+": "+ Colores.Reset);
            System.out.println(
                    rst.getString("apellidos")+ ", "+
                            rst.getString("nombre")+ " "+
                            rst.getInt("edad"));
        }

        rst.close();
    }
```

Como podemos ver, los datos están ahora en variables, pero la construcción de SQL es más compleja. Hay que tener en cuenta que los textos deben estar entre comillas y los números no, lo que facilita cometer errores. Pero puede ser peor, este tipo de código puede incurrir en problemas de inyección SQL, como vemos en el siguiente ejemplo:

```java
        ConexionDB conDB = new ConexionDB("instituto");
        Connection con = conDB.getConexion();
        // hardcoded String
        String id_persona=Utilidades.leerTextoC("Dame el id: ");
        // The query
        String SQL="Select * from persona where id_persona ="+id_persona;
        // The statement
        Statement st=con.createStatement();
        // The execution
        ResultSet rst=st.executeQuery(SQL);

        // processing
        while(rst.next()){
            System.out.print(Colores.Bright_Blue+ "Personas con " +id_persona+": "+ Colores.Reset);
            System.out.println(
                    rst.getString("apellidos")+ ", "+
                            rst.getString("nombre")+ " "+
                            rst.getInt("edad"));
        }

        rst.close();
    }
```

- Si el usuario introduce `4` → Se mostrará las persona con ID igual a 4
- Si el usuario introduce `4 or 1` → Se mostrarán todas las personas

Debe evitarse este tipo de consultas en las declaraciones de validación de usuario, para las que utilizaremos las sentencias preparadas y, obviamente, ser muy cautelosos en la verificación de las entradas.



### 6.2.3. Sentencias preparadas

Para evitar el problema de la inyección SQL, siempre que tengamos parámetros en nuestra consulta, utilizaremos sentencias preparadas. En las sentencias preparadas, donde debemos utilizar un **marcador**, en lugar de componerla con concatenaciones dentro de la cadena, le indicaremos con un interrogante (`?`), un carácter llamado **placeholder**.

A continuación, deberemos asignar valores a estos placeholders, utilizando los métodos `setType(int pos)` donde `Type` es el tipo de datos que asignaremos y `pos` es la posición del placeholder, empezando por `1`. Veremos el ejemplo:


```java

        ConexionDB conDB = new ConexionDB("instituto");
        Connection con = conDB.getConexion();
        // hardcoded String
        String id_persona=Utilidades.leerTextoC("Dame el id: ");
        // The query
        String SQL="Select * from persona where id_persona = ?";

        // The statement
        PreparedStatement pst = con.prepareStatement(SQL);

        pst.setString(1, id_persona);

        // The execution
        ResultSet rst=pst.executeQuery();

        // processing
        while(rst.next()){
            System.out.print(Colores.Bright_Blue+ "Personas con " +id_persona+": "+ Colores.Reset);
            System.out.println(
                    rst.getString("apellidos")+ ", "+
                            rst.getString("nombre")+ " "+
                            rst.getInt("edad"));
        }

        rst.close();
```

!!! tip "Consejo" 

Puedes combinar ResultSet con ResultSetMetaData para obtener los nombres de las columnas y tipos de datos almacenados en la base de datos.


## 6.3. Actualización (Update) y Borrado (Delete)

La actualización y borrado de una fila se consideran como actualizaciones de la base de datos, ya que modifican el estado de la base de datos. De hecho, también consideramos la inserción como una actualización de la base de datos. Ambas tareas se incluyen en el método `executeUpdate()`. Vamos a estudiarlo a través de ejemplos:

### 6.3.1. Ejemplo de borrado

Vamos a borrar filas de una mesa de personas entre las edades dadas:


```java
        ConexionDB conDB = new ConexionDB("instituto");
        Connection con = conDB.getConexion();
        // hardcoded String
        // give the age's bounds
        int minEdad = Utilidades.leerEnteroC("Dame la edad mínima: ");
        int maxEdad = Utilidades.leerEnteroC("Dame la edad máxima: ");
        // The query
        String SQL="Delete from persona where edad between ? and ?";

        // The statement
        PreparedStatement pst = con.prepareStatement(SQL);

        pst.setInt(1, minEdad);
        pst.setInt(2, maxEdad);

        System.out.println(pst);
        // The execution
        int deletedRows = pst.executeUpdate();

        System.out.println(deletedRows + " han sido eliminadas");

        pst.close();
```

!!! warning "Peligro" 

Eliminar datos es una operación muy delicada. Cuida de: 

- No olvides la cláusula `WHERE` cuando eliminas, ya que eliminarás todos los datos de la tabla. 
- Si quieres eliminar toda la tabla, incluyendo la estructura (definición + tabla), debes utilizar `DROP TABLE` en lugar de `DELETE`. 
- Si intentas eliminar una fila que está referenciada por una clave externa, obtendrás la excepción `SQLIntegrityConstraintViolationException` y un mensaje como _No se puede eliminar o actualizar una fila padre: falla una restricción de clave externa_.

### 6.3.2. Ejemplo de Actualización

Vamos a añadir años a las personas con el ID dado:

```java
        ConexionDB conDB = new ConexionDB("instituto");
        Connection con = conDB.getConexion();
        // hardcoded String
        // give the age's bounds
        int difEdad = Utilidades.leerEnteroC("Dame el número de años: ");
        int idMin = Utilidades.leerEnteroC("Dame el id mínimo: ");
        // The query
        String SQL="Update persona set edad=edad+ ? where id_persona> ?";

        // The statement
        PreparedStatement pst = con.prepareStatement(SQL);

        pst.setInt(1, difEdad);
        pst.setInt(2, idMin);

        System.out.println(pst);
        // The execution
        int updatedRows = pst.executeUpdate();

        System.out.println(updatedRows + " han sido actualizadas");

        pst.close();
```

!!! warning 

Recuerda que: 

- La cláusula `UPDATE` no necesita `FROM` para que indiquemos directamente el nombre de la tabla. 
- Aparece la cláusula `SET`, con pares `campo=valor_actualizado`, para asignar el nuevo valor a los campos seleccionados. 
- Si olvidamos la cláusula `FROM`, se actualizarán todas las filas.

## 6.4. Scripts


Un script, que normalmente se ha creado en un archivo externo, es un conjunto de instrucciones SQL ejecutadas en orden de arriba abajo. Podemos tomar como estrategia leer el archivo línea por línea y ejecutarlo una por una, pero JDBC permite ejecutar un conjunto de instrucciones en bloque. Para ello, lo primero que debemos hacer es habilitar múltiples ejecuciones añadiendo un parámetro a la conexión, que es `allowMultiQueries=true`.

A continuación, debemos cargar el archivo y componer una cadena con todo el script. Para normalizarlo y hacerlo totalmente portátil, debemos tener cuidado con los saltos de línea, ya que dependiendo del sistema es una combinación `\n` o `\r\n`. Podemos leer línea por línea y guardarlo en un `StringBuilder`, añadiendo `System.getProperty("line.separator")` o `System.lineSeparator()`como separadores.

Después sólo necesitaremos crear una declaración con esta cadena y ejecutarla con `executeUpdate()`. Lo veremos a continuación:

```java
ConexionDB conDB = new ConexionDB("instituto");

        Connection con = conDB.getConexion();

        File script = new File("EsquemaCine.sql");

        try (BufferedReader bfr = new BufferedReader(new FileReader(script))) {

            StringBuilder sb = new StringBuilder();
            String linea;

            while ((linea = bfr.readLine()) != null) {
                // Elimina los comentarios y espacios en blanco
                linea = linea.trim();
                if (linea.isEmpty() || linea.startsWith("--") || linea.startsWith("#")) {
                    continue; // Omite líneas vacías y comentarios
                }

                sb.append(linea);

                // Si la línea termina en ';', es el final de una sentencia y deberemos ejecutar esta.
                if (linea.endsWith(";")) {
                    String query = sb.toString();
                    try (Statement stm = con.createStatement()) {
                        stm.execute(query);
                    }
                 catch (SQLException e) {
                     System.out.println("Error SQL ejecutando el script: " + e.getMessage());
                 }
                    // Reinicia el StringBuilder para la próxima sentencia
                    sb.setLength(0);

                } else {
                    // Si no, añade un espacio para separar partes de la misma sentencia
                    sb.append(" ");
                }

            }
            System.out.println("Script ejecutado correctamente.");

        } catch (IOException e) {
            System.out.println("Error de I/O al leer el script: " + e.getMessage());
        }

```

!!! tip "Consejo" 

¿Recuerdas las clases `Files` y `Paths`? Reescribe el último ejemplo para obtener un código más limpio.

## 6.5. Transacciones

Si queremos proteger la integridad de los datos, así como evitar situaciones de bloqueo inesperadas en aplicaciones multithread, debemos proteger nuestras operaciones, especialmente aquéllas que modifican los datos mediante el uso de transacciones.

Una transacción define un entorno de ejecución en el que las operaciones de guardado se mantienen almacenadas en la memoria hasta que la transacción se complete. Si en un momento determinado algo falla, el estado se devuelve al punto inicial de la misma (punto inicial) oa algún punto de marca intermedio. Por defecto, abrir una **conexión inicia una transacción**:

- Cada ejecución en la conexión genera una transacción por sí misma.
- Si queremos desactivar esta opción para que la transacción abarque varias ejecuciones, debemos marcarlo mediante `Connection.setAutoCommit(false);`.
- Para aceptar definitivamente la transacción lo haremos mediante `Connection.commit();`
- Para cancelar la transacción `Connection.rollback();`

## 6.6. ResultSets actualizables

Los métodos de trabajo revisados en las secciones anteriores, especialmente cuando se actualizan o borran filas, funcionan directamente en la base de datos. Esto significa que borre o actualice una fila sin cargarla previamente en la memoria. ¿Qué ocurre si desea mostrar los datos al usuario y luego el usuario decide borrar o actualizar la fila? En este caso, es mejor utilizar ResultSets actualizables.

Hemos estudiado ResultSet como una colección de filas y lo utilizamos sólo para la lectura. También podemos utilizarlo para editar y borrar datos. Para ello, debemos abrir el ResultSet de una forma diferente a la que hemos visto hasta ahora. Y, por último, pero no menos importante, dependerá de la base de datos la disponibilidad de crear este tipo de ResultSets.

Para ello, no depende del ResultSet ni de cómo se creó el Statement. Debemos utilizar este constructor:

```java
public abstract Statement createStatement( 
int arg0, // resultSetType 
int arg1, // resultSetConcurrency 
int arg2) // resultSetHoldability 
throws SQLException
```


Como puede ver, hay 3 argumentos para indicar qué tipo de ResultSet damos al final. Estos tres argumentos pueden ser:

- `resultSetType` → éstas son opciones sobre cómo moverse y pasar por las filas del ResultSet: 
- `TYPE_FORWARD_ONLY` → **opción por defecto**. El ResultSet sólo puede ocurrir una vez. 
- `TYPE_SCROLL_INSENSITIVE` → Permite rebobinar y saltar a una posición absoluta o relativa. 
- `TYPE_SCROLL_SENSITIVE` → Al igual que antes, pero permite ver los cambios realizados en la base de datos.
- `ResultSetConcurrency` → éstas son opciones sobre si se puede actualizar el ResultSet o no: 
- `CONCUR_READ_ONLY` → **opción por defecto**. Sólo lectura. Si queremos actualizar algo, sólo podemos utilizar las cláusulas `DELETE` o `UPDATE`. 
- `CONCUR_UPDATABLE` → Las filas de ResultSet se pueden actualizar o borrar.
- `ResultSetHoldability` → estas opciones son sobre el comportamiento al cerrar el ResultSet: 
- `HOLD_CURSORS_OVER_COMMIT` → El ResultSet se mantiene abierto después de confirmar la transacción. 
- `CLOSE_CURSORS_AT_COMMIT` → El ResultSet se cierra después de confirmar la transacción. Mejora el rendimiento.

En el siguiente ejemplo, podemos preguntar a nuestro DBMS si estos tipos de ResultSet están soportados:

```java
ConexionDB conDB = new ConexionDB("instituto");
Connection con = conDB.getConexion();
DatabaseMetaData dbmd = con.getMetaData();

System.out.println("TYPE_FORWARD_ONLY: " + dbmd.supportsResultSetType(ResultSet.TYPE_FORWARD_ONLY));
System.out.println("TYPE_SCROLL_INSENSITIVE: " + dbmd.supportsResultSetType(ResultSet.TYPE_SCROLL_INSENSITIVE));
System.out.println("TYPE_SCROLL_SENSITIVE: " + dbmd.supportsResultSetType(ResultSet.TYPE_SCROLL_SENSITIVE));
System.out.println("CONCUR_READ_ONLY: " + dbmd.supportsResultSetConcurrency(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY));
System.out.println("CONCUR_UPDATABLE: " + dbmd.supportsResultSetConcurrency(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE));
```

### 6.6.1. Movimiento del ResultSet

Como podemos ver, no sólo podemos mover el cursor hacia delante:

- `next`, `previous`, `first` y `last` → como su nombre indica, se mueven hacia delante, hacia atrás, al principio ya la última fila. Devuelve true si el cursor apunta a una fila y false de lo contrario.
- `beforeFirst` y `afterLast` → el cursor apuntará fuera de las filas, antes de la primera o después de la última fila.
- `relative(int n)` → el cursor se mueve _n_ files (hacia adelante o hacia atrás, dependiendo del signo).
- `absolute(int n)` → el cursor apunta a la fila _n_.


### 6.6.2. Eliminación de filas en un ResultSet

Después de colocar el cursor en la fila que se desea eliminar, se puede eliminar del ResultSet (y de la base de datos) con el método `deleteRow()`. Cuando se elimina una fila, el cursor apuntará a la fila anterior a la que se ha eliminado.

### 6.6.3. Actualización de filas en un ResultSet

Después de colocar el cursor en la fila deseada, se debe:

1. Actualizar las columnas deseadas, utilizando el método `updateType(int column, type newValue)`, donde la columna i-ésima (o con su nombre) se asigna el nuevo valor del tipo dado.
2. Una vez que se hayan modificado todas las columnas deseadas, se guardan los cambios con `updateRow()`.

!!! tip "Consejo" 

No podemos actualizar una fila entera, debemos actualizar columna por columna y después actualizar la fila.



### 1.6.4. Inserción de filas en un ResultSet

Si queremos insertar una nueva fila en un ResultSet, debemos:

1. Generar una nueva fila vacía, y esto se logra con el método `moveToInsertRow()`.
2. En esta fila, aplicamos el método `updateType(int column, type newValue)` a todas las columnas a las que queremos asignar un valor, y finalmente
3. Procedemos a insertar la nueva fila con `insertRow()`.


!!! note "Importante" 

- Estas operaciones de actualización, eliminación e inserción sólo pueden realizarse en consultas que provienen de una tabla sin agrupaciones. 
- Para evitar complejidad en nuestros programas, vale la pena evaluar la conveniencia de traducir las actualizaciones del ResultSet a SQL puro y ejecutarlas directamente en las bases de datos mediante nuevas sentencias.

Disponemos de todos los ejemplos en el proyecto `SentFija` en el siguiente [enlace](./SentFija.zip).