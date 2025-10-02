
!!! abstract "Notes sobre l'enunciat i pràctica"
    Aquesta pràctica és d'**enunciat obert**. Has de crear la teua pròpia tasca, amb certes limitacions, com comprendràs. Has de fer un programa que faça el **manteniment d'una base de dades** a la teua elecció: podràs crear-la de zero o escollir-ne alguna que conegues o cercar a internet.
    

# 1. La base de dades

Les restriccions de la base de dades són:

- Ha de contenir com a mínim tres entitats.
- Ha de contenir com a mínim tres relacions, una de cada classe: `1-1`, `1-M` i `N:M`. Si vols, pots crear una relació reflexiva.
- Utilitza MySQL

# 2. El programa

## 2.1. Estructura

Crea un programa Hibernate amb l'objectiu de realitzar les operacions bàsiques de CRUD a la base de dades (Create, Read, Update i Delete). Mapeja totes les entitats i relacions de la base de dades.

## 2.2. CRUD

Com tot el treball de cada entitat és el mateix (canviant el nom de l'entitat), només has de crear un CRUD complet per a una entitat. A continuació, crea mètodes per inserir, eliminar, actualitzar i seleccionar informació d'una entitat.

## 2.3. Relacions

Imagina que tenim una relació `1:M`, un `Autor` escriu diversos `Llibres`. Amb les teves pròpies relacions, fes el mateix de la següent manera:

### 2.3.1. Tasca 1

Has de mostrar registres d'una entitat, per exemple `mostra Autor`. Aquesta comanda mostrarà tots els autors de la base de dades. Però si la comanda és `mostra -r Autor`, mostrarà per a cada autor els llibres que ha escrit. (`r` significa _recursivament_)

### 2.3.2. Tasca 2

Quan vulguis inserir un nou Llibre, pots executar `afegir Llibre`, i després, de manera interactiva, el programa demanarà els valors del llibre i el crearà i emmagatzemarà, establint l'Autor com a `null`. Però si executes `afegir -r Llibre`, el programa mostrarà tots els autors de la base de dades. L'usuari en seleccionarà un, i aquest Autor es configurarà com a autor del llibre.

En el procés de selecció de l'Autor, hi haurà una opció addicional (Autor 0, per exemple) quan l'autor del llibre no estigui a la base de dades, i crearem un nou Autor i després l'assignarem al Llibre. Tant l'Autor com el Llibre es desaran.

# 3. Tasca.

Per pujar la tasca a la plataforma, només cal que escriguis un enllaç a un repositori privat de GitHub de l'estudiant. Has d'afegir l'usuari del teu professor com a convidat del teu repositori (`joange` - jgcamarena@ieseljust.com). La tasca es presentarà amb els següents punts.

En la carpeta del teu treball has de tenir:

1. Un script amb la creació de taules de la base de dades i alguna dada d'exemple. Has de generar-ho amb **MySQL Workbench sql dump**.
2. Una imatge de l'estructura de la teva base de dades, creada amb **MySQL Workbench reverse engineering**.
3. Un projecte Maven que implementi els requisits d'aquest text.
4. Fitxer `Readme.md` amb documentació sobre el teu programa.

## 3.1. Punt de control 1. La base de dades.

En aquesta tasca has de presentar el teu repositori quan hagis acabat les parts 1 i 2. El professor ho marcarà com a `OK` abans de començar a programar la part 3.

## 3.2. Punt de control 2. El programa.

Quan hagis acabat la tasca, presenta el teu repositori.

(c) Joan Gerard Camarena Estruch, novembre 2022

