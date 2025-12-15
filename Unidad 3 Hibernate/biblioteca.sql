CREATE DATABASE IF NOT EXISTS biblioteca;
USE biblioteca;


CREATE TABLE autor (
    idautor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50)
);


CREATE TABLE libro (
    idlibro INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50),
    titulo VARCHAR(200) NOT NULL,
    idautor INT NOT NULL,
    FOREIGN KEY (idautor) REFERENCES autor(idautor)
);

INSERT INTO autor (nombre, nacionalidad) VALUES
('Gabriel García Márquez', 'Colombiana'),
('Isabel Allende', 'Chilena'),
('Mario Vargas Llosa', 'Peruana'),
('Julio Cortázar', 'Argentina'),
('Jorge Luis Borges', 'Argentina');

INSERT INTO libro (tipo, titulo, idautor) VALUES
('Novela', 'Cien años de soledad', 1),
('Novela', 'El amor en los tiempos del cólera', 1),
('Novela', 'La casa de los espíritus', 2),
('Cuento', 'La ciudad y los perros', 3),
('Ensayo', 'Rayuela', 4),
('Poesía', 'Ficciones', 5),
('Novela', 'Crónica de una muerte anunciada', 1),
('Cuento', 'Bestiario', 4);