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

USE `fence` ;

-- -----------------------------------------------------
-- Table `fence`.`central`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`central` ;


CREATE TABLE IF NOT EXISTS `fence`.`central` (
  `id` INT NOT NULL,
  `id_central` INT NULL,
  `name_central` VARCHAR(100) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `fence`.`message_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`message_type` ;


CREATE TABLE IF NOT EXISTS `fence`.`message_type` (
  `id_message_type` ENUM('1', 'A', 'B', 'C', 'D', 'E', 'F', 'G') NOT NULL,
  `label` VARCHAR(50) NULL,
  PRIMARY KEY (`id_message_type`))
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `fence`.`message`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`message` ;


CREATE TABLE IF NOT EXISTS `fence`.`message` (
  `id_message` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `central_id` INT NOT NULL,
  `message_type_id` ENUM('1', 'A', 'B', 'C', 'D', 'E', 'F', 'G') NOT NULL,
  PRIMARY KEY (`id_message`, `central_id`, `message_type_id`),
  CONSTRAINT `fk_message_central1`
    FOREIGN KEY (`central_id`)
    REFERENCES `fence`.`central` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_message_message_type1`
    FOREIGN KEY (`message_type_id`)
    REFERENCES `fence`.`message_type` (`id_message_type`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `fence`.`modul`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`modul` ;


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


-- -----------------------------------------------------
-- Table `fence`.`photovoltaics`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`photovoltaics` ;


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

-- -----------------------------------------------------
-- Table `fence`.`enter`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`enter` ;


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


CREATE INDEX `id_UNIQUE` ON `fence`.`central` (`id` ASC) VISIBLE;
CREATE INDEX `fk_message_central1_idx` ON `fence`.`message` (`central_id` ASC) VISIBLE;
CREATE INDEX `fk_message_message_type1_idx` ON `fence`.`message` (`message_type_id` ASC) VISIBLE;
CREATE INDEX `fk_modul_message1_idx` ON `fence`.`modul` (`message_id` ASC) VISIBLE;
CREATE INDEX `fk_photovoltaics_message1_idx` ON `fence`.`photovoltaics` (`message_id` ASC) VISIBLE;
CREATE INDEX `fk_enter_message1_idx` ON `fence`.`enter` (`message_id` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

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

