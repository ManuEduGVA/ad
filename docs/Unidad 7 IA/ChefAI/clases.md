# Clases del backend

A continuacion se documentan todas las clases Java del proyecto. Se detalla su responsabilidad, elementos y relacion con otras clases.

## 1) ChefAiApplication

Ruta: `src/main/java/org/cipfpcheste/dam2/chefai/ChefAiApplication.java`

**Responsabilidad**

- Punto de entrada de la aplicacion Spring Boot.
- Inicia el contexto de Spring y el servidor embebido.

**Elementos principales**

- Anotacion `@SpringBootApplication`:

  - Activa el escaneo de componentes.
  - Habilita la autoconfiguracion.
  - Permite usar configuracion basada en clases.

- Metodo `main(String[] args)`:

  - Es el metodo que arranca la aplicacion.
  - Llama a `SpringApplication.run(...)`.

**Interacciones**

- No depende directamente de otras clases del proyecto.
- Permite que Spring detecte `@Controller` y `@Service`.

## 2) RecipeController
Ruta: `src/main/java/org/cipfpcheste/dam2/chefai/controlador/RecipeController.java`

**Responsabilidad**

- Controlador web MVC.
- Recibe peticiones HTTP y devuelve la vista `index`.

**Anotaciones**

- `@Controller`: indica que esta clase gestiona peticiones web y devuelve vistas.
- `@GetMapping("/")`: mapea la ruta raiz para mostrar el formulario.
- `@PostMapping("/receta")`: mapea el envio del formulario.

**Atributos**

- `private final RecetaService recetaService`:
  - Servicio que contiene la logica de negocio.
  - Se inyecta por constructor (inyeccion de dependencias).

**Constructores**

- `RecipeController(RecetaService recetaService)`:
  - Spring inyecta el servicio automaticamente.

**Metodos**

- `showHomePage(Model model)`:
  - **Entradas**: `Model model`.
  - **Acciones**:
    - Crea un `RecetaRequest` y un `RecetaResponse` vacios.
    - Los coloca en el `model` para que la vista los use.
  - **Salida**: devuelve la vista `index`.

- `generateReceta(@ModelAttribute RecetaRequest request, Model model)`:

  - **Entradas**:
    - `RecetaRequest request`: datos del formulario.
    - `Model model`: datos para la vista.
  - **Acciones**:
    - Llama a `recetaService.generateRecipe(...)`.
    - Si todo va bien, añade `success` y la respuesta.
    - Si hay error, añade `error` y una respuesta vacia.
  - **Salida**: devuelve la vista `index`.

**Notas didacticas**

- `@ModelAttribute` enlaza el formulario con el DTO de entrada.
- El controlador no implementa la logica del modelo; solo coordina.

## 3) RecetaService
Ruta: `src/main/java/org/cipfpcheste/dam2/chefai/service/RecetaService.java`

**Responsabilidad**

- Encapsula la logica de negocio para generar recetas.
- Se encarga de validar, crear el prompt y llamar a la IA.

**Anotaciones**

- `@Service`: indica que es un servicio de Spring.

**Atributos**

- `private final ChatClient chatClient`:
  - Cliente para llamar al modelo via Spring AI.
  - Se crea usando un `ChatClient.Builder`.

**Constructor**

- `RecetaService(ChatClient.Builder chatClientBuilder)`:
  - Construye el cliente con `chatClientBuilder.build()`.

**Metodos**

- `generateRecipe(RecetaRequest request)`:
  - **Entradas**: `RecetaRequest` con ingredientes, tipo y objetivo.
  - **Pasos**:

    1. `validateRequest(request)` valida la entrada.
    2. `createRecipePrompt(request)` crea el texto para la IA.
    3. Configura `OpenAiChatOptions` (modelo, temperatura, tokens).
    4. Llama al modelo con `chatClient.prompt().user(...).call()`.
    5. Limpia la salida con `cleanRecipeText(...)`.
    6. Devuelve un `RecetaResponse` con los datos finales.

  - **Salida**: `RecetaResponse`.
  - **Errores**: lanza `RuntimeException` si falla la llamada.

- `createRecipePrompt(RecetaRequest request)`:
  - **Objetivo**: construir el prompt con formato.
  - **Salida**: `String` listo para enviar a la IA.

- `cleanRecipeText(String text)`:
  - **Objetivo**: eliminar comillas y espacios sobrantes.
  - **Salida**: `String` limpio.

- `validateRequest(RecetaRequest request)`:
  - **Objetivo**: validar campos vacios y longitud maxima.
  - **Errores**: `IllegalArgumentException` si hay errores.

**Notas didacticas**

- Se separa la logica del controlador (principio SRP).
- Los metodos privados ayudan a mantener el codigo ordenado.

## 4) RecetaRequest

Ruta: `src/main/java/org/cipfpcheste/dam2/chefai/modelo/RecetaRequest.java`

**Responsabilidad**

- DTO de entrada con los datos del formulario.

**Anotaciones (Lombok)**

- `@Data`:
  - Genera getters, setters, `toString`, `equals`, `hashCode`.
- `@AllArgsConstructor`:
  - Crea constructor con todos los campos.
- `@NoArgsConstructor`:
  - Crea constructor vacio.

**Campos**

- `private String ingredientes`:
  - Texto con ingredientes disponibles.
- `private String tipoComida`:
  - Tipo de comida (desayuno, almuerzo, etc.).
- `private String objetivoDieta`:
  - Objetivo saludable (alto en proteina, bajo en carbohidratos, etc.).

**Uso**

- Se rellena automaticamente desde el formulario web.

## 5) RecetaResponse

Ruta: `src/main/java/org/cipfpcheste/dam2/chefai/modelo/RecetaResponse.java`

**Responsabilidad**

- DTO de salida con la receta generada y los datos asociados.

**Anotaciones (Lombok)**

- `@Data`, `@AllArgsConstructor`, `@NoArgsConstructor`.

**Campos**

- `private String ingredientes`:
  - Ingredientes recibidos (se muestran en pantalla).
- `private String receta`:
  - Texto de la receta generado por la IA.
- `private String tipoComida`:
  - Tipo de comida solicitado.
- `private String objetivoDieta`:
  - Objetivo saludable solicitado.

**Uso**

- Se crea en `RecetaService` y se envia al controlador.
