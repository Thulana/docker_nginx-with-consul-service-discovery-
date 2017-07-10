-- phpMyAdmin SQL Dump
-- version 4.7.1
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Jul 03, 2017 at 03:23 AM
-- Server version: 5.5.56
-- PHP Version: 7.0.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `orangehrm_mysql`
--
create database orangehrm_mysql;
use orangehrm_mysql;
DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`%` PROCEDURE `archive_reference` (IN `subject_table` VARCHAR(50) CHARSET UTF8, IN `key_value` VARCHAR(10) CHARSET UTF8, IN `record_descriptor` VARCHAR(200) CHARSET UTF8)  BEGIN
  INSERT INTO `ohrm_audittrail_reference_archive`(table_name,reference_key,record_descriptor) VALUES (subject_table, key_value, record_descriptor);
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `audit_DELETE_hs_hr_employee` (IN `action_owner_id` VARCHAR(6) CHARSET UTF8, IN `action_owner_name` VARCHAR(300) CHARSET UTF8, IN `action_name` VARCHAR(255) CHARSET UTF8, IN `new_version` INT, IN `affected_entity_id` INT(7), IN `affected_entity_name` VARCHAR(300) CHARSET UTF8, IN `old_employee_id` VARCHAR(50) CHARSET UTF8, IN `old_emp_firstname` VARCHAR(255) CHARSET UTF8, IN `old_emp_middle_name` VARCHAR(255) CHARSET UTF8, IN `old_emp_lastname` VARCHAR(255) CHARSET UTF8, IN `old_emp_other_id` VARCHAR(100) CHARSET UTF8, IN `old_emp_dri_lice_num` VARCHAR(100) CHARSET UTF8, IN `old_emp_dri_lice_exp_date` DATE, IN `old_emp_gender` SMALLINT(6), IN `old_emp_marital_status` VARCHAR(20) CHARSET UTF8, IN `old_nation_code` INT(4), IN `old_emp_birthday` DATE, IN `old_emp_street1` VARCHAR(255) CHARSET UTF8, IN `old_emp_street2` VARCHAR(255) CHARSET UTF8, IN `old_city_code` VARCHAR(255) CHARSET UTF8, IN `old_provin_code` VARCHAR(255) CHARSET UTF8, IN `old_emp_zipcode` VARCHAR(255) CHARSET UTF8, IN `old_coun_code` VARCHAR(255) CHARSET UTF8, IN `old_emp_hm_telephone` VARCHAR(255) CHARSET UTF8, IN `old_emp_mobile` VARCHAR(255) CHARSET UTF8, IN `old_emp_work_telephone` VARCHAR(255) CHARSET UTF8, IN `old_emp_work_email` VARCHAR(255) CHARSET UTF8, IN `old_emp_oth_email` VARCHAR(255) CHARSET UTF8, IN `old_emp_ssn_num` VARCHAR(255) CHARSET UTF8, IN `old_emp_sin_num` VARCHAR(255) CHARSET UTF8, IN `old_emp_nick_name` VARCHAR(255) CHARSET UTF8, IN `old_emp_military_service` VARCHAR(255) CHARSET UTF8, IN `old_emp_smoker` INT(4))  BEGIN
  DECLARE action_description VARCHAR(600) CHARSET UTF8;
  DECLARE action_description_contact VARCHAR(1000) CHARSET UTF8;

-- for emergency contacts
  DECLARE emp_number INT(7);
  DECLARE eec_seqno DECIMAL(2,0);
  DECLARE eec_name VARCHAR(100) CHARSET UTF8;
  DECLARE eec_relationship VARCHAR(100) CHARSET UTF8;
  DECLARE eec_home_no VARCHAR(100) CHARSET UTF8;
  DECLARE eec_mobile_no VARCHAR(100) CHARSET UTF8;
  DECLARE eec_office_no VARCHAR(100) CHARSET UTF8;


  SET action_description = '';
  SET action_description_contact = '';
  

  -- Start generating the action description

  IF(IFNULL(old_emp_firstname,'') != '') THEN SET action_description = CONCAT(action_description, ' ', 'Employee was deleted (Name:  ', old_emp_firstname, ' ',old_emp_middle_name,' ',old_emp_lastname, ', Employee Id: ',old_employee_id,')\n');END IF;

  -- End generating the action description

  IF (action_description != '') THEN
    INSERT INTO `ohrm_audittrail_pim_employee_trail` (action_time,action_owner_id,action_owner_name,version_id,action,affected_entity_id,affected_entity_name,action_description) VALUES (
      CURRENT_TIMESTAMP,
      action_owner_id,
      action_owner_name,
      new_version,
      action_name,
      affected_entity_id,
      affected_entity_name,
      action_description
    );
  END IF;

    
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `audit_DELETE_hs_hr_emp_dependents` (IN `action_owner_id` VARCHAR(6) CHARSET UTF8, IN `action_owner_name` VARCHAR(300) CHARSET UTF8, IN `action_name` VARCHAR(255) CHARSET UTF8, IN `new_version` INT, IN `affected_entity_id` VARCHAR(100) CHARSET UTF8, IN `affected_entity_name` VARCHAR(300) CHARSET UTF8, IN `old_ed_name` VARCHAR(100) CHARSET UTF8, IN `old_ed_relationship_type` ENUM('CHILD','OTHER'), IN `old_ed_relationship` VARCHAR(100) CHARSET UTF8, IN `old_ed_date_of_birth` DATE, IN `old_ed_nationality` INT)  BEGIN
  DECLARE action_description VARCHAR(600);


  SET action_description = '';
  -- Start generating the action description

   SET action_description = CONCAT(action_description, ' ', 'Dependent was deleted (Name: ',old_ed_name,')\n');
   SET action_description = CONCAT(action_description, ' ', 'Relationship: ',old_ed_relationship_type,'\n');
   IF (old_ed_relationship != '') THEN SET action_description = CONCAT(action_description, ' ', 'Relationship (Other): ',old_ed_relationship,'\n');END IF;
   IF (old_ed_date_of_birth != '') THEN SET action_description = CONCAT(action_description, ' ', 'Date of Birth: ',old_ed_date_of_birth,'\n');END IF;
   IF (IFNULL(old_ed_nationality,'') != '') THEN SET action_description = CONCAT(action_description, ' ', 'Nationality: ',(SELECT name from `ohrm_nationality` WHERE id=old_ed_nationality),'\n'); END IF;


  -- End generating the action description

  IF (action_description != '') THEN
    INSERT INTO `ohrm_audittrail_pim_dependents_trail` (action_time,action_owner_id,action_owner_name,version_id,action,affected_entity_id,affected_entity_name,action_description) VALUES (
      CURRENT_TIMESTAMP,
      action_owner_id,
      action_owner_name,
      new_version,
      action_name,
      affected_entity_id,
      affected_entity_name,
      action_description
    );
  END IF;
 
END$$
