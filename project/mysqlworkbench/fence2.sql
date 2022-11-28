-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema fence
-- -----------------------------------------------------

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
  `id_central` VARCHAR(17) NOT NULL,
  `name_central` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`name_central`, `id_central`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fence`.`message_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fence`.`message_type` (
  `id_message_type` ENUM('1', 'A', 'B', 'C', 'D', 'E', 'F', 'G') NOT NULL,
  `label` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_message_type`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fence`.`message`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fence`.`message` ;
CREATE TABLE IF NOT EXISTS `fence`.`message` (
  `id_message` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `message_type_id` ENUM('1', 'A', 'B', 'C', 'D', 'E', 'F', 'G') NOT NULL,
  `name_central` VARCHAR(100) NOT NULL,
  `id_central` VARCHAR(17) NOT NULL,
  PRIMARY KEY (`id_message`, `message_type_id`, `name_central`, `id_central`),
  INDEX `fk_message_message_type_idx` (`message_type_id` ASC),
  INDEX `fk_message_central1_idx` (`name_central` ASC, `id_central` ASC),
  CONSTRAINT `fk_message_message_type`
    FOREIGN KEY (`message_type_id`)
    REFERENCES `fence`.`message_type` (`id_message_type`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_message_central1`
    FOREIGN KEY (`name_central` , `id_central`)
    REFERENCES `fence`.`central` (`name_central` , `id_central`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fence`.`module`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fence`.`module` (
  `id` INT NOT NULL,
  `id_module` INT NOT NULL,
  `name_module` VARCHAR(100) NOT NULL,
  `message_id` INT NOT NULL,
  PRIMARY KEY (`id`, `message_id`),
  INDEX `fk_modul_message_idx` (`message_id` ASC),
  CONSTRAINT `fk_modul_message`
    FOREIGN KEY (`message_id`)
    REFERENCES `fence`.`message` (`id_message`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fence`.`photovoltaics`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fence`.`photovoltaics` (
  `id_photovoltaics` INT NOT NULL,
  `power` DECIMAL(5,2) NOT NULL,
  `voltage` DECIMAL(5,2) NOT NULL,
  `amperage` DECIMAL(5,2) NOT NULL,
  `message_id` INT NOT NULL,
  PRIMARY KEY (`id_photovoltaics`, `message_id`),
  INDEX `fk_photovoltaics_message_idx` (`message_id` ASC),
  CONSTRAINT `fk_photovoltaics_message`
    FOREIGN KEY (`message_id`)
    REFERENCES `fence`.`message` (`id_message`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fence`.`enter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fence`.`enter` (
  `id_enter` INT NOT NULL,
  `label_enter` VARCHAR(100) NOT NULL,
  `message_id` INT NOT NULL,
  PRIMARY KEY (`id_enter`, `message_id`),
  INDEX `fk_enter_message_idx` (`message_id` ASC),
  CONSTRAINT `fk_enter_message`
    FOREIGN KEY (`message_id`)
    REFERENCES `fence`.`message` (`id_message`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `fence`.`message_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `fence`;
INSERT INTO `fence`.`message_type` (`id_message_type`, `label`) VALUES ('1', 'komunikat o produkcji fotowoltaiki');
INSERT INTO `fence`.`message_type` (`id_message_type`, `label`) VALUES ('A', 'komunikat o wejsciu na teren brelokiem RFID');
INSERT INTO `fence`.`message_type` (`id_message_type`, `label`) VALUES ('B', 'komunikat o wejsciu na teren po rozpoznaniu twarzy');
INSERT INTO `fence`.`message_type` (`id_message_type`, `label`) VALUES ('C', 'rozbrojenie alarmu');
INSERT INTO `fence`.`message_type` (`id_message_type`, `label`) VALUES ('D', 'uzbrojenie alarmu');
INSERT INTO `fence`.`message_type` (`id_message_type`, `label`) VALUES ('E', 'utrata energii - przejscie na zasilanie bateryjne');
INSERT INTO `fence`.`message_type` (`id_message_type`, `label`) VALUES ('F', 'uruchomienie urzadzenia  ');
INSERT INTO `fence`.`message_type` (`id_message_type`, `label`) VALUES ('G', 'wlamanie ');

COMMIT;

