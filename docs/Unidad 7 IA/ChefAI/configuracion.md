# Configuracion (application.properties)

Archivo: `src/main/resources/application.properties`

Este archivo define propiedades de Spring Boot, el servidor y la integracion con la API.

## Propiedades y significado

- Nombre logico de la aplicacion.

  - `spring.application.name=ChefAI`
 
- Puerto HTTP en el que se levanta la app.
  - `server.port=8080`

- Contexto base. Con `/` la app queda en la raiz del servidor.
  - `server.servlet.context-path=/`
  
- URL base para las llamadas a la API compatible con OpenAI (Groq).
- `spring.ai.openai.base-url=https://api.groq.com/openai`
  
- Clave de API para autenticar las llamadas.
  - **Recomendacion didactica**: en produccion se debe usar una variable de entorno y no dejar la clave en el repositorio.
- `spring.ai.openai.api-key=...`
  
- Carpeta de plantillas Thymeleaf.
- `spring.thymeleaf.prefix=classpath:/templates/`
  
 - Extension de las vistas.
- `spring.thymeleaf.suffix=.html`
 
  - Modo de procesado de Thymeleaf.
- `spring.thymeleaf.mode=HTML`

  - Codificacion de caracteres para las vistas.
- `spring.thymeleaf.encoding=UTF-8`

  - Tipo de contenido devuelto por el motor de vistas.
- `spring.thymeleaf.servlet.content-type=text/html`

  - Carpeta para recursos estaticos (CSS, JS, imagenes).
- `spring.web.resources.static-locations=classpath:/static/`

- Nivel de log para un paquete concreto.
- `llogging.level.org.cipfpcheste.dam2.chefai=debug`
 

!!! info Buenas practicas
    - Mover la API key a variables de entorno.
    - Mantener propiedades sensibles fuera del repositorio.
    - Ajustar niveles de log segun entorno (DEV vs PROD).
