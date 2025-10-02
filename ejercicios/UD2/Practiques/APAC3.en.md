!!! abstract "About the practice"

    This practice is a **free statement** practice. You have to create your own task, with several limits, obviously. You have to do the **maintenance of a database** of your choice: you can create it from zero, you can choose one of last course, you can get from internet etc. 

# 1. The database

The database restrictions are:

- It must contains at least three entities.
- It must contains at least three relationships, one of each class: `1-1`, `1-M` and `N:M`. If you want, you can create a reflexive relation.
- Use MySQL

# 2. The program

## 2.1. Structure

Create an Hibernate program with the goal of doing the basic CRUD operations in the database (Create, Read, Update and Delete). Map all the entities and relationships of the database.

##  2.2. CRUD

As all the work of each entity is the same (changing the entity's name), you must create only one Entity full CRUD. Then, create methods to insert, delete, update and select information of one entity.

## 2.3. Relationships

Imagine that we have a `1:M` relationship, an `Author` writes several `Books`. With your own relationships do the same as follows:

### 2.3.1. Task 1

You have to show records from a entity, for instance `show Author`. This command will show all Authors in database. But if the command is `show -r Author` it will show for each author the books that has written. (`r` means _recursively_)

### 2.3.2. Task 2

When you want to insert a new Book, you can run `add Book`, and then, in an interactive way, the program will ask the values of the book and create it and store it, establishing the Author to `null`. But if you run `add -r Book`, the program will show all Authors in the database. The user will select one, and this Author is setted as book's author. 

In the Author selection process,  there will be an extra option (Author 0, for instance) when the book's author is not in the database, and we will create a new Author, and then assign to the Book. Both Author and Book will be saved.

# 3. Task.

To upload the task on the platform, you only need to write a link to a private repository of student's GitHub. You must add your teacher's user as a guest of your repo (`joange` - jgcamarena@ieseljust.com). The task will be presented as next points.

In your work's folder you must have:

1. A script with the database create table and some sample data. You must generate it with **MySQL Workbench sql dump**.
2. A picture of your database structure, created with MySQL **Workbench reverse engineering**.
3. A maven project that implement the requirements of this text.
4. `Readme.md` file with documentation about your program. 

## 3.1. Checkpoint 1. The database.

In this task you must present your repo when you finish part 1 and 2. The teacher will mark it as `OK` before you start to program with part 3.

## 3.2. Checkpoint 2. The program.

When you finish the task, present your repo.

(c) Joan Gerard Camarena Estruch, November 2022
