# 3. Archivos XML

## 3.1. ¿Por qué XML?

Cuando queremos guardar datos que puedan ser leídos por distintas aplicaciones y plataformas, es mejor utilizar formatos de almacenamiento estándar que múltiples aplicaciones puedan entender (portabilidad). Un caso muy específico son los lenguajes de marcado, y el más conocido es el estándar XML (**eXtensible Markup Language**).

Con los documentos XML, estructuramos la información insertando marcas o etiquetas entre la información. Estas etiquetas tienen un inicio y un final, y pueden anidarse dentro de otros, así como contener información textual. el encabezamiento del documento la codificación utilizada para guardar el documento.

La forma de guardar información en XML, de forma jerárquica, es muy similar a la forma en que lo hacen los objetos en una aplicación, de manera que éstos se pueden traducir de manera relativamente conveniente en un documento XML.

|Módulo |

|---|-|---|

|Acceso a Datos | 6 |8.45 |

|Programación de servicios y procesos |3 |9.0|

|Desarrollo de interfaces |6 |8.0|

|Programación Multimedia y dispositivos móviles |5 |7.34|

|Sistemas de Gestión Empresarial |5 |8.2|

|Empresa e iniciativa emprendedora |3 |7.4|


puede representarse en etiquetas `xml`:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<curso>
    <modulo>
        <nombre>Acceso a Datos</nombre>
        <horas>6</horas>
        <calificacion>8.45</calificacion>
    </modulo>
    <modulo>
        <nombre>Programación de servicios y procesos</nombre>
        <horas>3</horas>
        <calificacion>9.0</calificacion>
    </modulo>
    <modulo>
        <nombre>Desarrollo de interfaces</nombre>
        <horas>6</horas>
        <calificacion>8.0</calificacion>
    </modulo>
    <modulo>
        <nombre>Programación Multimedia y dispositivos móviles</nombre>
        <horas>5</horas>
        <calificacion>7.34</calificacion>
    </modulo>
    <modulo>
        <nombre>Sistemas de Gestión Empresarial</nombre>
        <horas>5</horas>
        <calificacion>8.2</calificacion>
    </modulo>
    <modulo>
        <nombre>Empresa e iniciativa emprendedora</nombre>
        <horas>3</horas>
        <calificacion>7.4</calificacion>
    </modulo>
</curso>
```

o puede ser representado con etiquetas y atributos:

```xml
<curso> 
<modulo nombre="Acceso a Datos" horas="6" calificacion="8.45" > 
<modulo nombre="Programación de servicios y procesos" "horas"=3 calificacion="9.0" > 
<modulo nombre ="Desarrollo de interfaces" horas="6" calificacion="8.0" > 
</modulo> 
<modulo nombre="Programación Multimedia y dispositivod móviles" horas="5" calificacion="7,34"> 
<modulo nombre="Sistemas de Gestión Empresarial" horas="5" "calificacion"=8.2 /> 
<modulo nombre="Empresa e iniciativa emprendedora" horas="3" calificacion="7.4" /> 
</modulo>
</curso>
```
Un **analizador XML** es una clase que permite analizar un archivo XML y extraer información de él, relacionándola según su posición en la jerarquía. Los analizadores, según su forma de funcionar, pueden ser:

- Analizadores **secuenciales** o sintácticos, que extraen el contenido a medida que se descubren las etiquetas de apertura y cierre. Son muy rápidos, pero tienen el problema que hay que leer todo el documento para acceder a una parte específica.
- Analizadores **jerárquicos**, que son los más utilizados y que guardan todos los datos del documento XML en la memoria, en forma de una estructura jerárquica (**DOM** o Document Object Model), siendo los preferidos para aplicaciones que deben leer los datos de forma más continua.

## 3.2. El Modelo de Objetos de Documento (DOM)

El DOM (Document Object Model) es la estructura especificada por la W3C donde se almacena la información de los documentos XML. El DOM se ha relacionado principalmente con el mundo web, con HTML y Javascript como principales impulsores.

La interfaz principal del DOM en Java es `Document`, y representa el _documento XML completo_ Al ser una interfaz, se puede implementar en varias clases.

!!! note "Hay que tener en cuenta que..." 
Una interfaz es una especie de plantilla para construir clases y generalmente está compuesta por un conjunto de declaraciones de cabecera de métodos no implementados que especifican cómo se comportan una o más clases. Además, una clase puede implementar una o más interfaces. 

Hay que tener en cuenta que una interfaz no debe confundirse con una clase abstracta, ya que hay algunas diferencias. Por ejemplo, una interfaz tiene todos los métodos abstractos, no puede declarar variables de instancia, una clase puede implementar varias interfaces pero no heredatar de varias superclases, y una interfaz no debe pertenecer a ninguna jerarquía, por lo que las clases que no tienen ninguna relación de herencia pueden implementar la misma interfaz.


Aparte de `Document`, la W3C también define la clase abstracta `DocumentBuilder`, que permite crear el DOM a partir del XML. Además, se especifica la clase `DocumentBuilderFactory`, que nos permite fabricar `DocumentBuilders`, puesto que, al ser abstracta, no se puede instanciar directamente.

Cabe decir, como advertencia, que Java ofrece muchas librerías desde las que importar Document. Las librerías que utilizaremos para analizar XML serán:

- La librería `java.xml.parsers.*`, que ofrecerá las clases `DocumentBuilderFactory` y `DocumentBuilder`, y
- La librería `org.w3c.dom.*` para la clase `Document`.


### 3.2.1. `DocumentBuilder` y `DocumentBuilderFactory`

Como se ha dicho, `DocumentBuilder` define una API para obtener instancias DOM de un documento XML. Para obtener una instancia de la clase, se debe utilizar la clase `DocumentBuilderFactory`, y concretamente el método `newDocumentBuilder()`:

Por otra parte, para leer e interpretar el documento XML, la clase `DocumentBuilderFactory` proporciona el método `parse()`, que analiza un XML indicado por un archivo y devuelve un objeto `Document`.

Veremos todo esto con un ejemplo. Continuamos almacenando datos sobre los módulos del curso, pero ahora con XML. El siguiente método nos servirá para abrir un documento XML, analizarlo y devolver el DOM generado en un `Document`. Lo podemos utilizar en cualquier sitio de nuestros programas, ya que la tarea es siempre similar:

```java
    public Document OpenXML(String name) throws IOException, SAXException, ParserConfigurationException, FileNotFoundException {

        // Create an instance of DocumentBuilderFactory
        DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
        // Using the DocumentBuilderFactory instance we create a DocumentBuilder
        DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();

        return dBuilder.parse(new File(name));
    }
```

Hay que decir que la función anterior podría simplificarse sin utilizar las declaraciones intermedias, pero está algo ofuscada.


```java
public Document OpenXML(String name) throws IOException,SAXException, ParserConfigurationException, FileNotFoundException { 
return DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(name);
}
```

Por otra parte, la clase `DocumentBuilder` también nos permite crear un nuevo DOM con el método `newDocument()`. Esto nos servirá más adelante para almacenar nuevos documentos XML. El procedimiento es el siguiente:

- Ante todo, debemos crear un nuevo DOM con `newDocument()`.
- Añadir los elementos y,
- Luego almacenarlo en un archivo.

En secciones posteriores, veremos cómo hacer todo esto. Por ahora, nos centraremos en interpretar y leer el DOM.

Para más información, puedes consultar las clases [DocumentBuilder](http://cr.openjdk.java.net/~iris/se/11/latestSpec/api/java.xml/javax/xml/parsers/DocumentBuilder.html) y [DocumentBuilderFactory](http://cr.openjdk.java.net/~iris/se/11/latestSpec/api/java.xml/javax/xml/parsers/DocumentBuilderFactory.html) en el API de OpenJDK.

## 3.3. Clases y Métodos de DOM

Hasta ahora hemos visto cómo abrir y analizar un documento XML con `DocumentBuilder` para crear un objeto de tipo `Document`. En esta sección veremos cómo trabajar con este documento para acceder a los distintos elementos. Como sabemos, el DOM tiene una estructura jerárquica, formada por nodos. Los distintos tipos de nodos que podemos encontrar son:

- `Document` → que es el nodo principal y representa todo el XML.
- `Element` → que representa las diferentes etiquetas (incluyendo la etiqueta raíz). En otras palabras, todas las etiquetas son Elementos, unas dentro de otras.
- `TextElement` → que representa el contenido de una etiqueta de texto.
- `Attribute` → que representa los atributos.

Todas estas interfaces derivan de la interfaz `Node`, por tanto, heredarán sus atributos y métodos, y además, proporcionarán sus propios atributos y métodos.

A continuación, veremos los métodos más importantes de cada interfaz:

### 3.3.1. Métodos de Nodo

**Métodos relacionados con la obtención de información**

- `String getNodeName()` → Obtiene el nombre del nodo actual
- `short getNodeType()` → Obtiene el tipo de nodo (ELEMENT_NODE, ATTRIBUTE_NODE, TEXT_NODE...)
- `String getNodeValue()`→ Obtiene el valor del nodo
- `NodeList getChildNodes()` → Obtiene una lista con los nodos hijos
- `Node getFirstChild()` → Devuelve el primer hijo
- `Node getLastChild()` → Devuelve el último hijo
- `NamedNodeMap getAttributes()` → Devuelve una lista con los atributos del nodo
- `Node getParentNode()` → Devuelve el nodo padre
- `String getTextContent()` → Devuelve el texto contenido en el elemento y sus descendientes
- `boolean hasChildNodes()` → Devuelve `true` si el nodo tiene algún hijo
- `boolean hasAttributes()` →Devuelve `true` si el nodo tiene algún atributo

**Métodos relacionados con la escritura**

- `Node appendChild(Node node)` → Añade un nuevo nodo como último hijo.
- `void removeChild(Node node)` → Elimina el nodo especificado de los nodos hijos.


### 3.3.2. Métodos de la interfaces Elemento:

**Métodos relacionados con la obtención de información**

- `String getAttribute(String name)` → Devuelve el valor del atributo dado por el nombre.
- `NodeList getElementsByTagName(String name)` → Devuelve una lista de nodos hijos que coinciden con el nombre dado.
- `boolean hasAttribute(String name)` → Devuelve true si el elemento tiene el atributo dado.

**Métodos relacionados con la escritura**

- `void setAttribute(String name, String value)` → Añade un atributo al elemento, con el nombre y valor dados.
- `void removeAttribute(String name)` → Elimina el atributo indicado por el nombre.

### 3.3.3. Métodos de la interfaz Documento:

**Métodos relacionados con la obtención de información**

- `Element getDocumentElement()` → Devuelve el elemento raíz del documento.
- `NodeList getElementsByTagName(String name)` → Devuelve una lista de nodos hijos que coinciden con el nombre dado.

**Métodos relacionados con la escritura**

- `Element createElement(String name)` → Crea un elemento nuevo con el nombre dado.
- `Text createTextNode(String text)` → Crea un nuevo elemento de texto.
- `Node appendChild(Node node)` → Añade un nuevo nodo hijo.

Los objetos de tipo `NodeList`, que representan una lista de nodos, ofrecen el método `item(int index)` para acceder a los distintos nodos de la lista, indicando su orden.


## 3.4. Lectura de archivos XML

Vamos a repasar todos los conceptos de esta sección con una práctica. Crearemos una clase que incluya todos los métodos necesarios para abrir, leer, mostrar y escribir archivos XML. Trabajaremos con el documento de la sección anterior.

Para empezar a leer el documento, lo primero que deberemos hacer es obtener el elemento raíz del documento con `getDocumentElement()`, que devuelve un objeto de tipo `Element`. Recuerda que la variable _doc_ contiene todo el DOM, leído con el método explicado anteriormente:

```java
Elemento root = doc.getDocumentElement();
```

Con este elemento raíz, ya podemos mostrar todo su contenido con `getTextContent()`. Se mostrará en pantalla en formato de texto, sólo se imprimirá:

```java
System.out.println(root.getTextContent());
```

Pero lo que nos interesa es recorrer todo el DOM y acceder a sus elementos. Para ello, a partir de este elemento raíz, seguiremos los siguientes pasos:

1. Buscamos todos los tags `<modul>` con `getElementsByTagName`. Este método nos devuelve una lista de nodos (objeto de tipo `NodeList`).
2. Será necesario recorrer la lista de nodos (`NodeList`) para acceder a cada elemento. Para ello, es necesario utilizar el método `item(int index)`, que devolverá un elemento de tipo `Node`, y que debe convertirse explícitamente a `Element` con una operación de cast.
3. Para cada elemento, accederemos al nombre del nodo para mostrar el nombre y el orden, utilizando `getNodeName()`.
4. Buscamos las diferentes etiquetas encontradas dentro de cada módulo ('nombre', 'horas' y 'calificación') con `getElementsByTagName()`. Este método nos devolverá una NodeList para cada tipo de etiqueta. Como sólo tendremos un elemento, basta con acceder al elemento único, representado por `item(0)`.
5. Cabe destacar que con lo que hemos visto hasta ahora tendremos la primera (y única) etiqueta 'nombre', 'horas' o 'calificación' del módulo, pero todavía no estamos en el contenido, ya que esto es un elemento de tipo `TEXT_NODE`. Para acceder, deberemos acceder al primer hijo de la etiqueta (`getFirstChild()`) y obtener su valor con `getNodeValue()`.

```java 
// We will get a list of nodes (Step 1) 
NodeList modules = root.getElementsByTagName("modulo"); 

// For each node (Step 2) 
for (int i = 0; i < modules.getLength(); i++) { 
Elemento el = (Element) modules.item(i); 

// Display the node name (Step 3) 
System.out.println(el.getNodeName() + " " + (y + 1)); 

// And we show the value of the different tags 
System.out.println("Nombre: " + el.getElementsByTagName("nombre").item(0).getFirstChild().getNodeValue()); 
System.out.println("Horas: " + el.getElementsByTagName("horas").item(0).getFirstChild().getNodeValue()); 
System.out.println("Calificación: " + el.getElementsByTagName("calificacion").item(0).getFirstChild().getNodeValue()); 
System.out.println(); 
}
}
```

## 3.5. Escribir archivos XML

Ahora vamos a la parte de escritura de los documentos XML. Por eso, partiremos de un archivo que ya contiene la información en formato binario de los módulos (por ejemplo, de la sección anterior), lo leeremos e importaremos su información en formato XML.

Lo primero que debemos hacer es leer el archivo de objetos utilizando un `ObjectInputStream`:


```java
ObjectInputStream f = new ObjectInputStream(new FileInputStream(file));
```

Y crearemos un documento vacío con las clases `DocumentBuilder` y `DocumentBuilderFactory`:

```java
Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
```

Una vez tenemos el documento vacío, creamos el elemento raíz (curso) y lo añadimos al documento:

```java
Elemento root = doc.createElement("curso");
doc.appendChild(root);
```

Recuerda que accederemos al archivo de objetos, así que deberemos saber exactamente cómo es la clase que queremos leer y acceder a los métodos correspondientes para obtener información sobre ella. Por eso, primero, debes definir un objeto de tipo `Modul`, y leeremos el archivo de objetos con el método `readObject` de `File`. Una vez leído un objeto, crearemos la etiqueta que engloba cada uno de ellos: la etiqueta `modulo`:


```java
Módulo m = (Módulo) f.readObject();
Elemento modulo = doc.createElement("modulo");
```

And inside it, as we extract the different properties of the module object, we will create child nodes and add them to the module. Por ejemplo, para el módulo name:

```java
Elemento name = doc.createElement("nombre");
name.appendChild(doc.createTextNode(m.getNom()));
module.appendChild(name);
```

Como podemos ver, hemos creado un objeto de tipo Elemento con la etiqueta 'nombre', y hemos añadido como hijo un nodo de tipo texto (TEXT_NODE), que hemos extraído directamente del objeto `Modul m` con su propia función `getModul()`. Además, hemos añadido esta etiqueta a la etiqueta `<modul>`, con `appendChild`.

Deberemos hacer lo mismo para las horas de cada módulo y la calificación, pero por ello, deberemos tener en cuenta que los métodos getHores y getNota no devuelven una cadena de texto, sino un entero y un decimal, por lo que tendrán que ser convertidos a texto:


```java
Elemento hours = doc.createElement("horas");
hours.appendChild(doc.createTextNode(Integer.toString(m.getHores()))));
module.appendChild(hours);

Elemento calificación = doc.createElement("calificacion");
calification.appendChild(doc.createTextNode(Double.toString(m.getNote()))));
module.appendChild(grade);
```

Pondremos todo este procedimiento dentro de un bucle que recorrerá todo el archivo de objetos. Una vez hayamos leído cada uno de los módulos, deberemos añadirlos al elemento raíz con:

```java
root.appendChild(modulo);
```


And we will already have el XML documento en el root. No se debe convertir este objeto en el type `Element` en texto string en orden a la obtención de la vuelta y de la etiqueta. Para este, se debe utilizar el ``Transformer` utility.


### 3.5.1. Transformer

Java nos ofrece la utilidad `Transformer` para convertir información entre diferentes formatos jerárquicos, como el objeto Documento que contiene el DOM de nuestro XML, a un archivo de texto XML.

La clase `Transformer`, como `DocumentBuilder`, es también una clase abstracta, por lo que también requiere una fábrica para ser instanciada. La clase Transformer trabaja con dos tipos de adaptadores. Los adaptadores son clases que hacen compatibles distintas jerarquías. Estos adaptadores son `Source` y `Result`. Las clases que implementan estos adaptadores serán las encargadas de hacer compatibles los distintos tipos de contenedores con los que requiere la clase Transformer. Así, y para aclararlo, tenemos las clases `DOMSource`, `SAXSource` o `StreamSource`, que son adaptadores del contenedor de origen de la información para DOM, SAX o Stream; y `DOMResult`, `SAXResult` y `StreamResult` como adaptadores equivalentes para el contenedor de destino.

En nuestro caso, ya que tenemos un DOM y queremos convertirlo en un Stream, necesitaremos un `DomSource` y un `StreamResult`. Veremos el código necesario para ello:

```java
Transformer trans = TransformerFactory.newInstance().newTransformer();
DOMSource source = new DOMSource(doc);
StreamResult result = new StreamResult(new FileOutputStream(file+".xml"));
```

Lo primero que hemos hecho es crear un objeto de tipo `Transformer` con el método `newTransformer()` de una instancia (newInstance()) de la fábrica de Transformers TransformerFactory. A continuación, hemos definido la fuente (source) y el resultado (resultado) para la transformación, siendo la fuente un DomSource creado a partir del doc que contiene nuestro documento, y el resultado un StreamResult, que escribirá el flujo en el disco a través de un FileOutputStream.

Por último, hacemos la transformación de un elemento a otro, que generará automáticamente el archivo XML de salida:

```java
trans.transform(source, result);
```

## 3.6. Técnicas avanzadas: vinculación XML

La técnica de vinculación consiste en generar clases Java con formatos específicos, como XML, de modo que cada etiqueta o atributo XML corresponda a una propiedad de una determinada clase. Esta correspondencia se llama **mapeo**.

En Java, existen diferentes librerías para la vinculación o mapeo: JAXB, JuBX, XMLBinding, etc. JAXB (Java Architecture for XML Binding) es una potente librería que se ha incluido en el estándar desde JDK 6, pero se ha eliminado en la versión 11 y se sugiere incluirla como paquete externo. JAXB utiliza anotaciones para obtener la información necesaria para el mapeo de la vinculación.Las anotaciones son indicaciones especiales de Java que permiten asociar información y funcionalidad a los objetos, sin interferir en la estructura del modelo de datos. Las anotaciones pueden asociarse con un paquete, una clase, un atributo o un parámetro, y se declaran con el símbolo `@` delante del nombre de la anotación. Cuando el compilador detecta una anotación, crea una instancia y la inyecta en el elemento afectado, sin interferir en la clase misma. Cuando una aplicación necesita la información de las anotaciones, puede obtener la instancia inyectada.

Por ejemplo, en la clase `Modul` que habíamos definido, utilizaríamos la anotación `@XmlRootElement` para indicar el elemento raíz del módulo, y las anotaciones `@XmlElement` para indicar que los setters de la clase también escribirán elementos XML.

```java
@XmlRootElement
class Modulo { 

String nombre; 
int horas; 
double nota; 

public String getNom() { return nombre; } 
@XmlElement 
public void setNom(String nombre) { this.nom = nombre; } 


public int getHores() { return horas; } 
@XmlElement 
public void setHores(int horas) { this.hores = horas; } 

public double getNota() { return nota; } 
@XmlElement 
public void setNota(double nota) { this.nota = nota;}


}
```

Con esto tendríamos sólo la clase con las anotaciones preparadas para guardar un módulo como documento XML. Para guardar toda la jerarquía deberíamos crear la clase `Curso`, que contendría un `ArrayList` de módulos.

## 3.7. Ejemplos con el XML inicial

📖 Ejemplo 1: Lectura de XML con DOM

```java
package org.dam;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import java.io.File;

public class LecturaCursoXML {
    public static void main(String[] args) {
        try {
            File archivo = new File("curso.xml");
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document document = builder.parse(archivo);

            document.getDocumentElement().normalize();

            System.out.println("Elemento raíz: " + document.getDocumentElement().getNodeName());

            NodeList listaModulos = document.getElementsByTagName("modulo");

            System.out.println("\n=== MÓDULOS DEL CURSO ===");
            System.out.printf("%-45s %-8s %-12s%n", "Nombre", "Horas", "Calificación");
            System.out.println("--------------------------------------------------------------");

            for (int i = 0; i < listaModulos.getLength(); i++) {
                Node nodo = listaModulos.item(i);

                if (nodo.getNodeType() == Node.ELEMENT_NODE) {
                    Element elemento = (Element) nodo;

                    String nombre = elemento.getElementsByTagName("nombre").item(0).getTextContent();
                    String horas = elemento.getElementsByTagName("horas").item(0).getTextContent();
                    String calificacion = elemento.getElementsByTagName("calificacion").item(0).getTextContent();

                    System.out.printf("%-45s %-8s %-12s%n",
                            nombre.length() > 40 ? nombre.substring(0, 40) + "..." : nombre,
                            horas,
                            calificacion);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}   

```

📝 Ejemplo 2: Escritura de XML con DOM

```java
package org.dam;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import java.io.File;

public class EscrituraCursoXML {
    public static void main(String[] args) {
        try {
            // Crear el DocumentBuilder
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document document = builder.newDocument();

            // Crear el elemento raíz <curso>
            Element curso = document.createElement("curso");
            document.appendChild(curso);

            // Crear módulos según la estructura proporcionada
            crearModulo(document, curso, "Acceso a Datos", 6, 8.45);
            crearModulo(document, curso, "Programación de servicios y procesos", 3, 9.0);
            crearModulo(document, curso, "Desarrollo de interfaces", 6, 8.0);
            crearModulo(document, curso, "Programación Multimedia y dispositivos móviles", 5, 7.34);
            crearModulo(document, curso, "Sistemas de Gestión Empresarial", 5, 8.2);
            crearModulo(document, curso, "Empresa e iniciativa emprendedora", 3, 7.4);

            // Escribir el contenido en un archivo XML
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            transformer.setOutputProperty(javax.xml.transform.OutputKeys.INDENT, "yes");
            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");

            DOMSource source = new DOMSource(document);
            StreamResult result = new StreamResult(new File("curso.xml"));

            transformer.transform(source, result);

            System.out.println("Archivo XML creado correctamente!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void crearModulo(Document document, Element curso, String nombre,
                                    int horas, double calificacion) {
        Element modulo = document.createElement("modulo");
        curso.appendChild(modulo);

        Element nom = document.createElement("nombre");
        nom.appendChild(document.createTextNode(nombre));
        modulo.appendChild(nom);

        Element horasElem = document.createElement("horas");
        horasElem.appendChild(document.createTextNode(String.valueOf(horas)));
        modulo.appendChild(horasElem);

        Element calificacionElem = document.createElement("calificacion");
        calificacionElem.appendChild(document.createTextNode(String.valueOf(calificacion)));
        modulo.appendChild(calificacionElem);
    }
}

```

🏗️ Ejemplo 3: JAXB - Escritura y Lectura

Clase Modulo para JAXB:

```java
package org.dam;
import jakarta.xml.bind.annotation.XmlElement;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlType;

@XmlRootElement(name = "módulo")
@XmlType(propOrder = {"nombre", "horas", "calificacion"})
public class Modulo {
    private String nombre;
    private int horas;
    private double calificacion;

    public Modulo() {
        // Constructor por defecto necesario para JAXB
    }

    public Modulo(String nombre, int horas, double calificacion) {
        this.nombre = nombre;
        this.horas = horas;
        this.calificacion = calificacion;
    }

    @XmlElement(name = "nom")
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    @XmlElement(name = "horas")
    public int getHoras() { return horas; }
    public void setHoras(int horas) { this.horas = horas; }

    @XmlElement(name = "calificación")
    public double getCalificacion() { return calificacion; }
    public void setCalificacion(double calificacion) { this.calificacion = calificacion; }

    @Override
    public String toString() {
        return String.format("%-40s %d horas - %.2f",
                nombre.length() > 35 ? nombre.substring(0, 35) + "..." : nombre,
                horas, calificacion);
    }
}

```
Clase Curso para JAXB:

```java
package org.dam;

import jakarta.xml.bind.annotation.XmlElement;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.util.ArrayList;
import java.util.List;

@XmlRootElement(name = "curso")
public class Curso {
    private List<Modulo> modulos = new ArrayList<>();

    @XmlElement(name = "modulo")
    public List<Modulo> getModulos() { return modulos; }
    public void setModulos(List<Modulo> modulos) { this.modulos = modulos; }

    public void addModulo(Modulo modulo) {
        modulos.add(modulo);
    }
}

```

Escritura con JAXB:

```java
package org.dam;

import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.Marshaller;
import java.io.File;

public class EscrituraJAXBCurso {
    public static void main(String[] args) {
        try {
            // Crear el curso con módulos
            Curso curso = new Curso();
            curso.addModulo(new Modulo("Acceso a Datos", 6, 8.45));
            curso.addModulo(new Modulo("Programación de servicios y procesos", 3, 9.0));
            curso.addModulo(new Modulo("Desarrollo de interfaces", 6, 8.0));
            curso.addModulo(new Modulo("Programación Multimedia y dispositivos móviles", 5, 7.34));
            curso.addModulo(new Modulo("Sistemas de Gestión Empresarial", 5, 8.2));
            curso.addModulo(new Modulo("Empresa e iniciativa emprendedora", 3, 7.4));

            // Configurar JAXB
            JAXBContext context = JAXBContext.newInstance(Curso.class);
            Marshaller marshaller = context.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
            marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");

            // Escribir en archivo
            marshaller.marshal(curso, new File("curso_jaxb.xml"));
            System.out.println("XML creado con JAXB exitosamente!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

```

Lectura con JAXB:

```java
package org.dam;

import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.Unmarshaller;
import java.io.File;

public class LecturaJAXBCurso {
    public static void main(String[] args) {
        try {
            JAXBContext context = JAXBContext.newInstance(Curso.class);
            Unmarshaller unmarshaller = context.createUnmarshaller();

            Curso curso = (Curso) unmarshaller.unmarshal(new File("curso_jaxb.xml"));

            System.out.println("=== MÓDULOS DEL CURSO (JAXB) ===");
            System.out.printf("%-45s %-8s %-12s%n", "Nombre", "Horas", "Calificación");
            System.out.println("--------------------------------------------------------------");

            for (Modulo modulo : curso.getModulos()) {
                System.out.println(modulo);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

```
Recuerda añadir la dependencia de jakarta en el pom.xml

```xml
        <!-- https://mvnrepository.com/artifact/jakarta.xml.bind/jakarta.xml.bind-api -->
        <dependency>
            <groupId>jakarta.xml.bind</groupId>
            <artifactId>jakarta.xml.bind-api</artifactId>
            <version>4.0.2</version>
        </dependency>

```


Por lo que se refiere a este curso, no profundizaremos más en esta técnica, ya que para nuestros propósitos, el análisis XML que hemos visto en las secciones anteriores es suficiente, o no :)

!!! note "Cada vez más" 
Utilizaremos muchas anotaciones en este curso, mantenga la calma...