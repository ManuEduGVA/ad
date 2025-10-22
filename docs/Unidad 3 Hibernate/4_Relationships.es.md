
# 4. Mapeando Relaciones

Como mencionamos en la introducción, analizaremos cómo mapear los diferentes tipos de relaciones. Antes de empezar a discutir la cardinalidad de las relaciones, debemos considerar el significado de estas relaciones, y revisaremos el concepto de direccionalidad de las relaciones.

- **Unidireccional** → Diremos que una relación es unidireccional cuando accedamos al objeto relacionado (componente) desde otro objeto (propietario). Por ejemplo, si montamos un _motor_ en un _coche_, lo lógico es que el propietario sea el _coche_, y desde éste obtendremos el _motor_. En este caso, dentro del objeto _Coche_ aparecerá un objeto _Motor_, y _Motor_ no tendrá una existencia propia.
- **Bidireccional** → Son relaciones en las que los elementos relacionados suelen tener el mismo peso o entidad. Por ejemplo, un _Grupo_ de un instituto y un _Tutor_. Desde un grupo tiene sentido conocer al tutor, y también podemos desde un profesor (el tutor) acceder al grupo que tutoriza. En este caso, dentro del objeto _Grupo_ tenemos una referencia al objeto _Tutor_ y viceversa.

!!! warning "Aviso" 
    En este tipo de referencias, como puede deducirse, existe una recursión intrínseca. Por tanto, cuando gestionamos este tipo de relaciones bidireccionales, tenga mucho cuidado de no causar bucles, ya que incluso algo tan sencillo como imprimir puede hacer que nuestro programa se bloquee y aparezca la conocida `StackOverflowException`.

A partir de ahora podríamos estudiar todas las representaciones con JPA.


## 4.1. Relaciones Uno a Uno

Para la explicación de los ejemplos, veremos el diseño y la implementación en la base de datos de cada caso y cómo se ve en Hibernate. Para este ejemplo representaremos una relación 1:1 entre Grupo y Profesor, donde puede verse que un Grupo tiene un Tutor, y un Tutor sólo puede tutorizar un Grupo.

<figure markdown="span">
  ![Image title](./img/1_1.png){ width="700" }
  <figcaption>one to one<figcaption>
</figure>

En primer lugar, la clase que es apuntada por la clave foránea. Muy fácil porque no necesitamos hacer nada.


```java
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@Entity
@Table(name="Profesor")
public class Profesor implements Serializable {

    static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int idProfesor;

    @Column
    private String nombre;

    public Profesor(String nombre) {
        this.nombre = nombre;
    }
}
```

Y ahora, la clase que contiene la clave ajena. Aquí debemos marcar que un `Grupo` necesita un `Profesor` como tutor. Veámoslo:

```java
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@Entity
@Table(name = "Grupo")
public class Grupo implements Serializable {

    static final long serialVersionUID = 137L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long idGrupo;

    @Column
    private String nivel;

    @Column
    private String curso;

    @Column
    private int anyo;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(
            name="id_tutor",
            referencedColumnName = "idProfesor",
            unique=true,
            foreignKey = @ForeignKey(name = "FK_GRP_TEACH"))
    private Profesor tutor;

    public Grupo(String nivel, String curso, int anyo) {
        this.nivel = nivel;
        this.curso = curso;
        this.anyo = anyo;
    }

}
```
Tenga en cuenta que la clase `Grupo` contiene un campo llamado `tutor` de la clase `Profesor`, y:

- `@OneToOne(cascade = CascadeType.ALL)` marcamos esta relación como 1:1. Además, especificamos el atributo cascada, que es el más importante. El cascading es la forma de decir que cuando realizamos alguna acción sobre la entidad objetivo (`Grupo`), la misma acción se aplicará a la entidad asociada (`Profesor`). Revisamos las opciones más relevantes: 
- `CascadeType.ALL` propaga todas las operaciones. La misma operación que realizamos en el objetivo se realizará en el asociado. 
- `CascadeType.PERSIST` propaga sólo la operación de persistencia en la base de datos (guardar). 
- `CascadeType.SAVE_UPDATE` es de Hibernate, no de JPA, y propaga el método `saveOrUpdate()`. Es muy similar a persisto. 
- `CascadeType.REMOVE` o `CascadeType.DELETE` propaga la eliminación de entidades. Tenga mucho cuidado con esta opción para evitar perder datos.
- En el `@JoinColumn` establecemos: 
- el nombre de la columna en nuestra base de datos 
- el nombre de la columna referenciada en la entidad objetivo `Profesor` 
- `unique=true` para asegurar que la relación es 1:1 (un profesor no puede estar relacionado con ningún otro grupo) 
- [opcional] para establecer el nombre de la restricción de clave foránea, en caso de que desee cambiarlo o eliminarlo en operaciones futuras.

Más información en la siguiente web[baeldung](https://www.baeldung.com/jpa-cascade-types)

### 4.1.1. Uno a Uno bidireccional

Si queremos almacenar en Profesor los grupos que está tutorizando, necesitamos añadir una referencia al Grupo. Como hemos hecho la clave foránea en Grupo, será muy fácil:

```java
@OneToOne(mappedBy= "tutor")
private Grupo elGrupo;
```

Con `mappedBy="tutor"` estamos diciendo que en la clase `Grupo` existe un campo llamado `tutor` con toda la información sobre la relación. Tenga en cuenta que no se añadirán campos aadicionales a `Profesor`, porque la información sobre la relación se encuentra en la tabla `Grupo`.

## 4.2. Uno a Muchos

Para esta explicación empezaremos con el siguiente modelo, en el que un **Libro** tiene un **Autor** que lo ha escrito, y un Autor puede haber escrito varios Libros. En el esquema relacional, la relación es desde `idAutor` en Libros, que es clave foránea en la tabla Autor (ID).

<figure markdown="span">
  ![Image title](./img/libro_autor.png){ width="700" }
  <figcaption>one to many<figcaption>
</figure>
Primero, podemos decidir quién es el propietario de la relación. Realmente no importa, pero en varios diseños es muy claro, por ejemplo entre `Estudiante` y `Email`, donde obviamente el propietario es `Estudiante`. Normalmente debería ser la clase con cardinalidad **muchos** el propietario. Veamos el ejemplo.

```java
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor

@Entity
@Table(name="libro")
public class Libro implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idlibro;

    @Column
    private String titulo;

    @Column
    private String tipo;

    @ManyToOne(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "idautor",
            foreignKey = @ForeignKey(name = "FK_LIB_AUT"))
    private Autor elAutor;

    public Libro(String titulo, String tipo, Autor elAutor) {
        this.titulo = titulo;
        this.tipo = tipo;
        this.elAutor = elAutor;
    }
}
```
En este ejemplo, un `Libro` tiene un autor (único). Lo implementamos almacenando una referencia a un objeto Autor, llamado `elAutor` dentro de nuestro Libro. Debemos escribir la información de la relación en este campo:

- Debemos marcar este campo como `@ManyToOne`, porque Libro está al lado de los muchos de la relación (recuerde que un Autor puede escribir varios Libros)
- La clave foránea será anotada con la etiqueta `@JoinColumn`, con varios atributos: 
- Puesto que `elAutor` es el punto inicial de la clave foránea, que apunta a la tabla `Autor`, necesitamos decir el nombre de la clave primaria en esta clase. Este atributo es opcional pero es una buena opción para mejorar nuestro código. 
- Opcionalmente, podemos llamar la restricción de la clave foránea, con un nombre bien estructurado, con el atributo `foreignKey`

```java
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.util.Set;
@Data
@NoArgsConstructor
@Entity
@Table(name="autor")
public class Autor implements Serializable{

    @Serial
    private static final long serialVersionUID = 137L;

    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long idautor;

    @Column
    private String nombre;

    @Column
    private String nacionalidad;

    @OneToMany(mappedBy="elAutor",
            cascade=CascadeType.PERSIST,
            fetch = FetchType.LAZY)
    private Set<Libro> losLibros;

    public Autor(String nombre, String nacionalidad, Set<Libro> losLibros) {
        this.nombre = nombre;
        this.nacionalidad = nacionalidad;
        this.losLibros = losLibros;
    }
}
```

La clase `Autor` está en el lado _un_, y esto significa que puede escribir _muchos_ `Libros`. Por esta razón, almacenamos todos los libros que ha escrito en un 'Set' de libros. Las anotaciones serán:

- Puesto que un Autor puede escribir muchos libros, marcamos el Set de libros como `@OneToMany`. Como hemos escrito la especificación de la relación en Libro, podríamos decir que la relación está mapeada en el campo `elAutor` dentro de la clase `Libro`, con `mappedBy="elAutor"` fácilmente.

!!! nota "Decisión" 
    En lugar de almacenar libros en un Set, se pueden almacenar en una Lista. La principal diferencia es responder a esta pregunta: _¿es importante el orden?_. Si respondes _sí_, debes utilizar una Lista. Si la respuesta es _no_, debes utilizar un Set.

!!! importante "Espacio" 

    La relación `1:N` que hemos explicado es bidireccional. Esto significa que desde un Autor podemos obtener todos los Libros que ha escrito, y desde un Libro podemos obtener el Autor. 

<figure markdown="span">
  ![Image title](./img/1_M_JPA.png){ width="700" }
  <figcaption>one to many bidirectional<figcaption>
</figure>

Puede encontrar varias páginas y libros que explican las relaciones unidireccionales `1:N`. Esto significa que con este tipo de implementación sólo podemos viajar en una dirección. En este caso, debemos almacenar sólo dentro de un Libro quien es el autor, porque el Libro es el propietario. Debemos eliminar el conjunto de libros en el autor para obtener una relación unidireccional.

### 4.2.1. Tipo de Carga **Fetch**

Este atributo suele aparecer cuando tenemos una relación `1:N` o `N:M` en una clase que tiene una colección de clases relacionadas (también puede especificarse con un `1:1` pero es menos común). Cuando Hibernate carga un objeto, cargará sus atributos generales (nombre, nacionalidad, etc...), pero ¿qué ocurre con los Libros que ha escrito, los carga o no?

- `DateType.EAGER` → Literalmente traducido como **ansioso**. No podemos esperar, y cuando se carga al Autor, Hibernate resolverá la relación y cargará todos los libros con todos los datos internos de cada libro. Tenemos todos los datos en el momento.
- `DateType.LAZY` → Literalmente como **perezoso** (vago), pero más representativo como _carga perezosa_. Si cargamos al Autor, Hibernate sólo carga los atributos propios del Autor, sin cargar sus Libros. Cuando intentamos acceder a sus libros desde nuestro programa, Hibernate se _activa_ y los carga. Es decir, en modo LAZY, los datos se cargan **cuando se necesitan**.

**¿Qué haremos?**

¿Qué es mejor o peor? La respuesta no es sencilla, ya queAmbos tienen ventajas y desventajas:

- En `EAGER` solo se realiza un acceso, mientras que en `LAZY` se realizan dos o más.

- En `EAGER` se cargan todos los datos, incluso los innecesarios; en `LAZY` solo se carga lo necesario.

El programador debe evaluar y equilibrar la cantidad de información requerida en un momento dado y el coste de acceso a la base de datos.

## 4.3. Muchos a Muchos

En esta sección, finalizaremos con el último tipo de relación que podemos encontrar en el modelo E/R: las relaciones muchos a muchos. Pueden aparecer otras relaciones con cardinalidades más altas, como las relaciones ternarias, pero, como se estudió en el primer año, todas ellas pueden modelarse con transformaciones binarias.

Dentro de las relaciones binarias, podemos encontrar dos posibilidades:

- Relaciones que simplemente indican la relación (por ejemplo, que un personaje puede o no portar cierto tipo de arma en un juego de rol) o

- Relaciones que, además de indicarla, añaden nuevos atributos. Por ejemplo, un actor participa en una película interpretando un tipo de papel: principal, secundario, etc.

En el modelo relacional, ambos casos se modelan como una nueva tabla (con o sin el atributo). Si nos encontramos en el segundo caso, se debe modelar una nueva tabla con los atributos que posee mediante una clase, por lo que la relación «N:M» entre dos tablas se convertirá en «dos relaciones uno a muchos 1:N y N:1» (actor-actuación y actuación-película). Nos centraremos en el primer caso, ya que estamos listos para resolver el segundo.

!!! Nota "Mejora"
    En la segunda parte, este tutorial explica cómo crear [N_M con atributos](https://thorben-janssen.com/hibernate-tip-many-to-many-association-with-additional-attributes/). Se recomienda implementar un ejemplo.

Modelemos el caso típico de un profesor que imparte varios módulos, que pueden ser impartidos por varios profesores. El esquema es el siguiente:

<figure markdown="span">
  ![Image title](./img/N_M.png){ width="700" }
  <figcaption>one to many bidirectional<figcaption>
</figure>

### 4.3.1 Muchos a Muchos con 4 clases

Como podemos ver, se mantiene la tabla central típica de la relación `N:M`. Para implementar este caso vamos a necesitar 4 clase que se podrán ver ahora:

Las clases Módulo y Profesor son las siguientes:


```java
package modelo;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Profesor")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Profesor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idProfesor")
    private Long idProfesor;

    @Column(name = "nombre")
    private String nombre;

    @OneToMany(mappedBy = "profesor", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Docencia> docencias = new ArrayList<>();
}
```
```java
package modelo;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Modulo")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Modulo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idModulo")
    private Long idModulo;

    @Column(name = "nombre")
    private String nombre;

    @OneToMany(mappedBy = "modulo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Docencia> docencias = new ArrayList<>();

}
```

Esta es la especificación más compleja, vamos:

- En ambas clases, la asignación es `@OneToMany`
- En ambos casos, indicamos cómo gestionamos las operaciones en cascada (`cascade`) y la carga de objetos relacionados desde la otra clase (`fetch`).
- En la clase propietaria (`Profesor`), se asignará un `List<Docencia>` con la relación que comenzará desde mi clase actual `Profesor` → `Docencia` → `Modulo` (el tipo base del Set).

En este apartado como podemos ver sólo hemos mapeado 2 entidades, Profesor y Módulo. Estas se encuetran relacionadas por la tabla docencia. Puesto que esta tabla docencia no tiene más atributos, podríamos prescindir de crear una clase llamada `Docencia` de tal manera que mapearamos directamente. En este apartado vamos a ver con 4 clases y entender el motivo de realizar esta implementación.

Clase `DocenciaId`

```java
package modelo;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocenciaId implements Serializable {

    private static final long serialVersionUID = 1L;

    @Column(name = "idProfesor")
    private Long idProfesor;

    @Column(name = "idModulo")
    private Long idModulo;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        DocenciaId that = (DocenciaId) o;
        return Objects.equals(idProfesor, that.idProfesor) &&
                Objects.equals(idModulo, that.idModulo);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idProfesor, idModulo);
    }
}
```
!!! question "¿Por qué necesitamos la clase DocenciaId?"
    - Porque la tabla Docencia tiene dos atributos como clave que son claves ajenas a su vez.
    - **JPA** requiere que las claves primarias compuestas se representen como una clase separada que implemente Serializable.
    - `@Embeddable`marca una clase cuyas instancias se almacenan como parte de una entidad dueña, en lugar de tener su propia identidad en la base de datos.

Una vez se dispone de la clase `DocenciaId`implementaremos la clase `Docencia`

```java
package modelo;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import jakarta.persistence.*;

@Entity
@Table(name = "Docencia")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Docencia {

    @EmbeddedId
    private DocenciaId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idProfesor")
    @JoinColumn(name = "idProfesor")
    private Profesor profesor;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idModulo")
    @JoinColumn(name = "idModulo")
    private Modulo modulo;
}

```

!!! info

    - `@EmbeddedId` A través de este decorador indicamos la uniciddad de la clave primaria. Es más apto para consultas con JPL.
    - `@MapsId` se usa para indicar que una relación JPA comparte la clave primaria con la entidad dueña. Específicamente, mapea una relación `@ManyToOne` o `@OneToOne` para que use la misma columna que forma parte de la clave primaria embebida.


Este sería un ejemplo de programa principal

```java
import modelo.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import java.time.LocalDateTime;

public class Main{

    public static void main(String[] args) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("DocenciaConsultasPU");
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            // Crear un nuevo profesor y asignarle múltiples módulos
            Profesor nuevoProfesor = new Profesor();
            nuevoProfesor.setNombre("Jose Manuel Romero");
            em.persist(nuevoProfesor);

            // Asignar módulos al nuevo profesor
            Modulo modulo1 = em.find(Modulo.class, 3L); // EIE
            Modulo modulo2 = em.find(Modulo.class, 6L); // ACD



            // Primera asignación
            Docencia docencia1 = new Docencia();
            docencia1.setId(new DocenciaId(nuevoProfesor.getIdProfesor(), modulo1.getIdModulo()));
            docencia1.setProfesor(nuevoProfesor);
            docencia1.setModulo(modulo1);
            em.persist(docencia1);

            // Segunda asignación
            Docencia docencia2 = new Docencia();
            docencia2.setId(new DocenciaId(nuevoProfesor.getIdProfesor(), modulo2.getIdModulo()));
            docencia2.setProfesor(nuevoProfesor);
            docencia2.setModulo(modulo2);
            em.persist(docencia2);

//            // Crear un nuevo alumno y agregarle exámenes
//            Alumno nuevoAlumno = new Alumno();
//            nuevoAlumno.setNombre("Marta");
//            nuevoAlumno.setApellidos("Rodriguez Santos");
//            nuevoAlumno.setEdad(23);
//            nuevoAlumno.setRepetidor(true);
//            em.persist(nuevoAlumno);
//
//            // Agregar exámenes al alumno
//            Examen examen1 = new Examen();
//            examen1.setFecha(LocalDateTime.of(2024, 1, 15, 10, 0));
//            examen1.setNota(7.0);
//            examen1.setAlumno(nuevoAlumno);
//            examen1.setModulo(modulo1);
//            em.persist(examen1);
//
//            Examen examen2 = new Examen();
//            examen2.setFecha(LocalDateTime.of(2024, 1, 20, 9, 0));
//            examen2.setNota(5.5);
//            examen2.setAlumno(nuevoAlumno);
//            examen2.setModulo(modulo2);
//            em.persist(examen2);

            tx.commit();
            System.out.println("Inserción compleja completada:");
            System.out.println("- Profesor: " + nuevoProfesor.getNombre() + " (ID: " + nuevoProfesor.getIdProfesor() + ")");
//            System.out.println("- Alumno: " + nuevoAlumno.getNombre() + " " + nuevoAlumno.getApellidos());
//            System.out.println("- Módulos asignados: " + modulo1.getNombre() + ", " + modulo2.getNombre());
//            System.out.println("- Exámenes creados: 2");

        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
            emf.close();
        }
    }
}

```

Puedes acceder a este proyecto desde [aquí](./jakartaDocencia.zip)

### 4.3.2 Muchos a Muchos con 2 clases

