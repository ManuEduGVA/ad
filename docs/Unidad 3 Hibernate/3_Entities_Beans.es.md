# 3. Mapeo de Entidades con JPA y Hibernate

Una vez estudiada la configuración inicial, es momento de mapear nuestras entidades y relaciones usando JPA. Partiendo del modelo relacional, usaremos la entidad `Peli`:



```sql
CREATE TABLE `Peli` (
  `idPeli` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(45) NOT NULL,
  `anyo` varchar(45) NOT NULL,
  `director` varchar(45) NOT NULL,
  PRIMARY KEY (`idPeli`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
```



Aquí hay un script [DBCine.sql](./DBCine1.sql) con el que trabajar. 


📁 Estructura del Proyecto
```text
JPAhibernate/
├── src/main/java/
│   ├── model/
│   │   └── Peli.java                 # Entidad principal
│   ├── util/
│   │   └── JpaUtil.java              # Utilidad para JPA
│   └── Main.java                     # Aplicación principal
├── src/main/resources/
│   ├── META-INF/
│   │   └── persistence.xml           # Configuración JPA
│   └── logback.xml                   # Configuración de logs
└── pom.xml                          # Dependencias Maven

```

## 3.1. ⚙️ Configuración de dependencias

### 📦 pom.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.cipfpcheste.dam2</groupId>
    <artifactId>JPAhibernate</artifactId>
    <version>1.0-SNAPSHOT</version>
    <name>JPAhibernate</name>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.target>24</maven.compiler.target>
        <maven.compiler.source>24</maven.compiler.source>
        <junit.version>5.11.0</junit.version>
    </properties>

    <dependencies>
        <!-- Conector MySQL -->
        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <version>9.4.0</version>
        </dependency>
        
        <!-- Hibernate ORM -->
        <dependency>
            <groupId>org.hibernate.orm</groupId>
            <artifactId>hibernate-core</artifactId>
            <version>7.1.2.Final</version>
        </dependency>
        
        <!-- Jakarta Persistence API -->
        <dependency>
            <groupId>jakarta.persistence</groupId>
            <artifactId>jakarta.persistence-api</artifactId>
            <version>3.2.0</version>
        </dependency>
        
        <!-- Logging con Logback -->
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-classic</artifactId>
            <version>1.5.19</version>
            <scope>compile</scope>
        </dependency>
    </dependencies>
</project>

```
### 🔍 Explicación de Dependencias

| Dependencia               | Versión     | Propósito                       |
| :------------------------ | :---------- | :------------------------------ |
| `mysql-connector-j`       | 9.4.0       | Conector oficial para MySQL     |
| `hibernate-core`          | 7.1.2.Final | Implementación ORM de Hibernate |
| `jakarta.persistence-api` | 3.2.0       | API estándar de JPA (Jakarta)   |
| `logback-classic`         | 1.5.19      | Sistema de logging avanzado     |

## 3.2. 🛠️ Archivos de Configuración

### 📄 persistence.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence version="3.2"
             xmlns="https://jakarta.ee/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="https://jakarta.ee/xml/ns/persistence
             https://jakarta.ee/xml/ns/persistence/persistence_3_2.xsd">

    <persistence-unit name="cinePU" transaction-type="RESOURCE_LOCAL">
        <description>Unidad de persistencia para aplicación Cine - Hibernate 7.1.2</description>

        <!-- Proveedor Hibernate 7 -->
        <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>

        <!-- Entidades -->
        <class>model.Peli</class>

        <properties>
            <!-- Conexión a Base de Datos - FORMATO NUEVO -->
            <property name="jakarta.persistence.jdbc.driver"
                      value="com.mysql.cj.jdbc.Driver"/>
            <property name="jakarta.persistence.jdbc.url"
                      value="jdbc:mysql://localhost:3308/Cine1_V1?createDatabaseIfNotExist=true"/>
            <property name="jakarta.persistence.jdbc.user" value="root"/>
            <property name="jakarta.persistence.jdbc.password" value="root"/>

            <!-- Configuración específica de Hibernate 7 -->
            <property name="hibernate.dialect"
                      value="org.hibernate.dialect.MySQLDialect"/>
            <property name="hibernate.hbm2ddl.auto" value="update"/>
            <property name="hibernate.show_sql" value="true"/>
            <property name="hibernate.format_sql" value="true"/>

            <!-- NUEVAS PROPIEDADES HIBERNATE 7 -->
            <property name="hibernate.connection.provider_disables_autocommit" value="true"/>
            <property name="hibernate.session.events.log" value="false"/>

            <!-- Pool de conexiones -->
            <property name="hibernate.connection.pool_size" value="5"/>
        </properties>
    </persistence-unit>
</persistence>
```
### 🔧 Propiedades de Configuración Clave

| Propiedad                        | Valor          | Descripción                         |
| :------------------------------- | :------------- | :---------------------------------- |
| `hibernate.dialect`              | `MySQLDialect` | Dialecto SQL para MySQL             |
| `hibernate.hbm2ddl.auto`         | `update`       | Actualiza esquema automáticamente   |
| `hibernate.show_sql`             | `true`         | Muestra SQL en consola              |
| `hibernate.format_sql`           | `true`         | Formatea SQL para mejor legibilidad |
| `hibernate.connection.pool_size` | `5`            | Tamaño del pool de conexiones       |

### 📊 logback.xml



```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>

    <!-- Logs específicos para Hibernate 7 -->
    <logger name="org.hibernate" level="INFO"/>
    <logger name="org.hibernate.SQL" level="DEBUG"/>
    <logger name="org.hibernate.orm.jdbc.bind" level="TRACE"/>
    <logger name="org.hibernate.stat" level="DEBUG"/>

    <root level="INFO">
        <appender-ref ref="CONSOLE" />
    </root>
</configuration>
```

## 3.3. 🎭 Modelo de Datos

### 🎬 Peli.java



``` java
package model;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "Peli")
public class Peli implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idPeli;

    @Column(name = "titulo", nullable = false, length = 100)
    private String titulo;

    @Column(name = "anyo", nullable = false)
    private int anyo;

    @Column(name = "director", nullable = false, length = 100)
    private String elDirector;

    // Constructores
    public Peli() {}

    public Peli(String titulo, int anyo, String elDirector) {
        this.titulo = titulo;
        this.anyo = anyo;
        this.elDirector = elDirector;
    }

    // Getters y setters
    public Long getIdPeli() {
        return idPeli;
    }

    public void setIdPeli(Long idPeli) {
        this.idPeli = idPeli;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public int getAnyo() {
        return anyo;
    }

    public void setAnyo(int anyo) {
        this.anyo = anyo;
    }

    public String getElDirector() {
        return elDirector;
    }

    public void setElDirector(String elDirector) {
        this.elDirector = elDirector;
    }

    @Override
    public String toString() {
        return "Peli{" +
                "idPeli=" + idPeli +
                ", titulo='" + titulo + '\'' +
                ", anyo=" + anyo +
                ", director='" + elDirector + '\'' +
                '}';
    }
}
}
```

### 📋 Anotaciones JPA Explicadas

| Anotación         | Uso   | Descripción                             |
| :---------------- | :---- | :-------------------------------------- |
| `@Entity`         | Clase | Marca la clase como entidad persistente |
| `@Table`          | Clase | Especifica el nombre de la tabla en BD  |
| `@Id`             | Campo | Indica la clave primaria                |
| `@GeneratedValue` | Campo | Estrategia de generación de IDs         |
| `@Column`         | Campo | Mapea el campo a columna de BD          |



!!! info "Información"
    Más información, [aquí](https://docs.jboss.org/hibernate/orm/7.1/introduction/html_single/Hibernate_Introduction.html)


### 💾 Estrategia de Generación de IDs

```java
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private Long idPeli;
```

La estrategia `IDENTITY` usa la auto-incrementación de MySQL para generar los IDs automáticamente.

## 3.4. 🔧 Utilidades JPA

### 🛠️ JpaUtil.java

```java
package util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.Map;
import java.util.HashMap;

public class JpaUtil {
    private static final String PERSISTENCE_UNIT_NAME = "cinePU";
    private static EntityManagerFactory entityManagerFactory;

    static {
        initialize();
    }

    private static void initialize() {
        try {
            System.out.println("Inicializando Hibernate 7.1.2...");

            // Configuración programática adicional si es necesaria
            Map<String, Object> configOverrides = new HashMap<>();
            configOverrides.put("hibernate.connection.autocommit", "false");

            entityManagerFactory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME, configOverrides);

            System.out.println("EntityManagerFactory creado exitosamente con Hibernate 7");
            System.out.println("Metadata: " + entityManagerFactory.getMetamodel().getEntities().size() + " entidades cargadas");

        } catch (Exception e) {
            System.err.println("Error inicializando Hibernate 7: " + e.getMessage());
            e.printStackTrace();
            throw new ExceptionInInitializerError("Fallo en inicialización de Hibernate 7: " + e.getMessage());
        }
    }

    public static EntityManager getEntityManager() {
        if (entityManagerFactory == null) {
            initialize();
        }
        return entityManagerFactory.createEntityManager();
    }

    public static EntityManagerFactory getEntityManagerFactory() {
        return entityManagerFactory;
    }

    public static void close() {
        if (entityManagerFactory != null && entityManagerFactory.isOpen()) {
            entityManagerFactory.close();
            System.out.println("EntityManagerFactory cerrado");
            entityManagerFactory = null;
        }
    }

    public static boolean isInitialized() {
        return entityManagerFactory != null && entityManagerFactory.isOpen();
    }
}
```

### 🎯 Patrón Singleton para EntityManagerFactory

El `EntityManagerFactory` es un objeto pesado que debe crearse **una sola vez** en toda la aplicación. Por eso usamos:

- **Bloque estático**: Se ejecuta al cargar la clase
- **Singleton**: Una única instancia compartida
- **Lazy initialization**: Se crea solo cuando se necesita

### 🔄 Ciclo de Vida de EntityManager



``` java
// 1. Obtener EntityManager
EntityManager em = JpaUtil.getEntityManager();

try {
    // 2. Iniciar transacción
    EntityTransaction tx = em.getTransaction();
    tx.begin();
    
    // 3. Operaciones JPA
    em.persist(entidad);
    
    // 4. Confirmar transacción
    tx.commit();
    
} finally {
    // 5. CERRAR SIEMPRE el EntityManager
    em.close();
}
```


## 3.5. 🚀 Aplicación Principal

### 📱 Main.java



``` java
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import model.Peli;
import util.JpaUtil;

public class Main {
    public static void main(String[] args) {
        System.out.println("=== HIBERNATE 7.1.2 - JPA PURO ===");

        EntityManager em = null;
        EntityTransaction tx = null;

        try {
            // 1. Obtener EntityManager
            em = JpaUtil.getEntityManager();
            System.out.println(" EntityManager obtenido - Hibernate 7.1.2");

            // 2. Verificar conexión
            boolean connected = em.isOpen();
            System.out.println(" EntityManager abierto: " + connected);

            // 3. Iniciar transacción
            tx = em.getTransaction();
            tx.begin();
            System.out.println("Transacción iniciada");

            // 4. Crear y persistir entidad
            Peli pelicula = new Peli("Avatar: El sentido del agua", 2022, "James Cameron");
            System.out.println(" Creando: " + pelicula);

            em.persist(pelicula);
            em.flush(); // Forzar INSERT inmediato
            System.out.println("Persistido con ID: " + pelicula.getIdPeli());

            // 5. Buscar para verificar
            Peli recuperada = em.find(Peli.class, pelicula.getIdPeli());
            System.out.println(" Recuperado: " + recuperada);

            // 6. Consulta JPQL
            Long count = em.createQuery("SELECT COUNT(p) FROM Peli p", Long.class).getSingleResult();
            System.out.println(" Total de películas en BD: " + count);

            // 7. Confirmar transacción
            tx.commit();
            System.out.println(" Transacción confirmada");

            System.out.println(" HIBERNATE 7.1.2 FUNCIONANDO CORRECTAMENTE!");

        } catch (Exception e) {
            System.err.println(" ERROR: " + e.getMessage());
            if (tx != null && tx.isActive()) {
                tx.rollback();
                System.out.println(" Transacción revertida");
            }
            e.printStackTrace();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
                System.out.println(" EntityManager cerrado");
            }
            JpaUtil.close();
        }
    }
}
```

### 🔍 Operaciones JPA Demostradas

| Operación  | Método          | Descripción                      |
| :--------- | :-------------- | :------------------------------- |
| **Create** | `em.persist()`  | Inserta nueva entidad            |
| **Read**   | `em.find()`     | Busca por ID                     |
| **JPQL**   | `createQuery()` | Consulta con lenguaje JPA        |
| **Flush**  | `em.flush()`    | Sincroniza con BD inmediatamente |

