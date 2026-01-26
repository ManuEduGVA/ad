# Frontend (HTML, CSS y JavaScript)

El frontend se compone de una vista Thymeleaf y recursos estaticos.

## Vista principal (Thymeleaf)

Archivo: `src/main/resources/templates/index.html`

**Estructura general**

- `<!DOCTYPE html>` y `<html lang="es">` definen el idioma y el documento.
- `<head>` carga el CSS `href="/style.css"`.
- `<body>` contiene la app dentro de `.container`.

**Cabecera**

- `.header` muestra el titulo, un subtitulo y una etiqueta de tecnologia.

**Mensajes de estado**

- Bloques con `th:if` para mostrar mensajes de exito o error:
  - `th:if="${success}"` y `th:text="${success}"`.
  - `th:if="${error}"` y `th:text="${error}"`.

**Formulario**

- Se envia a `POST /receta` con `th:action`.
- `textarea#ingredientes`:
  - `name="ingredientes"` enlaza con `RecetaRequest.ingredientes`.
  - `th:text` rellena el texto en caso de recarga.
- `select#tipoComida`:
  - `name="tipoComida"`.
- `select#objetivoDieta`:
  - `name="objetivoDieta"`.

**Nota didactica importante**

- En Spring MVC, el `name` del formulario debe coincidir con el nombre del atributo del DTO.
- En este proyecto, los `name` del HTML coinciden con `tipoComida` y `objetivoDieta` del DTO, por lo que el binding es directo.

**Resultado**

- Se muestra solo si hay receta:
  - `th:if="${recetaResponse != null and recetaResponse.receta != null and recetaResponse.receta != ''}"`
- Presenta ingredientes y receta generada en columnas.

## Estilos CSS

Archivo: `src/main/resources/static/style.css`

**Variables CSS (`:root`)**

- Define la paleta de colores (`--cream`, `--sage`, `--copper`, etc.).
- Facilita cambios globales en la interfaz.

**Tipografia y fondo**

- Usa fuentes de Google Fonts.
- Fondo con gradientes y circulos decorativos.

**Layout principal**

- `.container` centra y limita el ancho.
- `.header` usa un gradiente para la cabecera.
- `.content` controla padding y espaciado.

**Componentes de formulario**

- `textarea` y `select` con borde suave y foco con sombra.
- `.controls` usa grid para dos columnas.
- `.translate-btn` define el boton principal con hover.

**Resultado**

- `.translation-result` crea un panel destacado.
- `.result-container` usa dos columnas para ingredientes y receta.

## JavaScript

Archivo: `src/main/resources/static/js/app.js`

**Clase `RecipeApp`**

- Encapsula la logica del contador de caracteres.

**Metodos**

- `initializeElements()`:
  - Obtiene `textarea#ingredientes` y `div#charCount`.
- `attachEventListeners()`:
  - Escucha el evento `input` del textarea.
  - Llama a `updateCharCount()` al cargar.
- `updateCharCount()`:
  - Actualiza el texto `X/2000 caracteres`.
  - Si supera 2000, aplica la clase `warning`.

**Inicializacion**

- Se instancia cuando el DOM esta listo (`DOMContentLoaded`).

## Rutas estaticas

- CSS se sirve desde `/style.css`.
- JS se sirve desde `/js/app.js`.
- Esto funciona porque `spring.web.resources.static-locations` apunta a `classpath:/static/`.
