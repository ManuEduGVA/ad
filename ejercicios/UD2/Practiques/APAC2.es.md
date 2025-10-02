# 1. Visió General

Anem a crear un client de SGBD, com el MySQL Workbench, però en una versió de consola amb una shell i un prompt. El nostre client ens permet connectar-nos a un servidor, seleccionar una base de dades i finalment executar diverses consultes SQL.

## 1.1. Mode de servidor

En iniciar el nostre programa, demanarà les dades del servidor.

```sh
gradle run --console plain
...
$ Server: 127.0.0.1
$ Port: 3308
$ Username: root
$ Password:
$ (root) on 127.0.0.1:3308>
```

Com podeu veure a l'última línia, el prompt és `(usuari) a IP:port>`. El nostre client mostra sempre on estem connectats.

La llista d'ordres que el nostre client acceptarà quan estigui connectat és (**mode servidor**):

- `show database` o `show db` $\rightarrow$ mostra una llista amb totes les bases de dades del nostre SGBD.
- `info` $\rightarrow$ mostra informació sobre el SGBD i la configuració de la connexió.
- `import nom_del_script` $\rightarrow$ permet carregar un script SQL des d'un fitxer.
- `use nom_de_la_bd` $\rightarrow$ canvia el nostre programa al mode base de dades.
- `quit` $\rightarrow$ finalitza el nostre programa.



## 1.2. Mode de Base de Dades

Un cop estiguem connectats a un servidor i haguem seleccionat una base de dades, el nostre client entrarà en el mode de base de dades:

```sh
$ (root) on 127.0.0.1:3308>use Ciclismo
$ (root) on 127.0.0.1:3308[Ciclismo]>
```


Pots veure que el nom de la base de dades s'afegeix al prompt i ara el programa està esperant ordres per a la base de dades. Has d'implementar aquestes comandes:

- `sh tables` $\rightarrow$ mostra totes les taules de la base de dades seleccionada.
- `describe nom_de_la_taula` $\rightarrow$ mostra la descripció d'aquesta taula: camps, tipus de dades i claus primàries com a mínim.
- `insert Nom_de_la_Taula` $\rightarrow$ de manera interactiva, demana a l'usuari el valor de cada camp i insereix una nova fila.
- `sql` $\rightarrow$ executa qualsevol consulta a la base de dades seleccionada.
- `quit` $\rightarrow$ torna al mode SGBD.



# 2. Estructura del projecte i consells

El projecte conté les següents classes:

<center>![CEPA2](./CEPA2.png){width=75%}</center>

Anem a revisar les funcions de classe

## 2.1. ServerManager

Conté el _main_, i quan s'inicia, demana a l'usuari la informació del servidor. A continuació, inicia la classe `ConnectionManager` amb els valors proporcionats.

## 2.2. ConnectionManager

Gestiona la consola principal del programa i té com a atributs:

```java
String server;
String port;
String user;
String pass;
```


i com a mètodes:

- `ConnectionManager()` $\rightarrow$ constructor per defecte.
- `ConnectionManager(String server, String port, String user, String pass)` $\rightarrow$ constructor general.
- `public Connection connectDBMS()` $\rightarrow$ inicia i retorna una connexió.
- `public void showInfo()` $\rightarrow$ mostra la informació del servidor.
- `public void showDatabases()` $\rightarrow$ mostra les taules del servidor.
- `public void importScript(String script)` $\rightarrow$ carrega i executa un script.
- `public void startShell()` $\rightarrow$ inicia la consola del servidor. Aquesta consola ja està gairebé implementada.

## 2.3. Gestor de Base de Dades

Gestiona la consola del mode base de dades i necessita un atribut addicional respecte al Gestor de Connexió:

```java
String server;
String port;
String user;
String pass;
String dbname;
```


i com a mètodes:

- `DatabaseManager()` $\rightarrow$ constructor per defecte.
- `DatabaseManager(String server, String port, String user, String pass,String dbname)` $\rightarrow$ constructor general.
- `public Connection connectDatabase()` $\rightarrow$ inicia i retorna una connexió a la base de dades actual.
- `public void insertIntoTable(String table)` $\rightarrow$ inicia l'assistent d'inserció per a la taula donada.
- `public void showDescTable(String table)` $\rightarrow$ mostra la metadades de la taula.
- `public void executeSelect(String query)` $\rightarrow$ executa una consulta donada (de qualsevol tipus) i mostra els resultats a la pantalla, si n'hi ha.
- `public void startShell()` $\rightarrow$ inicia la consola del mode base de dades. Has de fer una implementació completa.

# 3. Insercions a les taules.

El mètode `insertIntoTable` és probablement el més difícil de la tasca, ja que cal demanar primer les metadades de la taula per conèixer els camps i els tipus de dades de la taula, i després demanar a l'usuari els valors i els formats.

El consell que es donarà és crear tres llistes amb:

1. Llista de camps que cal inserir.
2. Llista de valors que s'assignaran.
3. Llista de tipus de cada camp.

A més, cal generar una llista o cadena de marcadors de posició amb tants `?` com sigui necessari.


!!! tip "Consell"

    Recorda que, en demanar les metadades de la taula, les columnes que necessites són:

        - Columna 4: nom de la columna
        - Columna 6: tipus de dades de la columna
        - Columna 18: nullable o no. Aquest camp és obligatori si no és nullable.
        - Columna 23: incremental o no. No necessites aquest camp si és incremental.

    Finalment, verifica l'ajust dels placeholders, ja que depenen del tipus de dades. Tindre en compte que:

    - Les dades `int` faran servir `setInt()`
    - Les dades `datetime` faran servir `setDate()`, amb un casting a `java.sql.Date` en compte de `java.Date`
    - Per defecte el `setString` i confiar que el casting automàtic faça la seua feina.

© Joan Gerard Camarena, October-2022

© Última revisió, October-2024