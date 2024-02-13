-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema PHARMACIES
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema PHARMACIES
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `PHARMACIES` DEFAULT CHARACTER SET utf8 ;
USE `PHARMACIES` ;

-- -----------------------------------------------------
-- Table `PHARMACIES`.`PHYSICIAN`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`PHYSICIAN` (
  `PhysicianID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `SSN` CHAR(9) NOT NULL,
  `Specialty` VARCHAR(45) NOT NULL,
  `FirstYearOfPractice` CHAR(4) NOT NULL,
  PRIMARY KEY (`PhysicianID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHARMACIES`.`PATIENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`PATIENT` (
  `PatientID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PhysicianID` INT UNSIGNED NOT NULL,
  `FirstName` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `BirthDate` DATE NOT NULL,
  `SSN` CHAR(9) NOT NULL,
  `Street` VARCHAR(255) NOT NULL,
  `City` VARCHAR(45) NOT NULL,
  `State` CHAR(2) NOT NULL,
  `Zipcode` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`PatientID`),
  INDEX `PATIENT_PhysicianID_idx` (`PhysicianID` ASC) VISIBLE,
  CONSTRAINT `PATIENT_PhysicianID_idx`
    FOREIGN KEY (`PhysicianID`)
    REFERENCES `PHARMACIES`.`PHYSICIAN` (`PhysicianID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHARMACIES`.`PHARMACY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`PHARMACY` (
  `PharmacyID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Address` TEXT NOT NULL,
  `Phone` CHAR(10) NOT NULL,
  PRIMARY KEY (`PharmacyID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHARMACIES`.`MANUFACTURE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`MANUFACTURE` (
  `ManufactureID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Phone` CHAR(10) NOT NULL,
  PRIMARY KEY (`ManufactureID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHARMACIES`.`DRUG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`DRUG` (
  `Drug_ID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Trade_Name` VARCHAR(100) NULL DEFAULT NULL,
  `Formula` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`Drug_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHARMACIES`.`PRESCRIPTION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`PRESCRIPTION` (
  `RxID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PatientID` INT UNSIGNED NOT NULL,
  `Drug_ID` INT UNSIGNED NOT NULL,
  `PhysicianID` INT UNSIGNED NOT NULL,
  `PharmacyID` INT UNSIGNED NULL,
  `DrugName` VARCHAR(45) NOT NULL,
  `Quantity` INT UNSIGNED NOT NULL,
  `RxPrice` DECIMAL(10,2) UNSIGNED NULL,
  `PrescriptionDate` DATE NOT NULL DEFAULT (CURRENT_DATE()),
  `PrescriptionFillDate` DATE NULL,
  PRIMARY KEY (`RxID`),
  INDEX `PRESCRIPTION_PatientID_idx` (`PatientID` ASC) VISIBLE,
  INDEX `PRESCRIPTION_Drug_ID_idx` (`Drug_ID` ASC) VISIBLE,
  INDEX `PRESCRIPTION_PhysicianID_idx` (`PhysicianID` ASC) VISIBLE,
  INDEX `PRESCRIPTION_PharmacyID_idx` (`PharmacyID` ASC) VISIBLE,
  CONSTRAINT `PRESCRIPTION_PatientID_idx`
    FOREIGN KEY (`PatientID`)
    REFERENCES `PHARMACIES`.`PATIENT` (`PatientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `PRESCRIPTION_Drug_ID_idx`
    FOREIGN KEY (`Drug_ID`)
    REFERENCES `PHARMACIES`.`DRUG` (`Drug_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `PRESCRIPTION_PhysicianID_idx`
    FOREIGN KEY (`PhysicianID`)
    REFERENCES `PHARMACIES`.`PHYSICIAN` (`PhysicianID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `PRESCRIPTION_PharmacyID_idx`
    FOREIGN KEY (`PharmacyID`)
    REFERENCES `PHARMACIES`.`PHARMACY` (`PharmacyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHARMACIES`.`PRICES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`PRICES` (
  `PharmacyID` INT UNSIGNED NOT NULL,
  `Drug_ID` INT UNSIGNED NOT NULL,
  `Price` DECIMAL(10,2) UNSIGNED NOT NULL,
  PRIMARY KEY (`PharmacyID`, `Drug_ID`),
  INDEX `PRICES_Drug_ID_idx` (`Drug_ID` ASC) VISIBLE,
  INDEX `PRICES_PharmacyID_idx` (`PharmacyID` ASC) VISIBLE,
  CONSTRAINT `PRICES_PharmacyID_idx`
    FOREIGN KEY (`PharmacyID`)
    REFERENCES `PHARMACIES`.`PHARMACY` (`PharmacyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `PRICES_Drug_ID_idx`
    FOREIGN KEY (`Drug_ID`)
    REFERENCES `PHARMACIES`.`DRUG` (`Drug_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHARMACIES`.`CONTRACT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`CONTRACT` (
  `PharmacyID` INT UNSIGNED NOT NULL,
  `ManufactureID` INT UNSIGNED NOT NULL,
  `SupervisorName` VARCHAR(45) NOT NULL,
  `SupervisorLastName` VARCHAR(45) NOT NULL,
  `ContractText` LONGTEXT NOT NULL,
  `StartDate` DATE NOT NULL,
  `EndDate` DATE NOT NULL,
  PRIMARY KEY (`PharmacyID`, `ManufactureID`),
  INDEX `CONTRACT_ManufactureID_idx` (`ManufactureID` ASC) VISIBLE,
  INDEX `CONTRACT_PharmacyID_idx` (`PharmacyID` ASC) VISIBLE,
  CONSTRAINT `PharmacyID`
    FOREIGN KEY (`PharmacyID`)
    REFERENCES `PHARMACIES`.`PHARMACY` (`PharmacyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ManufactureID`
    FOREIGN KEY (`ManufactureID`)
    REFERENCES `PHARMACIES`.`MANUFACTURE` (`ManufactureID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHARMACIES`.`DRUG_MANUFACTURE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`DRUG_MANUFACTURE` (
  `ManufactureID` INT UNSIGNED NOT NULL,
  `Drug_ID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`ManufactureID`, `Drug_ID`),
  INDEX `BRIDGE_Drug_ID_idx` (`Drug_ID` ASC) VISIBLE,
  INDEX `BRIDGE_ManufactureID_idx` (`ManufactureID` ASC) VISIBLE,
  CONSTRAINT `BRIDGE_ManufactureID`
    FOREIGN KEY (`ManufactureID`)
    REFERENCES `PHARMACIES`.`MANUFACTURE` (`ManufactureID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `BRIDGE_Drug_ID`
    FOREIGN KEY (`Drug_ID`)
    REFERENCES `PHARMACIES`.`DRUG` (`Drug_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `PHARMACIES` ;

-- -----------------------------------------------------
-- Placeholder table for view `PHARMACIES`.`PATIENT_INFO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`PATIENT_INFO` (`PatientID` INT, `'Patient'` INT, `'Date of Birth'` INT, `'Social Security Number'` INT, `'Address'` INT, `'Primary Care'` INT, `'Primary Care SSN'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `PHARMACIES`.`PRESCRIPTION_INFO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`PRESCRIPTION_INFO` (`RxID` INT, `'Prescribed at'` INT, `'Medication'` INT, `'Manufacture'` INT, `'Quantity'` INT, `'Fill Date'` INT, `'Prescribed for'` INT, `'Patient SSN'` INT, `'Prescriber'` INT, `'Physician SSN'` INT, `'Specialty'` INT, `'Pharmacy'` INT, `'Pharmacy Address'` INT, `'Pharmacy Phone'` INT, `'Price'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `PHARMACIES`.`DRUG_INFO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`DRUG_INFO` (`Drug_ID` INT, `'Trade Name'` INT, `'Generic Name'` INT, `'Manufacture'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `PHARMACIES`.`CONTRACT_INFO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`CONTRACT_INFO` (`'Contract Between'` INT, `'From'` INT, `'To'` INT, `'Manufacture Phone'` INT, `'Pharmacy Supervisor'` INT, `'Pharmacy Address'` INT, `'Pharmacy Phone'` INT, `'Text'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `PHARMACIES`.`PHYSICIAN_INFO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`PHYSICIAN_INFO` (`PhysicianID` INT, `'Physician Name'` INT, `SSN` INT, `Specialty` INT, `'First Year of Practice'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `PHARMACIES`.`PHARMACY_INFO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`PHARMACY_INFO` (`PharmacyID` INT, `'Store Name'` INT, `'Store Address'` INT, `Phone` INT);

-- -----------------------------------------------------
-- Placeholder table for view `PHARMACIES`.`MANUFACTURE_INFO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHARMACIES`.`MANUFACTURE_INFO` (`ManufactureID` INT, `'Manufacture Name'` INT, `Phone` INT);

-- -----------------------------------------------------
-- View `PHARMACIES`.`PATIENT_INFO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PHARMACIES`.`PATIENT_INFO`;
USE `PHARMACIES`;
CREATE  OR REPLACE VIEW `PHARMACIES`.`PATIENT_INFO` AS 
	SELECT P.PatientID, CONCAT(P.FirstName, ' ', P.LastName) AS 'Patient',
    P.BirthDate AS 'Date of Birth', P.SSN AS 'Social Security Number',
    CONCAT(P.Street, ' ', P.City, ' ', P.State, ' ', P.Zipcode) AS 'Address',
	CONCAT(D.FirstName, ' ', D.LastName) AS 'Primary Care',  D.SSN AS 'Primary Care SSN' 
    FROM PATIENT P JOIN PHYSICIAN D 
	ON P.PhysicianID = D.PhysicianID 
	ORDER BY P.FirstName;

-- -----------------------------------------------------
-- View `PHARMACIES`.`PRESCRIPTION_INFO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PHARMACIES`.`PRESCRIPTION_INFO`;
USE `PHARMACIES`;
CREATE  OR REPLACE VIEW `PHARMACIES`.`PRESCRIPTION_INFO` AS
	SELECT S.RxID, S.PrescriptionDate AS 'Prescribed at',
	S.DrugName AS 'Medication', C.Name AS 'Manufacture', 
    S.Quantity AS 'Quantity', S.PrescriptionFillDate AS 'Fill Date',
	CONCAT(P.FirstName, ' ', P.LastName) AS 'Prescribed for', P.SSN AS 'Patient SSN', 
    CONCAT(D.FirstName, ' ', D.LastName) AS 'Prescriber', D.SSN AS 'Physician SSN',
	D.Specialty AS 'Specialty',
	F.Name AS 'Pharmacy', F.Address AS 'Pharmacy Address', F.Phone AS 'Pharmacy Phone',
	S.RxPrice AS 'Price'
	FROM PRESCRIPTION S, DRUG M, MANUFACTURE C, DRUG_MANUFACTURE MC, PATIENT P, PHYSICIAN D, PHARMACY F, PRICES R
	WHERE S.PatientID = P.PatientID AND S.Drug_ID = M.Drug_ID AND M.Drug_ID = MC.Drug_ID AND MC.ManufactureID = C.ManufactureID
	AND S.PhysicianID = D.PhysicianID AND S.PharmacyID = F.PharmacyID
	AND R.Drug_ID = M.Drug_ID AND R.PharmacyID = F.PharmacyID
	ORDER BY S.PrescriptionDate DESC;

-- -----------------------------------------------------
-- View `PHARMACIES`.`DRUG_INFO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PHARMACIES`.`DRUG_INFO`;
USE `PHARMACIES`;
CREATE  OR REPLACE VIEW `PHARMACIES`.`DRUG_INFO` AS
	SELECT D.Drug_ID, D.Trade_Name AS 'Trade Name', D.Formula AS 'Generic Name',
	M.Name AS 'Manufacture'
	FROM DRUG D, DRUG_MANUFACTURE DM, MANUFACTURE M
	WHERE D.Drug_ID = DM.Drug_ID AND DM.ManufactureID = M.ManufactureID
	ORDER BY D.Trade_Name;

-- -----------------------------------------------------
-- View `PHARMACIES`.`CONTRACT_INFO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PHARMACIES`.`CONTRACT_INFO`;
USE `PHARMACIES`;
CREATE  OR REPLACE VIEW `PHARMACIES`.`CONTRACT_INFO` AS
	SELECT CONCAT(M.Name, ' - ', P.Name) AS 'Contract Between', StartDate AS 'From', EndDate AS 'To', 
	M.Phone AS 'Manufacture Phone',
	CONCAT(C.SupervisorName, ' ', C.SupervisorLastName) AS 'Pharmacy Supervisor',
	P.Address AS 'Pharmacy Address',  P.Phone AS 'Pharmacy Phone',
	C.ContractText AS 'Text'
	FROM CONTRACT C, PHARMACY P, MANUFACTURE M
	WHERE C.PharmacyID = P.PharmacyID AND C.ManufactureID = M.ManufactureID
	ORDER BY M.NAME;

-- -----------------------------------------------------
-- View `PHARMACIES`.`PHYSICIAN_INFO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PHARMACIES`.`PHYSICIAN_INFO`;
USE `PHARMACIES`;
CREATE  OR REPLACE VIEW `PHYSICIAN_INFO` AS
	SELECT PhysicianID, CONCAT(FirstName, ' ', LastName) AS 'Physician Name', 
    SSN, Specialty, FirstYearOfPractice AS 'First Year of Practice'
    FROM PHYSICIAN 
    ORDER BY FirstName;

-- -----------------------------------------------------
-- View `PHARMACIES`.`PHARMACY_INFO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PHARMACIES`.`PHARMACY_INFO`;
USE `PHARMACIES`;
CREATE  OR REPLACE VIEW `PHARMACY_INFO` AS
	SELECT PharmacyID, Name AS 'Store Name', 
    Address AS 'Store Address', Phone 
    FROM PHARMACY 
    ORDER BY Name;

-- -----------------------------------------------------
-- View `PHARMACIES`.`MANUFACTURE_INFO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PHARMACIES`.`MANUFACTURE_INFO`;
USE `PHARMACIES`;
CREATE  OR REPLACE VIEW `MANUFACTURE_INFO` AS
	SELECT ManufactureID, Name AS 'Manufacture Name', Phone 
    FROM MANUFACTURE 
    ORDER BY Name;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
