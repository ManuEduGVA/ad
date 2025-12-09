## 1. HTTPS

Hoy en día, necesitamos añadir todo lo que podamos para asegurar nuestras aplicaciones. Estudiaremos el concepto de **tokens** para autorizar y autenticar nuestras solicitudes, pero necesitamos una capa extra, **https**.

En esta página web <https://tiptopsecurity.com/how-does-https-work-rsa-encryption-explained/> puede encontrar cómo funciona https.

### 1.1. Certificado

En primer lugar, necesitamos generar certificados, o comprarlos. Utilizaremos la herramienta `keytool` incluida con el kit de desarrollo de Java para generarlos. Este comando genera un par de certificados (público y privado).

```sh
keytool -genkeypair -alias manu -keyalg RSA -keysize 2048 -storetype PKCS12 -keystore manuro.p12 -validity 3650
```

Después de ejecutar este comando, debemos responder sobre quiénes somos, de la siguiente manera:

![keytool](./img/keytool.png){width=95%}


### 1.2. Configurar Spring

Una vez finalizado el proceso, debemos añadir el certificado dentro de nuestro proyecto. Por ejemplo, dentro de `/resources/keystore`. Por último, debemos cargar el certificado y habilitar SSL, simplemente añadiendo estas líneas a `application.properties`:

```sh
spring.application.name=HTTPS
server.port=9091
# The formato used for the keystore.
server.ssl.key-store-type=PKCS12
# The path to the keystore containing the certificate
server.ssl.key-store=classpath:keystore/manuro.p12
# The password used to generate the certificate
server.ssl.key-store-password=manuca
# The alias mapped to the certificate
server.ssl.key-alias=manu
# Use HTTPS instead of HTTP
server.ssl.enabled=true
```

![HTTPS_Spring_Project](./img/HTTPS_Spring_Project.png){width=95%}


Y esto es todo, cuando Spring comience veremos que está funcionando con el protocolo `https`:

```sh
2025-12-04T17:09:56.856+01:00  INFO 21868 --- [HTTPS] [  restartedMain] o.s.boot.tomcat.TomcatWebServer          : Tomcat initialized with port 9091 (https)
```

![HTTPS_Working](./img/HTTPS_Working.png){width=100%}

y en la solicitud probablemente los navegadores no confiarán en nuestro certificado (deberemos añadir una excepción de confianza):

![Certificate](./img/Certificate.png){width=95%}

## 2. Spring Security

Spring Security es un proyecto paraguas que agrupa a todos los mecanismos referentes a la seguridad. Necesitamos añadir:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

y automáticamente:

- La configuración por defecto está habilitada, a través de un filtro, llamado `SpringSecurityFilterChain`.
- Se crea un bean tipo `UserDetailsService` con un usuario llamado `user` y una contraseña aleatoria que se muestra por la consola.
- El filtro se registra en el contenedor de servlets para todas las solicitudes.

Aunque no has configurado demasiado, tiene muchas consecuencias:

- Requiere autenticación para interactuar con nuestra aplicación
- Genera un formulario de login por defecto.
- Genera un mecanismo de logout
- Protege el almacenamiento de contraseñas con `BCrypt`.
- Proporciona protección contra ataques CSRF, Fijación de Sesión, Clickjacking...

![login](./img/webSegura.png){width=95%}

![Password](./img/Password.png){width=95%}



Podemos crear el paquete security y dentro del mismo podemos crear una clase de configuración, con este contenido:

```java
package org.cipfpcheste.dam2.https.security;

import org.springframework.context.annotation.Configuration;

@Configuration
public class SecurityConfig {

}
```

!!! note "Atención" 
	Volveremos a esta clase para añadir más configuraciones. Lo más interesante es el método `configure` y la creación de varios beans utilizados por otras clases.


### 2.1. Datos de Usuarios para Autenticación y Autorización (Modelos)

!!! importante "Importante" 

​	A partir de ahora, este ejemplo se basa en una página web famosa <https://www.bezkoder.com>. Explicamos todo lo necesario del ejemplo que puede ver [aquí](https://www.bezkoder.com/spring-boot-jwt-authentication/).

​	En esta sección prepararemos nuestra aplicación para identificar a usuarios con diversos roles. Con estos roles, podremos conceder o no acceso a varios recursos.

### 2.2. Usuarios & Roles

Para ello necesitamos crear una clase `User`, para almacenar esta información en nuestra base de datos. Este usuario podría tener una colección de _rols_. Podemos hacerlo con una relación de muchos a muchos.

```java
public enum ERole { 
ROLE_USER, 
ROLE_MODERATOR, 
ROLE_ADMIN
}
```

basado en esta enumeración, haremos una clase `Role` para almacenar los roles que nuestra aplicación soportará:

```java
package org.cipfpcheste.dam2.https.models;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "roles")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private ERole name;
}
```

por último, una clase `User` como la siguiente. Añadimos nuevas anotaciones de validación:

```java
package org.cipfpcheste.dam2.https.models;

import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;


@Entity
@Table(name = "users",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = "username"),
                @UniqueConstraint(columnNames = "email")
        })
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(max = 20)
    private String username;

    @NotBlank
    @Size(max = 50)
    @Email
    private String email;

    @NotBlank
    @Size(max = 120)
    private String password;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable( name = "user_roles",joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "role_id"))
    private Set<Role> roles = new HashSet<>();

    public User() {
    }

    public User(String username, String email, String password) {
        this.username = username;
        this.email = email;
        this.password = password;
    }

}
```

### 2.3. Repositorio de Usuarios y Roles

Necesitamos crear nuestros repositorios para las últimas entidades, creando interfaces como normalmente hacemos.


```java
package org.cipfpcheste.dam2.https.repository;

import org.cipfpcheste.dam2.https.models.ERole;
import org.cipfpcheste.dam2.https.models.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByName(ERole name);
}
```

```java

package org.cipfpcheste.dam2.https.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import org.cipfpcheste.dam2.https.models.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);

    Boolean existsByUsername(String username);

    Boolean existsByEmail(String email);
}
```

También añadimos métodos para comprobar la existencia del usuario por nombre y correo electrónico, y métodos para encontrar por nombre, tanto `User` como `Role`.

### 2.4. UserDetails

Spring necesita que alguien implemente la interfaz `UserDetails`, muy importante porque Spring Security utilizará un `UserDetails`. `UserDetails` contiene la información necesaria para construir un objeto `Authentication` a partir de DAOs u otras fuentes de datos de seguridad. Creamos una clase, llamada `UserDetailsImpl`, que:

- Debe tener los campos `username` y `password`, y los getters. Debe respetar los nombres, cualquier cambio está prohibido. Estos métodos serán utilizados por las clases de autenticación.
- Sobreescribir métodos de `UserDetails`, por ejemplo `getAuthorities()` y varios métodos para controlar si el usuario está bloqueado, caducado, etc.

Clase completa:

```java
package org.cipfpcheste.dam2.https.services;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.cipfpcheste.dam2.https.models.User;
import org.jspecify.annotations.Nullable;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serial;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

public class UserDetailsImpl implements UserDetails {
    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private String username;
    private String email;

    @JsonIgnore
    private String password;

    private Collection<? extends GrantedAuthority> authorities;

    public UserDetailsImpl(Long id, String username, String email, String password,
                           Collection<? extends GrantedAuthority> authorities) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.authorities = authorities;
    }

    public static UserDetailsImpl build(User user) {
        List<GrantedAuthority> authorities = user.getRoles().stream()
                .map(role -> new SimpleGrantedAuthority(role.getName().name()))
                .collect(Collectors.toList());

        return new UserDetailsImpl(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getPassword(),
                authorities);
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public @Nullable String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }


    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

}
```

Ten en cuenta que:

- ¿Utilizamos `private Collection<? extends GrantedAuthority> authorities;` para almacenar las autoridades (es decir, roles) en un formato que es entendido por Spring Security.
- En lugar de crear un constructor, creamos un `builder()`, que recibe un `User`, extrae la información de éste y transforma la `List<Role>` en autoridades, y después, el builder llama al constructor.

En lugar de crear un `User` y `Role` `Service`, crearemos un `UserDetailSeriveImpl` (que implementa `UserDetailService` de Spring), para recuperar un `User` del repositorio, y después devuelve un `UserDetailImpl`, de la siguiente manera:

```java
package org.cipfpcheste.dam2.https.services;

import org.cipfpcheste.dam2.https.models.User;
import org.cipfpcheste.dam2.https.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    @Autowired
    UserRepository userRepository;

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User Not Found with username: " + username));

        return UserDetailsImpl.build(user);
    }

}

```

### 2.5. Cargas de DTO's

En esta sección veremos las clases necesarias que almacenan información para:

- Registrar a un nuevo usuario, para recibir información del cliente y almacenar un nuevo usuario. Esta clase es `SignupRequest`.
- Iniciar sesión de un usuario, para acceder a nuestro sistema. Esta clase es `LoginRequest`. 
- `JwtResponse`, relacionada como respuesta a la solicitud de inicio de sesión. Esta respuesta contendrá un **Token JWT**, utilizado para autorizar solicitudes posteriores. Esta clase es `JwtResponse`.

### 2.6. SignupRequest

Esta clase contiene información para registrar a un nuevo usuario. Contiene anotaciones de validación.

```java
package org.cipfpcheste.dam2.https.payload.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.Set;

@Data
public class SignupRequest {
    @NotBlank
    @Size(min = 3, max = 20)
    private String username;

    @NotBlank
    @Size(max = 50)
    @Email
    private String email;

    private Set<String> role;

    @NotBlank
    @Size(min = 6, max = 40)
    private String password;
}
```
Para enviar esta información, el objeto json recibido será similar a:

```json
{ 
"username":"manuro", 
"email":"jm.romeromartinez@edu.gva.es", 
"password":"123456", 
"role":["admin","user"]
}
```

### 2.7. LoginRequest

Muy sencilla:

```java
package org.cipfpcheste.dam2.https.payload.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginRequest {
    @NotBlank
    private String username;

    @NotBlank
    private String password;
}
```

y el objeto json asociado será:

```json
{ 
"username":"manuro", 
"password":"123456"
}
```

!!! note "Atención" 

    En esta clase podemos marcar los campos como obligatorios, con la anotación `@NotBlank` de `javax.validation.constraints.NotBlank`. Tienes que añadir: 
```xml 
<dependency> 
<groupId>org.springframework.boot</groupId> 
<artifactId>spring-boot-starter-validation</artifactId> 
</dependency> 
```


### 2.8. JwtResponse

Esta clase DTO es la clase que se devuelve como solicitud de _login_. Debe contener poca información sobre nuestro usuario y lo más importante, un token JWT. Este token se utilizará para autorizarnos, como estudiaremos en la siguiente sección.

```java
package org.cipfpcheste.dam2.https.payload.response;

import lombok.Data;

import java.util.List;

@Data
public class JwtResponse {
    private String token;
    private String type = "Bearer";
    private Long id;
    private String username;
    private String email;
    private List<String> roles;
}
```

Ten en cuenta que:

- Los campos de esta clase se poblarán a partir de la clase `User`, como un DTO.
- Hemos cambiado el formato del rol, de la clase `Role` a `String`, con una mejor gestión en los clientes.
- El `String token` es donde se almacena el token JWT. De hecho, un token es una cadena de texto, como mostraremos ahora.


## 3. Tokens JWT

### 3.1. ¿Qué es un token?

JSON Web Tokens (JWT) se han introducido como un método de securizar la comunicación segura entre dos partes. Se introdujo con la especificación RFC 7519 por el Internet Engineering Task Force (IETF).
Aunque podemos utilizar `JWT` con cualquier tipo de método de comunicación, hoy en día, JWT es muy popular para gestionar la autenticación y la autorización sobre HTTP.

Primero, necesitarás conocer algunas características de HTTP:

- HTTP es un protocolo _sin estado_, lo que significa que una solicitud HTTP no mantiene el estado. El servidor no es consciente de ninguna solicitud anterior enviada por el propio cliente.
- Las solicitudes HTTP deberían ser _autónomas_. Deben incluir información sobre solicitudes anteriores que el usuario ha realizado en la misma solicitud.

Hay algunas formas de hacer esto, pero la manera más popular es establecer un **session_id**, que es una referencia a la información del usuario:

- El servidor almacenará este ID de sesión en memoria o en una base de datos. El cliente enviará cada solicitud con ese ID de sesión.
- El servidor puede obtener información sobre el cliente utilizando esta referencia.
- Normalmente, este ID de sesión se envía al usuario como una **cookie**.

Aquí tienes el diagrama de cómo funciona la autenticación basada en sesiones.

![authentication-and-authorization-in-expressjs-using-jwt-1](./img/authentication-and-authorization-in-expressjs-using-jwt-1.png){width=95%}

Por otra parte, con JWT, cuando el cliente envía una solicitud de autenticación al servidor, éste enviará un **token** JSON al cliente, que incluye toda la información sobre el usuario junto con la respuesta.

El cliente enviará este token con **todas** las solicitudes posteriores. Por tanto, el servidor no deberá almacenar ninguna información sobre la sesión. Pero existe un problema con este enfoque. Cualquiera puede enviar una solicitud falsa con un token JSON falso y hacerse pasar por alguien que no es.

Por ejemplo, supongamos que después de la autenticación, el servidor devuelve un objeto JSON al cliente con el nombre de usuario y el tiempo de expiración. Así, dado que el objeto JSON es legible, cualquiera puede editar esta información y enviar una solicitud con ella. El problema es que no hay forma de validar esta solicitud.

Aquí es donde entra en juego la **firma testigo**. Así que en lugar de enviar sólo un token JSON normal, el servidor enviará un token firmado, que puede verificar que la información no ha cambiado.

![authentication-and-authorization-in-expressjs-using-jwt-2](./img/authentication-and-authorization-in-expressjs-using-jwt-2.png){width=95%}


### 3.2. Estructura de un JWT

Hablamos de la estructura de un JWT a través de un token de ejemplo:

```json
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ikpv aG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

Como puede ver, hay tres secciones en este JWT, cada una separada por un punto.

!!! note "Nota" 

La codificación `Base64` es una manera de asegurar que los datos no se corrompan, ya que no comprimen ni cifran los datos, sino que simplemente los codifican de forma que la mayoría de los sistemas pueden entender. Puede leer cualquier text codificado en Base64 simplemente descodificándolo.

La primera sección del JWT es un header, que es una cadena codificada en Base64. Si descodifica el header, se vería así:

```json
{ 
"alg":"HS512", 
"typ":"JWT"
}
```

La sección del header contiene el algoritmo de hash, que se utilizó para generar la firma del token y el tipo.

La segunda sección es el **payload** que contiene el objeto JSON que se envió de vuelta al usuario. Puesto que sólo está codificado en Base64, cualquiera puede descodificarlo fácilmente. Es obligatorio no incluir datos sensibles en los JWT, tales como contraseñas o información personal identificable.

Normalmente, el cuerpo del JWT se verá así, aunque no necesariamente se aplica:

```json
{ 
"sub": "1234567890", 
"name": "John Doe", 
"iat": 1516239022
}
```

!!! note "Nota" 
La mayoría de las veces, la propiedad `sub` contendrá el ID del usuario, la propiedad `iat` (_issued at_), abreviada como `emitido a`, es el sello de tiempo de emisión del token. También puede ver algunas propiedades comunes, como `eat` o `exp`, que es el tiempo de expiración del token. 

Todas estas propiedades son los claims del token, la información.

La sección final es la firma del token. Ésta se genera haciendo un hash de la cadena creada con las dos secciones anteriores y una contraseña secreta, utilizando el algoritmo mencionado en la sección del header.

Puede visitar <https://www.javainuse.com/jwtgenerator> y <https://jwt.io> para generar tokens y probar con varios datos, secretos y hashes.

![authentication-and-authorization-in-expressjs-using-jwt-3](./img/authentication-and-authorization-in-expressjs-using-jwt-3.png){width=95%}



### 3.3. JWT Library class

Añadiremos al `pom.xml` las siguientes dependencias:

```xml
 <!-- https://mvnrepository.com/artifact/io.jsonwebtoken/jjwt-api -->
<dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt-api</artifactId>
        <version>0.13.0</version>
</dependency>
<!-- https://mvnrepository.com/artifact/io.jsonwebtoken/jjwt-impl -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.13.0</version>
    <scope>runtime</scope>
</dependency>
<!-- https://mvnrepository.com/artifact/io.jsonwebtoken/jjwt-jackson -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.13.0</version>
    <scope>runtime</scope>
</dependency>
```

Esta clase es la que genera y comprueba la integridad de los tokens. Vamos a mostrar esa clase y qué elementos necesita. Esta clase será una clase de biblioteca con métodos para crear tokens, validarlos y extraer información de ellos. Podemos encontrar esta clase con nombres como `JWTUtils` o `JWTTokenProvider`. El esqueleto de esta clase es el siguiente:

- Carga o definición de constantes del token
- Método para generar JWT a partir de un objeto `Authentication`
- Métodos para obtener información del token
- Método para validar el token (firma)

La carga de constantes es así:

```java
package org.cipfpcheste.dam2.https.security.jwt;

import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.cipfpcheste.dam2.https.services.UserDetailsImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;

@Component
public class JWTUtils {


    private static final Logger logger = LoggerFactory.getLogger(JWTUtils.class);

    // Vamos a obtener del fichero application.properties una codificación en base64 para la generación de los tokens
    // en la aplicación la he generado en linux con el comando openssl rand -base64 64 para que me genere la cadena en base 64
    
    @Value("${app.jwtSecret}")
    private String jwtSecret;
    
    // Se guarda el tiempo de expiración del token. Lo podemos variar a conveniencia. Al igual que el anterior, del application.properties
    @Value("${app.jwtExpirationMs}")
    private int jwtExpirationMs;

```

Estas son los métodos que implementamos:

```java
/** Clave única y coherente para firmar y validar */
    private SecretKey key() {
     
    }

    public String generateJwtToken(Authentication authentication) {
        
    }

    public String getUserNameFromJwtToken(String token) {
        
    }

    public boolean validateJwtToken(String authToken) {
       
    }
```

### 3.4. Generar Tokens

Veamos cada método. Primero, necesitamos un objeto `Authentication`. Debemos saber que este objeto representa otro token (no nuestro JWT) con las credenciales del objeto que queremos identificar.

Antes de generar o validar un token, necesitaremos una clave válida para lo dicho, firmar o validar y lo haremos así:

```java
/** Clave única y coherente para firmar y validar */
    private SecretKey key() {
        // jwtSecret se asume codificado en Base64 (como en application.properties)
        byte[] keyBytes = Decoders.BASE64.decode(jwtSecret);
        return Keys.hmacShaKeyFor(keyBytes);
    }

```
Y genero el token:

```java
public String generateJwtToken(Authentication authentication) {
    UserDetailsImpl userPrincipal = (UserDetailsImpl) authentication.getPrincipal();

    Date now = new Date();
    Date expiryDate = new Date(now.getTime() + jwtExpirationMs);

    return Jwts.builder()
            .subject(userPrincipal.getUsername())
            .issuedAt(now)
            .expiration(expiryDate)
            .signWith(key(), Jwts.SIG.HS512)
            .compact();
}
```

Vemos que:

- Recibimos un objeto `Authentication`, en el que hemos guardado un `UserDetailsImpl`. Como todas las implementaciones de detalles de usuario, podemos obtener el nombre de usuario, y lo utilizamos para establecer el sujeto del token.
- Establecemos `IAT` en el momento actual.
- Establecemos el tiempo de expiración.
- Establecemos el algoritmo de cifrado y la palabra secreta, y el token está listo...
- El método `compact()` crea y transforma el token en String.

!!! note "Nota" 
    Como se puede observar el método signWith hace uso del método definido para generar la clave a partir del base64 del properties, es decir, de la entrada de `app.jwtSecret`.


```java 
    private static final Logger logger = LoggerFactory.getLogger(JWTUtils.class);

    @Value("${app.jwtSecret}")
    private String jwtSecret;

    @Value("${app.jwtExpirationMs}")
    private int jwtExpirationMs;
```

### 3.5. Validación de Usuarios del token

Para la validación de los usuarios desde el token haremos uso de esta función:

```java
public String getUserNameFromJwtToken(String token) {
    return Jwts.parser()
            .verifyWith(key())
            .build()
            .parseSignedClaims(token)
            .getPayload()
            .getSubject();
}

```
### 3.6. Validación de Tokens


```java
public boolean validateJwtToken(String authToken) {
    try {
        Jwts.parser()
                .verifyWith(key())
                .build()
                .parseSignedClaims(authToken);
        return true;
    } catch (SecurityException | MalformedJwtException e) {
        logger.error("Invalid JWT token: {}", e.getMessage());
    } catch (ExpiredJwtException e) {
            logger.error("JWT token is expired: {}", e.getMessage());
    } catch (UnsupportedJwtException e) {
        logger.error("JWT token is unsupported: {}", e.getMessage());
    } catch (IllegalArgumentException e) {
        logger.error("JWT claims string is empty: {}", e.getMessage());
    }
    return false;
}
```

En este método comprobamos si es un token válido. Para ello primero generamos la key con hmacShaKeyFor, que es un método de utilidad de JJWT que crea una SecretKey segura y apropiada para algoritmos HMAC a partir de bytes. Con este hacemos lo siguiente:

```java
Jwts.parser()        // 1. Inicia el constructor del parser
    .verifyWith(key()) // 2. Configura la clave de verificación
    .build()         // 3. Construye el parser
    .parseSignedClaims(authToken); // 4. Parsea y verifica el token


```
Si existe algún problema con la integridad del token, podría aparecer una excepción. Obtenemos los claims dentro de un blog `try-catch` e informamos si ocurre algo. Devolveremos `true` si no se captura ninguna excepción.


!!! note "Nota" 
    Recuerda que los _claims_ son el contenido del payload del token. No necesitamos los claims en este método, sólo comprobar si todo está bien. Esto lo podríamos hacer encadenado dentro de parseSignedClaims(authToken) . getPauloads() pero no nos interesan, por lo que los omitimos.


## 4. Authentication Controller

Ahora que también sabemos cómo crear tokens y la estructura de `User` en nuestra base de datos, es hora de exponer nuestro path para registrar e iniciar sesión de usuarios. Por tanto, sólo son obligatorios dos métodos. La clase podría ser algo así:

```java
@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
public class AuthController {
...
}
```

- La anotación `@CrossOrigin` permite solicitudes de cross-origin en clases de controlador específicas y/o métodos de controlador. Se procesa si se configura un `HandlerMapping` apropiado. Cross-Origin Resource Sharing (**CORS**) es un concepto de seguridad que permite restringir los recursos implementados en navegadores web. Evita que el código JavaScript produzca o consuma solicitudes contra un origen distinto. Por ejemplo, su aplicación web se está ejecutando en el puerto 8080 y mediante JavaScript está intentando consumir servicios web RESTful desde el puerto 9090. En estas situaciones, se encontrará con el problema de seguridad de Cross-Origin Resource Sharing en sus navegadores web.
- `@RequestMapping("/api/auth")` indica que todos los controladores están dentro del camino `/api/auth`.

Veámoslos, pero antes de estudiar los métodos, esta clase tiene estas variables necesarias:

- `@Autowired AuthenticationManager authenticationManager;` → se utiliza para crear un token de `Authentication`, utilizado por el contexto de seguridad de Spring y por el generador de tokens.
- `@Autowired UserRepository userRepository;` → se utiliza para acceder y guardar usuarios.
- `@Autowired RoleRepository roleRepository;` → para comprobar si los roles que llegan a la solicitud son válidos.
- `@Autowired PasswordEncoder encoder;` → se utiliza para cifrar la contraseña del usuario.
- `@Autowired JwtUtils jwtUtils;` → se utiliza para crear tokens JWT.

Ahora que hemos presentado a los actores, vamos a la función.

### 4.1. Signup (nuevo usuario)

El método encargado de crear nuevos usuarios recibirá un `SignupRequest` con estos datos:

```json
{ 
"username":"manuro", 
"email":"jm.romeromartinez@edu.gva.es", 
"password":"123456", 
"role":["admin","user"]
}
```

el cuerpo del método es el siguiente, y veámoslo por bloques:

```java
@PostMapping("/signup") 
public ResponseEntity<?> registerUser(@Valid @RequestBody SignupRequest signUpRequest) { 
if (userRepository.existsByUsername(signUpRequest.getUsername())) { 
return ResponseEntity 
.badRequest() 
.body(new MessageResponse("Error: Username is already taken!")); 
} 

if (userRepository.existsByEmail(signUpRequest.getEmail())) { 
return ResponseEntity 
.badRequest() 
.body(new MessageResponse("Error: Email is already in use!")); 
} 
// Create new user's account 
User user = new User(signUpRequest.getUsername(), 
signUpRequest.getEmail(), 
encoder.encode(signUpRequest.getPassword()));
```

En esta primera parte:

- Comprobamos si existe algún usuario con el mismo nombre de usuario o correo electrónico, consultando nuestro repositorio. Si aparece algún error, devolveremos un `ResponseEntity` como _bad request_ con un mensaje descriptivo.
- Por último, creamos un nuevo usuario con nombre de usuario, correo electrónico y una contraseña encriptada.

El siguiente bloque es responsable de obtener los roles (almacenados en un JSONArray de cadenas) y transformarlos en un `Set<Role>`.

```java 
Set<String> strRoles = signUpRequest.getRole(); 
Set<Role> roles = new HashSet<>(); 

if (strRoles == null) { 
Role userRole = roleRepository.findByName(ERole.ROLE_USER) 
.orElseThrow(() -> new RuntimeException("Error: Role is not found.")); 
roles.add(userRole); 
} else { 
strRoles.forEach(role -> { 
switch (role) { 
case "admin": 
Role adminRole = roleRepository.findByName(ERole.ROLE_ADMIN) 
.orElseThrow(() -> new RuntimeException("Error: Role is not found.")); 
roles.add(adminRole); 

break; 
case "mod": 
Role modRole = roleRepository.findByName(ERole.ROLE_MODERATOR) 
.orElseThrow(() -> new RuntimeException("Error: Role is not found.")); 
roles.add(modRole);
break; 
default: 
Role userRole = roleRepository.findByName(ERole.ROLE_USER) 
.orElseThrow(() -> new RuntimeException("Error: Role is not found.")); 
roles.add(userRole); 
} 
}); 
} 

user.setRolas(rolas);
```

Veámoslo:

- Primero comprobamos si el conjunto de roles está vacío. Si es cierto, establecemos un nuevo `Role` con `ERole.ROLE_USER` por defecto.
- En caso contrario, debemos recorrer todos los roles que obtenemos, comprobando cada rol en la base de datos y creando el objeto `Role` correspondiente.

Por último, asignamos `Set<Role>` al usuario creado en el primer bloque, y en el tercer bloque sólo necesitamos almacenar el nuevo usuario con `UserRepository` y enviar una respuesta de ok al cliente.

```java 
userRepository.save(user); 

return ResponseEntity.ok(new MessageResponse("User registered successfully!")); 
}
```

### 4.2. Signin (Validarse o acceder)

!!! note "Nota" 
En castellano: 

- Signin: registrarse, acceder al login. 
- Signup: inscribirse, darse de alta. La primera vez


Este controlador se utiliza para iniciar sesión de un usuario en nuestra aplicación. Como hemos estudiado, el DTO que recibimos en el `HTTP_POST` es la clase `LoginRequest`, como ésta:

```json
{ 
"username":"manuro", 
"password":"123456"
}
```

El método encargado será:

```java
@PostMapping("/signin") 
public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) { 

Authentication authentication = authenticationManager.authenticate( 
new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword())); 

SecurityContextHolder.getContext().setAuthentication(authentication); 
String jwt = jwtUtils.generateJwtToken(authentication); 

UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal(); 

List<String> roles = userDetails.getAuthorities().stream() 
.map(item -> item.getAuthority()) 
.collect(Collectors.toList()); 

return ResponseEntity.ok(new JwtResponse(jwt, 
userDetails.getId(), 
userDetails.getUsername(), 
userDetails.getEmail(), 
roles)); 
}
```

Ten en cuenta:

- La anotación `@Valid` comprueba que el objeto JSON coincida con la clase `LoginRequest` (mira las anotaciones de esta clase).
- Creamos un token de `Authentication` (éste no es el token JWT !!!) con el nombre de usuario y la contraseña recibidos. La contraseña todavía no está cifrada.
- El último token de `Authentication` se configura en `SecurityContextHolder`, un objeto que contiene un mínimo de seguridad a nivel de hilo. En este paso es cuando el subsistema de seguridad de Spring funciona, pidiendo a `UserDetailService` un usuario con ese nombre de usuario y contraseña en nuestra base de datos, y se guarda en un Bean `UserDetails` en la memoria. Si alguna credencial es incorrecta, se lanzará una excepción, que será gestionada por nuestro sistema (lo estudiaremos más adelante).
- Con este token (autenticación) generamos nuestro token. Recuerda que dentro de `jwtUtils` sólo obtenemos el nombre de usuario para generar el sujeto de nuestro token.
- Obtenemos el objeto `UserDetails` con el método `getPrincipal()`, y
- Transformamos la lista de autoridades en una lista de cadenas (¿has estudiado cómo mapear listas? ¿Y filtrar? ¿Y reducir?).
- Finalmente, creamos y devolvemos un `ResponseEntity`, con http_Status **ok**, con un `JwtResponse` dentro. Token más atributos. Un ejemplo de `JWTrespone` es:

```json
{
    "accessToken": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtYW51cm8iLCJpYXQiOjE3NjUzMDI1ODksImV4cCI6MTc2NTM4ODk4OX0.9yZHAZ1E8wemMbUVbJ9vkA4JhjTgXj4B8ETlhUZRGIpi3apFrXEpJ2RKlSBZoVKDcs-iebIzu7lLoujHAzmlLg",
    "id": 3,
    "username": "manuro",
    "email": "jm.romeromartinez@edu.gva.es",
    "roles": [
        "ROLE_ADMIN"
    ],
    "tokenType": "Bearer"
}
```

!!! note "Atención" 
El último token tiene saltos de línea adicionales para evitar salir del margen del papel, es una cadena completa.

Si el nombre de usuario no se encuentra en la base de datos, nuestra aplicación crea la siguiente respuesta:

```json
{ 
"path": "/api/auth/signin", 
"error": "Unauthorized", 
"message": "Bad credentiales", 
"status": 401
}
```

## 5. Tokens en funcionamiento

Ahora que el registro de usuarios y el inicio de sesión están implementados, hacemos una pregunta, ¿Qué hace la aplicación cliente con el JWTResponse que ha recibido después del proceso de inicio de sesión? Los datos del usuario normalmente se utilizan para la interfaz (nombre completo, avatar, etc.). ¿Pero qué pasa con los tokens?

La respuesta, como estudiaremos más adelante, es almacenarlo, y después enviarlo al servidor en cada solicitud como método de Autenticación y Autorización.

### 5.1. Enviando tokens

Para enviar un token, necesitamos adjuntarlo a la sección `Header`, creando un parámetro `Authorization` con el valor `Bearer token_recieved`, como puede ver enesta captura de pantalla de Postman:

![Send_JWT](./img/Send_JWT.png){width=95%}

!!! importante "Importante" 
Recuerda: la palabra `Bearer` más un _espacio en blanco_ más todo el token recibido (como `String`)


De acuerdo, así pues, la aplicación cliente nos enviará el token a través de la solicitud, pero ¿cómo hace nuestro servidor para obtener y comprobar el token? La respuesta es que debemos decirlo en forma de filtro.

## 6. Configuración de Seguridad

La clase que configura la seguridad es `WebSecurityConfig`. Vamos a explicarla por blogs de nuevo. Esta clase está compuesta por un conjunto de beans que se utilizarán en todo el proyecto (recuerda la inyección de código). Explicaremos sólo lo necesario.

```java
@Configuration
@EnableGlobalMethodSecurity( 
prePostEnabled = true)
public class WebSecurityConfig {

}

```

Esta anotación `@Configuration` indica a Spring que debe cargar esta clase. También permite que Spring utilice anotaciones de filtros pre y post (lo estudiaremos más adelante).

```java 
@Autowired 
UserDetailsServiceImpl userDetailsService; 

@Autowired 
private AuthEntryPointJwt unauthorizedHandler; 

@Bean 
public AuthTokenFilter authenticationJwtTokenFilter() { 
return new AuthTokenFilter(); 
}
```

Estos beans se explicarán más adelante. En pocas palabras, son responsables de gestionar errores como manejador de excepciones y de cómo aplicar cadenas de filtros para autenticar a usuarios.

```java 
@Bean 
public DaoAuthenticationProvider authenticationProvider() { 
DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider(); 

authProvider.setUserDetailsService(userDetailsService); 
authProvider.setPasswordEncoder(passwordEncoder()); 

return authProvider; 
}
```

Este Bean utiliza `UserDetailService` y `PasswordEncoder` para realizar el proceso de autenticación. Esto significa acceder a la base de datos y comprobar el usuario y la contraseña (con el mismo encoder que utilizamos para almacenar usuarios). Los siguientes Beans crean el `AuthenticationManager` y el encoder.

```java 

@Bean 
public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception { 
return authConfig.getAuthenticationManager(); 
} 

@Bean 
public PasswordEncoder passwordEncoder() { 
return new BCryptPasswordEncoder(); 
}
```

Y por último, una de las configuraciones más importantes (y difíciles de entender), la cadena de filtros de seguridad. Las cadenas de filtros son código que ponemos en medio entre el cliente y el servidor. Estos filtros interceptan la solicitud, la analizan y después, dependiendo del resultado del filtro, simplemente pasan el control al servidor o envían una respuesta al cliente. Este filtro podría cambiar la solicitud, añadiendo o eliminando información que será utilizada por el servidor.

```java 
@Bean 
public SecurityFilterChain filterChain(HttpSecurity http) throws Exception { 
http.cors().and().csrf().disable() 
.exceptionHandling().authenticationEntryPoint(unauthorizedHandler).and() 
.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS).and() 
.authorizeRequests().antMatchers("/api/auth/**").permitAll() 
.antMatchers("/api/test/**").permitAll() 
.añoRequest().authenticated(); 

http.authenticationProvider(authenticationProvider()); 

http.addFilterBefore(authenticationJwtTokenFilter(), UsernamePasswordAuthenticationFilter.class); 

return http.build(); 
}
```

Tenga en cuenta que:

- Habilitamos CORS (Cross-Origin Requests) y deshabilitamos CSRF (Cross Site Request Forgery)
- Establecemos la authenticationEntryPoint
- Permitimos el acceso a todos los caminos a `/api/auth/**`
- Permitimos el acceso a todos los caminos a `/api/test/**`
- Cualquier otra solicitud necesitará ser autenticada

Por último, añadimos el filtro antes y el proveedor de autenticación.

En una visión relajada, para entenderlo, los filtros se combinan con anotaciones que indican dónde y cuándo debemos comprobar la Autenticación y la Autorización.

![FilterChain](./img/FilterChain.png){width=95%}

### 6.1. AuthTokenFilter

Esta clase contiene el proceso de token recibido de los clientes. Debe implementar `OncePerRequestFilter` y sobreescribir `doFilterInternal()`.

```java
@Override 
protected void doFilterInternal( 
HttpServletRequest request, 
HttpServletResponse response, 
FilterChain (filterChain) throws ServletException, IOException { 
try { 
String jwt = parseJwt(request); 
if (jwt != null && jwtUtils.validateJwtToken(jwt)) { 
String username = jwtUtils.getUserNameFromJwtToken(jwt); 

UserDetails userDetails = userDetailsService.loadUserByUsername(username); 
UsernamePasswordAuthenticationToken authentication = 
new UsernamePasswordAuthenticationToken( 
userDetails, 
null, 
userDetails.getAuthorities()); 
authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request)); 

SecurityContextHolder.getContext().setAuthentication(authentication); 
} 
} catch (Exception e) { 
logger.error("Cannot set user authentication: {}", e); 
} 

filterChain.doFilter(request, response); 
}
```

En nuestras palabras, este método se ejecutará cuando se haga una solicitud y:

- Extrae el token de la solicitud, devolviendo sólo la información relevante (elimina `Bearer`).
- Comprueba que el token sea válido, y: 
- Extrae el nombre de usuario (está en el payload del token) y 
- Obtiene este `UserDetails` y crea un `UsernamePasswordAuthenticationToken` para ser inyectado en el resto de la solicitud-respuesta, obviamente con autoridades.
- Por último, continúa con el siguiente filtro, si existe, llamando `filterChain.doFilter(req,nada)`. Si no existe ningún filtro, el dispatcher pasa el control al controlador solicitado.

### 6.2. AuthEntryPoint

Esta clase contiene código que se ejecutará cuando aparezca una excepción. Crea entonces un cuerpo genérico dentro de la respuesta y establece una respuesta precisa para el cliente.

## 7. Controller Authorization

Sólo queda decir qué solicitud necesita ser autorizada. Recuerda que con otras clases preparamos la autenticación, **¿Quién eres?**. Ahora necesitamos preguntar **¿Qué puedes hacer?**

Como marcamos en nuestra `filterChain`, añadimos `addFilterBefore` para comprobar los roles. Pero, ¿dónde debemos decir los roles que capturan cada solicitud? La respuesta es fácil: los controladores. Veamos un controlador de prueba con filtro de autorización:

```java
@CrossOrigin(originos = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/test")
public class TestController { 
@GetMapping("/all") 
public String allAccess() { 
return "Public Content."; 
} 

@GetMapping("/user") 
@PreAuthorize("hasRole('USER') or hasRole('MODERATOR') or hasRole('ADMIN')") 
public String userAccess() { 
return "User Content."; 
} 

@GetMapping("/mod") 
@PreAuthorize("hasRole('MODERATOR')") 
public String moderatorAccess() { 
return "Moderator Board."; 
} 

@GetMapping("/admin") 
@PreAuthorize("hasRole('ADMIN')") 
public String adminAccess() { 
return "Admin Board."; 
}
}
```
Si:

- No aparece ninguna anotación: todos los roles pueden realizar esta solicitud
- `@PreAuthorize("hasRole('role')")` → Esta anotación indica el rol que está autorizado para realizar esta solicitud. Puedes combinar más de un rol con `otro`

## 8. Ejercicio. ¿Cómo utilizar este proyecto?

Probablemente tendrás ya una API implementada y funcionando de forma no segura. Ahora tienes la tarea de **fusionar** con este proyecto para autorizar ciertas operaciones sólo a usuarios registrados. Es una tarea larga (que no complicada), pero el resultado final será muy gratificante.
