!!! abstract "Notas sobre el enunciado y práctica" 
    -   Esta práctica es de **enunciado abierto**. Tienes que crear tu propia tarea, con ciertas limitaciones, como vas a comprender. 
        Tienes que hacer un programa que haga el **mantenimiento de una base de datos** a tu elección: podrás crearla de cero o escoger 
        alguna que conozcas o buscar en Internet.


# 1. La base de datos

Las restricciones de la base de datos son:

- Debe contener como mínimo tres entidades.
- Debe contener como mínimo tres relaciones, una de cada clase: `1-1`, `1-M` y `N:M`. Si lo deseas, puedes crear una relación reflexiva.
- Utiliza MySQL

# 2. El programa

## 2.1. Estructura

Crea un programa Hibernate con el objetivo de realizar las operaciones básicas de CRUD en su base de datos (Create, Read, Update y Delete). Mapea todas las entidades y relaciones de la base de datos.

## 2.2. CRUD

Como todo el trabajo de cada entidad es el mismo (cambiando el nombre de la entidad), sólo debes crear un CRUD completo para una entidad. A continuación, crea métodos para insertar, eliminar, actualizar y seleccionar información de una entidad.

## 2.3. Relaciones

Imagina que tenemos una relación `1:M`, un `Autor` escribe varios `Libros`. Con tus propias relaciones, haz lo mismo de la siguiente manera:

### 2.3.1. Tarea 1

Tienes que mostrar registros de una entidad, por ejemplo `muestra Autor`. Este pedido mostrará a todos los autores de la base de datos. Pero si el pedido es "muestra -r Autor", mostrará para cada autor los libros que ha escrito. (`r` significa _recursivamente_)

### 2.3.2. Tarea 2

Cuando quieras insertar un nuevo Libro, puedes ejecutar `añadir Libro`, y después, de forma interactiva, el programa pedirá los valores del libro y lo creará y almacenará, estableciendo el Autor como `null`. Pero si ejecutas "añadir -r Libro", el programa mostrará a todos los autores de la base de datos. El usuario seleccionará uno, y este Autor se configurará como autor del libro.

En el proceso de selección del Autor, habrá una opción adicional (Autor 0, por ejemplo) cuando el autor del libro no esté en la base de datos, y crearemos un nuevo Autor y después lo asignaremos al Libro. Tanto el Autor como el Libro se guardarán.

# 3. Tarea.

Para subir la tarea a la plataforma, basta con que escribas un enlace a un repositorio privado de GitHub del estudiante. Tienes que añadir al usuario de tu profesor como invitado de tu repositorio (`ManuEduGVA` - jm.romeromartinez@edu.gva.es). La tarea se presentará con los siguientes puntos.

En la carpeta de tu trabajo debes tener:

1. Un script con la creación de tablas de la base de datos y algún dato de ejemplo. Tienes que generarlo con **MySQL Workbench sql dump**.
2. Una imagen de la estructura de tu base de datos, creada con **MySQL Workbench reverse engineering**.
3. Un proyecto Maven que implemente los requisitos de este texto.
4. Archivo `Readme.md` con documentación sobre tu programa.
