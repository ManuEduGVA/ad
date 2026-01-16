
## 1. HATEOAS

**Hateoas** (_Hypermedia as the engine of application state_) es un principio de API RESTful definido por [Roy Fielding](https://en.wikipedia.org/wiki/Roy_Fielding). Principalmente significa que el cliente puede moverse por toda la aplicación sólo desde URI's generales en formato hipermedia. El principio implica que la API debe guiar al cliente a través de la aplicación devolviendo información relevante sobre los siguientes pasos potenciales, junto con cada respuesta.

Para la conexión entre el servidor y el cliente, Fielding define estas cuatro características:

- **Identificación única de todos los recursos**: todos los recursos deben poder ser identificados con un URI (Identificador de Recurso Único).
- **Interacción con recursos a través de representaciones**: Si un cliente necesita un recurso, el servidor le envía una representación (por ejemplo, HTML, JSON o XML) para que el cliente pueda modificar o eliminar el recurso original.
- **Mensajes explícitos**: cada mensaje intercambiado entre el servidor y el cliente debe contener todos los datos necesarios para entenderse mutuamente.
- **HATEOAS**: Este principio también integra una API REST. Esta estructura basada en hipermedia facilita a los clientes el acceso a la aplicación, ya que no necesitan conocer nada más sobre la interfaz para poder acceder y navegar por ella.

HATEOAS es, en resumidas cuentas, una de las propiedades más básicas de las API REST y, como tal, esencial en cualquier servicio REST.

Un valor devuelto sin HATEOAS, con datos de un cliente:

```json
{
    "idCliente": 3,
    "nif": "33333333C",
    "nombre": "Vicente",
    "apellidos": "Mondragón",
    "claveSeguridad": "1234",
    "email": "vicente.mondragon@tia.es",
    "recomendacion": {
      "idRecomendacion": 3,
      "observaciones": "Realiza muchos pedidos"
    },
    "listaCuentas": [
      {
        "idCuenta": 8,
        "banco": "1001",
        "sucursal": "1001",
        "dc": "11",
        "numeroCuenta": "1000000008",
        "saldoActual": 7500.0,
        "links": [
          
        ]
      },
      {
        "idCuenta": 10,
        "banco": "1001",
        "sucursal": "1001",
        "dc": "11",
        "numeroCuenta": "1000000010",
        "saldoActual": -3500.0,
        "links": [
          
        ]
      }
    ],
    "listaDirecciones": [
      {
        "idDireccion": 5,
        "descripcion": "calle de la creu, 2",
        "pais": "España",
        "cp": "46701"
      }
    ]
  }
```

Ten en cuenta que:

- Hemos obtenido todos los datos del cliente
- No sabemos cómo obtener datos de campos relacionados específicos, como `Direccion` o `Cuenta`. Están ahí pero no sabemos cómo obtenerlas

La misma solicitud con HATEOAS:

```json
{
  "idCliente": 3,
  "nif": "33333333C",
  "nombre": "Vicente",
  "apellidos": "Mondragón",
  "claveSeguridad": "1234",
  "email": "vicente.mondragon@tia.es",
  "links": [
    {
      "rel": "self",
      "href": "http://localhost:9090/clientes/3"
    },
    {
      "rel": "listaDirecciones",
      "href": "http://localhost:9090/clientes/3/direcciones"
    },
    {
      "rel": "listaCuentas",
      "href": "http://localhost:9090/clientes/3/cuentas"
    }
  ]
}
```

Cómo puedes ver:

- Sólo se envían los datos de un cliente
- Tenemos enlaces, con URI's claras para obtener información específica de este cliente

y lo más importante **Si el servidor cambia su estructura, enviará enlaces actualizados, y el cliente funcionará sin ningún problema**


## 2. Añadiendo HATEOAS

### 2.1. Librerías

!!! nota "Atención" 
    En este texto, añadiremos capacidades HATEOAS a una API RESTful desarrollada a lo largo de la unidad.

Sólo necesitamos añadir esta dependencia a nuestro `pom.xml`, suponiendo que hemos utilizado un proyecto iniciador de Spring:

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-hateoas</artifactId>
</dependency>
```

y ya está.

### 2.2. Wrappers (Envoltorios)

#### 2.2.1. Punto de inicio

Recuerda lo que hemos hecho en nuestro proyecto inicial:

- **Clases Modelo o DAO** → preparadas para guardar información en la base de datos. Están anotadas con Hibernate y son la base de nuestros repositorios. Por ejemplo, `Cliente`.
- **Clases DTO** preparadas para transferir datos desde nuestro modelo y hacia éste. 
- Estas clases encapsulan las DAO (añadiendo o eliminando campos). 
- Estas clases tienen métodos para convertir entre DAO y DTO. 
- Es el servicio quien realiza la conversión. 
- El cliente nos enviará información en estas clases DTO. 
- Estas clases pueden ser utilizadas tanto por una API Rest como por una aplicación web MVC.


Es necesario adaptar el DTO, **ClienteDTO**, a HATEOAS. Para ello lo envolveremos con RepresentationalModel:

```java
package com.manu.dto;

import com.manu.model.Cliente;
import com.manu.model.Cuenta;
import com.manu.model.Direccion;
import com.manu.model.Recomendacion;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.hateoas.RepresentationModel;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ClienteDTO extends RepresentationModel<ClienteDTO> {

    private Integer idCliente;

    private String nif;
    private String nombre;
    private String apellidos;
    private String claveSeguridad;
    private String email;
    private Recomendacion recomendacion;
    private List<Cuenta> listaCuentas;
    private List<Direccion> direcciones;

    public static ClienteDTO convertToDTO(Cliente cliente) {
        ClienteDTO clienteDTO = new ClienteDTO();
        clienteDTO.setIdCliente(cliente.getId());
        clienteDTO.setNif(cliente.getNif());
        clienteDTO.setNombre(cliente.getNombre());
        clienteDTO.setApellidos(cliente.getApellidos());
        clienteDTO.setClaveSeguridad(cliente.getClaveSeguridad());
        clienteDTO.setEmail(cliente.getEmail());
        clienteDTO.setRecomendacion(cliente.getRecomendacion());
        clienteDTO.setListaCuentas(cliente.getListaCuentas());
        clienteDTO.setDirecciones(cliente.getListaDirecciones());
        return clienteDTO;
    }

    public static Cliente convertToEntity(ClienteDTO clientedto) {
        Cliente cliente = new Cliente();
        cliente.setId(clientedto.getIdCliente());
        cliente.setNif(clientedto.getNif());
        cliente.setNombre(clientedto.getNombre());
        cliente.setApellidos(clientedto.getApellidos());
        cliente.setClaveSeguridad(clientedto.getClaveSeguridad());
        cliente.setEmail(clientedto.getEmail());
        cliente.setRecomendacion(clientedto.getRecomendacion());
        cliente.setListaCuentas(clientedto.getListaCuentas());
        cliente.setRecomendacion(clientedto.getRecomendacion());
        return cliente;
    }
}

```


#### 2.2.2. Envoltorio HATEOAS

Necesitamos definir una nueva clase para envolver nuestra respuesta HATEOAS.

Partiendo de los DTO's, contiene toda la información de una clase, propia y relacionada (Cliente más Dirección más Cuentas). Con HATEOAS, como hemos mostrado recientemente, sólo necesitamos la información propia del Cliente y necesitamos generar enlaces a entidades relacionadas. Entonces, necesitamos añadir a la información del cliente la capacidad de generar y almacenar enlaces. La clase que lo permite es `RepresentationModel<base_class>` (documentación completa [aquí](https://docs.spring.io/spring-hateoas/docs/current/api/org/springframework/hateoas/RepresentationModel.html)). Esto añadirá a nuestras clases:

- Una estructura para guadar links
- Métodos para añadir, comprobar y devolver links

Para hacerlo

```java
package com.manu.hateoas;

import com.manu.dto.ClienteDTO;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.hateoas.RepresentationModel;

import java.io.Serializable;

@Data
@AllArgsConstructor
public class ClienteHATEOAS extends RepresentationModel<ClienteDTO> implements Serializable {

    private static final long serialVersionUID = 1L;
    private Integer idCliente;
    private String nif;
    private String nombre;
    private String apellidos;
    private String claveSeguridad;
    private String email;

    public static ClienteHATEOAS fromClienteDTO2HATEOAS(ClienteDTO clienteDTO) {
        return new ClienteHATEOAS(
                clienteDTO.getIdCliente(),
                clienteDTO.getNif(),
                clienteDTO.getNombre(),
                clienteDTO.getApellidos(),
                clienteDTO.getClaveSeguridad(),
                clienteDTO.getEmail());
    }
}

```

!!! important "Importante" 
    - Al tener una API base que funciona con `ClienteDTO`, hemos creado esta clase envoltorio a partir de ella. 
    - Dado que HATEOAS es sólo un formato de respuesta, puedes crearlo a partir de `Cliente` como clase base, pero debes definir tu servicio para devolver `Cliente` también. 
    - Es muy importante crear un método de conversión `fromClienteDTO2HATEOAS`, que incluya los campos necesarios.

Entonces, utilizaremos el método `add(Link)` en nuestro envoltorio `ClienteHATEOAS` para añadir tantos `Link` como sea necesario.

```java
import org.springframework.hateoas.Link;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

Link self=linkTo(methodOn(controller_class.class)
    		.methodName(args))
    		.withSelfRel(); // or .withRel(String Link)
```

- `linkTo` → método estático que crea un `Link` desde
- `methodOn(class)` → busca en una clase de controlador un método
- `.methodName(args)` → obtiene una _llamada real_ para este método
- Y para etiquetar el enlace:
  - `.withSelfRel()` → crea un enlace llamado `self`
  - `.withRel(String Link)` → crea un vínculo con el nombre dado.

Ejemplos de nuestro `Cliente controller` en la siguiente sección


### 3.1. Self links

```java

ClienteDTO clienteDTO = clienteService.getClienteById(idCliente);
if (clienteDTO == null) {
        return ResponseEntity.notFound().build();
    }

// Convertimos DTO a modelo HATEOAS
ClienteHATEOAS clienteHATEOAS = ClienteHATEOAS.fromClienteDTO2HATEOAS(clienteDTO);

// Añadimos enlaces HATEOAS
clienteHATEOAS.add(
        linkTo(methodOn(ClienteController.class).showClienteById(idCliente))
                .withSelfRel()
```

Este ejemplo:

- Carga un `ClienteDTO` del `ClienteService` actual.
- Luego busca en la clase `ClienteController` un método llamado `showClienteById`.
- Hace una llamada interna y busca el camino y vincula el argumento al camino (¿recuerdas `@PathVariable`?)
- Por último, obtiene el camino (ruta) completo con el argumento y lo almacena en el Link con la referencia `self`

El resultado será algo así:

```json
{
  "rel": "self",
  "href": "http://localhost:9090/clientes/3"
}
```

### 3.2. Referenciando links

```java
clienteHATEOAS.add(
        linkTo(methodOn(CuentaController.class).listCuentasCliente(idCliente))
                  .withRel("listaCuentas")
    );

```

Este ejemplo:

- Carga un `ClienteDTO` del `ClienteService` actual.
- Luego busca en la clase `CuentaController` un método llamado `listCuentasCliente`.
- Hace una llamada interna y busca el camino y vincula el argumento al camino (¿recuerdas `@PathVariable`?)
- Por último, obtiene el camino (ruta) completo con el argumento y lo almacena en el Link con la referencia `listaCuentas` pasada como parámetro a `withRel`

El resultado será algo así:
```json
{
  "rel": "listaCuentas",
  "href": "http://localhost:9090/clientes/3/cuentas"
}
```

### 3.3. Añadiendo enlaces a nuestro envoltorio y ejemplo completo

Una vez hemos visto como construir los enlaces con HATEOAS veamos el método completo:

El método del controlador para obtener un `Cliente` será:

```java
@GetMapping("/clientes/{idCliente}")
    public ResponseEntity<ClienteHATEOAS> showClienteById(@PathVariable Integer idCliente) {

        ClienteDTO clienteDTO = clienteService.getClienteById(idCliente);
        if (clienteDTO == null) {
            return ResponseEntity.notFound().build();
        }

        // Convertimos DTO a modelo HATEOAS
        ClienteHATEOAS clienteHATEOAS = ClienteHATEOAS.fromClienteDTO2HATEOAS(clienteDTO);

        // Añadimos enlaces HATEOAS
        clienteHATEOAS.add(
                linkTo(methodOn(ClienteController.class).showClienteById(idCliente))
                        .withSelfRel()
        );
        clienteHATEOAS.add(
                linkTo(methodOn(DireccionController.class).listDireccionesCliente(idCliente))
                        .withRel("listaDirecciones")
        );
        clienteHATEOAS.add(
                linkTo(methodOn(CuentaController.class).listCuentasCliente(idCliente))
                        .withRel("listaCuentas")
        );

        return ResponseEntity.ok(clienteHATEOAS);
    }
```

y el resultado será algo así:

```json
{
  "idCliente": 3,
  "nif": "33333333C",
  "nombre": "Vicente",
  "apellidos": "Mondragón",
  "claveSeguridad": "1234",
  "email": "vicente.mondragon@tia.es",
  "links": [
    {
      "rel": "self",
      "href": "http://localhost:9090/clientes/3"
    },
    {
      "rel": "listaDirecciones",
      "href": "http://localhost:9090/clientes/3/direcciones"
    },
    {
      "rel": "listaCuentas",
      "href": "http://localhost:9090/clientes/3/cuentas"
    }
  ]
}
```

Esto nos dará las URL's que nos permitirán acceder a las direcciones del cliente 3 y las cuentas del cliente 3 ... pero ... ¿Sólo con lo que tenemos será suficiente?

Parece evidente que cuando invoquemos estos otros métodos deberemos tener desarrollados los controladores de direcciones y cuentas para que respondan a estos.

Veamos el ejemplo de cuentas.

En el interfaz`CuentaService` añadiomos un método a implementar que recibirán un id de cliente.

```java
 List<CuentaDTO> listCuentasCliente (Integer idCliente);
```

El interfaz quedará así:

```java
package com.manu.service;

import com.manu.dto.CuentaDTO;

import java.util.List;

public interface CuentaService {
    CuentaDTO saveCuenta(CuentaDTO cuentaDTO);
    CuentaDTO getCuentaById(Long id);
    List<CuentaDTO> listAllCuentas();
    List<CuentaDTO> listCuentasCliente (Integer idCliente);
    void deleteCuenta(Long id);
}
```

La implementación en la clase `CuentaServiceImpl` :

```java

    @Override
    public List<CuentaDTO> listCuentasCliente(Integer idCliente) {
        // Buuscamos el cliente con el método de clienteRepository
        Cliente cliente = clienteRepository.findById(Long.valueOf(idCliente))
                .orElse(null);

        if (cliente == null) {
            // El cliente no existe -> el controller ya traduce null a 404
            return null;
        }

        // Obtenermos su lista de direcciones
        if (cliente.getListaCuentas() == null || cliente.getListaCuentas().isEmpty()) {
            // Cliente existe pero no tiene direcciones
            return new ArrayList<>();
        }

        // Convertimos su lista de direcciones en un objetoDireccionDTO
        return cliente.getListaCuentas()
                .stream()
                .map(CuentaDTO::convertToDTO)
                .toList();
    }

```

Podemos observar en este método que disponemos de `clienteRepository`. Esta variable la hemos injectado con `@Autowired` en la clase, de tal manera que podemos acceder a los métodos de ClienteRepository.

Aquí podemos ver la implementación completa de este servicio:

```java
package com.manu.service;

import com.manu.dto.CuentaDTO;
import com.manu.model.Cliente;
import com.manu.model.Cuenta;
import com.manu.repository.ClienteRepository;
import com.manu.repository.CuentaRespository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class CuentaServiceImpl implements CuentaService{

    @Autowired
    private CuentaRespository cuentaRespository;

    @Autowired
    private ClienteRepository clienteRepository;


    @Override
    public CuentaDTO saveCuenta(CuentaDTO cuentaDTO) {
        Cuenta cuenta = CuentaDTO.convertToEntity(cuentaDTO);
        cuentaRespository.save(cuenta);
        return cuentaDTO;
    }

    @Override
    public CuentaDTO getCuentaById(Long id) {
        Optional<Cuenta> cuenta = cuentaRespository.findById(id);
        return cuenta.map(CuentaDTO::convertToDTO).orElse(null);
    }

    @Override
    public List<CuentaDTO> listAllCuentas() {
        List<Cuenta> lista = cuentaRespository.findAll();
        List<CuentaDTO> listaResultado = new ArrayList<CuentaDTO>();
        for (int i = 0; i < lista.size(); ++i) {
            listaResultado.add(CuentaDTO.convertToDTO(lista.get(i)));
        }
        return listaResultado;
    }

    @Override
    public List<CuentaDTO> listCuentasCliente(Integer idCliente) {
        // Buuscamos el cliente con el método de clienteRepository
        Cliente cliente = clienteRepository.findById(Long.valueOf(idCliente))
                .orElse(null);

        if (cliente == null) {
            // El cliente no existe -> el controller ya traduce null a 404
            return null;
        }

        // Obtenermos su lista de direcciones
        if (cliente.getListaCuentas() == null || cliente.getListaCuentas().isEmpty()) {
            // Cliente existe pero no tiene direcciones
            return new ArrayList<>();
        }

        // Convertimos su lista de direcciones en un objetoDireccionDTO
        return cliente.getListaCuentas()
                .stream()
                .map(CuentaDTO::convertToDTO)
                .toList();
    }

    @Override
    public void deleteCuenta(Long id) {
        cuentaRespository.deleteById(id);
    }
}

```
## 4. Trabajo pendiente

Ahora, haciendo una petición simple a un `Cliente` tenemos acceso a toda la información y siguientes acciones disponibles en los datos de la respuesta

Esto permite al servidor poder evolucionar sin tener que modificar los clientes que le hacen peticiones, ya que cualquier modificación será inmediatamente notificada a los usuarios de las API en las propias respuestas.

Ahora te toca a ti completar el proyecto desarrollado añadiendo las clases necesarias y añadiendo el HATEOAS en estos modelos. Si estás inmerso en un proyecto, es adecuado que lo adaptaras a HATEOAS.

Completa con direcciones y recomendaciones.
