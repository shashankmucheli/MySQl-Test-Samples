SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`ref_drg`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`ref_drg` (
  `drg` VARCHAR(10) NOT NULL ,
  `designation` VARCHAR(200) NOT NULL ,
  `cost` DECIMAL(10,5) NOT NULL ,
  `avg_duration` DECIMAL(10,5) NOT NULL ,
  `first_day_with_reduction` DECIMAL(10,5) NOT NULL ,
  `cost_reduction` DECIMAL(10,5) NOT NULL ,
  `first_day_with_supplement` DECIMAL(10,5) NOT NULL ,
  `extra_cost_day` DECIMAL(10,5) NOT NULL ,
  `external_transfer_reduction_day` DECIMAL(10,5) NOT NULL ,
  `drg_transfer` TINYINT(1) NULL ,
  `exception_readmission` TINYINT(1) NULL ,
  PRIMARY KEY (`drg`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`patient_history`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`patient_history` (
  `EDS` INT NOT NULL AUTO_INCREMENT ,
  `patient_first_name` VARCHAR(45) NOT NULL ,
  `patient_last_name` VARCHAR(45) NULL ,
  `date_of_birth` DATE NOT NULL ,
  `date_of_entry` DATE NOT NULL ,
  `DRG_entry` VARCHAR(45) NOT NULL ,
  `actual_DRG` VARCHAR(45) NOT NULL ,
  `DRG_à_la_sortie` VARCHAR(45) NOT NULL ,
  `bed` VARCHAR(45) NOT NULL ,
  `actual_release_date` DATE NOT NULL ,
  `type_of_service` VARCHAR(5) NOT NULL ,
  `transferred_service` VARCHAR(45) NULL ,
  `indication_at_the_entrance` VARCHAR(100) NULL ,
  `end_date_coding_the_IP_Manager` DATE NULL ,
  PRIMARY KEY (`EDS`) ,
  INDEX `actual_DRG_idx` (`DRG_entry` ASC) ,
  INDEX `actual_DRG_idx1` (`actual_DRG` ASC) ,
  INDEX `DRG_à_la_sortie_idx` (`DRG_à_la_sortie` ASC) ,
  CONSTRAINT `DRG_entry`
    FOREIGN KEY (`DRG_entry` )
    REFERENCES `mydb`.`ref_drg` (`drg` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `actual_DRG`
    FOREIGN KEY (`actual_DRG` )
    REFERENCES `mydb`.`ref_drg` (`drg` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `DRG_à_la_sortie`
    FOREIGN KEY (`DRG_à_la_sortie` )
    REFERENCES `mydb`.`ref_drg` (`drg` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ref_chop`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`ref_chop` (
  `ID` INT NOT NULL ,
  `nbcar` INT NOT NULL ,
  `zcode` VARCHAR(20) NOT NULL ,
  `item_type` VARCHAR(5) NOT NULL ,
  `text` VARCHAR(500) NULL ,
  `codable` TINYINT(1) NULL ,
  `emitter` VARCHAR(10) NULL ,
  `status` INT NULL ,
  `modification_date` DATE NULL ,
  `indent_level` INT NULL ,
  `database_id` INT NULL ,
  `laterality` VARCHAR(10) NULL ,
  PRIMARY KEY (`ID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`sort_range`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`sort_range` (
  `ranking_according_to_current_selection` INT NOT NULL ,
  `display_according_to_current_selection` TINYINT(1) NULL ,
  `name_in_this_line` VARCHAR(45) NULL ,
  `independent_online` VARCHAR(45) NULL ,
  `bed_in_this_line` VARCHAR(45) NULL ,
  `sort_rangecol` VARCHAR(45) NULL ,
  PRIMARY KEY (`ranking_according_to_current_selection`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`cross_reference`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`cross_reference` (
  `EDS` INT NOT NULL ,
  `ranking_according_to_current_selection` INT NULL ,
  PRIMARY KEY (`EDS`) ,
  INDEX `ranking_according_to_current_selection_idx` (`ranking_according_to_current_selection` ASC) ,
  CONSTRAINT `EDS`
    FOREIGN KEY (`EDS` )
    REFERENCES `mydb`.`patient_history` (`EDS` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ranking_according_to_current_selection`
    FOREIGN KEY (`ranking_according_to_current_selection` )
    REFERENCES `mydb`.`sort_range` (`ranking_according_to_current_selection` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`patient_address`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`patient_address` (
  `EDS` INT NOT NULL ,
  `patient_from` VARCHAR(45) NULL ,
  `patient_address` VARCHAR(45) NULL ,
  `medical_officer_in_charge` VARCHAR(45) NULL ,
  `following_the_application_from` DATE NULL ,
  `on_request` VARCHAR(45) NULL ,
  `ttt_de_suite_demande_des_le` DATE NULL ,
  `entry_time` TIME NULL ,
  `out_time` TIME NULL ,
  `operation_date` DATE NULL ,
  PRIMARY KEY (`EDS`) ,
  CONSTRAINT `patientEDS`
    FOREIGN KEY (`EDS` )
    REFERENCES `mydb`.`cross_reference` (`EDS` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`chop_table`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`chop_table` (
  `EDS` INT NOT NULL ,
  `chop_id` INT NOT NULL ,
  `chop_date_IPM` DATE NULL ,
  `chop_date_encoder` DATE NULL ,
  `chop_text` VARCHAR(100) NULL ,
  INDEX `chop_id_idx` (`chop_id` ASC) ,
  PRIMARY KEY (`EDS`) ,
  CONSTRAINT `chop_EDS`
    FOREIGN KEY (`EDS` )
    REFERENCES `mydb`.`cross_reference` (`EDS` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `chop_id`
    FOREIGN KEY (`chop_id` )
    REFERENCES `mydb`.`ref_chop` (`ID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`cim_table`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`cim_table` (
  `EDS` INT NOT NULL ,
  `cim` VARCHAR(45) NULL ,
  `cim_date_IPM` DATE NULL ,
  `cim_date_encoder` DATE NULL ,
  `cim_text` VARCHAR(100) NULL ,
  PRIMARY KEY (`EDS`) ,
  CONSTRAINT `cim_EDS`
    FOREIGN KEY (`EDS` )
    REFERENCES `mydb`.`cross_reference` (`EDS` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`rem_table`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`rem_table` (
  `EDS` INT NOT NULL ,
  `rem_date` DATE NULL ,
  `rem_text` VARCHAR(100) NULL ,
  PRIMARY KEY (`EDS`) ,
  CONSTRAINT `rem_EDS`
    FOREIGN KEY (`EDS` )
    REFERENCES `mydb`.`cross_reference` (`EDS` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `mydb` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
