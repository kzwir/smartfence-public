-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: mariadb
-- Czas generowania: 18 Lis 2022, 09:10
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

DELIMITER $$
--
-- Procedury
--
DROP PROCEDURE IF EXISTS `populate`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `populate` (`in_db` VARCHAR(100), `in_table` VARCHAR(100), `in_rows` INT, `in_debug` CHAR(1))   BEGIN
/*
|
| Developer: Kedar Vaijanapurkar
| USAGE: call populate('DATABASE-NAME','TABLE-NAME',NUMBER-OF-ROWS,DEBUG-MODE);
| EXAMPLE: call populate('sakila','film',100,'N');
| Debug-mode will print an SQL that's executed and iterated.
| The data is being loaded in bulk of 500 rows which is hardcoded for now.
|
*/

DECLARE col_name VARCHAR(100);
DECLARE col_type VARCHAR(100);
DECLARE col_datatype VARCHAR(100);
DECLARE col_maxlen VARCHAR(100);
DECLARE col_extra VARCHAR(100);
DECLARE col_num_precision VARCHAR(100);
DECLARE col_num_scale VARCHAR(100);
DECLARE func_query VARCHAR(1000);
DECLARE i INT;
DECLARE batch_size INT;

DECLARE done INT DEFAULT 0;
DECLARE cur_datatype cursor FOR
 SELECT column_name,COLUMN_TYPE,data_type,CHARACTER_MAXIMUM_LENGTH,EXTRA,NUMERIC_PRECISION,NUMERIC_SCALE FROM information_schema.columns WHERE table_name=in_table AND table_schema=in_db ORDER BY ORDINAL_POSITION;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


SET func_query='';
OPEN cur_datatype;
datatype_loop: loop

FETCH cur_datatype INTO col_name, col_type, col_datatype, col_maxlen, col_extra, col_num_precision, col_num_scale;
#SELECT CONCAT(col_name,"-", col_type,"-", col_datatype,"-", IFNULL(col_maxlen,'NULL'),"-", IFNULL(col_extra,'NULL')) AS VALS;
  IF (done = 1) THEN
    leave datatype_loop;
  END IF;

CASE
WHEN col_extra='auto_increment' THEN SET func_query=concat(func_query,'NULL, ');
WHEN col_datatype in ('double','int','bigint') THEN SET func_query=concat(func_query,'get_int(), ');
WHEN col_datatype in ('varchar','char') THEN SET func_query=concat(func_query,'get_string(',ifnull(col_maxlen,0),'), ');
WHEN col_datatype in ('tinyint', 'smallint','year') or col_datatype='mediumint' THEN SET func_query=concat(func_query,'get_tinyint(), ');
WHEN col_datatype in ('datetime','timestamp') THEN SET func_query=concat(func_query,'get_datetime(), ');
WHEN col_datatype in ('date') THEN SET func_query=concat(func_query,'get_date(), ');
WHEN col_datatype in ('float', 'decimal') THEN SET func_query=concat(func_query,'get_float(',col_num_precision,',',col_num_scale,'), ');
WHEN col_datatype in ('enum','set') THEN SET func_query=concat(func_query,'get_enum("',col_type,'"), ');
WHEN col_datatype in ('GEOMETRY','POINT','LINESTRING','POLYGON','MULTIPOINT','MULTILINESTRING','MULTIPOLYGON','GEOMETRYCOLLECTION') THEN SET func_query=concat(func_query,'NULL, ');
ELSE SET func_query=concat(func_query,'get_varchar(',ifnull(col_maxlen,0),'), ');
END CASE;


end loop  datatype_loop;
close cur_datatype;

SET func_query=trim(trailing ', ' FROM func_query);
SET @func_query=concat("INSERT INTO ", in_db,".",in_table," VALUES (",func_query,");");
SET @func_query=concat("INSERT IGNORE  INTO ", in_db,".",in_table," VALUES (",func_query,")");

SET batch_size = 500;
while batch_size > 0 DO
   set batch_size  = batch_size - 1;
   set @func_query = CONCAT( @func_query , " ,(",func_query,")" );
END WHILE;
set @func_query = CONCAT( @func_query , ";" );
        IF in_debug='Y' THEN
                select @func_query;
        END IF;
SET i=in_rows;
SET batch_size=500;
populate :loop
        WHILE (i>batch_size) DO
          PREPARE t_stmt FROM @func_query;
          EXECUTE t_stmt;
          SET i = i - batch_size;
        END WHILE;
SET @func_query=concat("INSERT INTO ", in_db,".",in_table," VALUES (",func_query,");");
        WHILE (i>0) DO
          PREPARE t_stmt FROM @func_query;
          EXECUTE t_stmt;
          SET i = i - 1;
        END WHILE;
LEAVE populate;
END LOOP populate;
SELECT "Kedar Vaijanapurkar" AS "Developed by";
END$$

DROP PROCEDURE IF EXISTS `populate_fk`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `populate_fk` (`in_db` VARCHAR(50), `in_table` VARCHAR(50), `in_rows` INT, `in_debug` CHAR(1))   fk_load:BEGIN

#select CONCAT("UPDATE ",TABLE_NAME," SET ",COLUMN_NAME,"=(SELECT ",REFERENCED_COLUMN_NAME," FROM ",REFERENCED_TABLE_SCHEMA,".",REFERENCED_TABLE_NAME," ORDER BY RAND() LIMIT 1);") into @query from information_schema.key_column_usage where TABLE_NAME=in_table AND TABLE_SCHEMA=in_db AND CONSTRAINT_NAME <> 'PRIMARY';
select concat("UPDATE ",in_table," SET ", (select GROUP_CONCAT(COLUMN_NAME,"=(SELECT ",REFERENCED_COLUMN_NAME," FROM ",REFERENCED_TABLE_SCHEMA,".",REFERENCED_TABLE_NAME," ORDER BY RAND() LIMIT 1)") from information_schema.key_column_usage where TABLE_NAME=in_table AND TABLE_SCHEMA=in_db AND CONSTRAINT_NAME <> 'PRIMARY' group by table_name),";" ) into @query;
	IF in_debug='Y' THEN
		select @query;
	END IF;
if @query is null then
select "No referential information found." as Error;
LEAVE fk_load;
end if;

set  foreign_key_checks=0;
call populate(in_db,in_table,in_rows,'N');
PREPARE t_stmt FROM @query;
EXECUTE t_stmt;

set  foreign_key_checks=1;

END$$

DROP PROCEDURE IF EXISTS `populate_message`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `populate_message` (IN `centralId` INT, IN `centralName` VARCHAR(45), IN `centralTypeId` INT, IN `messageTypeId` INT, IN `meesageDate` DATETIME, IN `moduleName` VARCHAR(45), IN `moduleId` INT, IN `power` DECIMAL(5,2), IN `voltage` DECIMAL(5,2), IN `amperage` DECIMAL(5,2), IN `messageTxt` VARCHAR(45))   BEGIN
/* dane mock do testów b.d.
Rodzaje komunikatów:
1. photovoltaics:
    Nazwa Centrali
    ID Centrali (unikalne - bez możliwości zmiany)
    Rodzaj komunikatu 1
    Data RRRR/MM/DD hh24:mi:ss
    Nazwa Modułu (domyślnie będzie to np. segment1 - ale użytkownik może zmienić tą nazwę na np. obokLasu)
    ID Modułu (unikalne - bez możliwości zmiany)
    Moc
    Napięcie 
    Prąd
2. security:
    Nazwa Centrali
    ID Centrali (unikalne - bez możliwości zmiany)
    Rodzaj komunikatu 2A
    Data RRRR/MM/DD hh24:mi:ss
    Nazwa Modułu (domyślnie będzie to np. Furtka1 - ale użytkownik może zmienić tą nazwę na np. Wejscie Od Tylu)
    ID Modułu (unikalne - bez możliwości zmiany)
    Nazwa breloka RFID (domyślnie brelok1...brelok10
*/    
    INSERT IGNORE INTO central(id, name, central_type_id) VALUES (
        centralId, centralName, centralTypeId
    );

    INSERT IGNORE INTO module (id, name, central_id) VALUES(
        moduleId, moduleName, centralId
    );

    IF centralTypeId = 1 THEN 
        INSERT INTO photovoltaics (id, central_id, date, power, voltage, amperage, message_type_id) VALUES(
            default, centralId, meesageDate, power, voltage, amperage, 1
        );
    ELSE
        INSERT INTO security (id, central_id, date, value, message_type_id) VALUES(
            default, centralId, meesageDate, messageTxt, 2
        );
    END IF;
    commit;
END$$

--
-- Funkcje
--
DROP FUNCTION IF EXISTS `get_date`$$
CREATE DEFINER=`admin`@`%` FUNCTION `get_date` () RETURNS VARCHAR(10) CHARSET utf8mb4 DETERMINISTIC RETURN DATE(FROM_UNIXTIME(RAND() * (1356892200 - 1325356200) + 1325356200))
#       Below will generate random data for random years
#       RETURN DATE(FROM_UNIXTIME(RAND() * (1577817000 - 946665000) + 1325356200))$$

DROP FUNCTION IF EXISTS `get_datetime`$$
CREATE DEFINER=`admin`@`%` FUNCTION `get_datetime` () RETURNS VARCHAR(30) CHARSET utf8mb4 DETERMINISTIC RETURN FROM_UNIXTIME(ROUND(RAND() * (1356892200 - 1325356200)) + 1325356200)$$

DROP FUNCTION IF EXISTS `get_enum`$$
CREATE DEFINER=`admin`@`%` FUNCTION `get_enum` (`col_type` VARCHAR(100)) RETURNS VARCHAR(100) CHARSET utf8mb4 DETERMINISTIC RETURN if((@var:=ceil(rand()*10)) > (length(col_type)-length(replace(col_type,',',''))+1),(length(col_type)-length(replace(col_type,',',''))+1),@var)$$

DROP FUNCTION IF EXISTS `get_float`$$
CREATE DEFINER=`admin`@`%` FUNCTION `get_float` (`in_precision` INT, `in_scale` INT) RETURNS VARCHAR(100) CHARSET utf8mb4 DETERMINISTIC RETURN round(rand()*pow(10,(in_precision-in_scale)),in_scale)$$

DROP FUNCTION IF EXISTS `get_int`$$
CREATE DEFINER=`admin`@`%` FUNCTION `get_int` () RETURNS INT(11) DETERMINISTIC RETURN floor(rand()*10000000)$$

DROP FUNCTION IF EXISTS `get_string`$$
CREATE DEFINER=`admin`@`%` FUNCTION `get_string` (`in_strlen` INT) RETURNS VARCHAR(500) CHARSET utf8mb4 DETERMINISTIC BEGIN
set @var:='';
IF (in_strlen>500) THEN SET in_strlen=500; END IF;
while(in_strlen>0) do
set @var:=concat(@var,IFNULL(ELT(1+FLOOR(RAND() * 53), 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',' ','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'),'Kedar'));
set in_strlen:=in_strlen-1;
end while;
RETURN @var;
END$$

DROP FUNCTION IF EXISTS `get_time`$$
CREATE DEFINER=`admin`@`%` FUNCTION `get_time` () RETURNS INT(11) DETERMINISTIC RETURN TIME(FROM_UNIXTIME(RAND() * (1356892200 - 1325356200) + 1325356200))$$

DROP FUNCTION IF EXISTS `get_tinyint`$$
CREATE DEFINER=`admin`@`%` FUNCTION `get_tinyint` () RETURNS INT(11) DETERMINISTIC RETURN floor(rand()*100)$$

DROP FUNCTION IF EXISTS `get_varchar`$$
CREATE DEFINER=`admin`@`%` FUNCTION `get_varchar` (`in_length` VARCHAR(500)) RETURNS VARCHAR(500) CHARSET utf8mb4 DETERMINISTIC RETURN SUBSTRING(MD5(RAND()) FROM 1 FOR in_length)$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `central`
--

DROP TABLE IF EXISTS `central`;
CREATE TABLE IF NOT EXISTS `central` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL COMMENT 'nazwa centrali (dla płotu maksymalnie 15 sztuk, dla bramofonu maksymalnie 2 sztuki modułów)',
  `central_type_id` int(11) NOT NULL COMMENT 'rodzaj centralki, 1 fotowoltaika, 2 security',
  UNIQUE KEY `central_name` (`id`,`name`),
  KEY `id` (`id`),
  KEY `central_type_id` (`central_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `central_type`
--

DROP TABLE IF EXISTS `central_type`;
CREATE TABLE IF NOT EXISTS `central_type` (
  `id` int(11) NOT NULL COMMENT 'id typu centralki, dwa rodzaje:\n1. bramofon\n2. plot',
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
  `id` int(11) NOT NULL COMMENT 'id typu komunikatu:\nkomunikat o wejściu na teren brelokiem RFID\n1. fotowoltaika\n2 - bezpieczeństwo, komunikat o wejściu na teren po rozpoznaniu twarzy\n3 - bezpieczeństwo, rozbrojenie alarmu\n4 - bezpieczeństwo, uzbrojenie alarmu\n5 - bezpieczeństwo, utrata energii - przejście na zasilanie bateryjne\n6 - bezpieczeństwo, uruchomienie urządzenia  \n7 - bezpieczeństwo, włamanie \n',
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
  `id` int(11) NOT NULL COMMENT 'id modułu (dla płotu maksymalnie 15 sztuk, dla bramofonu maksymalnie 2 sztuki modułów w jednej centrali)',
  `name` varchar(45) NOT NULL COMMENT 'nazwa modulu, moze sie zmieniac',
  `central_id` int(11) NOT NULL COMMENT 'id centrali',
  PRIMARY KEY (`id`),
  UNIQUE KEY `module_name` (`id`,`name`),
  KEY `id` (`id`),
  KEY `central_id` (`central_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `photovoltaics`
--

DROP TABLE IF EXISTS `photovoltaics`;
CREATE TABLE IF NOT EXISTS `photovoltaics` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id komunikatu.',
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `security`
--

DROP TABLE IF EXISTS `security`;
CREATE TABLE IF NOT EXISTS `security` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id komunikatu.',
  `central_id` int(11) NOT NULL COMMENT 'id centralki',
  `date` datetime NOT NULL COMMENT 'data wyslania komunikatu',
  `value` varchar(45) DEFAULT NULL COMMENT 'wartosc komunikatu',
  `message_type_id` int(11) NOT NULL COMMENT 'id rodzaju komunikatu',
  PRIMARY KEY (`id`),
  KEY `central_id` (`central_id`),
  KEY `message_type_id` (`message_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `central`
--
ALTER TABLE `central`
  ADD CONSTRAINT `central_ibfk_1` FOREIGN KEY (`central_type_id`) REFERENCES `central_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

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
