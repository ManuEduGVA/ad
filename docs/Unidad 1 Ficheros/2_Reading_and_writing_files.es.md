# 2. Lectura y escritura de archivos

Java ofrece una gran variedad de maneras de manipular el contenido de los archivos, aportando gran poder pero también complejidad al mismo tiempo.

La lectura y escritura de archivos en Java se realiza a través de flujos de datos o `streams`, que pueden ser orientados a bytes o considerados como un conjunto de caracteres. El concepto de archivo, que es estático, debe diferenciarse del concepto de flujo, que tiene un carácter dinámico: un archivo se guarda en el disco, pero desde el punto de vista de la aplicación, nos interesa la transferencia de esta información desde el archivo a nuestro programa. Una comparación clásica: los flujos serían como tuberías de agua, mientras que los archivos serían depósitos. El concepto de **flujo de datos**, aparte del ámbito de los archivos, también será aplicable a la transferencia de información, por ejemplo a través de la red o entre procesos.

Los flujos se pueden clasificar en:

- `flujo de entrada`: Aquellos que van desde una fuente (por ejemplo, un archivo) al programa.
- `flujo de salida`: Aquellos que salen del programa hacia un destino (por ejemplo, un archivo).

Cuando leemos y almacenamos datos, debemos tener mucho cuidado con los tipos de datos con los que trabajamos, ya que la misma secuencia de bits en el disco representa información diferente según el tipo de datos utilizado. Incluido cuando se trata del mismo tipo de datos, como en el caso de los caracteres, es necesario tener especial cuidado, ya que diferentes sistemas pueden utilizar diferentes codificaciones. Java, por ejemplo, para el tipo char utiliza Unicode de 16 bits (UTF-16), pero podemos intentar acceder a archivos codificados, por ejemplo, con UTF-8 o ASCII.

Las superclases padre para el manejo de corrientes orientadas a bytes son `InputStream` y `OutputStream`. De ellas derivan otras, pero para la gestión de archivos nos interesan dos: `FileInputStream` y `FileOutputStream`.


## 2.1. FileInputStream

La clase `FileInputStream` se utiliza para acceder a archivos para la lectura y tiene dos constructores principales:

- `FileInputStream (File f)` → Recibe un objeto de tipo `File`, que hará referencia al objeto que leeremos.
- `FileInputStream (String name)` → Recibe una cadena con el nombre o la ruta de la ubicación del archivo a leer.

Los principales métodos que tenemos para esta clase son:

- `int read()` → Método de lectura secuencial abstracto: Devuelve un entero correspondiente al siguiente byte de un flujo de entrada (fichero, vector de bytes...). Si llega al final de la secuencia, devuelve `-1`. En caso de error, lanzará una excepción de tipo IOException.
- `int read(byte[] buffer)` → Lee un número determinado de bytes de la entrada (tanto como el tamaño del buffer), los guarda en el buffer y devuelve el número de bytes leídos efectivamente, que como máximo será igual al tamaño del buffer. Si no hay bytes disponibles, devuelve `-1`.
- `int available()` → Indica los bytes disponibles para la lectura.
- `long skip(long des)` → Salta tantos bytes como indica el parámetro. El valor de retorno es el número de bytes que se han descartado efectivamente (puede ser menor que el indicado si llegamos al final, por ejemplo).
- `int close()` → Cierra el flujo de datos.

## 2.2. FileOutputStream

La clase `FileOutputStream` se utiliza para acceder a archivos para la escritura. Tiene los siguientes constructores:

- `FileOutputStream (File f)` → Recibe un objeto de tipo `File` y lo abre en modo escritura. En caso de que no exista, se creará, y si ya existe, se sobreescribirá.
- `FileOutputStream (String name)` → Recibe una cadena con el nombre o la ruta de la ubicación del archivo a escribir, y lo abre en modo escritura. En caso de que no exista, se creará, y si ya existe, se sobreescribirá.
- `FileOutputStream (File f, boolean append)` → Recibe un objeto de tipo `File` y lo abre en modo añadir, para escribir al final. Si no existe, se creará, y si ya existe, se escribirá detrás (sólo si append está establecido en `True`).
- `FileOutputStream (String name, boolean append)` → Recibe una cadena con el nombre o la ruta de la ubicación del archivo a escribir y lo abre en modo añadir, para escribir al final. Si no existe, se creará, y si ya existe, se escribirá detrás (sólo si append está establecido en `True`).

Los principales métodos de la clase son:

- `write(int byte)` → Escribe el byte en el flujo de salida. Aunque este parámetro es un entero, sólo se escribe un byte. Si hay un error, se lanzará una excepción de tipo IOException.
- `void write(byte[] buffer)` → Escribe el contenido del buffer (vector de bytes) en el archivo. Si el buffer es nulo, lanzará una excepción.
- `void write(byte[] buffer, int pos, int length)` → Escribe el contenido del `buffer` (vector de bytes) desde la posición `pos`, y tantos bytes como se indiquen en `length`.
- `void flush()` → Fuerza la escritura de los bytes restantes en la memoria caché en el archivo de salida.
- `void close()` → Cierra el flujo de salida y libera los recursos.

### 2.2.1. Ejercicio resuelto

Crea un programa sencillo en Java que copie un hitoxer a otro archivo byte en byte. El archivo origen y el archivo destino se indicarán a través de la línea de pedidos.


!!! example "Solución" 

```java 
class FileCopy { 
/* 
Class to test FileInputStream and FileOutputStream. 

Copy byte to byte of files 

Sintaxis: 
FileCopy sourceFile destinationFile. 

*/ 
public static void main(String[] args) throws Exception { 
// Byte readed from source 
int bytes; 
// Bytes (effectively) writen to dest 
long bytesCopied=0; 

// Streams 

FileInputStream fis= null; 
FileOutputStream fundido=null; 

// To provide information about source 
File f; 


// Are the arguments ok? 
if(args.length!=2){ 
System.out.println("Número de argumentos erróneo. Sintaxis:\n FileCopy archivoOrigen archivoDesti"); 
return; 
} 

try{ 

// show source size 
f=new File(args[0]); 
System.out.println("Total: "+f.length()+" bytes"); 

// Create streams 
fis=new FileInputStream(args[0]); 
fos=new FileOutputStream(args[1]); 

do { 
// read one byte from source 
bytes=fis.read(); 
// write in destination 
if (bytes!=-1) 
fos.write(bytes); 
// Update number of bytes 
bytesCopied++; 

// Show progress (think alternativas as exercise) 
System.out.print("\rCopiados "+(bytesCopied-1)+" bytes..."); 
}while (bytes!=-1); 
System.out.println("Done it!"); 


}catch (IOException exc){ 
System.out.println("Error de entrada y salida: "+exc); 
}finally { 
// En el final, no hay que terminar las filas, sino en error existentes o no. 
try { 
if (fis!=null) fis.close(); 
}catch (IOException exc){ 
System.out.println("Error al cerrar el archivo de origen."); 
} 
try { 
if(fos!=null) fos.close(); 
}catch (IOException exc){ 
System.out.println("Error al cerrar el archivo destino."); 
} 
} 
} 
} 
```


!!! note "Piensa y comprueba" 

Con el programa de ejemplo que hemos visto, podríamos copiar archivos de todo tipo: texto, audio, vídeo. 

**Reto** 

Trate de cambiar el último programa para leer los datos en bloques de 32 bytes, utilizando los métodos adecuados de las clases. Comparte tu solución en el foro.


## 2.3. Ficheros de Texto

Como se ha dicho, Java permite gestionar flujos con orientación a bytes o con orientación a caracteres. Las clases abstractas para la gestión de flujos orientados a caracteres son `Reader` y `Writer`.

### 2.3.1. `FileReader`

La clase `FileReader` sirve para acceder a archivos para la lectura y tiene dos constructores:

- `FileReader (File f)` → Recibe un objeto de tipo `File`, que hará referencia al objeto del que se obtendrá la información.
- `FileReader (String name)` → Recibe una cadena con el nombre o la ruta del archivo.

Los métodos que tenemos para esta clase son muy parecidos a los que tenemos para `FileInputStream`, con la diferencia de que ahora leemos caracteres en lugar de bytes.

- `int read()` → Lee el siguiente carácter del flujo de entrada y lo devuelve como entero.
- `int read(char[] buffer) → Rellena el buffer con tantos caracteres de la entrada como tenga (como máximo). Devuelve el número de caracteres leídos efectivamente.
- `int available()` → Devuelve el número de caracteres disponibles para la lectura.
- `long skip(long des)` → Salta tantos caracteres como indica el parámetro.
- `int close()` → Cierra el flujo de datos.

### 2.3.2. `FileWriter`

La clase FileWriter sería el equivalente de `FileOutputStream` en la versión de flujos orientados a caracteres Los constructores de la clase son:

- `FileWriter (File f)` → Abre elarchivo especificado por `File` para la escritura. Si el archivo no existe, se creará, y si ya existe, se eliminarán los contenidos.
- `FileWriter (String name)` → Abre el archivo especificado por una cadena con el nombre y la ruta en modo escritura. Si no existe, se creará, y si ya existe, se borrarán los contenidos.
- `FileWriter (File f, boolean append)` → Recibe un objeto de tipo `File` y lo abre en modo añadir, para escribir al final. Si no existe, se creará, y si ya existe, se escribirá detrás.
- `FileWriter (String name, boolean append)` → Recibe una cadena con el nombre o la ruta de la ubicación del archivo a escribir y lo abre en modo añadir, para escribir al final. Si no existe, se creará, y si ya existe, se escribirá detrás.

Los principales métodos de la clase `FileWriter` son muy similares a los de `OutputStream`:

- `write(int character)` → Escribe el carácter en el flujo de salida, con la codificación propia del sistema operativo. Si hay un error, se arroja una excepción de tipo `IOException`.
- `void write(char[] buffer)` → Escribe el contenido del buffer (vector de caracteres) en el archivo. Si el buffer es nulo, lanzará una excepción.
- `void write(char[] buffer, int pos, int length)` → Escribe el contenido del buffer (array de caracteres) desde la posición pos, y tantos bytes como se indiquen en length.
- `void flush()` → Fuerza la escritura de los bytes restantes en la memoria caché en el archivo de salida.
- `void close()` → Cierra el flujo de salida y libera los recursos.
- `void write(String text)` → Escribe todo el contenido de texto en el archivo.

### 2.3.3. Ejercicio resuelto

Crea un programa sencillo en Java que fusione todos los archivos dentro de una carpeta en un único archivo. La carpeta de origen y el archivo de destino se indicarán en la llamada del programa. Supongamos que todos los archivos dentro de esta carpeta son archivos de texto.

!!! example "Solución" 

```java 
class FusionaTextos { 
// Código del programa 
} 
``` /* 


Sintax: 
MergeTexts DirectorioOrigen ArchivoDestino 

*/ 
public static void main(String[] args) throws Exception { 

File decir; // Source dir 
// Collection of files from that dir 
File[] filas; 

// readed characters 
int characters; 

// Input and Output Streams 
FileReader fin=null; 
FileWriter fout=null; 

// Check the args 
if(args.length!=2){ 
System.out.println("Número de argumentos erróneo. Sintaxis:\n mergeTexts DirectorioOrigen archivoDesti"); 
return; 
} 

try{ 

// We get the list of Files 
dir=new File(args[0]); 
filas=dir.listFiles(); 


// Open and close output stream (in ordenar a crear el archivo) 
fout=new FileWriter(args[1]); 
fout.close(); 

// Re-open it 
fout=new FileWriter(args[1], true); 

// Iterate among the list 
for (int i=0; i<files.length; i++){ 
// open input stream 
fin=new FileReader(argos[0]+"/"+files[y].getName()); 
System.out.println("Merging "+args[0]+"/"+files[i].getName()); 
// and merge to the output one 
do { 
characters=fin.read(); 
if (characters!=-1) 
fout.write(characters); 
}while (characters!=-1); 
fin.close(); //close the file merged 

} 
fout.close(); //close the output file 

}catch (Exception exc){ 
// Catch all the exception (we coud improve it) 
System.out.println("Input/Output error: "+exc); 
} 
} 
} 
```

!!! note "Mejora tu código" 

Intenta mejorar el código anterior creando una función `merge()`. Deberíamos llamarla dentro del bucle principal.



## 2.4. Decoradores

[Patrón de diseño decorador](https://refactoring.guru/es/design-patterns/decorator/)

Las clases de decorador son aquellas que heredan de cierta clase y proporcionan funcionalidades añadidas al original. En el caso de los flujos de entrada y salida, tenemos decoradores que nos permiten leer o escribir líneas completas en vez de byte a byte, o guardarlos en un cierto formato de datos. Simplifica nuestro trabajo, añadiendo una forma más natural y amigable para utilizar las clases base.

La clase `InputStream` tiene varios decoradores, pero nos centraremos en los siguientes:

- `DataInputStream` → Permite leer datos de cualquier tipo (entero, lógico, etc.)
- `ObjectInputStream` → Añade la opción de leer un objeto entero

Por otro lado, la clase `OutputStream` también tiene diferentes decoradores, entre los que destacamos:

- `DataOutputStream` → Permite escribir datos de cualquier tipo (entero, lógico, etc.)
- `PrintStream` →Permite escribir datos de cualquier tipo y también acepta los métodos `printf` y `println`
- `ObjectOutputStream` → Permite escribir (serializar) objetos

En cuanto a las clases de decorador para flujos orientados a caracteres, tenemos, por un lado, los decoradores de `Reader` (más destacados):

- `BufferedReader` → Crea un buffer de entrada, permitiendo, por ejemplo, leer una línea completa

Y para la escritura:

- `BufferedWriter` → Crea un buffer de salida, permitiendo, por ejemplo, escribir una línea completa
- `PrintWriter` → Permite escribir datos de diferentes tipos y tiene métodos como `printf` y `println`

La clase `BufferedReader`, entre otros, tiene el método `readLine()`, que permite leer una línea entera del archivo hasta el final de la línea, muy útil en archivos de texto.

Por su parte, la clase `BufferedWriter` proporciona el método `newLine()` para introducir el carácter de retorno de carro y el método `write(String cadena, int inicio, int longitud)` para escribir una cadena o parte específica.

El otro decorador para la escritura es el `PrintWriter`, que nos ofrece los métodos `print(datos)`, `println(datos)` y `printf()` para el formato.

!!! note "Alternativas a..." 

Obviamente, podría: 

- concatenar `\n` al final de cada cadena en cada método `print()` en vez de llamar `newLine()`. 
- utilizar `println()` en lugar de llamar `newLine()`.



### 2.4.1. Ejercicio resuelto

Crea un programa para copiar un archivo de texto añadiendo el número de línea al principio de cada línea.

!!! example "Solución" 

```java 
public class NumberLines { 
public static void main(String[] args) throws Exception { 

// Input and Output 
BufferedReader fin; 
PrintWriter fout; 

// line counter 
int num_linia; 
// readed line 
String linea; 

// check args 
if (args.length != 2) { 
System.out.println("Número de argumentos erróneo. Sintaxis:\n numberLines archivo salida"); 
return; 
} 

// Creare decorators 
fin = new BufferedReader(new FileReader(args[0])); 
fout = new PrintWriter(new FileWriter(args[1])); 

num_linia = 1; 
do { 
// Read the line 
linea = fin.readLine(); 
if (línea != null) { 
fout.println(num_linia + ". " + linea); 
} 
num_linia++; 
} while (línea != null); // until we can't read 

// close all 
fin.close(); 
fout.close(); 

} 
} 
```

## 2.5. Ficheros binarios

En esta sección y las siguientes veremos cómo almacenar diferentes tipos de datos y objetos en archivos de diferentes formatos: archivos binarios, archivos XML o JSON.

### 2.5.1. Almacenar datos estructurados en archivos binarios.

En la sección anterior vimos cómo trabajar con archivos de caracteres y de bytes. En el caso de los archivos de bytes, hemos visto cómo leerlos y escribirlos secuencialmente, byte a byte hasta el final del archivo.

Imaginemos que queremos guardar la siguiente tabla, que combina datos de distintos tipos. Este ejemplo aparecerá en las siguientes secciones.

|Modulo |

|---|-|---|

|Acceso a Datos | 6 |8.45 |

|Programación de servicios y procesos |3 |9.0|

|Desarrollo de interfaces |6 |8.0|

|Programación Multimedia y dispositivos móviles |5 |7.34|

|Sistemas de Gestión Empresarial |5 |8.2|

|Empresa e iniciativa emprendedora |3 |7.4|

Como podemos ver, tenemos datos de texto, datos numéricos enteros y reales. Si queremos mantener los tipos, los flujos orientados a caracteres como `Reader` o `Writer` no serán útiles, así que deberíamos utilizar `InputStream` y `OutputStream`.

Para guardar estas estructuras eficientemente, podemos utilizar las clases `DataInputStream` y `DataOutputStream`, que son decoradores de flujos y que nos ofrecen los siguientes métodos para guardar o recuperar datos de diferentes tipos, sin tener que preocuparnos de cuánto ocupan internamente como puede ver, hay métodos recíprocos para leer.

|`DataInputStream` |

|---|---|---|

|`byte readByte()`|`void writeByte(int)` |un byte |

|`short readShort()` |`void writeShort(short)` |entero corto |

|`int readInt()` |`void writeInt(int)` |

|`long readLong()` |`void writeLong(long)` |

|`float readFloat()` |`void writeFloat(float)` | real de precisión simple|

|`double readDouble()` |`void writeDouble(double)` |real doble|

|`char readChar()` |`void writeChar(int)` |n carácter Unicode|

|`String readUTF()` |`void writeUTF(String)`|un String UTF-8 |

!!! tip 

Una cadena `UTF-8` es diferente a una String. Cuando se guarda una cadena, como es evidente, se guardan todos los caracteres. Al guardarla como cadena UTF-8, se añade información sobre la longitud de la cadena, siendo esta información esencial para cortar estas cadenas cuando se lean en el futuro. 

Imagina que guardas dos cadenas, "euro" y "sport". El resultado será, al final, "eurosport". Cuando alguien abra este archivo en el futuro, ¿cómo sabrá el número de cadenas almacenadas ("euro", "sport" o simplemente "eurosport" (canal de televisión))? 

Al guardarlo como UTF-8, cuando guardas "euro" y "sport", el resultado es "4euro5sport". Cuando alguien intente leerlo, primero verá un '4' y leerá "euro". Luego, verá un '5' y leerá "sport". 

Cabe destacar que si se guarda "eurosport", el resultado será "9eurosport". Prueba a escribir un programa de ejemplo con esta cadena, abriendo el archivo resultante con un editor hexadecimal.


### 2.5.2. Ejercicio resuelto

Escribe un programa que tenga los datos almacenados en tres arrays paralelos, que almacenan los datos de los módulos de DAM. Escribe dos funciones, una para escribir estos datos en un archivo y otra para leerlos. Considera almacenar los datos agrupados por módulo, en vez de nombre, horas y calificación.


!!! example "Solución" 

```java 
public class Moduls{ 

// several arrays with modules data 
String[] modulos={"Acceso a Datos", "Programación de servicios y procesos", "Desarrollo de interfaces", "Programación Multimedia y dispositivod móviles", "Sistemas de Gestión Empresarial", "Empresa e iniciativa emprendedora"}; 
int[] horas={6, 3, 6, 5, 5, 3}; 
double[] notas={8.45, 9.0, 8.0, 7.34, 8.2, 7.4}; 

public void readFiLe(String name) throws IOException { 
// Para leer el archivo binario, creamos un DataInputStream 
// a partir del FileInputStream creado a partir del nombre 
DataInputStream f = new DataInputStream(new FileInputStream(name)); 

// Mientras el DataInputStream tenga datos disponibles 
while (f.available()>0){ 
// Leeremos del archivo cada dato, con el orden correspondiente 
// en función del tipo 
// (por lo tanto, debemos saber el orden en el que guardamos!) 
System.out.println("Módulo: " + f.readUTF()); 
System.out.println("Horas: " + f.readInt()); 
System.out.println("Notas: " + f.readDouble()); 
System.out.println(); 
} 
f.close(); 
} 

public void writeFile(String name) throws IOException{ 
// Para escribir el archivo, hacemos uso de DataOutputStream 
DataOutputStream f = new DataOutputStream(new FileOutputStream(name)); 

// Recorreremos cualquiera de los vectores (todos deberían tener) 
// la misma longitud 
for (int i=0;i<this.moduls.length;i++){ 
// Y para cada posición, escribiremos en función del tipo de dato 
f.writeUTF(this.moduls[i]); 
f.writeInt(this.horas[i]); 
f.writeDouble(this.notes[i]); 

} 
f.close(); 
} 

public static void main(String[] args) throws IOException { 

// Comprobamos los argumentos 
if (args.length!=2){ 
System.out.println("Número de argumentos incorrecto.\n\nSintaxis: \n\t java Moduls [read | write] archivo.dat"); 
System.exit(0); 
} 

// Defining the class 
Moduls moduls=new Modulos(); 

// Depending the args, we will proceed 
if (args[0].equals("read")) 
moduls.readFiLe(args[1]); 
else if (args[0].equals("write")) 
moduls.writeFile(args[1]); 
else 
System.out.println("No entiendo el mandato "+args[0]+"\n"); 
} 
} 

```

## 2.6. Serializando Objetos

Java proporciona un sistema genérico de serialización de objetos: un sistema recursivo que itera sobre cada objeto contenido en una instancia, hasta llegar a los tipos primitivos, que se almacenan como un array de bytes. Aparte de esta información de los tipos primitivos, también se almacena información adicional o metadatos específicos de cada clase, como el nombre o los atributos, entre otros. Gracias a estos metadatos, que describen los objetos que guardamos, podemos automatizar la serialización de forma genérica, asegurándonos que posteriormente podremos leer los objetos.

La desventaja de este método es que al cambiar la definición de la clase (por ejemplo, añadiendo un atributo más o cambiando su tipo), los metadatos se modifican y no podríamos leer los objetos serializados con versiones anteriores de la clase. Además, también hay que tener en cuenta que éste es un mecanismo específico de Java y que no podremos consultar estos objetoses desde otros lenguajes.

Por todo ello, otras técnicas son preferibles para el almacenamiento permanente de objetos, que veremos más adelante, pero la serialización puede resultar útil para el almacenamiento temporal, dentro de la propia ejecución de la aplicación.

!!! note "¿Qué es esto?" 
**Investigación:** intenta encontrar información sobre ***SerialVersionUID*** y para qué es importante.

### 2.6.1. La interfaz `Serializable` y los `Decorators`

Si queremos que una clase sea serializable, debe implementar la interfaz `Serializable`, la cual tiene como único propósito actuar como marcador para indicar al JVM que la clase puede ser serializada, por tanto, esta clase no tendrá métodos.

Cabe decir que todas las clases correspondientes a los tipos básicos ya implementan la interfaz Serializable, así como la clase String, contenedores y Arrays. En el caso de las colecciones, depende de sus contenidos, si sus elementos son serializables, la colección también lo será. Si el objeto que queremos serializar o sus objetos no implementan la interfaz Serializable, se lanzará la excepción `NotSerializableException`.

Los decoradores `ObjectInputStream` y `ObjectOutputStream` nos ofrecen la capacidad de serializar cualquier objeto deserializable. Para escribir un objeto, haremos uso del método `writeObject` de `ObjectOutputStream`, y para leerlo haremos uso de `readObject` de `ObjectInputStream`.

!!!note "Ovejas con ovejas" 

Hay que tener en cuenta que la lectura de objetos debe realizarse en instancias de la misma clase que se guardó. De lo contrario, se lanzará una excepción `ClassCastException`. Además, es necesario tener el código compilado de la clase para evitar la excepción `ClassNotFoundException`. 

Además, `readObject` devuelve un Object, y necesitamos un objeto de una clase específica. Por este motivo, es necesario realizar una conversión de Object a la clase necesaria. Los conceptos de herencia son importantes para garantizar programas robustos.


### 2.6.2. Ejercicio resuelto

Empezando con la misma base de la clase `Moduls` del ejercicio anterior, crearemos una clase `Modul` para almacenar un único módulo. Este tipo de clases se conocen como POJO (Plain Old Java Objects) y están diseñadas sólo para almacenar información. (Aparecerá más adelante, junto con las clases BEAN).

Una vez creada la clase `Modul`, escribe un programa para guardar objetos directamente en un archivo. Después, escribe la función complementaria para leer todos los objetos almacenados en ese archivo.


!!! example "Solución" 

```java title="Modulo.java"
package org.example.pojo;

import java.io.Serializable;

public class Modulo implements Serializable {

    String nombre;
    int horas;
    double nota;

    public Modulo(){
// Constructor vacío
    }

    public Modulo(String nombre, int horas, double nota){
        this.nombre=nombre;
        this.horas=horas;
        this.nota=nota;
    }

    public String getModulo() {return this.nombre;}
    public int getHoras() {return this.horas;}
    public double getNota() {return this.nota;}


    /*
     Write and Read modules to/from file
     */




}
```

```java title="Modulo2.java"
package org.example.pojo;

import java.io.*;

public class Modulo2 {

    // Arrays with source data
    String[] modulos = {"Acceso a Datos", "Programación de servicios y procesos", "Desarrollo de interfaces", "Programación Multimedia y dispositivod móviles", "Sistemas de Gestión Empresarial", "Empresa e iniciativa emprendedora"};
    int[] horas = {6, 3, 6, 5, 5, 3};
    double[] notas = {8.45, 9.0, 8.0, 7.34, 8.2, 7.4};

    public void EscribeObjeto(String nombre) throws IOException {

        //destination file
        ObjectOutputStream f = new ObjectOutputStream(new FileOutputStream(nombre));

        Modulo m; // Single object

        // loop along the arrays
        for (int i = 0; i < this.modulos.length; i++) {
            m = new Modulo(this.modulos[i], this.horas[i], this.notas[i]);
            f.writeObject(m);
        }

        // close the file
        f.close();

    }

    public void LeeObjeto(String nombre) throws IOException, ClassNotFoundException {

        // input file
        ObjectInputStream f = new ObjectInputStream(new FileInputStream(nombre));

        Modulo m;
        // No se puede saber que hay objetos existentes en el archivo.
        try {
            while (true) { // forever

                m = (Modulo) f.readObject();

                // show the module
                System.out.println("Modul: " + m.getModul());
                System.out.println("Horas: " + m.getHores());
                System.out.println("Nota: " + m.getNota());
                System.out.println();

            }
        } catch (EOFException ex) {
            f.close();
        }

    }
}

```

```java title="Main.java"

package org.example;

import org.example.pojo.Modulo2;

import java.io.IOException;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) throws IOException, ClassNotFoundException {

        // test the args
        if (args.length != 2) {
            System.out.println("Número de argumentos incorrecto.\n\nSintaxis: \n\t java Moduls2 [ read | write ] archivo.obj");
            System.exit(0);
        }

        Modulo2 modulos = new Modulo2();

        // depending the args
        if (args[0].equals("read")) {
            modulos.LeeObjeto(args[1]);
        } else if (args[0].equals("write")) {
            modulos.EscribeObjeto(args[1]);
        } else {
            System.out.println("No entiendo el mandato " + args[0] + "\n");
        }

    }
}

```

!!! tip "Menos trabajo, pero al final lo mismo." 

    Probablemente lo pienses:

    - Si todo en Java hereda de Object, un ArrayList es un Object... ¿Puedo guardar o cargar un ArrayList completo en una sola llamada?
    - Pruébalo como una mejora del ejercicio anterior.

