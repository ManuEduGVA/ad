# 5. Hibernate Query Language (HQL) / JPQL

La documentación completa se puede encontrar aquí:

- [Documentación en español](https://docs.jboss.org/hibernate/core/3.6/reference/es-ES/html/queryhql.html)
- [Documentación en inglés](https://docs.jboss.org/hibernate/core/4.3/manual/en-US/html/ch16.html)

## Introducción a JPQL

JPQL (Java Persistence Query Language) es el lenguaje de consulta estándar de JPA, basado en HQL (Hibernate Query Language). JPQL trabaja con entidades y sus propiedades en lugar de tablas y columnas directamente.

Las consultas con JPQL se realizan desde el **EntityManager** mediante la interfaz **TypedQuery** o **Query**. JPQL preserva el modelo orientado a objetos mientras permite realizar consultas similares a SQL.

## Creación y Ejecución de Consultas

En JPA, trabajamos con EntityManager en lugar de Session. Las consultas se crean de la siguiente manera:

```java
// Consulta tipada (recomendado)
TypedQuery<Alumno> q = entityManager.createQuery("JPQL statement", Alumno.class);

// Consulta no tipada (alternativa)
Query q = entityManager.createQuery("JPQL statement");
```



Opciones de ejecución:



```java
1 TypedQuery<Alumno> q = entityManager.createQuery("JPQL statement", Alumno.class);

2.1 List<Alumno> resultsObjects = q.getResultList();

2.2 List<Object[]> mixedResults = q.getResultList();

2.3 Alumno result = q.getSingleResult();

2.4 Object[] result = q.getSingleResult();

// Procesar la información obtenida
```



!!! note "Nota"
    - `entityManager.createQuery()` → permite escribir una consulta JPQL
    - `getResultList()` → obtiene todos los objetos que satisfacen la consulta
    - `getSingleResult()` → obtiene un único objeto

## Características de JPQL

- Las consultas se realizan sobre entidades, no tablas
- Los nombres de entidades y propiedades son case-sensitive
- Es recomendable usar alias para las entidades
- No es necesario usar `SELECT *` - podemos omitir el SELECT completamente
- Las constantes de texto se encierran entre comillas simples
- Podemos consultar colecciones dentro de las entidades

## 5.1. Recuperando Objetos

Basándonos en el esquema de base de datos proporcionado, definamos primero las entidades:

### Entidad Alumno



```java
@Entity
@Table(name = "Alumno")
@NamedQueries({
    @NamedQuery(name = "Alumno.findAll", query = "SELECT a FROM Alumno a"),
    @NamedQuery(name = "Alumno.findByEdad", query = "SELECT a FROM Alumno a WHERE a.edad = :edad"),
    @NamedQuery(name = "Alumno.findRepetidores", query = "SELECT a FROM Alumno a WHERE a.repetidor = true")
})
public class Alumno implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idAlumno;
    
    private String nombre;
    private String apellidos;
    private Integer edad;
    private Boolean repetidor;
    
    @OneToMany(mappedBy = "alumno")
    private List<Examen> examenes = new ArrayList<>();
    
    // Constructores, getters y setters
}
```



### Entidad Examen



```java
@Entity
@Table(name = "Examen")
public class Examen implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idExamen;
    
    private LocalDateTime fecha;
    private Double nota;
    
    @ManyToOne
    @JoinColumn(name = "idAlumno")
    private Alumno alumno;
    
    @ManyToOne
    @JoinColumn(name = "idModul")
    private Modulo modulo;
    
    // Constructores, getters y setters
}
```



## 5.2. Consultas JPQL

### 5.2.1. Obteniendo Objetos Simples

**Consultar todos los alumnos:**



```java
// Forma completa y tipada
TypedQuery<Alumno> q = entityManager.createQuery("SELECT a FROM Alumno a", Alumno.class);
List<Alumno> losAlumnos = q.getResultList();

// Forma simplificada
TypedQuery<Alumno> q = entityManager.createQuery("FROM Alumno", Alumno.class);
List<Alumno> losAlumnos = q.getResultList();

for (Alumno alumno : losAlumnos) {
    System.out.println(alumno);
}
```



**Consultar un alumno específico:**



```java
TypedQuery<Alumno> q = entityManager.createQuery("SELECT a FROM Alumno a WHERE a.idAlumno = :id", Alumno.class);
q.setParameter("id", 1L);
Alumno alumno = q.getSingleResult();
System.out.println(alumno);
```



!!! warning "Atención"
    Usar `getSingleResult()` cuando la consulta puede devolver múltiples resultados lanzará una excepción `NonUniqueResultException`.

**Paginación de resultados:**



```java
TypedQuery<Alumno> q = entityManager.createQuery("SELECT a FROM Alumno a ORDER BY a.nombre", Alumno.class);
q.setFirstResult(0); // Índice del primer resultado
q.setMaxResults(10); // Máximo número de resultados
List<Alumno> alumnos = q.getResultList();
```



### 5.2.2. Obteniendo Objetos Compuestos

**Consultar nombre y edad de los alumnos:**



```java
TypedQuery<Object[]> q = entityManager.createQuery(
    "SELECT a.nombre, a.edad FROM Alumno a", Object[].class);
List<Object[]> results = q.getResultList();

for (Object[] result : results) {
    String nombre = (String) result[0];
    Integer edad = (Integer) result[1];
    System.out.println("Alumno: " + nombre + ", Edad: " + edad);
}
```



**Trabajando con colecciones:**



```java
TypedQuery<Object[]> q = entityManager.createQuery(
    "SELECT a.nombre, SIZE(a.examenes) FROM Alumno a", Object[].class);
List<Object[]> results = q.getResultList();

for (Object[] result : results) {
    System.out.println("Alumno: " + result[0] + " ha realizado " + result[1] + " exámenes.");
}
```



## 5.3. Parámetros en JPQL

### 5.3.1. Parámetros Posicionales (NO recomendado en JPA 2.0+)



```java
// No recomendado - usar parámetros nombrados en su lugar
Query q = entityManager.createQuery("SELECT a FROM Alumno a WHERE a.edad = ?1");
q.setParameter(1, 24);
List<Alumno> alumnos = q.getResultList();
```



### 5.3.2. Parámetros Nominales (Recomendado)



```java
TypedQuery<Alumno> q = entityManager.createQuery(
    "SELECT a FROM Alumno a WHERE a.edad BETWEEN :minEdad AND :maxEdad", Alumno.class);
q.setParameter("minEdad", 20);
q.setParameter("maxEdad", 25);
List<Alumno> alumnos = q.getResultList();
```



### 5.3.3. Consultas Nombradas (Named Queries)

Definidas en la entidad:



```java
@Entity
@Table(name = "Alumno")
@NamedQueries({
    @NamedQuery(name = "Alumno.findRepetidores", 
                query = "SELECT a FROM Alumno a WHERE a.repetidor = true"),
    @NamedQuery(name = "Alumno.findByRangoEdad",
                query = "SELECT a FROM Alumno a WHERE a.edad BETWEEN :min AND :max"),
    @NamedQuery(name = "Alumno.findAllOrderByEdadDesc",
                query = "SELECT a FROM Alumno a ORDER BY a.edad DESC")
})
public class Alumno implements Serializable {
    // ...
}
```



Uso de consultas nombradas:



```java
// Consulta tipada
TypedQuery<Alumno> q = entityManager.createNamedQuery("Alumno.findRepetidores", Alumno.class);
List<Alumno> repetidores = q.getResultList();

// Con parámetros
TypedQuery<Alumno> q = entityManager.createNamedQuery("Alumno.findByRangoEdad", Alumno.class);
q.setParameter("min", 20);
q.setParameter("max", 25);
List<Alumno> alumnos = q.getResultList();
```



## 5.4. Operaciones CRUD con JPA

### 5.4.1. Crear (Insert)



```java
Alumno alumno = new Alumno();
alumno.setNombre("Lewis");
alumno.setApellidos("Hamilton");
alumno.setEdad(42);
alumno.setRepetidor(false);

entityManager.persist(alumno);
// En un contexto transaccional, usar entityManager.getTransaction().commit()
```



### 5.4.2. Actualizar (Update)

**Actualizar un objeto específico:**



```java
Alumno alumno = entityManager.find(Alumno.class, 7L);
alumno.setEdad(44);
alumno.setRepetidor(true);

// Con merge (para entidades detached)
entityManager.merge(alumno);
```



**Actualización masiva:**



```java
Query q = entityManager.createQuery(
    "UPDATE Alumno a SET a.edad = a.edad + 1 WHERE a.repetidor = true");
int registrosActualizados = q.executeUpdate();
System.out.println(registrosActualizados + " alumnos actualizados");
```



### 5.4.3. Eliminar (Delete)

**Eliminar un objeto específico:**



```java
Alumno alumno = entityManager.find(Alumno.class, 7L);
entityManager.remove(alumno);
```



**Eliminación masiva:**



```java
Query q = entityManager.createQuery("DELETE FROM Alumno a WHERE a.repetidor = true");
int registrosEliminados = q.executeUpdate();
System.out.println(registrosEliminados + " alumnos eliminados");
```



!!! tip "Consejo"
    \- Las operaciones de actualización y eliminación masiva deben usarse con cuidado
    \- Verificar las restricciones de integridad referencial
    \- Considerar el uso de operaciones en cascada cuando sea apropiado

## 5.5. Consultas Avanzadas

### Joins implícitos y explícitos



```java
// Join implícito
TypedQuery<Object[]> q = entityManager.createQuery(
    "SELECT a.nombre, e.nota FROM Alumno a, Examen e WHERE a.idAlumno = e.alumno.idAlumno", 
    Object[].class);

// Join explícito (recomendado)
TypedQuery<Object[]> q = entityManager.createQuery(
    "SELECT a.nombre, e.nota FROM Alumno a JOIN a.examenes e WHERE e.nota > 5", 
    Object[].class);
```



### Funciones de agregación



```java
// Promedio de notas por alumno
TypedQuery<Object[]> q = entityManager.createQuery(
    "SELECT a.nombre, AVG(e.nota) FROM Alumno a JOIN a.examenes e GROUP BY a.nombre", 
    Object[].class);

// Contar exámenes por módulo
TypedQuery<Object[]> q = entityManager.createQuery(
    "SELECT m.nombre, COUNT(e) FROM Modulo m LEFT JOIN m.examenes e GROUP BY m.nombre", 
    Object[].class);
```



## 5.6. Estados de las Entidades en JPA

En JPA, las entidades pueden tener los siguientes estados:

- **Transient**: El objeto es nuevo y no está asociado con ningún contexto de persistencia
- **Managed**: El objeto está siendo gestionado por el EntityManager
- **Detached**: El objeto fue gestionado pero el EntityManager está cerrado
- **Removed**: El objeto está marcado para ser eliminado



```java
// Transient
Alumno alumno = new Alumno();

// Managed (después de persist)
entityManager.persist(alumno);

// Detached (después de close o clear)
entityManager.detach(alumno);
// o
entityManager.close();

// Removed
entityManager.remove(alumno);
```

El proyecto de ejemplo lo tenemos [aquí](./jakartaDocencia2Relations_Querys.zip)