# 5. MongoDB y Java

Vamos a ver cómo acceder a MongoDB desde nuestros programas Java. Primeramente, como vimos en la unidad 2, estudiaremos cómo acceder directamente y después desde ORM.

## 5.1. Drivers

Como sabemos, para conectar desde nuestras aplicaciones a una base de datos necesitamos un controlador o driver.
MongoDB ofrece **drivers oficiales** para una multitud de plataformas, incluyendo C, C++, C#, NodeJS, Python, y por supuesto, Java, entre otros muchos.

Focalizándonos en Java, MongoDB nos ofrece dos drivers:

- El driver Java para aplicaciones síncronas.
- El driver de Reactive Streams para el procesamiento de Streams asíncronos.

Aunque actualmente existe una tendencia hacia la programación reactiva, trabajaremos con el driver Java síncrono para facilitar la comprensión y centrarnos en el acceso real a los datos.

### 5.1.1. El driver Java

Utilizando el MongoDB Driver para Java podemos conectar tanto a una base de datos local o remota, como a un cluster de MongoDB Atlas. Este driver (MongoDB Java Driver) se puede encontrar en los repositorios Maven, proporcionando un gran número de clases e interfaces para facilitar el trabajo con MongoDB desde Java.

En un proyecto Gradle deberíamos utilizar:

```sh
// Source: https://mvnrepository.com/artifact/org.mongodb/mongodb-driver-sync
implementation("org.mongodb:mongodb-driver-sync:5.6.2")
```

mientras que en un proyecto Maven:

```xml
<!-- Source: https://mvnrepository.com/artifact/org.mongodb/mongodb-driver-sync -->
<dependency>
    <groupId>org.mongodb</groupId>
    <artifactId>mongodb-driver-sync</artifactId>
    <version>5.6.2</version>
    <scope>compile</scope>
</dependency>
```

Además vamos a añadir en el pom.xml el gestor de logs de tal manera que de forma eficiente podamos gestionar los niveles de información. Para ello añadimos las siguientes dependencias:

```xml
        <!-- Source: https://mvnrepository.com/artifact/org.apache.logging.log4j/log4j-core -->
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-core</artifactId>
            <version>2.25.3</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-slf4j2-impl</artifactId>
            <version>2.20.0</version>
        </dependency>
```

Una vez hecho esto, debemos crear dentro del directorio resources el fichero logback.xml y dentro del mismo configurar los niveles de log:

```xml
<configuration>
    <!-- Appender para consola -->
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    <!-- 🔹 MODO VERBOSE: Cambia a DEBUG -->
    <!-- 🔸 MODO NORMAL: Cambia a INFO -->
    <!-- 🔴 MODO SILENCIOSO: Cambia a ERROR -->

    <!-- Nivel específico para MongoDB -->
    <logger name="org.mongodb.driver" level="ERROR"/>

    <!-- Nivel para tu aplicación -->
    <logger name="org.cipfpcheste.dam2" level="INFO"/>

    <!-- Nivel global -->
    <root level="ERROR">
        <appender-ref ref="CONSOLE"/>
    </root>
</configuration>
```

## 5.2. Conexión a una base de datos

Para conectar y comunicarnos con una base de datos necesitamos a un cliente. En el caso del driver de Java para MongoDB, el cliente se implementa a través de la clase MongoClient.

La clase `MongoClient` representa un conjunto de conexiones a un servidor MongoDB. Estas conexiones son seguras para hilos, es decir, varios hilos de ejecución pueden acceder a ellos de forma segura.

La forma de crear instancias de `MongoClient` es a través del método `MongoClients.create()`. Además, por lo general, sólo necesitamos una instancia de esta clase, incluso en aplicaciones multi-hilo. El método `MongoClients.create` toma como argumento una `Connection String`, con el siguiente formato simplificado (los parámetros entre corchetes son opcionales):

```sh
mongodb:// [usuario: contraseña @] host[:port] /?opciones
```

Así, una forma de obtener, por ejemplo, una conexión al servidor local sería:

```java
String uri = "mongodb://localhost:27017";
MongoClient mongoClient = MongoClients.create(uri);
```


La clase MongoClient, entre otros, soporta los siguientes métodos:

- `getDatabase(String name)` → Obtiene una referencia a una base de datos cuyo nombre se pasa como argumento.
- `listDatabaseNames()` → Obtiene una lista de Strings (interfaz `MongoIterable`) con los nombres de las bases de datos del servidor.
- `close()` → Cierra la conexión con el servidor. Siempre debe hacerse cuando ya no se vaya a utilizar.

### 5.2.1. MongoDatabase

El método `getDatabase()` de la clase `MongoClient` devuelve una referencia a un objeto que implementa la interfaz `MongoDatabase`, que representa una conexión a una base de datos. Esta interfaz define los siguientes métodos:

- `getCollection(String name)` → Obtiene una referencia a la colección.
- `listCollectionNames()` → Obtiene una lista de Strings (interfaz `MongoIterable`) con los nombres de las colecciones de la base de datos.
- `listCollections()` → Obtiene una lista de referencias (`MongoCollection`) en las colecciones de la base de datos.
- `createCollection(String name)` → Crea una nueva colección con el nombre especificado en la base de datos.
- `drop()` → Elimina la base de datos.

Aquí encontrarás un ejemplo de conexión y listado de bases de datos y colecciones de un servidor dado:

```java
package org.cipfpcheste.dam2;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) {
        // Conector básico
        conectorBasico();

        // Conector con opciones
        conectorAvanzado();
        // Conector para operaciones CRUD
        operacionesCRUD();
    }

    /**
     * Conector básico a MongoDB
     */
    public static void conectorBasico() {
        System.out.println("=== CONECTOR BÁSICO MONGODB ===");

        // 1. Cadena de conexión simple
        String connectionString = "mongodb://root:toor@localhost:27017/Cine1_V1?authSource=admin";

        try (MongoClient mongoClient = MongoClients.create(connectionString)) {
            System.out.println("Conexión establecida exitosamente");

            // 2. Acceder a una base de datos
            MongoDatabase database = mongoClient.getDatabase("Cine1_V1");
            System.out.println("Base de datos: " + database.getName());

            // 3. Acceder a una colección
            MongoCollection<Document> collection = database.getCollection("Peli");
            System.out.println("Colección: " + collection.getNamespace());
            System.out.println("Documentos en colección: " + collection.countDocuments());

        } catch (Exception e) {
            System.err.println("Error de conexión: " + e.getMessage());
        }

    }

    /**
     * Conector avanzado con opciones
     */
    public static void conectorAvanzado() {
        System.out.println("\n=== CONECTOR AVANZADO MONGODB ===");

        // Cadena de conexión con autenticación
        String connectionString = "mongodb://root:toor@localhost:27017/Cine1_V1?authSource=admin";

        // Con opciones adicionales
        String connectionStringWithOptions =
                "mongodb://localhost:27017" +
                        "/?maxPoolSize=50" +
                        "&w=majority" +
                        "&retryWrites=true" +
                        "&readPreference=primary";

        try (MongoClient mongoClient = MongoClients.create(connectionString)) {

            // Listar bases de datos
            System.out.println("Bases de datos disponibles:");
            mongoClient.listDatabaseNames().forEach(System.out::println);

            // Acceder a la base de datos peliculasdb
            MongoDatabase db = mongoClient.getDatabase("Cine1_V1");

            // Listar colecciones
            System.out.println("\nColecciones en peliculasdb:");
            db.listCollectionNames().forEach(System.out::println);

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    /**
     * Operaciones CRUD básicas
     */
    public static void operacionesCRUD() {
        System.out.println("\n=== OPERACIONES CRUD BÁSICAS ===");

        String connectionString = "mongodb://root:toor@localhost:27017/Cine1_V1?authSource=admin";

        try (MongoClient mongoClient = MongoClients.create(connectionString)) {
            MongoDatabase database = mongoClient.getDatabase("Cine1_V1");
            MongoCollection<Document> peliculas = database.getCollection("Peli");

            // 1. INSERTAR un documento
            Document nuevaPelicula = new Document("titulo", "Inception")
                    .append("anyo", 2010)
                    .append("director", "Christopher Nolan")
                    .append("pais", "Estados Unidos")
                    .append("genero", java.util.Arrays.asList("Ciencia ficción", "Acción", "Thriller"))
                    .append("duracion_minutos", 148)
                    .append("puntuacion_imdb", 8.8);

            peliculas.insertOne(nuevaPelicula);
            System.out.println("Documento insertado: " + nuevaPelicula.getObjectId("_id"));

            // 2. BUSCAR documentos
            System.out.println("\nPelículas de Christopher Nolan:");
            peliculas.find(new Document("director", "Christopher Nolan"))
                    .forEach(doc -> System.out.println("- " + doc.getString("titulo") + " (" + doc.getInteger("anyo") + ")"));

            // 3. ACTUALIZAR un documento
            peliculas.updateOne(
                    new Document("titulo", "Inception"),
                    new Document("$set", new Document("puntuacion_imdb", 8.9))
            );
            System.out.println("\nPuntuación actualizada");

            // 4. ELIMINAR un documento
            peliculas.deleteOne(new Document("titulo", "Inception"));
            System.out.println("Documento eliminado");

            // 5. CONTAR documentos
            long total = peliculas.countDocuments();
            System.out.println("\nTotal de películas: " + total);

            // 6. AGGREGATION básica
            System.out.println("\nPelículas por país:");
            peliculas.aggregate(java.util.Arrays.asList(
                    new Document("$group",
                            new Document("_id", "$pais")
                                    .append("total", new Document("$sum", 1))
                    ),
                    new Document("$sort", new Document("total", -1))
            )).forEach(doc -> System.out.println(
                    doc.getString("_id") + ": " + doc.getInteger("total") + " películas"
            ));

        } catch (Exception e) {
            System.err.println("Error en operaciones CRUD: " + e.getMessage());
        }
    }
}
```
## 5.3. Consultas

El método `getCollection()` de `MongoDatabase()` nos proporciona una colección de `Document` (`MongoCollection<Document>`), sobre la que podremos realizar consultas utilizando el método `find()`. Este método, que ya conocemos del shell de MongoDB, nos permitirá filtrar documentos basándonos en ciertos criterios.

Estos criterios se expresan como filtros (query filters en la documentación), y pueden contener varios operadoresde consulta sobre algunos campos que determinarán qué documentos de la colección se incluyen como resultados.

La clase `Filter` nos proporciona métodos de fábrica para realizar estas consultas, de forma similar a como trabajábamos con el shell de MongoDB. Esta clase nos ofrece:

- Consulta vacía, con `Filters.empty()`.
- Operadores de comparación: Para realizar consultas basadas en valores de la colección: 
- `Filters.eq(key, value)`, `Filters.gt(key, value)`, `Filters.gte(key, value)`, `Filters.lt(key, value)` o `Filters.lte(key, value)`.
- Operadores lógicos: Para realizar operaciones lógicas sobre el resultado de otras consultas: `Filter.and(other_filters)`, `Filter.or(other_filters)`, etc.
- Operadores de array: Permiten realizar consultas basadas en el valor o número de elementos de un vector: `Filters.size(vector, size)`.
- Otros operadores, como `Filter.exists()` o `Filter.regex()`, para comprobar la existencia de una clave o realizar una búsqueda con expresión regular.

Además de los filtros, también podremos incluir operaciones de agregación, a través del método `aggregate()` de una instancia de `MongoCollection`. Puedes consultar la documentación sobre agregaciones en la guía de operaciones de agregación de MongoDB.

Por otra parte, la API del driver de MongoDB también nos permite realizar proyecciones de campos utilizando la clase `Projections`, que ofrece los métodos `Projections.fields()`, `Projections.include()` o `Projections.excludeID()`.

Ejemplo de búsqueda de películas de un año dado, sólo 10 resultados:


```java
public static void getPelisAnyo(MongoClient cliente, int anyo) {

// get collection from database
        MongoDatabase db=cliente.getDatabase("Cine1_V1");

// get documents from that colection
        MongoCollection<Document> colPelis = db.getCollection("Peli");

// And now, we apply a filtr and limit
        FindIterable<Document> docsPelis = colPelis
                .find(Filters.eq("anyo", anyo))
                .limit(10);

// we show it
        for (Document doc : docsPelis) {
            System.out.println(doc.toString());
        }
    }
```

!!! nota "Recuerda" 
    La clase `Document` tiene varios métodos para trabajar como documentos JSON en la unidad 1. Podemos obtener cada campo dada una _clave_, obteniendo su _valor_.

Otro ejemplo con filtros y proyecciones:

```java
public static void getPelisEntre(MongoClient cliente, int anyo1, int anyo2) {

// check anyo values
        if (anyo1>anyo2){
            int tmp=anyo1;
            anyo1=anyo2;
            anyo2=tmp;
        }

// get document collection
        MongoDatabase db=cliente.getDatabase("Cine1_V1");
        MongoCollection<Document> colPelis = db.getCollection("Peli");

// Creamos el filtro
        Bson filter= Filters.and(
                Filters.gte("anyo", anyo1),
                Filters.lte("anyo", anyo2)
        );

// Create projecction
        Bson projection= Projections
                .fields(Projections.include("titulo", "anyo"),
                        Projections.excludeId());

// Run the filters
        FindIterable<Document> DocsPelis = colPelis
                .find(filter)
                .projection(projection);

// Show the films
        for (Document doc : DocsPelis) {
            System.out.println(doc.toString());
        }
    }
```

y el programa final sería:

```java
package org.cipfpcheste.dam2;

import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Projections;
import org.bson.Document;
import org.bson.conversions.Bson;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) {
        // Conector básico
        conectorBasico();

        // Conector con opciones
        conectorAvanzado();
        // Conector para operaciones CRUD
        operacionesCRUD();
    }

    /**
     * Conector básico a MongoDB
     */
    public static void conectorBasico() {
        System.out.println("=== CONECTOR BÁSICO MONGODB ===");

        // 1. Cadena de conexión simple
        String connectionString = "mongodb://root:toor@localhost:27017/Cine1_V1?authSource=admin";

        try (MongoClient mongoClient = MongoClients.create(connectionString)) {
            System.out.println("Conexión establecida exitosamente");

            // 2. Acceder a una base de datos
            MongoDatabase database = mongoClient.getDatabase("Cine1_V1");
            System.out.println("Base de datos: " + database.getName());

            // 3. Acceder a una colección
            MongoCollection<Document> collection = database.getCollection("Peli");
            System.out.println("Colección: " + collection.getNamespace());
            System.out.println("Documentos en colección: " + collection.countDocuments());

        } catch (Exception e) {
            System.err.println("Error de conexión: " + e.getMessage());
        }

    }

    /**
     * Conector avanzado con opciones
     */
    public static void conectorAvanzado() {
        System.out.println("\n=== CONECTOR AVANZADO MONGODB ===");

        // Cadena de conexión con autenticación
        String connectionString = "mongodb://root:toor@localhost:27017/Cine1_V1?authSource=admin";

        // Con opciones adicionales
        String connectionStringWithOptions =
                "mongodb://localhost:27017" +
                        "/?maxPoolSize=50" +
                        "&w=majority" +
                        "&retryWrites=true" +
                        "&readPreference=primary";

        try (MongoClient mongoClient = MongoClients.create(connectionString)) {

            // Listar bases de datos
            System.out.println("Bases de datos disponibles:");
            mongoClient.listDatabaseNames().forEach(System.out::println);

            // Acceder a la base de datos peliculasdb
            MongoDatabase db = mongoClient.getDatabase("Cine1_V1");

            // Listar colecciones
            System.out.println("\nColecciones en Cine1_V1:");
            db.listCollectionNames().forEach(System.out::println);

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    /**
     * Operaciones CRUD básicas
     */
    public static void operacionesCRUD() {
        System.out.println("\n=== OPERACIONES CRUD BÁSICAS ===");

        String connectionString = "mongodb://root:toor@localhost:27017/Cine1_V1?authSource=admin";

        try (MongoClient mongoClient = MongoClients.create(connectionString)) {
            MongoDatabase database = mongoClient.getDatabase("Cine1_V1");
            MongoCollection<Document> peliculas = database.getCollection("Peli");

            // 1. INSERTAR un documento
            Document nuevaPelicula = new Document("titulo", "Inception")
                    .append("anyo", 2010)
                    .append("director", "Christopher Nolan")
                    .append("pais", "Estados Unidos")
                    .append("genero", java.util.Arrays.asList("Ciencia ficción", "Acción", "Thriller"))
                    .append("duracion_minutos", 148)
                    .append("puntuacion_imdb", 8.8);

            peliculas.insertOne(nuevaPelicula);
            System.out.println("Documento insertado: " + nuevaPelicula.getObjectId("_id"));

            // 2. BUSCAR documentos
            System.out.println("\nPelículas de Christopher Nolan:");
            peliculas.find(new Document("director", "Christopher Nolan"))
                    .forEach(doc -> System.out.println("- " + doc.getString("titulo") + " (" + doc.getInteger("anyo") + ")"));

            // 3. ACTUALIZAR un documento
            peliculas.updateOne(
                    new Document("titulo", "Inception"),
                    new Document("$set", new Document("puntuacion_imdb", 8.9))
            );
            System.out.println("\nPuntuación actualizada");

            // 4. ELIMINAR un documento
            peliculas.deleteOne(new Document("titulo", "Inception"));
            System.out.println("Documento eliminado");

            // 5. CONTAR documentos
            long total = peliculas.countDocuments();
            System.out.println("\nTotal de películas: " + total);

            // 6. AGGREGATION básica
            System.out.println("\nPelículas por país:");
            peliculas.aggregate(java.util.Arrays.asList(
                    new Document("$group",
                            new Document("_id", "$pais")
                                    .append("total", new Document("$sum", 1))
                    ),
                    new Document("$sort", new Document("total", -1))
            )).forEach(doc -> System.out.println(
                    doc.getString("_id") + ": " + doc.getInteger("total") + " películas"
            ));

            System.out.println("*".repeat(250));
            System.out.println("Filtros avanzados");
            System.out.println("*".repeat(250));
            getPelisEntre(mongoClient,2000,2025);
            System.out.println("*".repeat(250));
            System.out.println("Numero de peliculas para el año indicado");
            System.out.println("*".repeat(250));
            getPelisAnyo(mongoClient,2023);
            System.out.println("*".repeat(250));



        } catch (Exception e) {
            System.err.println("Error en operaciones CRUD: " + e.getMessage());
        }
    }

    /**
     * Conector con manejo de excepciones
     */
    public static MongoClient createConnectionWithRetry() {
        String connectionString = "mongodb://localhost:27017";
        int maxRetries = 3;
        int retryDelay = 2000; // 2 segundos

        for (int i = 0; i < maxRetries; i++) {
            try {
                System.out.println("Intentando conexión " + (i + 1) + "/" + maxRetries);
                MongoClient client = MongoClients.create(connectionString);

                // Verificar conexión
                client.listDatabaseNames().first();
                System.out.println("Conexión exitosa");
                return client;

            } catch (Exception e) {
                System.err.println("Intento " + (i + 1) + " fallido: " + e.getMessage());

                if (i < maxRetries - 1) {
                    try {
                        Thread.sleep(retryDelay);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                    }
                }
            }
        }
        throw new RuntimeException("No se pudo conectar después de " + maxRetries + " intentos");
    }

    public static void getPelisEntre(MongoClient cliente, int anyo1, int anyo2) {

// check anyo values
        if (anyo1>anyo2){
            int tmp=anyo1;
            anyo1=anyo2;
            anyo2=tmp;
        }

// get document collection
        MongoDatabase db=cliente.getDatabase("Cine1_V1");
        MongoCollection<Document> colPelis = db.getCollection("Peli");

// Creamos el filtro
        Bson filter= Filters.and(
                Filters.gte("anyo", anyo1),
                Filters.lte("anyo", anyo2)
        );

// Create projecction
        Bson projection= Projections
                .fields(Projections.include("titulo", "anyo"),
                        Projections.excludeId());

// Run the filters
        FindIterable<Document> DocsPelis = colPelis
                .find(filter)
                .projection(projection);

// Show the films
        for (Document doc : DocsPelis) {
            System.out.println(doc.toString());
        }
    }

    public static void getPelisAnyo(MongoClient cliente, int anyo) {

// get collection from database
        MongoDatabase db=cliente.getDatabase("Cine1_V1");

// get documents from that colection
        MongoCollection<Document> colPelis = db.getCollection("Peli");

// And now, we apply a filtr and limit
        FindIterable<Document> docsPelis = colPelis
                .find(Filters.eq("anyo", anyo))
                .limit(10);

// we show it
        for (Document doc : docsPelis) {
            System.out.println(doc.toString());
        }
    }
}

```

