CREATE DATABASE IF NOT EXISTS instituto 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE instituto;

CREATE TABLE IF NOT EXISTS persona (
    id_persona INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    edad INT NOT NULL CHECK (edad >= 16 AND edad <= 65),
    
    INDEX idx_nombre_completo (nombre, apellidos),
    INDEX idx_edad (edad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO persona (nombre, apellidos, edad) VALUES
('María', 'García López', 18),
('Carlos', 'Martínez Sánchez', 19),
('Ana', 'Rodríguez Fernández', 20),
('David', 'Pérez Gómez', 21),
('Laura', 'Hernández Díaz', 22),
('Javier', 'Moreno Jiménez', 18),
('Elena', 'Navarro Romero', 19),
('Sergio', 'Torres Molina', 20),
('Marta', 'Gil Ortega', 21),
('Pablo', 'Vargas Cruz', 23),
('Cristina', 'Silva Mendoza', 20),
('Roberto', 'Castro León', 21),
('Beatriz', 'Reyes Paredes', 22),
('Antonio', 'Méndez Ruiz', 35),
('Isabel', 'Santos Vega', 42),
('Sonia', 'Campos Navarro', 28),
('Miguel', 'Ortega Reyes', 38),
('Patricia', 'Luna Montes', 45);

-- Consulta para verificar los datos insertados
SELECT * FROM persona;
