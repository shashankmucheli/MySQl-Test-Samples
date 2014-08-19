SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`DRG_reference`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`DRG_reference` (
  `DRG` VARCHAR(20) NOT NULL ,
  `designation` VARCHAR(500) NOT NULL ,
  `avg_duration` FLOAT NULL ,
  `cost` FLOAT NULL ,
  `days_for_reduction` INT NULL ,
  `reduction_cost` FLOAT NULL ,
  `days_for_supplement` INT NULL ,
  `addtional_costs` FLOAT NULL ,
  PRIMARY KEY (`DRG`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`physician_details`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`physician_details` (
  `physician_name` VARCHAR(30) NOT NULL ,
  `department` VARCHAR(30) NOT NULL ,
  PRIMARY KEY (`physician_name`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`case_details`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`case_details` (
  `EDS` INT NOT NULL ,
  `patient_ID` INT NOT NULL ,
  `medical_officer_incharge` VARCHAR(30) NOT NULL ,
  `DRG` VARCHAR(20) NOT NULL ,
  `IPM` VARCHAR(45) NOT NULL ,
  `surgery_type` VARCHAR(45) NULL ,
  `date_of_surgery` DATE NULL ,
  `daily_notes` VARCHAR(500) NULL ,
  `indication` VARCHAR(100) NULL ,
  `expected_release` DATE NULL ,
  `days_exceeded` INT NULL ,
  ` type_of_service` VARCHAR(45) NULL ,
  `transferred_service` VARCHAR(45) NULL ,
  PRIMARY KEY (`EDS`) ,
  INDEX `patient_ID_idx` (`patient_ID` ASC) ,
  INDEX `ref_DRG_idx` (`DRG` ASC) ,
  INDEX `medical_officer_details_idx` (`medical_officer_incharge` ASC) ,
  CONSTRAINT `patient_ID`
    FOREIGN KEY (`patient_ID` )
    REFERENCES `mydb`.`patient_details` (`patient_ID` )
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `ref_DRG`
    FOREIGN KEY (`DRG` )
    REFERENCES `mydb`.`DRG_reference` (`DRG` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `medical_officer_details`
    FOREIGN KEY (`medical_officer_incharge` )
    REFERENCES `mydb`.`physician_details` (`physician_name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`bed_management`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`bed_management` (
  `bed_ID` VARCHAR(20) NOT NULL ,
  `current_occupant` INT NULL ,
  `occupied_till` DATE NULL ,
  `next_planned_occupant` INT NULL ,
  `EDS_current_occupant` INT NULL ,
  PRIMARY KEY (`bed_ID`) ,
  INDEX `patient_details_idx` (`current_occupant` ASC) ,
  INDEX `bed_EDS_idx` (`EDS_current_occupant` ASC) ,
  CONSTRAINT `patient_details`
    FOREIGN KEY (`current_occupant` )
    REFERENCES `mydb`.`patient_details` (`patient_ID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `bed_EDS`
    FOREIGN KEY (`EDS_current_occupant` )
    REFERENCES `mydb`.`case_details` (`EDS` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`patient_details`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`patient_details` (
  `patient_ID` INT NOT NULL ,
  `first_name` VARCHAR(45) NULL ,
  `last_name` VARCHAR(45) NULL ,
  `DOB` DATE NOT NULL ,
  `entry_date` DATE NULL ,
  `DRG_entry` VARCHAR(20) NULL ,
  `bed_alloted` VARCHAR(20) NULL ,
  `other_details` VARCHAR(150) NULL ,
  `sex` VARCHAR(45) NULL ,
  PRIMARY KEY (`patient_ID`) ,
  INDEX `initial_DRG_idx` (`DRG_entry` ASC) ,
  INDEX `alloted_bed_idx` (`bed_alloted` ASC) ,
  CONSTRAINT `initial_DRG`
    FOREIGN KEY (`DRG_entry` )
    REFERENCES `mydb`.`DRG_reference` (`DRG` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `alloted_bed`
    FOREIGN KEY (`bed_alloted` )
    REFERENCES `mydb`.`bed_management` (`bed_ID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`metadata_patients`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`metadata_patients` (
  `patient_ID` INT NOT NULL ,
  `patient_address` VARCHAR(100) NULL ,
  `patient_insurance_number` VARCHAR(100) NULL ,
  `insurance_notes` VARCHAR(150) NULL ,
  PRIMARY KEY (`patient_ID`) ,
  CONSTRAINT `get_metadata`
    FOREIGN KEY (`patient_ID` )
    REFERENCES `mydb`.`patient_details` (`patient_ID` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`chop_reference`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`chop_reference` (
  `chop_ID` INT NOT NULL ,
  `zcode` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(250) NOT NULL ,
  `indent_level` INT NOT NULL ,
  `database_id` INT NOT NULL ,
  `emitter` VARCHAR(45) NULL ,
  PRIMARY KEY (`chop_ID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`chop_table`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`chop_table` (
  `EDS` INT NOT NULL ,
  `chop_id` INT NOT NULL ,
  ` chop_notes` VARCHAR(45) NULL ,
  INDEX `chop_ref_idx` (`chop_id` ASC) ,
  INDEX `chopEDS_idx` (`EDS` ASC) ,
  CONSTRAINT `chop_ref`
    FOREIGN KEY (`chop_id` )
    REFERENCES `mydb`.`chop_reference` (`chop_ID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `chopEDS`
    FOREIGN KEY (`EDS` )
    REFERENCES `mydb`.`case_details` (`EDS` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`users`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`users` (
  `ID` INT NOT NULL ,
  `username` VARCHAR(50) NOT NULL ,
  `password` VARCHAR(50) NOT NULL ,
  `email` VARCHAR(100) NULL ,
  `last_login` DATETIME NULL ,
  `date_created` DATETIME NULL ,
  PRIMARY KEY (`ID`) )
ENGINE = InnoDB;

USE `mydb` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
