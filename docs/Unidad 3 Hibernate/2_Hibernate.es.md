# 2. Hibernate

<figure markdown="span">
  ![Image title](./img/Hibernate.png){ width="700" }
  <figcaption>Hibernate</figcaption>
</figure>

[Hibernate](https://hibernate.org) es un framework ORM para Java, que facilita la correspondencia de atributos entre una base de datos relacional y el modelo de objetos de nuestra aplicación mediante archivos XML o anotaciones en los beans de entidad. Es un software libre distribuido bajo la licencia GPL 2.0, por lo que puede utilizarse en aplicaciones comerciales.

Hibernate es la implementación más popular de la especificación JPA (Java Persistence API), un estándar de Java para la persistencia de objetos. JPA proporciona una API uniforme mientras que Hibernate ofrece la implementación robusta que maneja la correspondencia ORM.

La función principal de Hibernate con JPA será ofrecer al programador las herramientas para detallar su modelo de datos mediante anotaciones estándar, de modo que sea el propio ORM el que interactúe con la base de datos, mientras que el desarrollador se dedica a manipular objetos.

<figure markdown="span">
  ![Image title](./img/Hibernate-arquitecture.png){ width="700" }
  <figcaption>Hibernate Arquitecture</figcaption>
</figure>

JPA introduce el EntityManager como interfaz principal para las operaciones de persistencia, reemplazando en muchos casos el uso directo de Session de Hibernate. Los objetos creados son rastreados en el contexto de persistencia, y las operaciones se sincronizan con la base de datos al confirmar las transacciones.

## 2.1 Configuración

Hibernate, como implementación de JPA, no necesita una instalación específica, puesto que está integrado en nuestro proyecto como librerías. Utilizaremos Maven como gestor de paquetes para automatizar las dependencias.

Utilizaremos **Maven** como gestor de paquetes.

## 2.2 Dependencias.

En nuestros proyectos se utilizarán dos herramientas básicas: Hibernate y un controlador para conectarse a la base de datos seleccionada. Obviamente, es necesario añadir las dependencias al gestor de paquetes. En Maven, las dependencias se incluyen en el archivo `Pom.xml`, en la carpeta raíz de nuestro proyecto. Dentro de la etiqueta `<dependencias>` hay que añadir:

=== "Maven"

    ```xml
    <!-- Hibernate como implementación JPA -->
    <dependency>
        <groupId>org.hibernate.orm</groupId>
        <artifactId>hibernate-core</artifactId>
        <version>7.1.2.Final</version>
    </dependency>

    <!-- MySQL Connector -->
    <dependency>
        <groupId>com.mysql</groupId>
        <artifactId>mysql-connector-j</artifactId>
        <version>8.0.33</version>
    </dependency>

    <!-- API JPA (Jakarta Persistence) -->
    <dependency>
        <groupId>jakarta.persistence</groupId>
        <artifactId>jakarta.persistence-api</artifactId>
        <version>3.1.0</version>
    </dependency>
    ```
=== "Gradle"

    ```bash
    // Hibernate como implementación JPA
    implementation("org.hibernate.orm:hibernate-core:7.1.2.Final")

    // MySQL Connector
    implementation("com.mysql:mysql-connector-j:8.0.33")

    // API JPA (Jakarta Persistence)
    implementation("jakarta.persistence:jakarta.persistence-api:3.1.0")
    ```

!!! note "Recuerda..." 
Recuerda que puedes encontrar los paquetes en <https://mvnrepository.com/repos/central>


## 2.3. Estructura del proyecto

Una vez que hemos añadido las dependencias, debemos crear una estructura de proyecto para organizar nuestras clases, con el objetivo de separar la lógica del programa. A continuación, mostraremos una breve descripción, profundizando en cada punto más adelante.

### 2.3.1. Entidades JPA

Las entidades JPA son la evolución de los Beans tradicionales:

Como extensión de los POJOs, aparecen los **Beans**, sin restricciones en los atributos, constructores y herencia. Tienen algunas restricciones:

- Sus atributos deben ser `private` (encapsulación).
- Deben implementar la interfaz `Serializable`.
- Deben tener getters y setters públicos.
- Deben tener un constructor genérico (sin argumentos).

!!! note "Recuerda" 

La serialización en tiempo de ejecución asocia a cada clase serializable un número de versión, llamado `serialVersionUID`, que se utiliza durante la deserialización para verificar que el emisor y el receptor de un objeto serializado han cargado clases para ese objeto que son compatibles en relación a la serialización. 

Si el receptor ha cargado una clase para el objeto que tiene un `serialVersionUID` distinto al de la clase del emisor correspondiente, entonces la deserialización dará lugar a una `InvalidClassException`. Una clase serializable puede declarar su propio `serialVersionUID` explícitament mediante la declaración de un campo llamado `serialVersionUID` que debe ser estático, final y de tipo long: 

```java 
static final long serialVersionUID = 137L; 
```

Así, los Beans son componentes de acceso a datos y representan a entidades en nuestra aplicación. Es una buena idea crear nuestros Beans en la misma carpeta, normalmente llamada `Modelo`.

Nosotros vamos a trabajar con JPA que es lo que la industria hace uso actualmente.

```java

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "Peli")
public class Peli implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idPeli;
    
    @Column(name = "titulo", nullable = false)
    private String titulo;
    
    @Column(name = "anyo")
    private int anyo;
    
    @Column(name = "director")
    private String elDirector;

    // Constructor por defecto (OBLIGATORIO en JPA)
    public Peli() {}

    // Constructor con parámetros
    public Peli(String titulo, int anyo, String elDirector) {
        this.titulo = titulo;
        this.anyo = anyo;
        this.elDirector = elDirector;
    }

    // Getters y setters
    public Long getIdPeli() { return idPeli; }
    public void setIdPeli(Long idPeli) { this.idPeli = idPeli; }
    // ... resto de getters y setters
}

```


### 2.3.2. Archivos de mapeo

**¡IMPORTANTE!** Con JPA, los archivos `*.hbm.xml` **NO SON NECESARIOS**. Todo el mapeo se define mediante anotaciones en las clases entidad.


## 2.4. Configuración del proyecto

Vamos a examinar más detenidamente el archivo de configuración de Hibernate. En el archivo de configuración de Hibernate podemos establecer las opciones de forma desordenada, pero se recomienda agrupar los bloques de opciones para aclarar y mantener el código, así como indicar mediante comentarios qué estamos haciendo en cada momento. Lo veremos con un ejemplo completo, que detallaremos paso a paso en las siguientes secciones.

### 2.4.1. Hibernate.cfg.xml

=== "XML"

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-configuration PUBLIC
"-//Hibernate/Hibernate Configuration DTD 3.0//EN"
"http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">

<hibernate-configuration>
    <session-factory>
        <!-- Configuración de conexión -->
        <property name="hibernate.connection.driver_class">com.mysql.cj.jdbc.Driver</property>
        <property name="hibernate.connection.url">jdbc:mysql://localhost:3308/DBName</property>
        <property name="hibernate.connection.username">root</property>
        <property name="hibernate.connection.password">root</property>

        <!-- Pool de conexiones -->
        <property name="hibernate.connection.pool_size">5</property>

        <!-- Dialecto -->
        <property name="hibernate.dialect">org.hibernate.dialect.MySQLDialect</property>

        <!-- Contexto de sesión -->
        <property name="hibernate.current_session_context_class">thread</property>

        <!-- Mostrar SQL (solo desarrollo) -->
        <property name="hibernate.show_sql">true</property>
        <property name="hibernate.format_sql">true</property>

        <!-- Estrategia DDL -->
        <property name="hibernate.hbm2ddl.auto">update</property>

        <!-- Mapeo de clases entidad JPA -->
        <mapping class="paquete.entidad.Peli" />
    </session-factory>
</hibernate-configuration>
```

### 2.4.2 Alternativa: persistence.xml

=== "XML"

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <persistence version="3.0" xmlns="https://jakarta.ee/xml/ns/persistence"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="https://jakarta.ee/xml/ns/persistence 
                                    https://jakarta.ee/xml/ns/persistence/persistence_3_0.xsd">
        <persistence-unit name="miUnidadPersistencia" transaction-type="RESOURCE_LOCAL">
            <description>Unidad de persistencia para MySQL</description>
            
            <!-- Proveedor JPA -->
            <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
            
            <!-- Propiedades -->
            <properties>
                <property name="jakarta.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver"/>
                <property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3308/DBName"/>
                <property name="jakarta.persistence.jdbc.user" value="root"/>
                <property name="jakarta.persistence.jdbc.password" value="root"/>
                
                <property name="hibernate.dialect" value="org.hibernate.dialect.MySQLDialect"/>
                <property name="hibernate.show_sql" value="true"/>
                <property name="hibernate.format_sql" value="true"/>
                <property name="hibernate.hbm2ddl.auto" value="update"/>
            </properties>
        </persistence-unit>
    </persistence>
    ```
### 2.4.3 Opciones hbm2ddl.auto

| Opción        | Descripción                                                  |
| :------------ | :----------------------------------------------------------- |
| `create`      | Crea siempre la BD cuando se carga la session factory. Se pierden los datos. |
| `update`      | Los datos se mantienen, pero la estructura se actualiza. Útil en producción. |
| `create-drop` | Como create pero elimina la base de datos al final.          |
| `validate`    | Comprueba el mapeo entre la base de datos y los beans.       |
| `none`        | No realiza acciones DDL.                                     |

### 2.4.4 Carga de scripts

Para insertar datos de prueba, crea un archivo `import.sql` en `src/main/resources`. Se ejecutará automáticamente después de la creación de tablas.

Para múltiples scripts:

=== "XML"

    ```xml
    <property name="hibernate.hbm2ddl.import_files"> 
    /import1.sql, /import2.sql
    </property>
    ```


## 2.5 Configuración de sesiones

### 2.5.1 HibernateUtil con JPA

=== "Java"

    ```java
    import org.hibernate.SessionFactory;
    import org.hibernate.boot.Metadata;
    import org.hibernate.boot.MetadataSources;
    import org.hibernate.boot.registry.StandardServiceRegistry;
    import org.hibernate.boot.registry.StandardServiceRegistryBuilder;

    public class HibernateUtil { 

        private static final SessionFactory sessionFactory; 

        static { 
            try { 
                StandardServiceRegistry registry = new StandardServiceRegistryBuilder()
                        .configure("hibernate.cfg.xml")
                        .build();
                        
                MetadataSources sources = new MetadataSources(registry);
                sources.addAnnotatedClass(Peli.class);
                
                Metadata metadata = sources.getMetadataBuilder().build();
                sessionFactory = metadata.getSessionFactoryBuilder().build();
                
            } catch (Throwable ex) { 
                System.err.println("Error en la inicialización. " + ex); 
                throw new ExceptionInInitializerError(ex); 
            } 
        } 

        public static SessionFactory getSessionFactory() { 
            return sessionFactory; 
        }
        
        public static void shutdown() {
            if (sessionFactory != null) {
                sessionFactory.close();
            }
        }
    }
    ```

### 2.5.2 JPAUtil (Alternativa estándar)

=== "Java"

    ```java
    import jakarta.persistence.EntityManager;
    import jakarta.persistence.EntityManagerFactory;
    import jakarta.persistence.Persistence;

    public class JPAUtil {
        private static final EntityManagerFactory emf = 
            Persistence.createEntityManagerFactory("miUnidadPersistencia");

        public static EntityManager getEntityManager() {
            return emf.createEntityManager();
        }
        
        public static void close() {
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
        }
    }
    ```



## 2.6 Operaciones básicas

### 2.6.1 Persistir entidades

=== "Con Session"


    ```java
    Session session = HibernateUtil.getSessionFactory().openSession();
    Transaction tx = session.beginTransaction();

    Peli nuevaPeli = new Peli("Inception", 2010, "Christopher Nolan");
    session.persist(nuevaPeli);

    tx.commit();
    session.close();
    ```




=== "Con EntityManager"

    ```java
    EntityManager em = JPAUtil.getEntityManager();
    EntityTransaction tx = em.getTransaction();
    tx.begin();

    em.persist(nuevaPeli);

    tx.commit();
    em.close();
    ```




### 2.6.2 Buscar por ID

=== "Con Session"

    ```java
    Peli peli = session.find(Peli.class, 1L);
    ```




=== "Con EntityManager"

    ```java
    Peli peli = em.find(Peli.class, 1L);
    ```




### 2.6.3 Actualizar entidades

=== "Java"

    ```java
    Peli peli = em.find(Peli.class, 1L);
    peli.setTitulo("Nuevo título");
    // La actualización es automática al hacer commit
    ```



### 2.6.4 Eliminar entidades


=== "Java"

    ```java
    Peli peli = em.find(Peli.class, 1L);
    em.remove(peli);
    ```



## 2.7 Consultas con JPQL

### 2.7.1 Consulta básica


=== "Java"
    ```java
    TypedQuery<Peli> query = em.createQuery(
        "SELECT p FROM Peli p WHERE p.anyo > :anio", Peli.class);
    query.setParameter("anio", 2000);
    List<Peli> pelis = query.getResultList();
    ```



### 2.7.2 Consulta con múltiples resultados

=== "Java"

    ```java
    TypedQuery<Object[]> query = em.createQuery(
        "SELECT p.titulo, p.director FROM Peli p", Object[].class);
    ```



### 2.7.3 Consultas nativas SQL

=== "Java"

    ```java
    Query query = em.createNativeQuery("SELECT * FROM Peli WHERE anyo > ?", Peli.class);
    query.setParameter(1, 2000);
    List<Peli> pelis = query.getResultList();
    ```



## 2.8 Ejemplo completo

=== "Java"

    ```java
    public class Main {
        public static void main(String[] args) {
            EntityManager em = JPAUtil.getEntityManager();
            EntityTransaction tx = null;
            
            try {
                tx = em.getTransaction();
                tx.begin();
                
                // Crear y guardar nueva entidad
                Peli peli = new Peli("The Matrix", 1999, "Lana Wachowski");
                em.persist(peli);
                
                // Buscar entidad
                Peli encontrada = em.find(Peli.class, peli.getIdPeli());
                System.out.println("Encontrada: " + encontrada);
                
                // Consulta JPQL
                TypedQuery<Peli> query = em.createQuery(
                    "SELECT p FROM Peli p WHERE p.anyo >= :anio", Peli.class);
                query.setParameter("anio", 2000);
                List<Peli> pelisRecientes = query.getResultList();
                
                tx.commit();
                
            } catch (Exception e) {
                if (tx != null && tx.isActive()) {
                    tx.rollback();
                }
                e.printStackTrace();
            } finally {
                em.close();
                JPAUtil.close();
            }
        }
    }
    ```



## 2.9 Ventajas de JPA

| Ventaja           | Descripción                                          |
| :---------------- | :--------------------------------------------------- |
| **Portabilidad**  | Puedes cambiar entre diferentes implementaciones JPA |
| **Estándar**      | Las anotaciones JPA son reconocidas universalmente   |
| **Integración**   | Mejor compatibilidad con Spring y otros frameworks   |
| **Mantenimiento** | Código más limpio y fácil de mantener                |
| **Futuro**        | JPA es el estándar actual de la industria            |

!!! success "Mejores prácticas"

    \- Siempre usa anotaciones JPA en lugar de archivos XML

    \- Maneja las transacciones correctamente

    \- Usa `@Entity` y `@Table` para el mapeo de entidades

    \- Define `@Id` y estrategia de generación apropiada

    \- Cierra recursos en bloques finally o usa try-with-resources


!!! note "Atención"
    Esta implementación mantiene la compatibilidad con el patrón Singleton para SessionFactory/EntityManagerFactory, asegurando una única instancia en la aplicación.