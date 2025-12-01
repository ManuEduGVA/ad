## 1. Introducción. Servicios de Acceso a Datos

Un **servlet** es una aplicación que se ejecuta en un servidor, preparada para responder a _solicitudes http_. Más tarde tenemos **JSP** (Java Server Pages), que permiten combinar elementos _HTML/XML_ con fragmentos de _código Java_ para generar contenido dinámicamente. Debemos lanzar un servidor de aplicaciones y añadir la aplicación para ejecutarla y servirla como otra página.

Podemos utilizar Servlets para escribir una aplicación web, pero existen muchos detalles intrínsecos a controlar: validación, REST, cuerpo de la solicitud/respuesta para JSON, vinculación de formularios, etc. Esto implica que gran parte de nuestro código se dedica a controlar las capas inferiores de comunicación.

Con el **framework** Spring, realmente utilizamos servlets, pero libera al programador de esta tarea _pesada_, gestionándola automáticamente. Esto permite al programador centrarse en la lógica de la aplicación, sin tener que manejar los niveles inferiores de comunicaciones. Además, Spring Boot se define como un **acelerador de Spring**, permitiéndonos indicar una serie de convenciones (comportamientos) que realizan tareas pesadas de configuración de archivos para nosotros. Por último, Spring Boot incorpora un servidor web integrado (normalmente `Tomcat`).

El término framework o si intentamos forzar su traducción al Español es _marco de trabajo_  y nos proporciona un conjunto de reglas y herramientas diseñadas para aumentar la velocidad de desarrollo de aplicaciones.

## 2. MVC

El Modelo Vista Controlador (MVC) es una arquitectura para el desarrollo de aplicaciones que separa los datos, la interfaz y la lógica de control en capas.

![MVC](./img/MVC.png){width=95%}

El funcionamiento es el siguiente:

1. El usuario está utilizando la aplicación cliente (normalmente un navegador o cliente), y realiza una solicitud a través del **protocolo http**, también conocida como una **HTTP_REQUEST**. Estas solicitudes son recibidas por el **módulo controlador**. El controlador gestiona una lista de operaciones o eventos que puede procesar, determinados por su propio protocolo.
2. En el caso de una solicitud que solicita una consulta o modificación de los datos, pasamos los parámetros proporcionados en la solicitud a la **capa del modelo**. Esta capa accede a los datos, realizando los pasos 3 y 4 a través de operaciones del SGBD. El Modelo está ahora en condiciones de dar una respuesta.
3. Consultar la base de datos.
4. Recuperación de la consulta de la base de datos.
5. El modelo transfiere el conjunto de resultados obtenidos a la vista.
6. La vista es responsable de recibir los datos y presentarlos o formatearlos adecuadamente.
7. El controlador devuelve la presentación generada por la vista (que normalmente será HTML dinámico) a la aplicación cliente, a través de la solicitud **HTTP_RESPONSE**.

## 3. REST

El modelo **REST** (**Representational State Transfer**) nos permite proporcionar a nuestro servidor un servicio para recuperar y manipular datos fácilmente en el servidor. En este modelo, la parte de la vista se delega al cliente, dejando el controlador y el modelo en el servidor. En este modelo, destacaremos entre otros:

- El protocolo sigue el modelo **cliente/servidor sin estado**, al igual que http, una solicitud sólo responderá según la información recibida en la misma solicitud, sin tener en cuenta todas las anteriores.
- Soporte de operaciones CRUD, a través de las especificaciones http equivalentes: **GET** (consulta), **POST** (crear), **PUT** (modificar) y **DELETE** (eliminar).
- Disposición del modelo **HATEOAS** (**Hypermedia As Engine Of The Application State**). Este principio permite incluir hipervínculos como recursos en las respuestas.

En **MVC**, y de forma simplificada, sería eliminar la capa de la vista y devolver los datos procesados ​​por el modelo. Normalmente los servidores REST devuelven datos en formato **JSON**.