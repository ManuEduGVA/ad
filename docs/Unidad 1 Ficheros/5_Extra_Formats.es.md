# 5. Formatos extra

En esta sección estudiaremos dos tipos de archivos de texto que se utilizan ampliamente en informática y la forma de trabajar con ellos.

## 5.1. Archivos CSV

Un archivo de **valores separados por comas** (CSV) es un archivo de texto estándar que utiliza una coma (`,`) para separar los valores. Cada línea del archivo consiste en uno o más campos separados por comas. Cada campo puede o no estar cerrado entre comillas dobles. Además, varios formatos utilizan distintos caracteres como separador, como el punto y coma (`;`) o el símbolo de numeral (`#`). [RFC 4180](https://tools.ietf.org/html/rfc4180) define el formato o definiciones de un archivo CSV o archivo de texto/csv.

En caso de que el símbolo utilizado como separador aparezca dentro de los valores, es buena idea cerrar el contenido entre comillas. Se puede ver un ejemplo de archivo CSV aquí:

```csv
Chevrolet Chevelle Concours (sw);0;8;350.0;165.0;4142.;11.5;70;US
Ford Torino (sw);0;8;351.0;153.0;4034.;11.0;70;US
Plymouth Satellite (sw);0;8;383.0;175.0;4166.;10.5;70;US
AMC Rebel SST (sw);0;8;360.0;175.0;3850.;11.0;70;US
Dodge Challenger SE;15.0;8;383.0;170.0;3563.;10.0;70;US
Plymouth Cuda 340;14.0;8;340.0;160.0;3609.;8.0;70;US
Ford Mustang Boss 302;0;8;302.0;140.0;3353.;8.0;70;US
```

La forma de procesar un archivo CSV en Java es:

1. Abrir el archivo como archivo de texto para la lectura. Debemos leer línea por línea, ya que cada línea es un registro. Leer una línea en una variable de tipo `String`.
2. Procesar los registros individuales: 
1. Podemos separar cada campo. Una buena opción es utilizar el método `split(char)` de la clase String. Obtengamos un array de cadenas con los valores de los campos individuales. 
2. Procesar cada valor de campo según sus necesidades.


!!! note "Atención" 

Es una buena idea empezar a utilizar las clases abstractas `Files` y `Paths`. Estas clases mejoran el uso de la clase File y sus clases derivadas, ofreciendo métodos útiles que nos permiten realizar operaciones rápidas con menos líneas de código. Por ejemplo, la siguiente línea, a partir del `filename`, la abre y después lee todo el archivo, devolviendo una lista con las líneas separadas en cada elemento de la colección. 

```java 
List<String> lines=Files.readAllLines(Paths.get(filename)); 
``` 

Más información en: 

- [Files](https://docs.oracle.com/en/java/javase/12/docs/api/java.base/java/nio/file/Files.html) 
- [Paths](https://docs.oracle.com/en/java/javase/12/docs/api/java.base/java/nio/file/Paths.html)

## 5.2. Archivos de propiedades

### 5.2.1. Archivo de propiedades

Por último, pero no menos importante, le mostraremos un tipo de archivo de texto importante, que son los archivos de propiedades. Estos archivos almacenan, como ya sabéis, varias propiedades que se utilizan durante la ejecución del programa. Cuando el programa se inicia, carga estas propiedades y ajusta varias opciones. Ejemplos de estos archivos son `my.conf` en MySQL, `php.ini` en PHP, etc.

El aspecto de este archivo consiste en varias líneas (una por propiedad) y cada línea tiene el formato `atributo=valor`. Por ejemplo, un supuesto archivo:


```conf
# properties of my program
puerto=1234
volume=90
bright=56
load_on_start=true
```


La forma de procesar un archivo de propiedades en Java es similar a un CSV:

1. Abrir como archivo de texto para la lectura. Debemos leer línea por línea, ya que cada línea es una propiedad distinta. Leer una línea en una variable de tipo `String`.
2. Procesar los registros individuales: 
1. Podemos separar cada campo. Una buena opción es utilizar el método `split(char)` de la clase String. Obtengamos un array de cadenas con los valores de los campos individuales. Los separadores normalmente son `=`, `:`. 
2. La izquierda del separador es el nombre de la propiedad. 
3. La derecha del separador es el valor de la propiedad. 
4. Hay que tener en cuenta que si una línea comienza con barra (`#`), es un comentario y se ignorará.


### 5.2.2. Propiedades de Java

Java tiene un objeto muy útil para manejar este tipo de información. Con los objetos [preperties](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/util/Properties.html) de Java, podemos almacenar un conjunto de propiedades con una tabla de hash (básicamente una pareja clave-valor). Tiene métodos preparados para cargar y guardar desde y hacia flujos de texto o, incluso, archivos XML. Algunos métodos interesantes para las propiedades son:

**Lectura desde archivo (texto o XML)**

- `void load(InputStream inStream)` → Lee un conjunto de propiedades (parejas clave-elemento) desde el flujo de entrada de bytes.
- `void load(Reader reader)` → Lee un conjunto de propiedades (parejas clave-elemento) desde el flujo de entrada de caracteres en un formato sencillo orientado a líneas.
- `void loadFromXML(InputStream in)` → Carga todas las propiedades representadas por el documento XML en el flujo de entrada especificado en esta tabla de propiedades.

**Escritura en archivo (texto o XML)**

- `void store(OutputStream out, Str.ing comments)` → Escribe este conjunto de propiedades (parejas clave-elemento) en esta tabla de propiedades en el flujo de salida en un formato adecuado para cargarlo en una tabla de propiedades utilizando el método load(InputStream).
- `void store(Writer writer, String comments)` → Escribe este conjunto de propiedades (parejas clave-elemento) en esta tabla de propiedades en el flujo de caracteres de salida en un formato adecuado para utilizar el método load(Reader).
- `void storeToXML(OutputStream os, String comment)` → Emite un documento XML que representa todas las propiedades contenidas en esta tabla.

**Trabajo con propiedades (heredado de HashTable)**

- `Set<K> keySet()` → Devuelve una vista de conjunto de las claves contenidas en este mapa.
- `V get(Object key)` → Devuelve el valor (`V`) al que se asigna la clave especificada, o `null` si este mapa no contiene ninguna asignación para la clave.
- `boolean containsKey(Object key)` Comprueba si el objeto especificado es una clave de esta tabla de hash.
- `V put(K key, V value)` → Asigna la clave especificada al valor especificado en esta tabla de hash.
- `V remove(Object key)` → Elimina la clave (y se devuelve el valor correspondiente) de esta tabla de hash.

### 5.2.3. Programa de ejemplo

En el siguiente programa, puede ver un ejemplo de lectura y creación de archivos de propiedades en Java.

```java 

/** 
* Load the file specified and show its properties in different ways 
* @param filename 
*/ 
private void loadAndShowProperties(String filename) { 

Properties properties = new Properties(); 

try { 
properties.load(new FileInputStream(new File(filename))); 

System.out.println("Whole set: " + properties); 

properties.list(System.out); 

Set<Object> keys = properties.keySet( ); 

System.out.println("My listing: "); 
for (Object key : keys) { 
System.out.println(key + " - " + properties.getProperty((String) key)); 
} 

} catch (FileNotFoundException e) { 
// TODO Auto-generated catch block 
e.printStackTrace(); 
} catch (IOException e) { 
// TODO Auto-generated catch block 
e.printStackTrace(); 
} 

} 

/** 
* Create en properties object, populated with samples and stores into a 
* texto file and a XML file 
* @throws IOException 
*/ 
private void writeProperties() throws IOException { 
Properties props = new Properties(); 

props.put("Color", "Green"); 
props.put("Range", "123"); 
props.put("Visible", "false"); 
props.put("Size", "Big"); 
props.put("Status", "functional"); 
props.put("Value", "345.24"); 

props.store(new FileWriter(new File("propios.properties")), "Sample props file"); 

props.storeToXML(new FileOutputStream(new File("propios.xml")), "Sample XML Props"); 
}
```

## 5.3. Entorno, archivos `.env` y `dot_env`

### 5.3.1. ¿Por qué utilizar variables de entorno?

Las variables de entorno son un aspecto crucial para configurar y gestionar aplicaciones en distintos entornos, como **desarrollo, pruebas y producción**. Proporcionan una forma de pasar dinámicamente datos de configuración a las aplicaciones sin codificar valores directamente al código fuente. Este enfoque mejora la **flexibilidad**, **portabilidad** y **seguridad** de las aplicaciones.

En Java, acceder a las variables de entorno es sencillo gracias a la clase `System`, que proporciona métodos para obtener las variables de entorno. Esta capacidad es especialmente útil para:

- Configurar parámetros de la aplicación tales como URL de bases de datos, claves de API y rutas de archivos.
- Gestionar configuraciones específicas del entorno sin alterar el código fuente.
- Mantener información sensible, tales como contraseñas y tokens, fuera del código fuente.

Entendiendo cómo utilizar de forma efectiva las variables de entorno en Java, los desarrolladores pueden crear aplicaciones más adaptables y seguras.

### 5.3.2. Obtener variables de entorno

Para acceder a las variables de entorno en Java, puede utilizar el método `System.getenv()`. Este método está sobrecargado y puede ser:

- `System.getenv()` → devuelve un objeto `Map` que contiene todas las variables de entorno y sus valores correspondientes.
- `System.getenv(String)` → devuelve una `String` con el valor de la variable de entorno específica o null si no existe.

!!! example "Cómo recuperar las variables de entorno en Java:" 

```java 
Map<String, String> env = System.getenv(); 

// Acceder a una variable de entorno específica 
String value = env.get("NOMBRE_VARIABLE"); 

// Imprimir todas las variables de entorno 
for (Map.Entry<String, String> entry : env.entrySet()) { 
System.out.println(entry.getKey() + " = " + entry.getValue()); 
} 
``` 

> Tenga en cuenta que: 
> 
> - La clase Map devuelve una colección de entradas con parejas clave-valor. 
> - Las variables de entornorn distinguen entre mayúsculas y minúsculas, así que asegúrese de utilizar las mayúsculas de forma correcta al acceder a ellas.


### 5.3.3. La alternativa `dot-env`

Almacenar la configuración en el entorno es uno de los principios de una aplicación de doce factores. Cualquier cosa que pueda cambiar entre los entornos de despliegue, como los recursos de las bases de datos o las credenciales de los servicios externos, debe extraerse del código y almacenarse en variables de entorno.

Pero no siempre es práctico establecer variables de entorno en máquinas de desarrollo o servidores de integración continua en los que se ejecutan varios proyectos. `Dotenv` carga las variables de un archivo `.env` en el entorno cuando se inicia.

Desafortunadamente, Java no admite de forma nativa la carga de archivos `.env`, pero puede utilizar librerías externas para conseguir esta tarea. Una de las librerías populares para este propósito es `dotenv-java`. Esta librería le permite cargar fácilmente las variables de entorno de un archivo .env en su aplicación Java. <https://github.com/cdimascio/dotenv-java>

**Añada la dependencia**

Primero, debe añadir la librería `dotenv-java` a su proyecto. Si utiliza Maven, añada la siguiente dependencia al archivo pom.xml:

```xml
<dependency> 
<groupId>io.github.cdimascio</groupId> 
<artifactId>java-dotenv</artifactId> 
<version>5.2.2</version>
</dependency>
```

Si utiliza Gradle, añada lo siguiente al archivo build.gradle:

```
implementation 'io.github.cdimascio:java-dotenv:5.2.2'
```


**Cree el archivo `.env`**

El archivo .env es como un archivo de configuración. Puede almacenarlo en la ruta raíz de su aplicación

```conf
DATABASE_URL=jdbc:mysql://localhost:3306/testdb
DATABASE_USER=root
DATABASE_PASSWORD=password
```

**Cargue la configuración**


```java
importe io.github.cdimascio.dotenv.Dotenv;

public class Main { 
public static void main(String[] args) { 
// Load the .env file 
Dotenv dotenv = Dotenv.load(); 

// Retrieve environment variables 
String databaseUrl = dotenv.get("DATABASE_URL"); 
String databaseUser = dotenv.get("DATABASE_USER"); 
String databasePassword = dotenv.get("DATABASE_PASSWORD"); 

// Print the values 
System.out.println("Database URL: " + databaseUrl); 
System.out.println("Database User: " + databaseUser); 
System.out.println("Database Password: " + databasePassword); 

// Use the variables as needed 
// For example, establish a database connection using these variables 
}
}

```


!!! info "Atención" 
Tenga en cuenta que con la librería java dotenv, utilizará `dotenv.get()` en lugar del método `System.getenv()`, ya que está accediendo a un archivo local.