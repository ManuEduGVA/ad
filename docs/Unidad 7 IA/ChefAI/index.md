# ChefAI - Documentacion didactica

Explicación del funcionamiento de la app, el flujo de datos y las partes principales.

## Que hace el proyecto

ChefAI es una app web con Spring Boot y Thymeleaf que genera recetas saludables a partir de ingredientes. El usuario completa un formulario y la app consulta un modelo de IA (Groq) para devolver la receta.

## Tecnologias principales

- Spring Boot (aplicacion y servidor web)
- Spring MVC (controladores y vistas)
- Thymeleaf (plantillas HTML)
- Spring AI + Groq (llamada al modelo)
- HTML + CSS + JavaScript (interfaz)

## Estructura general del proyecto

- `src/main/java` contiene el backend (controlador, servicio, modelos y main).
- `src/main/resources/templates` contiene las vistas Thymeleaf.
- `src/main/resources/static` contiene CSS y JavaScript.
- `src/main/resources/application.properties` contiene la configuracion.

## Flujo de la aplicación

1. El navegador abre `/` y el controlador devuelve la vista `index`.
2. El usuario rellena el formulario y envia el POST `/receta`.
3. El servicio valida la entrada y construye un prompt.
4. Se llama al modelo de IA y se limpia la respuesta.
5. Se devuelve la receta a la vista y se muestra en pantalla.

El proyecto completo lo podemos encontrar [aquí](./ChefAI.zip)
