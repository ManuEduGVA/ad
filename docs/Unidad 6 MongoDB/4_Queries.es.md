# 4. Consultas en Mongo

## 4.1. find()

El comando find nos permite recuperar los documentos de una colección que coinciden con un **criterio especificado como documento JSON**. Su sintaxis básica es la siguiente:

```js
db.collection.find({critería_in_JSON_formato});
```
Debemos tener en cuenta aspectos como los tipos de datos que utilizamos, que es importante, puesto que el documento `{edad:20}` no es el mismo que `{edad:"20"}`.

Por otro lado, también debemos considerar que **el documento vacío `{}` coincide con todos los documentos**, por lo que la consulta
`db.collection.find({})` devolvería todos los objetos de la colección.

### 4.1.1. ¿Qué claves recuperar?

El comando find devuelve los documentos completos que coinciden con los criterios de selección. Si no queremos obtener todas las claves, podemos especificar qué claves queremos consultar, incluyéndolas en un segundo parámetro:

```js
db.collection.find({query_document}, {key_1:1, key_2:1});
```

Como podemos ver, este segundo parámetro también se expresa en formato JSON (de nuevo) y está formado por dos claves (`key_1` y `key_2`), ambas con un valor de 1. Este valor numérico también se interpreta como `true`. Es decir, aquí especificamos cuáles son los campos que queremos mostrar. En caso de que queramos mostrar todos los campos y esconder algunos, utilizaríamos la misma sintaxis, pero ahora utilizando un 0 para aquellos campos que queremos esconder.

### 4.1.2. Operaciones de comparación

MongoDB nos permite realizar comparaciones con datos numéricos, siempre utilizando el formato de documento JSON
`db.collection.find({key: {$operator:value} });`

Los operadores de comparación que podemos utilizar en MongoDB son:

- `$lt` → Menor que
- `$lte` → Menor o igual que
- `$gt` → Mayor que
- `$gte` → Mayor o igual que

### 4.1.3. Operación OR

Si queremos realizar un filtro o consulta donde se cumplan varias condiciones (una operación AND), sólo deberemos separarlas por comas en el mismo documento JSON que utilizamos como criterio. Por otra parte, si lo que queremos es llevar a cabo una operación OR, debemos utilizar un operador especial.

### 4.1.4. Operadores `$IN` y `$NIN`

Un caso especial de OR es cuando queremos comprobar si un campo se encuentra dentro de un conjunto específico de valores. Es decir, si es un valor u otro. Por eso utilizamos el operador `$in`, de la siguiente manera:

```js
db.collection.find({key:{$in:[vector_de_valores]}})
```

De forma similar, existe el operador `$nin` (**Not In**), que obtiene los documentos donde el valor especificado no se encuentra en la lista. Debemos tener en cuenta que en este último caso también se mostrarán aquellos documentos que tengan un valor nulo para la clave.

### 4.1.5. Operador `$OR`

Cuando queremos realizar la operación OR en diferentes campos del documento, utilizaremos el operador `$OR`, al que pasamos un vector de posibles condiciones, de la siguiente manera:

```js
db.collection.find({$or:[condition1, condition2,...]})
```

!!! note "Attention" 
Las condiciones del array son condiciones en json


### 4.1.6. Operador `$NOT`

El operador `$NOT` es un operador metacondicional, es decir, siempre se aplica a otro criterio, invirtiendo su valor de certeza. Su sintaxis sería:

```js
db.collection.find({key:{$not: {criterion}}}).pretty();
```


### 4.1.7. Operador `$EXISTS`

Recordemos que en MongoDB, los documentos no tienen una estructura o esquema común, por lo que es posible que existan claves definidas sólo en algunos de ellos. El operador `$exists` se utiliza para comprobar la existencia o no de una determinada clave.
La sintaxis a utilizar sería:

```js
db.collection.find({key:{ $exists: true|false }})
```

Con esto obtenemos los documentos para los que la clave existe o no, dependiendo de si hemos indicado true o false en la consulta.

## 4.2. Resultados de las consultas y tipos de datos

Los tipos de datos en MongoDB pueden tener algunos comportamientos especiales. Veremos algunos casos para saber qué hacer en determinadas situaciones.

### 4.2.1. valores nulos

El valor null coincide con las siguientes situaciones:

- Cuando el valor de la clave es null, o
- Cuando la clave no existe en el documento (en este caso, normalmente se dice que el campo no está informado)

### 4.2.2. Expresiones regulares y cadenas de caracteres

Cuando aplicamos un filtro de documento por un campo de texto, puede que no conozcamos exactamente el valor del campo por el que queremos filtrar. Las expresiones regulares ofrecen un potente mecanismo para la coincidencia de cadenas.

MongoDB nos permite utilizar estas expresiones de diversas formas, ya sea utilizando expresiones regulares de Javascript o utilizando el operador `$regex`, que utiliza **Expresiones Regulares Compatibles con Perl** (PCRE). Las expresiones regulares de Javascript se expresan utilizando la siguiente sintaxis:

```js
{ key: /pattern/<options> }
```

Como podemos ver, utilizamos un patrón similar a una cadena de texto, pero utilizando la barra inclinada `/` como delimitador en lugar de las comillas (```). Por su parte, si utilizamos el operador `$regex`, podemos utilizar la siguiente sintaxi:

```js
{ key: { $regex: /pattern/, $options: '<options>' } }
{ key: { $regex: 'pattern', $options: '<options>' } }
{ key: { $regex: /pattern/<options> } }
```

Podemos encontrar varias opciones para expresiones regulares:

- `i` → Las coincidencias no distinguen entre mayúsculas y minúsculas: 
- `{name:/john/i}` 
- `{name: { $regex: 'john',$options: 'y'}}`
- `m` → Permite incluir caracteres como `^` o `$`, para coincidir al principio o al final, en cadenas con múltiples líneas. 
- `{name:/^John/m}` 
- `{name: { $regex: 'John', $options: 'm'}}`
- `x` Ignora los espacios en blanco en el patrón `$regex`, siempre que no estén escapados o incluidos en una clase de caracteres. 
- `{name: { $regex: ' J oh n',$options: 'x'}}`
- `s` Permite que el carácter punto (`.`) represente cualquier carácter, incluyendo el carácter de nueva línea. 
- `{name:/ju.n/s}` 
- `{name: { $regex: 'thu.n',$options: 's'}}`

Puede encontrar más información sobre expresiones regulares y casos particulares en los que se recomienda utilizar un tipo de expresión u otra en la documentación oficial de MongoDB sobre `$regex` [aquí](https://www.mongodb.com/docs/manual/reference/operator/query/regex/).

## 4.3. Consideraciones sobre el tipo de datos de las consultas

### 4.3.1. Consultas con arrays

Para buscar elementos coincidentes dentro de un array, procedemos con la misma sintaxis como si fuera cualquier otra clave, utilizando el documento de consulta `{key:value}`, siendo la clave un array, y el valor, ya sea un _n valor_ que debe contener el array, u otro vector ordenado que queremos que coincida exactamente.

Por ejemplo:

- `db.collection.find({ my_vector : value })` → Coincide con todos los documentos en los que el vector `my_vector` aparece, en la posición que sea, el valor indicado. 
- `db.users.find({roles:"admin"})` muestra los usuarios que en el array `roles` tienen el rol _admin_ (u otros).
- `db.collection.find({ my_vector : [value] })` → Coincide con todos los documentos en los que el vector `my_vector` aparece sólo el valor indicado. 
- `db.users.find({roles:["admin"]})` muestra a los usuarios que tienen exactamente el rol _admin_.

Además, también podemos utilizar expresiones regulares o demás operadores que hemos visto como condiciones.

Por otra parte, también podemos referirnos a un elemento específico del vector por su índice, utilizando la notación de puntos y entre comillas:

- `db.collection.find({"my_vector.position" :[value]})` 
- `db.users.find({"roles.2":["admin"]})` muestra el usuario que tiene como tercer rol admin

### 4.3.2. El operador `$all`

Con `$all` podemos especificar más de un elemento coincidente dentro del array:

- `db.collection.find({ my_vector : {$all:[value1, value2,...]}})` 
- `db.users.find({roles:{$all:["mod","admin"]}})` muestra los usuarios que tienen los roles _mod_ y _admin_ (y posiblemente otros).

### 4.3.3. El operador `$size`

Utilizando `$size` podemos incluir condiciones sobre la longitud de los vectores:

- `db.collection.find({ my_vector : {$size:size} })`

### 4.3.4. El operador `$slice`

El operador slice nos permite obtener un subconjunto de los elementos del vector, con la siguiente sintaxis:

- `key: {$slice: x}`: 
- si x>0 obtiene los primeros x elementos 
- si x<0, obtiene los últimos x elementos
- `key: {$slice: [ x , y ] }` Obtener _y_ elementos desde el elemento a la posición _x_ del documento embebido

Para consultar documentos embebidos, simplemente especifique el camino completo de la clave, cerrado entre comillas y separado por puntos:
`db.collection.find({"path.to.key":value_or_condition})`

## 4.4. Cursores

Cuando realizamos una consulta, MongoDB devuelve los resultados utilizando cursos, que son punteros en los resultados de la consulta, como conectores en la unidad 2. Los clientes que utilizan Mongo iteran sobre estos cursos para recuperar los resultados, y ofrecen un conjunto de funcionalidades, como limitar los resultados, etc.

Cuando realizamos una consulta en una base de datos con muchos resultados, el cliente (`mongosh`) devuelve sólo 20 resultados y el mensaje `Type "it" for more`, para continuar iterando el cursor.

### 4.4.1. Límite, Skip y Suerte

MongoDB nos permite realizar ciertas limitaciones en los resultados. Entre ellas, podemos destacar:

- `limit` → Para limitar el número de resultados
- `skip` → Salta un número específico de resultados.
- `sort` → Ordena los resultados. Necesita un objeto JSON con las claves para ordenar, y un valor de 1 para ordenar ascendentemente o -1 para ordenar descendentemente.

## 4.5. Introducción al Marco de Agrupación

Las consultas de agrupación que realizábamos con operadores como `GROUP BY`, `SUM` o `COUNT` en SQL se pueden realizar con el Marco de Agrupación de MongoDB. Las consultas de agrupación tienen la siguiente sintaxis:

```js
db.collection.aggregate( [<pipeline>] )
```

El pipeline o _tuberia_ tiene un concepto similar a las tiberías de Unix: los resultados de una orden se pasan como entrada a otra, para obtener resultados conjuntamente.

Las operaciones que podemos realizar dentro de estas consultas de agrupación son:

- `$project` → Para realizar una proyección sobre un conjunto de datos de entrada, añadiendo, eliminando o recalculando campos para que la salida sea diferente.
- `$match` → Filtra la entrada para reducir el número de documentos, dejando sólo aquellos que cumplen ciertas condiciones.
- `$limit` → Restringe el número de resultados.
- `$skip` → Salta un cierto número de registros.
- `$unwind` → Convierte un array para devolverlo separado en documentos.
- `$group` → Agrupa documentos según cierta condición.
- `$sort` → Ordena un conjunto de documentos, según el campo especificado.
- `$geoNear`→ Se utiliza como datos geoespaciales, devolviendo los documentos ordenados por proximidad según un punto geoespacial.

Para realizar cálculos sobre los datos producidos por las tuberías, utilizaremos expresiones. Las expresiones son funciones que realizan cierta operación sobre un grupo de documentos, vector o campo específico. Algunas de estas expresiones son `$max`, `$min`, `$divide` o `$substr`.

Puede encontrar mucha más información sobre agregaciones a la documentación oficial de MongoDB.
## 4.6. Ejercicios

Seguimos trabajando con la colección de películas. En este caso, utilizaremos el terminal mongosh (o Studio3T si lo prefieres), y realizaremos las siguientes consultas sobre esta colección.

1. Obtenga todas las producciones que se estrenaron en `2023` o que tienen 180 o más minutos de duración.
2. Obtenga todas las películas que **NO** se estrenaron entre los años `2000` y `2010`.
3. Obtenga todas las películas para las que la clave "oscars" no está definida.
4. Obtenga el título de todas las películas que comienzan con la cadena `The`, independientemente de mayúsculas o minúsculas.
5. Obtenga el título de todas las películas que contienen el género comedia (`Comedia`).
6. Muestre el título y los géneros de las películas que contienen el género comedia (`Comedia`) o thriller (`Thriller`) o acción (`Acción`).
7. Obtenga el título y los géneros de las películas que tienen tres géneros.
8. Obtenga las películas con una calificación de `puntuacion_imdb` superior a `4`.
9. Haga la misma consulta que antes, pero limitando el número de documentos a 10.
10. Ahora muestre el título y la calificación de aquellas películas con una calificación superior a 4, ordenadas por calificación (de más alta a más baja) y limitando los resultados a 10.
