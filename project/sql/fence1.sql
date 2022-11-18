-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: mariadb
-- Czas generowania: 16 Lis 2022, 08:55
-- Wersja serwera: 10.4.8-MariaDB-1:10.4.8+maria~bionic
-- Wersja PHP: 8.0.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Baza danych: `fence`
--
CREATE DATABASE IF NOT EXISTS `fence` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `fence`;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `central`
--

DROP TABLE IF EXISTS `central`;
CREATE TABLE IF NOT EXISTS `central` (
  `id` int(11) PRIMARY KEY,
  `name` varchar(45) NOT NULL COMMENT 'nazwa centrali (dla płotu maksymalnie 15 sztuk, dla bramofonu maksymalnie 2 sztuki modułów)',
  `central_type_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `central_type_id` (`central_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `central_type`
--

DROP TABLE IF EXISTS `central_type`;
CREATE TABLE IF NOT EXISTS `central_type` (
  `id` int(11) PRIMARY KEY COMMENT 'id typu centralki, dwa rodzaje:\n1. bramofon\n2. plot',
  `name` varchar(45) NOT NULL COMMENT 'nazwa typu centralki',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `central_type`
--

INSERT INTO `central_type` (`id`, `name`) VALUES
(1, 'photovoltaics'),
(2, 'security');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `message_type`
--

DROP TABLE IF EXISTS `message_type`;
CREATE TABLE IF NOT EXISTS `message_type` (
  `id` int(11) PRIMARY KEY COMMENT 'id typu komunikatu:\nkomunikat o wejściu na teren brelokiem RFID\n1. fotowoltaika\n2 - bezpieczeństwo, komunikat o wejściu na teren po rozpoznaniu twarzy\n3 - bezpieczeństwo, rozbrojenie alarmu\n4 - bezpieczeństwo, uzbrojenie alarmu\n5 - bezpieczeństwo, utrata energii - przejście na zasilanie bateryjne\n6 - bezpieczeństwo, uruchomienie urządzenia  \n7 - bezpieczeństwo, włamanie \n',
  `name` varchar(100) NOT NULL COMMENT 'nazwa komunikatu',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `message_type`
--

INSERT INTO `message_type` (`id`, `name`) VALUES
(1, 'photovoltaics'),
(2, 'komunikat o wejściu na teren brelokiem RFID'),
(3, 'komunikat o wejściu na teren po rozpoznaniu twarzy'),
(4, 'rozbrojenie alarmu'),
(5, 'uzbrojenie alarmu'),
(6, 'utrata energii - przejście na zasilanie bateryjne'),
(7, 'uruchomienie urządzenia  '),
(8, 'włamanie ');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `module`
--

DROP TABLE IF EXISTS `module`;
CREATE TABLE IF NOT EXISTS `module` (
  `id` int(11) PRIMARY KEY COMMENT 'id modułu (dla płotu maksymalnie 15 sztuk, dla bramofonu maksymalnie 2 sztuki modułów w jednej centrali)',
  `name` varchar(45) NOT NULL COMMENT 'nazwa modulu, moze sie zmieniac',
  `central_id` int(11) NOT NULL COMMENT 'id centrali',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `central_id` (`central_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `photovoltaics`
--

DROP TABLE IF EXISTS `photovoltaics`;
CREATE TABLE IF NOT EXISTS `photovoltaics` (
  `id` int(11) PRIMARY KEY AUTO_INCREMENT COMMENT 'Id komunikatu.',
  `central_id` int(11) NOT NULL COMMENT 'Id centralki.',
  `date` datetime NOT NULL COMMENT 'Data i czas wysłania komunikatu.',
  `power` decimal(5,2) NOT NULL COMMENT 'moc [W]',
  `voltage` decimal(5,2) NOT NULL COMMENT 'napięcie [V]',
  `amperage` decimal(5,2) DEFAULT NULL COMMENT 'natężenie [A]',
  `message_type_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `message_type_id` (`message_type_id`),
  KEY `central_id` (`central_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `security`
--

DROP TABLE IF EXISTS `security`;
CREATE TABLE IF NOT EXISTS `security` (
  `id` int(11) PRIMARY KEY AUTO_INCREMENT COMMENT 'id komunikatu',
  `central_id` int(11) NOT NULL COMMENT 'id centralki',
  `date` datetime NOT NULL COMMENT 'data wyslania komunikatu',
  `value` varchar(45) DEFAULT NULL COMMENT 'wartosc komunikatu',
  `message_type_id` int(11) NOT NULL COMMENT 'id rodzaju komunikatu',
  PRIMARY KEY (`id`),
  KEY `central_id` (`central_id`),
  KEY `message_type_id` (`message_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `central`
--
ALTER TABLE `central`
  ADD CONSTRAINT `central_ibfk_1` FOREIGN KEY (`central_type_id`) REFERENCES `central_type` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `module`
--
ALTER TABLE `module`
  ADD CONSTRAINT `module_ibfk_1` FOREIGN KEY (`central_id`) REFERENCES `central` (`central_type_id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `photovoltaics`
--
ALTER TABLE `photovoltaics`
  ADD CONSTRAINT `photovoltaics_ibfk_1` FOREIGN KEY (`central_id`) REFERENCES `central` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `photovoltaics_ibfk_2` FOREIGN KEY (`message_type_id`) REFERENCES `message_type` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `security`
--
ALTER TABLE `security`
  ADD CONSTRAINT `security_ibfk_1` FOREIGN KEY (`central_id`) REFERENCES `central` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `security_ibfk_2` FOREIGN KEY (`message_type_id`) REFERENCES `message_type` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;
COMMIT;


ALTER TABLE `central` ADD INDEX(`id`);
ALTER TABLE `central_type` ADD INDEX(`id`);
ALTER TABLE `central` ADD INDEX(`central_type_id`);
ALTER TABLE `message_type` ADD INDEX(`id`);
ALTER TABLE `module` ADD INDEX(`id`);
ALTER TABLE `module` ADD INDEX(`central_id`);
ALTER TABLE `photovoltaics` ADD INDEX(`id`);
ALTER TABLE `photovoltaics` ADD INDEX(`message_type_id`);
ALTER TABLE `photovoltaics` ADD INDEX(`central_id`);
ALTER TABLE `security` ADD INDEX(`central_id`);
ALTER TABLE `security` ADD INDEX(`message_type_id`);

CREATE UNIQUE INDEX central_name ON central (id, name); -- unikalny klucz na id i name
CREATE UNIQUE INDEX module_name ON module (id, name) -- unikalny klucz na id i name