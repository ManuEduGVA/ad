# 7. De filas a Objetos

Finalmente, para cerrar la unidad, trabajaremos de forma natural: recuperaremos datos de la base de datos, crearemos objetos a partir del ResultSet y guardaremos los datos en la base de datos.

Estudiaremos una nueva forma de crear nuestros POJO (y BEAN), utilizando una librería moderna llamada Lombok.

## 7.1. POJO, BEAN y Proyecto Lombok

Debemos crear clases según nuestro modelo orientado a objetos. Dependiendo de cómo hayamos dado las clases, pueden ser POJO o BEAN u otro tipo de clases. Vamos a entenderlo (extraído de aquí: [enlace](https://www.geeksforgeeks.org/pojo-vs-java-beans/)).

### 7.1.1. POJO

Esto significa Plain Old Java Object. Es una clase que:

- No debe extender ninguna clase.
- No debe implementar ninguna interfaz.
- No debe contener anotaciones específicas.

No existen restricciones en los modificadores de acceso de los campos. Pueden ser privados, por defecto, protegidos o públicos. Tampoco es necesario incluir ningún constructor en éste.

Un ejemplo de POJO sería, por ejemplo:

```java
// AS POJO
public class Modul { 
// atributos 
String nombre; 
int horas; 
double nota; 
// constructor 
public Modul(String nombre, int horas, double nota) { 
this.nombre = nombre; 
this.horas = horas; 
this.nota = nota; 
} 
// getters 
public String getModul(){return this.nombre;} 
public int getHores() {return this.hores;} 
public double getNota() {return this.nota;} 

@Override 
public String toString() { 
return "Modul{" + "nombre=" + nombre + ", horas=" + horas + ", nota=" + nota + '}'; 
}
}
```

Como puede ver, un POJO es la mínima clase que podemos hacer.


### 7.1.2. BEAN

Los Beans son un tipo especial de POJO. Hay algunas restricciones para que un POJO sea un Bean.

- Todos los JavaBeans son POJOs, pero no todos los POJOs son JavaBeans.
- `Serializable`, deben implementar la interfaz Serializable. Sin embargo, algunos POJOs que no implementan la interfaz Serializable se llaman POJOs porque Serializable es una interfaz marcadora y, por tanto, no supone una carga excesiva.
- Los campos deben ser privados. Esto proporciona un control completo sobre los campos.
- Los campos deben tener getters o setters o ambos.
- Debe haber un constructor sin argumentos en un Bean.
- Los campos sólo se acceden mediante constructor o getters y setters.

```java
// AS POJO
public class Modul { 
// atributos 
private String nombre; 
private int horas; 
private double nota; 
// constructor 
public Modul() { } 
// getters 
public String getModul(){return this.nombre;} 
public int getHores() {return this.hores;} 
public double getNota() {return this.nota;}
// setters 
public void getModul(){return this.nombre;} 
public void getHores() {return this.hores;} 
public void getNota() {return this.nota;} 

@Override 
public String toString() { 
return "Modul{" + "nombre=" + nombre + ", horas=" + horas + ", nota=" + nota + '}'; 
}
}
```

Para resumir, las clases POJO y Beans se utilizan para definir objetos Java para aumentar su legibilidad y reutilización. Los POJOs no tienen otras restricciones mientras que los beans son POJOs especiales con algunas restricciones.

### 7.1.3. Lombok

Independientemente de si utilizamos POJO o BEAN, hay algunas tareas repetitivas que debemos realizar para crear nuestras clases. La mayoría de estas tareas son implementadas por los IDE, como crear getters, setters, encapsular campos, crear constructores, etc. Project Lombok es una librería que evita realizar estas tareas repetitivas, y decimos lo que queremos y la librería y el compilador hacen el resto.

En este enlace [configuración de Lombok](https://projectlombok.org/setup/) encontrarás cómo configurar la librería en cada gestor de proyectos (gradle, maven, etc.) y en cada IDE (Netbeans, Eclipse, IntelliJ, etc.).

Una vez instalada, basta con decir mediante anotaciones lo que quieres:

- `@Getter` → generará todos los getters.
- `@Setter` → generará todos los setters.
- `@Data` → todos los métodos que necesitan un POJO, incluyendo `ToString`.
- `@AllArgsConstructor` o `@NoArgsConstructor` → generará el constructor que quieras.

En el siguiente [vídeo](https://youtu.be/Ot_4SbEpZMA) se explica cómo añadir la dependencia de Gradle y utilizar Lombok.

## 7.2. Cargando objetos

Vamos a finalizar con un ejemplo:

### 7.2.1. Clase Persona

Esta clase es el POJO de una persona. Creará getters, setters, toString y los métodos principales con sólo unas pocas líneas y algunas anotaciones.


```java
@Fecha
@AllArgsConstructor
@NoArgsConstructor
public class Persona { 
private int idPersona; 
private String número; 
private String cogidos; 
private int edad;
}
```

Hay que tener en cuenta que con Lombok el trabajo resulta fácil.

### 7.2.2. Llenando un Array

Para llenar una estructura de datos desde la base de datos, primero es necesario obtener los datos. Es necesario crear el objeto `Statement` o `PreparedStatement` y ejecutar la consulta.

La tarea principal es transformar el `ResultSet` en una lista, pero es una tarea sencilla:

- Recorre el ResultSet (con next), y para cada fila: 
- Crea un objeto con los valores almacenados en las columnas 
- Añade este objeto a la lista

```java
ArrayList<Persona> lasPersonas= new ArrayList();

ConnexioDB conDB=new ConnexioDB("Instituto");

Connection con=conDB.getConnexio();

String SQL="Select * from Persona" ;
// The statement
Statement st=con.createStatement( 
ResultSet.TYPE_SCROLL_INSENSITIVE, 
ResultSet.CONCUR_READ_ONLY);

// The execution
ResultSet rst=st.executeQuery(SQL);

if (!rst.next()){ 
System.out.println("No people in DB");
}
else{ 
rst.beforeFirst(); 
while(rst.next()){ 
Persona p= new Persona( 
rst.getInt(1), 
rst.getString(2), 
rst.getString(3), 
rst.getInt(4)); 
System.out.println("Adding" +p); 
lasPersonas.add(p); 
}
}

System.out.println("Added " + lasPersonas.size() + " people");
rst.close();
```

Ahora podrás cambiar la información en los objetos y, finalmente, si se ha realizado alguna modificación, deberás guardarla en la base de datos. Las preguntas son:

- ¿Cómo puedo saber si se ha actualizado un objeto?
- ¿Cómo puedo saber qué campo debe guardarse?

Como puedes ver, existen varias tareas que requieren un control de la modificación de los datos y cómo guardarlos. Esta tarea será fácil con ORM y la estudiaremos.