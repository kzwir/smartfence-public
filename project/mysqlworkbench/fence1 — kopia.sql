-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema fence
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `fence` ;

-- -----------------------------------------------------
-- Schema fence
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `fence` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
USE `fence` ;

-- -----------------------------------------------------
-- Table `fence`.`central_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`central_type` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fence`.`central_type` (
  `id` INT NOT NULL COMMENT 'id typu centralki, dwa rodzaje:\n1. bramofon\n2. plot',
  `name` VARCHAR(45) NOT NULL COMMENT 'nazwa typu centralki',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_UNIQUE` ON `fence`.`central_type` (`id` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fence`.`central`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`central` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fence`.`central` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL COMMENT 'nazwa centrali (dla płotu maksymalnie 15 sztuk, dla bramofonu maksymalnie 2 sztuki modułów)',
  `central_type_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `central_type_id`
    FOREIGN KEY (`central_type_id`)
    REFERENCES `fence`.`central_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_UNIQUE` ON `fence`.`central` (`id` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `central_type_id_idx` ON `fence`.`central` (`central_type_id` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fence`.`message_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`message_type` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fence`.`message_type` (
  `id_message_type` ENUM('1', 'A', 'B', 'C', 'D', 'E', 'F', 'G') NOT NULL,
  `label` VARCHAR(50) NULL,
  PRIMARY KEY (`id_message_type`))
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_UNIQUE` ON `fence`.`message_type` (`id` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fence`.`photovoltaics`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`photovoltaics` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fence`.`photovoltaics` (
  `id_photovoltaics` INT NOT NULL,
  `power` DECIMAL(5,2) NOT NULL,
  `voltage` DECIMAL(5,2) NOT NULL,
  `amperage` DECIMAL(5,2) NOT NULL,
  `message_id` INT NOT NULL,
  PRIMARY KEY (`id_photovoltaics`, `message_id`),
  CONSTRAINT `fk_photovoltaics_message1`
    FOREIGN KEY (`message_id`)
    REFERENCES `fence`.`message` (`id_message`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_UNIQUE` ON `fence`.`photovoltaics` (`id` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `central_id_idx` ON `fence`.`photovoltaics` (`central_id` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `message_type_id_idx` ON `fence`.`photovoltaics` (`message_type_id` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fence`.`module`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`module` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fence`.`module` (
  `id` INT NOT NULL COMMENT 'id modułu (dla płotu maksymalnie 15 sztuk, dla bramofonu maksymalnie 2 sztuki modułów w jednej centrali)',
  `name` VARCHAR(45) NOT NULL COMMENT 'nazwa modulu, moze sie zmieniac',
  `central_id` INT NOT NULL COMMENT 'id centrali',
  PRIMARY KEY (`id`),
  CONSTRAINT `central_id`
    FOREIGN KEY (`central_id`)
    REFERENCES `fence`.`central` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_UNIQUE` ON `fence`.`module` (`id` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `central_id_idx` ON `fence`.`module` (`central_id` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fence`.`security`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`security` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fence`.`security` (
  `id` INT NOT NULL COMMENT 'id komunikatu',
  `central_id` INT NOT NULL COMMENT 'id centralki',
  `date` DATETIME NOT NULL COMMENT 'data wyslania komunikatu',
  `value` VARCHAR(45) NULL COMMENT 'wartosc komunikatu',
  `message_type_id` INT NOT NULL COMMENT 'id rodzaju komunikatu',
  PRIMARY KEY (`id`),
  CONSTRAINT `central_id`
    FOREIGN KEY (`central_id`)
    REFERENCES `fence`.`central` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `message_type_id`
    FOREIGN KEY (`message_type_id`)
    REFERENCES `fence`.`message_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `central_id_idx` ON `fence`.`security` (`central_id` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `message_type_id_idx` ON `fence`.`security` (`message_type_id` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fence`.`centrala`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`centrala` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fence`.`centrala` (
  `id` INT NOT NULL,
  `id_centrala` INT NULL,
  `name_centrala` VARCHAR(100) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `id_UNIQUE` ON `fence`.`centrala` (`id` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fence`.`message_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`message_type` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fence`.`message_type` (
  `id_message_type` ENUM('1', 'A', 'B', 'C', 'D', 'E', 'F', 'G') NOT NULL,
  `label` VARCHAR(50) NULL,
  PRIMARY KEY (`id_message_type`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fence`.`message`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`message` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fence`.`message` (
  `id_message` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `centrala_id` INT NOT NULL,
  `message_type_id` ENUM('1', 'A', 'B', 'C', 'D', 'E', 'F', 'G') NOT NULL,
  PRIMARY KEY (`id_message`, `centrala_id`, `message_type_id`),
  CONSTRAINT `fk_message_centrala1`
    FOREIGN KEY (`centrala_id`)
    REFERENCES `fence`.`centrala` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_message_message_type1`
    FOREIGN KEY (`message_type_id`)
    REFERENCES `fence`.`message_type` (`id_message_type`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_message_centrala1_idx` ON `fence`.`message` (`centrala_id` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `fk_message_message_type1_idx` ON `fence`.`message` (`message_type_id` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fence`.`modul`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`modul` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fence`.`modul` (
  `id` INT NOT NULL,
  `id_modul` INT NULL,
  `name_modul` VARCHAR(100) NULL,
  `message_id` INT NOT NULL,
  PRIMARY KEY (`id`, `message_id`),
  CONSTRAINT `fk_modul_message1`
    FOREIGN KEY (`message_id`)
    REFERENCES `fence`.`message` (`id_message`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_modul_message1_idx` ON `fence`.`modul` (`message_id` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fence`.`photovoltaics`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`photovoltaics` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fence`.`photovoltaics` (
  `id_photovoltaics` INT NOT NULL,
  `power` DECIMAL(5,2) NOT NULL,
  `voltage` DECIMAL(5,2) NOT NULL,
  `amperage` DECIMAL(5,2) NOT NULL,
  `message_id` INT NOT NULL,
  PRIMARY KEY (`id_photovoltaics`, `message_id`),
  CONSTRAINT `fk_photovoltaics_message1`
    FOREIGN KEY (`message_id`)
    REFERENCES `fence`.`message` (`id_message`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_photovoltaics_message1_idx` ON `fence`.`photovoltaics` (`message_id` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `fence`.`enter`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`enter` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `fence`.`enter` (
  `id_enter` INT NOT NULL,
  `label_enter` VARCHAR(100) NULL,
  `message_id` INT NOT NULL,
  PRIMARY KEY (`id_enter`, `message_id`),
  CONSTRAINT `fk_enter_message1`
    FOREIGN KEY (`message_id`)
    REFERENCES `fence`.`message` (`id_message`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_enter_message1_idx` ON `fence`.`enter` (`message_id` ASC) VISIBLE;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `fence`.`central_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `fence`;
INSERT INTO `fence`.`central_type` (`id`, `name`) VALUES (1, 'photovoltaics');
INSERT INTO `fence`.`central_type` (`id`, `name`) VALUES (2, 'security');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fence`.`message_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `fence`;
INSERT INTO `fence`.`message_type` (`id`, `name`) VALUES (2, 'komunikat o wejściu na teren brelokiem RFID');
INSERT INTO `fence`.`message_type` (`id`, `name`) VALUES (3, 'komunikat o wejściu na teren po rozpoznaniu twarzy');
INSERT INTO `fence`.`message_type` (`id`, `name`) VALUES (4, 'rozbrojenie alarmu');
INSERT INTO `fence`.`message_type` (`id`, `name`) VALUES (5, 'uzbrojenie alarmu');
INSERT INTO `fence`.`message_type` (`id`, `name`) VALUES (6, 'utrata energii - przejście na zasilanie bateryjne');
INSERT INTO `fence`.`message_type` (`id`, `name`) VALUES (7, 'uruchomienie urządzenia  ');
INSERT INTO `fence`.`message_type` (`id`, `name`) VALUES (8, 'włamanie ');
INSERT INTO `fence`.`message_type` (`id`, `name`) VALUES (1, 'photovoltaics');

COMMIT;

