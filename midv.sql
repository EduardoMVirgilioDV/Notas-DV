/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 100135
Source Host           : localhost:3306
Source Database       : midv

Target Server Type    : MYSQL
Target Server Version : 100135
File Encoding         : 65001

Date: 2019-11-25 18:01:24
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for carreras
-- ----------------------------
DROP TABLE IF EXISTS `carreras`;
CREATE TABLE `carreras` (
  `id_carrera` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(40) NOT NULL,
  `descripcion` text NOT NULL,
  PRIMARY KEY (`id_carrera`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of carreras
-- ----------------------------
INSERT INTO `carreras` VALUES ('1', 'Diseño Multimedial', 'Aprendé a manejar diversos programas para generar contenido multimedia.');
INSERT INTO `carreras` VALUES ('2', 'Diseño y Programación Web', 'Dominá el arte de crear sitios y aplicaciones web.');
INSERT INTO `carreras` VALUES ('3', 'Diseño Gráfico', 'Volvete un experto en el manejo de la comunicación gráfica.');
INSERT INTO `carreras` VALUES ('4', 'Diseño de Videojuegos', 'Creá los mejores y más divertidos videojuegos.');
INSERT INTO `carreras` VALUES ('5', 'Analista de Sistemas', 'Volvete Neo.');
INSERT INTO `carreras` VALUES ('6', 'Cine de Animación', 'Pixarizate.');

-- ----------------------------
-- Table structure for docentes
-- ----------------------------
DROP TABLE IF EXISTS `docentes`;
CREATE TABLE `docentes` (
  `id_docente` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  PRIMARY KEY (`id_docente`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of docentes
-- ----------------------------
INSERT INTO `docentes` VALUES ('1', 'Santiago', 'Gallino');
INSERT INTO `docentes` VALUES ('2', 'Omar', 'Toyos');
INSERT INTO `docentes` VALUES ('3', 'Guido', 'Tondo');
INSERT INTO `docentes` VALUES ('4', 'Pilar', 'Gallardo');
INSERT INTO `docentes` VALUES ('5', 'Tomás', 'Korman');
INSERT INTO `docentes` VALUES ('6', 'Germán', 'Patrizi');
INSERT INTO `docentes` VALUES ('7', 'Antonio', 'Rubio');

-- ----------------------------
-- Table structure for docentes_dictan_materias
-- ----------------------------
DROP TABLE IF EXISTS `docentes_dictan_materias`;
CREATE TABLE `docentes_dictan_materias` (
  `id_materia` int(10) unsigned NOT NULL,
  `id_docente` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_materia`,`id_docente`),
  KEY `fk_docentes_dictan_materias_docentes` (`id_docente`),
  CONSTRAINT `fk_docentes_dictan_materias_docentes` FOREIGN KEY (`id_docente`) REFERENCES `docentes` (`id_docente`),
  CONSTRAINT `fk_docentes_dictan_materias_materias` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of docentes_dictan_materias
-- ----------------------------
INSERT INTO `docentes_dictan_materias` VALUES ('1', '2');
INSERT INTO `docentes_dictan_materias` VALUES ('2', '1');
INSERT INTO `docentes_dictan_materias` VALUES ('2', '2');
INSERT INTO `docentes_dictan_materias` VALUES ('3', '6');
INSERT INTO `docentes_dictan_materias` VALUES ('4', '1');
INSERT INTO `docentes_dictan_materias` VALUES ('4', '2');
INSERT INTO `docentes_dictan_materias` VALUES ('5', '1');
INSERT INTO `docentes_dictan_materias` VALUES ('5', '2');

-- ----------------------------
-- Table structure for instancias_evaluacion
-- ----------------------------
DROP TABLE IF EXISTS `instancias_evaluacion`;
CREATE TABLE `instancias_evaluacion` (
  `id_instancia` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(25) NOT NULL,
  PRIMARY KEY (`id_instancia`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of instancias_evaluacion
-- ----------------------------
INSERT INTO `instancias_evaluacion` VALUES ('1', '1er TP');
INSERT INTO `instancias_evaluacion` VALUES ('2', '2do TP');
INSERT INTO `instancias_evaluacion` VALUES ('3', '3er TP');
INSERT INTO `instancias_evaluacion` VALUES ('4', 'Recuperatorio 1er TP');
INSERT INTO `instancias_evaluacion` VALUES ('5', 'Recuperatorio 2do TP');
INSERT INTO `instancias_evaluacion` VALUES ('6', 'Recuperatorio 3er TP');
INSERT INTO `instancias_evaluacion` VALUES ('7', 'Final');

-- ----------------------------
-- Table structure for materias
-- ----------------------------
DROP TABLE IF EXISTS `materias`;
CREATE TABLE `materias` (
  `id_materia` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_carrera` int(10) unsigned NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text NOT NULL,
  `cuatrimestre` int(11) NOT NULL,
  PRIMARY KEY (`id_materia`),
  KEY `fk_materias_carreras` (`id_carrera`),
  CONSTRAINT `fk_materias_carreras` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of materias
-- ----------------------------
INSERT INTO `materias` VALUES ('1', '1', 'Lógica de Programación', 'HTML+CSS', '1');
INSERT INTO `materias` VALUES ('2', '1', 'Programación Visual I', 'Responsive Web Design', '2');
INSERT INTO `materias` VALUES ('3', '1', 'Programación Visual II', 'Construct', '3');
INSERT INTO `materias` VALUES ('4', '1', 'Programación Visual III', 'php+MySQL', '4');
INSERT INTO `materias` VALUES ('5', '1', 'Desarrollo de Aplicaciones Móviles', 'jQuery Mobile y PhoneGap', '5');
INSERT INTO `materias` VALUES ('6', '1', 'Diseño Gráfico Publicitario I', 'No sé', '1');

-- ----------------------------
-- Table structure for notas
-- ----------------------------
DROP TABLE IF EXISTS `notas`;
CREATE TABLE `notas` (
  `id_nota` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_materias` int(10) unsigned NOT NULL,
  `id_instancia` int(10) unsigned NOT NULL,
  `fecha` date NOT NULL,
  `nota` int(10) unsigned NOT NULL,
  `comentarios` text,
  PRIMARY KEY (`id_nota`),
  KEY `fk_notas_materias` (`id_materias`),
  KEY `fk_notas_instancias_evaluacion` (`id_instancia`),
  CONSTRAINT `fk_notas_instancias_evaluacion` FOREIGN KEY (`id_instancia`) REFERENCES `instancias_evaluacion` (`id_instancia`),
  CONSTRAINT `fk_notas_materias` FOREIGN KEY (`id_materias`) REFERENCES `materias` (`id_materia`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of notas
-- ----------------------------
INSERT INTO `notas` VALUES ('2', '4', '2', '2019-12-11', '7', ':D:D');
INSERT INTO `notas` VALUES ('3', '4', '3', '2019-11-11', '6', ':D:D:D');
