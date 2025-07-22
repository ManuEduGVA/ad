# Sistema de archivos

## `ls -la`

En este ejercicio, implementaremos una versión optimizada del programa [`ls`](https://man7.org/linux/man-pages/man1/ls.1.html). Listará un directorio en un modo de vista específico. Tanto el directorio como la vista se indicarán al iniciar el programa.

El modo de vista puede ser lista, columnas o tabla:

- **Lista** $\rightarrow$ Los nombres de los archivos se muestran uno encima del otro. - **Columnas** $\rightarrow$ Igual que una lista, pero en varias columnas.
- **Tabla** $\rightarrow$ Se mostrará la información del archivo, con este patrón: `DFRWH name size mod_data`:
- `D` $\rightarrow$ es un directorio.
- `F` $\rightarrow$ es un archivo.
- `R` $\rightarrow$ podemos leer el archivo.
- `W` $\rightarrow$ podemos escribir el archivo.
- `H` $\rightarrow$ el archivo está oculto.

#### Envío

Un solo archivo `.java` con el programa. Para facilitarte la tarea, aquí tienes código para formatear una lista de cadenas en columnas. Se debe inicializar `MAX_FILES_BY_COLUMN = 4`.

```java
public static void ListaColumnas(String[] filenames){
int columnas = (filenames.length / MAX_FILES_BY_COLUMN)+1; String[][] salida = new String[MAX_FILES_BY_COLUMN][columnas];
for (int i=0;i<filenames.length;i++){
salida[i % MAX_FILES_BY_COLUMN][i / MAX_FILES_BY_COLUMN]=
filenames[i];
}
//bucle para mostrar salida ls
for (int i=0;i<MAX_FILES_BY_COLUMN;i++){
for (int j=0; j<columnas;j++)
System.out.print(salida[i][j] + " - ");
System.out.println(" /n");
}
}
```

## Archivos ocultos

Escribe un programa Java que encuentre todos los archivos ocultos de un directorio y sus subdirectorios recursivamente.

## Archivo más grande

Escribe un programa Java para encontrar el archivo más grande de un conjunto de archivos en un directorio.

# Archivos de texto

## ¿Cuántas vocales?

Escribe un programa que reciba el nombre de un archivo de texto y una vocal. El programa mostrará el número de veces que aparece esa vocal en el archivo.

## `tail` y `head`

Escribe tu propia versión de tail y head en las utilidades GNU. Puedes encontrar información en:

- [tail](https://man7.org/linux/man-pages/man1/tail.1.html)
- [head](https://man7.org/linux/man-pages/man1/head.1.html)

:::nota

Recuerda que estos programas muestran las últimas y las primeras diez líneas por defecto. Si quieres modificarlo, puedes usar `-nX`, donde X es el número de líneas que quieres mostrar. :::

# Archivos binarios

## Calcular el tamaño de un archivo de imagen (**HARD**)

Según la especificación de imágenes bmp o png, como se puede ver:

- [Especificación BMP](https://en.wikipedia.org/wiki/BMP_file_format)
- [Especificación PNG](https://en.wikipedia.org/wiki/Portable_Network_Graphics)

Escribir un programa que reciba el nombre de un archivo png o bmp y devuelva el ancho y el alto de la imagen.

# Archivos CSV

Crear una función para mostrar un archivo CSV, según los siguientes requisitos:

- Debemos indicar a la función el carácter separador.
- Debemos indicar a la función si el CSV tiene una línea de encabezado o no.
- (Mejora) La función debe calcular el tamaño máximo de columna para cada línea y mostrar cada columna con el tamaño calculado previamente, como MySQL muestra sus tablas.

En la plataforma encontrarás archivos CSV con los nombres de los jugadores de la MLB, pero puedes elegir el archivo que prefieras.

# Archivos XML

En la plataforma encontrarás un archivo llamado `monaco2017.xml` con mucha información sobre la carrera del campeonato de F1 2017 en Mónaco. Además de otra información, encontramos:

```xml
<Result number="5" position="1" positionText="1" points="25">
<Driver driverId="vettel" code="VET" url="http://en.wikipedia.org/wiki/Sebastian_Vettel">
<PermanentNumber>5</PermanentNumber>
<GivenName>Sebastian</GivenName>
<FamilyName>Vettel</FamilyName>
<DateOfBirth>1987-07-03</DateOfBirth>
<Nationality>German</Nationality>
</Driver>
<Constructor constructorId="ferrari" url="http://en.wikipedia.org/wiki/Scuderia_Ferrari">
<Name>Ferrari</Name>
<Nationality>Italian</Nationality>
</Constructor>
<Grid>2</Grid>
<Laps>78</Laps>
<Status statusId="1">Finished</Status>
<Time millis="6284340">1:44:44.340</Time>
<FastestLap rank="2" lap="38">
<Time>1:15.238</Time>
<AverageSpeed units="kph">159.669</AverageSpeed>
</FastestLap>
</Result>
```

Dentro del `Result`, encontraremos como atributos el número del piloto (atributo `number`) y la posición en la que terminó la carrera (`position`). Además, encontraremos los siguientes elementos:

- Piloto: información sobre el piloto.
- Fabricante: información sobre la marca del coche.
- Parrilla: posición en la que el piloto ha salido.
- Laps: vueltas completadas.
- Estado: indica con el atributo `statusID=1` que el piloto terminó la carrera. - Tiempo: indica el tiempo que tardó la carrera (en milisegundos) en completarse, y en su valor, la diferencia con respecto a los primeros.
- VueltaRápida: indica la clasificación con respecto a la vuelta rápida en su atributo de rango.

En la plataforma encontrarás:

- Clase de piloto: implementación completaemented, que necesita la parte del controlador del XML para crear un objeto Driver.
- ResultadoCarrera: parcialmente implementado, con los siguientes atributos:

```java
private Driver d;
private String constructor;
private int initialPos;
private int finalPos;
private long timeMillis;
private int completedLaps;
private int rankFastesLap;
private boolean finisher;
```

Complete el programa añadiendo:

- `Constructor(Element result)`, que recibe un elemento XML.
- `public String toCSV()`, que devuelve todos los campos separados por `;`.
- `public ArrayList<ResultadoCarrera> carregaResultadosXML(String nomXML)`, que recibe el nombre del archivo XML y carga todos los resultados. - `public void saveAsCSV(String nomFitxer, ArrayList<ResultadoCarrera> elsResultats)`, que guardará en un archivo de texto csv los resultados cargados previamente.

# Archivos JSON

En la plataforma encontrarás un archivo llamado `SW.json`. Este recupera información sobre los personajes de la famosa saga. Escribe un programa para obtener:

- Personajes que no condujeron ningún vehículo.
- Lista de personajes, ordenados por número de películas en las que aparecen.
- Crea un archivo XML como este, con un breve resumen:

```xml
<character films="4" vehicle="0">
<name>Luke Skywalker</name>
<mass>77</mass>
<url>https://swapi.dev/api/people/1/</url>
</character>
```

Comencemos el curso experimentando con bases de datos y programas para repasar todos los conceptos necesarios para comenzar con los temas principales con una base sólida.
<!--

# Enlaces

- $\rightarrow$
- $\rightarrow$
- $\rightarrow$

-->