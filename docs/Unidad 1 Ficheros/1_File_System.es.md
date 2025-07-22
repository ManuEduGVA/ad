# 1. Sistema de archivos

## 1.1. Introducción

En los inicios de la informática, los archivos eran el único mecanismo para almacenar información. Hoy en día, los sistemas operativos gestionan los dispositivos de almacenamiento de modo casi transparente para el usuario. Sin entrar en detalles de las tecnologías de almacenamiento subyacentes, nos ofrecen una abstracción mediante la cual sólo debemos preocuparnos por dos conceptos: archivos y directorios.

- **Archivo** → contenedores de información (de todo tipo y formato).
- **Directorios** → organizadoras de archivos, y pueden contener archivos y otros directorios.

Sobre la información (el contenido del archivo), encontramos una clasificación clásica:

- **Archivo de texto** → la información se almacena de forma que puede verse o abrirse con cualquier editor de texto plano, como vino, nano o notepad.
- **Archivo binario** → la información se almacena codificada en formato binario. Como ya sabe el estudiante, cualquier tipo de información (texto, números, fotos, etc.) puede traducirse a 0 y 1. En nuestro caso (programadoras), podemos transformar objetos y variables de diferentes formas.

!!! importante "Importante tener en cuenta que..." 

- Aunque almacenemos información en archivos de texto, aparece un nuevo concepto: **estructura**. Si organizamos la información de diferentes formas, podemos hablar de archivos csv, archivos xml, archivos json. Los archivos csv, xml y json son estructuras, porque al fin y al cabo, todos ellos son archivos de texto. 
- La gente piensa que los archivos de texto son débiles para almacenar información, pero no es cierto. Las técnicas criptográficas nos ofrecen métodos para almacenar información de forma segura dentro de archivos de texto. Por ejemplo, `htpasswd` en **apache** o `/etc/shadow` en sistemas Linux. Abajo pueden verse un ejemplo de clave pública PGP, almacenada en un archivo de texto.

```bash
-----BEGIN PGP PUBLIC KEY BLOCK-----
Comment: Alice's OpenPGP certificate
Comment: https://www.ietf.org/id/draft-bre-openpgp-samples-01.html

mDMEXEcE6RYJKwYBBAHaRw8BAQdArjWwk3FAqyiFbFBKT4TzXcVBqPTB3gmzlC/U
b7O1u120JkFsaWNlIExvdmVsYWNlIDxhbGljZUBvcGVucGdwLmV4YW1wbGU+iJAE
...
DAAKCRDyMVUMT0fjjlnQAQDFHUs6TIcxrNTtEZFjUFm1M0PJ1Dng/cDW4xN80fsn
0QEA22Kr7VkCjeAEC08VSTeV+QFsmz55/lntWkwYWhmvOgE=
=iIGO
-----END PGP PUBLIC KEY BLOCK-----
```

## 1.2. Accediendo al sistema de archivos en Java

`Java` nos ofrece varias formas de acceder al sistema de archivos. Esta forma es independiente del dispositivo subyacente que almacena la información. El dispositivo puede ser un disco duro, un disco ssd, unidad óptica, etc. La clase que nos ofrece esta posibilidad es la clase [File](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/io/File.html). Repasaremos los principales aspectos de esta clase y después revisaremos algunos ejemplos.

- El constructor de la clase está sobrecargado, como la mayoría de las clases de Java. Podemos utilizar: 

- `File(File pariente, String child)` → Crea una nueva instancia de File a partir de un directorio padre abstracto y una cadena de directorio hijo. 
- `File(String pathname)` → Crea una nueva instancia de File convirtiendo la cadena de directorio dato en un directorio abstracto. 
- `File(String parent, String child)` → Crea una nueva instancia de File a partir de una cadena de directorio padre y una cadena de directorio hijo. 
- `File(URI uri)` → Crea una nueva instancia de File convirtiendo el file: URI dado en un directorio abstracto.

- Para acceder al archivo debemos usar un número de ruta. Ésta es la ruta, y tenemos dos posibilidades: 

- **Ruta absoluta** → la ruta desde el directorio raíz del sistema hasta el archivo que queremos, comenzando con `/` en sistemas Linux o `letra:` en sistemas Windows. Recuerda utilizar `/` para separar carpetas en Linux y `\\` en Windows. No es un error, ya que la barra invertida es un símbolo con un significado propio, debemos escaparla, duplicándola para obtener el significado que queremos. 
- **Ruta relativa** → suponemos que el archivo que queremos se encuentra en la misma carpeta que el proyecto/programa que estamos ejecutando. En este caso, sólo proporcionamos el nombre del archivo, sin ninguna carpeta al principio de la ruta.

```java
// absolute paths
File f=new File("/home/manu/texto.md") // Linux
File f=new File("C:\\Usuarios\\manu\\Dektop\\texto.md") // Windows
...
// relative paths
File f=new File("texto.md") // Linux
File f=new File("docs\texto.md") // Windows
```

- La misma clase `File` se utiliza para acceder tanto a un archivo regular como a un directorio. Es tarea del programador diferenciarlos mediante los métodos de archivo, así como comprobar si un archivo existe. Para ello podemos utilizar varios métodos como: 
- `boolean exists()` → devuelve true si el objeto de archivo existe y false de lo contrario. 
- `boolean isFile()` y `isDirectory()` → devuelve true si el objeto es un archivo regular o un directorio. Obviamente, aquestos métodos son exclusivos.


## 1.3. Creando archivos

Si queremos crear una carpeta o un archivo regular, podemos utilizar estos métodos:

- `boolean createNewFile()` → Crea de forma atómica un nuevo archivo vacío con el nombre especificado si y sólo si un archivo con ese nombre todavía no existe.
- `static FilecreateTempFile(String prefijo, String suffix)` → Crea un archivo vacío en el directorio temporal por defecto, utilizando el prefijo y el sufijo especificados para generar su nombre.
- `boolean mkdir()` → Crea el directorio con el nombre especificado.
- `boolean mkdirs()` → Crea el directorio con el nombre especificado, incluyendo cualquier directorio padre necesario pero que no exista.
- `boolean renameTo(File dest)` → Cambia el nombre del archivo especificado.
- `boolean delete()` → Elimina el archivo o directorio especificado.

!!! note "Atención" 
- En las secciones siguientes estudiaremos cómo crear archivos cuando guardamos contenido. En otras palabras, no es necesario crear el archivo _ad hoc_ y luego rellenarlo. Hay mecanismos para crear el archivo de forma automatizada. 
- La diferencia entre mkdir y mkdirs es que la segunda opción creará todos los directorios entre el sistema de archivos raíz y el directorio actual, mientras que la primera requiere que la ruta ya exista.


## 1.4. Pidiendo propiedades del archivo

Normalmente abrimos archivos para escribir o leer su contenido, pero a veces necesitamos pedir las propiedades del archivo, como el tamaño, los permisos, etc. La clase File nos ayudará de nuevo.

Información general:

- `boolean exists()` → Comprueba si el archivo o directorio indicado para esta ruta abstracta existe.
- `long lastModified()` → Devuelve el tiempo en que se modificó por última vez el archivo indicado por esta ruta abstracta.
- `long length()` → Devuelve el tamaño del archivo indicado para esta ruta abstracta.

Información sobre permisos. Esta información es la misma que el usuario puede obtener con `ls -la` en el formato de `chmod`:

- `boolean canExecute()` → Comprueba si la aplicación puede ejecutar el archivo indicado por esta ruta abstracta.
- `boolean canRead()` → Comprueba si la aplicación puede leer el archivo indicado para esta ruta abstracta.
- `boolean canWrite()` → Comprueba si la aplicación puede modificar el archivo indicado por esta ruta abstracta.

Contenido de un directorio:

- `String[] list()` → Devuelve un **array de cadenas** con los nombres de los archivos y directorios del directorio indicado por esta ruta abstracta.
- `File[] listFiles()` → Devuelve un array de rutas abstractas que indican los archivos del directorio indicado por esta ruta abstracta.
- `String[] list(FilenameFilter filter)` → Devuelve un array de cadenas con los nombres de los archivos y directorios del directorio indicado por esta ruta abstracta que cumplen el filtro especificado.
- `File[] listFiles(FilenameFilter filter)` → Devuelve un array de rutas abstractas que indican los archivos y directorios del directorio indicado por esta ruta abstracta que cumplen el filtro especificado.

!!! tip "Consejo" 
Le sugerimos al estudiante que busque información sobre la clase [FilenameFilter](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/io/FilenameFilter.html).


### 1.4.1. Ejercicio resuelto

Analiza y explica el siguiente blog de código
```java
public static void main(String[] args) { 
String ruta = args[0]; 
File f = new File(ruta); 

if (f.exists()) { 
if (f.isFile()) { 
System.out.println("El tamaño es de " + f.length()); 
System.out.println("Puede ejecturase: " + f.canExecute()); 
System.out.println("Puede leerse: " + f.canRead()); 
System.out.println("Puede escribirse: " + f.canWrite()); 
} else { 
String[] losArchivos = f.list(); 
System.out.println("El directorio " + ruta + " contiene:"); 
for (String archivo : losArchivos) { 
System.out.println("\t" + archivo); 
} 
} 

} else { 
System.out.println("El archivo o ruta no existe"); 
}
}
```

**Solución**

1. Este programa lee desde la línea de pedidos una ruta y crea un objeto File.
2. A continuación, comprueba si la ruta existe o no en el sistema de archivos. En caso de que no exista, el programa finaliza.
3. Si la ruta existe, el siguiente paso es verificar si es un archivo: 
1. Leemos algunas propiedades triviales como el tamaño y los permisos.
4. Si la ruta apuntada por el archivo es un directorio, obtenemos el contenido de este directorio y lo mostramos en la pantalla.


<!--
Buscar y reemplazar $\rightarrow$ por → (simbolo del sistema)
Cambiar los awesomebox por !!! al inicio, quitar los traseros y tabular los contenidos. Podemos darle título
-->