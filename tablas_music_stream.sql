-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema music_stream
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema music_stream
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `music_stream` DEFAULT CHARACTER SET utf8 ;
USE `music_stream` ;

-- -----------------------------------------------------
-- Table `music_stream`.`artistas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `music_stream`.`artistas` (
  `nombre` VARCHAR(100) NOT NULL,
  `biografia` LONGTEXT NULL,
  `listeners` INT NULL,
  `similares` LONGTEXT NULL,
  `playcount` INT NULL,
  PRIMARY KEY (`nombre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `music_stream`.`canciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `music_stream`.`canciones` (
  `id` VARCHAR(100) NOT NULL,
  `track_name` VARCHAR(100) NULL,
  `year` INT NULL,
  `genre` VARCHAR(100) NULL,
  `artist_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`, `artist_name`),
  INDEX `fk_canciones_artistas_idx` (`artist_name` ASC) VISIBLE,
  CONSTRAINT `fk_canciones_artistas`
    FOREIGN KEY (`artist_name`)
    REFERENCES `music_stream`.`artistas` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
