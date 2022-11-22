-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: mariaDB
-- Czas generowania: 22 Lis 2022, 14:47
-- Wersja serwera: 10.4.8-MariaDB-1:10.4.8+maria~bionic
-- Wersja PHP: 8.0.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `fence`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`admin`@`%` PROCEDURE `populate_message` (IN `centralId` INT, IN `centralName` VARCHAR(100) CHARSET utf8, IN `messageTypeId` ENUM('1','A','B','C','D','E','F','G'), IN `meesageDate` DATETIME, IN `moduleName` VARCHAR(100) CHARSET utf8, IN `moduleId` INT, IN `power` DECIMAL(5,2), IN `voltage` DECIMAL(5,2), IN `amperage` DECIMAL(5,2), IN `messageTxt` VARCHAR(100) CHARSET utf8)   BEGIN
/*
Rodzaje komunikatów:
1 komunikaty o produkcji fotowoltaiki
2 komunikaty bezpieczeństwa
A komunikat o wejściu na teren brelokiem RFID
B komunikat o wejściu na teren po rozpoznaniu twarzy
C rozbrojenie alarmu
D uzbrojenie alarmu
E utrata energii - przejście na zasilanie bateryjne
F uruchomienie urządzenia
G włamanie

Składowe ramek									
1 Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (1)	Data RRRR/MM/DD/hh24/mi/ss	# Nazwa Modułu	* ID Modułu	Moc	Napięcie 	Prąd
A Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (A)	Data RRRR/MM/DD/hh24/mi/ss	# Nazwa Modułu	* ID Modułu	Nazwa breloka RFID		
B Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (B)	Data RRRR/MM/DD/hh24/mi/ss	# Nazwa Modułu	* ID Modułu	Nazwa rozpoznanej twarzy		
C Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (C)	Data RRRR/MM/DD/hh24/mi/ss					
D Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (D)	Data RRRR/MM/DD/hh24/mi/ss					
E Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (E)	Data RRRR/MM/DD/hh24/mi/ss					
F Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (F)	Data RRRR/MM/DD/hh24/mi/ss					
G Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (G)	Data RRRR/MM/DD/hh24/mi/ss	# Nazwa Modułu	* ID Modułu			

Przykładowe ramki									
1 CentralaMC;30:AE:A4:07:0D:64;1;2022/11/15/19/14/2;Plot1;30:AE:B4:08:AD:64;53,0;25,0;1,5;								
A CentralaPS;30:AE:A4:07:0D:64;A;2022/09/11/19/8/8;Bramofon2;30:AE:B4:08:AD:64;brelok1;								
B MojaCentrala;30:AE:A4:07:0D:64;A;2022/09/11/19/8/8;Bramofon2;30:AE:B4:08:AD:64;Twarzyczka1;								
C Centralna;30:AE:A4:07:0D:64;A;2022/09/11/1/8/8;								
D CentralaMC;30:AE:A4:07:0D:64;A;2022/09/8/0/8/8;								
E CentralaMC;30:AE:A4:07:0D:64;A;2022/09/11/19/59/8;								
F CentralaMC;30:AE:A4:07:0D:64;A;2022/09/14/5/8/8;								
G CentralaMC;30:AE:A4:07:0D:64;A;2022/09/11/19/8/8;PodLasem;30:AE:B4:08:AD:64;								

Wszystkie powyższe dane będą przesyłane w formie zmiennej tekstowej.									
Oznaczenie * unikalne- bez możliwości zmiany								
Oznaczenie # możliwość zmiany								
Data będzie znacznikiem z której godziny jest dany pomiar - pomiary uśredniane są przez 30 s i do centrali wysyłany jest komunikat średniej mocy, prądu, napięcia za ostatnie 30s. Centrala po zebraniu wszystkich pomiarów z modułów prześlę poszczególne wyniki do serwera. 									
*/
 DECLARE messageId INT DEFAULT 0;
 INSERT IGNORE INTO central(id, id_central, name_central) VALUES (
       DEFAULT, centralId, centralName
 );

 -- messageTypeId = 'C' or 'D' or 'E' or 'F'
 SET messageId = LAST_INSERT_ID();
 INSERT message(id_message, date, central_id, message_type_id) VALUES (
       DEFAULT, messageDate, messageId, messageTypeId
 );

CASE messageTypeId 
      WHEN messageTypeId = '1' THEN 
		INSERT INTO photovoltaics (id, power, voltage, amperage, message_id) VALUES(
				default, power, voltage, amperage, messageId
        );
      WHEN messageTypeId = 'A' OR messageTypeId = 'B' THEN
		INSERT INTO enter (id, label_enter, message_id) VALUES(
				default, messageText, messageId
        );
      WHEN messageTypeId = 'G' THEN
		INSERT IGNORE INTO module (id, id_module, name_module, message_id) VALUES(
			DEFAULT, moduleId, moduleName, messageId
		);
    END CASE;
	
    commit;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `central`
--

CREATE TABLE `central` (
  `id` int(11) NOT NULL,
  `id_central` int(11) NOT NULL,
  `name_central` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `enter`
--

CREATE TABLE `enter` (
  `id_enter` int(11) NOT NULL,
  `label_enter` varchar(100) NOT NULL,
  `message_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `message`
--

CREATE TABLE `message` (
  `id_message` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `central_id` int(11) NOT NULL,
  `message_type_id` enum('1','A','B','C','D','E','F','G') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `message_type`
--

CREATE TABLE `message_type` (
  `id_message_type` enum('1','A','B','C','D','E','F','G') NOT NULL,
  `label` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `message_type`
--

INSERT INTO `message_type` (`id_message_type`, `label`) VALUES
('1', 'komunikat o produkcji fotowoltaiki'),
('A', 'komunikat o wejsciu na teren brelokiem RFID'),
('B', 'komunikat o wejsciu na teren po rozpoznaniu twarzy'),
('C', 'rozbrojenie alarmu'),
('D', 'uzbrojenie alarmu'),
('E', 'utrata energii - przejscie na zasilanie bateryjne'),
('F', 'uruchomienie urzadzenia  '),
('G', 'wlamanie ');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `modul`
--

CREATE TABLE `modul` (
  `id` int(11) NOT NULL,
  `id_module` int(11) NOT NULL,
  `name_module` varchar(100) NOT NULL,
  `message_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `photovoltaics`
--

CREATE TABLE `photovoltaics` (
  `id_photovoltaics` int(11) NOT NULL,
  `power` decimal(5,2) NOT NULL,
  `voltage` decimal(5,2) NOT NULL,
  `amperage` decimal(5,2) NOT NULL,
  `message_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `central`
--
ALTER TABLE `central`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `enter`
--
ALTER TABLE `enter`
  ADD PRIMARY KEY (`id_enter`,`message_id`),
  ADD KEY `fk_enter_message_idx` (`message_id`);

--
-- Indeksy dla tabeli `message`
--
ALTER TABLE `message`
  ADD PRIMARY KEY (`id_message`,`central_id`,`message_type_id`),
  ADD KEY `fk_message_message_type_idx` (`message_type_id`),
  ADD KEY `fk_message_central_idx` (`central_id`) USING BTREE;

--
-- Indeksy dla tabeli `message_type`
--
ALTER TABLE `message_type`
  ADD PRIMARY KEY (`id_message_type`);

--
-- Indeksy dla tabeli `modul`
--
ALTER TABLE `modul`
  ADD PRIMARY KEY (`id`,`message_id`),
  ADD KEY `fk_modul_message_idx` (`message_id`);

--
-- Indeksy dla tabeli `photovoltaics`
--
ALTER TABLE `photovoltaics`
  ADD PRIMARY KEY (`id_photovoltaics`,`message_id`),
  ADD KEY `fk_photovoltaics_message_idx` (`message_id`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `central`
--
ALTER TABLE `central`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `enter`
--
ALTER TABLE `enter`
  MODIFY `id_enter` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `message`
--
ALTER TABLE `message`
  MODIFY `id_message` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `modul`
--
ALTER TABLE `modul`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `photovoltaics`
--
ALTER TABLE `photovoltaics`
  MODIFY `id_photovoltaics` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `enter`
--
ALTER TABLE `enter`
  ADD CONSTRAINT `fk_enter_message` FOREIGN KEY (`message_id`) REFERENCES `message` (`id_message`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ograniczenia dla tabeli `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `fk_message_centrala` FOREIGN KEY (`central_id`) REFERENCES `central` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_message_message_type` FOREIGN KEY (`message_type_id`) REFERENCES `message_type` (`id_message_type`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ograniczenia dla tabeli `modul`
--
ALTER TABLE `modul`
  ADD CONSTRAINT `fk_modul_message` FOREIGN KEY (`message_id`) REFERENCES `message` (`id_message`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ograniczenia dla tabeli `photovoltaics`
--
ALTER TABLE `photovoltaics`
  ADD CONSTRAINT `fk_photovoltaics_message` FOREIGN KEY (`message_id`) REFERENCES `message` (`id_message`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
