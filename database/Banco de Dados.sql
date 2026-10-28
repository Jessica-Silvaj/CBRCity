-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.32-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.20.0.7320
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para nightevolutiontp
CREATE DATABASE IF NOT EXISTS `nightevolutiontp` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `nightevolutiontp`;

-- Copiando estrutura para tabela nightevolutiontp.accounts
CREATE TABLE IF NOT EXISTS `accounts` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Whitelist` tinyint(1) NOT NULL DEFAULT 0,
  `Characters` int(10) NOT NULL DEFAULT 1,
  `Gemstone` bigint(19) NOT NULL DEFAULT 0,
  `Discord` varchar(50) NOT NULL DEFAULT '0',
  `License` varchar(50) NOT NULL DEFAULT '0',
  `Login` bigint(19) NOT NULL DEFAULT current_timestamp(),
  `Token` varchar(10) DEFAULT '0',
  `Banned` bigint(19) NOT NULL DEFAULT 0,
  `Reason` varchar(254) DEFAULT NULL,
  `Referral` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `Discord` (`Discord`),
  KEY `License` (`License`),
  KEY `Token` (`Token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.avatars
CREATE TABLE IF NOT EXISTS `avatars` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Image` text DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.barbershop
CREATE TABLE IF NOT EXISTS `barbershop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `X` float DEFAULT NULL,
  `Y` float DEFAULT NULL,
  `Z` float DEFAULT NULL,
  `Permission` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `barbershop` (`id`, `X`, `Y`, `Z`, `Permission`) VALUES
	(1, -813.37, -183.85, 37.57, NULL),
	(2, 138.13, -1706.46, 29.3, NULL),
	(3, -1280.92, -1117.07, 7, NULL),
	(4, 1930.54, 3732.06, 32.85, NULL),
	(5, 1214.2, -473.18, 66.21, NULL),
	(6, -33.61, -154.52, 57.08, NULL),
	(7, -276.65, 6226.76, 31.7, NULL),
	(8, -1129.97, -2815.86, 21.36, ''),
	(9, -1120.07, -2798.85, 21.36, '');

-- Copiando estrutura para tabela nightevolutiontp.blips
CREATE TABLE IF NOT EXISTS `blips` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Sprite` int(11) NOT NULL,
  `Color` int(11) NOT NULL,
  `Scale` float NOT NULL DEFAULT 0.6,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `blips` (`id`, `Name`, `X`, `Y`, `Z`, `Sprite`, `Color`, `Scale`) VALUES
	(1, 'Banco', 149.64, -1041.36, 29.59, 108, 25, 0.7),
	(2, 'Banco', 313.95, -279.74, 54.39, 108, 25, 0.7),
	(3, 'Banco', -351.2, -50.57, 49.26, 108, 25, 0.7),
	(4, 'Banco', -2961.85, 482.87, 15.92, 108, 25, 0.7),
	(5, 'Banco', 1175.09, 2707.53, 38.31, 108, 25, 0.7),
	(6, 'Banco', -1212.37, -331.37, 38, 108, 25, 0.7),
	(7, 'Banco', -112.86, 6470.46, 31.85, 108, 25, 0.7),
	(8, 'Hospital', -555.9, -607.95, 34.64, 80, 0, 0.5),
	(9, 'Garagem', 55.43, -876.19, 30.66, 357, 62, 0.6),
	(10, 'Garagem', 598.04, 2741.27, 42.07, 357, 62, 0.6),
	(11, 'Garagem', -136.36, 6357.03, 31.49, 357, 62, 0.6),
	(12, 'Garagem', 275.23, -345.54, 45.17, 357, 62, 0.6),
	(13, 'Garagem', 596.4, 90.65, 93.12, 357, 62, 0.6),
	(14, 'Garagem', -340.76, 265.97, 85.67, 357, 62, 0.6),
	(15, 'Garagem', -2030.01, -465.97, 11.6, 357, 62, 0.6),
	(16, 'Garagem', -1184.92, -1510, 4.64, 357, 62, 0.6),
	(17, 'Garagem', 214.02, -808.44, 31.01, 357, 62, 0.6),
	(18, 'Garagem', -348.88, -874.02, 31.31, 357, 62, 0.6),
	(19, 'Garagem', 67.74, 12.27, 69.21, 357, 62, 0.6),
	(20, 'Garagem', 361.9, 297.81, 103.88, 357, 62, 0.6),
	(21, 'Garagem', 1035.89, -763.89, 57.99, 357, 62, 0.6),
	(22, 'Garagem', -796.63, -2022.77, 9.16, 357, 62, 0.6),
	(23, 'Garagem', 453.27, -1146.76, 29.52, 357, 62, 0.6),
	(24, 'Garagem', 528.66, -146.3, 58.38, 357, 62, 0.6),
	(25, 'Garagem', -1159.48, -739.32, 19.89, 357, 62, 0.6),
	(26, 'Garagem', 101.22, -1073.68, 29.38, 357, 62, 0.6),
	(27, 'Garagem', 1725.21, 4711.77, 42.11, 357, 62, 0.6),
	(28, 'Garagem', 1624.05, 3566.14, 35.15, 357, 62, 0.6),
	(29, 'Garagem', -73.35, -2004.6, 18.27, 357, 62, 0.6),
	(30, 'Garagem', 1200.52, -1276.06, 35.22, 357, 62, 0.6),
	(31, 'Mercado Central', 46.7, -1749.71, 29.62, 78, 62, 0.5),
	(32, 'Loja de Eletronicos', -1526.57, -404.98, 35.64, 355, 27, 0.4),
	(33, 'Departamento Policial', -1278.42, 308.1, 65.42, 60, 18, 0.6),
	(34, 'Loja de Departamento', 29.2, -1351.89, 29.34, 52, 36, 0.5),
	(35, 'Loja de Departamento', 2561.74, 385.22, 108.61, 52, 36, 0.5),
	(36, 'Loja de Departamento', 1160.21, -329.4, 69.03, 52, 36, 0.5),
	(37, 'Loja de Departamento', -711.99, -919.96, 19.01, 52, 36, 0.5),
	(38, 'Loja de Departamento', -54.56, -1758.56, 29.05, 52, 36, 0.5),
	(39, 'Loja de Departamento', 375.87, 320.04, 103.42, 52, 36, 0.5),
	(40, 'Loja de Departamento', -3237.48, 1004.72, 12.45, 52, 36, 0.5),
	(41, 'Loja de Departamento', 1730.64, 6409.67, 35, 52, 36, 0.5),
	(42, 'Loja de Departamento', 543.51, 2676.85, 42.14, 52, 36, 0.5),
	(43, 'Loja de Departamento', 1966.53, 3737.95, 32.18, 52, 36, 0.5),
	(44, 'Loja de Departamento', 2684.73, 3281.2, 55.23, 52, 36, 0.5),
	(45, 'Loja de Departamento', 1696.12, 4931.56, 42.07, 52, 36, 0.5),
	(46, 'Loja de Departamento', -1820.18, 785.69, 137.98, 52, 36, 0.5),
	(47, 'Loja de Departamento', 1395.35, 3596.6, 34.86, 52, 36, 0.5),
	(48, 'Loja de Departamento', -2977.14, 391.22, 15.03, 52, 36, 0.5),
	(49, 'Loja de Departamento', -3034.99, 590.77, 7.8, 52, 36, 0.5),
	(50, 'Loja de Departamento', 1144.46, -980.74, 46.19, 52, 36, 0.5),
	(51, 'Loja de Departamento', 1166.06, 2698.17, 37.95, 52, 36, 0.5),
	(52, 'Loja de Departamento', -1493.12, -385.55, 39.87, 52, 36, 0.5),
	(53, 'Loja de Departamento', -1228.6, -899.7, 12.27, 52, 36, 0.5),
	(60, 'Loja de Armas', 1692.27, 3760.91, 34.69, 76, 6, 0.4),
	(61, 'Loja de Armas', 253.8, -50.47, 69.94, 76, 6, 0.4),
	(62, 'Loja de Armas', 842.54, -1035.25, 28.19, 76, 6, 0.4),
	(63, 'Loja de Armas', -331.67, 6084.86, 31.46, 76, 6, 0.4),
	(64, 'Loja de Armas', -662.37, -933.58, 21.82, 76, 6, 0.4),
	(65, 'Loja de Armas', -1304.12, -394.56, 36.7, 76, 6, 0.4),
	(66, 'Loja de Armas', -1118.98, 2699.73, 18.55, 76, 6, 0.4),
	(67, 'Loja de Armas', 2567.98, 292.62, 108.73, 76, 6, 0.4),
	(68, 'Loja de Armas', -3173.51, 1088.35, 20.84, 76, 6, 0.4),
	(69, 'Loja de Armas', 22.53, -1105.52, 29.79, 76, 6, 0.4),
	(70, 'Loja de Armas', 810.22, -2158.99, 29.62, 76, 6, 0.4),
	(71, 'Barbearia', -815.12, -184.15, 37.57, 71, 62, 0.5),
	(72, 'Barbearia', 139.56, -1704.12, 29.05, 71, 62, 0.5),
	(73, 'Barbearia', -1278.11, -1116.66, 6.75, 71, 62, 0.5),
	(74, 'Barbearia', 1928.89, 3734.04, 32.6, 71, 62, 0.5),
	(75, 'Barbearia', 1217.05, -473.45, 65.96, 71, 62, 0.5),
	(76, 'Barbearia', -34.08, -157.01, 56.83, 71, 62, 0.5),
	(77, 'Barbearia', -274.5, 6225.27, 31.45, 71, 62, 0.5),
	(78, 'Loja de Roupas', 86.06, -1391.64, 29.23, 366, 62, 0.5),
	(79, 'Loja de Roupas', -719.94, -158.18, 37, 366, 62, 0.5),
	(80, 'Loja de Roupas', -152.79, -306.79, 38.67, 366, 62, 0.5),
	(81, 'Loja de Roupas', -816.39, -1081.22, 11.12, 366, 62, 0.5),
	(82, 'Loja de Roupas', -1206.51, -781.5, 17.12, 366, 62, 0.5),
	(83, 'Loja de Roupas', -1458.26, -229.79, 49.2, 366, 62, 0.5),
	(84, 'Loja de Roupas', -2.41, 6518.29, 31.48, 366, 62, 0.5),
	(85, 'Loja de Roupas', 1682.59, 4819.98, 42.04, 366, 62, 0.5),
	(86, 'Loja de Roupas', 129.46, -205.18, 54.51, 366, 62, 0.5),
	(87, 'Loja de Roupas', 618.49, 2745.54, 42.01, 366, 62, 0.5),
	(88, 'Loja de Roupas', 1197.93, 2698.21, 37.96, 366, 62, 0.5),
	(89, 'Loja de Roupas', -3165.74, 1061.29, 20.84, 366, 62, 0.5),
	(90, 'Loja de Roupas', -1093.76, 2703.99, 19.04, 366, 62, 0.5),
	(91, 'Loja de Roupas', 414.86, -807.57, 29.34, 366, 62, 0.5),
	(92, 'Embarcações', -1728.06, -1050.69, 1.71, 356, 62, 0.6),
	(93, 'Embarcações', -776.72, -1495.02, 2.29, 356, 62, 0.6),
	(94, 'Embarcações', -893.97, 5687.78, 3.29, 356, 62, 0.6),
	(95, 'Embarcações', 1509.64, 3788.7, 33.51, 356, 62, 0.6),
	(105, 'Loja de Tatuagem', 1327.98, -1654.78, 52.03, 75, 13, 0.5),
	(106, 'Loja de Tatuagem', -1149.04, -1428.64, 4.71, 75, 13, 0.5),
	(107, 'Loja de Tatuagem', 322.01, 186.24, 103.34, 75, 13, 0.5),
	(108, 'Loja de Tatuagem', -3175.64, 1075.54, 20.58, 75, 13, 0.5),
	(109, 'Loja de Tatuagem', 1866.01, 3748.07, 32.79, 75, 13, 0.5),
	(110, 'Loja de Tatuagem', -295.51, 6199.21, 31.24, 75, 13, 0.5),
	(111, 'Concessionária', 127.64, -149.92, 54.8, 225, 62, 0.6),
	(112, 'Aeronaves', -1250.77, -3403.68, 13.94, 43, 62, 0.7),
	(124, 'Hotel', -772.73, 312.74, 85.7, 475, 26, 0.6),
	(125, 'Redline', 1152.44, -778.79, 57.6, 402, 1, 0.7),
	(126, 'Bennys', -223.46, -1337.73, 31.98, 402, 0, 0.7),
	(127, 'Estúdio Fotográfico', -1030.2, -3490.13, 14.55, 184, 8, 0.5),
	(129, 'Cat Cafe', -1538.27, -457.73, 35.9, 93, 3, 0.5),
	(130, 'Moo Moo Cafe', -579.28, -1065.96, 22.34, 93, 8, 0.5),
	(131, 'Auto Escola', 213.23, -1396.95, 30.58, 225, 0, 0.5),
	(132, 'Central de Empregos', -269.36, -955.38, 31.22, 351, 0, 0.7),
	(133, 'Loja de Penhores', -778.48, -599.87, 30.28, 267, 0, 0.5),
	(135, 'Área de Risco', 2476.97, 3767.59, 65.33, 84, 1, 0.5),
	(136, 'Área de Risco', 1255.91, -206.17, 110.32, 84, 1, 0.5),
	(137, 'Área de Risco', 95.41, 6731.3, 42.51, 84, 1, 0.5),
	(138, 'Área de Risco', 3716.84, 4519.86, 27.4, 84, 1, 0.5),
	(139, 'Área de Risco', -371.74, 1567.68, 350.72, 84, 1, 0.5),
	(140, 'Área de Risco', -1727.22, 585.65, 171.75, 84, 1, 0.5),
	(141, 'Área de Risco', 843.29, 1806.5, 159.88, 84, 1, 0.5),
	(142, 'Área de Risco', 178.68, 703.56, 209.05, 84, 1, 0.5),
	(143, 'Área de Risco', 1378.42, -741.9, 67.23, 84, 1, 0.5),
	(144, 'Área de Risco', -1183.86, -1769.51, 4.69, 84, 1, 0.5),
	(145, 'Área de Risco', 1500.55, 6340.45, 28.51, 84, 1, 0.5),
	(146, 'Área de Risco', 1353.74, -2540.76, 48.83, 84, 1, 0.5),
	(147, 'Área de Risco', 1707.23, 4529.05, 42.04, 84, 1, 0.5),
	(148, 'Área de Risco', 1925.61, 717.08, 190.29, 84, 1, 0.5),
	(149, 'Mansão', -2301.67, 4337.24, 33.11, 374, 0, 0.5),
	(150, 'Mansão', -555.53, 1230.59, 326.4, 374, 0, 0.5),
	(151, 'Mansão', 659.75, 901.6, 252.7, 374, 0, 0.5),
	(152, 'Mansão', 778.95, 3420.24, 57.87, 374, 0, 0.5),
	(153, 'Mansão', -2990.26, 2183.95, 48.7, 374, 0, 0.5);

-- Copiando estrutura para tabela nightevolutiontp.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) DEFAULT 'Individuo',
  `Lastname` varchar(50) DEFAULT 'Indigente',
  `License` varchar(50) DEFAULT NULL,
  `Bank` bigint(19) NOT NULL DEFAULT 5000,
  `Phone` varchar(20) DEFAULT NULL,
  `Blood` int(1) NOT NULL DEFAULT 1,
  `Prison` int(10) NOT NULL DEFAULT 0,
  `Killed` int(10) NOT NULL DEFAULT 0,
  `Death` int(10) NOT NULL DEFAULT 0,
  `Daily` varchar(20) NOT NULL DEFAULT '09-01-1990-0',
  `Created` bigint(19) NOT NULL DEFAULT current_timestamp(),
  `Login` bigint(19) NOT NULL DEFAULT current_timestamp(),
  `Skin` varchar(50) NOT NULL DEFAULT 'mp_m_freemode_01',
  `SkinMontly` bigint(19) NOT NULL DEFAULT 0,
  `Age` int(3) DEFAULT 0,
  `Deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `License` (`License`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.chests
CREATE TABLE IF NOT EXISTS `chests` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Weight` bigint(19) NOT NULL DEFAULT 500,
  `Slots` int(10) NOT NULL DEFAULT 50,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  `X` float NOT NULL DEFAULT 0,
  `Y` float NOT NULL DEFAULT 0,
  `Z` float NOT NULL DEFAULT 0,
  `Configuration` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `chests` (`id`, `Name`, `Weight`, `Slots`, `Permission`, `X`, `Y`, `Z`, `Configuration`) VALUES
	(1, 'CatCafe', 500, 50, '', -1547.78, -454.33, 36.2, '[{"permission":"CatCafe","weight":1000,"slots":50,"label":"Baú"}]'),
	(2, 'MooMooCafe', 500, 50, '', -588.69, -1069.07, 22.33, '[{"permission":"MooMooCafe","weight":1000,"slots":50,"label":"Baú"}]'),
	(3, 'Redline', 500, 50, '', 1147.63, -802.02, 64.77, '[{"weight":1000,"permission":"Redline","slots":50,"label":"Baú Geral"}]'),
	(4, 'Bennys', 500, 50, '', -243.65, -1361.23, 39.78, '[{"slots":50,"weight":1000,"label":"Baú Geral","permission":"Bennys"}]'),
	(6, 'Paramedico', 500, 50, '', -582.2, -582.9, 34.64, '[{"slots":50,"permission":"Paramedico","label":"Baú","weight":1000}]'),
	(7, 'Policia', 500, 50, '', -1288.7, 328.36, 65.49, '[{"slots":50,"permission":"Policia","weight":5000,"label":"Baú"}]'),
	(8, 'Et', 500, 50, '', 2473.38, 3774.87, 56.86, '[{"weight":500,"slots":50,"label":"Baú Membro","permission":"Et,3"},{"weight":500,"slots":50,"label":"Baú Gerente","permission":"Et,2"},{"weight":500,"slots":50,"label":"Baú Lider","permission":"Et,1"}]'),
	(9, 'Barragem', 500, 50, '', 1280.42, -78.63, 75.08, '[{"weight":500,"label":"Baú Membro","permission":"Barragem,3","slots":50},{"weight":500,"label":"Baú Gerente","permission":"Barragem,2","slots":50},{"weight":500,"label":"Baú Lider","permission":"Barragem,1","slots":50}]'),
	(10, 'Paleto', 500, 50, '', 118.62, 6757.58, 45.48, '[{"weight":500,"label":"Baú Membro","permission":"Paleto,3","slots":50},{"weight":500,"label":"Baú Gerente","permission":"Paleto,2","slots":50},{"weight":500,"label":"Baú Lider","permission":"Paleto,1","slots":50}]'),
	(11, 'Pesqueiro', 500, 50, '', 3723.7, 4564.48, 30.43, '[{"weight":500,"label":"Baú Membro","permission":"Pesqueiro,3","slots":50},{"weight":500,"label":"Baú Gerente","permission":"Pesqueiro,2","slots":50},{"weight":500,"label":"Baú Lider","permission":"Pesqueiro,1","slots":50}]'),
	(12, 'Observatorio', 500, 50, '', -442.74, 1582.12, 362.76, '[{"permission":"Observatorio,3","slots":50,"label":"Baú Membro","weight":500},{"permission":"Observatorio,2","slots":50,"label":"Baú Gerente","weight":500},{"permission":"Observatorio,1","slots":50,"label":"Baú Lider","weight":500}]'),
	(13, 'Resort', 500, 50, '', -1684.56, 574.27, 157.28, '[{"weight":500,"permission":"Resort,3","label":"Baú Membro","slots":50},{"weight":500,"permission":"Resort,2","label":"Baú Gerente","slots":50},{"weight":500,"permission":"Resort,1","label":"Baú Lider","slots":50}]'),
	(14, 'Curvados', 500, 50, '', 842.97, 1859.38, 144.51, '[{"permission":"Curvados,3","weight":500,"slots":50,"label":"Baú Membro"},{"permission":"Curvados,2","weight":500,"slots":50,"label":"Baú Gerente"},{"permission":"Curvados,1","weight":500,"slots":50,"label":"Baú Lider"}]'),
	(15, 'Praia', 500, 50, '', -1221.35, -1809.12, 7.58, '[{"slots":50,"permission":"Praia,3","label":"Baú Membro","weight":500},{"slots":50,"permission":"Praia,2","label":"Baú Gerente","weight":500},{"slots":50,"permission":"Praia,1","label":"Baú Lider","weight":500}]'),
	(16, 'Tunel', 500, 50, '', 1449.33, 6344.12, 32.84, '[{"permission":"Tunel,3","label":"Baú Membro","slots":50,"weight":500},{"permission":"Tunel,2","label":"Baú Gerente","slots":50,"weight":500},{"permission":"Tunel,1","label":"Baú Lider","slots":50,"weight":500}]'),
	(17, 'Porto', 500, 50, '', 1352.85, -2534.51, 51.79, '[{"weight":500,"permission":"Porto,3","label":"Baú Membro","slots":50},{"weight":500,"permission":"Porto,2","label":"Baú Gerente","slots":50},{"weight":500,"permission":"Porto,1","label":"Baú Lider","slots":50}]'),
	(18, 'Norte', 500, 50, '', 1727.44, 4489.33, 45.37, '[{"weight":500,"slots":50,"permission":"Norte,3","label":"Baú Membro"},{"weight":500,"slots":50,"permission":"Norte,2","label":"Baú Gerente"},{"weight":500,"slots":50,"permission":"Norte,1","label":"Baú Lider"}]'),
	(19, 'Corrego', 500, 50, '', 1939.9, 713.4, 194.2, '[{"label":"Baú Membro","slots":50,"weight":500,"permission":"Corrego,3"},{"label":"Baú Gerente","slots":50,"weight":500,"permission":"Corrego,2"},{"label":"Baú Lider","slots":50,"weight":500,"permission":"Corrego,1"}]'),
	(20, 'Lago', 500, 50, '', 189.41, 703.83, 211.96, '[{"label":"Baú Membro","permission":"Lago,3","weight":500,"slots":50},{"label":"Baú Gerente","permission":"Lago,2","weight":500,"slots":50},{"label":"Baú Lider","permission":"Lago,1","weight":500,"slots":50}]'),
	(21, 'Helipa', 500, 50, '', 1308.47, -754.72, 78.04, '[{"permission":"Helipa,3","slots":50,"weight":500,"label":"Baú Membro"},{"permission":"Helipa,2","slots":50,"weight":500,"label":"Baú Gerente"},{"permission":"Helipa,1","slots":50,"weight":500,"label":"Baú Lider"}]'),
	(24, 'Mansão01', 500, 50, '', -2298.73, 4336.41, 37.08, '[{"label":"Baú","slots":50,"weight":2000,"permission":"Mansao01"}]'),
	(25, 'Mansão02', 500, 50, '', -565.17, 1265.65, 331.15, '[{"label":"Baú","slots":50,"weight":2000,"permission":"Mansao02"}]'),
	(26, 'Mansão03', 500, 50, '', 683.31, 919.23, 247.58, '[{"label":"Baú","slots":50,"weight":2000,"permission":"Mansao03"}]'),
	(27, 'Mansão04', 500, 50, '', 799.8, 3417.8, 57.88, '[{"label":"Baú","slots":50,"weight":2000,"permission":"Mansao04"}]'),
	(28, 'Mansão05', 500, 50, '', -3003.43, 2179.14, 41.5, '[{"label":"Baú","slots":50,"weight":2000,"permission":"Mansao05"}]');

-- Copiando estrutura para tabela nightevolutiontp.cleararea
CREATE TABLE IF NOT EXISTS `cleararea` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Radius` float NOT NULL DEFAULT 100,
  `ClearPeds` tinyint(1) NOT NULL DEFAULT 1,
  `ClearVehicles` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `cleararea` (`id`, `Name`, `X`, `Y`, `Z`, `Radius`, `ClearPeds`, `ClearVehicles`) VALUES
	(1, 'Auto Escola', 247.79, -1370.75, 32.89, 100, 1, 1),
	(2, 'Policia', -1335.13, 314.19, 65.48, 100, 1, 1),
	(3, 'Hospital', -555.57, -595.64, 35.1, 100, 1, 1),
	(4, 'Mecânica Redline', 1143.71, -782.37, 57.59, 100, 1, 1),
	(5, 'Mecânica Bennys', -208.27, -1346.98, 31, 100, 1, 1),
	(6, 'Et', 2473.38, 3774.87, 56.86, 100, 1, 1),
	(7, 'Barragem', 1280.42, -78.63, 75.08, 100, 1, 1),
	(8, 'Paleto', 118.62, 6757.58, 45.48, 100, 1, 1),
	(9, 'Pesqueiro', 3723.7, 4564.48, 30.43, 100, 1, 1),
	(10, 'Observatorio', -442.74, 1582.12, 362.76, 100, 1, 1),
	(11, 'Resort', -1684.56, 574.27, 157.28, 100, 1, 1),
	(12, 'Curvados', 842.97, 1859.38, 144.51, 100, 1, 1),
	(13, 'Praia', -1221.35, -1809.12, 7.58, 100, 1, 1),
	(14, 'Tunel', 1449.33, 6344.12, 32.84, 100, 1, 1),
	(15, 'Porto', 1352.85, -2534.51, 51.79, 100, 1, 1),
	(16, 'Norte', 1727.44, 4489.33, 45.37, 100, 1, 1),
	(17, 'Corrego', 1939.9, 713.4, 194.2, 100, 1, 1),
	(18, 'Lago', 189.41, 703.83, 211.96, 100, 1, 1),
	(19, 'Helipa', 1308.47, -754.72, 78.04, 100, 1, 1);

-- Copiando estrutura para tabela nightevolutiontp.cloakrooms
CREATE TABLE IF NOT EXISTS `cloakrooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Permission` varchar(255) DEFAULT NULL,
  `X` float DEFAULT NULL,
  `Y` float DEFAULT NULL,
  `Z` float DEFAULT NULL,
  `Presets` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `cloakrooms` (`id`, `Name`, `Permission`, `X`, `Y`, `Z`, `Presets`) VALUES
	(1, 'CatCafe', 'CatCafe', -1552, -450.38, 36.2, '{"Atendente":{"perm":"CatCafe","order":1,"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"pants":{"item":269,"texture":0},"arms":{"item":14,"texture":0},"hat":{"item":202,"texture":0},"decals":{"item":1,"texture":0},"glass":{"item":15,"texture":0},"accessory":{"item":0,"texture":0},"mask":{"item":0,"texture":0},"vest":{"item":0,"texture":0},"ear":{"item":12,"texture":0},"shoes":{"item":200,"texture":0},"backpack":{"item":0,"texture":0},"watch":{"item":0,"texture":1},"tshirt":{"item":7,"texture":0},"torso":{"item":794,"texture":0}},"mp_m_freemode_01":{"backpack":{"item":0,"texture":0},"glass":{"item":0,"texture":0},"arms":{"item":0,"texture":0},"hat":{"item":236,"texture":0},"decals":{"item":0,"texture":0},"bracelet":{"item":-1,"texture":-1},"accessory":{"item":0,"texture":0},"pants":{"item":201,"texture":0},"mask":{"item":0,"texture":0},"shoes":{"item":159,"texture":0},"ear":{"item":16,"texture":0},"watch":{"item":3,"texture":0},"vest":{"item":0,"texture":0},"tshirt":{"item":15,"texture":0},"torso":{"item":651,"texture":0}}},"Gerente":{"perm":"CatCafe","order":2,"mp_f_freemode_01":{"shoes":{"item":200,"texture":0},"glass":{"item":15,"texture":0},"arms":{"item":14,"texture":0},"hat":{"item":202,"texture":1},"decals":{"item":1,"texture":0},"bracelet":{"item":-1,"texture":-1},"accessory":{"item":0,"texture":0},"pants":{"item":269,"texture":0},"watch":{"item":0,"texture":1},"backpack":{"item":0,"texture":0},"ear":{"item":12,"texture":0},"vest":{"item":0,"texture":0},"mask":{"item":0,"texture":0},"tshirt":{"item":7,"texture":0},"torso":{"item":794,"texture":1}},"mp_m_freemode_01":{"backpack":{"item":0,"texture":0},"vest":{"item":0,"texture":0},"arms":{"item":0,"texture":0},"hat":{"item":236,"texture":1},"decals":{"item":0,"texture":0},"glass":{"item":0,"texture":0},"accessory":{"item":0,"texture":0},"mask":{"item":0,"texture":0},"pants":{"item":201,"texture":0},"shoes":{"item":159,"texture":0},"ear":{"item":16,"texture":0},"bracelet":{"item":-1,"texture":-1},"watch":{"item":3,"texture":0},"tshirt":{"item":15,"texture":0},"torso":{"item":651,"texture":1}}}}'),
	(2, 'MooMooCafe', 'MooMooCafe', -593.65, -1059.59, 22.53, '{"Atendente":{"perm":"MooMooCafe","order":1,"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"pants":{"item":269,"texture":0},"arms":{"item":14,"texture":0},"hat":{"item":202,"texture":2},"decals":{"item":1,"texture":0},"glass":{"item":15,"texture":0},"accessory":{"item":0,"texture":0},"mask":{"item":0,"texture":0},"vest":{"item":0,"texture":0},"ear":{"item":12,"texture":0},"shoes":{"item":200,"texture":0},"backpack":{"item":0,"texture":0},"watch":{"item":0,"texture":0},"tshirt":{"item":7,"texture":0},"torso":{"item":794,"texture":3}},"mp_m_freemode_01":{"hat":{"item":236,"texture":0},"glass":{"item":0,"texture":0},"arms":{"item":0,"texture":0},"pants":{"item":201,"texture":0},"decals":{"item":0,"texture":0},"bracelet":{"item":-1,"texture":-1},"accessory":{"item":0,"texture":0},"watch":{"item":3,"texture":0},"backpack":{"item":0,"texture":0},"shoes":{"item":159,"texture":0},"ear":{"item":16,"texture":0},"vest":{"item":0,"texture":0},"mask":{"item":0,"texture":0},"tshirt":{"item":15,"texture":0},"torso":{"item":651,"texture":3}}},"Gerente":{"perm":"MooMooCafe","order":2,"mp_f_freemode_01":{"shoes":{"item":200,"texture":0},"glass":{"item":15,"texture":0},"arms":{"item":14,"texture":0},"hat":{"item":202,"texture":3},"decals":{"item":1,"texture":0},"bracelet":{"item":-1,"texture":-1},"accessory":{"item":0,"texture":0},"pants":{"item":269,"texture":0},"watch":{"item":0,"texture":0},"backpack":{"item":0,"texture":0},"ear":{"item":12,"texture":0},"vest":{"item":0,"texture":0},"mask":{"item":0,"texture":0},"tshirt":{"item":7,"texture":0},"torso":{"item":794,"texture":2}},"mp_m_freemode_01":{"pants":{"item":201,"texture":0},"bracelet":{"item":-1,"texture":-1},"arms":{"item":0,"texture":0},"hat":{"item":236,"texture":3},"decals":{"item":0,"texture":0},"glass":{"item":0,"texture":0},"accessory":{"item":0,"texture":0},"mask":{"item":0,"texture":0},"vest":{"item":0,"texture":0},"ear":{"item":16,"texture":0},"shoes":{"item":159,"texture":0},"backpack":{"item":0,"texture":0},"watch":{"item":3,"texture":0},"tshirt":{"item":15,"texture":0},"torso":{"item":651,"texture":2}}}}'),
	(3, 'Redline', 'Redline', 1160.25, -788.32, 57.6, '{"Mecânico":{"order":2,"perm":"Redline","mp_m_freemode_01":{"accessory":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":2},"shoes":{"texture":2,"item":168},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"torso":{"texture":1,"item":638},"bracelet":{"texture":-1,"item":-1},"backpack":{"texture":0,"item":0},"pants":{"texture":1,"item":232},"tshirt":{"texture":0,"item":231},"arms":{"texture":0,"item":4}},"mp_f_freemode_01":{"decals":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":1},"shoes":{"texture":2,"item":262},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"torso":{"texture":2,"item":781},"bracelet":{"texture":-1,"item":-1},"pants":{"texture":1,"item":268},"backpack":{"texture":0,"item":0},"tshirt":{"texture":0,"item":508},"arms":{"texture":0,"item":0}}},"Diretor Geral":{"order":6,"perm":"Redline","mp_m_freemode_01":{"accessory":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":2},"shoes":{"texture":2,"item":168},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"torso":{"texture":3,"item":638},"bracelet":{"texture":-1,"item":-1},"backpack":{"texture":0,"item":0},"pants":{"texture":2,"item":232},"tshirt":{"texture":0,"item":231},"arms":{"texture":0,"item":4}},"mp_f_freemode_01":{"decals":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":1},"shoes":{"texture":2,"item":262},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"pants":{"texture":2,"item":268},"torso":{"texture":4,"item":781},"bracelet":{"texture":-1,"item":-1},"glass":{"texture":0,"item":15},"backpack":{"texture":0,"item":0},"tshirt":{"texture":0,"item":508},"arms":{"texture":0,"item":0}}},"Aprendiz":{"order":1,"perm":"Redline","mp_m_freemode_01":{"glass":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":2},"shoes":{"texture":2,"item":168},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"torso":{"texture":0,"item":638},"bracelet":{"texture":-1,"item":-1},"backpack":{"texture":0,"item":0},"pants":{"texture":0,"item":232},"tshirt":{"texture":0,"item":231},"arms":{"texture":0,"item":4}},"mp_f_freemode_01":{"decals":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":1},"shoes":{"texture":2,"item":262},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"torso":{"texture":1,"item":781},"bracelet":{"texture":-1,"item":-1},"backpack":{"texture":0,"item":0},"pants":{"texture":0,"item":268},"tshirt":{"texture":0,"item":508},"arms":{"texture":0,"item":0}}},"Diretor":{"order":5,"perm":"Redline","mp_m_freemode_01":{"glass":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":2},"shoes":{"texture":2,"item":168},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"torso":{"texture":5,"item":638},"bracelet":{"texture":-1,"item":-1},"backpack":{"texture":0,"item":0},"pants":{"texture":2,"item":232},"tshirt":{"texture":0,"item":231},"arms":{"texture":0,"item":4}},"mp_f_freemode_01":{"decals":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":1},"shoes":{"texture":2,"item":262},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"torso":{"texture":5,"item":781},"bracelet":{"texture":-1,"item":-1},"backpack":{"texture":0,"item":0},"pants":{"texture":2,"item":268},"tshirt":{"texture":0,"item":508},"arms":{"texture":0,"item":0}}},"Gerente":{"order":4,"perm":"Redline","mp_m_freemode_01":{"accessory":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":2},"shoes":{"texture":2,"item":168},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"torso":{"texture":2,"item":638},"bracelet":{"texture":-1,"item":-1},"backpack":{"texture":0,"item":0},"pants":{"texture":1,"item":232},"tshirt":{"texture":0,"item":231},"arms":{"texture":0,"item":4}},"mp_f_freemode_01":{"decals":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":1},"shoes":{"texture":2,"item":262},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"torso":{"texture":3,"item":781},"bracelet":{"texture":-1,"item":-1},"pants":{"texture":1,"item":268},"backpack":{"texture":0,"item":0},"tshirt":{"texture":0,"item":508},"arms":{"texture":0,"item":0}}},"Supervisor":{"order":3,"perm":"Redline","mp_m_freemode_01":{"decals":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":2},"shoes":{"texture":2,"item":168},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"torso":{"texture":4,"item":638},"bracelet":{"texture":-1,"item":-1},"backpack":{"texture":0,"item":0},"pants":{"texture":1,"item":232},"tshirt":{"texture":0,"item":231},"arms":{"texture":0,"item":4}},"mp_f_freemode_01":{"decals":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":1},"shoes":{"texture":2,"item":262},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"torso":{"texture":0,"item":781},"bracelet":{"texture":-1,"item":-1},"backpack":{"texture":0,"item":0},"pants":{"texture":1,"item":268},"tshirt":{"texture":0,"item":508},"arms":{"texture":0,"item":0}}}}'),
	(4, 'Bennys', 'Bennys', -235.64, -1327.03, 31.98, '{"Gerente":{"mp_f_freemode_01":{"pants":{"texture":4,"item":268},"backpack":{"texture":0,"item":0},"watch":{"texture":0,"item":1},"accessory":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"ear":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"tshirt":{"texture":1,"item":508},"arms":{"texture":0,"item":0},"torso":{"texture":8,"item":781},"shoes":{"texture":2,"item":262},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"bracelet":{"texture":-1,"item":-1}},"perm":"Redline","order":4,"mp_m_freemode_01":{"pants":{"texture":4,"item":232},"backpack":{"texture":0,"item":0},"watch":{"texture":0,"item":2},"accessory":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"tshirt":{"texture":1,"item":231},"arms":{"texture":0,"item":4},"torso":{"texture":8,"item":638},"shoes":{"texture":2,"item":168},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"bracelet":{"texture":-1,"item":-1}}},"Mecânico":{"mp_f_freemode_01":{"pants":{"texture":4,"item":268},"backpack":{"texture":0,"item":0},"watch":{"texture":0,"item":1},"accessory":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"ear":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"tshirt":{"texture":1,"item":508},"arms":{"texture":0,"item":0},"torso":{"texture":7,"item":781},"shoes":{"texture":2,"item":262},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"bracelet":{"texture":-1,"item":-1}},"perm":"Redline","order":2,"mp_m_freemode_01":{"pants":{"texture":4,"item":232},"backpack":{"texture":0,"item":0},"watch":{"texture":0,"item":2},"accessory":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"tshirt":{"texture":1,"item":231},"arms":{"texture":0,"item":4},"torso":{"texture":7,"item":638},"shoes":{"texture":2,"item":168},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"bracelet":{"texture":-1,"item":-1}}},"Diretor Geral":{"mp_f_freemode_01":{"pants":{"texture":5,"item":268},"backpack":{"texture":0,"item":0},"watch":{"texture":0,"item":1},"accessory":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"ear":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"tshirt":{"texture":1,"item":508},"arms":{"texture":0,"item":0},"torso":{"texture":9,"item":781},"shoes":{"texture":2,"item":262},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"bracelet":{"texture":-1,"item":-1}},"perm":"Redline","order":6,"mp_m_freemode_01":{"pants":{"texture":5,"item":232},"backpack":{"texture":0,"item":0},"watch":{"texture":0,"item":2},"accessory":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"ear":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"tshirt":{"texture":1,"item":231},"arms":{"texture":0,"item":4},"torso":{"texture":9,"item":638},"shoes":{"texture":2,"item":168},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"bracelet":{"texture":-1,"item":-1}}},"Diretor":{"mp_f_freemode_01":{"pants":{"texture":5,"item":268},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":1},"backpack":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"accessory":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"tshirt":{"texture":1,"item":508},"arms":{"texture":0,"item":0},"torso":{"texture":11,"item":781},"shoes":{"texture":2,"item":262},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"bracelet":{"texture":-1,"item":-1}},"perm":"Redline","order":5,"mp_m_freemode_01":{"pants":{"texture":5,"item":232},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":2},"backpack":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"tshirt":{"texture":1,"item":231},"arms":{"texture":0,"item":4},"torso":{"texture":11,"item":638},"shoes":{"texture":2,"item":168},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"bracelet":{"texture":-1,"item":-1}}},"Supervisor":{"mp_f_freemode_01":{"pants":{"texture":4,"item":268},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":1},"backpack":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"accessory":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"tshirt":{"texture":1,"item":508},"arms":{"texture":0,"item":0},"torso":{"texture":10,"item":781},"shoes":{"texture":2,"item":262},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"bracelet":{"texture":-1,"item":-1}},"perm":"Redline","order":3,"mp_m_freemode_01":{"pants":{"texture":4,"item":232},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":2},"backpack":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"tshirt":{"texture":1,"item":231},"arms":{"texture":0,"item":4},"torso":{"texture":10,"item":638},"shoes":{"texture":2,"item":168},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"bracelet":{"texture":-1,"item":-1}}},"Aprendiz":{"mp_f_freemode_01":{"pants":{"texture":3,"item":268},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":1},"backpack":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"accessory":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"tshirt":{"texture":1,"item":508},"arms":{"texture":0,"item":0},"torso":{"texture":6,"item":781},"shoes":{"texture":2,"item":262},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"bracelet":{"texture":-1,"item":-1}},"perm":"Redline","order":1,"mp_m_freemode_01":{"pants":{"texture":3,"item":232},"ear":{"texture":0,"item":0},"watch":{"texture":0,"item":2},"backpack":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"tshirt":{"texture":1,"item":231},"arms":{"texture":0,"item":4},"torso":{"texture":6,"item":638},"shoes":{"texture":2,"item":168},"mask":{"texture":0,"item":0},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"bracelet":{"texture":-1,"item":-1}}}}'),
	(6, 'Paramedico', 'Paramedico', -549.08, -584.97, 34.64, '{"Médico":{"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"torso":{"texture":1,"item":777},"tshirt":{"texture":0,"item":11},"watch":{"texture":0,"item":1},"arms":{"texture":0,"item":104},"ear":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"pants":{"texture":3,"item":133},"shoes":{"texture":1,"item":243}},"order":3,"perm":"","mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"torso":{"texture":0,"item":637},"tshirt":{"texture":0,"item":15},"watch":{"texture":0,"item":2},"arms":{"texture":0,"item":86},"ear":{"texture":0,"item":0},"accessory":{"texture":4,"item":181},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"shoes":{"texture":0,"item":159},"glass":{"texture":0,"item":0},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"pants":{"texture":0,"item":104},"decals":{"texture":0,"item":0}}},"SAMU":{"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"shoes":{"texture":1,"item":262},"tshirt":{"texture":0,"item":7},"watch":{"texture":0,"item":1},"arms":{"texture":0,"item":101},"ear":{"texture":0,"item":0},"accessory":{"texture":4,"item":146},"torso":{"texture":0,"item":778},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"pants":{"texture":0,"item":267},"decals":{"texture":0,"item":0}},"order":2,"perm":"","mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"shoes":{"texture":1,"item":168},"tshirt":{"texture":0,"item":15},"watch":{"texture":0,"item":2},"arms":{"texture":0,"item":86},"ear":{"texture":0,"item":0},"accessory":{"texture":4,"item":181},"torso":{"texture":0,"item":636},"hat":{"texture":0,"item":11},"vest":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"pants":{"texture":0,"item":231},"decals":{"texture":0,"item":0}}},"Cirurgião":{"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"shoes":{"texture":0,"item":206},"tshirt":{"texture":0,"item":11},"watch":{"texture":0,"item":1},"arms":{"texture":0,"item":102},"ear":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"torso":{"texture":2,"item":780},"hat":{"texture":0,"item":57},"vest":{"texture":0,"item":0},"glass":{"texture":0,"item":15},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"pants":{"texture":0,"item":111},"decals":{"texture":0,"item":0}},"order":1,"perm":"","mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"torso":{"texture":0,"item":635},"tshirt":{"texture":0,"item":15},"watch":{"texture":0,"item":2},"arms":{"texture":0,"item":95},"ear":{"texture":0,"item":0},"accessory":{"texture":0,"item":0},"vest":{"texture":0,"item":0},"hat":{"texture":0,"item":11},"shoes":{"texture":0,"item":159},"glass":{"texture":0,"item":0},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"pants":{"texture":7,"item":129},"decals":{"texture":0,"item":0}}}}'),
	(7, 'Policia', 'Policia', -1265.92, 341.6, 69.69, '{"1º Sargento":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":641,"texture":5},"arms":{"item":0,"texture":0},"vest":{"item":79,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":228,"texture":6},"mask":{"item":0,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":262,"texture":0},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":0,"texture":0}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":5},"arms":{"item":14,"texture":0},"vest":{"item":83,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":195,"texture":6},"mask":{"item":0,"texture":0},"tshirt":{"item":14,"texture":0},"accessory":{"item":241,"texture":0},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"watch":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":6,"perm":""},"2º Tenente":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":642,"texture":8},"arms":{"item":0,"texture":0},"vest":{"item":78,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":230,"texture":1},"mask":{"item":279,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":260,"texture":0},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":-1,"texture":-1}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":8},"arms":{"item":14,"texture":0},"vest":{"item":79,"texture":0},"mask":{"item":431,"texture":0},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":199,"texture":1},"tshirt":{"item":14,"texture":0},"watch":{"item":-1,"texture":-1},"accessory":{"item":236,"texture":0},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"ear":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":9,"perm":""},"Aspirante":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":642,"texture":7},"arms":{"item":0,"texture":0},"vest":{"item":80,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":230,"texture":1},"mask":{"item":279,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":259,"texture":1},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":-1,"texture":-1}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":7},"arms":{"item":14,"texture":0},"vest":{"item":84,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":199,"texture":1},"mask":{"item":431,"texture":0},"tshirt":{"item":14,"texture":0},"accessory":{"item":242,"texture":1},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"watch":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":8,"perm":""},"Sub-Tenente":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":642,"texture":6},"arms":{"item":0,"texture":0},"vest":{"item":80,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":230,"texture":1},"mask":{"item":279,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":259,"texture":1},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":-1,"texture":-1}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":6},"arms":{"item":14,"texture":0},"vest":{"item":84,"texture":0},"mask":{"item":431,"texture":0},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":199,"texture":1},"tshirt":{"item":14,"texture":0},"watch":{"item":-1,"texture":-1},"accessory":{"item":242,"texture":1},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"ear":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":7,"perm":""},"Capitão":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":642,"texture":10},"arms":{"item":0,"texture":0},"vest":{"item":78,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":230,"texture":2},"mask":{"item":0,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":260,"texture":0},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":-1,"texture":-1}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":10},"arms":{"item":14,"texture":0},"vest":{"item":79,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":199,"texture":2},"mask":{"item":431,"texture":0},"tshirt":{"item":14,"texture":0},"accessory":{"item":236,"texture":0},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"watch":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":11,"perm":""},"Tenente-Coronel":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":641,"texture":12},"arms":{"item":0,"texture":0},"vest":{"item":78,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":230,"texture":2},"mask":{"item":0,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":262,"texture":0},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":-1,"texture":-1}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":12},"arms":{"item":14,"texture":0},"vest":{"item":79,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":199,"texture":2},"mask":{"item":431,"texture":0},"tshirt":{"item":14,"texture":0},"accessory":{"item":241,"texture":0},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"watch":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":13,"perm":""},"1º Tenente":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":642,"texture":9},"arms":{"item":0,"texture":0},"vest":{"item":78,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":230,"texture":1},"mask":{"item":279,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":260,"texture":0},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":-1,"texture":-1}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":9},"arms":{"item":14,"texture":0},"vest":{"item":79,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":199,"texture":1},"mask":{"item":431,"texture":0},"tshirt":{"item":14,"texture":0},"accessory":{"item":236,"texture":0},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"watch":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":10,"perm":""},"Major":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":642,"texture":11},"arms":{"item":0,"texture":0},"vest":{"item":78,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":230,"texture":2},"mask":{"item":0,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":260,"texture":0},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":-1,"texture":-1}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":11},"arms":{"item":14,"texture":0},"vest":{"item":79,"texture":0},"mask":{"item":431,"texture":0},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":199,"texture":2},"tshirt":{"item":14,"texture":0},"watch":{"item":-1,"texture":-1},"accessory":{"item":236,"texture":0},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"ear":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":12,"perm":""},"Recruta":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":641,"texture":0},"arms":{"item":0,"texture":0},"vest":{"item":0,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":227,"texture":6},"mask":{"item":0,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":0,"texture":0},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":0,"texture":0}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":0},"arms":{"item":14,"texture":0},"vest":{"item":0,"texture":0},"mask":{"item":0,"texture":0},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":194,"texture":6},"tshirt":{"item":14,"texture":0},"watch":{"item":-1,"texture":-1},"accessory":{"item":0,"texture":0},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"ear":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":1,"perm":""},"Cabo":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":641,"texture":2},"arms":{"item":0,"texture":0},"vest":{"item":79,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":227,"texture":6},"mask":{"item":0,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":260,"texture":0},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":0,"texture":0}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":2},"arms":{"item":14,"texture":0},"vest":{"item":83,"texture":0},"mask":{"item":0,"texture":0},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":194,"texture":6},"tshirt":{"item":14,"texture":0},"watch":{"item":-1,"texture":-1},"accessory":{"item":237,"texture":0},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"ear":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":3,"perm":""},"Coronel":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":641,"texture":13},"arms":{"item":0,"texture":0},"vest":{"item":82,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":230,"texture":2},"mask":{"item":0,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":262,"texture":0},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":-1,"texture":-1}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":13},"arms":{"item":14,"texture":0},"vest":{"item":86,"texture":0},"mask":{"item":431,"texture":0},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":199,"texture":2},"tshirt":{"item":14,"texture":0},"watch":{"item":-1,"texture":-1},"accessory":{"item":241,"texture":0},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"ear":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":14,"perm":""},"Soldado":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":641,"texture":1},"arms":{"item":0,"texture":0},"vest":{"item":79,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":227,"texture":6},"mask":{"item":0,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":0,"texture":0},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":0,"texture":0}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":1},"arms":{"item":14,"texture":0},"vest":{"item":83,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":194,"texture":6},"mask":{"item":0,"texture":0},"tshirt":{"item":14,"texture":0},"accessory":{"item":0,"texture":0},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"watch":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":2,"perm":""},"3º Sargento":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":641,"texture":3},"arms":{"item":0,"texture":0},"vest":{"item":79,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":228,"texture":6},"mask":{"item":0,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":262,"texture":0},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":0,"texture":0}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":3},"arms":{"item":14,"texture":0},"vest":{"item":83,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":195,"texture":6},"mask":{"item":0,"texture":0},"tshirt":{"item":14,"texture":0},"accessory":{"item":241,"texture":0},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"watch":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":4,"perm":""},"2º Sargento":{"mp_m_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":641,"texture":4},"arms":{"item":0,"texture":0},"vest":{"item":79,"texture":0},"ear":{"item":-1,"texture":-1},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":228,"texture":6},"mask":{"item":0,"texture":0},"tshirt":{"item":15,"texture":0},"accessory":{"item":262,"texture":0},"shoes":{"item":168,"texture":1},"pants":{"item":233,"texture":0},"watch":{"item":3,"texture":0},"glass":{"item":0,"texture":0}},"mp_f_freemode_01":{"bracelet":{"item":-1,"texture":-1},"torso":{"item":785,"texture":4},"arms":{"item":14,"texture":0},"vest":{"item":83,"texture":0},"mask":{"item":0,"texture":0},"backpack":{"item":0,"texture":0},"decals":{"item":0,"texture":0},"hat":{"item":195,"texture":6},"tshirt":{"item":14,"texture":0},"watch":{"item":-1,"texture":-1},"accessory":{"item":241,"texture":0},"shoes":{"item":262,"texture":1},"pants":{"item":269,"texture":0},"ear":{"item":-1,"texture":-1},"glass":{"item":-1,"texture":-1}},"order":5,"perm":""}}'),
	(8, 'Policia 2', 'Policia', -1262.92, 347.21, 69.69, '{"GOT 1":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":5,"item":639},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":0,"item":15},"vest":{"texture":0,"item":76},"pants":{"texture":0,"item":233},"mask":{"texture":0,"item":279},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":5,"item":783},"tshirt":{"texture":0,"item":6},"decals":{"texture":0,"item":0},"ear":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"glass":{"texture":-1,"item":-1},"mask":{"texture":0,"item":431},"pants":{"texture":0,"item":269},"vest":{"texture":0,"item":81},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":262}},"order":14,"perm":""},"DIP 3":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":1,"item":639},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":0,"item":15},"vest":{"texture":5,"item":83},"pants":{"texture":1,"item":233},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":10,"item":782},"mask":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"accessory":{"texture":0,"item":241},"tshirt":{"texture":0,"item":6},"backpack":{"texture":0,"item":0},"pants":{"texture":2,"item":269},"shoes":{"texture":1,"item":262},"vest":{"texture":4,"item":82},"glass":{"texture":-1,"item":-1},"ear":{"texture":-1,"item":-1}},"order":3,"perm":""},"GIP 3":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":8,"item":640},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":0,"item":15},"vest":{"texture":2,"item":83},"pants":{"texture":0,"item":233},"mask":{"texture":0,"item":279},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":7,"item":782},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"tshirt":{"texture":0,"item":6},"mask":{"texture":0,"item":431},"pants":{"texture":0,"item":269},"backpack":{"texture":0,"item":0},"vest":{"texture":6,"item":82},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":262}},"order":6,"perm":""},"Probatório 1":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":6,"item":639},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":260},"tshirt":{"texture":0,"item":15},"vest":{"texture":1,"item":77},"pants":{"texture":5,"item":233},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":8,"item":783},"tshirt":{"texture":0,"item":6},"decals":{"texture":0,"item":0},"ear":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":237},"glass":{"texture":-1,"item":-1},"mask":{"texture":0,"item":0},"pants":{"texture":7,"item":269},"vest":{"texture":0,"item":80},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":14},"shoes":{"texture":1,"item":262}},"order":18,"perm":""},"GRR 3":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":2,"item":647},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":2,"item":0},"vest":{"texture":0,"item":0},"pants":{"texture":5,"item":233},"mask":{"texture":2,"item":279},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":1},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":2,"item":789},"glass":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"ear":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"tshirt":{"texture":1,"item":51},"mask":{"texture":2,"item":431},"pants":{"texture":7,"item":269},"backpack":{"texture":0,"item":0},"vest":{"texture":0,"item":0},"arms":{"texture":0,"item":3},"shoes":{"texture":1,"item":262}},"order":13,"perm":""},"GTM 1":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":0,"item":233},"watch":{"texture":0,"item":3},"torso":{"texture":3,"item":639},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":0,"item":15},"vest":{"texture":0,"item":83},"pants":{"texture":4,"item":233},"mask":{"texture":0,"item":279},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":0,"item":198},"watch":{"texture":-1,"item":-1},"torso":{"texture":4,"item":783},"mask":{"texture":0,"item":431},"decals":{"texture":0,"item":0},"glass":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"tshirt":{"texture":0,"item":6},"backpack":{"texture":0,"item":0},"pants":{"texture":6,"item":269},"ear":{"texture":-1,"item":-1},"vest":{"texture":0,"item":82},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":262}},"order":16,"perm":""},"GRR 1":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":2,"item":639},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":0,"item":15},"vest":{"texture":0,"item":0},"pants":{"texture":5,"item":233},"mask":{"texture":2,"item":279},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":3,"item":783},"glass":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"ear":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"tshirt":{"texture":0,"item":6},"mask":{"texture":2,"item":431},"pants":{"texture":7,"item":269},"backpack":{"texture":0,"item":0},"vest":{"texture":0,"item":0},"arms":{"texture":0,"item":14},"shoes":{"texture":1,"item":262}},"order":11,"perm":""},"DIP 2":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":2,"item":645},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":0,"item":15},"vest":{"texture":6,"item":83},"pants":{"texture":1,"item":233},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":1},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":6,"item":788},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"tshirt":{"texture":0,"item":6},"vest":{"texture":2,"item":82},"pants":{"texture":2,"item":269},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":262}},"order":2,"perm":""},"GTM 2":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":0,"item":232},"watch":{"texture":0,"item":3},"torso":{"texture":4,"item":645},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":0,"item":15},"vest":{"texture":1,"item":83},"pants":{"texture":4,"item":233},"mask":{"texture":0,"item":279},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":1},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":0,"item":197},"watch":{"texture":-1,"item":-1},"torso":{"texture":3,"item":788},"glass":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"ear":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"tshirt":{"texture":0,"item":6},"mask":{"texture":0,"item":0},"pants":{"texture":6,"item":269},"backpack":{"texture":0,"item":0},"vest":{"texture":0,"item":82},"arms":{"texture":0,"item":9},"shoes":{"texture":1,"item":262}},"order":17,"perm":""},"GRR 2":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":3,"item":645},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":0,"item":15},"vest":{"texture":0,"item":0},"pants":{"texture":5,"item":233},"mask":{"texture":2,"item":279},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":4,"item":788},"mask":{"texture":2,"item":431},"decals":{"texture":0,"item":0},"glass":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"tshirt":{"texture":0,"item":6},"backpack":{"texture":0,"item":0},"pants":{"texture":7,"item":269},"ear":{"texture":-1,"item":-1},"vest":{"texture":0,"item":0},"arms":{"texture":0,"item":3},"shoes":{"texture":1,"item":262}},"order":12,"perm":""},"GATE 1":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":4,"item":639},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":0,"item":15},"vest":{"texture":1,"item":82},"pants":{"texture":3,"item":233},"mask":{"texture":1,"item":279},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":7,"item":783},"glass":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"ear":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"tshirt":{"texture":0,"item":6},"mask":{"texture":1,"item":431},"pants":{"texture":3,"item":269},"backpack":{"texture":0,"item":0},"vest":{"texture":1,"item":86},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":262}},"order":7,"perm":""},"GATE 2":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":5,"item":646},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":0,"item":15},"vest":{"texture":0,"item":0},"pants":{"texture":0,"item":233},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":1},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":4,"item":787},"mask":{"texture":0,"item":0},"decals":{"texture":0,"item":0},"glass":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"tshirt":{"texture":0,"item":6},"backpack":{"texture":0,"item":0},"pants":{"texture":0,"item":269},"ear":{"texture":-1,"item":-1},"vest":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":262}},"order":8,"perm":""},"GIP 2":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":2,"item":648},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":2,"item":0},"vest":{"texture":0,"item":0},"pants":{"texture":0,"item":233},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":1},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":1,"item":786},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"tshirt":{"texture":1,"item":52},"mask":{"texture":0,"item":0},"pants":{"texture":0,"item":269},"backpack":{"texture":0,"item":0},"vest":{"texture":0,"item":0},"arms":{"texture":0,"item":3},"shoes":{"texture":1,"item":262}},"order":5,"perm":""},"GATE 4":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":0,"item":234},"watch":{"texture":0,"item":3},"torso":{"texture":5,"item":645},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":260},"tshirt":{"texture":0,"item":15},"vest":{"texture":0,"item":0},"pants":{"texture":3,"item":233},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":1},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":0,"item":201},"watch":{"texture":-1,"item":-1},"torso":{"texture":4,"item":787},"tshirt":{"texture":0,"item":6},"decals":{"texture":0,"item":0},"ear":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":237},"glass":{"texture":-1,"item":-1},"mask":{"texture":0,"item":0},"pants":{"texture":3,"item":269},"vest":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":262}},"order":10,"perm":""},"GOT 2":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":8,"item":645},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":0,"item":15},"vest":{"texture":0,"item":76},"pants":{"texture":0,"item":233},"mask":{"texture":0,"item":279},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":1},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":8,"item":788},"glass":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"ear":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"tshirt":{"texture":0,"item":6},"mask":{"texture":0,"item":431},"pants":{"texture":0,"item":269},"backpack":{"texture":0,"item":0},"vest":{"texture":0,"item":81},"arms":{"texture":0,"item":9},"shoes":{"texture":1,"item":262}},"order":15,"perm":""},"BOPE 2":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":10,"item":229},"watch":{"texture":-1,"item":-1},"torso":{"texture":9,"item":640},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":0},"tshirt":{"texture":0,"item":15},"vest":{"texture":1,"item":85},"pants":{"texture":3,"item":236},"mask":{"texture":3,"item":280},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":0,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":9,"item":196},"watch":{"texture":-1,"item":-1},"torso":{"texture":8,"item":782},"glass":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"ear":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":237},"tshirt":{"texture":0,"item":6},"mask":{"texture":3,"item":432},"pants":{"texture":1,"item":270},"backpack":{"texture":0,"item":0},"vest":{"texture":1,"item":88},"arms":{"texture":0,"item":14},"shoes":{"texture":1,"item":262}},"order":21,"perm":""},"Probatório 2":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":6,"item":645},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":260},"tshirt":{"texture":0,"item":15},"vest":{"texture":0,"item":0},"pants":{"texture":5,"item":233},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":5,"item":788},"glass":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"ear":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":237},"tshirt":{"texture":0,"item":6},"mask":{"texture":0,"item":0},"pants":{"texture":7,"item":269},"backpack":{"texture":0,"item":0},"vest":{"texture":0,"item":0},"arms":{"texture":0,"item":14},"shoes":{"texture":1,"item":262}},"order":19,"perm":""},"BOPE 1":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":0,"item":229},"watch":{"texture":-1,"item":-1},"torso":{"texture":0,"item":640},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":0},"tshirt":{"texture":0,"item":15},"vest":{"texture":0,"item":85},"pants":{"texture":0,"item":236},"mask":{"texture":2,"item":280},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":3,"item":196},"watch":{"texture":-1,"item":-1},"torso":{"texture":0,"item":782},"mask":{"texture":2,"item":432},"decals":{"texture":0,"item":0},"glass":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":237},"tshirt":{"texture":0,"item":6},"backpack":{"texture":0,"item":0},"pants":{"texture":2,"item":270},"ear":{"texture":-1,"item":-1},"vest":{"texture":0,"item":88},"arms":{"texture":0,"item":14},"shoes":{"texture":1,"item":262}},"order":20,"perm":""},"GATE 3":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":0,"item":649},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":0,"item":15},"vest":{"texture":0,"item":0},"pants":{"texture":0,"item":233},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":0,"item":792},"glass":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"ear":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"tshirt":{"texture":0,"item":6},"mask":{"texture":0,"item":0},"pants":{"texture":0,"item":269},"backpack":{"texture":0,"item":0},"vest":{"texture":0,"item":0},"arms":{"texture":0,"item":9},"shoes":{"texture":1,"item":262}},"order":9,"perm":""},"DIP 1":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":0,"item":643},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":260},"tshirt":{"texture":1,"item":0},"vest":{"texture":0,"item":0},"pants":{"texture":1,"item":233},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":1},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":0,"item":791},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":237},"tshirt":{"texture":0,"item":52},"mask":{"texture":0,"item":0},"pants":{"texture":2,"item":269},"backpack":{"texture":0,"item":0},"vest":{"texture":0,"item":0},"arms":{"texture":0,"item":15},"shoes":{"texture":1,"item":262}},"order":1,"perm":""},"GIP 1":{"mp_m_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":0,"item":3},"torso":{"texture":1,"item":647},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":0,"item":0},"accessory":{"texture":0,"item":262},"tshirt":{"texture":1,"item":76},"vest":{"texture":0,"item":0},"pants":{"texture":0,"item":233},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":1},"shoes":{"texture":1,"item":168}},"mp_f_freemode_01":{"bracelet":{"texture":-1,"item":-1},"hat":{"texture":-1,"item":-1},"watch":{"texture":-1,"item":-1},"torso":{"texture":2,"item":791},"ear":{"texture":-1,"item":-1},"decals":{"texture":0,"item":0},"glass":{"texture":-1,"item":-1},"accessory":{"texture":0,"item":241},"tshirt":{"texture":1,"item":52},"vest":{"texture":0,"item":0},"pants":{"texture":0,"item":269},"mask":{"texture":0,"item":0},"backpack":{"texture":0,"item":0},"arms":{"texture":0,"item":0},"shoes":{"texture":1,"item":262}},"order":4,"perm":""}}');

-- Copiando estrutura para tabela nightevolutiontp.codes_creative
CREATE TABLE IF NOT EXISTS `codes_creative` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Code` varchar(50) NOT NULL DEFAULT '',
  `Rewards` longtext DEFAULT NULL,
  `Max` int(9) NOT NULL DEFAULT 1,
  `Used` int(9) NOT NULL DEFAULT 0,
  `CreatedAt` bigint(19) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.codes_creative_redeemd
CREATE TABLE IF NOT EXISTS `codes_creative_redeemd` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Code` varchar(50) NOT NULL DEFAULT '',
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `RedeemdAt` bigint(19) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.crafting
CREATE TABLE IF NOT EXISTS `crafting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Mode` varchar(50) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Circle` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `crafting` (`id`, `Name`, `Mode`, `X`, `Y`, `Z`, `Circle`) VALUES
	(1, 'CatCafe', 'Restaurantes', -1555.34, -452.3, 36.2, 1),
	(3, 'MooMooCafe', 'Restaurantes', -588.63, -1059.51, 22.33, 1),
	(4, 'Et', 'Et', 2475.03, 3777.02, 56.86, 1),
	(5, 'Barragem', 'Barragem', 1282.77, -80.07, 75.08, 1),
	(6, 'Paleto', 'Paleto', 124.53, 6751.97, 45.58, 1),
	(7, 'Pesqueiro', 'Pesqueiro', 3716.35, 4553.13, 30.61, 1),
	(8, 'Pesqueiro', 'Pesqueiro', -431.92, 1580.8, 362.3, 1),
	(9, 'Resort', 'Resort', -1694.69, 565.41, 157.45, 1),
	(10, 'Curvados', 'Curvados', 851, 1861.84, 144.69, 1),
	(11, 'Praia', 'Praia', -1223.66, -1800.71, 7.75, 1),
	(12, 'Tunel', 'Tunel', 1454.81, 6356.69, 33, 1),
	(13, 'Porto', 'Porto', 1361.85, -2544.54, 51.97, 1),
	(14, 'Norte', 'Norte', 1729.57, 4503.4, 45.54, 1),
	(15, 'Corrego', 'Corrego', 1948.63, 714.46, 194.36, 1),
	(16, 'Lago', 'Lago', 187.16, 694.1, 212.14, 1),
	(17, 'Helipa', 'Helipa', 1308.38, -761.9, 78.23, 1);

-- Copiando estrutura para tabela nightevolutiontp.crafting_configs
CREATE TABLE IF NOT EXISTS `crafting_configs` (
  `Mode` varchar(50) NOT NULL,
  `Permission` varchar(50) DEFAULT NULL,
  `List` longtext DEFAULT NULL,
  PRIMARY KEY (`Mode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `crafting_configs` (`Mode`, `Permission`, `List`) VALUES
	('Barragem', 'Barragem', '{"blowtorch":{"Required":{"sheetmetal":2,"aluminum":5},"Amount":1}}'),
	('Corrego', 'Corrego', '{"WEAPON_SMG_AMMO":{"Amount":1,"Required":{"gunpowder":1,"copper_pure":1,"lead_pure":1}},"WEAPON_SHOTGUN_AMMO":{"Amount":1,"Required":{"gunpowder":1,"copper_pure":1,"lead_pure":1}},"WEAPON_PISTOL_AMMO":{"Amount":1,"Required":{"gunpowder":1,"copper_pure":1,"lead_pure":1}},"WEAPON_RIFLE_AMMO":{"Amount":1,"Required":{"gunpowder":1,"copper_pure":1,"lead_pure":1}}}'),
	('Curvados', 'Curvados', '{"racestablet":{"Amount":1,"Required":{"screws":4,"copper":10,"sheetmetal":2,"aluminum":10,"metalspring":1}},"handcuff":{"Amount":1,"Required":{"copper":7,"aluminum":10}},"card02":{"Amount":1,"Required":{"plastic":10,"dirtydollar":20}},"repairkit02":{"Amount":1,"Required":{"aluminum":5,"sheetmetal":2,"scotchtape":2,"roadsigns":2,"copper":5}},"lockpick":{"Amount":1,"Required":{"aluminum":30,"copper":30,"sheetmetal":2}},"racesticket":{"Amount":1,"Required":{"plastic":25,"dirtydollar":25}},"ballisticplate":{"Amount":1,"Required":{"copper":5,"sheetmetal":3,"aluminum":5,"roadsigns":3,"tarp":3}},"ATTACH_GRIP":{"Amount":1,"Required":{"plastic":15,"rubber":15,"scotchtape":1,"electroniccomponents":1,"insulatingtape":1}},"ATTACH_FLASHLIGHT":{"Amount":1,"Required":{"plastic":15,"glass":15,"insulatingtape":1,"scotchtape":1,"batteryaaplus":1,"batteryaa":1}},"ATTACH_SILENCER":{"Amount":1,"Required":{"plastic":20,"copper":20,"emptybottle":1,"scotchtape":5,"insulatingtape":5,"toothpaste":1}},"card04":{"Amount":1,"Required":{"plastic":20,"dirtydollar":20}},"c4":{"Amount":1,"Required":{"explosives":3,"scotchtape":5}},"ATTACH_CROSSHAIR":{"Amount":1,"Required":{"plastic":15,"copper":15,"glass":15,"insulatingtape":1,"scotchtape":1,"batteryaaplus":1,"batteryaa":1}},"blocksignal":{"Amount":1,"Required":{"plastic":10}},"repairkit01":{"Amount":1,"Required":{"aluminum":5,"sheetmetal":1,"scotchtape":1,"roadsigns":1,"copper":5}},"card05":{"Amount":1,"Required":{"plastic":25,"dirtydollar":30}},"repairkit04":{"Amount":1,"Required":{"aluminum":10,"sheetmetal":10,"scotchtape":10,"roadsigns":10,"copper":10}},"card03":{"Amount":1,"Required":{"plastic":15,"dirtydollar":20}},"card01":{"Amount":1,"Required":{"plastic":5,"dirtydollar":20}},"dismantle":{"Amount":1,"Required":{"plastic":5,"dirtydollar":5}},"repairkit03":{"Amount":1,"Required":{"aluminum":7,"sheetmetal":4,"scotchtape":4,"roadsigns":4,"copper":7}},"ATTACH_MAGAZINE":{"Amount":1,"Required":{"plastic":15,"rubber":15,"scotchtape":1,"electroniccomponents":1,"insulatingtape":1}},"hood":{"Amount":1,"Required":{"rubber":10,"tarp":5}}}'),
	('Et', 'Et', '{"blowtorch":{"Amount":1,"Required":{"sheetmetal":2,"aluminum":5}}}'),
	('Helipa', 'Helipa', '{"washbleach":{"Amount":1,"Required":{"sulfuric":1,"saline":2,"glass":1,"alcohol":1}},"washbattery":{"Amount":1,"Required":{"batteryaaplus":7,"aluminum":15,"copper":20,"electroniccomponents":5,"sheetmetal":3}}}'),
	('Lago', 'Lago', '{"washbleach":{"Amount":1,"Required":{"sulfuric":1,"saline":2,"glass":1,"alcohol":1}},"washbattery":{"Amount":1,"Required":{"batteryaaplus":7,"aluminum":15,"copper":20,"electroniccomponents":5,"sheetmetal":3}}}'),
	('Norte', 'Norte', '{"WEAPON_SMG_AMMO":{"Amount":1,"Required":{"gunpowder":1,"copper_pure":1,"lead_pure":1}},"WEAPON_SHOTGUN_AMMO":{"Amount":1,"Required":{"gunpowder":1,"copper_pure":1,"lead_pure":1}},"WEAPON_PISTOL_AMMO":{"Amount":1,"Required":{"gunpowder":1,"copper_pure":1,"lead_pure":1}},"WEAPON_RIFLE_AMMO":{"Amount":1,"Required":{"gunpowder":1,"copper_pure":1,"lead_pure":1}}}'),
	('Observatorio', 'Observatorio', '{"codeine":{"Required":{"alcohol":2,"analgesic":1,"sulfuric":2},"Amount":1},"metadone":{"Required":{"alcohol":2,"analgesic":1,"sulfuric":2},"Amount":1},"joint":{"Required":{"weed":1},"Amount":1},"methsack":{"Required":{"meth":10},"Amount":1},"weedsack":{"Required":{"joint":10},"Amount":1},"cokesack":{"Required":{"cocaine":10},"Amount":1},"crack":{"Required":{"acetone":2,"cocaine":10},"Amount":1},"cocaine":{"Required":{"coke":1},"Amount":1},"amphetamine":{"Required":{"meth":6,"cocaine":6},"Amount":1},"meth":{"Required":{"saline":1,"sulfuric":1},"Amount":5},"heroin":{"Required":{"saline":2,"alcohol":2,"meth":7,"sulfuric":2},"Amount":1}}'),
	('Paleto', 'Paleto', '{"codeine":{"Required":{"alcohol":2,"analgesic":1,"sulfuric":2},"Amount":1},"metadone":{"Required":{"alcohol":2,"analgesic":1,"sulfuric":2},"Amount":1},"joint":{"Required":{"weed":1},"Amount":1},"methsack":{"Required":{"meth":10},"Amount":1},"weedsack":{"Required":{"joint":10},"Amount":1},"cokesack":{"Required":{"cocaine":10},"Amount":1},"crack":{"Required":{"acetone":2,"cocaine":10},"Amount":1},"cocaine":{"Required":{"coke":1},"Amount":1},"amphetamine":{"Required":{"meth":6,"cocaine":6},"Amount":1},"meth":{"Required":{"saline":1,"sulfuric":1},"Amount":5},"heroin":{"Required":{"saline":2,"alcohol":2,"meth":7,"sulfuric":2},"Amount":1}}'),
	('Pesqueiro', 'Pesqueiro', '{"codeine":{"Required":{"alcohol":2,"analgesic":1,"sulfuric":2},"Amount":1},"metadone":{"Required":{"alcohol":2,"analgesic":1,"sulfuric":2},"Amount":1},"joint":{"Required":{"weed":1},"Amount":1},"methsack":{"Required":{"meth":10},"Amount":1},"weedsack":{"Required":{"joint":10},"Amount":1},"cokesack":{"Required":{"cocaine":10},"Amount":1},"crack":{"Required":{"acetone":2,"cocaine":10},"Amount":1},"cocaine":{"Required":{"coke":1},"Amount":1},"amphetamine":{"Required":{"meth":6,"cocaine":6},"Amount":1},"meth":{"Required":{"saline":1,"sulfuric":1},"Amount":5},"heroin":{"Required":{"saline":2,"alcohol":2,"meth":7,"sulfuric":2},"Amount":1}}'),
	('Porto', 'Porto', '{"WEAPON_SMG_AMMO":{"Amount":1,"Required":{"gunpowder":1,"copper_pure":1,"lead_pure":1}},"WEAPON_SHOTGUN_AMMO":{"Amount":1,"Required":{"gunpowder":1,"copper_pure":1,"lead_pure":1}},"WEAPON_PISTOL_AMMO":{"Amount":1,"Required":{"gunpowder":1,"copper_pure":1,"lead_pure":1}},"WEAPON_RIFLE_AMMO":{"Amount":1,"Required":{"gunpowder":1,"copper_pure":1,"lead_pure":1}}}'),
	('Praia', 'Praia', '{"WEAPON_PISTOL":{"Amount":1,"Required":{"pistolbody":1,"weaponparts":3,"metalspring":1,"glass":100,"rubber":100,"plastic":120,"copper":75,"aluminum":75}},"WEAPON_PISTOL_MK2":{"Amount":1,"Required":{"pistolbody":1,"weaponparts":3,"metalspring":1,"glass":115,"rubber":115,"plastic":135,"copper":75,"aluminum":75}},"WEAPON_SNSPISTOL":{"Amount":1,"Required":{"pistolbody":1,"weaponparts":3,"metalspring":1,"glass":75,"rubber":100,"plastic":65,"copper":55,"aluminum":65}},"WEAPON_SNSPISTOL_MK2":{"Amount":1,"Required":{"pistolbody":1,"weaponparts":3,"metalspring":1,"glass":75,"rubber":100,"plastic":110,"copper":75,"aluminum":75}},"WEAPON_VINTAGEPISTOL":{"Amount":1,"Required":{"pistolbody":1,"weaponparts":3,"metalspring":1,"glass":75,"rubber":75,"plastic":100,"copper":50,"aluminum":50}},"WEAPON_PISTOL50":{"Amount":1,"Required":{"pistolbody":1,"weaponparts":5,"metalspring":1,"glass":155,"rubber":155,"plastic":165,"copper":100,"aluminum":100}},"WEAPON_MACHINEPISTOL":{"Amount":1,"Required":{"smgbody":1,"weaponparts":5,"metalspring":2,"glass":145,"rubber":145,"plastic":155,"copper":100,"aluminum":100}},"WEAPON_MICROSMG":{"Amount":1,"Required":{"smgbody":1,"weaponparts":5,"metalspring":2,"glass":225,"rubber":235,"plastic":275,"copper":175,"aluminum":175}},"WEAPON_MINISMG":{"Amount":1,"Required":{"smgbody":1,"weaponparts":5,"metalspring":2,"glass":225,"rubber":235,"plastic":275,"copper":175,"aluminum":175}},"WEAPON_GUSENBERG":{"Amount":1,"Required":{"smgbody":1,"weaponparts":5,"metalspring":2,"glass":275,"rubber":305,"plastic":305,"copper":225,"aluminum":225}},"WEAPON_PUMPSHOTGUN_MK2":{"Amount":1,"Required":{"riflebody":1,"weaponparts":8,"metalspring":2,"glass":375,"rubber":425,"plastic":345,"copper":175,"aluminum":175}},"WEAPON_SAWNOFFSHOTGUN":{"Amount":1,"Required":{"riflebody":1,"weaponparts":5,"metalspring":1,"glass":225,"rubber":255,"plastic":265,"copper":175,"aluminum":175}},"WEAPON_COMPACTRIFLE":{"Amount":1,"Required":{"riflebody":1,"weaponparts":8,"metalspring":2,"glass":305,"rubber":325,"plastic":265,"copper":175,"aluminum":175}},"WEAPON_ADVANCEDRIFLE":{"Amount":1,"Required":{"riflebody":1,"weaponparts":10,"metalspring":3,"glass":385,"rubber":405,"plastic":405,"copper":335,"aluminum":325}},"WEAPON_BULLPUPRIFLE_MK2":{"Amount":1,"Required":{"riflebody":1,"weaponparts":10,"metalspring":3,"glass":305,"rubber":425,"plastic":425,"copper":300,"aluminum":425}},"WEAPON_SPECIALCARBINE":{"Amount":1,"Required":{"riflebody":1,"weaponparts":10,"metalspring":3,"glass":305,"rubber":425,"plastic":425,"copper":425,"aluminum":300}},"WEAPON_SPECIALCARBINE_MK2":{"Amount":1,"Required":{"riflebody":1,"weaponparts":10,"metalspring":3,"glass":275,"rubber":400,"plastic":400,"copper":425,"aluminum":345}},"WEAPON_ASSAULTRIFLE":{"Amount":1,"Required":{"riflebody":1,"weaponparts":10,"metalspring":3,"glass":305,"rubber":425,"plastic":425,"copper":425,"aluminum":300}},"WEAPON_ASSAULTRIFLE_MK2":{"Amount":1,"Required":{"riflebody":1,"weaponparts":10,"metalspring":3,"glass":275,"rubber":400,"plastic":400,"copper":425,"aluminum":345}}}'),
	('Resort', 'Resort', '{"racestablet":{"Amount":1,"Required":{"screws":4,"copper":10,"sheetmetal":2,"aluminum":10,"metalspring":1}},"handcuff":{"Amount":1,"Required":{"copper":7,"aluminum":10}},"card02":{"Amount":1,"Required":{"plastic":10,"dirtydollar":20}},"repairkit02":{"Amount":1,"Required":{"aluminum":5,"sheetmetal":2,"scotchtape":2,"roadsigns":2,"copper":5}},"lockpick":{"Amount":1,"Required":{"aluminum":30,"copper":30,"sheetmetal":2}},"racesticket":{"Amount":1,"Required":{"plastic":25,"dirtydollar":25}},"ballisticplate":{"Amount":1,"Required":{"copper":5,"sheetmetal":3,"aluminum":5,"roadsigns":3,"tarp":3}},"ATTACH_GRIP":{"Amount":1,"Required":{"plastic":15,"rubber":15,"scotchtape":1,"electroniccomponents":1,"insulatingtape":1}},"ATTACH_FLASHLIGHT":{"Amount":1,"Required":{"plastic":15,"glass":15,"insulatingtape":1,"scotchtape":1,"batteryaaplus":1,"batteryaa":1}},"ATTACH_SILENCER":{"Amount":1,"Required":{"plastic":20,"copper":20,"emptybottle":1,"scotchtape":5,"insulatingtape":5,"toothpaste":1}},"card04":{"Amount":1,"Required":{"plastic":20,"dirtydollar":20}},"c4":{"Amount":1,"Required":{"explosives":3,"scotchtape":5}},"ATTACH_CROSSHAIR":{"Amount":1,"Required":{"plastic":15,"copper":15,"glass":15,"insulatingtape":1,"scotchtape":1,"batteryaaplus":1,"batteryaa":1}},"blocksignal":{"Amount":1,"Required":{"plastic":10}},"repairkit01":{"Amount":1,"Required":{"aluminum":5,"sheetmetal":1,"scotchtape":1,"roadsigns":1,"copper":5}},"card05":{"Amount":1,"Required":{"plastic":25,"dirtydollar":30}},"repairkit04":{"Amount":1,"Required":{"aluminum":10,"sheetmetal":10,"scotchtape":10,"roadsigns":10,"copper":10}},"card03":{"Amount":1,"Required":{"plastic":15,"dirtydollar":20}},"card01":{"Amount":1,"Required":{"plastic":5,"dirtydollar":20}},"dismantle":{"Amount":1,"Required":{"plastic":5,"dirtydollar":5}},"repairkit03":{"Amount":1,"Required":{"aluminum":7,"sheetmetal":4,"scotchtape":4,"roadsigns":4,"copper":7}},"ATTACH_MAGAZINE":{"Amount":1,"Required":{"plastic":15,"rubber":15,"scotchtape":1,"electroniccomponents":1,"insulatingtape":1}},"hood":{"Amount":1,"Required":{"rubber":10,"tarp":5}}}'),
	('Restaurantes', 'Restaurantes', '{\r\n    "nigirizushi": {"Amount": 1, "Required": {"fishfillet": 3, "ricebag": 1}}, \r\n    "sushi": {"Amount": 1, "Required": {"fishfillet": 2, "sugarbox": 1}}, \r\n    "cupcake": {"Amount": 1, "Required": {"milkbottle": 1, "chocolate": 1, "sugarbox": 1}}, \r\n    "applelove": {"Amount": 1, "Required": {"sugarbox": 1, "apple": 1}}, \r\n    "cookies": {"Amount": 1, "Required": {"milkbottle": 1, "chocolate": 1, "sugarbox": 1}}, \r\n    "hamburger2": {"Amount": 1, "Required": {"meatfillet": 1, "mayonnaise": 1, "ryebread": 1}}, \r\n    "hamburger3": {"Amount": 1, "Required": {"meatfillet": 1, "mayonnaise": 1, "ryebread": 1}}, \r\n    "pizzamozzarella": {"Amount": 1, "Required": {"milkbottle": 1, "ryebread": 1, "water": 1, "tomato": 1}}, \r\n    "pizzabanana": {"Amount": 1, "Required": {"milkbottle": 1, "ryebread": 1, "water": 1, "banana": 1}}, \r\n    "pizzachocolate": {"Amount": 1, "Required": {"milkbottle": 1, "ryebread": 1, "water": 1, "chocolate": 1}}, \r\n    "donut": {"Amount": 1, "Required": {"milkbottle": 1, "chocolate": 1, "sugarbox": 1}}, \r\n    "fries": {"Amount": 1, "Required": {"potato": 1}}, \r\n    "hotdog": {"Amount": 1, "Required": {"ryebread": 1, "sausage": 1}}, \r\n    "sandwich": {"Amount": 1, "Required": {"ryebread": 1, "tomato": 1}}, \r\n    "tacos": {"Amount": 1, "Required": {"tortilla": 1, "tomato": 1, "meatfillet": 1}}, \r\n    "milkshake": {"Amount": 1, "Required": {"milkbottle": 1, "strawberry": 1}}, \r\n    "cappuccino": {"Amount": 1, "Required": {"milkbottle": 1, "chocolate": 1, "coffee": 1}}, \r\n    "passionjuice": {"Amount": 1, "Required": {"passion": 2, "water": 1}}, \r\n    "tangejuice": {"Amount": 1, "Required": {"tange": 1, "water": 1}}, \r\n    "orangejuice": {"Amount": 1, "Required": {"orange": 1, "water": 1}}, \r\n    "applejuice": {"Amount": 1, "Required": {"apple": 1, "water": 1}}, \r\n    "grapejuice": {"Amount": 1, "Required": {"grape": 1, "water": 1}}, \r\n    "lemonjuice": {"Amount": 1, "Required": {"lemon": 1, "water": 1}}, \r\n    "bananajuice": {"Amount": 1, "Required": {"banana": 1, "water": 1}}, \r\n    "acerolajuice": {"Amount": 1, "Required": {"acerola": 1, "water": 1}}, \r\n    "strawberryjuice": {"Amount": 1, "Required": {"strawberry": 1, "water": 1}}, \r\n    "blueberryjuice": {"Amount": 1, "Required": {"blueberry": 1, "water": 1}}, \r\n    "coffeemilk": {"Amount": 1, "Required": {"coffee": 1, "milkbottle": 1}}, \r\n    "water": {"Amount": 1, "Required": {"emptybottle": 1}}, \r\n    "combo1": {"Amount": 1, "Required": {"hamburger2": 2, "water": 2}}, \r\n    "combo2": {"Amount": 1, "Required": {"hamburger2": 2, "hamburger3": 1, "water": 1, "orangejuice": 2}}, \r\n    "combo3": {"Amount": 1, "Required": {"hamburger2": 3, "hamburger3": 2, "donut": 2, "water": 2, "milkshake": 2}},\r\n    "COMBOPFELINO": {"Amount": 1, "Required": {"catburger": 1, "milkuwu": 1}}, \r\n    "COMBOMMIAW": {"Amount": 1, "Required": {"catburger": 1, "mlkmorango": 1}}, \r\n    "COMBOGGARFIELD": {"Amount": 1, "Required": {"ursoburger": 1, "milkchocolate": 1}}, \r\n    "COMBOBABYCAT": {"Amount": 1, "Required": {"catburger": 1, "mamadeira": 1}}, \r\n    "COMBOPATINHAS": {"Amount": 1, "Required": {"coxinha": 2, "sucodeuva": 1}}, \r\n    "catburger": {"Amount": 1, "Required": {"meatfillet": 1, "ryebread": 1, "mayonnaise": 1}}, \r\n    "milkcereja": {"Amount": 1, "Required": {"milkbottle": 1, "cherry": 1}}, \r\n    "milkfrutos": {"Amount": 1, "Required": {"milkbottle": 1, "strawberry": 1, "grape": 1}}, \r\n    "mlkmorango": {"Amount": 1, "Required": {"milkbottle": 1, "strawberry": 1}}, \r\n    "milkchocolate": {"Amount": 1, "Required": {"milkbottle": 1, "chocolate": 1}}, \r\n    "pirulito": {"Amount": 1, "Required": {"sugarbox": 2}}, \r\n    "sorvete": {"Amount": 1, "Required": {"milkbottle": 1, "strawberry": 1}}, \r\n    "cafe": {"Amount": 1, "Required": {"coffee": 1, "water": 1}}, \r\n    "mamadeira": {"Amount": 1, "Required": {"milkbottle": 1}}, \r\n    "sorvete2": {"Amount": 1, "Required": {"milkbottle": 1, "chocolate": 1}}, \r\n    "milkuwu": {"Amount": 1, "Required": {"milkbottle": 1, "sugarbox": 1}}, \r\n    "marshmellow": {"Amount": 1, "Required": {"sugarbox": 2, "water": 1}}, \r\n    "coxinha": {"Amount": 1, "Required": {"flour": 1, "chicken": 1}}, \r\n    "chaverde": {"Amount": 1, "Required": {"tealeaf": 1, "water": 1}}, \r\n    "melancia": {"Amount": 1, "Required": {"watermelon": 1}}, \r\n    "catpanqueca": {"Amount": 1, "Required": {"flour": 1, "milkbottle": 1, "sugarbox": 1}}, \r\n    "ursoburger": {"Amount": 1, "Required": {"meatfillet": 2, "ryebread": 1, "mayonnaise": 1}}, \r\n    "iogurtedemaca": {"Amount": 1, "Required": {"milkbottle": 1, "apple": 1}}, \r\n    "sucodekiwi": {"Amount": 1, "Required": {"kiwi": 1, "water": 1}}, \r\n    "sucodelimao": {"Amount": 1, "Required": {"lemon": 1, "water": 1}}, \r\n    "sucodelaranja": {"Amount": 1, "Required": {"orange": 1, "water": 1}}, \r\n    "sucodemorango": {"Amount": 1, "Required": {"strawberry": 1, "water": 1}}, \r\n    "pudimdeuva": {"Amount": 1, "Required": {"grape": 2, "sugarbox": 1, "milkbottle": 1}}, \r\n    "tortadeamendoim": {"Amount": 1, "Required": {"peanut": 2, "flour": 1, "sugarbox": 1}}, \r\n    "torrada": {"Amount": 1, "Required": {"ryebread": 1, "mayonnaise": 1}}, \r\n    "churros": {"Amount": 1, "Required": {"flour": 1, "sugarbox": 1, "chocolate": 1}}, \r\n    "capuccino": {"Amount": 1, "Required": {"coffee": 1, "milkbottle": 1, "chocolate": 1}}, \r\n    "leitecomcanela": {"Amount": 1, "Required": {"milkbottle": 1, "cinnamon": 1}}, \r\n    "chocolatecremoso": {"Amount": 1, "Required": {"milkbottle": 1, "chocolate": 2}}, \r\n    "coelhodechocolate": {"Amount": 1, "Required": {"chocolate": 2}}, \r\n    "cupcakerecheado": {"Amount": 1, "Required": {"flour": 1, "milkbottle": 1, "chocolate": 1}}, \r\n    "cupcakedeabóbora": {"Amount": 1, "Required": {"flour": 1, "milkbottle": 1, "pumpkin": 1}}, \r\n    "cupcakededefranboesa": {"Amount": 1, "Required": {"flour": 1, "milkbottle": 1, "raspberry": 1}}, \r\n    "cupcakedemorango": {"Amount": 1, "Required": {"flour": 1, "milkbottle": 1, "strawberry": 1}}, \r\n    "cupcakedelaranja": {"Amount": 1, "Required": {"flour": 1, "milkbottle": 1, "orange": 1}}, \r\n    "bolinhodecereja": {"Amount": 1, "Required": {"flour": 1, "sugarbox": 1, "cherry": 1}}, \r\n    "supermilkshakerosa": {"Amount": 1, "Required": {"milkbottle": 2, "strawberry": 2, "sugarbox": 1}}, \r\n    "supermilkshakechocolate": {"Amount": 1, "Required": {"milkbottle": 2, "chocolate": 2, "sugarbox": 1}}, \r\n    "iogurtemorango": {"Amount": 1, "Required": {"milkbottle": 1, "strawberry": 1}}, \r\n    "bolococo": {"Amount": 1, "Required": {"flour": 1, "coconut": 1, "milkbottle": 1}}, \r\n    "rocambolemorango": {"Amount": 1, "Required": {"flour": 1, "strawberry": 1, "sugarbox": 1}}, \r\n    "sucodeuva": {"Amount": 1, "Required": {"grape": 1, "water": 1}}, \r\n    "sucodemaca": {"Amount": 1, "Required": {"apple": 1, "water": 1}}, \r\n    "sucodefrutas": {"Amount": 1, "Required": {"apple": 1, "banana": 1, "water": 1}}, \r\n    "bolodemorango": {"Amount": 1, "Required": {"flour": 1, "strawberry": 2, "sugarbox": 1}}, \r\n    "leitedemorango": {"Amount": 1, "Required": {"milkbottle": 1, "strawberry": 1}}, \r\n    "leitedebanana": {"Amount": 1, "Required": {"milkbottle": 1, "banana": 1}}, \r\n    "leitedechocolate": {"Amount": 1, "Required": {"milkbottle": 1, "chocolate": 1}}, \r\n    "cereal": {"Amount": 1, "Required": {"flour": 1, "milkbottle": 1, "sugarbox": 1}},\r\n    "COMBOSUNSET": {"Amount": 1, "Required": {"bifeepao": 1, "coquetellaranjaelimao": 1}}, \r\n    "COMBOTROPICAL": {"Amount": 1, "Required": {"peixebatata": 1, "daiquiridemorango": 1}}, \r\n    "COMBOMARECLASSICA": {"Amount": 1, "Required": {"bolocarne": 1, "limonada": 1}}, \r\n    "COMBOTROPICALIA": {"Amount": 1, "Required": {"bibimbap": 1, "uvalimao": 1}}, \r\n    "COMBOFLAMINGOSUPREMO": {"Amount": 1, "Required": {"salmaomolho": 1, "coquetelcarambola": 1}}, \r\n    "abacateovos": {"Amount": 1, "Required": {"avocado": 1, "egg": 1, "ryebread": 1}}, \r\n    "bibimbap": {"Amount": 1, "Required": {"ricebag": 1, "meatfillet": 1, "egg": 1, "lettuce": 1}}, \r\n    "bifeepao": {"Amount": 1, "Required": {"meatfillet": 1, "ryebread": 1}}, \r\n    "bolocarne": {"Amount": 1, "Required": {"meatfillet": 2, "tomato": 1, "flour": 1}}, \r\n    "caviarvermelho": {"Amount": 1, "Required": {"fishfillet": 2, "salt": 1}}, \r\n    "eggsbenedict": {"Amount": 1, "Required": {"egg": 2, "ryebread": 1, "mayonnaise": 1}}, \r\n    "peixebatata": {"Amount": 1, "Required": {"fishfillet": 1, "potato": 1}}, \r\n    "purebatata": {"Amount": 1, "Required": {"potato": 2, "milkbottle": 1}}, \r\n    "salada": {"Amount": 1, "Required": {"lettuce": 1, "tomato": 1, "oliveoil": 1}}, \r\n    "salmaomolho": {"Amount": 1, "Required": {"fishfillet": 1, "mayonnaise": 1, "lemon": 1}}, \r\n    "wafflesgelado": {"Amount": 1, "Required": {"flour": 1, "milkbottle": 1, "strawberry": 1}}, \r\n    "coquetelcarambola": {"Amount": 1, "Required": {"starfruit": 1, "water": 1, "sugarbox": 1}}, \r\n    "coquetellaranjaelimao": {"Amount": 1, "Required": {"orange": 1, "lemon": 1, "water": 1}}, \r\n    "daiquiridemorango": {"Amount": 1, "Required": {"strawberry": 1, "lemon": 1, "water": 1}}, \r\n    "leitedecoco": {"Amount": 1, "Required": {"coconut": 1, "water": 1}}, \r\n    "limonada": {"Amount": 1, "Required": {"lemon": 2, "water": 1, "sugarbox": 1}}, \r\n    "mangaelimao": {"Amount": 1, "Required": {"mango": 1, "lemon": 1, "water": 1}}, \r\n    "morangoemanga": {"Amount": 1, "Required": {"strawberry": 1, "mango": 1, "water": 1}}, \r\n    "morangoepesego": {"Amount": 1, "Required": {"strawberry": 1, "peach": 1, "water": 1}}, \r\n    "uvalimao": {"Amount": 1, "Required": {"grape": 1, "lemon": 1, "water": 1}}\r\n  }'),
	('Tunel', 'Tunel', '{"WEAPON_PISTOL":{"Amount":1,"Required":{"pistolbody":1,"weaponparts":3,"metalspring":1,"glass":100,"rubber":100,"plastic":120,"copper":75,"aluminum":75}},"WEAPON_PISTOL_MK2":{"Amount":1,"Required":{"pistolbody":1,"weaponparts":3,"metalspring":1,"glass":115,"rubber":115,"plastic":135,"copper":75,"aluminum":75}},"WEAPON_SNSPISTOL":{"Amount":1,"Required":{"pistolbody":1,"weaponparts":3,"metalspring":1,"glass":75,"rubber":100,"plastic":65,"copper":55,"aluminum":65}},"WEAPON_SNSPISTOL_MK2":{"Amount":1,"Required":{"pistolbody":1,"weaponparts":3,"metalspring":1,"glass":75,"rubber":100,"plastic":110,"copper":75,"aluminum":75}},"WEAPON_VINTAGEPISTOL":{"Amount":1,"Required":{"pistolbody":1,"weaponparts":3,"metalspring":1,"glass":75,"rubber":75,"plastic":100,"copper":50,"aluminum":50}},"WEAPON_PISTOL50":{"Amount":1,"Required":{"pistolbody":1,"weaponparts":5,"metalspring":1,"glass":155,"rubber":155,"plastic":165,"copper":100,"aluminum":100}},"WEAPON_MACHINEPISTOL":{"Amount":1,"Required":{"smgbody":1,"weaponparts":5,"metalspring":2,"glass":145,"rubber":145,"plastic":155,"copper":100,"aluminum":100}},"WEAPON_MICROSMG":{"Amount":1,"Required":{"smgbody":1,"weaponparts":5,"metalspring":2,"glass":225,"rubber":235,"plastic":275,"copper":175,"aluminum":175}},"WEAPON_MINISMG":{"Amount":1,"Required":{"smgbody":1,"weaponparts":5,"metalspring":2,"glass":225,"rubber":235,"plastic":275,"copper":175,"aluminum":175}},"WEAPON_GUSENBERG":{"Amount":1,"Required":{"smgbody":1,"weaponparts":5,"metalspring":2,"glass":275,"rubber":305,"plastic":305,"copper":225,"aluminum":225}},"WEAPON_PUMPSHOTGUN_MK2":{"Amount":1,"Required":{"riflebody":1,"weaponparts":8,"metalspring":2,"glass":375,"rubber":425,"plastic":345,"copper":175,"aluminum":175}},"WEAPON_SAWNOFFSHOTGUN":{"Amount":1,"Required":{"riflebody":1,"weaponparts":5,"metalspring":1,"glass":225,"rubber":255,"plastic":265,"copper":175,"aluminum":175}},"WEAPON_COMPACTRIFLE":{"Amount":1,"Required":{"riflebody":1,"weaponparts":8,"metalspring":2,"glass":305,"rubber":325,"plastic":265,"copper":175,"aluminum":175}},"WEAPON_ADVANCEDRIFLE":{"Amount":1,"Required":{"riflebody":1,"weaponparts":10,"metalspring":3,"glass":385,"rubber":405,"plastic":405,"copper":335,"aluminum":325}},"WEAPON_BULLPUPRIFLE_MK2":{"Amount":1,"Required":{"riflebody":1,"weaponparts":10,"metalspring":3,"glass":305,"rubber":425,"plastic":425,"copper":300,"aluminum":425}},"WEAPON_SPECIALCARBINE":{"Amount":1,"Required":{"riflebody":1,"weaponparts":10,"metalspring":3,"glass":305,"rubber":425,"plastic":425,"copper":425,"aluminum":300}},"WEAPON_SPECIALCARBINE_MK2":{"Amount":1,"Required":{"riflebody":1,"weaponparts":10,"metalspring":3,"glass":275,"rubber":400,"plastic":400,"copper":425,"aluminum":345}},"WEAPON_ASSAULTRIFLE":{"Amount":1,"Required":{"riflebody":1,"weaponparts":10,"metalspring":3,"glass":305,"rubber":425,"plastic":425,"copper":425,"aluminum":300}},"WEAPON_ASSAULTRIFLE_MK2":{"Amount":1,"Required":{"riflebody":1,"weaponparts":10,"metalspring":3,"glass":275,"rubber":400,"plastic":400,"copper":425,"aluminum":345}}}');

-- Copiando estrutura para tabela nightevolutiontp.deaths_creative
CREATE TABLE IF NOT EXISTS `deaths_creative` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Attacker` bigint(19) NOT NULL DEFAULT 0,
  `Victim` bigint(19) NOT NULL DEFAULT 0,
  `Weapon` varchar(50) NOT NULL DEFAULT 'WEAPON_PISTOL',
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.density
CREATE TABLE IF NOT EXISTS `density` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `VehicleDensity` float NOT NULL DEFAULT 0,
  `RandomVehicleDensity` float NOT NULL DEFAULT 0,
  `ParkedVehicleDensity` float NOT NULL DEFAULT 0,
  `ScenarioPedDensity` float NOT NULL DEFAULT 0,
  `PedDensity` float NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `density` (`id`, `VehicleDensity`, `RandomVehicleDensity`, `ParkedVehicleDensity`, `ScenarioPedDensity`, `PedDensity`) VALUES
	(1, 0, 0, 0, 1, 1);

-- Copiando estrutura para tabela nightevolutiontp.dependents
CREATE TABLE IF NOT EXISTS `dependents` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Dependent` int(10) NOT NULL DEFAULT 0,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.desmanche_settings
CREATE TABLE IF NOT EXISTS `desmanche_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Configuration` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `desmanche_settings` (`id`, `Configuration`) VALUES
	(1, '{"distanceToSeeText":20,"timeToFinish":10,"animationTime":5,"canChopNPCVehicles":true,"shelfObjectName":"v_ind_cf_shelf2","autoChop":true,"timeWaitBeforeStart":15,"prohibiteVehicles":[]}');

-- Copiando estrutura para tabela nightevolutiontp.desmanches
CREATE TABLE IF NOT EXISTS `desmanches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Configuration` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `desmanches` (`id`, `Name`, `Configuration`) VALUES
	(3, 'Et', '{"requireItemAmount":50,"darkMoneyItem":"dirtydollar","requireItem":"blowtorch","blip":{"x":2486.6,"y":3761.23,"z":56.86},"shelf":{"h":141.9,"cds":{"x":2483.82,"y":3757.73,"z":55.86}},"paymentMultiplier":40,"permission":"Et"}'),
	(5, 'Barragem', '{"requireItemAmount":50,"darkMoneyItem":"dirtydollar","requireItem":"blowtorch","blip":{"x":1267.96,"y":-92.2,"z":75.08},"shelf":{"h":54.97,"cds":{"x":1263.85,"y":-90.27,"z":74.08}},"paymentMultiplier":40,"permission":"Barragem"}');

-- Copiando estrutura para tabela nightevolutiontp.doors
CREATE TABLE IF NOT EXISTS `doors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hash` bigint(20) NOT NULL,
  `coords` varchar(255) NOT NULL,
  `distance` float NOT NULL,
  `permission` varchar(255) NOT NULL,
  `other` int(11) DEFAULT NULL,
  `lockState` tinyint(1) DEFAULT 1,
  `name` varchar(255) DEFAULT 'Porta',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.elevators
CREATE TABLE IF NOT EXISTS `elevators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elevator_id` varchar(50) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `coords` varchar(255) NOT NULL,
  `permission` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `elevators` (`id`, `elevator_id`, `name`, `coords`, `permission`) VALUES
	(65, 'Paramedico', 'Garagem', '{"h":179.79,"x":-519.79,"y":-592.63,"z":30.84}', ''),
	(66, 'Paramedico', '1', '{"h":179.06,"x":-555.59,"y":-595.24,"z":41.29}', ''),
	(67, 'Paramedico', 'Heliponto', '{"h":177.72,"x":-555.63,"y":-593.32,"z":58.8}', ''),
	(70, 'Policia', '1', '{"y":346.52,"x":-1257.23,"h":151.27,"z":69.7}', ''),
	(71, 'Policia', 'Heliponto', '{"y":285.81,"x":-1392.65,"h":105.77,"z":89.89}', '');

-- Copiando estrutura para tabela nightevolutiontp.ems_creative_consultations
CREATE TABLE IF NOT EXISTS `ems_creative_consultations` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Reason` varchar(255) NOT NULL DEFAULT '',
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Doctor` bigint(19) NOT NULL DEFAULT 0,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Status` varchar(255) NOT NULL DEFAULT 'appointment',
  `Description` longtext DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.ems_creative_exams
CREATE TABLE IF NOT EXISTS `ems_creative_exams` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL DEFAULT '',
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Doctor` bigint(19) NOT NULL DEFAULT 0,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Status` varchar(255) NOT NULL DEFAULT 'appointment',
  `Description` longtext DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.ems_creative_specialties
CREATE TABLE IF NOT EXISTS `ems_creative_specialties` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Name` varchar(150) NOT NULL DEFAULT 'Médico',
  `Members` longtext NOT NULL DEFAULT '[]',
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.entitydata
CREATE TABLE IF NOT EXISTS `entitydata` (
  `Name` varchar(100) NOT NULL,
  `Information` longtext DEFAULT NULL,
  PRIMARY KEY (`Name`),
  UNIQUE KEY `unique_name` (`Name`),
  KEY `Information` (`Name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.europa_handling_presets
CREATE TABLE IF NOT EXISTS `europa_handling_presets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(50) NOT NULL,
  `name` varchar(48) NOT NULL,
  `note` varchar(160) DEFAULT NULL,
  `author_passport` int(11) NOT NULL DEFAULT 0,
  `author_name` varchar(100) NOT NULL DEFAULT 'Desconhecido',
  `field_count` int(11) NOT NULL DEFAULT 0,
  `values` longtext NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_model` (`model`),
  KEY `idx_author_passport` (`author_passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.foodrush_deliverers
CREATE TABLE IF NOT EXISTS `foodrush_deliverers` (
  `user_id` int(11) NOT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT 0,
  `active_order_id` int(11) DEFAULT NULL,
  `last_active_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.foodrush_order_items
CREATE TABLE IF NOT EXISTS `foodrush_order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `item_id` varchar(64) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `foodrush_order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `foodrush_orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.foodrush_orders
CREATE TABLE IF NOT EXISTS `foodrush_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `restaurant_name` varchar(255) NOT NULL,
  `total_amount` int(11) NOT NULL,
  `delivery_fee` int(11) NOT NULL,
  `status` varchar(32) NOT NULL,
  `code` varchar(8) NOT NULL,
  `payment_method` varchar(32) NOT NULL,
  `customer_x` double DEFAULT NULL,
  `customer_y` double DEFAULT NULL,
  `customer_z` double DEFAULT NULL,
  `deliverer_id` int(11) DEFAULT NULL,
  `deliverer_earnings` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.fuelstations_creative
CREATE TABLE IF NOT EXISTS `fuelstations_creative` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  `Name` varchar(100) NOT NULL DEFAULT 'Posto de Combustível',
  `Color` int(3) NOT NULL DEFAULT 47,
  `Blip` int(3) NOT NULL DEFAULT 361,
  `Stock` int(9) NOT NULL DEFAULT 0,
  `FuelPrice` decimal(5,1) NOT NULL DEFAULT 5.0,
  `MoneyEarned` bigint(19) NOT NULL DEFAULT 0,
  `MoneySpent` bigint(19) NOT NULL DEFAULT 0,
  `FuelImported` bigint(19) NOT NULL DEFAULT 0,
  `Visits` bigint(19) NOT NULL DEFAULT 0,
  `Empty` bigint(19) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.fuelstations_creative_jobs
CREATE TABLE IF NOT EXISTS `fuelstations_creative_jobs` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  `Name` varchar(100) NOT NULL DEFAULT 'Carga Pequena',
  `Amount` bigint(19) NOT NULL DEFAULT 0,
  `Reward` bigint(19) NOT NULL DEFAULT 0,
  `Working` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.garages
CREATE TABLE IF NOT EXISTS `garages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Permission` varchar(50) DEFAULT NULL,
  `Classes` longtext DEFAULT NULL,
  `Spawns` longtext DEFAULT NULL,
  `CNH` varchar(50) DEFAULT NULL,
  `Job` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `garages` (`id`, `Name`, `X`, `Y`, `Z`, `Permission`, `Classes`, `Spawns`, `CNH`, `Job`) VALUES
	(1, '144', 232.55, 202.8, 105.39, '', '["stockade"]', '[[233.45,196.9,105.22,69.73]]', 'C,D', 'Transporter'),
	(2, '141', 1961.97, 5181.03, 47.95, '', '["ratloader"]', '[[1967.33,5179.34,47.06,158.75]]', NULL, NULL),
	(3, '124', 1509.64, 3788.7, 33.51, '', '["Embarcações"]', '[[1493.4,3797.23,29.89,50.19]]', NULL, NULL),
	(4, '14', 1035.84, -763.87, 58, '', '[]', '[[1046.54,-785.65,57.66,90.71],[1046.56,-774.55,57.69,90.71],[1046.56,-778.24,57.68,90.71],[1046.55,-782,57.68,90.71]]', 'A,B,C,D', ''),
	(5, '16', 453.28, -1146.77, 29.5, '', '[]', '[[467.33,-1151.89,28.96,85.04],[467.16,-1154.75,28.96,85.04],[467.1,-1157.73,28.96,87.88]]', NULL, NULL),
	(6, '148', 68.21, 124.82, 79.18, '', '["boxville2"]', '[[61.84,124.32,79.09,158.75],[72.19,120.91,79.08,158.75]]', 'C,D', 'Grime'),
	(7, '20', -800.45, 336.61, 85.7, '', '[]', '[[-800.38,331.9,85.38,181.42]]', NULL, NULL),
	(8, '10', 213.97, -808.43, 31, '', '[]', '[[224.85,-796.69,30.33,249.45],[221.93,-804.11,30.35,249.45],[222.9,-801.61,30.33,249.45],[223.92,-799.2,30.33,249.45]]', NULL, NULL),
	(9, '22', 1725.21, 4711.77, 42.11, '', '[]', '[[1722.82,4700.38,42.28,87.88]]', NULL, NULL),
	(10, '12', 67.72, 12.3, 69.22, '', '[]', '[[54.8,19.92,69.25,340.16],[63.87,16.5,68.87,340.16],[60.78,17.6,68.92,340.16],[57.76,18.76,69.03,340.16]]', NULL, NULL),
	(11, '149', 392.93, -1644.61, 29.29, '', '["flatbed"]', '[[398.83,-1641.44,29.29,321.56]]', 'C,D', 'Towed'),
	(13, '1', 55.44, -876.17, 30.67, '', '[]', '[[60.44,-866.47,30.23,340.16],[57.26,-865.35,30.25,340.16],[54.03,-864.21,30.25,340.16],[50.73,-863.01,30.26,340.16],[60.52,-866.53,30.14,340.16],[50.73,-873.28,30.11,158.75],[47.36,-872.07,30.13,158.75],[44.15,-870.9,30.13,158.75]]', '', ''),
	(14, '2', 599.04, 2745.33, 42.04, '', '[]', '[[595.59,2737.55,41.7,184.26],[604.82,2738.27,41.64,187.09],[601.75,2738.08,41.65,184.26],[598.63,2737.85,41.69,184.26]]', NULL, NULL),
	(15, '3', -136.8, 6356.84, 31.49, '', '[]', '[[-136.1,6346.53,31.16,42.52],[-133.72,6349.01,31.16,42.52]]', NULL, NULL),
	(16, '4', 275.23, -345.56, 45.17, '', '[]', '[[269.53,-322.4,44.58,252.29],[270.77,-319.14,44.58,252.29],[266.06,-332.07,44.58,252.29],[267.18,-328.9,44.58,252.29],[268.32,-325.67,44.58,252.29]]', NULL, NULL),
	(17, '5', 596.43, 90.68, 93.13, '', '[]', '[[598.69,98.42,92.57,249.45],[599.82,102.03,92.57,249.45]]', NULL, NULL),
	(18, '6', -340.57, 266.04, 85.68, '', '[]', '[[-349.47,272.54,84.77,272.13],[-349.5,275.91,84.69,272.13],[-349.56,279.3,84.62,272.13],[-349.67,282.6,84.59,274.97],[-349.74,286.16,84.59,272.13],[-349.8,289.76,84.6,272.13],[-349.85,293.28,84.6,272.13],[-349.87,296.72,84.6,272.13]]', NULL, NULL),
	(19, '7', -2030.03, -465.99, 11.59, '', '[]', '[[-2037.4,-461.02,11.07,138.9],[-2039.78,-459.07,11.07,138.9],[-2042.12,-457.1,11.07,138.9],[-2044.47,-455.11,11.07,138.9],[-2046.85,-453.09,11.07,138.9],[-2049.12,-451.17,11.07,138.9],[-2051.51,-449.23,11.07,138.9]]', NULL, NULL),
	(20, '8', -1184.94, -1509.99, 4.65, '', '[]', '[[-1188.69,-1488.27,4.04,121.89],[-1183.29,-1495.81,4.04,121.89],[-1185.23,-1493.28,4.04,121.89],[-1186.87,-1490.71,4.04,121.89]]', NULL, NULL),
	(21, '9', 101.23, -1073.64, 29.37, '', '[]', '[[110.27,-1052.86,28.88,246.62],[105.9,-1063.14,28.88,246.62],[107.42,-1059.61,28.88,246.62],[108.88,-1056.23,28.88,246.62]]', NULL, NULL),
	(22, '19', -791.48, 336.48, 85.7, '', '[]', '[[-791.64,331.67,85.38,181.42]]', NULL, NULL),
	(23, '131', -1896.42, -3032.01, 13.93, '', '["Helicópteros"]', '[[-1890.65,-3045.12,14.61,150.24]]', NULL, NULL),
	(24, '15', -796.69, -2022.85, 9.17, '', '[]', '[[-779.77,-2040.03,8.56,314.65],[-777.36,-2042.58,8.56,314.65],[-774.92,-2044.9,8.56,314.65]]', NULL, NULL),
	(25, '17', 528.65, -146.25, 58.37, '', '[]', '[[552.81,-136.41,58.99,178.59],[540.99,-136.2,59.13,178.59],[544.84,-136.25,59.01,178.59],[548.83,-136.31,59.01,181.42]]', NULL, NULL),
	(26, '11', -348.89, -874.02, 31.31, '', '[]', '[[-332.72,-877.71,30.75,167.25],[-343.62,-875.51,30.75,167.25],[-339.98,-876.27,30.75,167.25],[-336.35,-876.98,30.75,167.25]]', NULL, NULL),
	(27, '21', 935.95, 0.36, 78.76, '', '[]', '[[933.29,-3.74,78.44,147.41]]', NULL, NULL),
	(28, '13', 361.96, 297.8, 103.88, '', '[]', '[[371.06,284.68,102.94,340.16],[374.8,283.39,102.85,340.16],[378.62,282.06,102.78,340.16]]', NULL, NULL),
	(29, '23', 1624.05, 3566.14, 35.15, '', '[]', '[[1633.27,3563.91,34.91,303.31]]', NULL, NULL),
	(30, '150', 977.78, -2220.77, 31.54, '', '["youga2"]', '[[972.99,-2220.39,30.53,85.04]]', NULL, NULL),
	(31, '121', -1728.06, -1050.69, 1.7, '', '["Embarcações"]', '[[-1734.05,-1057.01,0.94,133.23]]', NULL, NULL),
	(32, '143', -341.45, -1567.52, 25.22, '', '["trash"]', '[[-346.4,-1560.42,24.95,93.55]]', 'C,D', 'Garbageman'),
	(34, '122', -776.63, -1494.93, 2.29, '', '["Embarcações"]', '[[-786.5,-1498.89,-0.57,110.56]]', NULL, NULL),
	(35, '146', 1241.65, -3262.85, 5.53, '', '["packer"]', '[[1272.11,-3266.03,6.1,91],[1271.56,-3287.96,6.1,91],[1271.82,-3282.63,6.1,91],[1271.95,-3271.04,6.1,91]]', 'C,D', 'Trucker'),
	(37, '142', 453.74, -600.6, 28.59, '', '["bus"]', '[[462.81,-606.03,28.49,212.6],[461.54,-612.34,28.49,215.44],[460.98,-619.81,28.49,215.44]]', '', 'Driver'),
	(38, '140', -615.63, -907.18, 24.15, '', '["cruiser"]', '[[-615.82,-911.88,23.44,104.89],[-615.73,-916.04,23.13,107.72],[-615.63,-920.3,22.83,110.56]]', '', 'Throwing'),
	(40, '123', -895.04, 5687.46, 3.03, '', '["Embarcações"]', '[[-907.5,5684.52,0.76,102.05]]', NULL, NULL),
	(41, '26', 1200.52, -1276.06, 35.22, '', '[]', '[[1206.23,-1270.21,35.03,175.75]]', NULL, NULL),
	(42, '147', 905.6, -165.08, 74.11, '', '["taxi"]', '[[916.21,-170.61,74.04,99.22],[918.35,-167.18,74.22,99.22],[920.64,-163.54,74.43,99.22]]', 'B', 'Taxi'),
	(43, '24', 1143.8, 2667.46, 38.15, '', '[]', '[[1137.41,2674.26,37.83,0.0]]', NULL, NULL),
	(46, '25', -73.35, -2004.6, 18.27, '', '[]', '[[-59.61,-1990.85,17.69,155.91],[-63.69,-1989.71,17.69,167.25],[-67.6,-1989.01,17.69,170.08],[-71.34,-1988.57,17.69,172.92],[-74.96,-1988.07,17.69,170.08],[-78.64,-1987.63,17.69,170.08],[-82.27,-1987.19,17.69,170.08]]', NULL, NULL),
	(47, '18', -1159.56, -739.39, 19.88, '', '[]', '[[-1144.95,-745.49,19.34,104.89],[-1142.76,-748.44,19.19,107.72],[-1140.18,-751.41,19.06,107.72],[-1137.99,-754.36,18.91,107.72],[-1135.43,-757.3,18.75,107.72],[-1133.12,-760.4,18.59,107.72],[-1130.59,-763.27,18.43,107.72]]', NULL, NULL),
	(48, 'Redline', 1119.26, -777.58, 57.63, 'Redline', '["BCs_RaptorMec","BCs_ReboqueMec","BCs_R1200Mec"]', '[[1126.33,-774.49,57.66,268.72]]', NULL, NULL),
	(49, 'Redline 2', 1143.47, -795.3, 70.57, 'Redline', '["B412Mec"]', '[[1141.51,-788.77,70.57,0.51]]', NULL, NULL),
	(51, 'Bennys', -195.83, -1368.89, 31.26, 'Bennys', '["BCs_RaptorMec2","BCs_ReboqueMec2","BCs_R1200Mec2"]', '[[-198.92,-1375.12,31.26,181.95]]', NULL, NULL),
	(52, 'Bennys 2', -192.83, -1293.64, 31.3, 'Bennys', '["B412Mec2"]', '[[-184.04,-1293.24,31.3,0.25]]', NULL, NULL),
	(53, 'Paramedico', -516.41, -594.54, 30.3, 'Paramedico', '["wrtrhp","wrsprhp","wrrgrhp","wrdefhp"]', '[[-513.19,-596.52,30.3,181.1]]', NULL, NULL),
	(54, 'Paramedico 2', -567.73, -598.11, 60.22, 'Paramedico', '["wrcndhp"]', '[[-572.54,-599.84,60.22,88.79]]', NULL, NULL),
	(55, 'Paramedico 3', -543.14, -598.35, 60.22, 'Paramedico', '["wrcndhp"]', '[[-538.4,-599.85,60.22,269.89]]', NULL, NULL),
	(56, 'Milkman', 961.56, -2189.5, 30.51, '', '["youga2"]', '[[955.6,-2187.37,30.55,86.36]]', 'B', 'Milkman'),
	(57, 'Et', 2506.3, 3733.51, 58.63, 'Et', '[]', '[[2516.19,3737.22,58.63,236.2]]', '', ''),
	(58, 'Barragem', 1267.97, -107.53, 75.03, 'Barragem', '[]', '[[1260.27,-109.91,75,133.39]]', '', ''),
	(59, 'Paleto', 90.17, 6747.44, 42.51, 'Paleto', '[]', '[[93.19,6741.31,42.51,127.02]]', '', ''),
	(60, 'Pesqueiro', 3719.92, 4547.04, 27.52, 'Pesqueiro', '[]', '[[3729.16,4552.21,27.52,241.23]]', '', ''),
	(61, 'Observatorio', -438.32, 1578.21, 359.39, 'Observatorio', '[]', '[[-435.45,1572.83,358.86,243.17]]', '', ''),
	(62, 'Resort', -1692.57, 558.72, 154.37, 'Resort', '[]', '[[-1684.02,562.25,154.37,225.95]]', '', ''),
	(63, 'Curvados', 855.1, 1862.11, 141.6, 'Curvados', '[]', '[[851.05,1852.71,141.6,213.38]]', '', ''),
	(64, 'Praia', -1204.53, -1811.67, 4.65, 'Praia', '[]', '[[-1207.01,-1803.54,4.65,28.39]]', '', ''),
	(65, 'Tunel', 1450.24, 6361.68, 29.91, 'Tunel', '[]', '[[1442.66,6355.55,29.91,74.36]]', '', ''),
	(66, 'Porto', 1338.09, -2536.1, 48.85, 'Porto', '[]', '[[1343.43,-2543.58,48.85,189.52]]', '', ''),
	(67, 'Norte', 1723.47, 4506.69, 42.45, 'Norte', '[]', '[[1719.01,4498.31,42.45,89.57]]', '', ''),
	(68, 'Corrego', 1939.63, 752.18, 191.58, 'Corrego', '[]', '[[1933.71,742.45,191.58,100.94]]', '', ''),
	(69, 'Lago', 184.73, 692.5, 209.05, 'Lago', '[]', '[[180.36,701.34,209.05,90.08]]', '', ''),
	(70, 'Helipa', 1282.79, -771.84, 75.16, 'Helipa', '[]', '[[1288.95,-773.45,75.16,336.43]]', '', ''),
	(71, 'Policia', -1270.52, 250.46, 63.57, 'Policia', '["htcmd","htcot001","htcot002","htcov001","htcov002","htcov003","htcov004","htcov005","htcov006","htcov007","htcov008","htcov009","htdedepol","htdipcov001","htdipcov002","htdipcov003","htdipcov004","htdipcov005","htdipgtm001","htdipgtm002","htdipspeed001","htdipspeed002","htdipspeed003","htdipspeed004","htgtm001","htgtm002","htgtm003","htpol001","htpol002","htspeed001","htspeed002","htspeed003","htspeed004","htssp","htcore001","htcore002"]', '[[-1273.32,252.03,63.54,355.75],[-1277.48,252.26,63.44,355.81],[-1281.42,252.66,63.38,354.86],[-1285.17,252.52,63.28,357]]', '', ''),
	(73, 'Policia 2', -1388.78, 268.22, 91.59, 'Policia', '["htdipgraer001","htdipgraer002","HTGRAER001","htgraer002","htgraer003"]', '[[-1382.98,271.79,91.59,109.91]]', '', ''),
	(74, 'Mansão01', -2313.34, 4332.68, 29.08, 'Mansao01', '[]', '[[-2304.96,4337.81,29.08,227.18]]', '', ''),
	(75, 'Mansão02', -558.96, 1272.38, 326.65, 'Mansao02', '[]', '[[-558.61,1267.01,326.65,222.08]]', '', ''),
	(76, 'Mansão03', 624.93, 927.53, 247.58, 'Mansao03', '[]', '[[629.74,921.3,247.58,259.38]]', '', ''),
	(77, 'Mansao03 2', 628.61, 894.91, 248.42, 'Mansao03', '[]', '[[621.73,893.99,248.42,261.65]]', '', ''),
	(78, 'Mansão04', 827.61, 3433.36, 57.86, 'Mansao04', '[]', '[[819.41,3437.29,57.86,87.4]]', '', ''),
	(79, 'Mansão04 2', 692.8, 3438.16, 57.75, 'Mansao04', '[]', '[[686.57,3436.7,57.75,185.67]]', '', ''),
	(80, 'Mansão05', -2965.23, 2175.12, 41.9, 'Mansao05', '[]', '[[-2971.65,2174.04,41.9,47.74]]', '', ''),
	(81, 'Spawn', -1038.93, -2731.03, 20.17, '', '[]', '[[-1035.42,-2727.72,20.14,238.2]]', '', ''),
	(82, 'Hospital Público', -454.02, -626.7, 31.32, '', '["Bicicletas","Blindados","Brasileiros","Caminhões","Carretas","Clássicos","Compactos","Cupês","Esportivos","Exclusivos","Ilegal","Importados","Industriais","Kids","Luxo","Militares","Motocicletas","Motos","Muscles","Off-Roads","Premium","Races","SUVs","Sedans","Ultra","Vans","Vips"]', '[[-457.05,-624.6,31.17,0.25],[-460.47,-624.63,31.17,1.67],[-464.14,-624.5,31.17,0.63]]', '', ''),
	(83, 'FuelStation01', 298.8, -1248.46, 29.28, 'FuelStation01', '["packer"]', '[[293.81,-1244.09,29.28,87.88]]', '', ''),
	(84, 'FuelStation02', 2661.97, 3264.9, 55.23, 'FuelStation02', '["packer"]', '[[2660.68,3259.94,55.23,243.78]]', '', ''),
	(85, 'FuelStation03', -2066.26, -312.35, 13.26, 'FuelStation03', '["packer"]', '[[-2069.05,-304.94,13.14,82.21]]', '', ''),
	(86, 'FuelStation04', -2526.46, 2349.55, 33.06, 'FuelStation04', '["packer"]', '[[-2529.62,2342.47,33.06,212.6]]', '', ''),
	(87, 'FuelStation05', 144.52, 6645.05, 31.53, 'FuelStation05', '["packer"]', '[[143.87,6636.88,31.61,133.23]]', '', ''),
	(88, 'FuelStation06', 834.45, -1036.86, 27.14, 'FuelStation06', '["packer"]', '[[827.2,-1045.19,27.23,0.0]]', '', ''),
	(89, 'FuelStation07', 1204.69, -1386.02, 35.22, 'FuelStation07', '["packer"]', '[[1199.4,-1386.06,35.22,181.42]]', '', ''),
	(90, 'FuelStation08', 1167.55, -320.78, 69.29, 'FuelStation08', '["packer"]', '[[1174.11,-317.6,69.17,280.63]]', '', ''),
	(91, 'FuelStation09', 650.51, 280.86, 103.15, 'FuelStation09', '["packer"]', '[[644.43,279.21,103.19,147.41]]', '', ''),
	(92, 'FuelStation10', 2562.41, 397.85, 108.61, 'FuelStation10', '["packer"]', '[[2570.59,397.75,108.46,269.3]]', '', ''),
	(93, 'FuelStation11', 177.9, -1544.26, 29.25, 'FuelStation11', '["packer"]', '[[181.03,-1551.05,29.17,223.94]]', '', ''),
	(94, 'FuelStation12', -339.56, -1496.76, 30.6, 'FuelStation12', '["packer"]', '[[-335.06,-1492.0,30.65,0.0]]', '', ''),
	(95, 'FuelStation13', 1770.12, 3338.26, 41.43, 'FuelStation13', '["packer"]', '[[1768.29,3344.1,41.01,300.48]]', '', ''),
	(96, 'FuelStation14', 61.64, 2785.28, 57.88, 'FuelStation14', '["packer"]', '[[66.08,2782.53,57.88,138.9]]', '', ''),
	(97, 'FuelStation15', 252.49, 2596.33, 44.85, 'FuelStation15', '["packer"]', '[[251.0,2603.77,45.01,8.51]]', '', ''),
	(98, 'FuelStation16', 1021.4, 2655.24, 39.55, 'FuelStation16', '["packer"]', '[[1026.16,2658.24,39.55,0.0]]', '', ''),
	(99, 'FuelStation17', 1189.36, 2650.63, 37.83, 'FuelStation17', '["packer"]', '[[1185.87,2654.68,37.83,314.65]]', '', ''),
	(100, 'FuelStation18', 2545.93, 2584.04, 37.95, 'FuelStation18', '["packer"]', '[[2541.79,2580.8,37.95,93.55]]', '', ''),
	(101, 'FuelStation19', 1982.42, 3788.37, 32.18, 'FuelStation19', '["packer"]', '[[1980.35,3781.17,32.18,209.77]]', '', ''),
	(102, 'FuelStation20', 1702.32, 4916.6, 42.07, 'FuelStation20', '["packer"]', '[[1696.26,4914.76,42.07,53.86]]', '', ''),
	(103, 'FuelStation21', 1698.55, 6426, 32.76, 'FuelStation21', '["packer"]', '[[1692.39,6425.27,32.62,150.24]]', '', ''),
	(104, 'FuelStation22', -71.32, 6424.94, 31.44, 'FuelStation22', '["packer"]', '[[-76.72,6425.35,31.49,42.52]]', '', ''),
	(105, 'FuelStation23', -1827.85, 780.37, 138.1, 'FuelStation23', '["packer"]', '[[-1821.45,779.35,137.63,221.11]]', '', ''),
	(106, 'FuelStation24', -1408.56, -271.51, 46.39, 'FuelStation24', '["packer"]', '[[-1407.03,-275.4,46.39,130.4]]', '', ''),
	(107, 'FuelStation25', -724.41, -911.98, 19.01, 'FuelStation25', '["packer"]', '[[-729.05,-912.58,19.01,178.59]]', '', ''),
	(108, 'FuelStation26', -523.29, -1223.86, 18.45, 'FuelStation26', '["packer"]', '[[-518.54,-1218.93,18.27,334.49]]', '', ''),
	(109, 'FuelStation27', -60.68, -1751.09, 29.3, 'FuelStation27', '["packer"]', '[[-60.47,-1742.63,29.32,53.86]]', '', '');

-- Copiando estrutura para tabela nightevolutiontp.hwid
CREATE TABLE IF NOT EXISTS `hwid` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Account` bigint(19) NOT NULL DEFAULT 1,
  `Token` varchar(250) NOT NULL DEFAULT '0',
  `Banned` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.initial
CREATE TABLE IF NOT EXISTS `initial` (
  `user_id` int(11) NOT NULL,
  `resgatou` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.initial_data
CREATE TABLE IF NOT EXISTS `initial_data` (
  `user_id` int(11) NOT NULL,
  `carro` longtext DEFAULT NULL,
  `tempo` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.invoices
CREATE TABLE IF NOT EXISTS `invoices` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Received` bigint(19) NOT NULL DEFAULT 0,
  `Reason` longtext NOT NULL,
  `Price` bigint(19) NOT NULL DEFAULT 0,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.killconfirm_settings
CREATE TABLE IF NOT EXISTS `killconfirm_settings` (
  `user_id` int(11) NOT NULL,
  `sound_id` int(11) NOT NULL DEFAULT 0,
  `visual_state` int(11) NOT NULL DEFAULT 0,
  `hitfeed_state` tinyint(1) NOT NULL DEFAULT 0,
  `body_sound` int(11) NOT NULL DEFAULT 0,
  `volume` float NOT NULL DEFAULT 0.5,
  `color` varchar(10) NOT NULL DEFAULT '#DFB80E',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.lb_phone_backups
CREATE TABLE IF NOT EXISTS `lb_phone_backups` (
  `id` varchar(100) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  PRIMARY KEY (`id`,`phone_number`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `fk_lb_phone_backups_phone_number` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.lscustoms
CREATE TABLE IF NOT EXISTS `lscustoms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `H` float NOT NULL,
  `Permission` varchar(50) DEFAULT NULL,
  `Logo` varchar(50) DEFAULT 'lscustoms.png',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `lscustoms` (`id`, `Name`, `X`, `Y`, `Z`, `H`, `Permission`, `Logo`) VALUES
	(1, 'Redline', 1140.25, -784.72, 57.6, 358.84, 'Redline', 'redline.png'),
	(2, 'Redline 2', 1131.55, -784.57, 57.6, 57.59, 'Redline', 'redline.png'),
	(3, 'Redline 3', 1122.7, -784.61, 57.6, 57.59, 'Redline', 'redline.png'),
	(4, 'Redline 4', 1141.58, -788.8, 70.57, 57.59, 'Redline', 'redline.png'),
	(5, 'Bennys', -213.71, -1348.11, 32.04, 90.53, 'Bennys', 'bennys.png'),
	(6, 'Bennys 2', -213.72, -1342.89, 32.04, 91.27, 'Bennys', 'bennys.png'),
	(7, 'Bennys 3', -213.76, -1337.86, 32.04, 92.53, 'Bennys', 'bennys.png'),
	(8, 'Bennys 4', -213.76, -1332.91, 32.04, 93.91, 'Bennys', 'bennys.png'),
	(9, 'Bennys 5', -204.36, -1348.2, 32.04, 272.47, 'Bennys', 'bennys.png'),
	(10, 'Bennys 6', -204.34, -1342.98, 32.04, 271.61, 'Bennys', 'bennys.png'),
	(11, 'Bennys 7', -204.34, -1337.98, 32.04, 271.64, 'Bennys', 'bennys.png'),
	(12, 'Bennys 8', -204.35, -1332.96, 32.04, 271.05, 'Bennys', 'bennys.png'),
	(13, 'Bennys 9', -183.18, -1289.72, 31.3, 359.76, 'Bennys', 'bennys.png'),
	(14, 'teste', 245.17, 119.91, 102.61, 156.38, '', 'lscustoms.png');

-- Copiando estrutura para tabela nightevolutiontp.mdt_creative_arrest
CREATE TABLE IF NOT EXISTS `mdt_creative_arrest` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Officer` bigint(19) NOT NULL DEFAULT 0,
  `Officers` longtext DEFAULT NULL,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Infractions` longtext DEFAULT NULL,
  `Arrest` bigint(19) NOT NULL DEFAULT 0,
  `Fine` bigint(19) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.mdt_creative_board
CREATE TABLE IF NOT EXISTS `mdt_creative_board` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Title` varchar(100) NOT NULL,
  `Description` longtext DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.mdt_creative_fines
CREATE TABLE IF NOT EXISTS `mdt_creative_fines` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Officer` bigint(19) NOT NULL DEFAULT 0,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Infractions` longtext DEFAULT NULL,
  `Fine` bigint(19) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  `Paid` tinyint(1) NOT NULL DEFAULT 0,
  `Arrest` bigint(19) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `MDT_Arrest` (`Arrest`),
  CONSTRAINT `MDT_Arrest` FOREIGN KEY (`Arrest`) REFERENCES `mdt_creative_arrest` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.mdt_creative_internalaffairs
CREATE TABLE IF NOT EXISTS `mdt_creative_internalaffairs` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Title` text DEFAULT NULL,
  `Accused` bigint(19) NOT NULL DEFAULT 0,
  `Officer` bigint(19) NOT NULL DEFAULT 0,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  `Archive` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.mdt_creative_medals
CREATE TABLE IF NOT EXISTS `mdt_creative_medals` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Image` text NOT NULL DEFAULT '',
  `Name` varchar(150) NOT NULL DEFAULT 'Honra ao Mérito',
  `Officers` longtext NOT NULL DEFAULT '[]',
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.mdt_creative_penalcode_articles
CREATE TABLE IF NOT EXISTS `mdt_creative_penalcode_articles` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Section` bigint(19) NOT NULL DEFAULT 0,
  `Article` varchar(250) NOT NULL,
  `Contravention` varchar(250) NOT NULL,
  `Fine` bigint(19) NOT NULL DEFAULT 0,
  `Arrest` bigint(19) NOT NULL DEFAULT 0,
  `Bail` bigint(19) NOT NULL DEFAULT 0,
  `Order` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `MDT_Section` (`Section`),
  CONSTRAINT `MDT_Section` FOREIGN KEY (`Section`) REFERENCES `mdt_creative_penalcode_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.mdt_creative_penalcode_sections
CREATE TABLE IF NOT EXISTS `mdt_creative_penalcode_sections` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Type` varchar(10) NOT NULL,
  `Title` varchar(100) NOT NULL,
  `Description` longtext DEFAULT NULL,
  `Order` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.mdt_creative_reports
CREATE TABLE IF NOT EXISTS `mdt_creative_reports` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Title` text DEFAULT NULL,
  `Suspects` longtext NOT NULL DEFAULT '[]',
  `Officer` bigint(19) NOT NULL DEFAULT 0,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  `Archive` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.mdt_creative_units
CREATE TABLE IF NOT EXISTS `mdt_creative_units` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Image` text NOT NULL DEFAULT '',
  `Name` varchar(150) NOT NULL DEFAULT 'BCSO',
  `Permission` varchar(100) NOT NULL DEFAULT '',
  `Officers` longtext NOT NULL DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.mdt_creative_vehicles
CREATE TABLE IF NOT EXISTS `mdt_creative_vehicles` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Officer` bigint(19) NOT NULL DEFAULT 0,
  `Image` text NOT NULL DEFAULT '',
  `Vehicle` varchar(100) DEFAULT NULL,
  `Plate` varchar(10) DEFAULT NULL,
  `Location` varchar(100) DEFAULT NULL,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.mdt_creative_wanted
CREATE TABLE IF NOT EXISTS `mdt_creative_wanted` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Image` text DEFAULT NULL,
  `Accusations` longtext DEFAULT NULL,
  `Officer` bigint(19) NOT NULL DEFAULT 0,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `HowLong` int(5) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.mdt_creative_warning
CREATE TABLE IF NOT EXISTS `mdt_creative_warning` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Officer` bigint(19) NOT NULL DEFAULT 0,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.moneywash
CREATE TABLE IF NOT EXISTS `moneywash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Permission` varchar(50) DEFAULT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `H` float NOT NULL,
  `Hash` varchar(100) DEFAULT 'bkr_prop_prtmachine_dryer_spin',
  `Tax` int(11) DEFAULT 5,
  `BatteryItem` varchar(50) DEFAULT 'washbattery',
  `BleachItem` varchar(50) DEFAULT 'washbleach',
  `WashAmount` int(11) DEFAULT 500,
  `WashTime` int(11) DEFAULT 10,
  `BatteryDuration` int(11) DEFAULT 604800,
  `BleachDuration` int(11) DEFAULT 21600,
  `BleachBonus` int(11) DEFAULT 50,
  `DirtyItem` varchar(50) DEFAULT 'dirtydollar',
  `CleanItem` varchar(50) DEFAULT 'dollar',
  `WetItem` varchar(50) DEFAULT 'wetdollar',
  `DryAmount` int(11) DEFAULT 200,
  `DryTime` int(11) DEFAULT 30,
  `DryTax` int(11) DEFAULT 30,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `moneywash` (`id`, `Name`, `Permission`, `X`, `Y`, `Z`, `H`, `Hash`, `Tax`, `BatteryItem`, `BleachItem`, `WashAmount`, `WashTime`, `BatteryDuration`, `BleachDuration`, `BleachBonus`, `DirtyItem`, `CleanItem`, `WetItem`, `DryAmount`, `DryTime`, `DryTax`) VALUES
	(3, 'Helipa', 'Helipa', 1306.86, -761.36, 77.23, 157.9, '', 5, 'washbattery', 'washbleach', 500, 10, 604800, 21600, 50, 'dirtydollar', 'dollar', 'wetdollar', 200, 30, 30),
	(4, 'Lago', 'Lago', 187.2, 695.72, 211.14, 89.95, '', 5, 'washbattery', 'washbleach', 500, 10, 604800, 21600, 50, 'dirtydollar', 'dollar', 'wetdollar', 200, 30, 30);

-- Copiando estrutura para tabela nightevolutiontp.night_animdupla
CREATE TABLE IF NOT EXISTS `night_animdupla` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `animacao` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.night_letters
CREATE TABLE IF NOT EXISTS `night_letters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  `date` varchar(50) NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0,
  `deleted_sender` tinyint(1) DEFAULT 0,
  `deleted_receiver` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.night_nailshop
CREATE TABLE IF NOT EXISTS `night_nailshop` (
  `Passport` int(11) NOT NULL,
  `nail_data` longtext DEFAULT '{}',
  PRIMARY KEY (`Passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.night_permissions
CREATE TABLE IF NOT EXISTS `night_permissions` (
  `role` varchar(50) NOT NULL,
  `permissions` longtext NOT NULL,
  PRIMARY KEY (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.night_punicoes
CREATE TABLE IF NOT EXISTS `night_punicoes` (
  `user_id` int(11) DEFAULT NULL,
  `staffid` longtext DEFAULT NULL,
  `motivo` longtext DEFAULT NULL,
  `status` longtext DEFAULT NULL,
  `contagem` longtext DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `tempo_restante` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.night_teleportes
CREATE TABLE IF NOT EXISTS `night_teleportes` (
  `user_id` int(11) DEFAULT NULL,
  `id` longtext DEFAULT NULL,
  `nome` longtext DEFAULT NULL,
  `coords` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.night_webhooks
CREATE TABLE IF NOT EXISTS `night_webhooks` (
  `category` varchar(50) NOT NULL,
  `link` text DEFAULT NULL,
  PRIMARY KEY (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `night_webhooks` (`category`, `link`) VALUES
	('Appearance', ''),
	('Blips', ''),
	('Chests', ''),
	('ClearArea', ''),
	('Cloakroom', ''),
	('Config', ''),
	('Crafting', ''),
	('Density', ''),
	('Desmanches', ''),
	('Doors', ''),
	('Elevators', ''),
	('Garages', ''),
	('LSCustoms', ''),
	('Moneywash', ''),
	('NPCs', ''),
	('PDM', ''),
	('Radio', ''),
	('Routes', ''),
	('Safezones', ''),
	('Shops', '');

-- Copiando estrutura para tabela nightevolutiontp.npcs
CREATE TABLE IF NOT EXISTS `npcs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Model` varchar(255) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `H` float NOT NULL,
  `Distance` int(11) NOT NULL DEFAULT 50,
  `Collision` tinyint(1) NOT NULL DEFAULT 0,
  `AnimDict` varchar(255) DEFAULT NULL,
  `AnimName` varchar(255) DEFAULT NULL,
  `Route` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `npcs` (`id`, `Name`, `Model`, `X`, `Y`, `Z`, `H`, `Distance`, `Collision`, `AnimDict`, `AnimName`, `Route`) VALUES
	(1, 'Banned', 'a_m_m_bevhills_02', -1674.58, -3174.77, 13.99, 331.66, 100, 1, NULL, NULL, 9999998),
	(3, 'Cow', 'a_c_cow', 957.99, -2207.26, 30.6, 266.46, 50, 1, NULL, NULL, NULL),
	(4, 'Cow', 'a_c_cow', 956.66, -2220.51, 30.58, 266.46, 50, 1, NULL, NULL, NULL),
	(5, 'Cow', 'a_c_cow', 955.6, -2233.52, 30.58, 266.46, 50, 1, NULL, NULL, NULL),
	(6, 'Cow', 'a_c_cow', 954.49, -2247.07, 30.58, 266.46, 50, 1, NULL, NULL, NULL),
	(7, 'Desmanche', 'g_m_y_salvagoon_01', 778.49, -395.89, 33.43, 99.22, 100, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(8, 'Towed South', 'u_m_o_finguru_01', 408.91, -1622.75, 29.28, 232.45, 50, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(10, 'Bus', 'a_m_y_business_02', 453.47, -602.34, 28.59, 266.46, 50, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(11, 'Hotel', 's_m_y_doorman_01', -772.76, 312.81, 85.7, 181.42, 50, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(12, 'Grime', 's_m_m_postal_01', 68.99, 127.46, 79.21, 158.75, 50, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(13, 'Megamall', 'ig_dale', 46.7, -1749.71, 29.62, 51.03, 50, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(15, 'MoneyWash', 'a_m_m_soucent_03', 68.93, -1569.81, 29.59, 48.19, 50, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(16, 'Eletronics', 'ig_dale', -1529.66, -400.48, 35.64, 227.64, 50, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(17, 'Taxi', 'ig_dale', 901.97, -167.97, 74.07, 238.12, 50, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(18, 'Aeronaves', 'g_m_y_korlieut_01', -1250.77, -3403.68, 13.94, 51.6, 100, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(19, 'Caminhoneiro', 's_m_m_trucker_01', 1239.87, -3257.2, 7.09, 274.97, 100, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(20, 'Cemitery', 'g_m_m_armboss_01', -1741.52, -219.85, 56.14, 255.12, 100, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(21, 'Departament Store', 'mp_m_shopkeep_01', 24.51, -1346.75, 29.49, 272.13, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(22, 'Departament Store', 'mp_m_shopkeep_01', 2556.77, 380.87, 108.61, 0, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(23, 'Departament Store', 'mp_m_shopkeep_01', 1164.81, -323.61, 69.2, 99.22, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(24, 'Departament Store', 'mp_m_shopkeep_01', -706.16, -914.55, 19.21, 87.88, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(25, 'Departament Store', 'mp_m_shopkeep_01', -47.35, -1758.59, 29.42, 45.36, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(26, 'Departament Store', 'mp_m_shopkeep_01', 372.7, 326.89, 103.56, 255.12, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(27, 'Departament Store', 'mp_m_shopkeep_01', -3242.7, 1000.05, 12.82, 357.17, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(28, 'Departament Store', 'mp_m_shopkeep_01', 1728.08, 6415.6, 35.03, 243.78, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(29, 'Departament Store', 'mp_m_shopkeep_01', 549.09, 2670.89, 42.16, 93.55, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(30, 'Departament Store', 'mp_m_shopkeep_01', 1959.87, 3740.44, 32.33, 300.48, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(31, 'Departament Store', 'mp_m_shopkeep_01', 2677.65, 3279.66, 55.23, 331.66, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(32, 'Departament Store', 'mp_m_shopkeep_01', 1697.32, 4923.46, 42.06, 323.15, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(33, 'Departament Store', 'mp_m_shopkeep_01', -1819.52, 793.48, 138.08, 130.4, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(34, 'Departament Store', 'mp_m_shopkeep_01', 1391.62, 3605.95, 34.98, 198.43, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(35, 'Departament Store', 'mp_m_shopkeep_01', -2966.41, 391.52, 15.05, 82.21, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(36, 'Departament Store', 'mp_m_shopkeep_01', -3039.42, 584.42, 7.9, 14.18, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(37, 'Departament Store', 'mp_m_shopkeep_01', 1134.32, -983.09, 46.4, 277.8, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(38, 'Departament Store', 'mp_m_shopkeep_01', 1165.32, 2710.79, 38.15, 175.75, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(39, 'Departament Store', 'mp_m_shopkeep_01', -1486.72, -377.61, 40.15, 130.4, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(40, 'Departament Store', 'mp_m_shopkeep_01', -1221.48, -907.93, 12.32, 31.19, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(41, 'Ammu-Nation Store', 'ig_dale', 1692.27, 3760.91, 34.69, 226.78, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(42, 'Ammu-Nation Store', 'ig_dale', 253.8, -50.47, 69.94, 65.2, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(43, 'Ammu-Nation Store', 'ig_dale', 842.54, -1035.25, 28.19, 0, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(44, 'Ammu-Nation Store', 'ig_dale', -331.67, 6084.86, 31.46, 223.94, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(45, 'Ammu-Nation Store', 'ig_dale', -662.37, -933.58, 21.82, 181.42, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(46, 'Ammu-Nation Store', 'ig_dale', -1304.12, -394.56, 36.7, 73.71, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(47, 'Ammu-Nation Store', 'ig_dale', -1118.98, 2699.73, 18.55, 221.11, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(48, 'Ammu-Nation Store', 'ig_dale', 2567.98, 292.62, 108.73, 0, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(49, 'Ammu-Nation Store', 'ig_dale', -3173.51, 1088.35, 20.84, 246.62, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(50, 'Ammu-Nation Store', 'ig_dale', 22.53, -1105.52, 29.79, 155.91, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(51, 'Ammu-Nation Store', 'ig_dale', 810.22, -2158.99, 29.62, 0, 15, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(53, 'Transporter', 'ig_casey', 264.74, 219.99, 101.67, 343, 20, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(54, 'Leiteiro', 'cs_manuel', 963.13, -2215.33, 30.55, 272.13, 50, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(55, 'Lenhador', 'a_m_o_ktown_01', 1961.61, 5179.26, 47.94, 277.8, 50, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(56, 'Caçador', 'ig_hunter', -679.14, 5834.37, 17.32, 127.56, 10, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(57, 'Caçador', 'a_m_o_ktown_01', -695.67, 5802.27, 17.33, 64.73, 50, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(58, 'Pescador', 'a_f_y_eastsa_03', -1816.64, -1193.73, 14.31, 334.49, 30, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(60, 'Throwing', 'a_m_m_paparazzi_01', -607.05, -925.7, 23.86, 218.27, 50, 0, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	-- (61, 'Concessionária', 'ig_siemonyetarian', 127.93, -142.67, 54.85, 151.9, 30, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(62, 'Comida Paramedico', 'mp_m_shopkeep_01', -533.32, -592.79, 34.64, 90.24, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(63, 'Farmacia', 's_m_m_paramedic_01', -577.77, -592.58, 34.64, 269.35, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(64, 'Central de Empregos', 'a_m_y_smartcaspat_01', -269.36, -955.38, 31.22, 204.17, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(65, 'Fishing 2', 'a_f_y_eastsa_03', -1803.71, -1197.93, 13.02, 50.3, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(66, 'Mineração', 's_m_y_construct_01', 2964.37, 2752.93, 43.33, 208.66, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(67, 'Mineração 2', 's_m_y_construct_01', 2956.94, 2745.19, 43.53, 278.86, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(68, 'Cemitery 2', 'g_m_m_armboss_01', -1734.72, -223.14, 56.09, 82.65, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(69, 'Transporter 2', 'ig_casey', 410.79, -1620.58, 29.29, 231, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(70, 'Caminhoneiro 2', 's_m_m_trucker_01', 1240.5, -3266.15, 5.53, 272.94, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(71, 'Lixeiro', 's_m_m_trucker_01', -350.09, -1570.03, 25.22, 294.81, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(72, 'Penhores', 'ig_dale', -782.17, -608.88, 30.28, 1.69, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(73, 'Desmanche 1', 'g_m_y_salvagoon_01', 2481.61, 3775.24, 56.86, 150.13, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(74, 'Desmanche 2', 'g_m_y_salvagoon_01', 1281.26, -87.01, 75.08, 57.57, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(75, 'Paleto', 'g_m_y_salvagoon_01', 124.63, 6754.15, 42.5, 126.44, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(76, 'Pesqueiro', 'g_m_y_salvagoon_01', 3717.18, 4551.16, 27.52, 331.63, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(77, 'Observatorio', 'g_m_y_salvagoon_01', -432.69, 1582.44, 359.2, 153.08, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(78, 'Resort', 'g_m_y_salvagoon_01', -1694.42, 563.32, 154.36, 320.32, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(79, 'Curvados', 'g_m_y_salvagoon_01', 851.08, 1864.29, 141.61, 124.73, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(80, 'Praia', 'g_m_y_salvagoon_01', -1226.14, -1800.43, 4.65, 212.6, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(81, 'Tunel', 'g_m_y_salvagoon_01', 1453.76, 6358.61, 29.91, 161.58, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(82, 'Porto', 'g_m_y_salvagoon_01', 1362.72, -2542.37, 48.88, 102.05, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(83, 'Norte', 'g_m_y_salvagoon_01', 1727.77, 4505.08, 42.46, 181.42, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(84, 'Corrego', 'g_m_y_salvagoon_01', 1950.62, 713.78, 191.28, 14.18, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(85, 'Lago', 'g_m_y_salvagoon_01', 188.66, 697.01, 209.06, 0, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(86, 'Helipa', 'g_m_y_salvagoon_01', 1305.9, -759.75, 75.13, 68.04, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	-- (87, 'Pipa', 'a_m_y_hipster_02', 199.89, -985.76, 30.09, 137.28, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(88, 'Ammu-Nation do Spawn', 'ig_dale', -1032.68, -2814.51, 21.36, 57.95, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(89, 'Departament do Spawn', 'mp_m_shopkeep_01', -1092.9, -2736.27, 21.36, 239.32, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL),
	(90, 'Concessionária do Spawn', 'ig_siemonyetarian', -1003.88, -2789.43, 21.36, 62.72, 50, 1, 'anim@heists@heist_corona@single_team', 'single_team_loop_boss', NULL);

-- Copiando estrutura para tabela nightevolutiontp.painel_creative_announcements
CREATE TABLE IF NOT EXISTS `painel_creative_announcements` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Title` text DEFAULT NULL,
  `Description` longtext DEFAULT NULL,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Updated` bigint(19) DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.painel_creative_paramedic
CREATE TABLE IF NOT EXISTS `painel_creative_paramedic` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Doctor` bigint(19) NOT NULL DEFAULT 0,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Description` longtext DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.painel_creative_tags
CREATE TABLE IF NOT EXISTS `painel_creative_tags` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Image` text NOT NULL DEFAULT '',
  `Name` varchar(150) NOT NULL DEFAULT 'Recruta',
  `Members` longtext NOT NULL DEFAULT '[]',
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.painel_creative_transactions
CREATE TABLE IF NOT EXISTS `painel_creative_transactions` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Type` varchar(50) NOT NULL DEFAULT 'Deposit',
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Value` bigint(19) NOT NULL DEFAULT 0,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Transfer` bigint(19) DEFAULT NULL,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.pdm
CREATE TABLE IF NOT EXISTS `pdm` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Permission` varchar(50) DEFAULT NULL,
  `Classes` longtext DEFAULT NULL,
  `Cam` varchar(255) DEFAULT NULL,
  `Spawn` varchar(255) DEFAULT NULL,
  `DriveIn` varchar(255) DEFAULT NULL,
  `DriveOut` varchar(255) DEFAULT NULL,
  `Logo` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `pdm` (`id`, `Name`, `X`, `Y`, `Z`, `Permission`, `Classes`, `Cam`, `Spawn`, `DriveIn`, `DriveOut`, `Logo`) VALUES
	(1, 'Concessionária Central', 127.63, -143.38, 54.8, '', '["Bicicletas","Blindados","Brasileiros","Caminhões","Carretas","Clássicos","Compactos","Cupês","Esportivos","Exclusivos","Ilegal","Importados","Industriais","Kids","Luxo","Motocicletas","Motos","Muscles","Off-Roads","Premium","Races","SUVs","Sedans","Ultra","Vans","Vips"]', '[132.37,-151.35,54.83,286.3]', '[137.82,-149.68,54.05,104.89]', '[-955.1,-3168.97,13.93,56.7]', '[122.68,-141.37,54.8,161.58]', 'logo.png'),
	(2, 'PDM Aeronaves', -1250.85, -3403.64, 13.94, '', '["Aviões","Helicópteros"]', '[-1266.84,-3372.62,13.94,148.94]', '[-1275.3,-3387.3,13.94,324.69]', '[-1047.38,-3310.18,13.94,59.32]', '[-1247.39,-3398.76,13.94,50.58]', 'logo.png'),
	(3, 'Concessionária do Spawn', -1004.49, -2789.09, 21.36, '', '["Motocicletas","Motos"]', '[-1021.85,-2779.95,21.36,236.81]', '[-1016.03,-2783.22,21.39,5.18]', '[-938.64,-3178.55,13.98,56.93]', '[-1007.14,-2795.31,21.36,59.77]', 'logo.png');

-- Copiando estrutura para tabela nightevolutiontp.permissions
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Permission` varchar(100) NOT NULL DEFAULT '',
  `Members` int(10) NOT NULL DEFAULT 10,
  `Tags` int(10) NOT NULL DEFAULT 3,
  `Announces` int(10) NOT NULL DEFAULT 3,
  `Experience` bigint(19) NOT NULL DEFAULT 0,
  `Points` bigint(19) NOT NULL DEFAULT 0,
  `Bank` bigint(19) NOT NULL DEFAULT 0,
  `Premium` bigint(19) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_backups
CREATE TABLE IF NOT EXISTS `phone_backups` (
  `id` varchar(100) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_backups_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_clock_alarms
CREATE TABLE IF NOT EXISTS `phone_clock_alarms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) NOT NULL,
  `hours` int(2) NOT NULL DEFAULT 0,
  `minutes` int(2) NOT NULL DEFAULT 0,
  `label` varchar(50) DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`,`phone_number`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_clock_alarms_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_crypto
CREATE TABLE IF NOT EXISTS `phone_crypto` (
  `id` varchar(100) NOT NULL,
  `coin` varchar(15) NOT NULL,
  `amount` double NOT NULL DEFAULT 0,
  `invested` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`,`coin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_darkchat_accounts
CREATE TABLE IF NOT EXISTS `phone_darkchat_accounts` (
  `phone_number` varchar(15) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`username`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_darkchat_accounts_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_darkchat_channels
CREATE TABLE IF NOT EXISTS `phone_darkchat_channels` (
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_darkchat_members
CREATE TABLE IF NOT EXISTS `phone_darkchat_members` (
  `channel_name` varchar(50) NOT NULL,
  `username` varchar(20) NOT NULL,
  PRIMARY KEY (`channel_name`,`username`),
  KEY `username` (`username`),
  CONSTRAINT `phone_darkchat_members_ibfk_1` FOREIGN KEY (`channel_name`) REFERENCES `phone_darkchat_channels` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_darkchat_members_ibfk_2` FOREIGN KEY (`username`) REFERENCES `phone_darkchat_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_darkchat_messages
CREATE TABLE IF NOT EXISTS `phone_darkchat_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel` varchar(50) NOT NULL,
  `sender` varchar(20) NOT NULL,
  `content` varchar(1000) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `channel` (`channel`),
  KEY `sender` (`sender`),
  CONSTRAINT `phone_darkchat_messages_ibfk_1` FOREIGN KEY (`channel`) REFERENCES `phone_darkchat_channels` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_darkchat_messages_ibfk_2` FOREIGN KEY (`sender`) REFERENCES `phone_darkchat_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_instagram_accounts
CREATE TABLE IF NOT EXISTS `phone_instagram_accounts` (
  `display_name` varchar(30) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `profile_image` varchar(500) DEFAULT NULL,
  `bio` varchar(100) DEFAULT NULL,
  `post_count` int(11) NOT NULL DEFAULT 0,
  `story_count` int(11) NOT NULL DEFAULT 0,
  `follower_count` int(11) NOT NULL DEFAULT 0,
  `following_count` int(11) NOT NULL DEFAULT 0,
  `phone_number` varchar(15) NOT NULL,
  `private` tinyint(1) DEFAULT 0,
  `verified` tinyint(1) DEFAULT 0,
  `date_joined` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`username`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_instagram_accounts_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_instagram_comments
CREATE TABLE IF NOT EXISTS `phone_instagram_comments` (
  `id` varchar(10) NOT NULL,
  `post_id` varchar(50) NOT NULL,
  `username` varchar(20) NOT NULL,
  `comment` varchar(500) NOT NULL DEFAULT '',
  `like_count` int(11) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  KEY `username` (`username`),
  CONSTRAINT `phone_instagram_comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `phone_instagram_posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `phone_instagram_comments_ibfk_2` FOREIGN KEY (`username`) REFERENCES `phone_instagram_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_instagram_follow_requests
CREATE TABLE IF NOT EXISTS `phone_instagram_follow_requests` (
  `requester` varchar(20) NOT NULL,
  `requestee` varchar(20) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`requester`,`requestee`),
  KEY `requestee` (`requestee`),
  CONSTRAINT `phone_instagram_follow_requests_ibfk_1` FOREIGN KEY (`requester`) REFERENCES `phone_instagram_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_instagram_follow_requests_ibfk_2` FOREIGN KEY (`requestee`) REFERENCES `phone_instagram_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_instagram_follows
CREATE TABLE IF NOT EXISTS `phone_instagram_follows` (
  `followed` varchar(20) NOT NULL,
  `follower` varchar(20) NOT NULL,
  PRIMARY KEY (`followed`,`follower`),
  KEY `follower` (`follower`),
  CONSTRAINT `phone_instagram_follows_ibfk_1` FOREIGN KEY (`followed`) REFERENCES `phone_instagram_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_instagram_follows_ibfk_2` FOREIGN KEY (`follower`) REFERENCES `phone_instagram_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_instagram_likes
CREATE TABLE IF NOT EXISTS `phone_instagram_likes` (
  `id` varchar(10) NOT NULL,
  `username` varchar(20) NOT NULL,
  `is_comment` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`,`username`),
  KEY `username` (`username`),
  CONSTRAINT `phone_instagram_likes_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_instagram_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_instagram_messages
CREATE TABLE IF NOT EXISTS `phone_instagram_messages` (
  `id` varchar(10) NOT NULL,
  `sender` varchar(20) NOT NULL,
  `recipient` varchar(20) NOT NULL,
  `content` varchar(1000) DEFAULT NULL,
  `attachments` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `sender` (`sender`),
  KEY `recipient` (`recipient`),
  CONSTRAINT `phone_instagram_messages_ibfk_1` FOREIGN KEY (`sender`) REFERENCES `phone_instagram_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_instagram_messages_ibfk_2` FOREIGN KEY (`recipient`) REFERENCES `phone_instagram_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_instagram_notifications
CREATE TABLE IF NOT EXISTS `phone_instagram_notifications` (
  `id` varchar(10) NOT NULL,
  `username` varchar(20) NOT NULL,
  `from` varchar(20) NOT NULL,
  `type` varchar(20) NOT NULL,
  `post_id` varchar(50) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  KEY `from` (`from`),
  CONSTRAINT `phone_instagram_notifications_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_instagram_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_instagram_notifications_ibfk_2` FOREIGN KEY (`from`) REFERENCES `phone_instagram_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_instagram_posts
CREATE TABLE IF NOT EXISTS `phone_instagram_posts` (
  `id` varchar(10) NOT NULL,
  `media` text DEFAULT NULL,
  `caption` varchar(500) NOT NULL DEFAULT '',
  `location` varchar(50) DEFAULT NULL,
  `like_count` int(11) NOT NULL DEFAULT 0,
  `comment_count` int(11) NOT NULL DEFAULT 0,
  `username` varchar(20) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  CONSTRAINT `phone_instagram_posts_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_instagram_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_instagram_stories
CREATE TABLE IF NOT EXISTS `phone_instagram_stories` (
  `id` varchar(10) NOT NULL,
  `username` varchar(20) NOT NULL,
  `image` varchar(500) NOT NULL,
  `metadata` longtext DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  CONSTRAINT `phone_instagram_stories_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_instagram_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_instagram_stories_views
CREATE TABLE IF NOT EXISTS `phone_instagram_stories_views` (
  `story_id` varchar(50) NOT NULL,
  `viewer` varchar(20) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`story_id`,`viewer`),
  KEY `viewer` (`viewer`),
  CONSTRAINT `phone_instagram_stories_views_ibfk_1` FOREIGN KEY (`story_id`) REFERENCES `phone_instagram_stories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `phone_instagram_stories_views_ibfk_2` FOREIGN KEY (`viewer`) REFERENCES `phone_instagram_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_last_phone
CREATE TABLE IF NOT EXISTS `phone_last_phone` (
  `id` varchar(100) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_last_phone_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_logged_in_accounts
CREATE TABLE IF NOT EXISTS `phone_logged_in_accounts` (
  `phone_number` varchar(15) NOT NULL,
  `app` varchar(50) NOT NULL,
  `username` varchar(100) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`phone_number`,`app`,`username`),
  CONSTRAINT `phone_logged_in_accounts_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_mail_accounts
CREATE TABLE IF NOT EXISTS `phone_mail_accounts` (
  `address` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_mail_deleted
CREATE TABLE IF NOT EXISTS `phone_mail_deleted` (
  `message_id` int(10) unsigned NOT NULL,
  `address` varchar(100) NOT NULL,
  PRIMARY KEY (`message_id`,`address`),
  KEY `address` (`address`),
  CONSTRAINT `phone_mail_deleted_ibfk_1` FOREIGN KEY (`message_id`) REFERENCES `phone_mail_messages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `phone_mail_deleted_ibfk_2` FOREIGN KEY (`address`) REFERENCES `phone_mail_accounts` (`address`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_mail_messages
CREATE TABLE IF NOT EXISTS `phone_mail_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `recipient` varchar(100) NOT NULL,
  `sender` varchar(100) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `attachments` longtext DEFAULT NULL,
  `actions` longtext DEFAULT NULL,
  `read` tinyint(1) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_recipient` (`recipient`),
  KEY `idx_sender` (`sender`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_maps_locations
CREATE TABLE IF NOT EXISTS `phone_maps_locations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) NOT NULL,
  `name` varchar(50) NOT NULL,
  `x_pos` float NOT NULL,
  `y_pos` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_maps_locations_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_marketplace_posts
CREATE TABLE IF NOT EXISTS `phone_marketplace_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) NOT NULL,
  `title` varchar(50) NOT NULL,
  `description` varchar(1000) NOT NULL,
  `attachments` text DEFAULT NULL,
  `price` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_marketplace_posts_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_message_channels
CREATE TABLE IF NOT EXISTS `phone_message_channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `is_group` tinyint(1) NOT NULL DEFAULT 0,
  `name` varchar(50) DEFAULT NULL,
  `last_message` varchar(50) NOT NULL DEFAULT '',
  `last_message_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_message_members
CREATE TABLE IF NOT EXISTS `phone_message_members` (
  `channel_id` int(11) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `is_owner` tinyint(1) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `unread` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`channel_id`,`phone_number`),
  KEY `idx_members_phone_number` (`phone_number`),
  CONSTRAINT `phone_message_members_ibfk_1` FOREIGN KEY (`channel_id`) REFERENCES `phone_message_channels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_message_messages
CREATE TABLE IF NOT EXISTS `phone_message_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_id` int(11) NOT NULL,
  `sender` varchar(15) NOT NULL,
  `content` varchar(1000) DEFAULT NULL,
  `attachments` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `channel_id` (`channel_id`),
  CONSTRAINT `phone_message_messages_ibfk_1` FOREIGN KEY (`channel_id`) REFERENCES `phone_message_channels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_music_playlists
CREATE TABLE IF NOT EXISTS `phone_music_playlists` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) NOT NULL,
  `name` varchar(50) NOT NULL,
  `cover` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_music_playlists_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_music_saved_playlists
CREATE TABLE IF NOT EXISTS `phone_music_saved_playlists` (
  `playlist_id` int(10) unsigned NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  PRIMARY KEY (`playlist_id`,`phone_number`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_music_saved_playlists_ibfk_1` FOREIGN KEY (`playlist_id`) REFERENCES `phone_music_playlists` (`id`) ON DELETE CASCADE,
  CONSTRAINT `phone_music_saved_playlists_ibfk_2` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_music_songs
CREATE TABLE IF NOT EXISTS `phone_music_songs` (
  `song_id` varchar(100) NOT NULL,
  `playlist_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`song_id`,`playlist_id`),
  KEY `playlist_id` (`playlist_id`),
  CONSTRAINT `phone_music_songs_ibfk_1` FOREIGN KEY (`playlist_id`) REFERENCES `phone_music_playlists` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_notes
CREATE TABLE IF NOT EXISTS `phone_notes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) NOT NULL,
  `title` varchar(50) NOT NULL,
  `content` longtext DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_notes_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_notifications
CREATE TABLE IF NOT EXISTS `phone_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) NOT NULL,
  `app` varchar(50) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `content` varchar(500) DEFAULT NULL,
  `thumbnail` varchar(500) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `show_avatar` tinyint(1) DEFAULT 0,
  `custom_data` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_notifications_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_phone_blocked_numbers
CREATE TABLE IF NOT EXISTS `phone_phone_blocked_numbers` (
  `phone_number` varchar(15) NOT NULL,
  `blocked_number` varchar(15) NOT NULL,
  PRIMARY KEY (`phone_number`,`blocked_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_phone_calls
CREATE TABLE IF NOT EXISTS `phone_phone_calls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `caller` varchar(15) NOT NULL,
  `callee` varchar(15) NOT NULL,
  `duration` int(11) NOT NULL DEFAULT 0,
  `answered` tinyint(1) DEFAULT 0,
  `hide_caller_id` tinyint(1) DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_calls_missed` (`callee`,`answered`),
  KEY `idx_calls_callee_id` (`callee`),
  KEY `idx_calls_caller_id` (`caller`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_phone_contacts
CREATE TABLE IF NOT EXISTS `phone_phone_contacts` (
  `contact_phone_number` varchar(15) NOT NULL,
  `firstname` varchar(50) NOT NULL DEFAULT '',
  `lastname` varchar(50) NOT NULL DEFAULT '',
  `profile_image` varchar(500) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `favourite` tinyint(1) DEFAULT 0,
  `phone_number` varchar(15) NOT NULL,
  PRIMARY KEY (`contact_phone_number`,`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_phone_voicemail
CREATE TABLE IF NOT EXISTS `phone_phone_voicemail` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `caller` varchar(15) NOT NULL,
  `callee` varchar(15) NOT NULL,
  `url` varchar(500) NOT NULL,
  `duration` int(11) NOT NULL,
  `hide_caller_id` tinyint(1) DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_phones
CREATE TABLE IF NOT EXISTS `phone_phones` (
  `id` varchar(100) NOT NULL,
  `owner_id` varchar(100) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `pin` varchar(4) DEFAULT NULL,
  `face_id` varchar(100) DEFAULT NULL,
  `settings` longtext DEFAULT NULL,
  `is_setup` tinyint(1) DEFAULT 0,
  `assigned` tinyint(1) DEFAULT 0,
  `battery` int(11) NOT NULL DEFAULT 100,
  `last_seen` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone_number` (`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_photo_album_members
CREATE TABLE IF NOT EXISTS `phone_photo_album_members` (
  `album_id` int(11) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  PRIMARY KEY (`album_id`,`phone_number`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_photo_album_members_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `phone_photo_albums` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_photo_album_members_ibfk_2` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_photo_album_photos
CREATE TABLE IF NOT EXISTS `phone_photo_album_photos` (
  `album_id` int(11) NOT NULL,
  `photo_id` int(11) NOT NULL,
  PRIMARY KEY (`album_id`,`photo_id`),
  KEY `photo_id` (`photo_id`),
  CONSTRAINT `phone_photo_album_photos_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `phone_photo_albums` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_photo_album_photos_ibfk_2` FOREIGN KEY (`photo_id`) REFERENCES `phone_photos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_photo_albums
CREATE TABLE IF NOT EXISTS `phone_photo_albums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) NOT NULL,
  `title` varchar(100) NOT NULL,
  `shared` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_photo_albums_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_photos
CREATE TABLE IF NOT EXISTS `phone_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) NOT NULL,
  `link` varchar(500) NOT NULL,
  `is_video` tinyint(1) DEFAULT 0,
  `size` float NOT NULL DEFAULT 0,
  `metadata` varchar(20) DEFAULT NULL,
  `is_favourite` tinyint(1) DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_photos_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_services_channels
CREATE TABLE IF NOT EXISTS `phone_services_channels` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) NOT NULL,
  `company` varchar(50) NOT NULL,
  `last_message` varchar(100) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_services_messages
CREATE TABLE IF NOT EXISTS `phone_services_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `channel_id` int(10) unsigned NOT NULL,
  `sender` varchar(15) NOT NULL,
  `message` varchar(1000) NOT NULL,
  `x_pos` int(11) DEFAULT NULL,
  `y_pos` int(11) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `channel_id` (`channel_id`),
  CONSTRAINT `phone_services_messages_ibfk_1` FOREIGN KEY (`channel_id`) REFERENCES `phone_services_channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tiktok_accounts
CREATE TABLE IF NOT EXISTS `phone_tiktok_accounts` (
  `name` varchar(30) NOT NULL,
  `bio` varchar(100) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `verified` tinyint(1) DEFAULT 0,
  `follower_count` int(11) NOT NULL DEFAULT 0,
  `following_count` int(11) NOT NULL DEFAULT 0,
  `like_count` int(11) NOT NULL DEFAULT 0,
  `video_count` int(11) NOT NULL DEFAULT 0,
  `twitter` varchar(20) DEFAULT NULL,
  `instagram` varchar(20) DEFAULT NULL,
  `show_likes` tinyint(1) DEFAULT 1,
  `phone_number` varchar(15) NOT NULL,
  `date_joined` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`username`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_tiktok_accounts_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tiktok_channels
CREATE TABLE IF NOT EXISTS `phone_tiktok_channels` (
  `id` varchar(10) NOT NULL,
  `last_message` varchar(50) NOT NULL,
  `member_1` varchar(20) NOT NULL,
  `member_2` varchar(20) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_1` (`member_1`,`member_2`),
  KEY `member_2` (`member_2`),
  CONSTRAINT `phone_tiktok_channels_ibfk_1` FOREIGN KEY (`member_1`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_channels_ibfk_2` FOREIGN KEY (`member_2`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tiktok_comments
CREATE TABLE IF NOT EXISTS `phone_tiktok_comments` (
  `id` varchar(10) NOT NULL,
  `reply_to` varchar(10) DEFAULT NULL,
  `video_id` varchar(10) NOT NULL,
  `username` varchar(20) NOT NULL,
  `comment` varchar(550) NOT NULL,
  `likes` int(11) NOT NULL DEFAULT 0,
  `replies` int(11) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `video_id` (`video_id`),
  KEY `username` (`username`),
  KEY `reply_to` (`reply_to`),
  CONSTRAINT `phone_tiktok_comments_ibfk_1` FOREIGN KEY (`video_id`) REFERENCES `phone_tiktok_videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_comments_ibfk_2` FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_comments_ibfk_3` FOREIGN KEY (`reply_to`) REFERENCES `phone_tiktok_comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tiktok_comments_likes
CREATE TABLE IF NOT EXISTS `phone_tiktok_comments_likes` (
  `username` varchar(20) NOT NULL,
  `comment_id` varchar(10) NOT NULL,
  PRIMARY KEY (`username`,`comment_id`),
  KEY `comment_id` (`comment_id`),
  CONSTRAINT `phone_tiktok_comments_likes_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_comments_likes_ibfk_2` FOREIGN KEY (`comment_id`) REFERENCES `phone_tiktok_comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tiktok_follows
CREATE TABLE IF NOT EXISTS `phone_tiktok_follows` (
  `followed` varchar(20) NOT NULL,
  `follower` varchar(20) NOT NULL,
  PRIMARY KEY (`followed`,`follower`),
  KEY `follower` (`follower`),
  CONSTRAINT `phone_tiktok_follows_ibfk_1` FOREIGN KEY (`followed`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_follows_ibfk_2` FOREIGN KEY (`follower`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tiktok_likes
CREATE TABLE IF NOT EXISTS `phone_tiktok_likes` (
  `username` varchar(20) NOT NULL,
  `video_id` varchar(10) NOT NULL,
  PRIMARY KEY (`username`,`video_id`),
  KEY `video_id` (`video_id`),
  CONSTRAINT `phone_tiktok_likes_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_likes_ibfk_2` FOREIGN KEY (`video_id`) REFERENCES `phone_tiktok_videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tiktok_messages
CREATE TABLE IF NOT EXISTS `phone_tiktok_messages` (
  `id` varchar(10) NOT NULL,
  `channel_id` varchar(10) NOT NULL,
  `sender` varchar(20) NOT NULL,
  `content` varchar(500) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `channel_id` (`channel_id`),
  KEY `sender` (`sender`),
  CONSTRAINT `phone_tiktok_messages_ibfk_1` FOREIGN KEY (`channel_id`) REFERENCES `phone_tiktok_channels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_messages_ibfk_2` FOREIGN KEY (`sender`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tiktok_notifications
CREATE TABLE IF NOT EXISTS `phone_tiktok_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `from` varchar(20) NOT NULL,
  `type` varchar(20) NOT NULL,
  `video_id` varchar(10) DEFAULT NULL,
  `comment_id` varchar(10) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  KEY `from` (`from`),
  KEY `video_id` (`video_id`),
  KEY `comment_id` (`comment_id`),
  CONSTRAINT `phone_tiktok_notifications_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_notifications_ibfk_2` FOREIGN KEY (`from`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_notifications_ibfk_3` FOREIGN KEY (`video_id`) REFERENCES `phone_tiktok_videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_notifications_ibfk_4` FOREIGN KEY (`comment_id`) REFERENCES `phone_tiktok_comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tiktok_pinned_videos
CREATE TABLE IF NOT EXISTS `phone_tiktok_pinned_videos` (
  `username` varchar(20) NOT NULL,
  `video_id` varchar(10) NOT NULL,
  PRIMARY KEY (`username`,`video_id`),
  KEY `video_id` (`video_id`),
  CONSTRAINT `phone_tiktok_pinned_videos_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_pinned_videos_ibfk_2` FOREIGN KEY (`video_id`) REFERENCES `phone_tiktok_videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tiktok_saves
CREATE TABLE IF NOT EXISTS `phone_tiktok_saves` (
  `username` varchar(20) NOT NULL,
  `video_id` varchar(10) NOT NULL,
  PRIMARY KEY (`username`,`video_id`),
  KEY `video_id` (`video_id`),
  CONSTRAINT `phone_tiktok_saves_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_saves_ibfk_2` FOREIGN KEY (`video_id`) REFERENCES `phone_tiktok_videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tiktok_unread_messages
CREATE TABLE IF NOT EXISTS `phone_tiktok_unread_messages` (
  `username` varchar(20) NOT NULL,
  `channel_id` varchar(10) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`username`,`channel_id`),
  KEY `channel_id` (`channel_id`),
  CONSTRAINT `phone_tiktok_unread_messages_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_unread_messages_ibfk_2` FOREIGN KEY (`channel_id`) REFERENCES `phone_tiktok_channels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tiktok_videos
CREATE TABLE IF NOT EXISTS `phone_tiktok_videos` (
  `id` varchar(10) NOT NULL,
  `username` varchar(20) NOT NULL,
  `src` varchar(500) NOT NULL,
  `caption` varchar(100) DEFAULT NULL,
  `metadata` longtext DEFAULT NULL,
  `music` text DEFAULT NULL,
  `likes` int(11) NOT NULL DEFAULT 0,
  `comments` int(11) NOT NULL DEFAULT 0,
  `views` int(11) NOT NULL DEFAULT 0,
  `saves` int(11) NOT NULL DEFAULT 0,
  `pinned_comment` varchar(10) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  CONSTRAINT `phone_tiktok_videos_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tiktok_views
CREATE TABLE IF NOT EXISTS `phone_tiktok_views` (
  `username` varchar(20) NOT NULL,
  `video_id` varchar(10) NOT NULL,
  PRIMARY KEY (`username`,`video_id`),
  KEY `video_id` (`video_id`),
  CONSTRAINT `phone_tiktok_views_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_tiktok_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tiktok_views_ibfk_2` FOREIGN KEY (`video_id`) REFERENCES `phone_tiktok_videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tinder_accounts
CREATE TABLE IF NOT EXISTS `phone_tinder_accounts` (
  `name` varchar(50) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `photos` text DEFAULT NULL,
  `bio` varchar(500) DEFAULT NULL,
  `dob` date NOT NULL,
  `is_male` tinyint(1) NOT NULL,
  `interested_men` tinyint(1) NOT NULL,
  `interested_women` tinyint(1) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `last_seen` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`phone_number`),
  CONSTRAINT `phone_tinder_accounts_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tinder_matches
CREATE TABLE IF NOT EXISTS `phone_tinder_matches` (
  `phone_number_1` varchar(15) NOT NULL,
  `phone_number_2` varchar(15) NOT NULL,
  `latest_message` varchar(1000) DEFAULT NULL,
  `latest_message_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`phone_number_1`,`phone_number_2`),
  KEY `phone_number_2` (`phone_number_2`),
  CONSTRAINT `phone_tinder_matches_ibfk_1` FOREIGN KEY (`phone_number_1`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tinder_matches_ibfk_2` FOREIGN KEY (`phone_number_2`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tinder_messages
CREATE TABLE IF NOT EXISTS `phone_tinder_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(15) NOT NULL,
  `recipient` varchar(15) NOT NULL,
  `content` varchar(1000) DEFAULT NULL,
  `attachments` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `sender` (`sender`),
  KEY `recipient` (`recipient`),
  CONSTRAINT `phone_tinder_messages_ibfk_1` FOREIGN KEY (`sender`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tinder_messages_ibfk_2` FOREIGN KEY (`recipient`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_tinder_swipes
CREATE TABLE IF NOT EXISTS `phone_tinder_swipes` (
  `swiper` varchar(15) NOT NULL,
  `swipee` varchar(15) NOT NULL,
  `liked` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`swiper`,`swipee`),
  KEY `swipee` (`swipee`),
  CONSTRAINT `phone_tinder_swipes_ibfk_1` FOREIGN KEY (`swiper`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_tinder_swipes_ibfk_2` FOREIGN KEY (`swipee`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_twitter_accounts
CREATE TABLE IF NOT EXISTS `phone_twitter_accounts` (
  `display_name` varchar(30) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `bio` varchar(100) DEFAULT NULL,
  `profile_image` varchar(500) DEFAULT NULL,
  `profile_header` varchar(500) DEFAULT NULL,
  `pinned_tweet` varchar(50) DEFAULT NULL,
  `verified` tinyint(1) DEFAULT 0,
  `follower_count` int(11) NOT NULL DEFAULT 0,
  `following_count` int(11) NOT NULL DEFAULT 0,
  `private` tinyint(1) DEFAULT 0,
  `date_joined` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`username`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_twitter_accounts_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_twitter_follow_requests
CREATE TABLE IF NOT EXISTS `phone_twitter_follow_requests` (
  `requester` varchar(20) NOT NULL,
  `requestee` varchar(20) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`requester`,`requestee`),
  KEY `requestee` (`requestee`),
  CONSTRAINT `phone_twitter_follow_requests_ibfk_1` FOREIGN KEY (`requester`) REFERENCES `phone_twitter_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_twitter_follow_requests_ibfk_2` FOREIGN KEY (`requestee`) REFERENCES `phone_twitter_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_twitter_follows
CREATE TABLE IF NOT EXISTS `phone_twitter_follows` (
  `followed` varchar(20) NOT NULL,
  `follower` varchar(20) NOT NULL,
  `notifications` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`followed`,`follower`),
  KEY `follower` (`follower`),
  CONSTRAINT `phone_twitter_follows_ibfk_1` FOREIGN KEY (`followed`) REFERENCES `phone_twitter_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_twitter_follows_ibfk_2` FOREIGN KEY (`follower`) REFERENCES `phone_twitter_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_twitter_hashtags
CREATE TABLE IF NOT EXISTS `phone_twitter_hashtags` (
  `hashtag` varchar(50) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `last_used` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`hashtag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_twitter_likes
CREATE TABLE IF NOT EXISTS `phone_twitter_likes` (
  `tweet_id` varchar(50) NOT NULL,
  `username` varchar(20) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`tweet_id`,`username`),
  KEY `username` (`username`),
  CONSTRAINT `phone_twitter_likes_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_twitter_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_twitter_messages
CREATE TABLE IF NOT EXISTS `phone_twitter_messages` (
  `id` varchar(10) NOT NULL,
  `sender` varchar(20) NOT NULL,
  `recipient` varchar(20) NOT NULL,
  `content` varchar(1000) DEFAULT NULL,
  `attachments` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `sender` (`sender`),
  KEY `recipient` (`recipient`),
  CONSTRAINT `phone_twitter_messages_ibfk_1` FOREIGN KEY (`sender`) REFERENCES `phone_twitter_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_twitter_messages_ibfk_2` FOREIGN KEY (`recipient`) REFERENCES `phone_twitter_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_twitter_notifications
CREATE TABLE IF NOT EXISTS `phone_twitter_notifications` (
  `id` varchar(10) NOT NULL,
  `username` varchar(20) NOT NULL,
  `from` varchar(20) NOT NULL,
  `type` varchar(20) NOT NULL,
  `tweet_id` varchar(50) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  KEY `from` (`from`),
  CONSTRAINT `phone_twitter_notifications_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_twitter_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_twitter_notifications_ibfk_2` FOREIGN KEY (`from`) REFERENCES `phone_twitter_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_twitter_promoted
CREATE TABLE IF NOT EXISTS `phone_twitter_promoted` (
  `tweet_id` varchar(50) NOT NULL,
  `promotions` int(11) NOT NULL DEFAULT 0,
  `views` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`tweet_id`),
  CONSTRAINT `phone_twitter_promoted_ibfk_1` FOREIGN KEY (`tweet_id`) REFERENCES `phone_twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_twitter_retweets
CREATE TABLE IF NOT EXISTS `phone_twitter_retweets` (
  `tweet_id` varchar(50) NOT NULL,
  `username` varchar(20) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`tweet_id`,`username`),
  KEY `username` (`username`),
  CONSTRAINT `phone_twitter_retweets_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_twitter_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_twitter_tweets
CREATE TABLE IF NOT EXISTS `phone_twitter_tweets` (
  `id` varchar(10) NOT NULL,
  `username` varchar(20) NOT NULL,
  `content` varchar(280) DEFAULT NULL,
  `attachments` text DEFAULT NULL,
  `reply_to` varchar(50) DEFAULT NULL,
  `like_count` int(11) DEFAULT 0,
  `reply_count` int(11) DEFAULT 0,
  `retweet_count` int(11) DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  CONSTRAINT `phone_twitter_tweets_ibfk_1` FOREIGN KEY (`username`) REFERENCES `phone_twitter_accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_vipstore_orders
CREATE TABLE IF NOT EXISTS `phone_vipstore_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL,
  `product_id` varchar(80) NOT NULL,
  `product_name` varchar(120) NOT NULL,
  `item` varchar(120) NOT NULL,
  `amount` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `created_at` int(11) NOT NULL,
  `redeemed_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_phone_vipstore_passport` (`passport`),
  KEY `idx_phone_vipstore_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_voice_memos_recordings
CREATE TABLE IF NOT EXISTS `phone_voice_memos_recordings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) NOT NULL,
  `file_name` varchar(50) NOT NULL,
  `file_url` varchar(500) NOT NULL,
  `file_length` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_voice_memos_recordings_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_wallet_transactions
CREATE TABLE IF NOT EXISTS `phone_wallet_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) NOT NULL,
  `amount` int(11) NOT NULL,
  `company` varchar(50) NOT NULL,
  `logo` varchar(200) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `phone_number` (`phone_number`),
  CONSTRAINT `phone_wallet_transactions_ibfk_1` FOREIGN KEY (`phone_number`) REFERENCES `phone_phones` (`phone_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.phone_yellow_pages_posts
CREATE TABLE IF NOT EXISTS `phone_yellow_pages_posts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) NOT NULL,
  `title` varchar(50) NOT NULL,
  `description` varchar(1000) NOT NULL,
  `attachment` varchar(500) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Copiando estrutura para tabela nightevolutiontp.playerdata
CREATE TABLE IF NOT EXISTS `playerdata` (
  `Passport` bigint(19) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Information` longtext DEFAULT NULL,
  PRIMARY KEY (`Passport`,`Name`),
  KEY `Passport` (`Passport`),
  KEY `Information` (`Name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.propertys
CREATE TABLE IF NOT EXISTS `propertys` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL DEFAULT 'Propertys0001',
  `Interior` varchar(20) NOT NULL DEFAULT 'Amethyst',
  `Item` bigint(19) NOT NULL DEFAULT 3,
  `Tax` bigint(19) NOT NULL DEFAULT 0,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Serial` varchar(10) NOT NULL,
  `Garage` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.races
CREATE TABLE IF NOT EXISTS `races` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL DEFAULT 'Indivíduo Indigente',
  `Mode` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `Race` smallint(5) unsigned NOT NULL DEFAULT 0,
  `Passport` int(10) unsigned NOT NULL DEFAULT 0,
  `Vehicle` varchar(50) NOT NULL DEFAULT 'Sultan RS',
  `Points` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_race_player` (`Mode`,`Race`,`Passport`),
  KEY `Points` (`Points`),
  KEY `Name` (`Name`),
  KEY `Vehicle` (`Vehicle`),
  KEY `Passport` (`Passport`),
  KEY `Race` (`Race`),
  KEY `Mode` (`Mode`),
  KEY `idx_races_race_points` (`Race`,`Points`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.radios
CREATE TABLE IF NOT EXISTS `radios` (
  `frequencia` int(11) NOT NULL,
  `permissao` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`frequencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.relacionamento
CREATE TABLE IF NOT EXISTS `relacionamento` (
  `identifier` varchar(60) NOT NULL,
  `status` enum('solteiro','namorando','noivo','casado') NOT NULL DEFAULT 'solteiro',
  `partner_id` varchar(60) DEFAULT NULL,
  `partner_name` varchar(80) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.routes
CREATE TABLE IF NOT EXISTS `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `route` tinyint(1) DEFAULT 1,
  `circle` float DEFAULT 1,
  `wanted` int(11) DEFAULT 600,
  `battlepass` int(11) DEFAULT 2,
  `debugpoly` tinyint(1) DEFAULT 0,
  `permission` varchar(50) DEFAULT NULL,
  `mode` varchar(50) DEFAULT 'Always',
  `init` varchar(255) DEFAULT NULL,
  `experience` longtext DEFAULT NULL,
  `list` longtext DEFAULT NULL,
  `coords` longtext DEFAULT NULL,
  `loop` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `routes` (`id`, `name`, `route`, `circle`, `wanted`, `battlepass`, `debugpoly`, `permission`, `mode`, `init`, `experience`, `list`, `coords`, `loop`) VALUES
	(1, 'Et', 1, 1, 600, 2, 0, 'Et', 'Always', '{"z":56.85,"x":2481.61,"y":3775.24}', '{"Amount":1,"Name":"Lumberman"}', '[{"Max":5,"Item":"aluminum","Chance":50,"Min":1,"Price":0},{"Max":5,"Item":"sheetmetal","Chance":50,"Min":1,"Price":0}]', '[{"z":23.47,"x":-513.92,"y":-1019.31},{"z":10.08,"x":-1604.18,"y":-832.26},{"z":42.57,"x":-536.48,"y":-45.61},{"z":71.62,"x":-53.01,"y":79.35},{"z":99.48,"x":581.16,"y":139.13},{"z":80.6,"x":814.39,"y":-93.48},{"z":67.01,"x":1106.93,"y":-355.03},{"z":58.36,"x":1070.71,"y":-780.46},{"z":45.91,"x":1142.82,"y":-986.58},{"z":35.23,"x":1200.55,"y":-1276.6},{"z":31.24,"x":967.81,"y":-1829.29},{"z":29.65,"x":809.16,"y":-2222.61},{"z":6.02,"x":684.61,"y":-2741.62},{"z":6.45,"x":263.47,"y":-2506.62},{"z":6.01,"x":94.66,"y":-2676.38},{"z":7.4,"x":-43.87,"y":-2519.91},{"z":18.28,"x":182.93,"y":-2027.68},{"z":10.84,"x":-306.86,"y":-2191.84},{"z":23.19,"x":-570.95,"y":-1775.95},{"z":25.23,"x":-350.03,"y":-1569.9},{"z":29.57,"x":-128.36,"y":-1394.12},{"z":29.37,"x":67.84,"y":-1399.02},{"z":32.51,"x":343.13,"y":-1297.91},{"z":29.29,"x":485.92,"y":-1477.41},{"z":29.21,"x":139.81,"y":-1337.41},{"z":31.93,"x":263.82,"y":-1346.16},{"z":10.66,"x":-723.33,"y":-1112.41},{"z":7.02,"x":-842.54,"y":-1128.21},{"z":25.94,"x":488.46,"y":-898.56}]', 1),
	(2, 'Barragem', 1, 1, 600, 2, 0, 'Barragem', 'Always', '{"x":1281.26,"y":-87.01,"z":75.08}', '{"Name":"Lumberman","Amount":1}', '[{"Min":1,"Chance":50,"Max":5,"Price":0,"Item":"aluminum"},{"Min":1,"Chance":50,"Max":5,"Price":0,"Item":"sheetmetal"}]', '[{"x":-513.92,"y":-1019.31,"z":23.47},{"x":-1604.18,"y":-832.26,"z":10.08},{"x":-536.48,"y":-45.61,"z":42.57},{"x":-53.01,"y":79.35,"z":71.62},{"x":581.16,"y":139.13,"z":99.48},{"x":814.39,"y":-93.48,"z":80.6},{"x":1106.93,"y":-355.03,"z":67.01},{"x":1070.71,"y":-780.46,"z":58.36},{"x":1142.82,"y":-986.58,"z":45.91},{"x":1200.55,"y":-1276.6,"z":35.23},{"x":967.81,"y":-1829.29,"z":31.24},{"x":809.16,"y":-2222.61,"z":29.65},{"x":684.61,"y":-2741.62,"z":6.02},{"x":263.47,"y":-2506.62,"z":6.45},{"x":94.66,"y":-2676.38,"z":6.01},{"x":-43.87,"y":-2519.91,"z":7.4},{"x":182.93,"y":-2027.68,"z":18.28},{"x":-306.86,"y":-2191.84,"z":10.84},{"x":-570.95,"y":-1775.95,"z":23.19},{"x":-350.03,"y":-1569.9,"z":25.23},{"x":-128.36,"y":-1394.12,"z":29.57},{"x":67.84,"y":-1399.02,"z":29.37},{"x":343.13,"y":-1297.91,"z":32.51},{"x":485.92,"y":-1477.41,"z":29.29},{"x":139.81,"y":-1337.41,"z":29.21},{"x":263.82,"y":-1346.16,"z":31.93},{"x":-723.33,"y":-1112.41,"z":10.66},{"x":-842.54,"y":-1128.21,"z":7.02},{"x":488.46,"y":-898.56,"z":25.94}]', 0),
	(3, 'Paleto', 1, 1, 600, 2, 0, 'Paleto', 'Always', '{"x":124.63,"y":6754.15,"z":42.5}', '{"Name":"Lumberman","Amount":1}', '[{"Item":"acetone","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"alcohol","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"analgesic","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"coke","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"saline","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"sulfuric","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"weed","Chance":50,"Min":1,"Max":5,"Price":0}]', '[{"x":-513.92,"y":-1019.31,"z":23.47},{"x":-1604.18,"y":-832.26,"z":10.08},{"x":-536.48,"y":-45.61,"z":42.57},{"x":-53.01,"y":79.35,"z":71.62},{"x":581.16,"y":139.13,"z":99.48},{"x":814.39,"y":-93.48,"z":80.6},{"x":1106.93,"y":-355.03,"z":67.01},{"x":1070.71,"y":-780.46,"z":58.36},{"x":1142.82,"y":-986.58,"z":45.91},{"x":1200.55,"y":-1276.6,"z":35.23},{"x":967.81,"y":-1829.29,"z":31.24},{"x":809.16,"y":-2222.61,"z":29.65},{"x":684.61,"y":-2741.62,"z":6.02},{"x":263.47,"y":-2506.62,"z":6.45},{"x":94.66,"y":-2676.38,"z":6.01},{"x":-43.87,"y":-2519.91,"z":7.4},{"x":182.93,"y":-2027.68,"z":18.28},{"x":-306.86,"y":-2191.84,"z":10.84},{"x":-570.95,"y":-1775.95,"z":23.19},{"x":-350.03,"y":-1569.9,"z":25.23},{"x":-128.36,"y":-1394.12,"z":29.57},{"x":67.84,"y":-1399.02,"z":29.37},{"x":343.13,"y":-1297.91,"z":32.51},{"x":485.92,"y":-1477.41,"z":29.29},{"x":139.81,"y":-1337.41,"z":29.21},{"x":263.82,"y":-1346.16,"z":31.93},{"x":-723.33,"y":-1112.41,"z":10.66},{"x":-842.54,"y":-1128.21,"z":7.02},{"x":488.46,"y":-898.56,"z":25.94}]', 0),
	(4, 'Pesqueiro', 1, 1, 600, 2, 0, 'Pesqueiro', 'Always', '{"x":3717.18,"y":4551.16,"z":27.52}', '{"Name":"Lumberman","Amount":1}', '[{"Item":"acetone","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"alcohol","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"analgesic","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"coke","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"saline","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"sulfuric","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"weed","Chance":50,"Min":1,"Max":5,"Price":0}]', '[{"x":-513.92,"y":-1019.31,"z":23.47},{"x":-1604.18,"y":-832.26,"z":10.08},{"x":-536.48,"y":-45.61,"z":42.57},{"x":-53.01,"y":79.35,"z":71.62},{"x":581.16,"y":139.13,"z":99.48},{"x":814.39,"y":-93.48,"z":80.6},{"x":1106.93,"y":-355.03,"z":67.01},{"x":1070.71,"y":-780.46,"z":58.36},{"x":1142.82,"y":-986.58,"z":45.91},{"x":1200.55,"y":-1276.6,"z":35.23},{"x":967.81,"y":-1829.29,"z":31.24},{"x":809.16,"y":-2222.61,"z":29.65},{"x":684.61,"y":-2741.62,"z":6.02},{"x":263.47,"y":-2506.62,"z":6.45},{"x":94.66,"y":-2676.38,"z":6.01},{"x":-43.87,"y":-2519.91,"z":7.4},{"x":182.93,"y":-2027.68,"z":18.28},{"x":-306.86,"y":-2191.84,"z":10.84},{"x":-570.95,"y":-1775.95,"z":23.19},{"x":-350.03,"y":-1569.9,"z":25.23},{"x":-128.36,"y":-1394.12,"z":29.57},{"x":67.84,"y":-1399.02,"z":29.37},{"x":343.13,"y":-1297.91,"z":32.51},{"x":485.92,"y":-1477.41,"z":29.29},{"x":139.81,"y":-1337.41,"z":29.21},{"x":263.82,"y":-1346.16,"z":31.93},{"x":-723.33,"y":-1112.41,"z":10.66},{"x":-842.54,"y":-1128.21,"z":7.02},{"x":488.46,"y":-898.56,"z":25.94}]', 0),
	(5, 'Observatorio', 1, 1, 600, 2, 0, 'Observatorio', 'Always', '{"x":-432.69,"y":1582.44,"z":359.2}', '{"Name":"Lumberman","Amount":1}', '[{"Item":"acetone","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"alcohol","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"analgesic","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"coke","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"saline","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"sulfuric","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"weed","Chance":50,"Min":1,"Max":5,"Price":0}]', '[{"x":-513.92,"y":-1019.31,"z":23.47},{"x":-1604.18,"y":-832.26,"z":10.08},{"x":-536.48,"y":-45.61,"z":42.57},{"x":-53.01,"y":79.35,"z":71.62},{"x":581.16,"y":139.13,"z":99.48},{"x":814.39,"y":-93.48,"z":80.6},{"x":1106.93,"y":-355.03,"z":67.01},{"x":1070.71,"y":-780.46,"z":58.36},{"x":1142.82,"y":-986.58,"z":45.91},{"x":1200.55,"y":-1276.6,"z":35.23},{"x":967.81,"y":-1829.29,"z":31.24},{"x":809.16,"y":-2222.61,"z":29.65},{"x":684.61,"y":-2741.62,"z":6.02},{"x":263.47,"y":-2506.62,"z":6.45},{"x":94.66,"y":-2676.38,"z":6.01},{"x":-43.87,"y":-2519.91,"z":7.4},{"x":182.93,"y":-2027.68,"z":18.28},{"x":-306.86,"y":-2191.84,"z":10.84},{"x":-570.95,"y":-1775.95,"z":23.19},{"x":-350.03,"y":-1569.9,"z":25.23},{"x":-128.36,"y":-1394.12,"z":29.57},{"x":67.84,"y":-1399.02,"z":29.37},{"x":343.13,"y":-1297.91,"z":32.51},{"x":485.92,"y":-1477.41,"z":29.29},{"x":139.81,"y":-1337.41,"z":29.21},{"x":263.82,"y":-1346.16,"z":31.93},{"x":-723.33,"y":-1112.41,"z":10.66},{"x":-842.54,"y":-1128.21,"z":7.02},{"x":488.46,"y":-898.56,"z":25.94}]', 0),
	(6, 'Resort', 1, 1, 600, 2, 0, 'Resort', 'Always', '{"x":-1694.42,"y":563.32,"z":154.36}', '{"Name":"Lumberman","Amount":1}', '[{"Item":"aluminum","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"batteryaa","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"batteryaaplus","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"copper","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"electroniccomponents","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"emptybottle","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"glass","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"gunpowder","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"insulatingtape","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"metalspring","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"plastic","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"roadsigns","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"scotchtape","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"screws","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"sheetmetal","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"tarp","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"toothpaste","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"rubber","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"explosives","Chance":50,"Min":1,"Max":5,"Price":0}]', '[{"x":-513.92,"y":-1019.31,"z":23.47},{"x":-1604.18,"y":-832.26,"z":10.08},{"x":-536.48,"y":-45.61,"z":42.57},{"x":-53.01,"y":79.35,"z":71.62},{"x":581.16,"y":139.13,"z":99.48},{"x":814.39,"y":-93.48,"z":80.6},{"x":1106.93,"y":-355.03,"z":67.01},{"x":1070.71,"y":-780.46,"z":58.36},{"x":1142.82,"y":-986.58,"z":45.91},{"x":1200.55,"y":-1276.6,"z":35.23},{"x":967.81,"y":-1829.29,"z":31.24},{"x":809.16,"y":-2222.61,"z":29.65},{"x":684.61,"y":-2741.62,"z":6.02},{"x":263.47,"y":-2506.62,"z":6.45},{"x":94.66,"y":-2676.38,"z":6.01},{"x":-43.87,"y":-2519.91,"z":7.4},{"x":182.93,"y":-2027.68,"z":18.28},{"x":-306.86,"y":-2191.84,"z":10.84},{"x":-570.95,"y":-1775.95,"z":23.19},{"x":-350.03,"y":-1569.9,"z":25.23},{"x":-128.36,"y":-1394.12,"z":29.57},{"x":67.84,"y":-1399.02,"z":29.37},{"x":343.13,"y":-1297.91,"z":32.51},{"x":485.92,"y":-1477.41,"z":29.29},{"x":139.81,"y":-1337.41,"z":29.21},{"x":263.82,"y":-1346.16,"z":31.93},{"x":-723.33,"y":-1112.41,"z":10.66},{"x":-842.54,"y":-1128.21,"z":7.02},{"x":488.46,"y":-898.56,"z":25.94}]', 0),
	(7, 'Curvados', 1, 1, 600, 2, 0, 'Curvados', 'Always', '{"x":851.08,"y":1864.29,"z":141.61}', '{"Name":"Lumberman","Amount":1}', '[{"Item":"aluminum","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"batteryaa","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"batteryaaplus","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"copper","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"electroniccomponents","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"emptybottle","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"glass","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"gunpowder","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"insulatingtape","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"metalspring","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"plastic","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"roadsigns","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"scotchtape","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"screws","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"sheetmetal","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"tarp","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"toothpaste","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"rubber","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"explosives","Chance":50,"Min":1,"Max":5,"Price":0}]', '[{"x":-513.92,"y":-1019.31,"z":23.47},{"x":-1604.18,"y":-832.26,"z":10.08},{"x":-536.48,"y":-45.61,"z":42.57},{"x":-53.01,"y":79.35,"z":71.62},{"x":581.16,"y":139.13,"z":99.48},{"x":814.39,"y":-93.48,"z":80.6},{"x":1106.93,"y":-355.03,"z":67.01},{"x":1070.71,"y":-780.46,"z":58.36},{"x":1142.82,"y":-986.58,"z":45.91},{"x":1200.55,"y":-1276.6,"z":35.23},{"x":967.81,"y":-1829.29,"z":31.24},{"x":809.16,"y":-2222.61,"z":29.65},{"x":684.61,"y":-2741.62,"z":6.02},{"x":263.47,"y":-2506.62,"z":6.45},{"x":94.66,"y":-2676.38,"z":6.01},{"x":-43.87,"y":-2519.91,"z":7.4},{"x":182.93,"y":-2027.68,"z":18.28},{"x":-306.86,"y":-2191.84,"z":10.84},{"x":-570.95,"y":-1775.95,"z":23.19},{"x":-350.03,"y":-1569.9,"z":25.23},{"x":-128.36,"y":-1394.12,"z":29.57},{"x":67.84,"y":-1399.02,"z":29.37},{"x":343.13,"y":-1297.91,"z":32.51},{"x":485.92,"y":-1477.41,"z":29.29},{"x":139.81,"y":-1337.41,"z":29.21},{"x":263.82,"y":-1346.16,"z":31.93},{"x":-723.33,"y":-1112.41,"z":10.66},{"x":-842.54,"y":-1128.21,"z":7.02},{"x":488.46,"y":-898.56,"z":25.94}]', 0),
	(8, 'Praia', 1, 1, 600, 2, 0, 'Praia', 'Always', '{"x":-1226.14,"y":-1800.43,"z":4.65}', '{"Name":"Lumberman","Amount":1}', '[{"Item":"aluminum","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"copper","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"glass","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"metalspring","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"pistolbody","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"plastic","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"rubber","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"riflebody","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"smgbody","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"weaponparts","Chance":50,"Min":1,"Max":5,"Price":0}]', '[{"x":-513.92,"y":-1019.31,"z":23.47},{"x":-1604.18,"y":-832.26,"z":10.08},{"x":-536.48,"y":-45.61,"z":42.57},{"x":-53.01,"y":79.35,"z":71.62},{"x":581.16,"y":139.13,"z":99.48},{"x":814.39,"y":-93.48,"z":80.6},{"x":1106.93,"y":-355.03,"z":67.01},{"x":1070.71,"y":-780.46,"z":58.36},{"x":1142.82,"y":-986.58,"z":45.91},{"x":1200.55,"y":-1276.6,"z":35.23},{"x":967.81,"y":-1829.29,"z":31.24},{"x":809.16,"y":-2222.61,"z":29.65},{"x":684.61,"y":-2741.62,"z":6.02},{"x":263.47,"y":-2506.62,"z":6.45},{"x":94.66,"y":-2676.38,"z":6.01},{"x":-43.87,"y":-2519.91,"z":7.4},{"x":182.93,"y":-2027.68,"z":18.28},{"x":-306.86,"y":-2191.84,"z":10.84},{"x":-570.95,"y":-1775.95,"z":23.19},{"x":-350.03,"y":-1569.9,"z":25.23},{"x":-128.36,"y":-1394.12,"z":29.57},{"x":67.84,"y":-1399.02,"z":29.37},{"x":343.13,"y":-1297.91,"z":32.51},{"x":485.92,"y":-1477.41,"z":29.29},{"x":139.81,"y":-1337.41,"z":29.21},{"x":263.82,"y":-1346.16,"z":31.93},{"x":-723.33,"y":-1112.41,"z":10.66},{"x":-842.54,"y":-1128.21,"z":7.02},{"x":488.46,"y":-898.56,"z":25.94}]', 0),
	(9, 'Tunel', 1, 1, 600, 2, 0, 'Tunel', 'Always', '{"x":1453.76,"y":6358.61,"z":29.91}', '{"Name":"Lumberman","Amount":1}', '[{"Item":"aluminum","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"copper","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"glass","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"metalspring","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"pistolbody","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"plastic","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"rubber","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"riflebody","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"smgbody","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"weaponparts","Chance":50,"Min":1,"Max":5,"Price":0}]', '[{"x":-513.92,"y":-1019.31,"z":23.47},{"x":-1604.18,"y":-832.26,"z":10.08},{"x":-536.48,"y":-45.61,"z":42.57},{"x":-53.01,"y":79.35,"z":71.62},{"x":581.16,"y":139.13,"z":99.48},{"x":814.39,"y":-93.48,"z":80.6},{"x":1106.93,"y":-355.03,"z":67.01},{"x":1070.71,"y":-780.46,"z":58.36},{"x":1142.82,"y":-986.58,"z":45.91},{"x":1200.55,"y":-1276.6,"z":35.23},{"x":967.81,"y":-1829.29,"z":31.24},{"x":809.16,"y":-2222.61,"z":29.65},{"x":684.61,"y":-2741.62,"z":6.02},{"x":263.47,"y":-2506.62,"z":6.45},{"x":94.66,"y":-2676.38,"z":6.01},{"x":-43.87,"y":-2519.91,"z":7.4},{"x":182.93,"y":-2027.68,"z":18.28},{"x":-306.86,"y":-2191.84,"z":10.84},{"x":-570.95,"y":-1775.95,"z":23.19},{"x":-350.03,"y":-1569.9,"z":25.23},{"x":-128.36,"y":-1394.12,"z":29.57},{"x":67.84,"y":-1399.02,"z":29.37},{"x":343.13,"y":-1297.91,"z":32.51},{"x":485.92,"y":-1477.41,"z":29.29},{"x":139.81,"y":-1337.41,"z":29.21},{"x":263.82,"y":-1346.16,"z":31.93},{"x":-723.33,"y":-1112.41,"z":10.66},{"x":-842.54,"y":-1128.21,"z":7.02},{"x":488.46,"y":-898.56,"z":25.94}]', 0),
	(10, 'Porto', 1, 1, 600, 2, 0, 'Porto', 'Always', '{"x":1362.72,"y":-2542.37,"z":48.88}', '{"Name":"Lumberman","Amount":1}', '[{"Item":"lead_pure","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"copper_pure","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"gunpowder","Chance":50,"Min":1,"Max":5,"Price":0}]', '[{"x":-513.92,"y":-1019.31,"z":23.47},{"x":-1604.18,"y":-832.26,"z":10.08},{"x":-536.48,"y":-45.61,"z":42.57},{"x":-53.01,"y":79.35,"z":71.62},{"x":581.16,"y":139.13,"z":99.48},{"x":814.39,"y":-93.48,"z":80.6},{"x":1106.93,"y":-355.03,"z":67.01},{"x":1070.71,"y":-780.46,"z":58.36},{"x":1142.82,"y":-986.58,"z":45.91},{"x":1200.55,"y":-1276.6,"z":35.23},{"x":967.81,"y":-1829.29,"z":31.24},{"x":809.16,"y":-2222.61,"z":29.65},{"x":684.61,"y":-2741.62,"z":6.02},{"x":263.47,"y":-2506.62,"z":6.45},{"x":94.66,"y":-2676.38,"z":6.01},{"x":-43.87,"y":-2519.91,"z":7.4},{"x":182.93,"y":-2027.68,"z":18.28},{"x":-306.86,"y":-2191.84,"z":10.84},{"x":-570.95,"y":-1775.95,"z":23.19},{"x":-350.03,"y":-1569.9,"z":25.23},{"x":-128.36,"y":-1394.12,"z":29.57},{"x":67.84,"y":-1399.02,"z":29.37},{"x":343.13,"y":-1297.91,"z":32.51},{"x":485.92,"y":-1477.41,"z":29.29},{"x":139.81,"y":-1337.41,"z":29.21},{"x":263.82,"y":-1346.16,"z":31.93},{"x":-723.33,"y":-1112.41,"z":10.66},{"x":-842.54,"y":-1128.21,"z":7.02},{"x":488.46,"y":-898.56,"z":25.94}]', 0),
	(11, 'Norte', 1, 1, 600, 2, 0, 'Norte', 'Always', '{"x":1727.77,"y":4505.08,"z":42.46}', '{"Name":"Lumberman","Amount":1}', '[{"Item":"lead_pure","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"copper_pure","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"gunpowder","Chance":50,"Min":1,"Max":5,"Price":0}]', '[{"x":-513.92,"y":-1019.31,"z":23.47},{"x":-1604.18,"y":-832.26,"z":10.08},{"x":-536.48,"y":-45.61,"z":42.57},{"x":-53.01,"y":79.35,"z":71.62},{"x":581.16,"y":139.13,"z":99.48},{"x":814.39,"y":-93.48,"z":80.6},{"x":1106.93,"y":-355.03,"z":67.01},{"x":1070.71,"y":-780.46,"z":58.36},{"x":1142.82,"y":-986.58,"z":45.91},{"x":1200.55,"y":-1276.6,"z":35.23},{"x":967.81,"y":-1829.29,"z":31.24},{"x":809.16,"y":-2222.61,"z":29.65},{"x":684.61,"y":-2741.62,"z":6.02},{"x":263.47,"y":-2506.62,"z":6.45},{"x":94.66,"y":-2676.38,"z":6.01},{"x":-43.87,"y":-2519.91,"z":7.4},{"x":182.93,"y":-2027.68,"z":18.28},{"x":-306.86,"y":-2191.84,"z":10.84},{"x":-570.95,"y":-1775.95,"z":23.19},{"x":-350.03,"y":-1569.9,"z":25.23},{"x":-128.36,"y":-1394.12,"z":29.57},{"x":67.84,"y":-1399.02,"z":29.37},{"x":343.13,"y":-1297.91,"z":32.51},{"x":485.92,"y":-1477.41,"z":29.29},{"x":139.81,"y":-1337.41,"z":29.21},{"x":263.82,"y":-1346.16,"z":31.93},{"x":-723.33,"y":-1112.41,"z":10.66},{"x":-842.54,"y":-1128.21,"z":7.02},{"x":488.46,"y":-898.56,"z":25.94}]', 0),
	(12, 'Corrego', 1, 1, 600, 2, 0, 'Corrego', 'Always', '{"x":1950.62,"y":713.78,"z":191.28}', '{"Name":"Lumberman","Amount":1}', '[{"Item":"lead_pure","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"copper_pure","Chance":50,"Min":1,"Max":5,"Price":0},{"Item":"gunpowder","Chance":50,"Min":1,"Max":5,"Price":0}]', '[{"x":-513.92,"y":-1019.31,"z":23.47},{"x":-1604.18,"y":-832.26,"z":10.08},{"x":-536.48,"y":-45.61,"z":42.57},{"x":-53.01,"y":79.35,"z":71.62},{"x":581.16,"y":139.13,"z":99.48},{"x":814.39,"y":-93.48,"z":80.6},{"x":1106.93,"y":-355.03,"z":67.01},{"x":1070.71,"y":-780.46,"z":58.36},{"x":1142.82,"y":-986.58,"z":45.91},{"x":1200.55,"y":-1276.6,"z":35.23},{"x":967.81,"y":-1829.29,"z":31.24},{"x":809.16,"y":-2222.61,"z":29.65},{"x":684.61,"y":-2741.62,"z":6.02},{"x":263.47,"y":-2506.62,"z":6.45},{"x":94.66,"y":-2676.38,"z":6.01},{"x":-43.87,"y":-2519.91,"z":7.4},{"x":182.93,"y":-2027.68,"z":18.28},{"x":-306.86,"y":-2191.84,"z":10.84},{"x":-570.95,"y":-1775.95,"z":23.19},{"x":-350.03,"y":-1569.9,"z":25.23},{"x":-128.36,"y":-1394.12,"z":29.57},{"x":67.84,"y":-1399.02,"z":29.37},{"x":343.13,"y":-1297.91,"z":32.51},{"x":485.92,"y":-1477.41,"z":29.29},{"x":139.81,"y":-1337.41,"z":29.21},{"x":263.82,"y":-1346.16,"z":31.93},{"x":-723.33,"y":-1112.41,"z":10.66},{"x":-842.54,"y":-1128.21,"z":7.02},{"x":488.46,"y":-898.56,"z":25.94}]', 0),
	(13, 'Lago', 1, 1, 600, 2, 0, 'Lago', 'Always', '{"x":188.66,"z":209.06,"y":697.01}', '{"Name":"Lumberman","Amount":1}', '[{"Price":0,"Chance":50,"Min":1,"Max":5,"Item":"electroniccomponents"},{"Price":0,"Chance":50,"Min":1,"Max":5,"Item":"batteryaaplus"},{"Price":0,"Chance":50,"Min":1,"Max":5,"Item":"sheetmetal"},{"Price":0,"Chance":50,"Min":1,"Max":5,"Item":"copper"},{"Price":0,"Chance":50,"Min":1,"Max":5,"Item":"aluminum"},{"Price":0,"Chance":50,"Min":1,"Max":1,"Item":"glass"},{"Price":0,"Chance":50,"Min":1,"Max":2,"Item":"saline"},{"Price":0,"Chance":50,"Min":1,"Max":5,"Item":"sulfuric"},{"Price":0,"Chance":50,"Min":1,"Max":5,"Item":"alcohol"}]', '[{"x":-513.92,"z":23.47,"y":-1019.31},{"x":-1604.18,"z":10.08,"y":-832.26},{"x":-536.48,"z":42.57,"y":-45.61},{"x":-53.01,"z":71.62,"y":79.35},{"x":581.16,"z":99.48,"y":139.13},{"x":814.39,"z":80.6,"y":-93.48},{"x":1106.93,"z":67.01,"y":-355.03},{"x":1070.71,"z":58.36,"y":-780.46},{"x":1142.82,"z":45.91,"y":-986.58},{"x":1200.55,"z":35.23,"y":-1276.6},{"x":967.81,"z":31.24,"y":-1829.29},{"x":809.16,"z":29.65,"y":-2222.61},{"x":684.61,"z":6.02,"y":-2741.62},{"x":263.47,"z":6.45,"y":-2506.62},{"x":94.66,"z":6.01,"y":-2676.38},{"x":-43.87,"z":7.4,"y":-2519.91},{"x":182.93,"z":18.28,"y":-2027.68},{"x":-306.86,"z":10.84,"y":-2191.84},{"x":-570.95,"z":23.19,"y":-1775.95},{"x":-350.03,"z":25.23,"y":-1569.9},{"x":-128.36,"z":29.57,"y":-1394.12},{"x":67.84,"z":29.37,"y":-1399.02},{"x":343.13,"z":32.51,"y":-1297.91},{"x":485.92,"z":29.29,"y":-1477.41},{"x":139.81,"z":29.21,"y":-1337.41},{"x":263.82,"z":31.93,"y":-1346.16},{"x":-723.33,"z":10.66,"y":-1112.41},{"x":-842.54,"z":7.02,"y":-1128.21},{"x":488.46,"z":25.94,"y":-898.56}]', 0),
	(14, 'Helipa', 1, 1, 600, 2, 0, 'Helipa', 'Always', '{"x":1305.9,"z":75.13,"y":-759.75}', '{"Name":"Lumberman","Amount":1}', '[{"Price":0,"Chance":50,"Min":1,"Max":5,"Item":"electroniccomponents"},{"Price":0,"Chance":50,"Min":1,"Max":5,"Item":"batteryaaplus"},{"Price":0,"Chance":50,"Min":1,"Max":5,"Item":"sheetmetal"},{"Price":0,"Chance":50,"Min":1,"Max":5,"Item":"copper"},{"Price":0,"Chance":50,"Min":1,"Max":5,"Item":"aluminum"},{"Price":0,"Chance":50,"Min":1,"Max":1,"Item":"glass"},{"Price":0,"Chance":50,"Min":1,"Max":2,"Item":"saline"},{"Price":0,"Chance":50,"Min":1,"Max":1,"Item":"sulfuric"},{"Price":0,"Chance":50,"Min":1,"Max":1,"Item":"alcohol"}]', '[{"x":-513.92,"z":23.47,"y":-1019.31},{"x":-1604.18,"z":10.08,"y":-832.26},{"x":-536.48,"z":42.57,"y":-45.61},{"x":-53.01,"z":71.62,"y":79.35},{"x":581.16,"z":99.48,"y":139.13},{"x":814.39,"z":80.6,"y":-93.48},{"x":1106.93,"z":67.01,"y":-355.03},{"x":1070.71,"z":58.36,"y":-780.46},{"x":1142.82,"z":45.91,"y":-986.58},{"x":1200.55,"z":35.23,"y":-1276.6},{"x":967.81,"z":31.24,"y":-1829.29},{"x":809.16,"z":29.65,"y":-2222.61},{"x":684.61,"z":6.02,"y":-2741.62},{"x":263.47,"z":6.45,"y":-2506.62},{"x":94.66,"z":6.01,"y":-2676.38},{"x":-43.87,"z":7.4,"y":-2519.91},{"x":182.93,"z":18.28,"y":-2027.68},{"x":-306.86,"z":10.84,"y":-2191.84},{"x":-570.95,"z":23.19,"y":-1775.95},{"x":-350.03,"z":25.23,"y":-1569.9},{"x":-128.36,"z":29.57,"y":-1394.12},{"x":67.84,"z":29.37,"y":-1399.02},{"x":343.13,"z":32.51,"y":-1297.91},{"x":485.92,"z":29.29,"y":-1477.41},{"x":139.81,"z":29.21,"y":-1337.41},{"x":263.82,"z":31.93,"y":-1346.16},{"x":-723.33,"z":10.66,"y":-1112.41},{"x":-842.54,"z":7.02,"y":-1128.21},{"x":488.46,"z":25.94,"y":-898.56}]', 0);

-- Copiando estrutura para tabela nightevolutiontp.safezones
CREATE TABLE IF NOT EXISTS `safezones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `points` longtext NOT NULL,
  `minZ` float DEFAULT NULL,
  `maxZ` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `safezones` (`id`, `Name`, `points`, `minZ`, `maxZ`) VALUES
	(1, 'Praca Central (Legion)', '[{"x":82.08,"y":-1122.75},{"x":79.52,"y":-1122.14},{"x":77.23,"y":-1119.89},{"x":76.29,"y":-1117.00},{"x":76.84,"y":-1111.80},{"x":79.84,"y":-1100.71},{"x":88.48,"y":-1078.39},{"x":103.6,"y":-1045.46},{"x":112.63,"y":-1023.3},{"x":160.21,"y":-892.64},{"x":162.80,"y":-887.15},{"x":168.32,"y":-879.56},{"x":174.47,"y":-867.66},{"x":183.88,"y":-843.83},{"x":186.26,"y":-840.89},{"x":191.49,"y":-840.09},{"x":260.51,"y":-865.31},{"x":263.73,"y":-867.77},{"x":265.97,"y":-872.41},{"x":265.69,"y":-877.52},{"x":201.08,"y":-1055.44},{"x":198.93,"y":-1065.38},{"x":197.91,"y":-1077.94},{"x":196.65,"y":-1108.07},{"x":195.70,"y":-1112.14},{"x":192.62,"y":-1117.41},{"x":187.76,"y":-1121.44},{"x":178.91,"y":-1123.74}]', 25, 45),
	(2, 'Ilha dos Banidos', '[{"x":5588.77,"y":13887.28},{"x":5477.89,"y":13777.98},{"x":5383.17,"y":13902.15},{"x":5480.4,"y":13984.92}]', 8.99, 33.99);

-- Copiando estrutura para tabela nightevolutiontp.shop_configs
CREATE TABLE IF NOT EXISTS `shop_configs` (
  `Mode` varchar(50) NOT NULL,
  `Action` varchar(50) NOT NULL DEFAULT 'Buy',
  `Type` varchar(50) NOT NULL DEFAULT 'Cash',
  `Item` varchar(50) DEFAULT NULL,
  `Permission` varchar(50) DEFAULT NULL,
  `List` longtext NOT NULL,
  PRIMARY KEY (`Mode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `shop_configs` (`Mode`, `Action`, `Type`, `Item`, `Permission`, `List`) VALUES
	('Ammunation', 'Buy', 'Cash', NULL, NULL, '{"WEAPON_BATTLEAXE":975,"WEAPON_KNUCKLE":975,"WEAPON_CROWBAR":975,"WEAPON_BAT":975,"WEAPON_WRENCH":975,"WEAPON_FLASHLIGHT":975,"WEAPON_STONE_HATCHET":975,"WEAPON_POOLCUE":975,"WEAPON_MACHETE":975,"WEAPON_HATCHET":975,"WEAPON_HAMMER":975,"WEAPON_GOLFCLUB":975,"WEAPON_SWITCHBLADE":975}'),
	('Banned', 'Buy', 'Gemstone', NULL, NULL, '{"banned_reduce":10}'),
	('Caminhoneiro', 'Sell', 'Cash', NULL, NULL, '{"glass":75,"copper":75,"plastic":75,"rubber":75,"aluminum":75}'),
	('Cemitery', 'Sell', 'Cash', NULL, NULL, '{"alliance":25,"treasurebox":200,"cellphone":50,"toothpaste":50,"horsefigurine":80,"meth":100,"cigarette":5,"gauze":25,"cocaine":100,"joint":100,"screws":5,"goldnecklace":150,"vape":200,"lockpick":45,"silverchain":125,"suitcase":150,"pager":20,"scotchtape":25,"insulatingtape":35,"lighter":100,"screwnuts":5}'),
	('Chihuahua', 'Buy', 'Cash', NULL, NULL, '{"hamburger":25,"cola":20,"hotdog":20,"soda":20,"water":35}'),
	('Cigarette', 'Buy', 'Cash', NULL, NULL, '{"cigarette":15,"lighter":225}'),
	('Coffee', 'Buy', 'Cash', NULL, NULL, '{"coffeecup":20}'),
	('Comida Paramedico', 'Buy', 'Cash', NULL, NULL, '{"water":100,"sandwich":125}'),
	('Departament', 'Buy', 'Cash', NULL, NULL, '{"condensedmilk":25,"postit":20,"lighter":225,"backpackm":250,"sugarbox":35,"energetic":225,"backpackp":125,"emptybottle":15,"backpackg":275,"ricebag":105,"cigarette":15,"ryebread":20,"mayonnaise":20}'),
	('Donut', 'Buy', 'Cash', NULL, NULL, '{"donut":15,"chocolate":20}'),
	('Eletronics', 'Buy', 'Cash', NULL, NULL, '{"cellphone":725,"drone":4000,"radio":975,"dronecontrol":1000,"binoculars":425,"vape":4750,"maquinadecartao":500,"camera":425}'),
	('Farmacia', 'Buy', 'Cash', NULL, NULL, '{"ritmoneury":350,"gdtkit":200,"gauze":300,"adrenaline":5000,"bandage":300,"medkit":599,"sinkalmy":250}'),
	('Fishing', 'Sell', 'Cash', NULL, NULL, '{"smalltrout":65,"salmon":125,"yellowperch":75,"orangeroughy":65,"sardine":65,"anchovy":70,"catfish":70,"smallshark":250,"herring":75}'),
	('Fishing 2', 'Buy', 'Cash', NULL, NULL, '{"bait":5,"fishingrod4":4200,"fishingrod3":3175,"fishingrod2":2150,"fishingrodplus":4225,"fishingrod":1125}'),
	('Hamburger', 'Buy', 'Cash', NULL, NULL, '{"hamburger":25}'),
	('Hotdog', 'Buy', 'Cash', NULL, NULL, '{"hotdog":20}'),
	('Hunting', 'Sell', 'Cash', NULL, NULL, '{"deer3star":325,"deer2star":300,"coyote2star":300,"meatfillet":100,"boar1star":275,"deer1star":275,"boar3star":325,"mtlion3star":325,"coyote3star":325,"boar2star":300,"mtlion1star":275,"coyote1star":275,"mtlion2star":300}'),
	('Hunting2', 'Buy', 'Cash', NULL, NULL, '{"WEAPON_SWITCHBLADE":975,"WEAPON_MUSKET":4225,"ration":125,"WEAPON_MUSKET_AMMO":10}'),
	('Lixeiro', 'Sell', 'Cash', NULL, NULL, '{"batteryaa":25,"scotchtape":25,"tarp":25,"copper":75,"plastic":75,"insulatingtape":35,"aluminum":75,"glass":75,"electroniccomponents":10,"sheetmetal":25,"techtrash":25,"emptybottle":5,"batteryaaplus":35,"rubber":75,"roadsigns":25}'),
	('Mecanica', 'Buy', 'Cash', NULL, 'Mecanicas', '{"tyres":50,"plate":100,"advtoolbox":100,"toolbox":50,"nitro":100}'),
	('Megamall', 'Buy', 'Cash', NULL, NULL, '{"WEAPON_ACIDPACKAGE":10,"bait":5,"rope":925,"WEAPON_SHOES":25,"tangeclone_0":3000,"bananaclone_0":3000,"coffeeclone_0":3000,"GADGET_PARACHUTE":225,"emptypurifiedwater":1275,"WEAPON_BRICK":25,"tomatoclone_0":3000,"notepad":10,"axe":1225,"passionclone_0":3000,"grapeclone_0":3000,"lemonclone_0":3000,"scuba":975,"fishingrod":1225,"suitcase":275,"acerolaclone_0":3000,"appleclone_0":3000,"orangeclone_0":3000,"alliance":525,"strawberryclone_0":3000,"blueberryclone_0":3000,"pickaxe":1225}'),
	('Mineração', 'Buy', 'Cash', NULL, NULL, '{"pickaxe":1500,"pickaxeplus":8000}'),
	('Mineração 2', 'Buy', 'Cash', NULL, NULL, '{"sapphire_pure":250,"copper_pure":125,"emerald_pure":275,"chalcopyrite":300,"diamond_pure":225,"lead_pure":100,"gold_pure":175,"tin_pure":75,"ruby_pure":200,"bauxite":325,"iron_pure":150}'),
	('Paramedico', 'Buy', 'Cash', NULL, 'Paramedico', '{"medkit":285,"syringe03":45,"adrenaline":3225,"syringe04":45,"analgesic":65,"medicbag":725,"gauze":75,"bandage":115,"ritmoneury":235,"sinkalmy":185,"syringe01":45,"gdtkit":25,"syringe02":45}'),
	('Penhores', 'Sell', 'Cash', NULL, NULL, '{"cellphone":50,"racesticket":50,"treasurebox":200,"promissory4000":4000,"weedclone_0":50,"promissory3000":3000,"soap":10,"saline":25,"scotchtape":25,"goldnecklace":150,"pickaxe":80,"promissory2000":2000,"smgbody":150,"lockpick":45,"medkit":150,"silverchain":125,"crack":100,"acetone":25,"ration":15,"tyres":80,"alliance":25,"glass":75,"alcohol":25,"rope":15,"processorfan":30,"ritmoneury":50,"camera":60,"handcuff":60,"bandage":15,"goldenjug":300,"cigarette":5,"plate":150,"cocaine":100,"sulfuric":25,"explosives":100,"insulatingtape":35,"riflebody":200,"screwnuts":5,"dismantle":50,"joint":100,"gauze":25,"toolbox":100,"copper":75,"woodlog":15,"screws":5,"platinum":250,"rubber":75,"promissory5000":5000,"amphetamine":100,"vape":200,"techtrash":25,"meth":100,"sheetmetal":25,"gunpowder":30,"goldenleopard":400,"metadone":120,"analgesic":30,"circuit":40,"codeine":80,"fishingrod":75,"binoculars":40,"powersupply":50,"promissory1000":1000,"processor":75,"aluminum":75,"radio":60,"lighter":100,"rammemory":40,"pistolbody":100,"adrenaline":150,"pager":20,"tarp":25,"hood":15,"roadsigns":25,"sinkalmy":50,"plastic":75,"pouch":5,"cokeclone_0":50,"goldenlion":500,"bait":5,"postit":5,"heroin":120,"repairkit01":150,"safependrive":150}'),
	('Pipa', 'Buy', 'Cash', NULL, NULL, '{"linha_fio24":3000,"pipa_murcha1":1000,"pipa_treme":1000,"pipa_murcha7":1000,"pipa_murcha5":1000,"linha_seda":4000,"pipa_murcha3":1000,"linha_cerol":5000,"pipa_murcha2":1000,"linha_fio10":2000,"pipa_careca":1000,"linha_chilena":6000,"pipa_murcha6":1000,"linha_comum":1000,"pipa_simples":1000,"pipa_cafifa":1000,"pipa_raiada":1000,"pipa_murcha4":1000}'),
	('Policia', 'Buy', 'Cash', NULL, 'Policia', '{"radio":10,"WEAPON_SMG_MK2":600,"WEAPON_SMG":600,"WEAPON_CARBINERIFLE_MK2":700,"ATTACH_GRIP":350,"WEAPON_NIGHTSTICK":250,"WEAPON_HEAVYRIFLE":700,"scuba":200,"cellphone":10,"WEAPON_STUNGUN":250,"WEAPON_PUMPSHOTGUN":700,"energetic":10,"ballisticplate":100,"ATTACH_SILENCER":350,"WEAPON_FLASHLIGHT":50,"WEAPON_SMG_AMMO":1,"WEAPON_COMBATPISTOL":500,"handcuff":125,"WEAPON_HEAVYPISTOL":500,"backpackg":275,"ATTACH_CROSSHAIR":350,"WEAPON_SMOKEGRENADE":50,"WEAPON_RIFLE_AMMO":1,"barrier":25,"gdtkit":25,"WEAPON_TACTICALRIFLE":700,"WEAPON_APPISTOL":500,"ATTACH_FLASHLIGHT":350,"gsrkit":25,"WEAPON_BULLPUPRIFLE":700,"WEAPON_CARBINERIFLE":700,"WEAPON_PISTOL_AMMO":1,"ATTACH_MAGAZINE":350,"spikestrips":275}'),
	('Rebocador', 'Sell', 'Cash', NULL, NULL, '{"glass":75,"copper":75,"plastic":75,"rubber":75,"aluminum":75}'),
	('Restaurantes', 'Buy', 'Cash', '', 'Restaurantes', '{"fishfillet":10,"ricebag":10,"sugarbox":10,"milkbottle":10,"chocolate":10,"apple":10,"meatfillet":10,"mayonnaise":10,"ryebread":10,"tomato":10,"banana":10,"potato":10,"sausage":10,"tortilla":10,"strawberry":10,"coffee":10,"passion":10,"tange":10,"orange":10,"grape":10,"lemon":10,"acerola":10,"blueberry":10,"emptybottle":10,"cherry":10,"flour":10,"chicken":10,"tealeaf":10,"watermelon":10,"kiwi":10,"peanut":10,"cinnamon":10,"pumpkin":10,"raspberry":10,"coconut":10,"avocado":10,"egg":10,"lettuce":10,"salt":10,"oliveoil":10,"starfruit":10,"peach":10}'),
	('Soda', 'Buy', 'Cash', NULL, NULL, '{"water":35,"soda":20,"cola":20}'),
	('Water', 'Buy', 'Cash', NULL, NULL, '{"water":35}');

-- Copiando estrutura para tabela nightevolutiontp.shops
CREATE TABLE IF NOT EXISTS `shops` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Mode` varchar(50) NOT NULL,
  `Type` varchar(50) NOT NULL DEFAULT 'Buy',
  `X` float NOT NULL DEFAULT 0,
  `Y` float NOT NULL DEFAULT 0,
  `Z` float NOT NULL DEFAULT 0,
  `Circle` float DEFAULT NULL,
  `Route` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `shops` (`id`, `Name`, `Mode`, `Type`, `X`, `Y`, `Z`, `Circle`, `Route`) VALUES
	(1, 'Banned #1', 'Banned', 'Buy', -1674.58, -3174.77, 13.99, NULL, 9999998),
	(2, 'Departament #2', 'Departament', 'Buy', 24.51, -1346.75, 29.49, NULL, NULL),
	(3, 'Departament #3', 'Departament', 'Buy', 2556.77, 380.87, 108.61, NULL, NULL),
	(4, 'Departament #4', 'Departament', 'Buy', 1164.81, -323.61, 69.2, NULL, NULL),
	(5, 'Departament #5', 'Departament', 'Buy', -706.16, -914.55, 19.21, NULL, NULL),
	(6, 'Departament #6', 'Departament', 'Buy', -47.35, -1758.59, 29.42, NULL, NULL),
	(7, 'Departament #7', 'Departament', 'Buy', 372.7, 326.89, 103.56, NULL, NULL),
	(8, 'Departament #8', 'Departament', 'Buy', -3242.7, 1000.05, 12.82, NULL, NULL),
	(9, 'Departament #9', 'Departament', 'Buy', 1728.08, 6415.6, 35.03, NULL, NULL),
	(10, 'Departament #10', 'Departament', 'Buy', 549.09, 2670.89, 42.16, NULL, NULL),
	(11, 'Departament #11', 'Departament', 'Buy', 1959.87, 3740.44, 32.33, NULL, NULL),
	(12, 'Departament #12', 'Departament', 'Buy', 2677.65, 3279.66, 55.23, NULL, NULL),
	(13, 'Departament #13', 'Departament', 'Buy', 1697.32, 4923.46, 42.06, NULL, NULL),
	(14, 'Departament #14', 'Departament', 'Buy', -1819.52, 793.48, 138.08, NULL, NULL),
	(15, 'Departament #15', 'Departament', 'Buy', 1391.62, 3605.95, 34.98, NULL, NULL),
	(16, 'Departament #16', 'Departament', 'Buy', -2966.41, 391.52, 15.05, NULL, NULL),
	(17, 'Departament #17', 'Departament', 'Buy', -3039.42, 584.42, 7.9, NULL, NULL),
	(18, 'Departament #18', 'Departament', 'Buy', 1134.32, -983.09, 46.4, NULL, NULL),
	(19, 'Departament #19', 'Departament', 'Buy', 1165.32, 2710.79, 38.15, NULL, NULL),
	(20, 'Departament #20', 'Departament', 'Buy', -1486.72, -377.61, 40.15, NULL, NULL),
	(21, 'Departament #21', 'Departament', 'Buy', -1221.48, -907.93, 12.32, NULL, NULL),
	(22, 'Fishing #22', 'Fishing', 'Buy', -1816.64, -1193.73, 14.31, NULL, NULL),
	(23, 'Hunting #23', 'Hunting', 'Buy', -695.67, 5802.27, 17.33, NULL, NULL),
	(24, 'Hunting2 #24', 'Hunting2', 'Buy', -679.14, 5834.37, 17.32, NULL, NULL),
	(25, 'Paramedico', 'Paramedico', 'Buy', -520.91, -587.2, 41.24, 1, NULL),
	(28, 'Eletronics #28', 'Eletronics', 'Buy', -1529.06, -400.97, 35.64, NULL, NULL),
	(30, 'Megamall #30', 'Megamall', 'Buy', 46.7, -1749.71, 29.62, NULL, NULL),
	(31, 'Ammunation #31', 'Ammunation', 'Buy', 1692.27, 3760.91, 34.69, NULL, NULL),
	(32, 'Ammunation #32', 'Ammunation', 'Buy', 253.8, -50.47, 69.94, NULL, NULL),
	(33, 'Ammunation #33', 'Ammunation', 'Buy', 842.54, -1035.25, 28.19, NULL, NULL),
	(34, 'Ammunation #34', 'Ammunation', 'Buy', -331.67, 6084.86, 31.46, NULL, NULL),
	(35, 'Ammunation #35', 'Ammunation', 'Buy', -662.37, -933.58, 21.82, NULL, NULL),
	(36, 'Ammunation #36', 'Ammunation', 'Buy', -1304.12, -394.56, 36.7, NULL, NULL),
	(37, 'Ammunation #37', 'Ammunation', 'Buy', -1118.98, 2699.73, 18.55, NULL, NULL),
	(38, 'Ammunation #38', 'Ammunation', 'Buy', 2567.98, 292.62, 108.73, NULL, NULL),
	(39, 'Ammunation #39', 'Ammunation', 'Buy', -3173.51, 1088.35, 20.84, NULL, NULL),
	(40, 'Ammunation #40', 'Ammunation', 'Buy', 22.53, -1105.52, 29.79, NULL, NULL),
	(41, 'Ammunation #41', 'Ammunation', 'Buy', 810.22, -2158.99, 29.62, NULL, NULL),
	(42, 'Dismantle #42', 'Dismantle', 'Buy', 2340.7, 3126.49, 48.21, NULL, NULL),
	(44, 'CatCafe', 'Restaurantes', 'Buy', -1552.88, -449.56, 36.2, 1, NULL),
	(45, 'MooMooCafe', 'Restaurantes', 'Buy', -586.73, -1055.16, 22.33, 1, NULL),
	(46, 'Redline', 'Mecanica', 'Buy', 1139.97, -780.21, 57.6, 1, NULL),
	(47, 'Redline 2', 'Mecanica', 'Buy', 1131.48, -780.17, 57.6, 1, NULL),
	(48, 'Redline 3', 'Mecanica', 'Buy', 1122.74, -780.17, 57.6, 1, NULL),
	(49, 'Bennys', 'Mecanica', 'Buy', -195.23, -1328.56, 31.98, 1, NULL),
	(50, 'Bennys 2', 'Mecanica', 'Buy', -195.2, -1336.25, 31.98, 1, NULL),
	(51, 'Bennys 3', 'Mecanica', 'Buy', -195.24, -1344.06, 31.98, 1, NULL),
	(52, 'Paramedico 2', 'Paramedico', 'Buy', -590.21, -591.7, 41.24, 1, NULL),
	(53, 'Comida Paramedico', 'Comida Paramedico', 'Buy', -533.32, -592.79, 34.64, 1.5, NULL),
	(54, 'Farmacia', 'Farmacia', 'Buy', -577.77, -592.58, 34.64, 1.5, NULL),
	(55, 'Policia', 'Policia', 'Buy', -1252.12, 332, 69.69, 1, NULL),
	(56, 'Fishing 2', 'Fishing 2', 'Buy', -1803.71, -1197.93, 13.02, 1, NULL),
	(57, 'Mineração', 'Mineração', 'Buy', 2964.37, 2752.93, 43.33, 1, NULL),
	(58, 'Mineração 2', 'Mineração 2', 'Sell', 2956.94, 2745.19, 43.53, 1, NULL),
	(59, 'Cemitery', 'Cemitery', 'Sell', -1734.72, -223.14, 56.09, 1, NULL),
	(60, 'Rebocador', 'Rebocador', 'Buy', 410.79, -1620.58, 29.29, 1, NULL),
	(61, 'Caminhoneiro', 'Caminhoneiro', 'Buy', 1240.5, -3266.15, 5.53, 1, NULL),
	(62, 'Lixeiro', 'Lixeiro', 'Sell', -350.09, -1570.03, 25.22, 1, NULL),
	(63, 'Penhores', 'Penhores', 'Sell', -782.17, -608.88, 30.28, 1, NULL),
	(64, 'Pipa', 'Pipa', 'Buy', 199.89, -985.76, 30.09, 1, NULL),
	(65, 'Ammu-Nation do Spawn', 'Ammunation', 'Buy', -1032.68, -2814.51, 21.36, 2, NULL),
	(66, 'Loja de Departamento do Spawn', 'Departament', 'Buy', -1092.9, -2736.27, 21.36, 2, NULL);

-- Copiando estrutura para tabela nightevolutiontp.skinshop
CREATE TABLE IF NOT EXISTS `skinshop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `X` float DEFAULT NULL,
  `Y` float DEFAULT NULL,
  `Z` float DEFAULT NULL,
  `Permission` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `skinshop` (`id`, `X`, `Y`, `Z`, `Permission`) VALUES
	(1, 71.29, -1398.68, 29.37, NULL),
	(2, -708.56, -160.5, 37.41, NULL),
	(3, -158.76, -296.94, 39.73, NULL),
	(4, -829.08, -1073.27, 11.32, NULL),
	(5, -1192.23, -771.74, 17.32, NULL),
	(6, -1456.98, -241.17, 49.81, NULL),
	(7, 11.87, 6513.59, 31.88, NULL),
	(8, 1696.92, 4829.24, 42.06, NULL),
	(9, 122.93, -221.48, 54.56, NULL),
	(10, 617.77, 2761.81, 42.09, NULL),
	(11, 1190.79, 2714.29, 38.22, NULL),
	(12, -3173.28, 1046.04, 20.86, NULL),
	(13, -1108.61, 2709.59, 19.11, NULL),
	(14, 429.67, -800.14, 29.49, NULL),
	(15, 480.78, -1009.08, 30.68, NULL),
	(16, 474.41, -992.92, 30.68, NULL),
	(17, -1040.81, -2834.2, 21.36, ''),
	(19, -1055.13, -2858.96, 21.36, '');

-- Copiando estrutura para tabela nightevolutiontp.tattooshop
CREATE TABLE IF NOT EXISTS `tattooshop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `X` float DEFAULT NULL,
  `Y` float DEFAULT NULL,
  `Z` float DEFAULT NULL,
  `Permission` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tattooshop` (`id`, `X`, `Y`, `Z`, `Permission`) VALUES
	(1, 1321.46, -1653.91, 52.27, NULL),
	(2, -1155.66, -1427.18, 4.95, NULL),
	(4, -3169.29, 1077.59, 20.83, NULL),
	(5, 1864.45, 3746.73, 33.03, NULL),
	(6, -294.34, 6200.93, 31.48, NULL),
	(8, 324.12, 180.33, 103.59, ''),
	(9, -1115.69, -2791.12, 21.36, ''),
	(10, -1107.39, -2777.62, 21.36, '');

-- Copiando estrutura para tabela nightevolutiontp.taxes
CREATE TABLE IF NOT EXISTS `taxes` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Name` varchar(50) NOT NULL,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Price` bigint(19) NOT NULL,
  `Description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.tickets_creative
CREATE TABLE IF NOT EXISTS `tickets_creative` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Subject` varchar(255) NOT NULL DEFAULT '',
  `Category` varchar(100) NOT NULL DEFAULT '',
  `Assumed` bigint(19) DEFAULT NULL,
  `Status` tinyint(1) NOT NULL DEFAULT 1,
  `CreatedAt` bigint(19) DEFAULT NULL,
  `ClosedAt` bigint(19) DEFAULT NULL,
  `Author` bigint(19) NOT NULL DEFAULT 0,
  `Members` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.tickets_creative_messages
CREATE TABLE IF NOT EXISTS `tickets_creative_messages` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Ticket` bigint(19) NOT NULL DEFAULT 0,
  `Type` varchar(100) NOT NULL DEFAULT 'User',
  `Author` bigint(19) DEFAULT NULL,
  `Staff` tinyint(1) NOT NULL DEFAULT 0,
  `Message` longtext DEFAULT NULL,
  `CreatedAt` bigint(19) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `FK_tickets_creative_messages_tickets_creative` (`Ticket`),
  CONSTRAINT `FK_tickets_creative_messages_tickets_creative` FOREIGN KEY (`Ticket`) REFERENCES `tickets_creative` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.totem
CREATE TABLE IF NOT EXISTS `totem` (
  `totem_id` varchar(100) NOT NULL,
  `data` longtext NOT NULL,
  PRIMARY KEY (`totem_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `totem` (`totem_id`, `data`) VALUES
	('night_totem:CatCafe', '{"revenue":0,"totalSales":0,"items":{"cupcake":{"price":150,"stock":25},"COMBOMMIAW":{"price":150,"stock":25},"leitecomcanela":{"price":150,"stock":25},"leitedebanana":{"price":150,"stock":25},"COMBOPFELINO":{"price":150,"stock":25},"sushi":{"price":150,"stock":25},"COMBOFLAMINGOSUPREMO":{"price":150,"stock":25},"COMBOTROPICALIA":{"price":150,"stock":25},"mlkmorango":{"price":150,"stock":25},"combo3":{"price":150,"stock":25},"strawberryjuice":{"price":150,"stock":25},"marshmellow":{"price":150,"stock":25},"COMBOSUNSET":{"price":150,"stock":25},"sucodeuva":{"price":150,"stock":25},"cappuccino":{"price":150,"stock":25},"melancia":{"price":150,"stock":25},"sucodemorango":{"price":150,"stock":25},"mamadeira":{"price":150,"stock":25},"morangoepesego":{"price":150,"stock":25},"bolodemorango":{"price":150,"stock":25},"bifeepao":{"price":150,"stock":25},"chaverde":{"price":150,"stock":25},"hotdog":{"price":150,"stock":25},"acerolajuice":{"price":150,"stock":25},"grapejuice":{"price":150,"stock":25},"lemonjuice":{"price":150,"stock":25},"COMBOBABYCAT":{"price":150,"stock":25},"caviarvermelho":{"price":150,"stock":25},"wafflesgelado":{"price":150,"stock":25},"peixebatata":{"price":150,"stock":25},"fries":{"price":150,"stock":25},"sandwich":{"price":150,"stock":25},"tangejuice":{"price":150,"stock":25},"pizzachocolate":{"price":150,"stock":25},"cupcakededefranboesa":{"price":150,"stock":25},"bananajuice":{"price":150,"stock":25},"orangejuice":{"price":150,"stock":25},"tortadeamendoim":{"price":150,"stock":25},"leitedecoco":{"price":150,"stock":25},"COMBOGGARFIELD":{"price":150,"stock":25},"chocolatecremoso":{"price":150,"stock":25},"coffeemilk":{"price":150,"stock":25},"pizzamozzarella":{"price":150,"stock":25},"cafe":{"price":150,"stock":25},"milkcereja":{"price":150,"stock":25},"coelhodechocolate":{"price":150,"stock":25},"iogurtedemaca":{"price":150,"stock":25},"COMBOTROPICAL":{"price":150,"stock":25},"sorvete2":{"price":150,"stock":25},"passionjuice":{"price":150,"stock":25},"cupcakerecheado":{"price":150,"stock":25},"sorvete":{"price":150,"stock":25},"coquetelcarambola":{"price":150,"stock":25},"applejuice":{"price":150,"stock":25},"pirulito":{"price":150,"stock":25},"donut":{"price":150,"stock":25},"iogurtemorango":{"price":150,"stock":25},"milkshake":{"price":150,"stock":25},"pizzabanana":{"price":150,"stock":25},"catpanqueca":{"price":150,"stock":25},"ursoburger":{"price":150,"stock":25},"COMBOPATINHAS":{"price":150,"stock":25},"bolococo":{"price":150,"stock":25},"sucodelaranja":{"price":150,"stock":25},"limonada":{"price":150,"stock":25},"water":{"price":150,"stock":25},"abacateovos":{"price":150,"stock":25},"nigirizushi":{"price":150,"stock":25},"pudimdeuva":{"price":150,"stock":25},"sucodekiwi":{"price":150,"stock":25},"eggsbenedict":{"price":150,"stock":25},"COMBOMARECLASSICA":{"price":150,"stock":25},"applelove":{"price":150,"stock":25},"sucodefrutas":{"price":150,"stock":25},"combo1":{"price":150,"stock":25},"cereal":{"price":150,"stock":25},"blueberryjuice":{"price":150,"stock":25},"milkfrutos":{"price":150,"stock":25},"uvalimao":{"price":150,"stock":25},"catburger":{"price":150,"stock":25},"rocambolemorango":{"price":150,"stock":25},"churros":{"price":150,"stock":25},"capuccino":{"price":150,"stock":25},"cupcakedemorango":{"price":150,"stock":25},"cookies":{"price":150,"stock":25},"cupcakedeabobora":{"price":150,"stock":25},"supermilkshakechocolate":{"price":150,"stock":25},"coxinha":{"price":150,"stock":25},"tacos":{"price":150,"stock":25},"salada":{"price":150,"stock":25},"supermilkshakerosa":{"price":150,"stock":25},"salmaomolho":{"price":150,"stock":25},"leitedechocolate":{"price":150,"stock":25},"sucodemaca":{"price":150,"stock":25},"milkuwu":{"price":150,"stock":25},"hamburger2":{"price":150,"stock":25},"hamburger3":{"price":150,"stock":25},"milkchocolate":{"price":150,"stock":25},"daiquiridemorango":{"price":150,"stock":25},"purebatata":{"price":150,"stock":25},"coquetellaranjaelimao":{"price":150,"stock":25},"torrada":{"price":150,"stock":25},"morangoemanga":{"price":150,"stock":25},"cupcakedelaranja":{"price":150,"stock":25},"bolinhodecereja":{"price":150,"stock":25},"sucodelimao":{"price":150,"stock":25},"leitedemorango":{"price":150,"stock":25},"bolocarne":{"price":150,"stock":25},"combo2":{"price":150,"stock":25},"bibimbap":{"price":150,"stock":25},"mangaelimao":{"price":150,"stock":25}}}'),
	('night_totem:MooMooCafe', '{"revenue":0,"totalSales":0,"items":{"cupcake":{"price":150,"stock":25},"COMBOMMIAW":{"price":150,"stock":25},"leitecomcanela":{"price":150,"stock":25},"leitedebanana":{"price":150,"stock":25},"COMBOPFELINO":{"price":150,"stock":25},"sushi":{"price":150,"stock":25},"COMBOFLAMINGOSUPREMO":{"price":150,"stock":25},"COMBOTROPICALIA":{"price":150,"stock":25},"mlkmorango":{"price":150,"stock":25},"combo3":{"price":150,"stock":25},"strawberryjuice":{"price":150,"stock":25},"marshmellow":{"price":150,"stock":25},"COMBOSUNSET":{"price":150,"stock":25},"sucodeuva":{"price":150,"stock":25},"cappuccino":{"price":150,"stock":25},"melancia":{"price":150,"stock":25},"sucodemorango":{"price":150,"stock":25},"mamadeira":{"price":150,"stock":25},"morangoepesego":{"price":150,"stock":25},"bolodemorango":{"price":150,"stock":25},"bifeepao":{"price":150,"stock":25},"chaverde":{"price":150,"stock":25},"hotdog":{"price":150,"stock":25},"acerolajuice":{"price":150,"stock":25},"grapejuice":{"price":150,"stock":25},"lemonjuice":{"price":150,"stock":25},"COMBOBABYCAT":{"price":150,"stock":25},"caviarvermelho":{"price":150,"stock":25},"wafflesgelado":{"price":150,"stock":25},"peixebatata":{"price":150,"stock":25},"fries":{"price":150,"stock":25},"sandwich":{"price":150,"stock":25},"tangejuice":{"price":150,"stock":25},"pizzachocolate":{"price":150,"stock":25},"cupcakededefranboesa":{"price":150,"stock":25},"bananajuice":{"price":150,"stock":25},"orangejuice":{"price":150,"stock":25},"tortadeamendoim":{"price":150,"stock":25},"leitedecoco":{"price":150,"stock":25},"COMBOGGARFIELD":{"price":150,"stock":25},"chocolatecremoso":{"price":150,"stock":25},"coffeemilk":{"price":150,"stock":25},"pizzamozzarella":{"price":150,"stock":25},"cafe":{"price":150,"stock":25},"milkcereja":{"price":150,"stock":25},"coelhodechocolate":{"price":150,"stock":25},"iogurtedemaca":{"price":150,"stock":25},"COMBOTROPICAL":{"price":150,"stock":25},"sorvete2":{"price":150,"stock":25},"passionjuice":{"price":150,"stock":25},"cupcakerecheado":{"price":150,"stock":25},"sorvete":{"price":150,"stock":25},"coquetelcarambola":{"price":150,"stock":25},"applejuice":{"price":150,"stock":25},"pirulito":{"price":150,"stock":25},"donut":{"price":150,"stock":25},"iogurtemorango":{"price":150,"stock":25},"milkshake":{"price":150,"stock":25},"pizzabanana":{"price":150,"stock":25},"catpanqueca":{"price":150,"stock":25},"ursoburger":{"price":150,"stock":25},"COMBOPATINHAS":{"price":150,"stock":25},"bolococo":{"price":150,"stock":25},"sucodelaranja":{"price":150,"stock":25},"limonada":{"price":150,"stock":25},"water":{"price":150,"stock":25},"abacateovos":{"price":150,"stock":25},"nigirizushi":{"price":150,"stock":25},"pudimdeuva":{"price":150,"stock":25},"sucodekiwi":{"price":150,"stock":25},"eggsbenedict":{"price":150,"stock":25},"COMBOMARECLASSICA":{"price":150,"stock":25},"applelove":{"price":150,"stock":25},"sucodefrutas":{"price":150,"stock":25},"combo1":{"price":150,"stock":25},"cereal":{"price":150,"stock":25},"blueberryjuice":{"price":150,"stock":25},"milkfrutos":{"price":150,"stock":25},"uvalimao":{"price":150,"stock":25},"catburger":{"price":150,"stock":25},"rocambolemorango":{"price":150,"stock":25},"churros":{"price":150,"stock":25},"capuccino":{"price":150,"stock":25},"cupcakedemorango":{"price":150,"stock":25},"cookies":{"price":150,"stock":25},"cupcakedeabobora":{"price":150,"stock":25},"supermilkshakechocolate":{"price":150,"stock":25},"coxinha":{"price":150,"stock":25},"tacos":{"price":150,"stock":25},"salada":{"price":150,"stock":25},"supermilkshakerosa":{"price":150,"stock":25},"salmaomolho":{"price":150,"stock":25},"leitedechocolate":{"price":150,"stock":25},"sucodemaca":{"price":150,"stock":25},"milkuwu":{"price":150,"stock":25},"hamburger2":{"price":150,"stock":25},"hamburger3":{"price":150,"stock":25},"milkchocolate":{"price":150,"stock":25},"daiquiridemorango":{"price":150,"stock":25},"purebatata":{"price":150,"stock":25},"coquetellaranjaelimao":{"price":150,"stock":25},"torrada":{"price":150,"stock":25},"morangoemanga":{"price":150,"stock":25},"cupcakedelaranja":{"price":150,"stock":25},"bolinhodecereja":{"price":150,"stock":25},"sucodelimao":{"price":150,"stock":25},"leitedemorango":{"price":150,"stock":25},"bolocarne":{"price":150,"stock":25},"combo2":{"price":150,"stock":25},"bibimbap":{"price":150,"stock":25},"mangaelimao":{"price":150,"stock":25}}}');

-- Copiando estrutura para tabela nightevolutiontp.trail
CREATE TABLE IF NOT EXISTS `trail` (
  `passport` int(11) NOT NULL,
  `setting_key` varchar(64) NOT NULL,
  `setting_value` longtext DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`passport`,`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.transactions
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Type` varchar(50) NOT NULL,
  `Price` bigint(19) NOT NULL DEFAULT 0,
  `Timestamp` bigint(19) NOT NULL DEFAULT 0,
  `Reference` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Vehicle` varchar(100) DEFAULT NULL,
  `Tax` bigint(19) NOT NULL DEFAULT 0,
  `Plate` varchar(10) DEFAULT NULL,
  `Weight` bigint(19) NOT NULL DEFAULT 0,
  `Save` varchar(50) NOT NULL DEFAULT '1',
  `Rental` bigint(19) NOT NULL DEFAULT 0,
  `Arrest` tinyint(1) NOT NULL DEFAULT 0,
  `Block` tinyint(1) NOT NULL DEFAULT 0,
  `Engine` int(4) NOT NULL DEFAULT 1000,
  `Body` int(4) NOT NULL DEFAULT 1000,
  `Health` int(4) NOT NULL DEFAULT 1000,
  `Fuel` int(3) NOT NULL DEFAULT 100,
  `Nitro` int(5) NOT NULL DEFAULT 0,
  `Work` tinyint(1) NOT NULL DEFAULT 0,
  `Doors` longtext DEFAULT NULL,
  `Windows` longtext DEFAULT NULL,
  `Tyres` longtext DEFAULT NULL,
  `Seatbelt` tinyint(1) NOT NULL DEFAULT 0,
  `Drift` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `Vehicle` (`Vehicle`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para tabela nightevolutiontp.weazel
CREATE TABLE IF NOT EXISTS `weazel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` longtext NOT NULL,
  `description` longtext NOT NULL,
  `author` varchar(255) NOT NULL,
  `video` longtext NOT NULL,
  `img` longtext NOT NULL,
  `visualizations` int(11) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  `category` varchar(60) NOT NULL DEFAULT 'Notícia',
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Copiando estrutura para trigger nightevolutiontp.phone_instagram_decrement_comment_count
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_instagram_decrement_comment_count
AFTER DELETE ON phone_instagram_comments
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_posts
    SET comment_count = comment_count - 1
    WHERE id = OLD.post_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_instagram_decrement_like_count
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_instagram_decrement_like_count
AFTER DELETE ON phone_instagram_likes
FOR EACH ROW
BEGIN
    IF OLD.is_comment = 0 THEN
        UPDATE phone_instagram_posts
        SET like_count = like_count - 1
        WHERE id = OLD.id;
    ELSE
        UPDATE phone_instagram_comments
        SET like_count = like_count - 1
        WHERE id = OLD.id;
    END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_instagram_decrement_post_count
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_instagram_decrement_post_count
AFTER DELETE ON phone_instagram_posts
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_accounts
    SET post_count = post_count - 1
    WHERE username = OLD.username;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_instagram_decrement_story_count
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_instagram_decrement_story_count
AFTER DELETE ON phone_instagram_stories
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_accounts
    SET story_count = story_count - 1
    WHERE username = OLD.username;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_instagram_increment_comment_count
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_instagram_increment_comment_count
AFTER INSERT ON phone_instagram_comments
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_posts
    SET comment_count = comment_count + 1
    WHERE id = NEW.post_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_instagram_increment_like_count
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_instagram_increment_like_count
AFTER INSERT ON phone_instagram_likes
FOR EACH ROW
BEGIN
    IF NEW.is_comment = 0 THEN
        UPDATE phone_instagram_posts
        SET like_count = like_count + 1
        WHERE id = NEW.id;
    ELSE
        UPDATE phone_instagram_comments
        SET like_count = like_count + 1
        WHERE id = NEW.id;
    END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_instagram_increment_post_count
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_instagram_increment_post_count
AFTER INSERT ON phone_instagram_posts
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_accounts
    SET post_count = post_count + 1
    WHERE username = NEW.username;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_instagram_increment_story_count
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_instagram_increment_story_count
AFTER INSERT ON phone_instagram_stories
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_accounts
    SET story_count = story_count + 1
    WHERE username = NEW.username;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_instagram_update_counts_after_follow
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_instagram_update_counts_after_follow
AFTER INSERT ON phone_instagram_follows
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_accounts
    SET follower_count = follower_count + 1
    WHERE username = NEW.followed;

    UPDATE phone_instagram_accounts
    SET following_count = following_count + 1
    WHERE username = NEW.follower;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_instagram_update_counts_after_unfollow
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_instagram_update_counts_after_unfollow
AFTER DELETE ON phone_instagram_follows
FOR EACH ROW
BEGIN
    UPDATE phone_instagram_accounts
    SET follower_count = follower_count - 1
    WHERE username = OLD.followed;

    UPDATE phone_instagram_accounts
    SET following_count = following_count - 1
    WHERE username = OLD.follower;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_decrement_account_likes
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_decrement_account_likes
AFTER DELETE ON phone_tiktok_likes
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_accounts
    JOIN phone_tiktok_videos ON phone_tiktok_videos.username = phone_tiktok_accounts.username
    SET phone_tiktok_accounts.like_count = phone_tiktok_accounts.like_count - 1
    WHERE phone_tiktok_videos.id = OLD.video_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_decrement_comment_likes
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_decrement_comment_likes
AFTER DELETE ON phone_tiktok_comments_likes
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_comments
    SET likes = likes - 1
    WHERE id = OLD.comment_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_decrement_video_comments
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_decrement_video_comments
BEFORE DELETE ON phone_tiktok_comments
FOR EACH ROW
BEGIN
    DECLARE v_replies_count INT;

    -- Count the replies for the comment
    SELECT COUNT(*) INTO v_replies_count
    FROM phone_tiktok_comments
    WHERE reply_to = OLD.id;

    -- Update the video's comments count
    UPDATE phone_tiktok_videos
    SET comments = comments - (1 + v_replies_count)
    WHERE id = OLD.video_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_decrement_video_likes
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_decrement_video_likes
AFTER DELETE ON phone_tiktok_likes
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_videos
    SET likes = likes - 1
    WHERE id = OLD.video_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_decrement_video_saves
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_decrement_video_saves
AFTER DELETE ON phone_tiktok_saves
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_videos
    SET saves = saves - 1
    WHERE id = OLD.video_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_increment_account_likes
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_account_likes
AFTER INSERT ON phone_tiktok_likes
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_accounts
    JOIN phone_tiktok_videos ON phone_tiktok_videos.username = phone_tiktok_accounts.username
    SET phone_tiktok_accounts.like_count = phone_tiktok_accounts.like_count + 1
    WHERE phone_tiktok_videos.id = NEW.video_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_increment_comment_likes
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_comment_likes
AFTER INSERT ON phone_tiktok_comments_likes
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_comments
    SET likes = likes + 1
    WHERE id = NEW.comment_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_increment_video_comments
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_video_comments
AFTER INSERT ON phone_tiktok_comments
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_videos
    SET comments = comments + 1
    WHERE id = NEW.video_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_increment_video_count
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_video_count
AFTER INSERT ON phone_tiktok_videos
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_accounts
    SET video_count = video_count + 1
    WHERE username = NEW.username;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_increment_video_likes
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_video_likes
AFTER INSERT ON phone_tiktok_likes
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_videos
    SET likes = likes + 1
    WHERE id = NEW.video_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_increment_video_saves
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_video_saves
AFTER INSERT ON phone_tiktok_saves
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_videos
    SET saves = saves + 1
    WHERE id = NEW.video_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_increment_video_views
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_increment_video_views
AFTER INSERT ON phone_tiktok_views
FOR EACH ROW
BEGIN
    UPDATE phone_tiktok_videos
    SET views = views + 1
    WHERE id = NEW.video_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_update_counts_after_follow
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_update_counts_after_follow
AFTER INSERT ON phone_tiktok_follows
FOR EACH ROW
BEGIN
    -- Increment the follower_count for the followed user
    UPDATE phone_tiktok_accounts
    SET follower_count = follower_count + 1
    WHERE username = NEW.followed;

    -- Increment the following_count for the follower user
    UPDATE phone_tiktok_accounts
    SET following_count = following_count + 1
    WHERE username = NEW.follower;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_update_counts_after_unfollow
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_update_counts_after_unfollow
AFTER DELETE ON phone_tiktok_follows
FOR EACH ROW
BEGIN
    -- Decrement the follower_count for the followed user
    UPDATE phone_tiktok_accounts
    SET follower_count = follower_count - 1
    WHERE username = OLD.followed;

    -- Decrement the following_count for the follower user
    UPDATE phone_tiktok_accounts
    SET following_count = following_count - 1
    WHERE username = OLD.follower;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_tiktok_update_last_message
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_tiktok_update_last_message
AFTER INSERT ON phone_tiktok_messages
FOR EACH ROW
BEGIN
    DECLARE modified_content TEXT CHARACTER SET utf8mb4;

    IF NEW.content LIKE '<!SHARED-VIDEO-URL%' THEN
        SET modified_content = 'Shared a video';
    ELSEIF LENGTH(NEW.content) > 50 THEN
        SET modified_content = CONCAT(SUBSTR(NEW.content, 1, 17), '...');
    ELSE
        SET modified_content = NEW.content;
    END IF;

    UPDATE phone_tiktok_channels
    SET last_message = modified_content
    WHERE id = NEW.channel_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_twitter_update_counts_after_follow
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_twitter_update_counts_after_follow
AFTER INSERT ON phone_twitter_follows
FOR EACH ROW
BEGIN
    -- Increment the follower_count for the followed user
    UPDATE phone_twitter_accounts
    SET follower_count = follower_count + 1
    WHERE username = NEW.followed;

    -- Increment the following_count for the follower user
    UPDATE phone_twitter_accounts
    SET following_count = following_count + 1
    WHERE username = NEW.follower;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_twitter_update_counts_after_unfollow
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_twitter_update_counts_after_unfollow
AFTER DELETE ON phone_twitter_follows
FOR EACH ROW
BEGIN
    -- Decrement the follower_count for the followed user
    UPDATE phone_twitter_accounts
    SET follower_count = follower_count - 1
    WHERE username = OLD.followed;

    -- Decrement the following_count for the follower user
    UPDATE phone_twitter_accounts
    SET following_count = following_count - 1
    WHERE username = OLD.follower;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_twitter_update_like_count_after_like
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_twitter_update_like_count_after_like
AFTER INSERT ON phone_twitter_likes
FOR EACH ROW
BEGIN
    UPDATE phone_twitter_tweets
    SET like_count = like_count + 1
    WHERE id = NEW.tweet_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_twitter_update_like_count_after_unlike
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_twitter_update_like_count_after_unlike
AFTER DELETE ON phone_twitter_likes
FOR EACH ROW
BEGIN
    UPDATE phone_twitter_tweets
    SET like_count = like_count - 1
    WHERE id = OLD.tweet_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_twitter_update_retweet_count_after_retweet
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_twitter_update_retweet_count_after_retweet
AFTER INSERT ON phone_twitter_retweets
FOR EACH ROW
BEGIN
    UPDATE phone_twitter_tweets
    SET retweet_count = retweet_count + 1
    WHERE id = NEW.tweet_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger nightevolutiontp.phone_twitter_update_retweet_count_after_unretweet
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS phone_twitter_update_retweet_count_after_unretweet
AFTER DELETE ON phone_twitter_retweets
FOR EACH ROW
BEGIN
    UPDATE phone_twitter_tweets
    SET retweet_count = retweet_count - 1
    WHERE id = OLD.tweet_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

CREATE TABLE IF NOT EXISTS `coupons_creative` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Coupon` varchar(100) NOT NULL DEFAULT '',
  `Multiplier` FLOAT(10,2) NOT NULL DEFAULT 1.00,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `poll_creative` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `Question` varchar(255) NOT NULL DEFAULT '',
  `Code` varchar(100) NOT NULL DEFAULT '',
  `Passport` bigint(19) NOT NULL DEFAULT 0,
  `Answer` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `services` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `Permission` VARCHAR(100) NOT NULL,
  `X` FLOAT NOT NULL,
  `Y` FLOAT NOT NULL,
  `Z` FLOAT NOT NULL,
  `Distance` FLOAT NOT NULL DEFAULT 1.5,
  `Weight` FLOAT NOT NULL DEFAULT 1.0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `services` (`Permission`, `X`, `Y`, `Z`, `Distance`, `Weight`) VALUES
('CatCafe', -1551.92, -455.09, 36.19, 1.5, 1.0),
('MooMooCafe', -589.08, -1061.78, 26.39, 1.5, 1.0),
('Redline', 1160.77, -784.08, 57.59, 1.5, 1.0),
('Bennys', -194.38, -1316.82, 31.98, 1.5, 1.0),
('Paramedico', -555.58, -582.48, 34.64, 1.5, 1.0),
('Policia', -1264.5, 336.88, 66.49, 1.5, 1.0);

CREATE TABLE IF NOT EXISTS `groups` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `label` VARCHAR(100) DEFAULT NULL,
    `permissions` TEXT DEFAULT NULL,
    `hierarchy` TEXT DEFAULT NULL,
    `salary` TEXT DEFAULT NULL,
    `backpack` INT(11) DEFAULT 0,
    `type` VARCHAR(50) DEFAULT 'Work',
    `service` TINYINT(1) DEFAULT 1,
    `rejoin_service` TINYINT(1) DEFAULT 1,
    `chat` TINYINT(1) DEFAULT 0,
    `banned` TINYINT(1) DEFAULT 0,
    `markers` INT(11) DEFAULT NULL,
    `security_cam` TINYINT(1) DEFAULT 0,
    `domination` TINYINT(1) DEFAULT 0,
    `chest` TINYINT(1) DEFAULT 0,
    `block` TINYINT(1) DEFAULT 0,
    `max_members` INT(11) DEFAULT NULL,
    `data` LONGTEXT NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Admin', 'Adminstradores', '["Admin"]', '["Administrador","Diretor","Moderador","Suporte","Ajudante"]', '[]', 0, 'UnWorked', 1, 1, 1, 0, NULL, 0, 0, 0, 0, 30, '{"Permission":{"Admin":true},"Hierarchy":["Administrador","Diretor","Moderador","Suporte","Ajudante"],"Name":"Adminstradores","Service":true,"RejoinService":true,"Chat":true,"Max":30}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Ouro', 'Ouro', '["Ouro"]', '["Membro"]', '[3750]', 25, 'UnWorked', 1, 1, 0, 0, NULL, 0, 0, 0, 1, NULL, '{"Permission":{"Ouro":true},"Hierarchy":["Membro"],"Salary":[3750],"Service":true,"RejoinService":true,"Block":true,"Backpack":[25]}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Prata', 'Prata', '["Prata"]', '["Membro"]', '[2500]', 15, 'UnWorked', 1, 1, 0, 0, NULL, 0, 0, 0, 1, NULL, '{"Permission":{"Prata":true},"Hierarchy":["Membro"],"Salary":[2500],"Service":true,"RejoinService":true,"Block":true,"Backpack":[15]}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Bronze', 'Bronze', '["Bronze"]', '["Membro"]', '[1250]', 5, 'UnWorked', 1, 1, 0, 0, NULL, 0, 0, 0, 1, NULL, '{"Permission":{"Bronze":true},"Hierarchy":["Membro"],"Salary":[1250],"Service":true,"RejoinService":true,"Block":true,"Backpack":[5]}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Policias', 'Policias', '["Policia"]', '["Membro"]', '[]', 0, 'UnWorked', 0, 1, 0, 0, NULL, 0, 0, 0, 1, NULL, '{"Permission":{"Policia":true},"Hierarchy":["Membro"],"Block":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Policia', 'Policia', '["Policia"]', '["Coronel","Tenente-Coronel","Major","Capitão","1º Tenente","2º Tenente","Aspirante","Subtenente","1º Sargento","2º Sargento","3º Sargento","Cabo","Soldado","Recruta","Delegada"]', '[10000,9750,9500,9250,9000,8750,8500,8250,8000,7750,7500,7250,7000,6750,6500]', 0, 'Work', 1, 0, 1, 1, 26, 1, 0, 0, 0, NULL, '{"Permission":{"Policia":true},"Hierarchy":["Coronel","Tenente-Coronel","Major","Capitão","1º Tenente","2º Tenente","Aspirante","Subtenente","1º Sargento","2º Sargento","3º Sargento","Cabo","Soldado","Recruta","Delegada"],"Salary":[10000,9750,9500,9250,9000,8750,8500,8250,8000,7750,7500,7250,7000,6750,6500],"Name":"Policia","Type":"Work","Service":true,"RejoinService":false,"Chat":true,"Banned":true,"SecurityCam":true,"Markers":26}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Emergencia', 'Emergencia', '["Paramedico"]', '["Membro"]', '[]', 0, 'UnWorked', 0, 1, 0, 0, NULL, 0, 0, 0, 1, NULL, '{"Permission":{"Paramedico":true},"Hierarchy":["Membro"],"Block":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Paramedico', 'Paramedico', '["Paramedico"]', '["Médico","SAMU","Cirurgião"]', '[7000,6000,5000]', 0, 'Work', 1, 0, 1, 1, 34, 0, 0, 0, 0, NULL, '{"Permission":{"Paramedico":true},"Hierarchy":["Médico","SAMU","Cirurgião"],"Salary":[7000,6000,5000],"Type":"Work","Service":true,"RejoinService":false,"Chat":true,"Banned":true,"Markers":34}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Ilegal', 'Ilegal', '["Et","Barragem","Paleto","Pesqueiro","Observatorio","Resort","Curvados","Lago","Helipa","Praia","Tunel","Porto","Norte","Corrego"]', '["Membro"]', '[]', 0, 'UnWorked', 0, 1, 0, 0, NULL, 0, 0, 0, 1, NULL, '{"Permission":{"Et":true,"Barragem":true,"Paleto":true,"Pesqueiro":true,"Observatorio":true,"Resort":true,"Curvados":true,"Lago":true,"Helipa":true,"Praia":true,"Tunel":true,"Porto":true,"Norte":true,"Corrego":true},"Hierarchy":["Membro"],"Block":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Et', 'Et', '["Et"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Et":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Barragem', 'Barragem', '["Barragem"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Barragem":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Paleto', 'Paleto', '["Paleto"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Paleto":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Pesqueiro', 'Pesqueiro', '["Pesqueiro"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Pesqueiro":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Observatorio', 'Observatorio', '["Observatorio"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Observatorio":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Resort', 'Resort', '["Resort"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Resort":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Curvados', 'Curvados', '["Curvados"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Curvados":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Lago', 'Lago', '["Lago"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Lago":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Helipa', 'Helipa', '["Helipa"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Helipa":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Praia', 'Praia', '["Praia"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Praia":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Tunel', 'Tunel', '["Tunel"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Tunel":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Porto', 'Porto', '["Porto"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Porto":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Norte', 'Norte', '["Norte"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Norte":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Corrego', 'Corrego', '["Corrego"]', '["Chefe","Gerente","Membro"]', '[]', 0, 'Work', 1, 1, 0, 0, NULL, 1, 1, 1, 0, NULL, '{"Permission":{"Corrego":true},"Hierarchy":["Chefe","Gerente","Membro"],"Type":"Work","Service":true,"RejoinService":true,"SecurityCam":true,"Domination":true,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Mecanicas', 'Mecanicas', '["Bennys","Redline"]', '["Membro"]', '[]', 0, 'UnWorked', 0, 1, 0, 0, NULL, 0, 0, 0, 1, NULL, '{"Permission":{"Bennys":true,"Redline":true},"Hierarchy":["Membro"],"Block":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Bennys', 'Bennys', '["Bennys"]', '["Diretor-Geral","Diretor","Gerente","Supervisor","Mecânico","Aprendiz"]', '[5000,4500,4000,3500,3000,2500,2000]', 0, 'Work', 1, 0, 0, 0, NULL, 0, 0, 1, 0, NULL, '{"Permission":{"Bennys":true},"Hierarchy":["Diretor-Geral","Diretor","Gerente","Supervisor","Mecânico","Aprendiz"],"Salary":[5000,4500,4000,3500,3000,2500,2000],"Type":"Work","Service":true,"RejoinService":false,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Redline', 'Redline', '["Redline"]', '["Diretor-Geral","Diretor","Gerente","Supervisor","Mecânico","Aprendiz"]', '[5000,4500,4000,3500,3000,2500,2000]', 0, 'Work', 1, 0, 0, 0, NULL, 0, 0, 1, 0, NULL, '{"Permission":{"Redline":true},"Hierarchy":["Diretor-Geral","Diretor","Gerente","Supervisor","Mecânico","Aprendiz"],"Salary":[5000,4500,4000,3500,3000,2500,2000],"Type":"Work","Service":true,"RejoinService":false,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Restaurantes', 'Restaurantes', '["MooMooCafe","CatCafe"]', '["Membro"]', '[]', 0, 'UnWorked', 0, 1, 0, 0, NULL, 0, 0, 0, 1, NULL, '{"Permission":{"MooMooCafe":true,"CatCafe":true},"Hierarchy":["Membro"],"Block":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('MooMooCafe', 'MooMooCafe', '["MooMooCafe"]', '["Gerente","Atendente"]', '[3000,2000]', 0, 'Work', 1, 0, 0, 0, NULL, 0, 0, 1, 0, NULL, '{"Permission":{"MooMooCafe":true},"Hierarchy":["Gerente","Atendente"],"Salary":[3000,2000],"Type":"Work","Service":true,"RejoinService":false,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('CatCafe', 'CatCafe', '["CatCafe"]', '["Gerente","Atendente"]', '[3000,2000]', 0, 'Work', 1, 0, 0, 0, NULL, 0, 0, 1, 0, NULL, '{"Permission":{"CatCafe":true},"Hierarchy":["Gerente","Atendente"],"Salary":[3000,2000],"Type":"Work","Service":true,"RejoinService":false,"Chest":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Booster', 'Booster', '["Booster"]', '["Membro"]', '[2500]', 0, 'UnWorked', 1, 1, 0, 0, NULL, 0, 0, 0, 1, NULL, '{"Permission":{"Booster":true},"Hierarchy":["Membro"],"Salary":[2500],"Service":true,"RejoinService":true,"Block":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Freecam', 'Freecam', '["Freecam"]', '["Membro"]', '[]', 0, 'UnWorked', 1, 1, 0, 0, NULL, 0, 0, 0, 1, NULL, '{"Permission":{"Freecam":true},"Hierarchy":["Membro"],"Service":true,"RejoinService":true,"Block":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Corredor', 'Corredor', '["Corredor"]', '["Jogador"]', '[]', 0, 'UnWorked', 0, 1, 0, 0, 46, 0, 0, 0, 1, NULL, '{"Permission":{"Corredor":true},"Hierarchy":["Jogador"],"Block":true,"Markers":46}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Boosting', 'Boosting', '["Boosting"]', '["Jogador"]', '[]', 0, 'UnWorked', 0, 1, 0, 0, 50, 0, 0, 0, 1, NULL, '{"Permission":{"Boosting":true},"Hierarchy":["Jogador"],"Block":true,"Markers":50}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation01', 'FuelStation01', '["FuelStation01"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation01":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation02', 'FuelStation02', '["FuelStation02"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation02":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation03', 'FuelStation03', '["FuelStation03"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation03":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation04', 'FuelStation04', '["FuelStation04"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation04":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation05', 'FuelStation05', '["FuelStation05"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation05":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation06', 'FuelStation06', '["FuelStation06"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation06":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation07', 'FuelStation07', '["FuelStation07"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation07":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation08', 'FuelStation08', '["FuelStation08"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation08":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation09', 'FuelStation09', '["FuelStation09"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation09":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation10', 'FuelStation10', '["FuelStation10"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation10":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation11', 'FuelStation11', '["FuelStation11"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation11":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation12', 'FuelStation12', '["FuelStation12"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation12":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation13', 'FuelStation13', '["FuelStation13"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation13":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation14', 'FuelStation14', '["FuelStation14"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation14":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation15', 'FuelStation15', '["FuelStation15"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation15":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation16', 'FuelStation16', '["FuelStation16"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation16":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation17', 'FuelStation17', '["FuelStation17"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation17":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation18', 'FuelStation18', '["FuelStation18"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation18":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation19', 'FuelStation19', '["FuelStation19"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation19":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation20', 'FuelStation20', '["FuelStation20"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation20":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation21', 'FuelStation21', '["FuelStation21"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation21":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation22', 'FuelStation22', '["FuelStation22"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation22":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation23', 'FuelStation23', '["FuelStation23"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation23":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation24', 'FuelStation24', '["FuelStation24"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation24":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation25', 'FuelStation25', '["FuelStation25"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation25":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation26', 'FuelStation26', '["FuelStation26"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation26":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('FuelStation27', 'FuelStation27', '["FuelStation27"]', '["Proprietário","Gerente","Atendente","Frentista"]', '[]', 0, 'Fuel', 1, 1, 0, 0, NULL, 0, 0, 0, 1, 3, '{"Permission":{"FuelStation27":true},"Hierarchy":["Proprietário","Gerente","Atendente","Frentista"],"Type":"Fuel","Service":true,"RejoinService":true,"Block":true,"Max":3}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Mansao01', 'Mansão 01', '["Mansao01"]', '["Proprietário","Morador"]', '[5000,0]', 0, 'Propertys', 1, 1, 0, 0, NULL, 0, 0, 0, 0, 5, '{"Permission":{"Mansao01":true},"Hierarchy":["Proprietário","Morador"],"Salary":[5000,0],"Name":"Mansão 01","Type":"Propertys","Service":true,"RejoinService":true,"Max":5}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Mansao01', 'Mansão 01', '["Mansao01"]', '["Proprietário","Morador"]', '[5000,0]', 0, 'Propertys', 1, 1, 0, 0, NULL, 0, 0, 0, 0, 5, '{"Permission":{"Mansao01":true},"Hierarchy":["Proprietário","Morador"],"Salary":[5000,0],"Name":"Mansão 01","Type":"Propertys","Service":true,"RejoinService":true,"Max":5}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Mansao02', 'Mansão 02', '["Mansao02"]', '["Proprietário","Morador"]', '[5000,0]', 0, 'Propertys', 1, 1, 0, 0, NULL, 0, 0, 0, 0, 5, '{"Permission":{"Mansao02":true},"Hierarchy":["Proprietário","Morador"],"Salary":[5000,0],"Name":"Mansão 02","Type":"Propertys","Service":true,"RejoinService":true,"Max":5}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Mansao03', 'Mansão 03', '["Mansao03"]', '["Proprietário","Morador"]', '[5000,0]', 0, 'Propertys', 1, 1, 0, 0, NULL, 0, 0, 0, 0, 5, '{"Permission":{"Mansao03":true},"Hierarchy":["Proprietário","Morador"],"Salary":[5000,0],"Name":"Mansão 03","Type":"Propertys","Service":true,"RejoinService":true,"Max":5}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Mansao04', 'Mansão 04', '["Mansao04"]', '["Proprietário","Morador"]', '[5000,0]', 0, 'Propertys', 1, 1, 0, 0, NULL, 0, 0, 0, 0, 5, '{"Permission":{"Mansao04":true},"Hierarchy":["Proprietário","Morador"],"Salary":[5000,0],"Name":"Mansão 04","Type":"Propertys","Service":true,"RejoinService":true,"Max":5}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Mansao05', 'Mansão 05', '["Mansao05"]', '["Proprietário","Morador"]', '[5000,0]', 0, 'Propertys', 1, 1, 0, 0, NULL, 0, 0, 0, 0, 5, '{"Permission":{"Mansao05":true},"Hierarchy":["Proprietário","Morador"],"Salary":[5000,0],"Name":"Mansão 05","Type":"Propertys","Service":true,"RejoinService":true,"Max":5}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

INSERT INTO `groups` (`name`, `label`, `permissions`, `hierarchy`, `salary`, `backpack`, `type`, `service`, `rejoin_service`, `chat`, `banned`, `markers`, `security_cam`, `domination`, `chest`, `block`, `max_members`, `data`)
VALUES ('Lester', 'Lester', '["Lester"]', '["Chefe","Subchefe","Membro"]', '[]', 0, 'UnWorked', 1, 1, 0, 0, NULL, 0, 0, 0, 0, NULL, '{"Permission":{"Lester":true},"Hierarchy":["Chefe","Subchefe","Membro"],"Service":true,"RejoinService":true}')
ON DUPLICATE KEY UPDATE `label`=VALUES(`label`), `permissions`=VALUES(`permissions`), `hierarchy`=VALUES(`hierarchy`), `salary`=VALUES(`salary`), `backpack`=VALUES(`backpack`), `type`=VALUES(`type`), `service`=VALUES(`service`), `rejoin_service`=VALUES(`rejoin_service`), `chat`=VALUES(`chat`), `banned`=VALUES(`banned`), `markers`=VALUES(`markers`), `security_cam`=VALUES(`security_cam`), `domination`=VALUES(`domination`), `chest`=VALUES(`chest`), `block`=VALUES(`block`), `max_members`=VALUES(`max_members`), `data`=VALUES(`data`);

CREATE TABLE IF NOT EXISTS `night_plushies` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `Passport` INT(11) NOT NULL,
  `Plushie` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
