# 1. Bases de datos NoSQL

El movimiento NoSQL (**Not Only SQL**) contempla todas aquellas alternativas a los sistemas de gestión de bases de datos relacionales tradicionales. Las bases de datos orientadas a objetos podrían ser un primer enfoque en estas bases de datos NoSQL. Sin embargo, existen otros modelos, con un enfoque totalmente diferente. Estas son bases de datos basadas en **documentos**, en pares clave-valor o en gráficos.

Aunque algunas de las características planteadas por estos paradigmas se están incorporando a los estándares SQL y los SGBD relacionales, la realidad actual es que este tipo de bases de datos está creciendo considerablemente en muchas áreas.
A principios de los años 2000 surgió la web 2.0, que supuso la conversión de los usuarios en generadores de contenido. Posteriormente, con la web 3.0 o web semántica, Internet se convierte en una gran base de datos, y el acceso a ésta ya no es exclusivo de las aplicaciones web, sino de todo tipo de aplicaciones y apps. Actualmente, estamos ante el auge de la inteligencia artificial y la web 4.0, como una evolución de todo lo anterior. Con todo esto, podemos imaginar la gran cantidad de datos que los servidores deben almacenar, y que requiere un almacenamiento más deslocalizado, distribuido y suficientemente eficiente para soportar millones de consultas diarias.

En esta unidad nos centraremos en las bases de datos tipo documento, específicamente MongoDB, una base de datos basada en documentos JSON, muy popular en la web.

## 1.1. Tipo de bases de datos

Podemos encontrar

1. **Bases de datos clave-valor** → Es un modelo de base de datos bastante sencillo y popular, donde cada elemento se identifica con una clave única, siguiendo el modelo de tabla de hash, por lo que los datos se recuperan muy rápidamente. Los objetos generalmente se almacenan como objetos binarios (BLOBs). Algunas bases de datos de este tipo son **Cassandra** (Apache), **Bigtable** (Google) o **Dynamo** (Amazon).

2. **Bases de datos documentales** → Este modelo almacena la información en forma de documentos, generalmente `XML` o `JSON`, y se utiliza una clave única para cada registro, de forma que se permiten búsquedas clave-valor. La diferencia respecto a las bases de datos clave-valor anteriores es que aquí el valor es el documento en sí mismo, no datos binarios.
Como veremos más adelante, son muy versátiles, por lo que ni siquiera necesitamos tener una estructura común para los documentos que guardamos. El máximo exponente de ese tipo de base de datos es MongoDB.

3. **Bases de datos en grafos** → Un grafo es un conjunto de vértices o nodos unidos por aristas, que nos permiten representar relaciones entre ellos. Las bases de datos en grafos intentan seguir este modelo, por lo que la información se representa como nodos en un grafo, y las relaciones entre ellos se representan por aristas. De esta forma, aprovechando la teoría de grafos, podemos recorrer la información de manera óptima. Algunos ejemplos de este tipo de base de datos son Amazon Neptune, JanusGraph (Apache), SQL Server (Microsoft) o Neo4j.
