## 1. Introducción

Las bases de datos relacionales surgen del modelo relacional como un sistema que representa fielmente la realidad, con gran solidez debido a la lógica relacional subyacente. Este modelo representa la perspectiva estática de la modelización de la aplicación, y en él todos los datos se desglosan a niveles atómicos, puesto que, como recordamos, no se permiten valores multivaluados ni compuestos.

Este modelo ha sufrido la brecha objeto-relacional, en la que los lenguajes de programación han evolucionado las estructuras adoptando la metodología orientada a objetos. Esto nos lleva a diseñar la base de datos por un lado, siguiendo el modelo relacional, y también necesitamos diseñar las clases de la aplicación por otro lado. Estos diseños, que no suelen coincidir, se pueden ajustar con las herramientas ORM estudiadas en la unidad anterior para mitigar la desconexión objeto-relacional.

De esa brecha surge la necesidad de añadir un diseño más orientado a objetos dentro de la propia base de datos. Si analizamos un esquema orientado a objetos e intentamos aplicar la teoría de la normalización, encontraremos que los objetos se _descomponen_ en varias entidades, provocando la aparición de muchas tablas.

Este alto número de tablas provoca, como consecuencia, un aumento de las referencias entre ellas, aumentando considerablemente las relaciones entre ellas y, por tanto, un mayor número de restricciones a controlar (FOREIGN KEY), lo que supone un aumento del número de comprobaciones que debe realizar el SGBD.

Así, en la **BD OO** (_Base de Datos Orientada a Objetos_) se permite una definición de tipos de datos complejos en comparación con los simples que incorpora el SGBD relacional, permitiendo la definición de tipos estructurados e incluso multivaluados. Con todo ello, la BD OO debería permitir simplemente el diseño a través de objetos (similar al UML) indicando los objetos que participan en ellos, indicando sus atributos y métodos, y las relaciones que les afectan, y obviamente, las herencias.

Estas BD OO todavía no han despegado, y algunas soluciones que implementan soluciones comerciales es proporcionar al sistema de bases de datos relacionales las capacidades semánticas de la orientación a objetos, apareciendo así las BDOR (_Bases de Datos Objeto-Relacional_).

## 2. Bases de Datos Objeto-Relacional

El estándar ANSI SQL1999 (SQL99 y posteriormente SQL2003), como continuación de SQL92 en el que se adaptan las características del modelo relacional, permite añadir características orientadas a objetos en las bases de datos relacionales. Esto permite que los SGBD robustos hayan _adoptado_ e implementado aquellas características requeridas. Entre estas características se encuentran:

- Definición de nuevos tipos de datos por parte del usuario.
- Adaptación para acomodar grandes tipos de datos binarios como imágenes y documentos.
- Capacidad para almacenar elementos compuestos como arrays.
- Almacenar directamente referencias a otras tablas.
- Definición de objetos y herencia.
- Definición de funciones que gestionan las estructuras previamente definidas.

