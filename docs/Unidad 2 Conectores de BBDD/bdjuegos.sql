CREATE SCHEMA IF NOT EXISTS `BDJuegos` DEFAULT CHARACTER SET utf8 ;
USE `BDJuegos` ;

CREATE TABLE IF NOT EXISTS `BDJuegos`.`jugador` ( 
`id` INT NOT NULL, 
`nick` VARCHAR(45) NULL, 
`fechaRegistro` DATETIME NULL, 
PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `BDJuegos`.`Genero` ( 
`id` INT NOT NULL, 
`nombre` VARCHAR(45) NULL, 
`descripcion` VARCHAR(256) NULL, 
PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `BDJuegos`.`Juego` ( 
`id` INT NOT NULL, 
`nombre` VARCHAR(45) NULL, 
`descripcion` VARCHAR(256) NULL, 
`Genero_id` INT NOT NULL, 
PRIMARY KEY (`id`), 
INDEX `fk_Juego_Genero1_idx` (`Genero_id` ASC), 
CONSTRAINT `fk_Juego_Genero1` 
FOREIGN KEY (`Genero_id`) 
REFERENCES `BDJuegos`.`Genero` (`id`) 
ON DELETE NO ACTION 
ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `BDJuegos`.`Puntuaciones` ( 
`jugador_id` INT NOT NULL, 
`Juego_id` INT NOT NULL, 
`puntuacion` INT NULL, 
PRIMARY KEY (`jugador_id`, `Juego_id`), 
INDEX `fk_jugador_has_Juego_Juego1_idx` (`Juego_id` ASC), 
INDEX `fk_jugador_has_Juego_jugador1_idx` (`jugador_id` ASC), 
CONSTRAINT `fk_jugador_has_Juego_jugador1` 
FOREIGN KEY (`jugador_id`) 
REFERENCES `BDJuegos`.`jugador` (`id`) 
ON DELETE NO ACTION 
ON UPDATE NO ACTION, 
CONSTRAINT `fk_jugador_has_Juego_Juego1` 
FOREIGN KEY (`Juego_id`) 
REFERENCES `BDJuegos`.`Juego` (`id`) 
ON DELETE NO ACTION 
ON UPDATE NO ACTION)
ENGINE = InnoDB;
