# 📚 Simulacro de examen: **Acceso a Datos**

---

## ✅ Ejercicio 1: Fichero JSON `cvalenciana.json`

Este fichero contiene una estructura de **comunidades autónomas**, **provincias** y **ciudades**.

!!! info "Objetivo"
    En este ejercicio deberás realizar lo siguiente:

### 🔹 Clases a implementar
- **Comunidad**
  - Atributos: `id`, `nombre`
  - Contendrá un **ArrayList** de **Provincias**
- **Provincia**
  - Atributos: `idProvincia`, `nombre`
  - Contendrá un **ArrayList** de **Ciudades**
- **Ciudad**
  - Atributos: `código`, `nombre`

### 🔹 Operaciones requeridas
1. Obtener todos los municipios de la provincia de **Valencia** que comienzan por la letra **A**.
2. Contar todos los municipios de la provincia de **Castellón** que comienzan por la letra **B**.
3. Generar un fichero **CSV** (separador `;`) así con la cabecera de la siguiente información:

    - Nombre de provincia
    - Cantidad de municipios en la provincia
    - Nombre de municipio

---

## ✅ Ejercicio 2: Base de datos `cvalenciana.sql`

!!! tip "Configuración del proyecto"
    - Crear un proyecto **Java con Maven** llamado `comunidades`.
    - Configurar dependencias: **Lombok**, **MySQL**, etc.

### 🔹 Tareas
1. Crear una clase para conectar con el **SGBD** (no directamente con la BD). No debes conectar con una BD por defecto, sino sólo al gestor.
2. Listar las **bases de datos** del SGBD.
3. Conectar a la BD `comunidades_db` y:

    - Obtener las **tablas**.
    - Obtener la **definición de las tablas**.
    - Generar una operación **INSERT** (teniendo en cuenta los **metadatos**).
    - Generar una operación **SELECT** sobre cualquier tabla.

---

## ✅ Ejercicio 3: Hibernate y JPA

!!! note "Objetivo"
    Implementa un proyecto **Jakarta** con las dependencias necesarias y las clases que representen las relaciones entre las **3 tablas** de la BD.

### 🔹 Operaciones CRUD sobre la tabla `poblaciones`
- **Crear** nuevas poblaciones
- **Modificar** poblaciones
- **Consultar** poblaciones
- **Eliminar** poblaciones

### 🔹 Programa principal
1. Obtener todas las poblaciones de la **provincia de València**.
2. Modificar **Gátova** → **GÁTOVA**.
3. Eliminar **Casinos**.
4. Mostrar nuevamente las poblaciones de **València**.

---

Fichero con los datos en json [cavalenciana.json](./cvalenciana.json)
Fichero con los datos en de la base de datos [cavalenciana.sql](./cvalenciana.sql)