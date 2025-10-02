# 1. Overview

Let's go to create a DBMS client, like MySQL workbench, but in a console version with a shell and a prompt. Our client allows us to connect to a server, select a database and finally throws several SQL queries.

## 1.1. Server Mode

When starting our program, it will ask for server's data

```sh
gradle run --console plain
...
$ Server: 127.0.0.1
$ Port: 3308
$ Username: root
$ Password:
$ (root) on 127.0.0.1:3308>
```

As you can see on last line, prompt is `(user) on IP:port>`. Our client show where we are connected always.

List of order tha will be accepted by or client when connected are (**server mode**):

- `show databases` or `sh db` $\rightarrow$ show a list with all databases in our DBMS.
- `info` $\rightarrow$ show information abaut DBMS and connection settings.
- `import script_name` $\rightarrow$ Allow to load a sql scrip from a file.
- `use db_name` $\rightarrow$ change our program to database mode.
- `quit` $\rightarrow$ finish our program.

## 1.2. Database Mode

Once we are connected to a server, and selected a database, our client will enter in database mode:

```sh
$ (root) on 127.0.0.1:3308>use Ciclismo
$ (root) on 127.0.0.1:3308[Ciclismo]>
```

you can view that database name is added to the prompt, and now the program is waiting for commands to the database. You must implement these orders :

- `sh tables` $\rightarrow$ show all tables on selected database.
- `describe table_name` $\rightarrow$ show description of this table: fields, data types and primary keys at least.
- `insert Nom_de_la_Taula` $\rightarrow$  on an interactive way, ask to the user for each field value, and insert a new row.
- `sql` $\rightarrow$ It runs whatever query on selected database.
- `quit` $\rightarrow$ returns to DBMS mode.


# 2. Project structure and tips

The project contains theses classes:

<center>![CEPA2](./CEPA2.png){width=75%}</center>


Let's go to revise the class functions

## 2.1. ServerManager

It contains main, and when starting, ask the user for the server information. Then, it starts `ConnectionManager` class with the given values.

## 2.2. ConnectionManager

It manages the main program shell, and has as attributes:

```java
String server;
String port;
String user;
String pass;
```

and as methods:

- `ConnectionManager()` $\rightarrow$ default const.
- `ConnectionManager(String server, String port, String user, String pass)` $\rightarrow$ general const.
- `public Connection connectDBMS()` $\rightarrow$ starts and returns a connection.
- `public void showInfo()` $\rightarrow$  show server's information.
- `public void showDatabases()` $\rightarrow$ show server's tables.
- `public void importScript(String script)` $\rightarrow$ loads and run a script.
- `public void startShell()` $\rightarrow$ inits the server's mode shell. This shell is almost implemented.

## 2.3. DatabaseManager

It manage the database mode shell, and need an extra attribute than Connection manager:

```java
String server;
String port;
String user;
String pass;
String dbname;
```

and as methods:

- `DatabaseManager()` $\rightarrow$ default const.
- `DatabaseManager(String server, String port, String user, String pass,String dbname)` $\rightarrow$ general const.
- `public Connection connectDatabase()` $\rightarrow$ starts and returns a connection to the current database.
- `public void insertIntoTable(String table)` $\rightarrow$ starts the insertion assistant to the given table.
- `public void showDescTable(String table)` $\rightarrow$ show table metadata.
- `public void executeSelect(String query)` $\rightarrow$ run a given query (of any type) and show results on screen, if any.
- `public void startShell()` $\rightarrow$ inits the database's mode shell. You have to do a full implementation.

# 3. Table's insertions.

The `insertIntoTable` is probably the hardest method in the task, due to need to ask for table metadata first, in order to know the table fields and data types, and then ask to the user for the values and formats.

The advice that will be given is to set three list with:

1. Fields list that need to insert
2. Values list to we are going to set
3. Types list of each field

Furthermore, you need to generate a placeholders list or String, with so many `?` as you need.

!!! tip "Advice"

    Remember that asking for table metadata, the columns that you need are:

    - Column 4 : column name
    - Column 6: column data type
    - Column 18 nullable or not. This field is mandatory if were not null.
    - Column 23: incremental or not. You don't need this field, if were incremental.

    And last, a fine tunning is placeholders assignation, because it depends of data type. Take into account that:

    - If data type is `INT`, we will use `setInt`.
    - If data type is `DATETIME`, we will use `setDate` with a casting to `java.sql.Data` (not `java.Date`).
    - For a default or very specific type, you could setString, and hope that casts works properly.

© Joan Gerard Camarena, October-2022

© Last revision, October-2024