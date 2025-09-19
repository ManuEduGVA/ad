# 5. Metadata de la base de datos

Antes de recuperar datos, estudiaremos cómo obtener información sobre la base de datos a la que estamos conectados. Los metadatos de una base de datos describen su estructura: las tablas que componen la base de datos, los campos que forman estas tablas, los tipos de estos campos, etc. Aunque normalmente conocemos esta estructura previamente, es posible que necesitemos información en alguna ocasión, por eso tenemos las interfaces `DatabaseMetaData` y `ResultSetMetaData`.

La interfaz `DatabaseMetaData` nos proporciona información sobre las tablas y vistas de la base de datos, así como su estructura. A continuación tenemos algunos de los métodos más relevantes de esta interfaz.

- `String getDatabaseProductName()` →  Obtiene el nombre de SGBD.
- `String getDriverName()` →  Obtiene el nombre del controlador JDBC que se está utilizando.
- `String getURL()` →  Obtiene la URL de la conexión.
- `String getUserName()` →  Obtiene el nombre del usuario conectado a la base de datos.
- `ResultSet getTables(String catalog, String schema, String patternTableName, String[] type)` →  Obtiene información de las tablas disponibles en el catálogo indicado.
- `ResultSet getColumns(String catalog, String schema, String patternNameTable, String patternColumnName)` →  Obtiene información de los campos de la tabla especificada en el catálogo y esquema indicados.
- `ResultSet getPrimaryKeys(String catalog, String schema, String patternNameTable)` →  Obtiene la lista de campos que forman la clave primaria.
- `ResultSet getImportedKeys(String catalog, String schema, String patternNameTable)` →  Obtiene una lista con las claves externas definidas en la tabla.
- `ResultSet getExportedKeys(String catalog, String schema, String patternNameTable)` →  Obtiene una lista con las claves externas que apuntan a esta tabla.


!!! info "Información" 

En este punto, cabe señalar que los términos **catálogo** y **esquema** tienden a confundirse. Según los estándares, un catálogo contiene varios esquemas, con información detallada del sistema, desde la forma de almacenamiento interno hasta los esquemas conceptuales. En un catálogo, parece que existe un esquema llamado **INFORMATION_SCHEMA**, con las vistas y dominios del esquema de información del sistema. 

En cualquier caso, la mayoría de los SGBD coinciden el catálogo con el nombre de la base de datos. Además, en esta consulta especificamos el nombre de la base de datos como catálogo, mientras que si abrimos MySQLWorkbench, la base de datos se representa como un **esquema**. Puede encontrar más información al respecto en estos enlaces: 

- <https://stackoverflow.com/questions/7022755/whats-the-difference-between-a-catalog-and-a-schema-in-a-relational-database> 
- <https://www.quora.com/What-is-the-difference-between-system-catalog-and-database-schemain-a-Database>


## 5.1. Ejercicio resuelto

Vamos a crear un programa Java que muestre información interna de una base de datos `BDJocs`, mediante `DataBaseMetaData`. Veremos el programa paso a paso.

!!! info 
Puede ver toda la información del método y cómo los datos se almacenan en cada ResultSet del método en este [enlace](https://docs.oracle.com/javase/7/docs/api/java/sql/DatabaseMetaData.html).

### 5.1.1. Crear la connection


Recuerda cómo conectarte a un SGBD de forma sencilla:

```java
// load JDBC driver
2 Class.forName("com.mysql.cj.jdbc.Driver");
3 // Conecto a DBMS and DB BDJosc, with user and pass
4 Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3308/BDJocs", "root", "root");
```

Muy sencillo, carga el controlador y conéctate a la base de datos de la forma que hemos estudiado.

### 5.1.2. Recupera los metadatos del SGBD y muéstralos en un formato amigable

Utilizaremos la clase [Color](./Colores.java) para mostrar los datos en formato de texto en la consola.

```java
// get the metadata
DatabaseMetaData dbmd = con.getMetaData();

System.out.println(Colores.Blue+"\nDBMS information--------"+Colores.Reset);
System.out.println(Colores.Bright_White+"SGBD:\t"+Colores.Reset + dbmd.getDatabaseProductName());
System.out.println(Colores.Bright_White+"SGBD:\t"+Colores.Reset + dbmd.getDriverName());
System.out.println(Colores.Bright_White+"SGBD:\t"+Colores.Reset + dbmd.getURL());
System.out.println(Colores.Bright_White+"SGBD:\t"+Colores.Reset + dbmd.getUserName());
```

Como puede ver, obtenemos el nombre del SGBD, el controlador, el URL y el usuario que estamos utilizando. Obviamente, es lo mismo que pusimos al crear el objeto `Connection`, pero es un buen ejemplo para mostrar información.


### 5.1.3. Recuperar tablas en un esquema/base de datos

Utilizando el método `getTables()` podemos recuperar las tablas y más información. Supongamos que `BDJocs` existe en nuestro SGBD:

```java
System.out.println(Colores.Bright_White+String.format("%-15s %-15s %-15s","Database","Table","Type"));
System.out.println("-------------------------------------------------------"+Colores.Reset);
ResultSet rsmd = dbmd.getTables("BDJocs", null, null, null);
while (rsmd.next()) { 
System.out.println(String.format("%-15s %-15s %-15s",rsmd.getString(1),rsmd.getString(3),rsmd.getString(4)));
}
```


Comentarios:

Repasa `String.format()` para establecer una longitud específica de cada columna.

Según la documentación de javadoc, obtenemos que el ResultSet devuelto por `getTables` tiene las siguientes columnas: 

1. **TABLE_CAT** String → catálogo de la tabla (puede ser nulo) 
2. **TABLE_SCHEM** String → esquema de la tabla (puede ser nulo) 
3. **TABLE_NAME** String → nombre de la tabla 
4. **TABLE_TYPE** String → tipos de tabla. Los tipos típicos son "TABLE", "VIEW", "SYSTEM TABLE", "GLOBAL TEMPORARY", "LOCAL TEMPORARY", "ALIAS", "SYNONYM". 
5. **REMARKS** String → comentario explicativo sobre la mesa 
6. **TYPE_CAT** String → catálogo de los tipos (puede ser nulo) 
7. **TYPE_SCHEM** String → esquema de los tipos (puede ser nulo) 
8. **TYPE_NAME** String → nombre del tipo (puede ser nulo) 
9. **SELF_REFERENCING_COL_NAME** String → nombre de la columna "identificador" designada de una tabla indicada (puede ser nulo) 
10. **REF_GENERATION** String → especifica cómo se crean los valores en SELF_REFERENCING_COL_NAME Los valores pueden ser "SYSTEM", "USER", "DERIVED" (puede ser nulo).

Obtenemos las columnas 1, 3 y 4.



### 5.1.4. Obtener las columnas de la tabla

Es el momento de obtener las columnas de una tabla, utilizando el método `getColumns()`:

```java
String table=...; // we set the name of an existing table
ResultSet columnas = dbmd.getColumns("BDJocs",null , tabla, null);
System.out.println(Colores.Bright_White+String.format("%-25s %-15 s%-15s","Atributo/Claves","Tipos","¿Puede ser nulo?"+Colores.reset));

while (columnas.next()){ 
String columnName=columnes.getString(4); 
String tipo=columnes.getString(6); 
String nullable=columnes.getString(18); 

System.out.println(String.format("%-25s %-15s %15s",columnName,tipo,nullable));
}
```


Comentarios:

- `getColumns()` devuelve un ResultSet con 24 columnas, con mucha información de la tabla. Sólo obtenemos las columnas 4, 6 y 18 con el nombre, el tipo y si puede ser nulo.
- Del mismo modo, para obtener información sobre las claves, podemos utilizar: 
- `getPrimaryKeys()` devuelve un ResultSet con las claves primarias de las tablas. 
- `getExportedKeys()` devuelve un ResultSet con las columnas que apuntan a la clave primaria de la tabla actual. Esto significa todos los campos de otras tablas que apuntan a la clave primaria de la tabla actual. 
- `getImportedKeys()` devuelve un ResultSet con las columnas que son claves primarias importadas en la tabla actual. Esto significa las columnas que son claves externas (y apuntan a una clave primaria de otras tablas).

> Tiene todo el ejemplo en la carpeta `DatabaseMeta` de la aplicación de ejemplo y en el siguiente [enlace](./DatabaseMetadataAppApp.java).