## 📋 Descripción General

Desarrolla un programa en Java para gestionar información de alumnos mediante un sistema que utilice diferentes tipos de almacenamiento de datos. El programa deberá ser invocado desde la línea de comandos y permitirá trabajar con ficheros de texto y ficheros de objetos.

## 🎯 Objetivos

- Practicar el uso de argumentos en la línea de comandos
- Implementar serialización de objetos en Java
- Manejar diferentes tipos de almacenamiento (texto vs objetos)
- Desarrollar un diseño modular y mantenible
- Gestionar operaciones de entrada/salida con ficheros

## 📝 Requisitos Funcionales

### 1. Línea de Comandos

El programa debe aceptar tres argumentos:

- Primer argumento: opción a ejecutar (1, 2 o 3)
- Segundo argumento: ruta al fichero de texto
- Tercer argumento: ruta al fichero de objetos

### 2. Opciones del Programa

#### Opción 1: Introducción de Datos

- Permitir introducir datos de alumnos por pantalla
- Los datos a recoger: nombre, apellidos, NIA y clase
- Almacenar la información en un fichero de texto
- Usar un formato con separadores (ej: campos separados por ";")

#### Opción 2: Conversión a Objetos

- Leer los datos del fichero de texto
- Convertir cada registro en un objeto de tipo Alumno
- Almacenar los objetos en un fichero de objetos (serialización)
- **Eliminar el contenido del fichero de texto** después de la conversión
- Los nuevos objetos se deben añadir a los existentes en el fichero de objetos

#### Opción 3: Listado de Objetos

- Leer todos los objetos del fichero de objetos
- Mostrar por pantalla la información de todos los alumnos almacenados
- Incluir un contador del total de alumnos

### 3. Clase Alumno

- Debe implementar la interfaz Serializable
- Atributos: nombre, apellidos, NIA, clase
- Constructor que acepte todos los atributos
- Métodos getters y setters
- Método toString() para representación textual

## 🏗️ Requisitos Técnicos

### Diseño Modular

- Separar la funcionalidad en métodos independientes
- Cada método debe tener una responsabilidad única
- Manejo adecuado de excepciones

### Gestión de Ficheros

- Para texto: usar FileWriter, PrintWriter, BufferedReader
- Para objetos: usar ObjectOutputStream y ObjectInputStream
- Verificar existencia de ficheros antes de operar con ellos

### Flujo de Datos

```text
 qEntrada por teclado → Fichero texto → Objetos → Fichero objetos
```



## 📁 Estructura de Archivos

text

```
GestionAlumnos/
├── Alumno.java                 # Clase que representa a un alumno
├── GestionAlumnos.java         # Programa principal con la lógica
├── alumnos.txt                 # Fichero de texto (generado)
└── objetos.dat                 # Fichero de objetos (generado)
```



## 🧪 Ejemplo de Uso

### Compilación:

```bash
javac Alumno.java GestionAlumnos.java
```



### Ejecución Opción 1 (Introducir datos):

```bash
java GestionAlumnos 1 alumnos.txt objetos.dat
```



### Ejecución Opción 2 (Convertir a objetos):

```bash
java GestionAlumnos 2 alumnos.txt objetos.dat
```



### Ejecución Opción 3 (Listar objetos):

```bash
java GestionAlumnos 3 alumnos.txt objetos.dat
```



## 🔄 Comportamiento Esperado

1. Al ejecutar la opción 1, se introducen alumnos que se guardan en el fichero de texto
2. Al ejecutar la opción 2, los datos del fichero de texto se convierten en objetos y se añaden al fichero de objetos
3. Después de la conversión, el fichero de texto queda vacío
4. La opción 3 muestra todos los alumnos almacenados en el fichero de objetos

## 💡 Consejos

- Implementa validación de los argumentos de entrada
- Usa bloques try-with-resources para el manejo de streams
- Considera el caso de ficheros vacíos o inexistentes
- Documenta el código adecuadamente

## 📊 Criterios de Evaluación

- Correcta implementación de la serialización
- Manejo apropiado de excepciones
- Diseño modular y código limpio
- Funcionalidad completa según especificaciones
- Uso adecuado de los flujos de entrada/salida

¡Buena suerte con el ejercicio! 🚀