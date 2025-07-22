# 4. Archivos JSON

JSON es otro formato de texto ligero para el intercambio de datos. JSON significa _JavaScript Object Notation_ y es un subconjunto de la notación literal de objetos del lenguaje, que se ha adoptado junto con XML como uno de los principales estándares para el intercambio y almacenamiento de datos.

Una de las ventajas de JSON respecto a XML es la facilidad de escribir analizadores, pero lo que es más importante es que expresa lo mismo que XML pero de una forma mucho más concreta y concisa, por lo que se utiliza habitualmente en entornos donde el flujo de datos es importante, como es el caso de los servidores de Google, Yahoo, etc., que atienden a millones de usuarios.

## 4.1. Formato JSON

La especificación completa puede verse [aquí](https://www.json.org/)

Los tipos de datos que podemos representar en JSON son:

- **Números**, tanto enteros como decimales.
- **Cadenas de texto**, expresadas entre comillas y con la posibilidad de incluir secuencias de escape.
- **Booleans**, para representar los valores `true` y `false`.
- **Null**, para representar el valor `null`.
- **Array**, para representar listas de cero o más valores, de cualquier tipo, cerradas entre corchetes y separadas por comas.
- **Objetos**, como colecciones de pares `<clave>:<valor>`, separados por comas y entre claves, y de cualquier tipo de valor.

Lo veremos mejor con un ejemplo bien conocido: el de los módulos con los que estamos trabajando:

```json
{ 
"curso": [ 
{ 
"nombre": "Acceso a Datos", 
"horas": 6, 
"calificación": 8.45 
}, 
{ 
"nombre": "Programación de servicios y procesos", 
"horas": 3, 
"calificación": 9.0 
}, 
{ 
"nombre": "Desarrollo de interfaces", 
"horas": 6, 
"calificación": 8.0 
}, 
{ 
"nombre": "Programación Multimedia y dispositivos móviles", 
"horas": 5, 
"calificación": 7.34 
}, 
{ 
"nombre": "Sistemas de Gestión Empresarial", 
"horas": 5, 
"calificación": 8.2 
}, 
{ 
"nombre": "Empresa e iniciativa emprendedora", 
"horas": 3, 
"calificación": 7.4 
} 
]
}
```


Veremos cómo `curso` es un array o una lista de módulos (aunque ahora no utilizamos la etiqueta "módulo"), que en este caso son objetos con tres elementos: el nombre, que es una cadena de caracteres, las horas, que es un entero, y la calificación, que se representa como un número decimal. Cabe destacar que, como en XML, también necesitamos un objeto raíz, en este caso el elemento "curso".

Internet está lleno de servicios que ofrecen información en formato JSON. Por ejemplo, puede visitar:


- <https://arkhamdb.com/api/public/card/01001>
- <https://swapi.dev/api/films/1/>
- <http://hp-api.herokuapp.com/api/characters>

Existe una amplia gama de librerías de Java para manipular documentos JSON (GSON, Jackson, JSON.simple...). En nuestro caso, utilizaremos la librería `org.json`, que podemos consultar en el repositorio Maven: <https://mvnrepository.com/artifact/org.json/json>

En la siguiente sección comentaremos la funcionalidad de la librería, y en un documento adjunto, veremos cómo incorporarla a nuestros proyectos mediante el gestor de dependencias Gradle.

## 4.2. `Gson`

Gson es una biblioteca Java que permite convertir objetos Java a su representación JSON. También permite convertir una cadena JSON en un objeto Java equivalente. Gson puede trabajar con cualquier objeto Java, incluyendo objetos preexistentes cuyo código fuente no se conoce.

Existen algunos proyectos de código abierto que permiten convertir objetos Java a JSON. Sin embargo, la mayoría requiere la inclusión de anotaciones Java en las clases, algo que no es posible si no se tiene acceso al código fuente. Además, la mayoría no admite completamente el uso de genéricos de Java. Gson considera ambos objetivos de diseño muy importantes.

Gson se centra principalmente en Java. Usarlo con otros lenguajes JVM como Kotlin o Scala puede funcionar correctamente en muchos casos, pero las características específicas de cada lenguaje, como los tipos no nulos de Kotlin o los constructores con argumentos predeterminados, no son compatibles. Esto puede generar un comportamiento confuso e incorrecto.
Al usar lenguajes distintos de Java, es preferible una biblioteca JSON con soporte explícito para ese lenguaje.

### Objetivos

- Proporcionar métodos simples `toJson()` y `fromJson()` para convertir objetos Java a JSON y viceversa.
- Permitir la conversión de objetos preexistentes no modificables a y desde JSON.
- Amplio soporte para genéricos de Java.
- Permitir representaciones personalizadas de objetos.
- Admitir objetos de complejidad arbitraria (con jerarquías de herencia profundas y uso extensivo de tipos genéricos).


## 4.2. Clase Modulo

Nuestros ejemplos se basan en los datos de los módulos de DAM vistos en las secciones anteriores. Considera este bloque de código como punto de partida donde se crea un array `curso` y se llena con módulos. Para ello creamos la clase Modulo:

```java title="Modulo.java"

package org.example.pojo;

public class Modulo {
    private String nombre;
    private int horas;
    private double nota;

    // Constructores
    public Modulo() {}  // Necesario para GSON

    public Modulo(String nombre, int horas, double nota) {
        this.nombre = nombre;
        this.horas = horas;
        this.nota = nota;
    }

    // Getters y Setters
    public String getNombre() {
        return nombre;
    }

    public int getHoras() {
        return horas;
    }

    public double getNota() {
        return nota;
    }

    @Override
    public String toString() {
        return String.format("%s (%d horas) - Nota: %.2f", nombre, horas, nota);
    }
}

```

## 4.3. Clase Curso

La clase Curso se va a considerar el contenedor principal. 

- Se hace uso de `@SerializedName` para garantizar el mapeo exacto con el campo `curso`del JSON.
- Métodos de conversión integrados (`toJson()`/`fromJson()`).


```java title="Curso.java"
package org.example.pojo;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.annotations.SerializedName;
import java.util.List;

public class Curso {
    @SerializedName("curso")  // Anotación para mapear exactamente el campo JSON
    private List<Modulo> modulos;

    // Constructor necesario para GSON
    public Curso() {
    }

    // Constructor para creación manual
    public Curso(List<Modulo> modulos) {
        this.modulos = modulos;
    }

    // Getter y Setter (obligatorios para GSON)
    public List<Modulo> getModulos() {
        return modulos;
    }

    public void setModulos(List<Modulo> modulos) {
        this.modulos = modulos;
    }

    // Método para facilitar la conversión a JSON
    public String toJson() {
        return new GsonBuilder().setPrettyPrinting().create().toJson(this);
    }

    // Método estático para crear desde JSON
    public static Curso fromJson(String json) {
        return new Gson().fromJson(json, Curso.class);
    }
}

```

## 4.4. Clase CursoFileUtils

Esta clase contendrá un par de métodos que nos permitirán guardar y leer los cursos del fichero JSON

```java title="CursoFileUtils.java"
package org.example.utils;

import org.example.pojo.Curso;

import java.io.*;

public class CursoFileUtils {
    public static void guardarCurso(Curso curso, String filePath) throws IOException {
        try (FileWriter writer = new FileWriter(filePath)) {
            writer.write(curso.toJson());
        }
    }

    public static Curso cargarCurso(String filePath) throws IOException {
        try (FileReader reader = new FileReader(filePath)) {
            StringBuilder json = new StringBuilder();
            int c;
            while ((c = reader.read()) != -1) {
                json.append((char) c);
            }
            return Curso.fromJson(json.toString());
        }
    }
}

```
## 4.4. Clase Main

Desde la clase Main podemos ver el funcionamiento del mismo

```java title="Main.java"
package org.example;

import org.example.pojo.Curso;
import org.example.pojo.Modulo;
import org.example.utils.CursoFileUtils;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        try {
            // 1. Crear datos
            List<Modulo> modulos = Arrays.asList(
                    new Modulo("Acceso a Datos", 6, 8.45),
                    new Modulo("Programación", 3, 9.0)
            );

            Curso curso = new Curso(modulos);

            // 2. Guardar en archivo
            CursoFileUtils.guardarCurso(curso, "2dam.json");
            System.out.println("Datos guardados correctamente");

            // 3. Cargar desde archivo
            Curso cursoCargado = CursoFileUtils.cargarCurso("2dam.json");
            System.out.println("\nMódulos cargados:");
            cursoCargado.getModulos().forEach(System.out::println);

        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

```

Con esta separación obtenemos la siguiente estructura:

1. Anotación @SerializedName: Garantiza el mapeo exacto con el campo "curso" del JSON.
2. Separación de responsabilidades:
    1. Curso maneja la estructura contenedora
    2. Modulo maneja los datos individuales
    3. CursoFileUtils gestiona la persistencia
3. Métodos de conversión integrados (`toJson()`/`fromJson()`).
4. Manejo seguro de recursos con try-with-resources.