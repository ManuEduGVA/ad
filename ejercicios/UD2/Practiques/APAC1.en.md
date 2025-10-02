
# 1. Environment and program execution

In this first Data Access CEPA (_Continuous Evaluation Practice Activity_), we are going to implement the file persistence part of a geometric figures project partially done.

You are provided with a compressed file with the APAC1_AD Gradle project, with the figure hierarchy implementation and various utilities.
The project has been created with `gradle init`, which creates a small structure of directories and files for us, such as the `gradlew` and `gradlew.bat` launchers (which we will not use).

In order to build the project we will:

```bash
$ gradle build
BUILD SUCCESSFUL in 1 s
5 actionable tasks : 5 up-to-date
```

and to run the project:

```bash
gradle run --console plain
```

the `--console plain` option skip showing messages saying about the program execution. In addition, to pass some arguments to the program (in our program the height and width of the canvas) we must indicate as follows `--args="500 500"`. The string in the double quotes will be the args variable of main.

Once the program is running, the following prompt will be showed:

```
# Figura: 
```

This program let us draw a scene formed by several figures. The available options supported by the current version are (in Valencian):

- `dimensions ample alt` : It sets the height and with of the canvas.
- `cercle x y radi #color` : It adds a circle to the current scene. The circle will be placed at `x,y` coordinates, with the given radius and a color, in `#RRGGBB` format. This color is validated by a utility function.
- `rectangle x y height width #color`: It adds a rectangle placed in `x,y` coordinates, with the given measures and color.
- `linia x1 y1 x2 y2 #color`: It adds a line from the `(x1,y1)` starting point to the `(x2,y2)` final point and specified color. A fixed thickness by 3 pixels is establishe by the program.
- `draw`: It will open a _JavaFX_ window and draw all the figures stored and introduced in a canvas. When we will close the windows, the app will be finished.

# 2. New behaviors

In order to improve the base program, we must add the date persistence, adding functions to store and recover scenes. The orders wue have to implement are:

- `import [file.txt | file.obj]` $\rightarrow$ It will import from disk scenes configurations, stored in text files or object files. The program will decide the format taking into account the file extension.
- `export [file.txt | file.obj |file.svg | file.json]` $\rightarrow$ It will export to disk current scene configuration, saving it in text files, object files, svg format (a special xml format) or json format. The program will decide the format taking into account the file extension.

!!! note
    All the files will be saved in the root project folder


## 2.1. Sample files of scenes

**Text file**

```
dimensions 500 500
rectangle 10 10 480 480 #ccccee 
cercle 250 250 100 #aaaaaa
linia 50 250 450 250 #aaaaaa
linia 50 50 50 450 #aaaaaa
linia 450 40 450 450 #aaaaaa
```
**SVG file**

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

!!! note
    This kind of xml is maded because after export this scene, you may open it with [Inkscape](https://inkscape.org/es/). You can use it to prove you have done it well.

**JSON format**

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

# 3. Project structure

First, we have `build.gradle` file, with information about project building, with graphics and JSON libraries. In our project structure, we have:

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
as you can view, inside src folder, we could take into account:

- **App** $\rightarrow$ main class. It shows the prompt and it creates the canvas. You don't have to modify this class.
- **figura, cercle, linia, rectangle, punt** $\rightarrow$ these classes form the inheritance tree (except punt). They have the necessary attributes and methods. You probably need to add methods to get the representation of that class to text, json or xml. You must do the necessary classes serializables too.
- **escena** $\rightarrow$ it contains some attributes and the collection of figures
- **FileManager** $\rightarrow$ class that have to deal with the storing process. We have to do the main work on it, as we can show in the next point.

# 4. `FileManager` class

As we explained, here is where you have to store and recover the information in several formats.

## 4.1. exists method

```java
public Boolean Exists(String file)
```

It will return a logic value depending on the existence of the file or no.

## 4.2. `importFromText` method

```java
public Escena importFromText(String file)
```
Import a scene in text format, in the format indicated at the beginning of this document. In the imgs folder, you have a couple of images to test. As you can see, it receives the path to the file in String format, and it will return an object of type Scene.

Note that, in addition to the figures, the dimensions command may appear, which will indicate that we will have to modify the dimensions of the Scene.

## 4.3. `importFromObj` method

```java
public Escena importFromObj(String file)
```

Importing a serialized scene in object format, in the format indicated at the beginning of this document. In the imgs folder, you have a couple of images to test. As you can see, it receives the path to the file in String format, and it will return an object of type Scene.

## 4.4. `exportText` method

```java
public Boolean exportText(Escena escena, String file)
```

This method will export a given scene to a text file, in the format specified above, to be able to read them with `importFromText`.

The method will receive the Scene object, and a String with the name of the file to be saved, with a `.txt` extension.

For the implementation of this method, you will find it useful to implement a method called `getAsText` (or similar) in each type of figure, and returns the figure itself in the format of interest. In this way, to export the scene, we will go through the different figures and obtain the representation of each one.

## 4.5. `exportObj` method

```java
public Boolean exportObj(Escena escena, String file)
```

This method will export a given scene to an objects file, to be able to read it with `importFromObj`.

The method will receive the Scene object, and a String with the name of the file to be saved, with an `.obj` extension.

!!! warning
    Remember the use of `Serializable` modifier on the needed classes.


## 4.6. `exportSVG` method

```java
public Boolean exportSVG(Escena escena, String file)
```

This method will export a given scene to a svg file, in the xml format specified above in the previous pages. The method will receive the Scene object, and a String with the name of the file to be saved, with a `.svg` extension.

Some details of the format:

- We include `<?xml version="1.0" encoding="UTF-8" standalone="no"?>` always.
- The root element is the `<svg>` tag, with two attributes _width_ and _height_.
- Every _figure_ inheritor will be the equivalent `rect`, `circle` and `line` tag. Look at the document sample.
- To do a correct circle position, you have to add the radius to the figure position: `this.posicio.getX()+this.radi` and `this.posicio.getY()+this.radi`

!!! note
    To get a correct implementation of this method (and others that will become) is interesting to proceed as we notice:

    - declare an abstract method in Figura class. `getAsSVG()`, for instance.
    - implement this method on every descent class.

## 4.7. `exportJSON` method

```java
public Boolean exportJSON(Escena escena,String filename)
```

This method will create a JSON representation of the scene that the method receives. As the note given in the last point, is an interesting practice to create the `getAsJson()` method in the top class an implement in the bottom classes. 

:::note

To do a more efficient work, implement the methods as follows:

- `importFromText`, so you can import a full scene provided and could draw it.
- `exportToText`, so you can check your scene will be the same as the original one.
- `exportToObj`, so you can save a scene imported from text
- `importFromObj`, to check the exported one has been well done.
- At the end the rest of exports, to SVG and JSON
:::

# 5. Practice delivery

To do the practice upload you have to fulfill the following:

- Execute `gradle clean` in order to clean all the packages and libraries.
- Compress the project folder. **Zip format is mandatory**.
- Upload the practice at the aules platform, avoiding emails or other communication tools.

