
# 1. Entorn i execució del programa

En aquesta primera Activitat de Pràctica d'Avaluació Continuada (APAC1), implementarem la part de persistència de fitxers d'un projecte de figures geomètriques parcialment fet.

Disposeu d'un fitxer comprimit amb el projecte Gradle APAC1_AD, amb la implementació de la jerarquia de figures i altres utilitats.

El projecte ha estat creat amb `gradle init`, que crea una petita estructura de directoris i fitxers per a nosaltres, com ara els llançadors `gradlew` i `gradlew.bat` (que no utilitzarem).

Per construir el projecte, farem:

```bash
$ gradle build
BUILD SUCCESSFUL in 1 s
5 actionable tasks : 5 up-to-date
```

i per a executar-lo:

```bash
gradle run --console plain
```

l'opció  `--console plain` evita missatges per consola de l'execució del programa. Ademés, per a passar arguments al programa (tamany de l'àrea de dibuix) ho indicarem com segueix `--args="500 500"`. 

Un cop el programa en execució, ens apareixerà a la consola:

```
# Figura: 
```

Aquest programa ens permet dibuixar una escena formada per diverses figures. Les opcions disponibles compatibles amb la versió actual són:

- `dimensions ample alt`: Estableix l'alçada i l'amplada del canvas o llençol.
- `cercle x y radi #color`: Afegeix un cercle a l'escena actual. El cercle es col·locarà a les coordenades `x, y`, amb el radi especificat i un color en format `#RRGGBB`. Aquest color és validat per una funció d'utilitat implementada a les llibreries.
- `rectangle x y altura amplada #color`: Afegeix un rectangle col·locat a les coordenades `x, y`, amb les mesures especificades i un color.
- `linia x1 y1 x2 y2 #color`: Afegeix una línia des del punt d'inici `(x1, y1)` fins al punt final `(x2, y2)` i amb el color especificat. El programa estableix un gruix fixat de 3 píxels per a la línia.
- `draw`: Obre una finestra _JavaFX_ i dibuixa totes les figures emmagatzemades i introduïdes en un canvas. Quan tanquem la finestra, **l'aplicació finalitzarà**.

# 2. Noves funcionalitats

Per tal de millorar el programa base, hem d'afegir la persistència de dades, afegint funcions per emmagatzemar i recuperar escenes. Les ordres que hem de implementar són:

- `import [fitxer.txt | fitxer.obj]` $\rightarrow$ Importarà de disc les configuracions de les escenes (el dibuix), emmagatzemades en fitxers de text o fitxers d'objectes. El programa decidirà el format tenint en compte l'extensió del fitxer.
- `export [fitxer.txt | fitxer.obj | fitxer.svg | fitxer.json]` $\rightarrow$ Exportarà a disc la configuració actual de l'escena, guardant-la en fitxers de text, fitxers d'objectes, format svg (un format xml especial) o format json. El programa decidirà el format tenint en compte l'extensió del fitxer.

!!! note "Nota"
    Tots els fitxers es guardaran a l'arrel del programa
    

## 2.1. Fitxers d'exemples

**Fitxer de Text**

```
dimensions 500 500
rectangle 10 10 480 480 #ccccee 
cercle 250 250 100 #aaaaaa
linia 50 250 450 250 #aaaaaa
linia 50 50 50 450 #aaaaaa
linia 450 40 450 450 #aaaaaa
```
**Arxiu SVG**

```xml
<?xmlversion="1.0" encoding="UTF-8" standalone="no"?>
<svg height="500" width="500">
  <rect fill="#ccccee" height="480" width="480" x="10" y="10"/>
  <circle cx="250" cy="250" fill="#aaaaaa" r="100"/>
  <line stroke="#aaaaaa" stroke-width="3" x1="50" x2="450" y1="250" y2="250"/>
  <line stroke="#aaaaaa" stroke-width="3" x1="50" x2="50" y1="50" y2="450"/>
  <line stroke="#aaaaaa" stroke-width="3" x1="450" x2="450" y1="40" y2= "450"/>
</svg>
```

!!! note "Nota"
    Aquest tipus d'XML es fa perquè després d'exportar aquesta escena, pots obrir-la amb [Inkscape](https://inkscape.org/es/). Pots utilitzar-lo per comprovar que ho has fet bé.


**Format JSON**

```json
{"escena": {
    "width": 320,
    "height": 320
    "figuras": [
        {"cercle": {
            "r": "26",
            "cx": "166",
            "cy": "105",
            "fill": "#94c147"
        }},
        {"rectangle": {
            "x": "137",
            "width": "58",
            "y": "108",
            "fill": "#ffffff",
            "height": "58"
        }},
        {"rectangle": {
            "x": "139",
            "width": "52",
            "y": "111",
            "fill": "#94c147",
            "height": "52"
        }}
     ],
}}
```

# 3. Estructura del Projecte

Primer, tenim el fitxer `build.gradle`, amb informació sobre la construcció del projecte, amb llibreries de gràfics i JSON. En la nostra estructura de projecte, tenim:

```
main
  |-- java
  |   `--com
  |      `-- ieseljust
            `-- ad
                `-- figures
                    |-- App.java
                    |-- cercle.java
                    |-- escena.java
                    |-- figura.java
                    |-- FileManager.java
                    |-- HexColorValidator.java
                    |-- Linia.java
                    |-- punt.java
                    `-- Rectangle.java
```
Com a podeu veure, dins de la carpeta src, podem tenir en compte:

- **App** $\rightarrow$ classe principal. Mostra el prompt i crea el canvas. No cal que modifiquis aquesta classe.
- **figura, cercle, linia, rectangle, punt** $\rightarrow$ aquestes classes formen l'arbre d'herència (excepte punt). Tenen els atributs i mètodes necessaris. Probablement necessitaràs afegir mètodes per obtenir la representació d'aquesta classe en text, json o xml. També cal que facis les classes necessàries serialitzables.
- **escena** $\rightarrow$ conté alguns atributs i la col·lecció de figures.
- **FileManager** $\rightarrow$ classe que s'encarrega del procés d'emmagatzematge. Hem de fer la feina principal en aquesta classe, com es mostra al següent punt.

# 4. Classe `FileManager`

Com ja hem explicat, aquí és on has de guardar i recuperar la informació en diversos formats.

## 4.1. Mètode `exists` 

```java
public Boolean Exists(String file)
```

Retornarà un valor lògic en funció de l'existència del fitxer o no.

## 4.2. Mètode `importFromText` 

```java
public Escena importFromText(String file)
```
Importa una escena en format de text, en el format indicat al principi d'aquest document. Tens un parell d'imatges per provar. Com pots veure, rep la ruta del fitxer en format de cadena i retornarà un objecte de tipus Escena.

Cal tenir en compte que, a més de les figures, pot aparèixer la comanda `dimensions`, que indicarà que haurem de modificar les dimensions de l'Escena.

## 4.3. Mètode `importFromObj` 

```java
public Escena importFromObj(String file)
```

Importar una escena serialitzada en format d'objecte, en el format indicat al principi d'aquest document. A la carpeta imgs, tens un parell d'imatges per provar. Com pots veure, rep la ruta del fitxer en format de cadena i retornarà un objecte de tipus Escena.

## 4.4. Mètode `exportText` 

```java
public Boolean exportText(Escena escena, String file)
```
Aquest mètode exportarà una escena donada a un fitxer de text, en el format especificat anteriorment, per poder-les llegir amb `importFromText`.

El mètode rebrà l'objecte Escena i una cadena amb el nom del fitxer a desar, amb l'extensió `.txt`.

Per implementar aquest mètode, et serà útil implementar un mètode anomenat `getAsText` (o similar) en cada tipus de figura, que retorni la pròpia figura en el format desitjat. D'aquesta manera, per exportar l'escena, recorrerem les diferents figures i obtindrem la representació de cadascuna d'elles.


## 4.5. Mètode `exportObj` 

```java
public Boolean exportObj(Escena escena, String file)
```

Aquest mètode exportarà una escena donada a un fitxer d'objectes, per poder-lo llegir amb `importFromObj`.

El mètode rebrà l'objecte Escena i una cadena amb el nom del fitxer a desar, amb l'extensió `.obj`.

!!! warning "Atenció"
    Recorda utilitzar el modificador `Serializable` en les classes necessàries.


## 4.6. Mètode `exportSVG` 

```java
public Boolean exportSVG(Escena escena, String file)
```

Aquest mètode exportarà una escena donada a un fitxer `svg`, en el format xml especificat anteriorment a les pàgines anteriors. El mètode rebrà l'objecte Escena i una cadena amb el nom del fitxer a desar, amb l'extensió `.svg`.

Alguns detalls del format:

- Inclourem `<?xml version="1.0" encoding="UTF-8" standalone="no"?>` sempre.
- L'element arrel és l'etiqueta `<svg>`, amb dos atributs _width_ i _height_.
- Cada figura heretada serà l'equivalent a l'etiqueta `rect`, `circle` i `line`. Mira l'exemple del document.
- Per obtenir una posició correcta del cercle, has d'afegir el radi a la posició de la figura: `this.posicio.getX()+this.radi` i `this.posicio.getY()+this.radi`

!!! note "Important"
    Per obtenir una implementació correcta d'aquest mètode (i altres que vindran), és interessant seguir els següents passos:

    - Declara un mètode abstracte a la classe Figura. `getAsSVG()`, per exemple.
    - Implementa aquest mètode a cada classe descendents.



## 4.7. Mètode `exportJSON` 

```java
public Boolean exportJSON(Escena escena,String filename)
```

Aquest mètode crearà una representació JSON de l'escena que rep el mètode. Com es va mencionar a la nota anterior, és una pràctica interessant crear el mètode `getAsJson()` a la classe superior i implementar-lo a les classes inferiors.

!!! note "Atenció"

    Per treballar de manera més eficient, implementa els mètodes de la següent manera:

    - `importFromText`, per importar una escena completa i poder-la dibuixar.
    - `exportToText`, per comprovar que la teva escena sigui igual que l'original.
    - `exportToObj`, per desar una escena importada des de text.
    - `importFromObj`, per comprovar que l'exportada s'ha fet correctament.
    - Finalment, la resta d'exports, a SVG i JSON.

# 5. Entrega de la pràctica

Per fer l'enviament de la pràctica, heu de seguir els següents passos:

- Executeu `gradle clean` per netejar tots els paquets i llibreries.
- Comprimiu la carpeta del projecte. **El format zip és obligatori**.
- Pugeu la pràctica a la plataforma aules, evitant correus electrònics o altres eines de comunicació.

