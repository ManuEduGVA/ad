-- MySQL dump 10.13  Distrib 8.0.18, for macos10.14 (x86_64)
--
-- Host: 127.0.0.1    Database: DocenciaConsultas
-- ------------------------------------------------------
-- Server version	8.0.18

CREATE Database if not exists DocenciaConsultas;

USE DocenciaConsultas;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Alumno`
--

DROP TABLE IF EXISTS `Alumno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Alumno` (
  `idAlumno` bigint(20) NOT NULL AUTO_INCREMENT,
  `apellidos` varchar(255) DEFAULT NULL,
  `edad` int(11) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `repetidor` bit(1) DEFAULT NULL,
  PRIMARY KEY (`idAlumno`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alumno`
--

LOCK TABLES `Alumno` WRITE;
/*!40000 ALTER TABLE `Alumno` DISABLE KEYS */;
INSERT INTO `Alumno` VALUES (1,'Gómez Blas',24,'Pedro',_binary '\0'),(2,'Pons Pont',20,'Pere',_binary '\0'),(3,'Bo Pla',21,'Ana',_binary '\0'),(4,'Martínez Garcia',24,'Pedro',_binary '\0'),(5,'Gimeno Pons',19,'Saul',_binary ''),(6,'Zaragoza Vila',24,'Alexia',_binary '');
/*!40000 ALTER TABLE `Alumno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Docencia`
--

DROP TABLE IF EXISTS `Docencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Docencia` (
  `idProfesor` bigint(20) NOT NULL,
  `idModulo` bigint(20) NOT NULL,
  PRIMARY KEY (`idProfesor`,`idModulo`),
  KEY `FK_DOC_MOD` (`idModulo`),
  CONSTRAINT `FK_DOC_MOD` FOREIGN KEY (`idModulo`) REFERENCES `Modulo` (`idModulo`),
  CONSTRAINT `FK_DOC_PROF` FOREIGN KEY (`idProfesor`) REFERENCES `Profesor` (`idProfesor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Docencia`
--

LOCK TABLES `Docencia` WRITE;
/*!40000 ALTER TABLE `Docencia` DISABLE KEYS */;
INSERT INTO `Docencia` VALUES (2,1),(1,2),(1,3),(1,4),(2,4),(3,6),(4,6);
/*!40000 ALTER TABLE `Docencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Examen`
--

DROP TABLE IF EXISTS `Examen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Examen` (
  `idExamen` bigint(20) NOT NULL AUTO_INCREMENT,
  `fecha` datetime DEFAULT NULL,
  `nota` double DEFAULT NULL,
  `idAlumno` bigint(20) DEFAULT NULL,
  `idModul` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`idExamen`),
  KEY `FK_EX_ALU` (`idAlumno`),
  KEY `FK_EX_MOD` (`idModul`),
  CONSTRAINT `FK_EX_ALU` FOREIGN KEY (`idAlumno`) REFERENCES `Alumno` (`idAlumno`),
  CONSTRAINT `FK_EX_MOD` FOREIGN KEY (`idModul`) REFERENCES `Modulo` (`idModulo`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Examen`
--

LOCK TABLES `Examen` WRITE;
/*!40000 ALTER TABLE `Examen` DISABLE KEYS */;
INSERT INTO `Examen` VALUES (1,'2022-01-30 06:13:12',7.45,2,1),(2,'2022-01-30 06:13:12',6.5,3,1),(3,'2022-01-30 06:13:12',4,4,2),(4,'2022-01-30 06:13:12',8,4,4),(5,'2022-01-30 06:13:12',10,1,2),(6,'2022-01-30 06:13:12',3.7,5,2),(7,'2021-10-10 00:00:00',6.5,1,2),(8,'2021-12-03 06:13:12',3,5,3);
/*!40000 ALTER TABLE `Examen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Modulo`
--

DROP TABLE IF EXISTS `Modulo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Modulo` (
  `idModulo` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idModulo`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Modulo`
--

LOCK TABLES `Modulo` WRITE;
/*!40000 ALTER TABLE `Modulo` DISABLE KEYS */;
INSERT INTO `Modulo` VALUES (1,'PRG'),(2,'FOL'),(3,'EIE'),(4,'SEX'),(5,'BBDD'),(6,'ACD');
/*!40000 ALTER TABLE `Modulo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Profesor`
--

DROP TABLE IF EXISTS `Profesor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Profesor` (
  `idProfesor` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idProfesor`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Profesor`
--

LOCK TABLES `Profesor` WRITE;
/*!40000 ALTER TABLE `Profesor` DISABLE KEYS */;
INSERT INTO `Profesor` VALUES (1,'Mariano Faus'),(2,'Anna Marto'),(3,'Andrea Perez'),(4,'Angela Sanz'),(5,'Gerard Olmos');
/*!40000 ALTER TABLE `Profesor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-01-30 16:54:23
