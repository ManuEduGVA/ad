CREATE DATABASE IF NOT EXISTS instituto 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE instituto;

CREATE TABLE IF NOT EXISTS persona (
    id_persona INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    cogidos VARCHAR(255) NOT NULL,
    edad INT NOT NULL CHECK (edad >= 16 AND edad <= 65),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_nombre_completo (nombre, apellidos),
    INDEX idx_cogidos (cogidos(100)),
    INDEX idx_edad (edad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO persona (nombre, apellidos, cogidos, edad) VALUES
('María', 'García López', 'Programación, Bases de Datos, Sistemas Informáticos, Entornos de Desarrollo, Lenguaje de Marcas', 18),
('Carlos', 'Martínez Sánchez', 'Programación, Bases de Datos, Acceso a Datos, Desarrollo de Interfaces, Sistemas de Gestión Empresarial', 19),
('Ana', 'Rodríguez Fernández', 'Programación, Bases de Datos, Sistemas Informáticos, Entornos de Desarrollo, Formación y Orientación Laboral', 20),
('David', 'Pérez Gómez', 'Programación, Bases de Datos, Desarrollo de Interfaces, Acceso a Datos, Proyecto de Desarrollo de Aplicaciones Multiplataforma', 21),
('Laura', 'Hernández Díaz', 'Sistemas Informáticos, Bases de Datos, Programación, Lenguaje de Marcas, Formación en Centros de Trabajo', 22),
('Javier', 'Moreno Jiménez', 'Programación, Bases de Datos, Sistemas Informáticos, Lenguaje de Marcas, Entornos de Desarrollo', 18),
('Elena', 'Navarro Romero', 'Desarrollo Web en Entorno Cliente, Desarrollo Web en Entorno Servidor, Diseño de Interfaces Web, Desarrollo de Aplicaciones Web', 19),
('Sergio', 'Torres Molina', 'Bases de Datos, Programación, Desarrollo Web en Entorno Cliente, Desarrollo Web en Entorno Servidor, Despliegue de Aplicaciones Web', 20),
('Marta', 'Gil Ortega', 'Desarrollo Web en Entorno Servidor, Desarrollo Web en Entorno Cliente, Diseño de Interfaces Web, Desarrollo de Aplicaciones Web, Proyecto de Desarrollo de Aplicaciones Web', 21),
('Pablo', 'Vargas Cruz', 'Sistemas Informáticos, Bases de Datos, Programación, Formación y Orientación Laboral, Formación en Centros de Trabajo', 23),
('Cristina', 'Silva Mendoza', 'Programación (DAM), Desarrollo Web en Entorno Cliente (DAW), Bases de Datos (Común), Diseño de Interfaces Web (DAW)', 20),
('Roberto', 'Castro León', 'Sistemas Informáticos (Común), Desarrollo de Interfaces (DAM), Desarrollo Web en Entorno Servidor (DAW), Lenguaje de Marcas (Común)', 21),
('Beatriz', 'Reyes Paredes', 'Programación, Bases de Datos, Desarrollo Web en Entorno Cliente, Desarrollo Web en Entorno Servidor, Proyecto Integrado', 22),
('Antonio', 'Méndez Ruiz', 'Coordinación de DAM, Tutoría de 1º DAM, Impartición de Programación y Bases de Datos', 35),
('Isabel', 'Santos Vega', 'Coordinación de DAW, Tutoría de 2º DAW, Impartición de Desarrollo Web y Diseño de Interfaces', 42),
('Sonia', 'Campos Navarro', 'Gestión Académica, Secretaría, Administración de Matrículas', 28),
('Miguel', 'Ortega Reyes', 'Impartición de Sistemas Informáticos, Lenguaje de Marcas, FOL para DAM y DAW', 38),
('Patricia', 'Luna Montes', 'Impartición de Acceso a Datos, Desarrollo de Interfaces, Proyectos DAM', 45);

-- Consulta para verificar los datos insertados
SELECT * FROM persona;
