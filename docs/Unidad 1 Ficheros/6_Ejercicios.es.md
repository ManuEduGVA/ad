# Ejercicios sistema de archivos

## `ls -la`

En este ejercicio, implementaremos una versión optimizada del programa [`ls`](https://man7.org/linux/man-pages/man1/ls.1.html). Listará un directorio en un modo de vista específico. Tanto el directorio como la vista se indicarán al iniciar el programa.

El modo de vista puede ser lista, columnas o tabla:

- **Lista** &rarr; Los nombres de los archivos se muestran uno encima del otro. 
- **Columnas** &rarr; Igual que una lista, pero en varias columnas.
- **Tabla** &rarr; Se mostrará la información del archivo, con este patrón: `DFRWH name size mod_data`:
- `D` &rarr; es un directorio.
- `F` &rarr; es un archivo.
- `R` &rarr; podemos leer el archivo.
- `W` &rarr; podemos escribir el archivo.
- `H` &rarr; el archivo está oculto.

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

!!! nota

    Recuerda que estos programas muestran las últimas y las primeras diez líneas por defecto. Si quieres modificarlo, puedes usar `-nX`, donde X es el número de líneas que quieres mostrar.

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

En la plataforma encontrarás un archivo llamado `monaco2023.xml` con mucha información sobre la carrera del campeonato de F1 2023 en Mónaco. Además de otra información, encontramos:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<granPremio>
    <nombre>Gran Premio de Mónaco</nombre>
    <año>2023</año>
    <fecha>2023-05-28</fecha>
    <circuito>
        <nombre>Circuito de Mónaco</nombre>
        <ubicacion>Montecarlo, Mónaco</ubicacion>
        <longitud>3.337 km</longitud>
        <vueltas>78</vueltas>
        <distanciaTotal>260.286 km</distanciaTotal>
        <recordVuelta>1:12.909 (Lewis Hamilton, 2021)</recordVuelta>
    </circuito>
    
    <clasificacion>
        <piloto>
            <posicion>1</posicion>
            <nombre>Max Verstappen</nombre>
            <equipo>Red Bull Racing</equipo>
            <tiempo>1:11.365</tiempo>
        </piloto>
        <piloto>
            <posicion>2</posicion>
            <nombre>Fernando Alonso</nombre>
            <equipo>Aston Martin</equipo>
            <tiempo>1:11.449</tiempo>
        </piloto>
        <piloto>
            <posicion>3</posicion>
            <nombre>Esteban Ocon</nombre>
            <equipo>Alpine</equipo>
            <tiempo>1:11.553</tiempo>
        </piloto>
        <piloto>
            <posicion>4</posicion>
            <nombre>Carlos Sainz</nombre>
            <equipo>Ferrari</equipo>
            <tiempo>1:11.630</tiempo>
        </piloto>
        <piloto>
            <posicion>5</posicion>
            <nombre>Lewis Hamilton</nombre>
            <equipo>Mercedes</equipo>
            <tiempo>1:11.725</tiempo>
        </piloto>
    </clasificacion>
    
    <carrera>
        <resultado>
            <posicion>1</posicion>
            <nombre>Max Verstappen</nombre>
            <equipo>Red Bull Racing</equipo>
            <vueltas>78</vueltas>
            <tiempo>1:48:51.980</tiempo>
            <puntos>25</puntos>
        </resultado>
        <resultado>
            <posicion>2</posicion>
            <nombre>Fernando Alonso</nombre>
            <equipo>Aston Martin</equipo>
            <vueltas>78</vueltas>
            <tiempo>+27.921</tiempo>
            <puntos>18</puntos>
        </resultado>
        <resultado>
            <posicion>3</posicion>
            <nombre>Esteban Ocon</nombre>
            <equipo>Alpine</equipo>
            <vueltas>78</vueltas>
            <tiempo>+36.990</tiempo>
            <puntos>15</puntos>
        </resultado>
        <resultado>
            <posicion>4</posicion>
            <nombre>Lewis Hamilton</nombre>
            <equipo>Mercedes</equipo>
            <vueltas>78</vueltas>
            <tiempo>+39.062</tiempo>
            <puntos>12</puntos>
        </resultado>
        <resultado>
            <posicion>5</posicion>
            <nombre>George Russell</nombre>
            <equipo>Mercedes</equipo>
            <vueltas>78</vueltas>
            <tiempo>+56.284</tiempo>
            <puntos>10</puntos>
        </resultado>
    </carrera>
    
    <vueltaRapida>
        <piloto>Lewis Hamilton</piloto>
        <equipo>Mercedes</equipo>
        <tiempo>1:15.650</tiempo>
        <vuelta>33</vuelta>
    </vueltaRapida>
    
    <abandonos>
        <abandono>
            <piloto>Charles Leclerc</piloto>
            <equipo>Ferrari</equipo>
            <vuelta>53</vuelta>
            <causa>Daños por colisión</causa>
        </abandono>
        <abandono>
            <piloto>Nyck de Vries</piloto>
            <equipo>AlphaTauri</equipo>
            <vuelta>41</vuelta>
            <causa>Problemas mecánicos</causa>
        </abandono>
    </abandonos>
    
    <clasificacionMundialPilotos>
        <piloto>
            <posicion>1</posicion>
            <nombre>Max Verstappen</nombre>
            <puntos>144</puntos>
            <equipo>Red Bull Racing</equipo>
        </piloto>
        <piloto>
            <posicion>2</posicion>
            <nombre>Sergio Pérez</nombre>
            <puntos>105</puntos>
            <equipo>Red Bull Racing</equipo>
        </piloto>
        <piloto>
            <posicion>3</posicion>
            <nombre>Fernando Alonso</nombre>
            <puntos>93</puntos>
            <equipo>Aston Martin</equipo>
        </piloto>
    </clasificacionMundialPilotos>
    
    <clasificacionMundialConstructores>
        <equipo>
            <posicion>1</posicion>
            <nombre>Red Bull Racing</nombre>
            <puntos>249</puntos>
        </equipo>
        <equipo>
            <posicion>2</posicion>
            <nombre>Aston Martin</nombre>
            <puntos>120</puntos>
        </equipo>
        <equipo>
            <posicion>3</posicion>
            <nombre>Mercedes</nombre>
            <puntos>119</puntos>
        </equipo>
    </clasificacionMundialConstructores>
    
    <clima>
        <temperaturaAmbiente>24°C</temperaturaAmbiente>
        <temperaturaPista>42°C</temperaturaPista>
        <humedad>65%</humedad>
        <condiciones>Soleado</condiciones>
    </clima>
    
    <curiosidades>
        <curiosidad>Fernando Alonso consiguió su primer podio en Mónaco desde 2010</curiosidad>
        <curiosidad>Esteban Ocon logró su segundo podio en la Fórmula 1</curiosidad>
        <curiosidad>Red Bull Racing extendió su racha de victorias a 6 carreras</curiosidad>
        <curiosidad>Primera vez que Alpine y Aston Martin comparten podio</curiosidad>
    </curiosidades>
</granPremio>
```

Dentro de `resultado`, en `carrera` encontraremos como posicion (atributo `posicion`) que determinará la posición en la que acabó en la carrera. Además, encontraremos los siguientes elementos:

- nombre: nombre del piloto.
- equipo: información sobre la marca del coche.
- vueltas: vueltas completadas.
- tiempo: tiempo en completar la carrera.
- puntos: puntos obtenidos por el piloto.

En la plataforma encontrarás:

- Clase Carrera: Implementación completa, que necesita la parte del controlador del XML para crear un objeto Carrera.


```java

    private int posicion;
    private String nombre;
    private String equipo;
    private int vueltas;
    private String tiempo;
    private int puntos;

```

- Clase Competicion: Esta no tendrá constructor, constructor por defecto. Para esta se deberá implementar lo siguiente:


    - `Constructor(Element result)`, que recibe un elemento XML.
    - `public String toCSV()`, que devuelve todos los campos separados por `;`.
    - `public ArrayList<ResultadoCarrera> carregaResultadosXML(String nomXML)`, que recibe el nombre del archivo XML y carga todos los resultados. 
    - `public void saveAsCSV(String nomFitxer, ArrayList<ResultadoCarrera> elsResultats)`, que guardará en un archivo de texto csv los resultados cargados previamente.

- La clase del programa principal ya se proporciona implementada.

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