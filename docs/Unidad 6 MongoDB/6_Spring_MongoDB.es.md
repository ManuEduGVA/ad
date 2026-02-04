# 6. Spring Data MongoDB y API REST

Como sabemos, el proyecto **Spring Data**, incluido en la plataforma Spring, proporciona un marco para simplificar el acceso y la persistencia de datos en distintos repositorios de información. Dentro de este proyecto se encuentra **Spring Data MongoDB**, que proporciona integración con bases de datos MongoDB, a través de un modelo centrado en **POJOs** que interactúan con colecciones de documentos y proporciona un repositorio de acceso a datos.

En esta sección, y continuando con la unidad anterior, abordaremos el desarrollo de componentes de acceso a datos a través de Spring Data, así como microservicios que ofrecen estos datos a través de una API REST, todo ello siguiendo el patrón MVC que ya conocemos.

## 6.1. Definiendo el Modelo – Documento

Una base de datos MongoDB está compuesta por colecciones de `Document`. Aunque estos Documentos pueden tener estructuras diferentes entre sí o distintos tipos de datos, el modelo requiere una estructura estática. Así pues, lo primero que debemos hacer es crear una clase que represente este _Documento Principal para MongoDB_, que será lo que se devolverá por las consultas que se hagan.

En este contexto, existen dos anotaciones principales que utilizaremos:

- `@Document` → para indicar que una clase corresponde a un objeto de dominio (domain object) que se puede mapear en la base de datos para ofrecer persistencia. Esta anotación para MongoDB sería la equivalente a `@Entity` en JPA. Si no se indica nada, el nombre de la colección que se va a utilizar se interpretará como correspondiente al nombre de la clase en **minúsculas**. Así, si tenemos la clase `com.jaume.ad.Person`, se utilizará la colección `person`. Sin embargo, podemos indicar la colección con la que estamos trabajando, ya sea a través de los atributos value o collection, con la siguiente sintaxis: 
- `@Document(value="collection")` 
- `@Document("collection")` 
- `@Document(collection="collection")`
- `@Id` Se aplica a un campo, y se utiliza para indicar que el campo se utilizará como identificador. Como sabemos, cada documento en MongoDB requiere un identificador. Si no se proporciona ninguna, el controlador asignará un `ObjectID` automáticamente. Es importante tener en cuenta que los tipos de datos que podemos utilizar como identificadores pueden ser tanto `Strings` como `BigInteger`, puesto que Spring se encargará de convertirlos al tipo ObjectID.

!!! importante "Importante" 
    Existe una anotación `@DocumentReference` para relacionar Documentos uno dentro de otros, por ejemplo cuando almacenamos en una clase objetos de otras clases, como las relaciones en bases de datos SQL.

Además de éstas, existen otras anotaciones más específicas que podemos utilizar. Si lo desea, puede consultarlas en la documentación de referencia de Spring Data MongoDB [aquí](https://spring.io/projects/spring-data-mongodb).

```java
package org.cipfpcheste.dam2.springmongodb.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.List;

@Document(collection = "Peli")
public class Pelicula {

    @Id
    private String id;

    private String titulo;

    private Integer anyo;

    private String director;

    private String pais;

    private List<String> genero;

    @Field("duracion_minutos")
    private Integer duracionMinutos;

    private String clasificacion;

    @Field("actores_principales")
    private List<String> actoresPrincipales;

    @Field("puntuacion_imdb")
    private Double puntuacionImdb;

    @Field("taquilla_global_millones")
    private Double taquillaGlobalMillones;

    private Integer oscars;

    @Field("premios_goya")
    private Integer premiosGoya;

    // Constructores
    public Pelicula() {
    }

    public Pelicula(String titulo, Integer anyo, String director, String pais,
                    List<String> genero, Integer duracionMinutos, String clasificacion,
                    List<String> actoresPrincipales, Double puntuacionImdb,
                    Double taquillaGlobalMillones) {
        this.titulo = titulo;
        this.anyo = anyo;
        this.director = director;
        this.pais = pais;
        this.genero = genero;
        this.duracionMinutos = duracionMinutos;
        this.clasificacion = clasificacion;
        this.actoresPrincipales = actoresPrincipales;
        this.puntuacionImdb = puntuacionImdb;
        this.taquillaGlobalMillones = taquillaGlobalMillones;
    }

    // Getters y Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public Integer getAnyo() {
        return anyo;
    }

    public void setAnyo(Integer anyo) {
        this.anyo = anyo;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getPais() {
        return pais;
    }

    public void setPais(String pais) {
        this.pais = pais;
    }

    public List<String> getGenero() {
        return genero;
    }

    public void setGenero(List<String> genero) {
        this.genero = genero;
    }

    public Integer getDuracionMinutos() {
        return duracionMinutos;
    }

    public void setDuracionMinutos(Integer duracionMinutos) {
        this.duracionMinutos = duracionMinutos;
    }

    public String getClasificacion() {
        return clasificacion;
    }

    public void setClasificacion(String clasificacion) {
        this.clasificacion = clasificacion;
    }

    public List<String> getActoresPrincipales() {
        return actoresPrincipales;
    }

    public void setActoresPrincipales(List<String> actoresPrincipales) {
        this.actoresPrincipales = actoresPrincipales;
    }

    public Double getPuntuacionImdb() {
        return puntuacionImdb;
    }

    public void setPuntuacionImdb(Double puntuacionImdb) {
        this.puntuacionImdb = puntuacionImdb;
    }

    public Double getTaquillaGlobalMillones() {
        return taquillaGlobalMillones;
    }

    public void setTaquillaGlobalMillones(Double taquillaGlobalMillones) {
        this.taquillaGlobalMillones = taquillaGlobalMillones;
    }

    public Integer getOscars() {
        return oscars;
    }

    public void setOscars(Integer oscars) {
        this.oscars = oscars;
    }

    public Integer getPremiosGoya() {
        return premiosGoya;
    }

    public void setPremiosGoya(Integer premiosGoya) {
        this.premiosGoya = premiosGoya;
    }
}

```

## 📋 Explicación de los Decoradores

### 1. **`@Document(collection = "Peli")`**

- **Paquete:** `org.springframework.data.mongodb.core.mapping.Document`
- **Propósito:** Indica que esta clase Java representa un **documento MongoDB**
- **Parámetro :`collection`** Especifica que los documentos se almacenan en la colección llamada **"Peli"**
- **Nota:** Sin este parámetro, Spring usaría el nombre de la clase en minúsculas ("pelicula")

### 2. **`@Id`**

- **Paquete:** `org.springframework.data.annotation.Id`
- **Propósito:** Marca el campo como el **identificador único** del documento
- Comportamiento:
  - MongoDB usa `_id` como identificador por defecto
  - Spring mapea automáticamente `_id` ↔ `id`
  - Si no se proporciona valor, MongoDB genera un automáticamente `ObjectId`

### 3. **`@Field("nombre_campo")`**

- **Paquete:** `org.springframework.data.mongodb.core.mapping.Field`
- **Propósito:** Mapea un **atributo Java** a un **campo con nombre diferente** en MongoDB
- Ejemplos en la clase:
  - → En Java: , en MongoDB: `@Field("duracion_minutos")` `duracionMinutos`  `duracion_minutos`
  - → En Java: , en MongoDB: `@Field("actores_principales")` `actoresPrincipales` `actores_principales` 
  - → En Java: , en MongoDB: `@Field("puntuacion_imdb")` `puntuacionImdb` `puntuacion_imdb` 
  - → En Java: , en MongoDB: `@Field("taquilla_global_millones")` `taquillaGlobalMillones` `taquilla_global_millones` 
  - → En Java: , en MongoDB: `@Field("premios_goya")` `premiosGoya` `premios_goya` 

------

------

## 🗂️ Estructura de los Campos

### Campos sin : `@Field`

Cuando **NO** usas , Spring mapea el nombre del atributo Java directamente: `@Field`

- → `titulo` `titulo`
- → `anyo` `anyo`
- → `director` `director`
- → `pais` `pais`
- → `genero`  `genero` 
- → `clasificacion` `clasificacion` 
- → `oscars` `oscars` 

### Campos con : `@Field`

Permiten usar **convenciones diferentes** entre Java (camelCase) y MongoDB (snake_case):

- Java: ↔ MongoDB: `duracionMinutos` `duracion_minutos` 
- Java: ↔ MongoDB: `actoresPrincipales` `actores_principales` 
- Java: ↔ MongoDB: `puntuacionImdb` `puntuacion_imdb` 
- Java: ↔ MongoDB: `taquillaGlobalMillones` `taquilla_global_millones` 
- Java: ↔ MongoDB: `premiosGoya` `premios_goya` 

------

------

## 📊 Tipos de Datos

| Campo                  | Tipo Java    | Tipo MongoDB      |
| ---------------------- | ------------ | ----------------- |
| id                     | String       | ObjectId / String |
| titulo                 | String       | String            |
| anyo                   | Integer      | Int32             |
| director               | String       | String            |
| pais                   | String       | String            |
| genero                 | List<String> | Array             |
| duracionMinutos        | Integer      | Int32             |
| clasificacion          | String       | String            |
| actoresPrincipales     | List<String> | Array             |
| puntuacionImdb         | Double       | Double            |
| taquillaGlobalMillones | Double       | Double            |
| oscars                 | Integer      | Int32             |
| premiosGoya            | Integer      | Int32             |







## 6.2. Definiendo el Repositorio

Como sabemos, el repositorio es la interfaz encargada de gestionar el acceso a los datos. En el caso de MongoDB, éste derivará de `MongoRepository`, que será una interfaz parametrizada por dos argumentos:

- `MongoRepository<T, Id>`, donde: 
- `T` → El tipo de documento, que corresponderá a la clase definida en el modelo, y 
- `Id`→ El tipo de dato al que pertenecerá el identificador.

La interfaz MongoRepository, como hemos dicho, será específica para MongoDB, y derivará de las interfaces `CrudRepository` y `PagingAndSortingRepository`, de las que heredará todos sus métodos. De esta forma, en el repositorio sólo deberemos declarar aquellos métodos que sean más específicos para nuestra aplicación, ya que todos los métodos para implementar operaciones CRUD, así como `findAll()` y `findById()` serán heredados de `MongoRepository`.

Para definir nuestras propias consultas en el repositorio, utilizaremos la anotación `@Query`, proporcionando la consulta en cuestión como valor:

```java
@Query(value="{ parameterized_query}") // respecto a la clase base del repositorio
List<DocumentType> methodName(list_parameters);
```

Para suministrar parámetros a la consulta, éstos se reciben como argumentos del método, y se referencian por su orden a la consulta: `?0` para el primer argumento, `?1` para el segundo, etc. Quizás en versiones más nuevas se pueden utilizar parámetros de forma nominal, como `:parameter_name`.

```java
package org.cipfpcheste.dam2.springmongodb.repository;

import org.cipfpcheste.dam2.springmongodb.model.Pelicula;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PeliculaRepository extends MongoRepository<Pelicula, String> {
    
    // Buscar por título
    List<Pelicula> findByTituloContainingIgnoreCase(String titulo);
    
    // Buscar por director
    List<Pelicula> findByDirectorContainingIgnoreCase(String director);
    
    // Buscar por país
    List<Pelicula> findByPais(String pais);
    
    // Buscar por año
    List<Pelicula> findByAnyo(Integer anyo);
    
    // Buscar por género
    List<Pelicula> findByGeneroContaining(String genero);
    
    // Buscar películas con puntuación mayor o igual
    List<Pelicula> findByPuntuacionImdbGreaterThanEqual(Double puntuacion);
    
    // Buscar películas ganadoras de Oscars
    @Query("{ 'oscars': { $exists: true, $ne: null } }")
    List<Pelicula> findPeliculasConOscars();
    
    // Buscar películas ganadoras de Goyas
    @Query("{ 'premios_goya': { $exists: true, $ne: null } }")
    List<Pelicula> findPeliculasConGoyas();
}


```

## 6.3. Definiendo el servicio

Los servicios se encargan de la capa de negocio de nuestra aplicación y acceden a los datos a través del repositorio, enviando los resultados al controlador. Estos servicios, en general, se caracterizan por:

- Utilizar las anotaciones `@Service`, para indicar a Spring que se está implementando un servicio
- Por un lado, se define la interfaz del Servicio y, por otro, se realiza la implementación a través de la clase `ServiceImpl`.
- Se utiliza la anotación `@Autowired` en referencias a repositorios para enlazar o inyectar el servicio en cuestión con este repositorio.
- Una vez obtenga los datos del repositorio, los envía al controlador.

Interfaz PeliculaService:

```java

package org.cipfpcheste.dam2.springmongodb.service;

import org.cipfpcheste.dam2.springmongodb.model.Pelicula;

import java.util.List;
import java.util.Optional;

public interface PeliculaService {
    
    // Operaciones CRUD básicas
    List<Pelicula> obtenerTodasLasPeliculas();
    
    Optional<Pelicula> obtenerPeliculaPorId(String id);
    
    Pelicula crearPelicula(Pelicula pelicula);
    
    Pelicula actualizarPelicula(String id, Pelicula peliculaActualizada);
    
    boolean eliminarPelicula(String id);
    
    // Búsquedas específicas
    List<Pelicula> buscarPorTitulo(String titulo);
    
    List<Pelicula> buscarPorDirector(String director);
    
    List<Pelicula> buscarPorPais(String pais);
    
    List<Pelicula> buscarPorAnyo(Integer anyo);
    
    List<Pelicula> buscarPorGenero(String genero);
    
    List<Pelicula> buscarPorPuntuacionMinima(Double puntuacion);
    
    List<Pelicula> obtenerPeliculasConOscars();
    
    List<Pelicula> obtenerPeliculasConGoyas();
}


```
Implementación del interfaz, PeliculaServiceImpl:

```java

package org.cipfpcheste.dam2.springmongodb.service;

import org.cipfpcheste.dam2.springmongodb.model.Pelicula;
import org.cipfpcheste.dam2.springmongodb.repository.PeliculaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PeliculaServiceImpl implements PeliculaService {

    @Autowired
    private PeliculaRepository peliculaRepository;

    @Override
    public List<Pelicula> obtenerTodasLasPeliculas() {
        return peliculaRepository.findAll();
    }

    @Override
    public Optional<Pelicula> obtenerPeliculaPorId(String id) {
        return peliculaRepository.findById(id);
    }

    @Override
    public Pelicula crearPelicula(Pelicula pelicula) {
        return peliculaRepository.save(pelicula);
    }

    @Override
    public Pelicula actualizarPelicula(String id, Pelicula peliculaActualizada) {
        return peliculaRepository.findById(id)
            .map(pelicula -> {
                pelicula.setTitulo(peliculaActualizada.getTitulo());
                pelicula.setAnyo(peliculaActualizada.getAnyo());
                pelicula.setDirector(peliculaActualizada.getDirector());
                pelicula.setPais(peliculaActualizada.getPais());
                pelicula.setGenero(peliculaActualizada.getGenero());
                pelicula.setDuracionMinutos(peliculaActualizada.getDuracionMinutos());
                pelicula.setClasificacion(peliculaActualizada.getClasificacion());
                pelicula.setActoresPrincipales(peliculaActualizada.getActoresPrincipales());
                pelicula.setPuntuacionImdb(peliculaActualizada.getPuntuacionImdb());
                pelicula.setTaquillaGlobalMillones(peliculaActualizada.getTaquillaGlobalMillones());
                pelicula.setOscars(peliculaActualizada.getOscars());
                pelicula.setPremiosGoya(peliculaActualizada.getPremiosGoya());
                return peliculaRepository.save(pelicula);
            })
            .orElse(null);
    }

    @Override
    public boolean eliminarPelicula(String id) {
        if (peliculaRepository.existsById(id)) {
            peliculaRepository.deleteById(id);
            return true;
        }
        return false;
    }

    @Override
    public List<Pelicula> buscarPorTitulo(String titulo) {
        return peliculaRepository.findByTituloContainingIgnoreCase(titulo);
    }

    @Override
    public List<Pelicula> buscarPorDirector(String director) {
        return peliculaRepository.findByDirectorContainingIgnoreCase(director);
    }

    @Override
    public List<Pelicula> buscarPorPais(String pais) {
        return peliculaRepository.findByPais(pais);
    }

    @Override
    public List<Pelicula> buscarPorAnyo(Integer anyo) {
        return peliculaRepository.findByAnyo(anyo);
    }

    @Override
    public List<Pelicula> buscarPorGenero(String genero) {
        return peliculaRepository.findByGeneroContaining(genero);
    }

    @Override
    public List<Pelicula> buscarPorPuntuacionMinima(Double puntuacion) {
        return peliculaRepository.findByPuntuacionImdbGreaterThanEqual(puntuacion);
    }

    @Override
    public List<Pelicula> obtenerPeliculasConOscars() {
        return peliculaRepository.findPeliculasConOscars();
    }

    @Override
    public List<Pelicula> obtenerPeliculasConGoyas() {
        return peliculaRepository.findPeliculasConGoyas();
    }
}


```



## 6.4. Definiendo el controlador

Finalmente, nos queda la implementación del controlador, que ya conocemos de Spring. Recordamos las características principales de éste:

- Utilizar la anotación `@RestController` a nivel de clase para indicar que se trata de un controlador REST
- Utilizar la anotación `@RequestMapping` a nivel de clase para especificar el camino base para los puntos finales del servicio,
- Utilizar la anotación `@Autowired` en las propiedades que hacen referencia al servicio, para inyectarlo automáticamente,
- Utilizar las anotaciones `@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping` a los métodos que implementarán solicitudes de tipo GET, POST, PUT o DELETE, especificando su Endpoint.
- Utilizar las anotaciones `@PathVariable` o `@RequestParam` o `@RequestBody` en los argumentos de los métodos anteriores para obtener los valores del camino, solicitud o cuerpo.

## 2. OpenAPI (Swagger)

Swagger, ahora OpenApi, es una herramienta que se integra completamente con Spring y nos va a permitir describir, producir, consumir y visualizar servicios web RESTful.[1]​ Comenzó como parte del marco Swagger, y se convirtió en un proyecto separado en 2016, supervisado por la Iniciativa OpenAPI, un proyecto de colaboración de código abierto de la Fundación Linux.[2]​ Swagger y algunas otras herramientas pueden generar código, documentación y casos de prueba con un archivo de interfaz.

Lo primero que debemos hacer es añadir la dependencia en el pom.xl:

```xml
      <!-- Source: https://mvnrepository.com/artifact/org.springdoc/springdoc-openapi-starter-webmvc-ui -->
        <dependency>
            <groupId>org.springdoc</groupId>
            <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
            <version>3.0.1</version>
            <scope>compile</scope>
        </dependency>

```

Generamos el paquete `config`en el cual definiremos la configuración de OpenAPI en una clase:


```java
package org.cipfpcheste.dam2.springmongodb.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenAPIConfig {

    @Bean
    public OpenAPI peliculasAPI() {
        Server localServer = new Server();
        localServer.setUrl("http://localhost:8080");
        localServer.setDescription("Servidor de Desarrollo Local de 2º DAM");

        Contact contact = new Contact();
        contact.setEmail("manu@cipfpcheste.dam2");
        contact.setName("José Manuel Romero");
        contact.setUrl("https://portal.edu.gva.es/fpcheste/");

        License mitLicense = new License()
                .name("MIT License")
                .url("https://choosealicense.com/licenses/mit/");

        Info info = new Info()
                .title("API de Gestión de Películas")
                .version("1.0.0")
                .contact(contact)
                .description("API REST para la gestión de películas con MongoDB")
                .termsOfService("https://www.cipfpcheste.dam2/terms")
                .license(mitLicense);

        return new OpenAPI()
                .info(info)
                .servers(List.of(localServer));
    }
}

```



- **Paquete:** `org.springframework.context.annotation.Configuration`
- **Propósito:** Indica que esta clase contiene **definiciones de beans de Spring**
- **Comportamiento:** Spring procesará esta clase al iniciar la aplicación y registrará los beans definidos
- **Alternativa:** Podría usar `@SpringBootConfiguration` pero `@Configuration` es más estándar

- **Anotación:** `@Bean` marca este método como productor de un bean de Spring
- **Tipo de retorno:** - objeto principal que contiene toda la configuración de la documentación `OpenAPI`
- **Nombre del bean:** Por defecto es el nombre del método (`peliculasAPI`)
- **Ciclo de vida:** Singleton - se crea una sola instancia durante la vida de la aplicación



### Configuración del servidor

```java
Server localServer = new Server();
localServer.setUrl("http://localhost:8080");
localServer.setDescription("Servidor de Desarrollo Local");
```



#### Componentes:

- **Clase:** `io.swagger.v3.oas.models.servers.Server`
- **`setUrl()`:** Define la URL base donde está corriendo tu API
- **`setDescription()`:** Descripción legible del servidor

#### ¿Para qué sirve?

- Define dónde están disponibles los endpoints de tu API
- Puedes tener múltiples servidores (desarrollo, staging, producción)
- Swagger UI usará esta URL para hacer las peticiones de prueba



#### Ejemplo con múltiples servidores:

```java
Server devServer = new Server();
devServer.setUrl("http://localhost:8080");
devServer.setDescription("Desarrollo");

Server prodServer = new Server();
prodServer.setUrl("https://api.produccion.com");
prodServer.setDescription("Producción");

return new OpenAPI()
    .info(info)
    .servers(List.of(devServer, prodServer));
```



### **Información de Contacto**

```java
Contact contact = new Contact();
contact.setEmail("tu-email@cipfpcheste.dam2");
contact.setName("Tu Nombre");
contact.setUrl("https://www.cipfpcheste.dam2");
```

- **Clase:** `io.swagger.v3.oas.models.info.Contact`
- **`setEmail()`:** Email de contacto del responsable de la API
- **`setName()`:** Nombre del desarrollador o equipo
- **`setUrl()`:** URL del sitio web del desarrollador/organización

#### ¿Dónde se muestra?

Esta información aparece en la sección "Contact" de Swagger UI, permitiendo a los usuarios de la API saber a quién contactar para soporte o preguntas.



### **Licencia**

```java
License mitLicense = new License()
        .name("MIT License")
        .url("https://choosealicense.com/licenses/mit/");
```

- **Clase:** `io.swagger.v3.oas.models.info.License`
- **`name()`:** Nombre de la licencia bajo la cual se distribuye la API
- **`url()`:** URL con el texto completo de la licencia

#### Licencias comunes:

```java
// MIT License
new License().name("MIT").url("https://opensource.org/licenses/MIT");

// Apache 2.0
new License().name("Apache 2.0").url("https://www.apache.org/licenses/LICENSE-2.0.html");

// GPL v3
new License().name("GPL v3").url("https://www.gnu.org/licenses/gpl-3.0.html");
```



### **Información General de la API**

```java
Info info = new Info()
        .title("API de Gestión de Películas")
        .version("1.0.0")
        .contact(contact)
        .description("API REST para la gestión de películas con MongoDB")
        .termsOfService("https://www.cipfpcheste.dam2/terms")
        .license(mitLicense);
```



- **Clase:** `io.swagger.v3.oas.models.info.Info`
- **`title()`:** Título principal de tu API (aparece en la parte superior de Swagger UI)
- **`version()`:** Versión de la API (útil para control de versiones)
- **`contact()`:** Objeto Contact definido anteriormente
- **`description()`:** Descripción detallada de qué hace tu API
- **`termsOfService()`:** URL con los términos de servicio
- **`license()`:** Objeto License definido anteriormente

#### Versionado semántico recomendado:

```text
version("1.0.0")  // MAYOR.MENOR.PARCHE
//        ^-- Cambios incompatibles
//     ^----- Nueva funcionalidad compatible
//  ^-------- Correcciones de bugs
```



### **Objeto OpenAPI Final**

```java
return new OpenAPI()
        .info(info)
        .servers(List.of(localServer));
```

- **Clase:** `io.swagger.v3.oas.models.OpenAPI`
- **`info()`:** Adjunta toda la información de la API
- **`servers()`:** Lista de servidores disponibles

#### Este objeto es el que Spring usará para:

1. Generar la documentación JSON en `/api-docs`
2. Renderizar Swagger UI en `/swagger-ui.html`
3. Proveer metadatos a herramientas de cliente (Postman, etc.)

### Documentar el Controlador

Veamos las anotaciones que se visualizarán en el interfaz Web:



```java
package org.cipfpcheste.dam2.springmongodb.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.cipfpcheste.dam2.springmongodb.model.Pelicula;
import org.cipfpcheste.dam2.springmongodb.service.PeliculaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/peliculas")
@Tag(name = "Películas", description = "API para la gestión de películas")
public class PeliculaController {

    @Autowired
    private PeliculaService peliculaService;

    @Operation(
        summary = "Obtener todas las películas",
        description = "Retorna una lista completa de todas las películas almacenadas en la base de datos"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lista de películas obtenida exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @GetMapping
    public ResponseEntity<List<Pelicula>> obtenerTodasLasPeliculas() {
        return ResponseEntity.ok(peliculaService.obtenerTodasLasPeliculas());
    }

    @Operation(
        summary = "Obtener película por ID",
        description = "Retorna una película específica basada en su identificador único"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Película encontrada",
                     content = @Content(schema = @Schema(implementation = Pelicula.class))),
        @ApiResponse(responseCode = "404", description = "Película no encontrada"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @GetMapping("/{id}")
    public ResponseEntity<Pelicula> obtenerPeliculaPorId(
            @Parameter(description = "ID de la película a buscar", required = true)
            @PathVariable String id) {
        return peliculaService.obtenerPeliculaPorId(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @Operation(
        summary = "Crear nueva película",
        description = "Crea y almacena una nueva película en la base de datos"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Película creada exitosamente",
                     content = @Content(schema = @Schema(implementation = Pelicula.class))),
        @ApiResponse(responseCode = "400", description = "Datos de película inválidos"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @PostMapping
    public ResponseEntity<Pelicula> crearPelicula(
            @Parameter(description = "Datos de la película a crear", required = true)
            @RequestBody Pelicula pelicula) {
        Pelicula nuevaPelicula = peliculaService.crearPelicula(pelicula);
        return ResponseEntity.status(HttpStatus.CREATED).body(nuevaPelicula);
    }

    @Operation(
        summary = "Actualizar película",
        description = "Actualiza los datos de una película existente"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Película actualizada exitosamente",
                     content = @Content(schema = @Schema(implementation = Pelicula.class))),
        @ApiResponse(responseCode = "404", description = "Película no encontrada"),
        @ApiResponse(responseCode = "400", description = "Datos de película inválidos"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @PutMapping("/{id}")
    public ResponseEntity<Pelicula> actualizarPelicula(
            @Parameter(description = "ID de la película a actualizar", required = true)
            @PathVariable String id,
            @Parameter(description = "Nuevos datos de la película", required = true)
            @RequestBody Pelicula pelicula) {
        Pelicula peliculaActualizada = peliculaService.actualizarPelicula(id, pelicula);
        if (peliculaActualizada != null) {
            return ResponseEntity.ok(peliculaActualizada);
        }
        return ResponseEntity.notFound().build();
    }

    @Operation(
        summary = "Eliminar película",
        description = "Elimina una película de la base de datos"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "204", description = "Película eliminada exitosamente"),
        @ApiResponse(responseCode = "404", description = "Película no encontrada"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarPelicula(
            @Parameter(description = "ID de la película a eliminar", required = true)
            @PathVariable String id) {
        if (peliculaService.eliminarPelicula(id)) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @Operation(
        summary = "Buscar películas por título",
        description = "Busca películas que contengan el texto especificado en el título (sin distinción de mayúsculas/minúsculas)"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Búsqueda completada exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @GetMapping("/buscar/titulo")
    public ResponseEntity<List<Pelicula>> buscarPorTitulo(
            @Parameter(description = "Texto a buscar en el título", required = true)
            @RequestParam String titulo) {
        return ResponseEntity.ok(peliculaService.buscarPorTitulo(titulo));
    }

    @Operation(
        summary = "Buscar películas por director",
        description = "Busca películas dirigidas por el director especificado"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Búsqueda completada exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @GetMapping("/buscar/director")
    public ResponseEntity<List<Pelicula>> buscarPorDirector(
            @Parameter(description = "Nombre del director", required = true)
            @RequestParam String director) {
        return ResponseEntity.ok(peliculaService.buscarPorDirector(director));
    }

    @Operation(
        summary = "Buscar películas por país",
        description = "Busca películas producidas en el país especificado"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Búsqueda completada exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @GetMapping("/buscar/pais")
    public ResponseEntity<List<Pelicula>> buscarPorPais(
            @Parameter(description = "País de producción", required = true)
            @RequestParam String pais) {
        return ResponseEntity.ok(peliculaService.buscarPorPais(pais));
    }

    @Operation(
        summary = "Buscar películas por año",
        description = "Busca películas estrenadas en el año especificado"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Búsqueda completada exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @GetMapping("/buscar/anyo")
    public ResponseEntity<List<Pelicula>> buscarPorAnyo(
            @Parameter(description = "Año de estreno", required = true, example = "1972")
            @RequestParam Integer anyo) {
        return ResponseEntity.ok(peliculaService.buscarPorAnyo(anyo));
    }

    @Operation(
        summary = "Buscar películas por género",
        description = "Busca películas que pertenezcan al género especificado"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Búsqueda completada exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @GetMapping("/buscar/genero")
    public ResponseEntity<List<Pelicula>> buscarPorGenero(
            @Parameter(description = "Género de la película", required = true, example = "Drama")
            @RequestParam String genero) {
        return ResponseEntity.ok(peliculaService.buscarPorGenero(genero));
    }

    @Operation(
        summary = "Buscar películas por puntuación mínima",
        description = "Busca películas con una puntuación IMDB mayor o igual a la especificada"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Búsqueda completada exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @GetMapping("/buscar/puntuacion")
    public ResponseEntity<List<Pelicula>> buscarPorPuntuacionMinima(
            @Parameter(description = "Puntuación mínima en IMDB", required = true, example = "8.0")
            @RequestParam Double puntuacion) {
        return ResponseEntity.ok(peliculaService.buscarPorPuntuacionMinima(puntuacion));
    }

    @Operation(
        summary = "Obtener películas ganadoras de Oscars",
        description = "Retorna todas las películas que han ganado premios Oscar"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lista obtenida exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @GetMapping("/premios/oscars")
    public ResponseEntity<List<Pelicula>> obtenerPeliculasConOscars() {
        return ResponseEntity.ok(peliculaService.obtenerPeliculasConOscars());
    }

    @Operation(
        summary = "Obtener películas ganadoras de Goyas",
        description = "Retorna todas las películas que han ganado premios Goya"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lista obtenida exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @GetMapping("/premios/goyas")
    public ResponseEntity<List<Pelicula>> obtenerPeliculasConGoyas() {
        return ResponseEntity.ok(peliculaService.obtenerPeliculasConGoyas());
    }
}
```



### Modelo de datos (Pelicula)

Actualizamos la clase Película con las anotaciones de OpenAPI:



```java
package org.cipfpcheste.dam2.springmongodb.model;

import io.swagger.v3.oas.annotations.media.Schema;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.List;

@Document(collection = "Peli")
@Schema(description = "Modelo que representa una película en el sistema")
public class Pelicula {

    @Id
    @Schema(description = "Identificador único de la película", 
            example = "507f1f77bcf86cd799439011", 
            accessMode = Schema.AccessMode.READ_ONLY)
    private String id;

    @Schema(description = "Título de la película", 
            example = "El Padrino", 
            required = true)
    private String titulo;

    @Schema(description = "Año de estreno", 
            example = "1972", 
            required = true)
    private Integer anyo;

    @Schema(description = "Nombre del director", 
            example = "Francis Ford Coppola", 
            required = true)
    private String director;

    @Schema(description = "País de producción", 
            example = "Estados Unidos", 
            required = true)
    private String pais;

    @Schema(description = "Lista de géneros de la película", 
            example = "[\"Drama\", \"Crimen\"]", 
            required = true)
    private List<String> genero;

    @Field("duracion_minutos")
    @Schema(description = "Duración de la película en minutos", 
            example = "175")
    private Integer duracionMinutos;

    @Schema(description = "Clasificación por edad", 
            example = "R")
    private String clasificacion;

    @Field("actores_principales")
    @Schema(description = "Lista de actores principales", 
            example = "[\"Marlon Brando\", \"Al Pacino\", \"James Caan\"]")
    private List<String> actoresPrincipales;

    @Field("puntuacion_imdb")
    @Schema(description = "Puntuación en IMDB", 
            example = "9.2", 
            minimum = "0", 
            maximum = "10")
    private Double puntuacionImdb;

    @Field("taquilla_global_millones")
    @Schema(description = "Recaudación global en millones de dólares", 
            example = "246.1")
    private Double taquillaGlobalMillones;

    @Schema(description = "Número de premios Oscar ganados", 
            example = "3")
    private Integer oscars;

    @Field("premios_goya")
    @Schema(description = "Número de premios Goya ganados", 
            example = "0")
    private Integer premiosGoya;

    // Constructores
    public Pelicula() {
    }

    public Pelicula(String titulo, Integer anyo, String director, String pais,
                    List<String> genero, Integer duracionMinutos, String clasificacion,
                    List<String> actoresPrincipales, Double puntuacionImdb,
                    Double taquillaGlobalMillones) {
        this.titulo = titulo;
        this.anyo = anyo;
        this.director = director;
        this.pais = pais;
        this.genero = genero;
        this.duracionMinutos = duracionMinutos;
        this.clasificacion = clasificacion;
        this.actoresPrincipales = actoresPrincipales;
        this.puntuacionImdb = puntuacionImdb;
        this.taquillaGlobalMillones = taquillaGlobalMillones;
    }

    // Getters y Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public Integer getAnyo() {
        return anyo;
    }

    public void setAnyo(Integer anyo) {
        this.anyo = anyo;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getPais() {
        return pais;
    }

    public void setPais(String pais) {
        this.pais = pais;
    }

    public List<String> getGenero() {
        return genero;
    }

    public void setGenero(List<String> genero) {
        this.genero = genero;
    }

    public Integer getDuracionMinutos() {
        return duracionMinutos;
    }

    public void setDuracionMinutos(Integer duracionMinutos) {
        this.duracionMinutos = duracionMinutos;
    }

    public String getClasificacion() {
        return clasificacion;
    }

    public void setClasificacion(String clasificacion) {
        this.clasificacion = clasificacion;
    }

    public List<String> getActoresPrincipales() {
        return actoresPrincipales;
    }

    public void setActoresPrincipales(List<String> actoresPrincipales) {
        this.actoresPrincipales = actoresPrincipales;
    }

    public Double getPuntuacionImdb() {
        return puntuacionImdb;
    }

    public void setPuntuacionImdb(Double puntuacionImdb) {
        this.puntuacionImdb = puntuacionImdb;
    }

    public Double getTaquillaGlobalMillones() {
        return taquillaGlobalMillones;
    }

    public void setTaquillaGlobalMillones(Double taquillaGlobalMillones) {
        this.taquillaGlobalMillones = taquillaGlobalMillones;
    }

    public Integer getOscars() {
        return oscars;
    }

    public void setOscars(Integer oscars) {
        this.oscars = oscars;
    }

    public Integer getPremiosGoya() {
        return premiosGoya;
    }

    public void setPremiosGoya(Integer premiosGoya) {
        this.premiosGoya = premiosGoya;
    }
}
```



### Configuración Opcional en application.properties

```properties
springdoc.api-docs.path=/api-docs
springdoc.swagger-ui.path=/swagger-ui.html
springdoc.swagger-ui.operationsSorter=method
springdoc.swagger-ui.tagsSorter=alpha
springdoc.swagger-ui.tryItOutEnabled=true
```

No es necesaria.



### Acceso con el interfaz Web

Por defecto podemos acceder a la aplicación desde esta url: http://localhost:8080/swagger-ui/index.html

![SpringIA_conf_proyect](./img/OpenAPI.png)

El proyecto final lo podemos encontrar [aqui](SpringMongoDB.zip)

