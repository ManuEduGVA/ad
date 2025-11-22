## 1. Base de datos Orientadas a Objetos. ObjectDB

En esta sección, como SGBD, se ha escogido **ObjectDB**, puesto que es muy versátil, gratuito e incluso permite incrustarlo dentro de nuestros proyectos Java, lo que permite una gran simplicidad para el desarrollo de pequeñas aplicaciones, gracias a la eliminación de un servidor.

## 2. Instalación

[**ObjectDB**](https://www.objectdb.com/download) no requiere instalación como tal, ya que todo su código está integrado en una API para acceder a la base de datos empaquetada en un archivo **jar**. Desde el sitio web oficial podemos descargar el Kit de Desarrollo de ObjectDB. En el momento de escribir esta documentación, la versión es la 2.9.4. Este kit contiene, entre otros:

- Dependencias para proyectos Java
- Utilidades para visualizar y consultar la base de datos
- Servidor para aplicaciones distribuidas
- Documentación

Una vez descomprimido, sólo necesitaremos la máquina virtual Java instalada en nuestro sistema para ejecutar todos los elementos. Para utilizar ObjectDB en nuestro proyecto debemos añadir el archivo `objectdb.jar` a las dependencias de nuestro proyecto o hacerlo utilizando el gestor de dependencias _maven_ o _gradle_.

Nosotros vamos a optar por generar un proyecto de jakarta y añadiremos las dependencias de hibernate y persistencia.

Una vez arrancado el proyecto, en el pom.xml añadiremos la dependencia correspondiente a objectdb:

```XML
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.cipfpcheste.dam2</groupId>
    <artifactId>BBDDOO</artifactId>
    <version>1.0-SNAPSHOT</version>
    <name>BBDDOO</name>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.target>24</maven.compiler.target>
        <maven.compiler.source>24</maven.compiler.source>
        <junit.version>5.11.0</junit.version>
    </properties>
    <repositories>
        <repository>
            <id>objectdb</id>
            <name>ObjectDB Repository</name>
            <url>https://m2.objectdb.com</url>
        </repository>
    </repositories>
    <dependencies>
        <dependency>
            <groupId>jakarta.persistence</groupId>
            <artifactId>jakarta.persistence-api</artifactId>
            <version>3.2.0-M2</version>
        </dependency>
        <dependency>
            <groupId>com.objectdb</groupId>
            <artifactId>objectdb-jk</artifactId>
            <version>2.9.4</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/org.projectlombok/lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.42</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
        </plugins>
    </build>
</project>

```

Puesto que vamos a incluir el paquete de objectDB, debemos configurar el fichero persistence.xml:

```XML
<?xml version="1.0" encoding="UTF-8"?>
<persistence xmlns="http://xmlns.jcp.org/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/persistence
                                 http://xmlns.jcp.org/xml/ns/persistence/persistence_2_1.xsd"
             version="2.1">

    <persistence-unit name="objectdb-unit" transaction-type="RESOURCE_LOCAL">
        <provider>com.objectdb.jpa.Provider</provider>
        
        <class>Product</class>

        <properties>

            <property name="jakarta.persistence.jdbc.url"
                      value="/home/manu/temp/BBDDOO/bd/testdb.odb"/>

            <property name="jakarta.persistence.jdbc.user" value="admin"/>
            <property name="jakarta.persistence.jdbc.password" value="admin"/>

            <property name="jakarta.persistence.schema-generation.database.action"
                      value="create"/>

            <property name="eclipselink.logging.level" value="FINE"/>
        </properties>
    </persistence-unit>
</persistence>

```

???+ warning
    - Indicamos dónde almacenar la base de datos: **property name="jakarta.persistence.jdbc.url" value="/home/manu/temp/BBDDOO/bd/testdb.odb"**
    - Establecemos el usuario: **property name="jakarta.persistence.jdbc.user" value="admin"**
    - Establecemos la contraseña: **property name="jakarta.persistence.jdbc.password" value="admin"**
    - Política de creación de la BD: **property name="jakarta.persistence.schema-generation.database.action" value="create"**

En este momento podemos conectarnos a la base de datos, la centralización de la conexión a la base de datos se realiza a través de una instancia de un objeto `EntityManagerFactory`, del que podemos obtener varias instancias de un `EntityManager`.

Desde el `EntityManager` podremos llevar a cabo las operaciones típicas de CRUD, teniendo en cuenta que siempre que haya modificaciones en él. Debemos llevar a cabo la operación dentro de una transacción para evitar situaciones inconsistentes en ella. Aquí vemos una posible clase con el establecimiento de la conexión y la obtención de un `EntityManager`. Ten en cuenta que las importaciones son de `jakarta.persistence`.


## 3. Persistencia de clases

Para persistir un objeto, necesitaremos (similar a **Hibernate**):

- Anotar tu clase y marcarla como `@Entity`
- Definir un campo como `@Id` y opcionalmente auto-incrementar con `@GeneratedValue`.
- El resto de los atributos de la entidad, por defecto, se persisten automáticamente sin ningún tipo de anotación. En caso de no querer persistir, podemos indicarlo con `@Transient`. Aprovechamos Lombok para que nos genere todo getters, setters, toString, etc. Fíjate que creo un constructor sin el parámetro del id porque interesa de cara a que sea ObjectDB quien genere esa clave:


```java
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "productos")
public class Producto {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name = "nombre", nullable = false, length = 100)
    private String nombre;

    @Column(name = "precio", nullable = false)
    private double precio;

    @Column(name = "descripcion", length = 500)
    private String descripcion;

    public Producto(String nombre, double precio, String descripcion) {
        this.nombre = nombre;
        this.precio = precio;
        this.descripcion = descripcion;
    }
}
```

Para almacenar un Producto, bastará con crear un Producto y persistirlo en la base de datos, como se ve a continuación:


```java
        EntityManagerFactory emf = null;
        EntityManager em = null;
        try {

            emf = Persistence.createEntityManagerFactory("objectdb-unit");
            em = emf.createEntityManager();

            // Crear productos
            Producto portatil = new Producto("Asus TUF", 1299.99, "Portatil para gamers");
            Producto raton = new Producto("Ratón Inalámbrico", 49.99, "Ratón de baja calidad");
            Producto teclado = new Producto("Teclado Mecánico", 89.99, "Teclado mecánico RGB");

            // Persistir (CREATE)
            EntityTransaction transaction = em.getTransaction();
            transaction.begin();

            em.persist(portatil);
            em.persist(raton);
            em.persist(teclado);

            transaction.commit();
            System.out.println("Productos persistidos: " + portatil.getId() + ", " + raton.getId() + ", " + teclado.getId());
```

**Clases incrustadas o Componentes**

En Java, en ocasiones hay clases que no tienen existencia propia, a menos que existan dentro de otra clase como podría ser Fabricante. No tiene sentido crear un objeto Fabricante ad-hoc, en cambio, sí tiene sentido crearlo para que una Fabricante exista, por ejemplo, dentro de un Producto.

Para estos casos (débiles) que existen incrustados dentro de otras clases, debemos declararlos como incrustables utilizando la anotación `@Embeddable` y marcarlos como incrustados (`@Embedded`) dentro de la clase en la que existen.

```java
@Embeddable
public class Fabricante{ 
...
}

@Entity
public clases Producto{ 
... 
@Embedded 
private Producto producto;
}

// En el main
Producto  pro= new Producto("Lenovo Carbon", 1400, "Portatil pofesional");
Frabricante fa = new Fabricante("Lenovo Spain SL","Calle Puerto De Somport 9",28050,"Madrid");
pro.setFabricante(fa);
em.persist(pro);
```

Una entidad `Producto` se guardará en la base de datos, pero el `Fabricante` no existe como objeto por sí mismo.

Para los puntos de las relaciones, vamos a utilizar como ejemplos las clases Alumno, Profesor, Clase, etc.

## 4. Relaciones

### 4.1. Relación uno a uno

La relaciónmás sencilla es uno a uno, en la que un objeto contiene otro objeto. La marcaremos como ya hicimos en Hibernate con el modificador `@OneToOne` indicando que el guardado es en cascada (`cascade=CascadeType.PERSIST`).

A partir de ahora, cuando guardes una instancia de un objeto, tu propia instancia del objeto relacionado se guardará y enlazará. El objeto enlazado tendrá existencia por sí mismo (si está marcado como `@Entity`). Un ejemplo básico en el que una clase tiene un único `Tutor`:

Basado en un ejemplo en el que una `Clase` (de un instituto) tiene un `Tutor` asociado, el ejemplo será el siguiente:

```java
@Entity
public class Profesor{ 
...
}

@Entity
public class Clase{ 
... 
@OneToOne(cascade=CascadeType.PERSIST) 
private Profesor tutor;
}


Profesor p=new Profesor("Pepe");
Clase c= new Clase("2DAM");
c.setTutor(p);
um.persist(c); // Cuando guardamos clase, tutor es almacenado.
```

!!! importante "Atención" 
    - Recuerda que, al igual que en Hibernate, esta relación es unidireccional, pero puede hacerse bidireccional.


### 4.2. Relación Una a muchos

Ahora nos referiremos a una relación clásica en la que un Profesor es el tutor de varios Alumno. Estas relaciones pueden ser unidireccionales o bidireccionales. En este ejemplo lo veremos de forma _bidireccional_, de tal modo que dado un alumno podemos saber quién es su tutor y dado un profesor podemos obtener a los alumnos que tutoriza.


```java
@Entity
public class Alumno{ 
... 
@ManyToOne(cascade=CascadeType.PERSIST) 
private Profesor tutor;

}

@Entity
public class Profesor{ 
... 
@OneToMany(cascade=CascadeType.PERSIST, 
fetch=FetchType.EAGER) 
private List<Alumno> losEstudiantes;
}
```


!!! importante "Atención" 
    - Recuerda que, al igual que en Hibernate, la carga de las colecciones se puede realizar de inmediato, con un modo `EAGER` o cuando sea necesario en modo `LAZY`.


### 4.3. Muchos a muchos

En las relaciones de muchos a muchos, podemos abordarlas de distintas formas. Damos el ejemplo de la enseñanza entre Profesor y Alumno. Si simplemente queremos indicar quién enseña a quien, sería suficiente almacenar una colección de profesores en cada alumno (los profesores que enseñan a ese alumno), y simétricamente, en cada profesor una colección de alumnos (los alumnos a quienes enseñan). En este caso, sería _bidireccional_, ya que desde una clase podemos navegar a otra, quedando así:


```java
@Entity
public class Alumno{ 
... 
@ManyToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY) 
private Set<Profesor> profesores=new Hash Set<>();
}

@Entity
public class Profesor{ 
... 
@ManyToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY) 
private Set<Alumno> estudiantes=new Hash Set<>();;
}
```

!!! importante "Atención" 
    Si necesitamos guardar cualquier información dentro de esta relación, como la nota recibida, el estudiante, o los incidentes publicados, etc., entonces debemos crear una nueva clase, que incorporará los atributos de la relación, y establecer relaciones uno a muchos desde cada entidad (Estudiante/Profesor) hasta la nueva entidad (Enseñanza). Esta suposición es la famosa _Las relaciones N-M generan una tabla con los atributos que poseen_ del modelo relacional.


## 5. Consultas

Revisaremos cómo cargar los datos que hemos guardado previamente en la base de datos. Supongamos que tenemos una clase Estudiante, mapada con una entidad y con un identificador (_idStudent_). La manera más sencilla de cargar a un Estudiante, conociendo su id, es el método `find(class,id)`, como hicimos en Hibernate:

```java
Estudiante a=em.find(Estudiante.class,2);
```

El resto de las cargas deben llevarse a cabo mediante consultas, en un lenguaje **JPQL** (_Java Persistence Query Language_), nuevamente similar al HQL de Hibernate.

Hay dos clases: `Query` y `TypedQuery` (la segunda hereda de la primera), que se utilizan normalmente en el primer caso cuando no conocemos el resultado de la consulta, y en el segundo cuando conocemos el resultado.

La primera es polimórfica, por lo que enlazará dinámicamente los resultados, y la segunda verifica el resultado con la clase actual. La documentación oficial recomienda el uso de la segunda, `TypedQuery` para consultas y `Query` para actualizaciones y eliminaciones.

```java
// creation of Query (q) or TypedQuery (tq)

// único resultado

//returno a generic object, and we must cast it.
Object q.getSingleResult();

// returna un objeto específico
T tq.getSingleResult();

// un conjunto de resultados

//retorna un List de objetos genéricos que deberemos castear.
List q.getResultList();

// etorna un List de objetos concretos
List<T> tq.getResultList();

// para actualizar o eliminar
q.executeUpdate();
```

De forma similar a Hibernate, podemos consultar la base de datos de la siguiente manera:

```java
TypedQuery<Alumno> tq=em.createQuery("Select from Alumno en where a.ampa=true", Alumno.class);
List<Alumno> alumnosAmpa=tq.getResultList();
```

o con parámetros:

```java
TypedQuery<Alumno> tq=em.createQuery("Select a from Alumno a where a.ampa= :ampa", Alumno.class);
tq.setParameter("ampa", true);
List<Alumno> alumnosAmpa=tq.getResultList();
```

### 5.1. Borrados y Actualizaciones

Por último, revisaremos las últimas operaciones CRUD que nos quedan. Las actualizaciones son totalmente transparentes para el usuario, ya que cualquier modificación que se realice dentro del contexto de una transacción se guardará automáticamente cuando se cierre con un `commit()`. Alternativamente, se pueden realizar _consultas de actualización_.

Para las eliminaciones, si el objeto se ha recuperado de la base de datos, y por tanto está en la transacción actual, se puede eliminar con `em.remove(object)`. Se eliminará de la base de datos cuando se realice el commit.

## 6. Ejemplo con Producto

No voy a extenderme puesto que casi todos los conceptos son de Hibernate, JPA y JPQL.

### 6.1. pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.cipfpcheste.dam2</groupId>
    <artifactId>BBDDOO</artifactId>
    <version>1.0-SNAPSHOT</version>
    <name>BBDDOO</name>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.target>24</maven.compiler.target>
        <maven.compiler.source>24</maven.compiler.source>
        <junit.version>5.11.0</junit.version>
    </properties>
    <repositories>
        <repository>
            <id>objectdb</id>
            <name>ObjectDB Repository</name>
            <url>https://m2.objectdb.com</url>
        </repository>
    </repositories>
    <dependencies>
        <dependency>
            <groupId>jakarta.persistence</groupId>
            <artifactId>jakarta.persistence-api</artifactId>
            <version>3.2.0-M2</version>
        </dependency>
        <dependency>
            <groupId>com.objectdb</groupId>
            <artifactId>objectdb-jk</artifactId>
            <version>2.9.4</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/org.projectlombok/lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.42</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
        </plugins>
    </build>
</project>

```

### 6.2. persistence.xml

```xml

<?xml version="1.0" encoding="UTF-8"?>
<persistence xmlns="http://xmlns.jcp.org/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/persistence
                                 http://xmlns.jcp.org/xml/ns/persistence/persistence_2_1.xsd"
             version="2.1">

    <persistence-unit name="objectdb-unit" transaction-type="RESOURCE_LOCAL">
        <provider>com.objectdb.jpa.Provider</provider>
        
        <class>Producto</class>

        <properties>

            <property name="jakarta.persistence.jdbc.url"
                      value="/home/manu/temp/BBDDOO/bd/testdb.odb"/>

            <property name="jakarta.persistence.jdbc.user" value="admin"/>
            <property name="jakarta.persistence.jdbc.password" value="admin"/>

            <property name="jakarta.persistence.schema-generation.database.action"
                      value="create"/>

            <property name="eclipselink.logging.level" value="FINE"/>
        </properties>
    </persistence-unit>
</persistence>

```

### 6.3. Clase Producto

```java

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "productos")
public class Producto {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name = "nombre", nullable = false, length = 100)
    private String nombre;

    @Column(name = "precio", nullable = false)
    private double precio;

    @Column(name = "descripcion", length = 500)
    private String descripcion;

    public Producto(String nombre, double precio, String descripcion) {
        this.nombre = nombre;
        this.precio = precio;
        this.descripcion = descripcion;
    }
}

```

### 6.4. Main

```java
import jakarta.persistence.*;
import java.util.List;

public class Main {

    public static void main(String[] args) {
        System.out.println("Ejemplo de BBDDOO con ObjectDB");
        EntityManagerFactory emf = null;
        EntityManager em = null;
        try {

            emf = Persistence.createEntityManagerFactory("objectdb-unit");
            em = emf.createEntityManager();

            // Crear productos
            Producto portatil = new Producto("Asus TUF", 1299.99, "Portatil para gamers");
            Producto raton = new Producto("Ratón Inalámbrico", 49.99, "Ratón de baja calidad");
            Producto teclado = new Producto("Teclado Mecánico", 89.99, "Teclado mecánico RGB");

            // Persistir (CREATE)
            EntityTransaction transaction = em.getTransaction();
            transaction.begin();

            em.persist(portatil);
            em.persist(raton);
            em.persist(teclado);

            transaction.commit();
            System.out.println("Productos persistidos: " + portatil.getId() + ", " + raton.getId() + ", " + teclado.getId());

            // Lectura del portátil
             Producto busquedaProducto = em.find(Producto.class, portatil.getId());
            System.out.println("Productos: " + busquedaProducto);

            // Actualizar
            transaction.begin();
            busquedaProducto.setPrecio(1199.99);
            em.merge(busquedaProducto);
            transaction.commit();
            System.out.println("Producto actualizado: " + busquedaProducto);

            // Verificar actualización
            Producto productoActualizado = em.find(Producto.class, portatil.getId());
            System.out.println("Precio actualizado verificado: " + productoActualizado.getPrecio());

            // Realización de consultas con JPQL

            System.out.println("*".repeat(100));
            System.out.println("\n                            --- Prueba de consultas JPQL ---");
            System.out.println("*".repeat(100));

            // Consulta todos los productos
            TypedQuery<Producto> todoslosProductosQuery =
                    em.createQuery("SELECT p FROM Producto p ORDER BY p.precio DESC", Producto.class);
            List<Producto> todoslosProductos = todoslosProductosQuery.getResultList();

            System.out.println("Todos los productos (" + todoslosProductos.size() + "):");
            for (Producto producto : todoslosProductos) {
                System.out.println("   - " + producto);
            }

            // Consulta con filtro
            TypedQuery<Producto> productosCarosQuery =
                    em.createQuery("SELECT p FROM Producto p WHERE p.precio > 100", Producto.class);
            List<Producto> productosCaros = productosCarosQuery.getResultList();

            System.out.println("Productos caros (>100€): " + productosCaros.size());

            // Consulta con parámetros
            TypedQuery<Producto> QueryParametros =
                    em.createQuery("SELECT p FROM Producto p WHERE p.nombre LIKE :nombre", Producto.class);
            QueryParametros.setParameter("nombre", "%Ratón%");
            List<Producto> ProductoRaton = QueryParametros.getResultList();

            System.out.println("Productos con 'Ratón' en el nombre: " + ProductoRaton.size());

            System.out.println("*".repeat(100));

        } catch (Exception e) {
            System.err.println("Error de ejecución:");
            e.printStackTrace();
        } finally {
            // 5. Cerrar recursos
            if (em != null && em.isOpen()) {
                em.close();
                System.out.println("EntityManager cerrado");
            }
            if (emf != null && emf.isOpen()) {
                emf.close();
                System.out.println("EntityManagerFactory cerrado");
            }
        }
    }

}
```

Proyecto ejemplo de [Producto](./BBDDOO.zip)
