-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: May 04, 2026 at 12:32 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `qms-pro-main`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `module` varchar(100) NOT NULL,
  `action` varchar(100) NOT NULL,
  `model_type` varchar(100) DEFAULT NULL,
  `model_id` bigint(20) UNSIGNED DEFAULT NULL,
  `old_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_values`)),
  `new_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_values`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `audits`
--

CREATE TABLE `audits` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reference_no` varchar(50) NOT NULL,
  `program_id` bigint(20) UNSIGNED DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `type` enum('internal','external','surveillance','certification','supplier','process','system','compliance') NOT NULL DEFAULT 'internal',
  `scope` text DEFAULT NULL,
  `criteria` text DEFAULT NULL,
  `lead_auditor_id` bigint(20) UNSIGNED NOT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('planned','notified','in_progress','draft_report','report_issued','closed','cancelled') NOT NULL DEFAULT 'planned',
  `planned_start_date` date NOT NULL,
  `planned_end_date` date NOT NULL,
  `actual_start_date` date DEFAULT NULL,
  `actual_end_date` date DEFAULT NULL,
  `report_date` date DEFAULT NULL,
  `overall_result` enum('satisfactory','minor_findings','major_findings','critical_findings') DEFAULT NULL,
  `executive_summary` text DEFAULT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audits`
--

INSERT INTO `audits` (`id`, `reference_no`, `program_id`, `title`, `description`, `type`, `scope`, `criteria`, `lead_auditor_id`, `department_id`, `status`, `planned_start_date`, `planned_end_date`, `actual_start_date`, `actual_end_date`, `report_date`, `overall_result`, `executive_summary`, `attachments`, `created_at`, `updated_at`) VALUES
(1, 'AUD-2026-0001', NULL, 'IT department audit', NULL, 'internal', 'Cyber security', NULL, 1, 3, 'closed', '2026-03-05', '2026-03-12', '2026-04-14', '2026-04-15', '2026-04-15', 'satisfactory', NULL, NULL, '2026-03-05 10:54:25', '2026-04-15 09:07:42');

-- --------------------------------------------------------

--
-- Table structure for table `audit_checklists`
--

CREATE TABLE `audit_checklists` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `audit_id` bigint(20) UNSIGNED NOT NULL,
  `section` varchar(255) DEFAULT NULL,
  `question` text NOT NULL,
  `requirement_ref` varchar(100) DEFAULT NULL,
  `response` enum('yes','no','partial','na','not_checked') DEFAULT NULL,
  `evidence` text DEFAULT NULL,
  `finding_type` enum('conformity','minor_nc','major_nc','observation','opportunity') DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `sequence` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_checklists`
--

INSERT INTO `audit_checklists` (`id`, `audit_id`, `section`, `question`, `requirement_ref`, `response`, `evidence`, `finding_type`, `notes`, `sequence`, `created_at`) VALUES
(1, 1, 'fffff', 'fff', 'fff', NULL, 'aaddddd', NULL, NULL, 0, '2026-03-05 10:55:00'),
(2, 1, 'business continuity', 'Provide the buisness continuity plan', NULL, NULL, NULL, NULL, NULL, 0, '2026-04-15 09:06:36'),
(3, 1, 'policy and procedure', 'dddd', NULL, NULL, NULL, NULL, NULL, 0, '2026-04-15 09:06:51');

-- --------------------------------------------------------

--
-- Table structure for table `audit_findings`
--

CREATE TABLE `audit_findings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `audit_id` bigint(20) UNSIGNED NOT NULL,
  `reference_no` varchar(50) NOT NULL,
  `finding_type` enum('minor_nc','major_nc','observation','opportunity','positive') NOT NULL DEFAULT 'minor_nc',
  `description` text NOT NULL,
  `requirement_ref` varchar(255) DEFAULT NULL,
  `evidence` text DEFAULT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `assignee_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('open','capa_raised','closed') NOT NULL DEFAULT 'open',
  `capa_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_findings`
--

INSERT INTO `audit_findings` (`id`, `audit_id`, `reference_no`, `finding_type`, `description`, `requirement_ref`, `evidence`, `department_id`, `assignee_id`, `status`, `capa_id`, `created_at`) VALUES
(1, 1, 'AUD-1-F01', 'minor_nc', 'dddddddddddd', 'cjkl;\'', 'ddddddddddd', NULL, 16, 'capa_raised', 1, '2026-04-14 09:51:38');

-- --------------------------------------------------------

--
-- Table structure for table `audit_programs`
--

CREATE TABLE `audit_programs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `year` int(11) NOT NULL,
  `status` enum('planned','active','completed','cancelled') NOT NULL DEFAULT 'planned',
  `created_by_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `audit_team`
--

CREATE TABLE `audit_team` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `audit_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `role` enum('lead_auditor','auditor','observer','technical_expert') NOT NULL DEFAULT 'auditor'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_team`
--

INSERT INTO `audit_team` (`id`, `audit_id`, `user_id`, `role`) VALUES
(1, 1, 1, 'lead_auditor'),
(2, 1, 2, 'auditor'),
(3, 1, 9, 'lead_auditor');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `capas`
--

CREATE TABLE `capas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reference_no` varchar(50) NOT NULL,
  `nc_id` bigint(20) UNSIGNED DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `type` enum('corrective','preventive') NOT NULL DEFAULT 'corrective',
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('draft','open','in_progress','effectiveness_review','closed','cancelled') NOT NULL DEFAULT 'draft',
  `priority` enum('low','medium','high','critical') NOT NULL DEFAULT 'medium',
  `proposed_date` date DEFAULT NULL,
  `target_date` date NOT NULL,
  `actual_completion_date` date DEFAULT NULL,
  `root_cause_analysis` text DEFAULT NULL,
  `action_plan` text DEFAULT NULL,
  `effectiveness_criteria` text DEFAULT NULL,
  `effectiveness_result` text DEFAULT NULL,
  `effectiveness_verified_by_id` bigint(20) UNSIGNED DEFAULT NULL,
  `effectiveness_verified_at` timestamp NULL DEFAULT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `capas`
--

INSERT INTO `capas` (`id`, `reference_no`, `nc_id`, `title`, `description`, `type`, `owner_id`, `department_id`, `status`, `priority`, `proposed_date`, `target_date`, `actual_completion_date`, `root_cause_analysis`, `action_plan`, `effectiveness_criteria`, `effectiveness_result`, `effectiveness_verified_by_id`, `effectiveness_verified_at`, `attachments`, `created_at`, `updated_at`) VALUES
(1, 'CAPA-2026-0001', NULL, 'CAPA for AUD-1-F01: dddddddddddd', 'dddddddddddd', 'corrective', 16, NULL, 'open', 'medium', NULL, '2026-05-14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-14 09:51:44', '2026-04-14 09:51:44'),
(2, 'CAPA-2026-0002', 7, 'Prepare IT policies', 'ffffgg', 'corrective', 2, 3, 'closed', 'medium', NULL, '2026-03-05', '2026-04-15', 'ssssssd', 'aaaaasd', 'vvvfffff', 'effective', 2, '2026-04-15 08:26:06', NULL, '2026-04-15 08:24:57', '2026-04-15 08:26:06'),
(3, 'CAPA-2024-0001', 1, 'Restore and Validate Audit Logging System', 'Corrective action to restore audit trail functionality and validate all claims processed during the outage period.', 'corrective', 5, 3, 'in_progress', 'high', NULL, '2024-02-15', NULL, 'Audit logging disabled during patch deployment due to missing checklist item in change management procedure.', '1. Restore audit log system. 2. Re-process affected claims manually. 3. Update change management checklist. 4. Retrain IT team.', 'Zero audit trail gaps in 30-day post-implementation review.', NULL, NULL, NULL, NULL, '2026-04-16 11:12:58', '2026-04-16 11:12:58'),
(4, 'CAPA-2024-0002', 3, 'Customer Service Capacity & Automation Improvement', 'Address SLA breach through workforce planning and automated ticket routing implementation.', 'corrective', 13, 8, 'open', 'critical', NULL, '2024-03-31', NULL, 'Insufficient headcount for peak volumes. No predictive staffing model. Manual ticket routing causing delays.', '1. Hire 3 additional CS agents. 2. Implement automated routing rules. 3. Establish peak-season staffing model.', 'SLA compliance rate >= 95% for 3 consecutive months.', NULL, NULL, NULL, NULL, '2026-04-16 11:12:58', '2026-04-16 11:12:58'),
(5, 'CAPA-2024-0003', 5, 'DR/BCP Documentation and Testing', 'Preventive action to improve disaster recovery documentation and conduct quarterly DR tests.', 'preventive', 5, 3, 'closed', 'critical', NULL, '2024-01-25', '2024-01-22', 'Backup documentation was outdated. DR runbook not reviewed since 2021.', '1. Update DR runbook. 2. Conduct tabletop exercise. 3. Schedule quarterly DR tests.', 'Successful DR test with RTO < 4 hours.', 'DR test conducted Jan 20 — RTO achieved in 2.8 hours. All documentation updated.', NULL, '2026-04-13 11:12:58', NULL, '2026-04-16 11:12:58', '2026-04-16 11:12:58'),
(18, 'CAPA-2026-0006', NULL, 'capa test1', 'ad asa sa', 'corrective', 1, NULL, 'open', 'medium', NULL, '2026-04-15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-19 12:30:59', '2026-04-19 12:30:59'),
(19, 'CAPA-2026-0007', NULL, 'test', 'test test', 'corrective', 4, NULL, 'open', 'medium', NULL, '2026-05-19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-04 09:16:40', '2026-05-04 09:16:40');

-- --------------------------------------------------------

--
-- Table structure for table `capa_tasks`
--

CREATE TABLE `capa_tasks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `capa_id` bigint(20) UNSIGNED NOT NULL,
  `task_description` text NOT NULL,
  `responsible_id` bigint(20) UNSIGNED NOT NULL,
  `due_date` date NOT NULL,
  `status` enum('pending','in_progress','completed','overdue') NOT NULL DEFAULT 'pending',
  `completion_notes` text DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `capa_tasks`
--

INSERT INTO `capa_tasks` (`id`, `capa_id`, `task_description`, `responsible_id`, `due_date`, `status`, `completion_notes`, `completed_at`, `created_at`) VALUES
(1, 2, 'aaa', 14, '2026-04-04', 'pending', NULL, NULL, '2026-04-15 08:25:42'),
(2, 1, 'Restore audit logging service and validate connectivity', 11, '2024-01-25', 'completed', 'Logging service restored and verified on Jan 23.', '2026-04-08 11:25:31', '2026-03-27 11:25:31'),
(3, 1, 'Manual review and re-processing of 23 affected claims', 11, '2024-01-31', 'in_progress', NULL, NULL, '2026-03-27 11:25:31'),
(4, 1, 'Update change management checklist with logging verification step', 5, '2024-02-10', 'pending', NULL, NULL, '2026-03-27 11:25:31'),
(5, 2, 'Post job descriptions for 3 Customer Service Agent roles', 6, '2024-02-01', 'completed', 'Job postings live on LinkedIn and Bayt.com', '2026-04-11 11:25:31', '2026-04-01 11:25:31'),
(6, 2, 'Configure automated ticket routing rules in CRM', 5, '2024-02-28', 'in_progress', NULL, NULL, '2026-04-01 11:25:31');

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE `clients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `type` enum('client','insurer','regulator','partner','prospect') NOT NULL DEFAULT 'client',
  `industry` varchar(150) DEFAULT NULL,
  `contact_name` varchar(200) DEFAULT NULL,
  `contact_email` varchar(200) DEFAULT NULL,
  `contact_phone` varchar(50) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `account_manager_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('active','inactive','prospect') NOT NULL DEFAULT 'active',
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clients`
--

INSERT INTO `clients` (`id`, `name`, `code`, `type`, `industry`, `contact_name`, `contact_email`, `contact_phone`, `address`, `country`, `account_manager_id`, `status`, `metadata`, `created_at`, `updated_at`) VALUES
(1, 'AL-JAZEERA FACTORY FOR PAINTS CO.', '5855017761', 'client', 'null', 'NULL', 'nalyahya@jazeerapaints.com', '0507874171', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(2, 'Diamond  Insurance Broker ( DIB )', '7009167235', 'client', 'null', 'NULL', 'j.varkey@dbroker.com.sa', '920004778', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(3, 'ABDULAZIZ ALMULHEM OFFICE', '2050079328', 'client', 'null', 'NULL', 'mulhemco55@hotmail.com', '0507895089', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(4, 'AFLAJ FACTORY FOR READY CONCRETE AND BLUCK', '1015001383', 'client', 'null', 'NULL', 'aflajfactory@hotmail.com', '2042626', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(5, 'Al Amal Al Tatwerya Co.', '1010196220', 'client', 'null', 'NULL', 'mr_ashour@dw.com.sa', '0566491494', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(6, 'AL HOBAIL MEDICAL OFFICE', '1010055488', 'client', 'null', 'NULL', 'waleed@al-hobail.com', '+966 505558566', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(7, 'Al-YEMNI GROUP CO.', '1010156975', 'client', 'null', 'NULL', 'abdulkarim-e@yemni.com', '966532000000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(8, 'ALMAIASSA COMPANY', '1010524248', 'client', 'null', 'NULL', 'hr@almyassah.com', '0554143336', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(9, 'ALRAED FOOD AND TRADING CO.', '1010438727', 'client', 'null', 'NULL', 'a.qader@alraedsa.com', '0557977663', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(10, 'ALSULTAN ENTPS', '1010235068', 'client', 'null', 'NULL', 'yas_ser_pop@hotmail.com', '0509760550', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(11, 'Amjad Al-Jazira Holding Co.', '1010138905', 'client', 'null', 'NULL', 'JAZERA@gmail.com', '01-4944704', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(12, 'Bayat Hotel Services', '5855051528', 'client', 'null', 'NULL', 'ae.bhkm@bayathotels.com', '966 17 221 1111', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(13, 'BEEAH PLANNERS ARCHITECTS AND ENGINEERS', '1010461905', 'client', 'null', 'NULL', 'naif.alfarhan@beeah.sa', '0562635666', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(14, 'Canal Regional Company', '11010101010', 'client', 'null', 'NULL', 'abdulrehman@alobaidgroup.com', '0566878572', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(15, 'CARIBOU COFFEE', '1010238666', 'client', 'null', 'NULL', 's.ahmed@cariboucoffee.com.sa', '0540008501', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(16, 'FACTORY OF ALJAZIRA DEVELOPMENT CO.', '1010256553', 'client', 'null', 'NULL', 'samirelkhalil@jdco.com.sa', '966536000000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(17, 'Future Company for Construction Material', '5855035352', 'client', 'null', 'NULL', 'ssultan@tsccolor.com', '536676677', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(18, 'GALVANCO Co.', '1010026063', 'client', 'null', 'NULL', 'info@galvanco.com', '966113000000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(19, 'GOSI', '45666', 'client', 'null', 'NULL', 'kaburgubah@gosi.gov.sa', '0553880002', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(20, 'HAJOR ARABIA FOR FOODS', '10100863399', 'client', 'null', 'NULL', 'anithk@hajorfood.com', '0504828108', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(21, 'KANOLLI FOOD INDUSTRIES LTD. CO.', '1010074664', 'client', 'null', 'NULL', 'hatimcone@gmail.com', '0112651420', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(22, 'KSB HOLDING COMPANY', '1010415127', 'client', 'null', 'NULL', 'aalshouri@ksbholding.com', '966540000000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(23, 'MADAR AL ALALWAN EST', '1010252789', 'client', 'null', 'NULL', 'ramy.elhussainy@gmail.com', '531 477 926', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(24, 'Manakh Shebah Al - Jazeerah Trading Co.  MSJ', '1010098069', 'client', 'null', 'NULL', 'haya.m@ehr.sa', '502189743', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(25, 'MMLAKAT ALQEMAH EST', '1015001960', 'client', 'null', 'NULL', 'AMIRSAMY1987@YAHOO.COM', '0548945029', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(26, 'MODERN MACHINERY MANUFACTURING CO LIMITED', '1010269006', 'client', 'null', 'NULL', 'm.saleh@modern-machinery.net', '0541852935', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(27, 'NEMA POULTRY TRADING CO', '7003017758', 'client', 'null', 'NULL', 'aessam@jazeerapaints.com', '0596546755', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(28, 'RAZ HOLDING GROUP', '1010266498', 'client', 'null', 'NULL', 'esam@raz.com.sa', '966566000000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(29, 'Riyadh specialized co & associates for vehicle damage assessment ( BARCODE )', '1010594502', 'client', 'null', 'NULL', 'a.alshaya@barcode-sa.com', '0546866615', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(30, 'SANAR COMPANY', '1010452275', 'client', 'null', 'NULL', 'a.alamri@sanar.sa', '0555598449', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(31, 'SMO ALRESALA', '1010517848', 'client', 'null', 'NULL', 'hr@ways-sa.com', '0509339939', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(32, 'SUPPLIES SOLUTIONS CO. L.L.C', '1010306379', 'client', 'null', 'NULL', 'Accounting@supplies-solutions.com', '00966-1-215-4714', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(33, 'Tinting Systems Co', '10101010100', 'client', 'null', 'NULL', 'ssultan@tsccolor.com', '00966-536676677', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(34, 'YAZEED AL THENYAN ENGINEERING CONSULTANCY', '1010396909', 'client', 'null', 'NULL', 'yazeed@indexa.sa', '0504445240', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(35, 'Sulb Al Jazeera Concrete Manufacturing', '2050092468', 'client', 'null', 'NULL', 'aomar@sulbaljazeera.com', '054 009 1215', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(36, 'PRINCE BANDAR BIN FAISAL AL SAUD', '1006971848', 'client', 'null', 'NULL', 'Sultan-M-albishi@outlook.sa', '0540000914', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(37, 'UNITY NEW', '1010561906', 'client', 'null', 'NULL', 'deemasalloum@trendmena.net', '0569663460', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(38, 'PHARMACY TARIQ FAQEEH', '7005632935', 'client', 'null', 'NULL', 'faisal@smart-medica.com', '0501234117', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(39, 'DALLAH HOSPITAL COMPANY', '1111', 'client', 'null', 'NULL', 'm.alabdullatif@dbroker.com.sa', '1234567', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(40, 'MODERN TECHNOLOGY COMPANY(MOTECO)', '1010182404', 'client', 'null', 'NULL', 'b.alshammari@moteco.com', '0533520550', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(41, 'Al Nadeg Restaurant', '1010247409', 'client', 'null', 'NULL', 'acc@alnadeg.com', '0508800772', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(42, 'DR MOHAMMD ALFAGEEH AND PARTNERS CO', '7001844898', 'client', 'null', 'NULL', 'waad.aldoussary@dmf.med.sa', '00966114917871', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(43, 'thamer alhenaiwy lawyer and leagal consultation', '7019945695', 'client', 'null', 'NULL', 'thamerlawyer1@gmail.com', '0507026414', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(44, 'Salil limited company', '1010559922', 'client', 'null', 'NULL', 'msalem@salil-ltd.com', '0569181096', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(45, 'Muhammad Ali Al Habib Group', '7005314534', 'client', 'null', 'NULL', 'M_ALIALHABIB@YAHOO.COM', '0509640279', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(46, 'tayf najd group', '7002019243', 'client', 'null', 'NULL', 'sarah@teefnajd.com.sa', '0568885786', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(47, 'HERFAH', '7008247236', 'client', 'null', 'NULL', 'admin2@herfah.org.sa', '0594006640', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(48, 'GREENS CORNERS MEDICAL COMPANY', '1010406300', 'client', 'null', 'NULL', 't.alhamdan@greenscorners.com', '0547411119', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(49, 'Yousef Al Rajhi group', '7001697916', 'client', 'null', 'NULL', 'gm@alrajhishared.com', '0593440443', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(50, 'FAST COMPUTERS TRADING EST', '7016065646', 'client', 'null', 'NULL', 'mshaban@fastcompu.com', '0502881719', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(51, 'Hassan rayes estatement', '7001872444', 'client', 'null', 'NULL', 'hossam@hr4trade.com', '0550757609', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(52, 'Masar Scientific Company EVENT-07963', '123456', 'client', 'null', 'NULL', 'badr.alzain@yahoo.com', '0501094546', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(53, 'Al Barrak Medical Complex', '1010109424', 'client', 'null', 'NULL', 'albarrakclinic@yahoo.com', '0559072756', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(54, 'al moallem saudi holdimg company', '1010570609', 'client', 'null', 'NULL', 'a.almosawa@almoallem-h.com', '0551515645', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(55, 'ID WORK INTERIOR INC SPC', '7017573010', 'client', 'null', 'NULL', 'E.sabalilag@idworksglobal.com', '0567143517', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(56, 'Abdulrahman A. B Jazzar consulting engineers office', '7003623993', 'client', 'null', 'NULL', 'hani@jazzar-consult.com', '0505631118', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(57, 'MINISTRY OF TRANSPORT AND LOGISTIC SERVICES', '44124', 'client', 'null', 'NULL', 'k_hiring@mot.gov.sa', '0550331262', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(58, 'Fareaz for trading and marketing', '7001456941', 'client', 'null', 'NULL', 'batoolfareaz@gmail.com', '0555170217', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(59, 'ESTABLISHMENT GOLDEN FORSETAK FOR TRADING', '1010688492', 'client', 'null', 'NULL', 'mokhter_ja@hotmail.com', '0557656310', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(60, 'AZURE CAR showroom company', '1010781529', 'client', 'null', 'NULL', 'azure.co.sa@gmail.com', '0502508829', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(61, 'Seyaj company for security Guards', '7001463491', 'client', 'null', 'NULL', 'hr@seyaj.net', '0531009598', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(62, 'first choice arabia', '7021530196', 'client', 'null', 'NULL', 'anees.alamir@ismaeeljoman.com', '0552255993', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(63, 'OPM by OLAAT real estate', '1010222630', 'client', 'null', 'NULL', 'info@olaat.com', '0112933977', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(64, 'CAPADEV', '7006098995', 'client', 'null', 'NULL', 'cazzi@capadev.com', '0504571192', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(65, 'Maldives Embassy', '1234567', 'client', 'null', 'NULL', 'karima@maldivesembassy.com.sa', '0557212713', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(66, 'SAUDI TEC', '7000123278', 'client', 'null', 'NULL', 'a.aldosari@saudi-tech.com.sa', '0507489902', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(67, 'FDAK TRADING CO', '7001684377', 'client', 'null', 'NULL', 'asf@fidakcom.com', '0532146532', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(68, 'RAWASI', '7002547789', 'client', 'null', 'NULL', 'INFO@RAWASI-SA.COM', '0590070446', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(69, 'Saeed Bin Abdulrahman Bin Saad Al Yemni', '1001443637', 'client', 'null', 'NULL', 'basem@yemni.com', '0560378533', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(70, 'MASAS ALWATANIA', '1010177988', 'client', 'null', 'NULL', 'doaa@massasmedical.com', '0572350501', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(71, 'Engineering Projects for Consultancy', '7002153653', 'client', 'null', 'NULL', 'projectshouseec@gmail.com', '0501755537', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(72, 'KHABEER', '7003006793', 'client', 'null', 'NULL', 'training@alkhabeer.org', '0504190282', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(73, 'Al Habbari Group for Operation and Maintenance', '7001937643', 'client', 'null', 'NULL', 'asalajlan14@gmail.com', '0549229222', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(74, 'RASHED ALGHONAIM LAW FIRM', '7001721112', 'client', 'null', 'NULL', 'h.alghimlas@dbroker.com.sa', '966503000000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(75, 'AL SARH ALSHAMIKH MEDICAL COMPANY', '1138786865', 'client', 'null', 'NULL', 'reemasaifalsaif@gmail.com', '0534369403', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(76, 'petrogen', '7008710928', 'client', 'null', 'NULL', 'mustafa@petrogen.com', '0546067505', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(77, 'ABR ALHUDOOD CO.', '7013430306', 'client', 'null', 'NULL', 'aldhawi@abralhudood.com', '0543215555', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(78, 'Fun Learning Discovry', '1010292029', 'client', 'null', 'NULL', 'Dr_batarfi2@hotmail.com', '0566294477', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(79, 'AHMED ROSHDY FACTORY', '1010290448', 'client', 'null', 'NULL', 'rushdigroup@yahoo.com', '0560802028', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(80, 'Trading Construction Maintenance', '7012014093', 'client', 'null', 'NULL', 'Alqorrah.est@gmail.com', '0555781619', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(81, 'AMSY', '5850028435', 'client', 'null', 'NULL', 'hr@amsyclassic.com', '0553141581', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(82, 'RABWAH TIC', '7030360262', 'client', 'null', 'NULL', 'm.alrasheed@dbroker.com.sa', '0542088186', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(83, 'aleen co', '7001898050', 'client', 'null', 'NULL', 'khaled@aleengroup.com', '0552720000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(84, 'PCLAND', '4030275253', 'client', 'null', 'NULL', 'sando100.sk@gmail.com', '0565004733', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(85, 'Mawakeb alkhair company for commercial services', '4030451134', 'client', 'null', 'NULL', 'mawakbco@gmail.com', '0540005585', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(86, 'Vairom Company for Agricultural Pesticides', '5855354657', 'client', 'null', 'NULL', 'transportation@jazeerapaints.com', '0553787412', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(87, 'FIRST DELTA WORKS', '1010276357', 'client', 'null', 'NULL', 'RAMY@DELTA.COM.SA', '0534369403', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(88, 'National Recruitment Company', '7001737928', 'client', 'null', 'NULL', 'a.alwahedi@Natrec.com', '0542088186', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(89, 'Season Co', '7009436465', 'client', 'null', 'NULL', 'nizar@season.com.sa', '0559255339', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(90, 'Roots', '7029904138', 'client', 'null', 'NULL', 'jamil@desert-roots.com', '0534369403', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(91, 'MODERN ART', '1010819002', 'client', 'null', 'NULL', 'alsarra@mazaya.com.sa', '0534369403', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(92, 'EDECS AL DAWLIA FOR CONTRACTING', '1010871959', 'client', 'null', 'NULL', 'm.elmasry@aiibroker.com', '+20 122 555 5939', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(93, 'Alsaif Coffee trading co', '1010463682', 'client', 'null', 'NULL', 'info@alsaifcoffee.com', '504540639', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(94, 'Masdar Food Supply', '7017445417', 'client', 'null', 'NULL', 'hr@masdar-lmi.com', '0550009376', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(95, 'JACK ALSAUDIA co', '1010318603', 'client', 'null', 'NULL', 'a.ayman@jacksaudia.com', '0534369403', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(96, 'nawafith alshahad', '7003465858', 'client', 'null', 'NULL', 'ehab.reda@live.com', '0548182135', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(97, 'Asia Typical trad co', '4030095958', 'client', 'null', 'NULL', 'ASIA.123@yahoo.com', '0536590047', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(98, 'havana', '7032815602', 'client', 'null', 'NULL', 'hr@havana.com.sa', '0112634222', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(99, 'Maxus Arabia Limited Co', '7034002506', 'client', 'null', 'NULL', 'fadi@gmail.com', '0583720000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(100, 'Built Industrial Co', '7001524656', 'client', 'null', 'NULL', 's.mauntol@built.com.sa', '0565955567', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(101, 'POINTS INFORMATION TECHNOLOGY CO', '10107397730', 'client', 'null', 'NULL', 'ethar@pointsksa.com', '0534369403', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(102, 'Lourd garden', '7013936187', 'client', 'null', 'NULL', 'r.algarhy@dbroker.com.sa', '7013936187', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(103, 'JEDDAH MALDIVE EMBASSY', '1111111111', 'client', 'null', 'NULL', 'aisha@foreign.gov.mv', '0549365604', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(104, 'SIKA AlArabiya Est . For Logistics service', '101086144', 'client', 'null', 'NULL', 'eee123eee@msn.com', '0548739593', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(105, 'MUEEN HUMAN RESOURCES COMPANY', '7018066105', 'client', 'null', 'NULL', 'n.alzoman@mueen.com.sa', '0555011765', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(106, 'TAKWENAT', '1001010101', 'client', 'null', 'NULL', 'b.alshaya@dbroker.com.sa', '0555598380', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(107, 'Penetron Gulf Trading Company', '7027531636', 'client', 'null', 'NULL', 'ayman.fayed@penetron.com', '0556061777', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(108, 'Isotech co.', '7035076657', 'client', 'null', 'NULL', 'admin2@isotechco.com', '0552341089', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(109, 'Dar Book Experts', '1010010101', 'client', 'null', 'NULL', 'abdoashour678@gmail.com', '0554944406', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(110, 'BEEAH AMAL', '1010448464', 'client', 'null', 'NULL', 'info@beeahb.com', '0562635666', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(111, 'HUDHUD CO', '1010101010', 'client', 'null', 'NULL', 'hr@hudhud.sa', '0555598449', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(112, 'itfour', '1010766687', 'client', 'null', 'NULL', 'a.alqahtani@it4bsa.com', '00966555321655', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(113, 'fifth element', '7034345415', 'client', 'null', 'NULL', 'admin.ksa@5th-element.ae', '0538358153', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(114, 'Shahin digital information technology company', '1010761071', 'client', 'null', 'NULL', 'info@shahin.com.sa', '0555558880', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(115, 'Karam Al-afaq General Cont Est.', '7003628489', 'client', 'null', 'NULL', 'recycle.experts2@gmail.com', '0538932431', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(116, 'CLINLIA', '7024136546', 'client', 'null', 'NULL', 'nalgedeebi@clinlia.com', '0555499153', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(117, 'Est Aman Company For Metal Products', '7001567796', 'client', 'null', 'NULL', 'mametals@hotmail.com', '0122884790', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(118, 'KHOBARA ALTADWEER', '10101101010', 'client', 'null', 'NULL', 'recycle.experts2@gmail.com', '0538932431', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(119, 'Nami Luna space business services co.', '1010666657', 'client', 'null', 'NULL', 'ahmed.basfar@namipay.com.sa', '+966 54 551 7070', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(120, 'Development solution for contracting', '7016005121', 'client', 'null', 'NULL', 'gm@ds-cons.com', '0538358153', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(121, 'Afkar advertising agency', '7029061640', 'client', 'null', 'NULL', 's.alshehri@dbroker.com.sa', '0551443653', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(122, 'Abdullah ALsayed', '1010032384', 'client', 'null', 'NULL', 'a.awad@alsayedgroup.com', '0500176796', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(123, 'mithaq alomran', '7003359200', 'client', 'null', 'NULL', 'SHATHA.1099@ICLOUD.COM', '114935518', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(124, 'NOVAsat Commercial Company', '1010209253', 'client', 'null', 'NULL', 'mohammed.hussain@novasat.com.sa', '0507994046', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(125, 'Luna space telecommunications Co. Ltd', '1010200776', 'client', 'null', 'NULL', 'ahmed.basfar@namipay.com.sa', '966 54 551 7070', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(126, 'Luna space financial Company', '7009070074', 'client', 'null', 'NULL', 'ahmed.basfar@namipay.com.sa', '+966 54 551 7070', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(127, 'Luna space business services co.ltd.', '1010641358', 'client', 'null', 'NULL', 'ahmed.basfar@namipay.com.sa', '+966 54 551 7070', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(128, 'Nebras financial Company Ltd', '1010685590', 'client', 'null', 'NULL', 'ahmed.basfar@namipay.com.sa', '+966 54 551 7070', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(129, 'Princess Al anoud abdullah alsaud', '1094449533', 'client', 'null', 'NULL', 'ahsraf@hotmail.com', '0558956481', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(130, 'Alsanat Co', '1001101000', 'client', 'null', 'NULL', 'alsanat.sa@gmail.com', '0', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(131, 'united association', '4038385168', 'client', 'null', 'NULL', 'info@ua-lawfirm.com', '0542222689', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(132, 'ALSADRAN REAL ESTATE', '1009016401', 'client', 'null', 'NULL', 'nalsidran@gmail.com', '0555020000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(133, 'FEBC', '1010767938', 'client', 'null', 'NULL', 'a.dajani@febcgroup.com', '0541813322', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(134, 'Marafei Co.', '1010405674', 'client', 'null', 'NULL', 'info@marafei.com', '0536187857', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(135, 'mohammed alabdulatif cars', '1008551804', 'client', 'null', 'NULL', 'oh.hassan98@gmail.com', '0555236411', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(136, 'Ecale attorneys and counselors', '1009027101', 'client', 'null', 'NULL', 'Ghaida@ecalelawfirm.com', '055 283 6823', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(137, 'intellectual content Co.', '1010465410', 'client', 'null', 'NULL', 'Dar.alm@gmail.com', '0537561986', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(138, 'arnad Alshamal contracting co.', '7003028383', 'client', 'null', 'NULL', 'hisham@arnad-sa.com', '0504426274', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(139, 'Abdulrahman Ali Alrashed Law Company', '7037004046', 'client', 'null', 'NULL', 'ahassan@aarl.sa', '0554103710', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(140, 'WAAQS IBRAHIM AL MUSA EST', '7001927867', 'client', 'null', 'NULL', 'Osama.Alsaber@awqafalmousa.com', '0590386030', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(141, 'URBS', '1010877671', 'client', 'null', 'NULL', 'a.alkhmis@hr360s.com', '0536036282', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(142, 'ahmed alshamri', '2057004371', 'client', 'null', 'NULL', 'ahmed@gmail.com', '0', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(143, 'Bandar Saeed Foundation', '1010583688', 'client', 'null', 'NULL', 'm.esam@alemadonline.com', '532680419', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(144, 'Arab Emergency Company Ltd', '1010115601', 'client', 'null', 'NULL', 'admin@altawary.com', '0547631769', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(145, 'East Gulf VCo.', '7008655362', 'client', 'null', 'NULL', 'ibrahim@egulf.com.sa', '0544118707', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(146, 'wild eagle co.', '7042040191', 'client', 'null', 'NULL', 'shatha.1099@icloud.com', '0500749900', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(147, 'Nozom consulting', '7010996655', 'client', 'null', 'NULL', 'alanoud.alharbi@nozomtechs.com', '540344334', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(148, 'Badeel', '23698547', 'client', 'null', 'NULL', 'malajlan@badeel.com.sa', '0536976143', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(149, 'DAN Plastic Products Factory Co', '1010203608', 'client', 'null', 'NULL', 'info@danplastic.com', '0504178701', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(150, 'Luqaimat Mama Noura', '7003978462', 'client', 'null', 'NULL', 'futun@logimatmn.com', '0', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(151, 'AL NAKHEEL PAPER TRADING CO', '1010951454', 'client', 'null', 'NULL', 'Nakheelpaper@hotmail.com', '0558482685', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(152, 'Hihome Co', '1010601502', 'client', 'null', 'NULL', 'nourah.alsadoun@hihome.sa', '0538358153', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(153, 'Mohammed A. Farhat Co. for Contracting', '7001498711', 'client', 'null', 'NULL', 'mohammed@fmcksa.com', '0549349377', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(154, 'Three Event Company', '78425', 'client', 'null', 'NULL', 'ThreeEvent@gmail.com', '53 888 8041', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(155, 'Tadweer alkhair', '1010641053', 'client', 'null', 'NULL', 'recycle.experts2@gmail.com', '0538932431', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(156, 'Top Solutions', '7039190421', 'client', 'null', 'NULL', 'shatha.1099@icloud.com', '0538358153', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(157, 'Aerospace Systems Industrial', '7028852650', 'client', 'null', 'NULL', 'f.qaddan@sciencetech.com.sa', '966 55 223 5718', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(158, 'Systems Builders Co', '1010528768', 'client', 'null', 'NULL', 'a.mohamed@itbuilders.com.sa', '966554000000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(159, 'ABDULLAH IBRAHIM AL-SAYEGH AND SONS COMPANY', '7026298526', 'client', 'null', 'NULL', 'yousef@sayeghwater.com', '0542448743', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(160, 'RKB', '555', 'client', 'null', 'NULL', 'LAITH@RKKB.SA', '0594240978', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(161, 'ALfaraidy National Center', '7002267792', 'client', 'null', 'NULL', 'sultan.group2030@hotmail.com', '53 337 8826', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(162, 'SANA ALANDALUS', '1', 'client', 'null', 'NULL', 'khaledemad@sanaalandalus.sa', '0535622109', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(163, 'Diamond Motors Company', '7021977173', 'client', 'null', 'NULL', 'hababizamami@gmail.com', '59 760 8475', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(164, 'KAYAN', '1010799929', 'client', 'null', 'NULL', 'Mkreak@kayanhr.com', '+962 776 777 222', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(165, 'DERMA HOLDING', '666', 'client', 'null', 'NULL', 'Ahmed.taj@derma.sa', '0500331181', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(166, 'Just Taco', '7034086012', 'client', 'null', 'NULL', 'Sulimanalgathbar@gmail.com', '0554885007', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(167, 'Third Partner Company', '7014262997', 'client', 'null', 'NULL', 'm.albabakri@third-partner.com', '56 3066 508', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(168, 'Consulate General of the Sultanat of Oman.', '7001540587', 'client', 'null', 'NULL', 'Omanjaddeh@hotmail.com', '05636728399', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(169, 'Aknaf Arabia', '777', 'client', 'null', 'NULL', 'notfound@gmail.com', '01125455200', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(170, 'alsad company', '00', 'client', 'null', 'NULL', 'eng.anahla@gmail.com', '0595754340', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(171, 'ARKI', '1010462373', 'client', 'null', 'NULL', 'S.ALDAWOOD@ARKITECTONICA.ORG', '0543878472', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(172, 'Riyadh Travel and Tourism Agency', '7031202836', 'client', 'null', 'NULL', 'norah.saleh@alriyadhtravel.com', '535088800', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(173, 'Contracting Company for General Contracting Limited', '7001583074', 'client', 'null', 'NULL', 'a.alghamdi@alrajhishared.com', '0593004141', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(174, 'AXES SYSTEMS FOR INFOR TECH', '1010326475', 'client', 'null', 'NULL', 'gm@axessystems.net.sa', '50 722 0337', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(175, 'alezdhar and alrafah trading ltd', '7009425625', 'client', 'null', 'NULL', 'm.nasser@ezdhar-ksa.com', '0546664977', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(176, 'AL AWAM', '888', 'client', 'null', 'NULL', 'N@GMAIL.COM', '0502688164', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(177, 'GHANEM', '1009203129', 'client', 'null', 'NULL', 'r.alarjan@ghanem.sa', '0500864242', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(178, 'food platform trading company', '7009667267', 'client', 'null', 'NULL', 'bader@bz.sa', '0563578544', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(179, 'Furniture solutions company', '999', 'client', 'null', 'NULL', 'hanouf.saed@simplecity.sa', '0559085815', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(180, 'Saud AlAdaili Factory', '7013855544', 'client', 'null', 'NULL', 'wisam9999@hotmail.com', '55 744 9560', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(181, 'Salon Features', '7007407344', 'client', 'null', 'NULL', 'sara99925@hotmail.com', '54 247 7754', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(182, 'Specialized Tunnel Company', '7038508573', 'client', 'null', 'NULL', 'm.procurement@sa-tunneling.com', '55 758 6939', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(183, 'Noor Internet for Communications and IT', '7003670481', 'client', 'null', 'NULL', 'mhd.alshammeri@nour.net.sa', '59 594 2315', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(184, 'Fluids Control Contracting Company Ltd', '1010476535', 'client', 'null', 'NULL', 'a.almalki@flucon.co', '55 533 3472', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(185, 'Dome Al Omran Engineering Consultants', '7003828642', 'client', 'null', 'NULL', 'ahmedmargan@qoc.com.sa', '57 041 1112', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(186, 'Dome Al Omran Contracting Company', '7001881221', 'client', 'null', 'NULL', 'ahmedmargan@qoc.com.sa', '57 041 1112', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(187, 'Zaid Abdulrahman AlDabbagh Trading Company', '1010177601', 'client', 'null', 'NULL', 'Zaid.co2020@gmail.com', '966504000000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(188, 'Arabco', '1010415318', 'client', 'null', 'NULL', 'karim@altawary.com', '0547631791', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(189, 'Princess Mashael', '100', 'client', 'null', 'NULL', 'sayedsilkawy@gmail.com', '966503000000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(190, 'Hajen Printing Press', '7001574602', 'client', 'null', 'NULL', 'hr@hajen.sa', '0535904225', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(191, 'Mashaal AlMajd Company', '101', 'client', 'null', 'NULL', 'mohammed@amjadalsoraa.com', '0530794166', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(192, 'Gama International Limited LLC', '7010754211', 'client', 'null', 'NULL', 'a.ghozlan@gamadwc.com', '0540013971', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(193, 'National Centre for Non Profit Sector', '1234', 'client', 'null', 'NULL', 'n.alkathiri.t@ncnp.gov.sa', '0', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(194, 'al marwani', '102', 'client', 'null', 'NULL', 'almarwanistore@gmail.com', '0554850143', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(195, 'Hana Trading Establishment', '7029303753', 'client', 'null', 'NULL', 'info@beeahb.com', '0535977276', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(196, 'alsamil', '700121686', 'client', 'null', 'NULL', 'hr@alsamilgroup.com', '0568724414', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(197, 'esnad', '1010846397', 'client', 'null', 'NULL', 'R.alsaleh@esnad.sa', '0536017337', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(198, 'ALMALATH CONTRACT CO', '7002449606', 'client', 'null', 'NULL', 'm.aldhuyufi@dbroker.com.sa', '0552131670', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(199, 'alrayyah alshamsia', '7002930340', 'client', 'null', 'NULL', 'e.hassan@arkitectonica.org', '0543878472', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(200, 'Dima United Company', '7005598045', 'client', 'null', 'NULL', 'hr@deemaunited.com', '+966 56 933 4306', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(201, 'ALrouqi rent car', '4030185694', 'client', 'null', 'NULL', 'dsfj2026@gmail.com', '966 53 940 2295', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(202, 'Muthmirah Riyadh Food', '1010895957', 'client', 'null', 'NULL', 'halmajhadi@mrfoods.sa', '0540821712', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(203, 'alsalim united', '7007084754', 'client', 'null', 'NULL', 'Ghareeb@alsalimi.sa', '0555050904', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(204, 'Skyroses Smart Contracting', '1010946032', 'client', 'null', 'NULL', 'albandrimohamad71@gmail.com', '0508258140', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(205, 'abniya Limited Company', '7023837607', 'client', 'null', 'NULL', 'w.alghamdi@abniyaksa.com', '+966 53 548 9497', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(206, 'Talib Hamid AlShammari Company', '7014733765', 'client', 'null', 'NULL', 'tasaa2017@gmail.com', '+966 50 159 6538', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(207, 'ORBITA', '1010962845', 'client', 'null', 'NULL', 'Rifaat@orbitatechs.com', '0509001517', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(208, 'United Pharma Trading Co', '1010187079', 'client', 'null', 'NULL', 'wed.almashoq@adam.med.sa', '0565542223', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(209, 'nuts and spices co ltd', '7002516198', 'client', 'null', 'NULL', 'bader@bz.sa', '+966 56 357 8544', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(210, 'Luna space telecommunications Holding', '7034650692', 'client', 'null', 'NULL', 'h.hashem@dbroker.com.sa', '0530685650', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(211, 'Luna space telecommunications Co.', '7032756368', 'client', 'null', 'NULL', 'H.HASHEM@DBROKER.COM.SA', '0530685650', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(212, 'profssionalism for physiotherpy', '7003462871', 'client', 'null', 'NULL', 'Y-abed@outlook.com', '0542448743', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(213, 'ANR Almarefa', '1009014273', 'client', 'null', 'NULL', 'info@anr.com.sa', '0540344334', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(214, 'Kerten Saudi Administrative Company', '1010643158', 'client', 'null', 'NULL', 'H.HASHEM@DBROKER.COM.SA', '0530685650', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(215, 'Manar National Contracting Company', '7014957471', 'client', 'null', 'NULL', 'manaralwataniya@gmail.com', '+966 56 934 8573', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(216, 'wathaeiq almarifa', '1010599263', 'client', 'null', 'NULL', 'Rifaat@orbitatechs.com', '0509001517', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(217, 'Zoom For Operation', '7050096077', 'client', 'null', 'NULL', 'finance@zoom-opr.com', '0562594776', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(218, 'voila', '1010860670', 'client', 'null', 'NULL', 'samialdawood10@gmail.com', '0543878472', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(219, 'rawasl alhawsabah', '7050587125', 'client', 'null', 'NULL', 'abdo@rawasi.tech', '0582765100', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(220, 'Creative Block Company', '7002791536', 'client', 'null', 'NULL', 'Sfalamban@Blocksgroup.com', '+966 50 449 6664', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(221, 'ismail alhamrani', '1010852325', 'client', 'null', 'NULL', 'samaher@alhamrani-sa.com', '0538786797', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(222, 'AlIhaad Trading Company', '7002295967', 'client', 'null', 'NULL', 'Abdullah@gmail.com', '+966 59 639 3949', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(223, 'first millennium est', '1010494139', 'client', 'null', 'NULL', 'info@fm-sec.com', '0503192988', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(224, 'Ophira', '1010144737', 'client', 'null', 'NULL', 'alshajiri@gmail.com', '0565226567', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(225, 'Hospitality Board Co', '7001770572', 'client', 'null', 'NULL', 'eisa@hbbrands.com', '0591116080', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(226, 'YUNNHAL LOGISTICS SERVICES', '7036545296', 'client', 'null', 'NULL', 'hababizamami@gmail.com', '+966 55 972 1878', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(227, 'Haifa Saeed Trading Establishment', '7006073998', 'client', 'null', 'NULL', '3marazizo92@gmail.com', '966558000000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(228, 'Sakha Real Estate Services Company', '7049442036', 'client', 'null', 'NULL', 'khalid@skh.sa', '+966 54 803 1545', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(229, 'RAFIA Company', '7037488645', 'client', 'null', 'NULL', 'mam.Alangari@gmail.com', '+966 50 803 1331', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(230, 'ACFA Compny', '7001782411', 'client', 'null', 'NULL', 'Saud@acfasa.com', '+966 53 853 8747', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(231, 'Masat Alwatan', '7003117293', 'client', 'null', 'NULL', 'Masat.alwtan@gmail.com', '0556789571', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(232, 'Alameh Health and Nature Trading Company', '1009115782', 'client', 'null', 'NULL', 'ahmad.ayesh@advanced-me.com', '+966 58 222 6070', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(233, 'Advanced Construction Solutions for Contracting', '7006903251', 'client', 'null', 'NULL', 'a.abdulsalam@dbroker.com.sa', '+966 55 055 3709', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(234, 'alqabs color', '103', 'client', 'null', 'NULL', 'Walidzarour-1@windowslive.com', '0504174902', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(235, 'Al Alameyn Al Alamiya', '2051219980', 'client', 'null', 'NULL', 'h.hashem@dbroker.com.sa', '0530685650', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(236, 'Abdulelah alathel', '1009164667', 'client', 'null', 'NULL', 'A.alathel@aalathel.com', '0554444133', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(237, 'Bee Sports Company', '7027868491', 'client', 'null', 'NULL', 'muath_mali@yahoo.com', '+966 50 398 0159', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(238, 'SYNERGY', '7051516354', 'client', 'null', 'NULL', 'moraadalomari9@gmail.com', '0562594776', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(239, 'RETAJ AL MASKAN', '1010786954', 'client', 'null', 'NULL', 'Reetag01@hotmail.com', '0534141857', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(240, 'IGT Distribution', '7050190375', 'client', 'null', 'NULL', 'info@igt.sa', '920004778', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(241, 'Preparation smart Company', '7050079925', 'client', 'null', 'NULL', 'Diala@cookandcraft.io', '+966 53 548 9497', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(242, 'T ten', '7040829777', 'client', 'null', 'NULL', 'info@t-10.me', '0500000000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(243, 'Faisal Alothaim', '1010747843', 'client', 'null', 'NULL', 'info@alothaimlaw.com', '0554488865', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(244, 'AlBawarq Arab Trading Company', '104', 'client', 'null', 'NULL', 'munays@albawariq.com', '+966 53 399 3917', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(245, 'alhamdan', '105', 'client', 'null', 'NULL', 'Moassaalhmdan@gmail.com', '0557188899', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10');
INSERT INTO `clients` (`id`, `name`, `code`, `type`, `industry`, `contact_name`, `contact_email`, `contact_phone`, `address`, `country`, `account_manager_id`, `status`, `metadata`, `created_at`, `updated_at`) VALUES
(246, 'WOSUL Information retail solutions', '7017151825', 'client', 'null', 'NULL', 'a.shaheen@wosul.sa', '+966 54 181 9323', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(247, 'Al Naifat Contracting Company', '7003113573', 'client', 'null', 'NULL', 'sdyqmhmdabwbkr6@gmail.com', '+966 54 595 0439', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(248, 'Advanced Events Creativity Company', '7051466196', 'client', 'null', 'NULL', 'ahmad.ayesh@advanced-me.com', '+966 58 222 6070', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(249, 'Two Now Elite Company', '7050541635', 'client', 'null', 'NULL', 'contact.townow@gmail.com', '+966 53 268 0419', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(250, 'Marin Platform IT Company a single person company', '106', 'client', 'null', 'NULL', 'malsabeeh@marn.io', '+966 55 088 3891', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(251, 'TOWARD THE FUTURE CAPITAL', '1009028933', 'client', 'null', 'NULL', 'bGizuli@Ttf.com.sa', '0500116531', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(252, 'NEZEL AL-JANAUB LADARA AL-FANADAQ AND MUNTIJAAT', '4651103750', 'client', 'null', 'NULL', 'h.hashem@dbroker.com.sa', '0530685650', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(253, 'Happiness suite', '1010905352', 'client', 'null', 'NULL', 'talatghiad@gmail.com', '0542316307', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(254, 'BLABAN', '7040613692', 'client', 'null', 'NULL', 'almtsmbdynallh6@gmail.com', '+966 54 274 4279', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(255, 'CROWN ARABIA CAN CO. LTD', '7000331038', 'client', 'null', 'NULL', 'abdulaziz.alghefari@eur.crowncork.com', '+966 50 708 4486', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(256, 'CROWN JEDDAH BEVERAGE CAN FACTORY', '7014241272', 'client', 'null', 'NULL', 'abdulaziz.alghefari@eur.crowncork.com', '+966 50 708 4486', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(257, 'The Performance', '1010390482', 'client', 'null', 'NULL', 'fahadalbercha@gmail.com', '0508082775', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(258, 'Darry Al Qadimeh for touristic and accommodation Manager', '4651104269', 'client', 'null', 'NULL', 'aali@kertenhospitality.com', '0530685650', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(259, 'Hala Sports Community Club Foundation', '70173245505', 'client', 'null', 'NULL', 'alanoud@halacf.com', '+966 55 614 1465', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(260, 'MAKARIM', '1128019653', 'client', 'null', 'NULL', 'A@gmail.com', '0565351405', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(261, 'Josoor', '1010940700', 'client', 'null', 'NULL', 'abdulrahman@josoor.sa', '0555668270', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(262, 'Abdullah Hamad AlHammad Investment Company', '107', 'client', 'null', 'NULL', 'acc-mazin@alhammadholding.net', '+966 55 325 5171', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(263, 'Abdul Karim Muhammad Mansour Battati Law Firm', '7023422285', 'client', 'null', 'NULL', 'ammhhb@gmail.com', '0563207207', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(264, 'Abouh AlBunn Company forIndustry', '108', 'client', 'null', 'NULL', 'HR@nahjroastery.com', '+966 55 461 3812', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(265, 'Cognna', '1010784727', 'client', 'null', 'NULL', 'a.ajmi@dbroker.com.sa', '0537332709', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:10', '2026-04-27 12:50:10'),
(266, 'TILAL ALBINNA', '7028269129', 'client', 'null', 'NULL', 'moniem@etat-est.com', '0555258068', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:11', '2026-04-27 12:50:11'),
(267, 'saad alqahtani Est', '70180180734', 'client', 'null', 'NULL', 'alqhtani2088@gmail.com', '0582858521', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:11', '2026-04-27 12:50:11'),
(268, 'Amal Salon', '1010876019', 'client', 'null', 'NULL', 'a@gmail.com', '0500000000', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:11', '2026-04-27 12:50:11'),
(269, 'sanabel ohad', '109', 'client', 'null', 'NULL', 'hr2@wfoodco.com', '0552503881', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:11', '2026-04-27 12:50:11'),
(270, 'alcatop', '110', 'client', 'null', 'NULL', 'W.awadallah@alcatop-git.com', '0581477799', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:11', '2026-04-27 12:50:11'),
(271, 'Digital Projects Company', '7051919313', 'client', 'null', 'NULL', 'Rudwan@dgprojx.com', '0549068568', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:11', '2026-04-27 12:50:11'),
(272, 'Power networks co', '1010438229', 'client', 'null', 'NULL', 'm.alharbi@pnc.com.sa', '0504527479', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:11', '2026-04-27 12:50:11'),
(273, 'osan', '1010877666', 'client', 'null', 'NULL', 'hr@osanoptics.com', '0504509783', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:11', '2026-04-27 12:50:11'),
(274, 'Nine Steps Trading Company', '7017577755', 'client', 'null', 'NULL', 'HR@NINESTEPSA.COM', '0555919262', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:11', '2026-04-27 12:50:11'),
(275, 'Jyad Capital', '7053143751', 'client', 'null', 'NULL', 'nourah.j@jyad.sa', '0506504020', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:11', '2026-04-27 12:50:11'),
(276, 'dhay alhalal', '1131325872', 'client', 'null', 'NULL', 'moh_alhabeeb@yahoo.com', '0567017929', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:11', '2026-04-27 12:50:11'),
(277, 'ocean parts co', '7009420386', 'client', 'null', 'NULL', 'a.alolayan@opc-s.com', '0531928700', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:11', '2026-04-27 12:50:11'),
(278, 'KHAM COMPANY', '7034197900', 'client', 'null', 'NULL', 'Khamcarton@gmail.com', '+966 59 888 2614', 'NULL', 'Saudi arabia', NULL, 'active', NULL, '2026-04-27 12:50:11', '2026-04-27 12:50:11'),
(279, 'Bupa', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(280, 'Tawuniya', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(281, 'Medgulf', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(282, 'Wataniya (SNIC)', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(283, 'Gulf General Insurance (GGI)', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(284, 'SAICO', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(285, 'Malath', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(286, 'CHUBB', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(287, 'Rajhi Takaful', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(288, 'Gulf Union', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(289, 'Amana', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(290, 'ACIG', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(291, 'Saqer', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(292, 'Salama', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(293, 'Al inma Tokio Marine', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(294, 'UCA', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(295, 'LIVA', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(296, 'Arabian Shield', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(297, 'Enaya', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(298, 'Al Etihad', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(299, 'AICC Arabia', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(300, 'Buruj', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(301, 'walaa', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(302, 'GIG', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(303, 'Aljazira takaful/solidarity', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(304, 'CIGNA', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54'),
(305, 'Mutakamela', NULL, 'insurer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, '2026-04-28 06:56:54', '2026-04-28 06:56:54');

-- --------------------------------------------------------

--
-- Table structure for table `complaints`
--

CREATE TABLE `complaints` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reference_no` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `complainant_type` enum('client','vendor','employee','public','regulator','other') NOT NULL DEFAULT 'client',
  `complainant_name` varchar(200) DEFAULT NULL,
  `complainant_email` varchar(200) DEFAULT NULL,
  `complainant_phone` varchar(50) DEFAULT NULL,
  `client_id` bigint(20) UNSIGNED DEFAULT NULL,
  `assignee_id` bigint(20) UNSIGNED DEFAULT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `severity` enum('low','medium','high','critical') NOT NULL DEFAULT 'medium',
  `status` enum('received','acknowledged','under_investigation','pending_resolution','resolved','closed','escalated','withdrawn') NOT NULL DEFAULT 'received',
  `source` enum('email','phone','web_form','in_person','social_media','regulator','other') NOT NULL DEFAULT 'email',
  `received_date` datetime NOT NULL,
  `acknowledged_date` datetime DEFAULT NULL,
  `target_resolution_date` datetime DEFAULT NULL,
  `actual_resolution_date` datetime DEFAULT NULL,
  `root_cause` text DEFAULT NULL,
  `resolution` text DEFAULT NULL,
  `customer_satisfaction` tinyint(4) DEFAULT NULL,
  `is_regulatory` tinyint(1) NOT NULL DEFAULT 0,
  `escalation_level` int(11) NOT NULL DEFAULT 0,
  `escalated_to_id` bigint(20) UNSIGNED DEFAULT NULL,
  `capa_required` tinyint(1) NOT NULL DEFAULT 0,
  `capa_id` bigint(20) UNSIGNED DEFAULT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `complaints`
--

INSERT INTO `complaints` (`id`, `reference_no`, `title`, `description`, `category_id`, `complainant_type`, `complainant_name`, `complainant_email`, `complainant_phone`, `client_id`, `assignee_id`, `department_id`, `severity`, `status`, `source`, `received_date`, `acknowledged_date`, `target_resolution_date`, `actual_resolution_date`, `root_cause`, `resolution`, `customer_satisfaction`, `is_regulatory`, `escalation_level`, `escalated_to_id`, `capa_required`, `capa_id`, `attachments`, `created_at`, `updated_at`, `created_by`) VALUES
(1, 'CMP-2026-0001', 'complaint1', 'fdsdf sfs fdsf sfs', 16, 'client', 'Unknown', NULL, NULL, NULL, 18, NULL, 'medium', 'acknowledged', 'email', '2026-04-19 00:00:00', NULL, '2026-04-20 15:31:35', NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, '2026-04-19 12:31:35', '2026-05-03 11:53:10', NULL),
(2, 'CMP-2026-0002', 'test', 'hgff', 9, 'client', 'Unknown', NULL, NULL, NULL, NULL, NULL, 'medium', 'received', 'email', '2026-05-03 00:00:00', NULL, '2026-05-04 16:04:06', NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, '2026-05-03 13:04:06', '2026-05-03 13:04:06', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `complaint_categories`
--

CREATE TABLE `complaint_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `sla_hours` int(11) NOT NULL DEFAULT 72
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `complaint_categories`
--

INSERT INTO `complaint_categories` (`id`, `name`, `description`, `sla_hours`) VALUES
(1, 'Service Quality', 'Complaints about service quality', 48),
(2, 'Billing & Payment', 'Financial and billing disputes', 24),
(3, 'Staff Conduct', 'Complaints about employee behavior', 72),
(4, 'Process & Procedure', 'Process-related complaints', 48),
(5, 'System & Technology', 'Technology failures affecting service', 24),
(6, 'Communication', 'Communication breakdowns', 48),
(7, 'Regulatory', 'Regulatory-related complaints', 24),
(8, 'Service Quality', 'Complaints about service quality', 48),
(9, 'Billing & Payment', 'Financial and billing disputes', 24),
(10, 'Staff Conduct', 'Complaints about employee behavior', 72),
(11, 'Process & Procedure', 'Process-related complaints', 48),
(12, 'System & Technology', 'Technology failures affecting service', 24),
(13, 'Communication', 'Communication breakdowns', 48),
(14, 'Regulatory', 'Regulatory-related complaints', 24),
(15, 'Service Quality', 'Complaints about service quality', 48),
(16, 'Billing & Payment', 'Financial and billing disputes', 24),
(17, 'Staff Conduct', 'Complaints about employee behavior', 72),
(18, 'Process & Procedure', 'Process-related complaints', 48),
(19, 'System & Technology', 'Technology failures affecting service', 24),
(20, 'Communication', 'Communication breakdowns', 48),
(21, 'Regulatory', 'Regulatory-related complaints', 24);

-- --------------------------------------------------------

--
-- Table structure for table `complaint_updates`
--

CREATE TABLE `complaint_updates` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `complaint_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `update_type` enum('status_change','comment','escalation','resolution','closure') NOT NULL DEFAULT 'comment',
  `previous_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `notify_complainant` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `complaint_updates`
--

INSERT INTO `complaint_updates` (`id`, `complaint_id`, `user_id`, `update_type`, `previous_status`, `new_status`, `comment`, `notify_complainant`, `created_at`) VALUES
(1, 1, 1, 'comment', 'acknowledged', 'acknowledged', 'Complaint assigned to Turki Al-Abdali', 0, '2026-05-03 11:53:10');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` text DEFAULT NULL,
  `head_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`, `code`, `description`, `head_user_id`, `created_at`, `updated_at`) VALUES
(1, 'Quality Assurance', 'QA', NULL, 2, NULL, NULL),
(2, 'Operations', 'OPS', NULL, 4, NULL, NULL),
(3, 'Information Technology', 'IT', NULL, 5, NULL, NULL),
(4, 'Finance', 'FIN', NULL, 21, NULL, NULL),
(5, 'Human Resources', 'HR', NULL, 6, NULL, NULL),
(6, 'Sales & Marketing', 'SM', NULL, 7, NULL, NULL),
(7, 'Compliance', 'CR', NULL, 18, NULL, '2026-03-05 11:11:56'),
(8, 'Operation - Policy admin', 'PA', NULL, 22, NULL, '2026-03-05 11:12:23'),
(9, 'Technical', 'TE', NULL, NULL, '2026-03-05 11:12:50', '2026-03-05 11:12:50'),
(10, 'Customer Service', 'CS', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

CREATE TABLE `documents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `document_no` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `reviewer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `approver_id` bigint(20) UNSIGNED DEFAULT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `type` enum('policy','procedure','work_instruction','form','template','manual','specification','report','other','announcement') NOT NULL DEFAULT 'procedure',
  `status` enum('draft','under_review','pending_approval','approved','obsolete','superseded') NOT NULL DEFAULT 'draft',
  `version` varchar(20) NOT NULL DEFAULT '1.0',
  `effective_date` date DEFAULT NULL,
  `review_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `file_size` bigint(20) DEFAULT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `is_controlled` tinyint(1) NOT NULL DEFAULT 1,
  `requires_signature` tinyint(1) NOT NULL DEFAULT 0,
  `rejection_reason` text DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`)),
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `documents`
--

INSERT INTO `documents` (`id`, `document_no`, `title`, `description`, `category_id`, `owner_id`, `reviewer_id`, `approver_id`, `department_id`, `type`, `status`, `version`, `effective_date`, `review_date`, `expiry_date`, `file_path`, `file_size`, `mime_type`, `is_controlled`, `requires_signature`, `rejection_reason`, `submitted_at`, `approved_at`, `tags`, `metadata`, `created_at`, `updated_at`) VALUES
(1, 'DOC-20260429-8732', 'Change Management Policy', 'change management process', 1, 38, 38, NULL, NULL, 'procedure', 'draft', '1', NULL, NULL, NULL, 'documents/1671711806_1_Renewal_process.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Renewal_process.pdf\",\"new_name\":\"1671711806_1_Renewal_process.pdf\"}]', '2022-12-22 09:23:00', '2025-06-19 03:45:00'),
(2, 'DOC-20260429-1806', 'test', 'test', 1, 38, 38, NULL, NULL, 'procedure', 'draft', '1', NULL, NULL, NULL, 'documents/1750246935_194_Certificate59967.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Certificate59967.pdf\",\"new_name\":\"1750246935_194_Certificate59967.pdf\"}]', '2025-06-18 08:42:00', '2025-06-18 08:57:00'),
(3, 'DOC-20260429-2755', 'Strategic Partnership Policy-Arabic', 'DRAFT VERSION', 2, 44, 44, NULL, NULL, 'procedure', 'draft', '1', NULL, NULL, NULL, 'documents/1750315769_194_Strategic_partnership_policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Strategic_partnership_policy.pdf\",\"new_name\":\"1750315769_194_Strategic_partnership_policy.pdf\"}]', '2025-06-19 03:47:00', '2025-07-30 06:42:00'),
(4, 'DOC-20260429-3623', 'IT Policies and Procedure', NULL, 1, 38, 38, NULL, NULL, 'procedure', 'draft', '1', NULL, NULL, NULL, 'documents/1751268889_194_Electronic_Receipt_065_2183088365_Jithin_Varkey.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Electronic_Receipt_065_2183088365_Jithin_Varkey.pdf\",\"new_name\":\"1751268889_194_Electronic_Receipt_065_2183088365_Jithin_Varkey.pdf\"}]', '2025-06-30 04:34:00', '2025-06-30 04:36:00'),
(5, 'DOC-20260429-5998', 'الفنية والاكتتاب', 'استخدام التقنية والبيانات لضمان حماية المعلومات، تكامل الأنظمة، وجودة الخدمة والامتثال التنظيمي', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0001', NULL, NULL, NULL, 'documents/1751351851_214_______________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"______________________________________________.pdf\",\"new_name\":\"1751351851_214_______________________________________________.pdf\"}]', '2025-07-01 03:39:00', '2025-07-01 03:45:00'),
(6, 'DOC-20260429-5021', 'الفنية والاكتتاب', 'استخدام التقنية والبيانات لضمان حماية المعلومات، تكامل الأنظمة، وجودة الخدمة والامتثال التنظيمي', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0001', NULL, NULL, NULL, 'documents/1751352335_214_Technical_and_Underwriting_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Technical_and_Underwriting_Policy___Arabic.pdf\",\"new_name\":\"1751352335_214_Technical_and_Underwriting_Policy___Arabic.pdf\"}]', '2025-07-01 03:45:00', '2025-09-04 06:51:00'),
(7, 'DOC-20260429-7039', 'سياسة خطابات التعهد', 'إصدار واستخدام خطابات التعهد وفق ضوابط موثقة وموافقات داخلية لضمان الالتزام القانوني والتشغيلي دون استبدال الوثائق التأمينية الرسمية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0002', NULL, NULL, NULL, 'documents/1751352636_214_Letters_of_Undertaking_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Letters_of_Undertaking_Policy___Arabic.pdf\",\"new_name\":\"1751352636_214_Letters_of_Undertaking_Policy___Arabic.pdf\"}]', '2025-07-01 03:50:00', '2025-09-04 06:51:00'),
(8, 'DOC-20260429-5362', 'سياسة إعداد وتوثيق نماذج عروض التأمين', 'تنظم السياسة آلية استلام ومعالجة طلبات عروض التأمين عبر النظام ، لضمان اكتمال المستندات، دقة الإجراءات، وسرية البيانات وفق ضوابط رسمية', 2, 44, 44, NULL, NULL, 'policy', 'draft', ' 1TM0003', NULL, NULL, NULL, 'documents/1751352776_214_Insurance_Quotation_Preparation_and_Documentation_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Quotation_Preparation_and_Documentation_Policy___Arabic.pdf\",\"new_name\":\"1751352776_214_Insurance_Quotation_Preparation_and_Documentation_Policy___Arabic.pdf\"}]', '2025-07-01 03:53:00', '2025-07-01 03:54:00'),
(9, 'DOC-20260429-5085', 'سياسة إعداد وتوثيق نماذج عروض التأمين', 'تنظم السياسة آلية استلام ومعالجة طلبات عروض التأمين عبر النظام ، لضمان اكتمال المستندات، دقة الإجراءات، وسرية البيانات وفق ضوابط رسمية.', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0003', NULL, NULL, NULL, 'documents/1751352888_214_Insurance_Quotation_Preparation_and_Documentation_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Quotation_Preparation_and_Documentation_Policy___Arabic.pdf\",\"new_name\":\"1751352888_214_Insurance_Quotation_Preparation_and_Documentation_Policy___Arabic.pdf\"}]', '2025-07-01 03:54:00', '2025-09-04 06:52:00'),
(10, 'DOC-20260429-7796', 'سياسة الوضوح التعاقدي', 'الالتزام بعدم تنفيذ أي إجراء تأميني دون وجود خطاب تعيين رسمي، وضمان وضوح وتوثيق كافة عناصر العقد قبل الإصدار لتحقيق الشفافية والامتثال الك...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0004', NULL, NULL, NULL, 'documents/1751352973_214_Contractual_Clarity_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Contractual_Clarity_Policy___Arabic.pdf\",\"new_name\":\"1751352973_214_Contractual_Clarity_Policy___Arabic.pdf\"}]', '2025-07-01 03:56:00', '2025-09-04 06:52:00'),
(11, 'DOC-20260429-8536', 'سياسة الاستجابة للطوارئ واستمرارية الأعمال', 'تصنيف المهام الحيوية، وتفعيل خطط بديلة للطوارئ، وضمان حماية البيانات والتشغيل دون انقطاع', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0005', NULL, NULL, NULL, 'documents/1751353978_214_Emergency_Response_and_Business_Continuity_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Emergency_Response_and_Business_Continuity_Policy___Arabic.pdf\",\"new_name\":\"1751353978_214_Emergency_Response_and_Business_Continuity_Policy___Arabic.pdf\"}]', '2025-07-01 04:13:00', '2025-09-04 06:52:00'),
(12, 'DOC-20260429-3290', 'سياسة التعافي من الكوارث', 'استمرارية الخدمة من خلال نسخ احتياطي مشفر، جاهزية الفريق، بدائل تشغيلية، وتوثيق كامل للإجراءات وتحديث الخطة بناءً على الدروس المستفادة', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0006', NULL, NULL, NULL, 'documents/1751354052_214_Disaster_Recovery_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Disaster_Recovery_Policy___Arabic.pdf\",\"new_name\":\"1751354052_214_Disaster_Recovery_Policy___Arabic.pdf\"}]', '2025-07-01 04:14:00', '2025-09-04 06:54:00'),
(13, 'DOC-20260429-6106', 'سياسة الأخطاء والإغفالات', 'الوقاية من الأخطاء من خلال مراجعة دقيقة، توثيق الإجراءات، استخدام النماذج المعتمدة، تحليل الملاحظات، تصحيح الأخطاء فوراً، ومتابعة الأداء...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0007', NULL, NULL, NULL, 'documents/1751354124_214_Errors_and_Omissions_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Errors_and_Omissions_Policy___Arabic.pdf\",\"new_name\":\"1751354124_214_Errors_and_Omissions_Policy___Arabic.pdf\"}]', '2025-07-01 04:15:00', '2025-09-04 06:55:00'),
(14, 'DOC-20260429-2964', 'سياسة التعامل مع شركات التأمين', 'التعامل المهني والشفاف مع شركات التأمين عبر توثيق دقيق، مراجعة مستمرة، وتواصل رسمي يحفظ الحقوق ويلتزم بالضوابط التنظيمية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0008', NULL, NULL, NULL, 'documents/1751354259_214_Insurance_Company_Engagement_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Company_Engagement_Policy___Arabic.pdf\",\"new_name\":\"1751354259_214_Insurance_Company_Engagement_Policy___Arabic.pdf\"}]', '2025-07-01 04:17:00', '2025-09-04 06:56:00'),
(15, 'DOC-20260429-8138', 'سياسة العلاقات مع شركات التأمين', 'تنظيم علاقات مهنية وشفافة مع شركات التأمين عبر قنوات رسمية، مراجعة دقيقة للعروض، توثيق كامل، تقييم دوري، وإدارة النزاعات مع الالتزام الكا...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0009', NULL, NULL, NULL, 'documents/1751354658_214_Insurance_Company_Relationship_Management_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Company_Relationship_Management_Policy___Arabic.pdf\",\"new_name\":\"1751354658_214_Insurance_Company_Relationship_Management_Policy___Arabic.pdf\"}]', '2025-07-01 04:24:00', '2025-09-04 07:00:00'),
(16, 'DOC-20260429-5651', 'سياسة تحليل المحفظة التأمينية', 'الالتزام بتحليل دوري للمحفظة التأمينية لتقييم الأداء، اكتشاف المخاطر، تحسين المنتجات، ومتابعة تنفيذ خطط التطوير.', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0010', NULL, NULL, NULL, 'documents/1751355476_214_Insurance_Portfolio_Analysis_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Portfolio_Analysis_Policy___Arabic.pdf\",\"new_name\":\"1751355476_214_Insurance_Portfolio_Analysis_Policy___Arabic.pdf\"}]', '2025-07-01 04:40:00', '2025-09-04 07:01:00'),
(17, 'DOC-20260429-9728', 'سياسة الإبلاغ عن المخالفات', 'تنظم الإبلاغ عن المخالفات لضمان النزاهة والشفافية، عبر قنوات آمنة، مع حماية المبلغين، والتحقيق الفوري، والتصعيد عند الضرورة، وضمان سرية ا...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0011', NULL, NULL, NULL, 'documents/1751355768_214_Whistleblowing_and_Violations_Reporting_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Whistleblowing_and_Violations_Reporting_Policy___Arabic.pdf\",\"new_name\":\"1751355768_214_Whistleblowing_and_Violations_Reporting_Policy___Arabic.pdf\"}]', '2025-07-01 04:46:00', '2025-09-04 07:03:00'),
(18, 'DOC-20260429-3203', 'سياسة تأكيد تحصيل قسط العميل قبل إصدار الوثيقة التأمينية', 'الالتزام بتحصيل القسط الأول من العميل قبل بدء إصدار الوثيقة التأمينية، مع التحقق من صحة المستندات ومتابعة الإجراءات لضمان حماية حقوق الشر...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0012', NULL, NULL, NULL, 'documents/1751356100_214_Client_Premium_Collection_Confirmation_Before_Policy_Issuance_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Premium_Collection_Confirmation_Before_Policy_Issuance_Policy___Arabic.pdf\",\"new_name\":\"1751356100_214_Client_Premium_Collection_Confirmation_Before_Policy_Issuance_Policy___Arabic.pdf\"}]', '2025-07-01 04:49:00', '2025-09-04 07:04:00'),
(19, 'DOC-20260429-7107', 'سياسة الإصدار', 'تنظيم استقبال ومراجعة طلبات الإصدار التأميني وضمان دقة البيانات وجودة الخدمة', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0013', NULL, NULL, NULL, 'documents/1751356242_214_Issuance_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Issuance_Policy___Arabic.pdf\",\"new_name\":\"1751356242_214_Issuance_Policy___Arabic.pdf\"}]', '2025-07-01 04:50:00', '2025-09-04 08:02:00'),
(20, 'DOC-20260429-3659', 'السياسة العامة للفحص الدوري ومراجعة تقارير المعاينين الفنيين', 'تنظيم إجراءات وضوابط المعاينة الفنية للأصول التأمينية لضمان دقة التقارير وسلامة التغطية، من خلال تنسيق داخلي دقيق، مراجعة فنية صارمة، وحف...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0014', NULL, NULL, NULL, 'documents/1751356381_214_General_Policy_for_Periodic_Inspection_and_Review_of_Technical_Survey_Reports___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"General_Policy_for_Periodic_Inspection_and_Review_of_Technical_Survey_Reports___Arabic.pdf\",\"new_name\":\"1751356381_214_General_Policy_for_Periodic_Inspection_and_Review_of_Technical_Survey_Reports___Arabic.pdf\"}]', '2025-07-01 04:53:00', '2025-09-04 07:06:00'),
(21, 'DOC-20260429-8120', 'سياسة مطالبات التأمين والأرشفة الإلكترونية', 'إجراءات استقبال ومتابعة وتسوية مطالبات التأمين بدقة وشفافية، مع حفظ المستندات وضمان حماية بيانات العملاء', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0015', NULL, NULL, NULL, 'documents/1751356484_214_Insurance_Claims_and_Electronic_Archiving_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Claims_and_Electronic_Archiving_Policy___Arabic.pdf\",\"new_name\":\"1751356484_214_Insurance_Claims_and_Electronic_Archiving_Policy___Arabic.pdf\"}]', '2025-07-01 04:54:00', '2025-09-04 07:07:00'),
(22, 'DOC-20260429-9661', 'سياسة اتفاقيات شروط الأعمال مع العملاء', 'العلاقة التعاقدية مع العميل عبر اتفاقية وساطة موحدة مدتها ثلاث سنوات، تضمن الالتزام بالخدمات ومنع التغيير دون مبرر موثق', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1TM0016', NULL, NULL, NULL, 'documents/1751356580_214_Client_Business_Terms_Agreement_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Business_Terms_Agreement_Policy___Arabic.pdf\",\"new_name\":\"1751356580_214_Client_Business_Terms_Agreement_Policy___Arabic.pdf\"}]', '2025-07-01 04:56:00', '2025-09-04 08:24:00'),
(23, 'DOC-20260429-1816', 'سياسة الالتزام والامتثال التنظيمي', 'تحدد هذه السياسة إطارًا شاملًا لضمان التزام الشركة بجميع الأنظمة واللوائح التنظيمية من خلال هيكل رقابي مستقل، وضوابط واضحة، وثقافة مؤسسية...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0001', NULL, NULL, NULL, 'documents/1751361731_214_Regulatory_Compliance_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Regulatory_Compliance_Policy___Arabic.pdf\",\"new_name\":\"1751361731_214_Regulatory_Compliance_Policy___Arabic.pdf\"}]', '2025-07-01 06:22:00', '2025-07-01 06:22:00'),
(24, 'DOC-20260429-9377', 'سياسة مكافحة الفساد والرشوة', 'الممارسات المحظورة وأشكال الفساد والرشوة داخل الشركة، وتفرض ضوابط رقابية صارمة وآليات تنفيذية لضمان النزاهة والشفافية المؤسسية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0002', NULL, NULL, NULL, 'documents/1751361824_214_Anti_Corruption_and_Anti_Bribery_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Anti_Corruption_and_Anti_Bribery_Policy___Arabic.pdf\",\"new_name\":\"1751361824_214_Anti_Corruption_and_Anti_Bribery_Policy___Arabic.pdf\"}]', '2025-07-01 06:23:00', '2025-07-01 06:23:00'),
(25, 'DOC-20260429-4427', 'سياسة مكافحة غسل الأموال وتمويل الإرهاب', 'مبدأ \"اعرف عميلك\" يشمل جمع وتوثيق بيانات العميل، التحقق من هويته، ومتابعة العمليات المشبوهة لضمان الامتثال لمكافحة غسل الأموال وتمويل الإر...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0003', NULL, NULL, NULL, 'documents/1751361864_214_Anti_Money_Laundering_and_Counter_Terrorism_Financing_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Anti_Money_Laundering_and_Counter_Terrorism_Financing_Policy___Arabic.pdf\",\"new_name\":\"1751361864_214_Anti_Money_Laundering_and_Counter_Terrorism_Financing_Policy___Arabic.pdf\"}]', '2025-07-01 06:27:00', '2025-07-01 06:27:00'),
(26, 'DOC-20260429-2256', 'سياسة الإبلاغ المحمي', 'تمكين الموظفين من الإبلاغ الآمن عن المخالفات بسرية تامة، مع ضمان الحماية الكاملة للمبلغين وضبط إجراءات التحقق والمساءلة المؤسسية.', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0004', NULL, NULL, NULL, 'documents/1751362218_214_Whistleblower_Protection_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Whistleblower_Protection_Policy___Arabic.pdf\",\"new_name\":\"1751362218_214_Whistleblower_Protection_Policy___Arabic.pdf\"}]', '2025-07-01 06:30:00', '2025-07-01 06:30:00'),
(27, 'DOC-20260429-7975', 'سياسة إدارة المخاطر', 'القواعد عامة لإدارة المخاطر، تشمل تصنيفها، وطرق قياسها، واستراتيجيات الحد منها، وخطط الطوارئ، وآليات التقييم والمراجعة المستمرة لضمان جا...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0005', NULL, NULL, NULL, 'documents/1751362281_214_Risk_Management_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Risk_Management_Policy___Arabic.pdf\",\"new_name\":\"1751362281_214_Risk_Management_Policy___Arabic.pdf\"}]', '2025-07-01 06:31:00', '2025-07-01 06:31:00'),
(28, 'DOC-20260429-9658', 'سياسة تصنيف وأمن وإتلاف المعلومات', 'تحدد الوثيقة آليات تصنيف المعلومات وحمايتها، وتشمل ضوابط الوصول والتخزين والنقل والإتلاف، إضافة إلى الإجراءات النظامية لمعالجة سوء الاست...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0006', NULL, NULL, NULL, 'documents/1751362370_214_Information_Classification__Security__and_Disposal_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Classification__Security__and_Disposal_Policy___Arabic.pdf\",\"new_name\":\"1751362370_214_Information_Classification__Security__and_Disposal_Policy___Arabic.pdf\"}]', '2025-07-01 06:34:00', '2025-07-01 06:34:00'),
(29, 'DOC-20260429-4798', 'سياسة مراجعة الملفات', 'آلية وإجراءات مراجعة الملفات في الجهات الداخلية، بدءًا من خطط المراجعة وتصنيفات النتائج، وانتهاءً بالإجراءات التصحيحية والمساءلة في حال ...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0007', NULL, NULL, NULL, 'documents/1751362561_214_File_Review_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"File_Review_Policy.pdf\",\"new_name\":\"1751362561_214_File_Review_Policy.pdf\"}]', '2025-07-01 06:36:00', '2025-07-01 06:36:00'),
(30, 'DOC-20260429-4602', 'سياسة التدقيق الداخلي', 'أنواع، وخطوات ومنهجية التدقيق الداخلي، بما يضمن الاستقلالية، السرية، والامتثال، مع تصنيف النتائج وآليات التعامل مع المخالفات والمتابعة و...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0008', NULL, NULL, NULL, 'documents/1751362672_214_Internal_Audit_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Internal_Audit_Policy___Arabic.pdf\",\"new_name\":\"1751362672_214_Internal_Audit_Policy___Arabic.pdf\"}]', '2025-07-01 06:38:00', '2025-07-01 06:38:00'),
(31, 'DOC-20260429-9533', 'سياسة التدقيق الداخلي', 'أنواع، وخطوات ومنهجية التدقيق الداخلي، بما يضمن الاستقلالية، السرية، والامتثال، مع تصنيف النتائج وآليات التعامل مع المخالفات والمتابعة و...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0008', NULL, NULL, NULL, 'documents/1751362961_214_Internal_Audit_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Internal_Audit_Policy___Arabic.pdf\",\"new_name\":\"1751362961_214_Internal_Audit_Policy___Arabic.pdf\"}]', '2025-07-01 06:43:00', '2025-07-01 06:43:00'),
(32, 'DOC-20260429-1116', 'سياسة اتفاقيات الوكالة الخارجية', 'الضوابط العامة لإبرام العقود واتفاقيات الوكالة، وتشمل متطلبات التقييم المسبق، ومراجعة العقود، وآليات المتابعة والرقابة، والتعديل أو الإ...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0010', NULL, NULL, NULL, 'documents/1751363067_214_External_Agency_Agreement_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"External_Agency_Agreement_Policy___Arabic.pdf\",\"new_name\":\"1751363067_214_External_Agency_Agreement_Policy___Arabic.pdf\"}]', '2025-07-01 06:45:00', '2025-07-01 06:45:00'),
(33, 'DOC-20260429-2638', 'سياسة الإسناد الخارجي', 'الضوابط الشاملة لإسناد المهام للجهات الخارجية (الطرف الثالث)، بما يشمل معايير الاختيار، المتطلبات التنظيمية، آليات التقييم والمراقبة، إد...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0011', NULL, NULL, NULL, 'documents/1751363188_214_Outsourcing_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Outsourcing_Policy___Arabic.pdf\",\"new_name\":\"1751363188_214_Outsourcing_Policy___Arabic.pdf\"}]', '2025-07-01 06:47:00', '2025-07-01 06:47:00'),
(34, 'DOC-20260429-4896', 'سياسة الالتزام بالمعايير الدولية والمحلية', 'التزام الشركة بالمعايير المحلية والدولية، وآليات مراجعة الامتثال وتحديث السياسات، مع تقييم الفجوات التنظيمية، إصدار نشرات داخلية، متابع...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0012', NULL, NULL, NULL, 'documents/1751363406_214_Compliance_with_International_and_Local_Standards_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Compliance_with_International_and_Local_Standards_Policy___Arabic.pdf\",\"new_name\":\"1751363406_214_Compliance_with_International_and_Local_Standards_Policy___Arabic.pdf\"}]', '2025-07-01 06:50:00', '2025-07-01 06:50:00'),
(35, 'DOC-20260429-9586', 'Eid Al-Adha Holiday Circular', 'Eid Al-Adha Holiday Circular تعميم اجازة عيد الاضحى', 2, 38, 38, NULL, NULL, 'procedure', 'draft', 'NULL', NULL, NULL, NULL, 'documents/1751541639_194__________________________________________2024_1.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"_________________________________________2024_1.pdf\",\"new_name\":\"1751541639_194__________________________________________2024_1.pdf\"}]', '2025-07-03 08:22:00', '2025-07-03 08:22:00'),
(36, 'DOC-20260429-1291', 'Official Working Hours Circular', 'Official Working Hours Circular تعميم اوقات الدوام الرسمي', 2, 38, 38, NULL, NULL, 'procedure', 'draft', 'NULL', NULL, NULL, NULL, 'documents/1751541922_194___________________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"__________________________________________________________.pdf\",\"new_name\":\"1751541922_194___________________________________________________________.pdf\"}]', '2025-07-03 08:25:00', '2025-07-03 08:25:00'),
(37, 'DOC-20260429-6281', 'Supplementary Circular: National Day Holiday', 'Supplementary Circular: National Day Holiday تعميم الحاقي لإجازة اليوم الوطني', 2, 38, 38, NULL, NULL, 'procedure', 'draft', 'NULL', NULL, NULL, NULL, 'documents/1751541948_194___________________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"__________________________________________________________.pdf\",\"new_name\":\"1751541948_194___________________________________________________________.pdf\"}]', '2025-07-03 08:26:00', '2025-07-03 08:26:00'),
(38, 'DOC-20260429-4137', 'Promotion Announcement: Khalid', 'Promotion Announcement: Khalid تعميم ترقية خالد', 2, 38, 38, NULL, NULL, 'procedure', 'draft', 'HR250518', NULL, NULL, NULL, 'documents/1751542050_194_______________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"______________________________.pdf\",\"new_name\":\"1751542050_194_______________________________.pdf\"}]', '2025-07-03 08:29:00', '2025-07-03 08:29:00'),
(39, 'DOC-20260429-5243', 'Promotion Announcement: Shaden', 'Promotion Announcement: Shaden تعميم ترقية شادن', 2, 38, 38, NULL, NULL, 'procedure', 'draft', 'NULL', NULL, NULL, NULL, 'documents/1751542183_194_______________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"______________________________.pdf\",\"new_name\":\"1751542183_194_______________________________.pdf\"}]', '2025-07-03 08:31:00', '2025-07-03 08:31:00'),
(40, 'DOC-20260429-6942', 'Promotion Announcement for Abdullah', 'Promotion Announcement for Abdullah تعميم ترقية عبدالله', 2, 38, 38, NULL, NULL, 'procedure', 'draft', 'NULL', NULL, NULL, NULL, 'documents/1751542303_194_____________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"____________________________________.pdf\",\"new_name\":\"1751542303_194_____________________________________.pdf\"}]', '2025-07-03 08:33:00', '2025-07-03 08:33:00'),
(41, 'DOC-20260429-3772', 'Assignment Announcement for Abdullah', 'Assignment Announcement for Abdullah تعميم تكليف عبدالله', 2, 38, 38, NULL, NULL, 'procedure', 'draft', 'NULL', NULL, NULL, NULL, 'documents/1751542463_194_____________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"____________________________________.pdf\",\"new_name\":\"1751542463_194_____________________________________.pdf\"}]', '2025-07-03 08:35:00', '2025-07-03 08:35:00'),
(42, 'DOC-20260429-9788', 'Leave Policy Circular', 'Leave Policy Circular تعميم الاجازات', 2, 38, 38, NULL, NULL, 'procedure', 'draft', 'NULL', NULL, NULL, NULL, 'documents/1751542564_194________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"_______________________.pdf\",\"new_name\":\"1751542564_194________________________.pdf\"}]', '2025-07-03 08:37:00', '2025-07-03 08:37:00'),
(43, 'DOC-20260429-6480', 'Visitor Ban Circular', 'Visitor Ban Circular تعميم منع الزوار', 2, 38, 38, NULL, NULL, 'procedure', 'draft', 'NULL', NULL, NULL, NULL, 'documents/1751542652_194___________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"__________________________________.pdf\",\"new_name\":\"1751542652_194___________________________________.pdf\"}]', '2025-07-03 08:38:00', '2025-07-03 08:38:00'),
(44, 'DOC-20260429-4101', 'Circular to Managers', 'Circular to Managers تعميم للمدراء', 2, 38, 38, NULL, NULL, 'procedure', 'draft', 'HR250408', NULL, NULL, NULL, 'documents/1751542743_194__________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"_________________________.pdf\",\"new_name\":\"1751542743_194__________________________.pdf\"}]', '2025-07-03 08:40:00', '2025-07-03 08:44:00'),
(45, 'DOC-20260429-1545', 'Workforce', 'Workforce قوى', 2, 38, 38, NULL, NULL, 'procedure', 'draft', 'NULL', NULL, NULL, NULL, 'documents/1751542834_194_______.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"______.pdf\",\"new_name\":\"1751542834_194_______.pdf\"}]', '2025-07-03 08:41:00', '2025-07-03 08:41:00'),
(46, 'DOC-20260429-2051', 'Circular Regarding the Cancellation of Permission Requests', 'Circular Regarding the Cancellation of Permission Requests تعميم رفع الاستئذان', 2, 38, 38, NULL, NULL, 'procedure', 'draft', 'NULL', NULL, NULL, NULL, 'documents/1751542914_194__________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"_________________________.pdf\",\"new_name\":\"1751542914_194__________________________.pdf\"}]', '2025-07-03 08:43:00', '2025-07-03 08:43:00'),
(47, 'DOC-20260429-4240', 'National Day Holiday Circular', 'National Day Holiday Circular تعميم اجازة اليوم الوطني', 2, 38, 38, NULL, NULL, 'procedure', 'draft', 'NULL', NULL, NULL, NULL, 'documents/1751542992_194______________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"_____________________________________________.pdf\",\"new_name\":\"1751542992_194______________________________________________.pdf\"}]', '2025-07-03 08:44:00', '2025-07-03 08:44:00'),
(48, 'DOC-20260429-2100', 'سياسة الشؤون المالية العامة', 'إطار حوكمة مالية يضمن الشفافية والامتثال من خلال الالتزام بالمعايير المحاسبية، ضبط الموازنة، الامتثال الضريبي، حفظ السجلات، ومراقبة الأد...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0001', NULL, NULL, NULL, 'documents/1751787372_214_General_Financial_Affairs_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"General_Financial_Affairs_Policy___Arabic.pdf\",\"new_name\":\"1751787372_214_General_Financial_Affairs_Policy___Arabic.pdf\"}]', '2025-07-06 04:36:00', '2025-07-06 04:36:00'),
(49, 'DOC-20260429-4927', 'سياسة تخطيط الميزانية', 'منهجية محكمة لإعداد وتنفيذ ومتابعة الميزانية السنوية وفق ضوابط تنظيمية وتعاون بين الإدارات', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0002', NULL, NULL, NULL, 'documents/1751787442_214_Budget_Planning_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Budget_Planning_Policy___Arabic.pdf\",\"new_name\":\"1751787442_214_Budget_Planning_Policy___Arabic.pdf\"}]', '2025-07-06 04:37:00', '2026-03-31 02:34:00'),
(50, 'DOC-20260429-3456', 'سياسة التقارير المالية', 'نظام شامل لإعداد ومراجعة وتوثيق التقارير المالية الدورية بدقة وفي مواعيد محددة، وفق المعايير المحاسبية والجهات التنظيمية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0003', NULL, NULL, NULL, 'documents/1751787525_214_Financial_Reporting_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Financial_Reporting_Policy___Arabic.pdf\",\"new_name\":\"1751787525_214_Financial_Reporting_Policy___Arabic.pdf\"}]', '2025-07-06 04:38:00', '2025-07-06 04:38:00'),
(51, 'DOC-20260429-6690', 'سياسة المحاسبة', 'الالتزام بمعايير المحاسبة، التسجيل الدقيق، التسويات اليومية، والرقابة الداخلية، بدعم تقني وتنظيمي شامل', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0004', NULL, NULL, NULL, 'documents/1751787611_214_Accounting_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Accounting_Policy___Arabic.pdf\",\"new_name\":\"1751787611_214_Accounting_Policy___Arabic.pdf\"}]', '2025-07-06 04:41:00', '2026-03-31 02:30:00'),
(52, 'DOC-20260429-2670', 'سياسة التعاملات والتحويلات المالية للأطراف الخارجية', 'ضوابط تنفيذ التحويلات المالية للأطراف الخارجية تشمل الموافقات المسبقة، المستندات الرسمية، الرقابة المحاسبية، والحفظ الآمن للسجلات.', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0005', NULL, NULL, NULL, 'documents/1751787741_214_External_Financial_Transactions_and_Transfers_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"External_Financial_Transactions_and_Transfers_Policy___Arabic.pdf\",\"new_name\":\"1751787741_214_External_Financial_Transactions_and_Transfers_Policy___Arabic.pdf\"}]', '2025-07-06 04:43:00', '2025-07-06 04:43:00'),
(53, 'DOC-20260429-6273', 'سياسة المصروفات والمدفوعات', 'إجراءات تقديم الطلبات المالية، مراجعتها، والموافقة على الصرف، بما في ذلك التعامل مع المصروفات الطارئة، العهد النثرية، والامتثال للضوابط ...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0006', NULL, NULL, NULL, 'documents/1751787908_214_Expenses_and_Payments_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Expenses_and_Payments_Policy___Arabic.pdf\",\"new_name\":\"1751787908_214_Expenses_and_Payments_Policy___Arabic.pdf\"}]', '2025-07-06 04:46:00', '2025-07-06 04:46:00'),
(54, 'DOC-20260429-6954', 'سياسة المصروفات والمدفوعات', 'إجراءات تقديم الطلبات المالية، مراجعتها، والموافقة على الصرف، بما في ذلك التعامل مع المصروفات الطارئة، العهد النثرية، والامتثال للضوابط ...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0006', NULL, NULL, NULL, 'documents/1751788358_214_Expenses_and_Payments_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Expenses_and_Payments_Policy___Arabic.pdf\",\"new_name\":\"1751788358_214_Expenses_and_Payments_Policy___Arabic.pdf\"}]', '2025-07-06 04:52:00', '2025-07-06 04:52:00'),
(55, 'DOC-20260429-2699', 'سياسة التعاملات المالية مع شركات التأمين', 'متطلبات التحويلات المالية تشمل الحصول على الموافقة، مراجعة المستندات، تنفيذ التحويلات عبر قنوات آمنة، وحفظ السجلات للمراجعة المستقبلية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0007', NULL, NULL, NULL, 'documents/1751788484_214_Financial_Dealings_with_Insurance_Companies_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Financial_Dealings_with_Insurance_Companies_Policy___Arabic.pdf\",\"new_name\":\"1751788484_214_Financial_Dealings_with_Insurance_Companies_Policy___Arabic.pdf\"}]', '2025-07-06 04:54:00', '2025-07-06 04:54:00'),
(56, 'DOC-20260429-4617', 'سياسة العُهدة النثرية', 'تنظم منح واستخدام العهد النثرية المؤقتة والدائمة، بما في ذلك تحديد قيمتها وفقًا للمهام، وضمان استخدامها لأغراض محددة، مع الالتزام بالرقاب...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0008', NULL, NULL, NULL, 'documents/1751788562_214_Petty_Cash_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Petty_Cash_Policy___Arabic.pdf\",\"new_name\":\"1751788562_214_Petty_Cash_Policy___Arabic.pdf\"}]', '2025-07-06 04:56:00', '2026-03-31 02:59:00'),
(57, 'DOC-20260429-4213', 'سياسة الإنفاق الرأسمالي', 'تقديم طلبات الإنفاق الرأسمالي، تقييم الأصول، سياسة الإهلاك، المراجعة الدورية، وتنظيم التخلص من الأصول وفق الصلاحيات المعتمدة.', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0009', NULL, NULL, NULL, 'documents/1751788698_214_Capital_Expenditure_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Capital_Expenditure_Policy___Arabic.pdf\",\"new_name\":\"1751788698_214_Capital_Expenditure_Policy___Arabic.pdf\"}]', '2025-07-06 04:58:00', '2026-03-31 02:42:00'),
(58, 'DOC-20260429-6275', 'سياسة الاستثمارات', 'شروط وضوابط الاستثمارات تشمل الامتثال للتنظيمات والشريعة، تحديد المخاطر، موافقات الإدارة، تنوع المحفظة، وتقارير دورية لمراقبة الأداء', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0010', NULL, NULL, NULL, 'documents/1751788885_214_Investment_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Investment_Policy___Arabic.pdf\",\"new_name\":\"1751788885_214_Investment_Policy___Arabic.pdf\"}]', '2025-07-06 05:01:00', '2026-03-31 02:57:00'),
(59, 'DOC-20260429-7459', 'سياسة الضرائب', 'الالتزام بالتسجيل الضريبي والزكوي، إصدار الفواتير وفقًا للأنظمة، تقديم الإقرارات في الوقت المحدد، سداد المستحقات، والتدقيق الداخلي لضما...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0011', NULL, NULL, NULL, 'documents/1751789001_214_Tax_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Tax_Policy.pdf\",\"new_name\":\"1751789001_214_Tax_Policy.pdf\"}]', '2025-07-06 05:03:00', '2025-07-06 05:05:00'),
(60, 'DOC-20260429-5065', 'سياسة الضرائب', 'الالتزام بالتسجيل الضريبي والزكوي، إصدار الفواتير وفقًا للأنظمة، تقديم الإقرارات في الوقت المحدد، سداد المستحقات، والتدقيق الداخلي لضما...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0011', NULL, NULL, NULL, 'documents/1751789190_214_Tax_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Tax_Policy___Arabic.pdf\",\"new_name\":\"1751789190_214_Tax_Policy___Arabic.pdf\"}]', '2025-07-06 05:06:00', '2025-07-06 05:06:00'),
(61, 'DOC-20260429-5965', 'سياسة إقفال البيانات المالية', 'إغلاق الحسابات اليومية بدقة، إجراء التسويات المحاسبية الشهرية، إعداد التقارير المالية الدورية، والتأكد من الحفاظ على سرية البيانات المال...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0012', NULL, NULL, NULL, 'documents/1751789273_214_Financial_Closing_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Financial_Closing_Policy___Arabic.pdf\",\"new_name\":\"1751789273_214_Financial_Closing_Policy___Arabic.pdf\"}]', '2025-07-06 05:08:00', '2025-07-06 05:08:00'),
(62, 'DOC-20260429-8426', 'سياسة التحكم في الائتمان', 'تقييم العملاء الائتماني، تحديد الحدود، متابعة الذمم المدينة، والتعامل مع التعثر، مع توثيق الموافقات وإعداد تقارير دورية، مع الالتزام بال...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0013', NULL, NULL, NULL, 'documents/1751789358_214_Credit_Control_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Credit_Control_Policy___Arabic.pdf\",\"new_name\":\"1751789358_214_Credit_Control_Policy___Arabic.pdf\"}]', '2025-07-06 05:09:00', '2026-03-31 02:54:00'),
(63, 'DOC-20260429-6376', 'سياسة الإبلاغ عن الخسائر التشغيلية', 'الإبلاغ الفوري عن الخسائر التشغيلية، تحديد الإجراءات التصحيحية، تحليل الأسباب، وتقرير ربع سنوي للمخاطر مع متابعة التنفيذ من قبل الإدارة ا...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0014', NULL, NULL, NULL, 'documents/1751789452_214_Operational_Loss_Reporting_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Operational_Loss_Reporting_Policy___Arabic.pdf\",\"new_name\":\"1751789452_214_Operational_Loss_Reporting_Policy___Arabic.pdf\"}]', '2025-07-06 05:12:00', '2025-07-06 05:12:00'),
(64, 'DOC-20260429-2899', 'سياسة التسويات المحاسبية', 'التسويات المحاسبية تتم بشكل دوري مع توثيق الفروقات وحفظ السجلات لمدة 10 سنوات، وتشمل جميع الجهات المالية مع إجراءات تصحيحية عند وجود أي فرو...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0015', NULL, NULL, NULL, 'documents/1751791247_214_Accounting_Reconciliation_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Accounting_Reconciliation_Policy___Arabic.pdf\",\"new_name\":\"1751791247_214_Accounting_Reconciliation_Policy___Arabic.pdf\"}]', '2025-07-06 05:40:00', '2026-03-31 02:52:00'),
(65, 'DOC-20260429-1014', 'سياسة المراجع والمحاسب القانوني الخارجي', 'تعيين واختيار المراجع الخارجي، وتحديد معايير التقييم والمراجعة، مع ضمان الاستقلالية والامتثال للأنظمة، وتوثيق كافة الإجراءات والتقارير ...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0016', NULL, NULL, NULL, 'documents/1751791308_214_External_Auditor_and_Legal_Accountant_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"External_Auditor_and_Legal_Accountant_Policy___Arabic.pdf\",\"new_name\":\"1751791308_214_External_Auditor_and_Legal_Accountant_Policy___Arabic.pdf\"}]', '2025-07-06 05:41:00', '2025-07-06 05:41:00'),
(66, 'DOC-20260429-3844', 'سياسة صرف العمولات', 'النسبة المحددة لموظفي المبيعات حسب نوع التأمين، مع آلية صرف مرتبطة بتحصيل الأقساط، وتخضع للتعديل حسب مصلحة الشركة', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0017', NULL, NULL, NULL, 'documents/1751791415_214_Commission_Disbursement_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Commission_Disbursement_Policy___Arabic.pdf\",\"new_name\":\"1751791415_214_Commission_Disbursement_Policy___Arabic.pdf\"}]', '2025-07-06 05:43:00', '2025-07-06 05:46:00'),
(67, 'DOC-20260429-3169', 'سياسة إدارة المخاطر المالية', 'إدارة المخاطر المالية من خلال تصنيفها، تقييمها، وضع خطط للتخفيف منها، ورصد المؤشرات التحذيرية، مع الامتثال للمتطلبات التنظيمية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0018', NULL, NULL, NULL, 'documents/1751791472_214_Financial_Risk_Management_and_Debt_Aging_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Financial_Risk_Management_and_Debt_Aging_Policy___Arabic.pdf\",\"new_name\":\"1751791472_214_Financial_Risk_Management_and_Debt_Aging_Policy___Arabic.pdf\"}]', '2025-07-06 05:45:00', '2025-07-06 05:45:00'),
(68, 'DOC-20260429-5435', 'سياسة صرف العمولات', 'النسبة المحددة لموظفي المبيعات حسب نوع التأمين، مع آلية صرف مرتبطة بتحصيل الأقساط، وتخضع للتعديل حسب مصلحة الشركة.', 2, 44, 44, NULL, NULL, 'policy', 'draft', '2FM0017', NULL, NULL, NULL, 'documents/1751791678_214_Commission_Disbursement_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Commission_Disbursement_Policy___Arabic.pdf\",\"new_name\":\"1751791678_214_Commission_Disbursement_Policy___Arabic.pdf\"}]', '2025-07-06 05:48:00', '2025-07-06 05:48:00'),
(69, 'DOC-20260429-7903', 'سياسة التحصيل وأعمار الديون', 'طرق فعّالة لتسجيل، تصنيف، وتحصيل مستحقات العملاء، بما في ذلك خطة تحصيل دورية، تصعيد الحالات، والتعامل مع الديون المشكوك في تحصيلها، مع ضما...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0019', NULL, NULL, NULL, 'documents/1751791947_214_Debt_Collection_and_Aging_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Debt_Collection_and_Aging_Policy___Arabic.pdf\",\"new_name\":\"1751791947_214_Debt_Collection_and_Aging_Policy___Arabic.pdf\"}]', '2025-07-06 05:53:00', '2026-03-31 02:47:00'),
(70, 'DOC-20260429-6253', 'سياسة فصل المهام المالية', 'الالتزام بفصل المهام بين الموظفين لضمان النزاهة والشفافية، مع مراجعة دورية للصلاحيات وتنفيذ إجراءات تصعيدية في حال وجود مخالفات، والتأكد ...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0020', NULL, NULL, NULL, 'documents/1751792029_214_Financial_Segregation_of_Duties_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Financial_Segregation_of_Duties_Policy___Arabic.pdf\",\"new_name\":\"1751792029_214_Financial_Segregation_of_Duties_Policy___Arabic.pdf\"}]', '2025-07-06 05:55:00', '2026-03-31 03:01:00'),
(71, 'DOC-20260429-7152', 'سياسة إدارة السجلات المالية والأرشفة', 'تلتزم الإدارة المالية بإنشاء وتصنيف السجلات المالية بدقة، مع التحكم في التعديلات، والاحتفاظ بها لفترات محددة، وحفظها إلكترونيًا وورقيًا،...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0021', NULL, NULL, NULL, 'documents/1751792176_214_Financial_Records_Management_and_Archiving_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Financial_Records_Management_and_Archiving_Policy___Arabic.pdf\",\"new_name\":\"1751792176_214_Financial_Records_Management_and_Archiving_Policy___Arabic.pdf\"}]', '2025-07-06 05:56:00', '2026-03-31 02:26:00'),
(72, 'DOC-20260429-5688', 'سياسة حماية البيانات المالية والسرية', 'حماية البيانات المالية الحساسة، تشمل توقيع اتفاقيات سرية، تصنيف البيانات، التحكم في الوصول، التشفير، التدريب، وإجراءات التصعيد في حال حد...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1FM0023', NULL, NULL, NULL, 'documents/1751792373_214_Financial_Data_Protection_and_Confidentiality_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Financial_Data_Protection_and_Confidentiality_Policy___Arabic.pdf\",\"new_name\":\"1751792373_214_Financial_Data_Protection_and_Confidentiality_Policy___Arabic.pdf\"}]', '2025-07-06 06:00:00', '2025-07-06 06:00:00'),
(73, 'DOC-20260429-2819', 'إجراءات الإدارة المالية', NULL, 2, 44, 44, NULL, NULL, 'policy', 'draft', 'v1.0', NULL, NULL, NULL, 'documents/1751793163_214_Financial_Procedures___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Financial_Procedures___Arabic.pdf\",\"new_name\":\"1751793163_214_Financial_Procedures___Arabic.pdf\"}]', '2025-07-06 06:12:00', '2025-07-06 06:12:00'),
(74, 'DOC-20260429-5886', 'إجراءات الإدارة المالية', NULL, 2, 44, 44, NULL, NULL, 'procedure', 'draft', 'v1.0', NULL, NULL, NULL, 'documents/1751793195_214_Financial_Procedures___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Financial_Procedures___Arabic.pdf\",\"new_name\":\"1751793195_214_Financial_Procedures___Arabic.pdf\"}]', '2025-07-06 06:13:00', '2025-07-06 06:13:00'),
(75, 'DOC-20260429-7831', 'إجراءات الإدارة  الفنية', NULL, 2, 54, 54, NULL, NULL, 'procedure', 'draft', 'v1.0', NULL, NULL, NULL, 'documents/1751796750_214_Tinancial_Procedures____Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Tinancial_Procedures____Arabic.pdf\",\"new_name\":\"1751796750_214_Tinancial_Procedures____Arabic.pdf\"}]', '2025-07-06 07:12:00', '2025-09-18 10:19:00'),
(76, 'DOC-20260429-3941', 'إجراءات إدارة الإلتزام والامتثال', NULL, 2, 44, 44, NULL, NULL, 'procedure', 'draft', 'v1.0', NULL, NULL, NULL, 'documents/1751799437_214_Compliance_Procedures___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Compliance_Procedures___Arabic.pdf\",\"new_name\":\"1751799437_214_Compliance_Procedures___Arabic.pdf\"}]', '2025-07-06 07:57:00', '2025-07-06 07:57:00'),
(77, 'DOC-20260429-1190', 'سياسة مكافحة الاحتيال', 'مؤشرات الاحتيال وأساليب الوقاية منه داخليًا وخارجيًا، وتشمل ضوابط الإبلاغ، التحقق، التحقيق، حماية البيانات، والامتثال للأنظمة', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0009', NULL, NULL, NULL, 'documents/1752655593_214_Anti_Fraud_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Anti_Fraud_Policy_Arabic.pdf\",\"new_name\":\"1752655593_214_Anti_Fraud_Policy_Arabic.pdf\"}]', '2025-07-16 05:51:00', '2025-07-16 05:51:00'),
(78, 'DOC-20260429-6175', 'سياسة استمرارية الأعمال', 'آليات الحفاظ على استمرارية العمليات الحيوية أثناء الأزمات والطوارئ، من خلال خطط الاستجابة والتعافي، النسخ الاحتياطي، والتدريب الدوري', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1LCM0012', NULL, NULL, NULL, 'documents/1752655946_214_Business_Continuity_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Business_Continuity_Policy_Arabic.pdf\",\"new_name\":\"1752655946_214_Business_Continuity_Policy_Arabic.pdf\"}]', '2025-07-16 05:52:00', '2025-08-10 02:47:00'),
(79, 'DOC-20260429-8522', 'سسياسة مكافحة التحرش الجنسي', 'توفير بيئة عمل آمنة خالية من التحرش، مع تحديد أنواع السلوك المحظور، وطرق الإبلاغ، وآليات التحقيق والعقوبات لحماية جميع الموظفين', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0002', NULL, NULL, NULL, 'documents/1753172892_214_Anti_Sexual_Harassment_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Anti_Sexual_Harassment_Policy___Arabic.pdf\",\"new_name\":\"1753172892_214_Anti_Sexual_Harassment_Policy___Arabic.pdf\"}]', '2025-07-22 05:28:00', '2025-11-16 08:53:00'),
(80, 'DOC-20260429-2217', 'سياسة الإحلال والتعاقب الوظيفي', 'تعزيز التوطين من خلال تخطيط التعاقب الوظيفي، الاستقطاب الفعّال، تطوير الكفاءات الوطنية، ومراجعة دورية لضمان جاهزية الكوادر المؤهلة', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0003', NULL, NULL, NULL, 'documents/1753172970_214_Succession_and_Replacement_Policy__Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Succession_and_Replacement_Policy__Arabic.pdf\",\"new_name\":\"1753172970_214_Succession_and_Replacement_Policy__Arabic.pdf\"}]', '2025-07-22 05:30:00', '2025-11-16 08:52:00'),
(81, 'DOC-20260429-9008', 'سياسة المسؤولية الاجتماعية', 'التزام الشركة بالمساهمة المجتمعية من خلال مبادرات بيئية، تعليمية، وتوظيفية، بما يعزز التنمية المستدامة ويعكس قيم دايموند المؤسسية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0004', NULL, NULL, NULL, 'documents/1753173260_214_Corporate_Social_Responsibility__CSR__Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Corporate_Social_Responsibility__CSR__Policy_Arabic.pdf\",\"new_name\":\"1753173260_214_Corporate_Social_Responsibility__CSR__Policy_Arabic.pdf\"}]', '2025-07-22 05:34:00', '2025-07-31 05:42:00'),
(82, 'DOC-20260429-4857', 'سياسة الانضمام الوظيفي', 'تنظم السياسة إجراءات استقبال وتوجيه الموظفين الجدد خلال أول 30 يوم عمل لضمان تكيفهم السلس مع بيئة العمل وتعزيز جاهزيتهم المهنية منذ اليوم ا...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0008', NULL, NULL, NULL, 'documents/1753175310_214_Employee_Onboarding_and_Orientation_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Onboarding_and_Orientation_Policy_Arabic.pdf\",\"new_name\":\"1753175310_214_Employee_Onboarding_and_Orientation_Policy_Arabic.pdf\"}]', '2025-07-22 06:08:00', '2025-07-31 05:41:00'),
(83, 'DOC-20260429-6611', 'سياسة البدلات والترقيات', 'ضوابط صرف البدلات وشروط الترقية، بما يضمن العدالة وتحفيز الأداء، مع مراعاة التدرج الوظيفي والاستحقاقات المرتبطة بالمهام الفعلية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0010', NULL, NULL, NULL, 'documents/1753175403_214_Allowances_and_Promotions_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Allowances_and_Promotions_Policy___Arabic.pdf\",\"new_name\":\"1753175403_214_Allowances_and_Promotions_Policy___Arabic.pdf\"}]', '2025-07-22 06:10:00', '2025-07-31 05:41:00'),
(84, 'DOC-20260429-5711', 'سياسة السفر لأغراض العمل', 'سفر الموظفين في المهام الرسمية داخل المملكة وخارجها، وتشمل ضوابط التكليف، التكاليف، البدلات، والتمثيل المهني للشركة', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0013', NULL, NULL, NULL, 'documents/1753175546_214_Business_Travel_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Business_Travel_Policy___Arabic.pdf\",\"new_name\":\"1753175546_214_Business_Travel_Policy___Arabic.pdf\"}]', '2025-07-22 06:12:00', '2025-07-31 05:41:00'),
(85, 'DOC-20260429-6546', 'سياسة الترفيه والضيافة', 'ضوابط الصرف على الضيافة والفعاليات الداخلية، بما يضمن تعزيز بيئة العمل دون تجاوز الميزانيات أو إساءة الاستخدام', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0014', NULL, NULL, NULL, 'documents/1753175592_214_Entertainment_and_Hospitality_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Entertainment_and_Hospitality_Policy___Arabic.pdf\",\"new_name\":\"1753175592_214_Entertainment_and_Hospitality_Policy___Arabic.pdf\"}]', '2025-07-22 06:13:00', '2025-07-31 05:41:00'),
(86, 'DOC-20260429-3284', 'سياسة التدريب', 'آلية استقطاب المتدربين وتدريب الموظفين الجدد والحاليين، بهدف تطوير المهارات ورفع الكفاءة بما يتماشى مع احتياجات الشركة وأهدافها الاسترا...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0016', NULL, NULL, NULL, 'documents/1753175688_214_Training_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Training_Policy_Arabic.pdf\",\"new_name\":\"1753175688_214_Training_Policy_Arabic.pdf\"}]', '2025-07-22 06:15:00', '2025-07-22 06:16:00'),
(87, 'DOC-20260429-5398', 'سياسة التدريب', 'آلية استقطاب المتدربين وتدريب الموظفين الجدد والحاليين، بهدف تطوير المهارات ورفع الكفاءة بما يتماشى مع احتياجات الشركة وأهدافها الاسترا...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0016', NULL, NULL, NULL, 'documents/1753176878_214_Training_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Training_Policy_Arabic.pdf\",\"new_name\":\"1753176878_214_Training_Policy_Arabic.pdf\"}]', '2025-07-22 06:34:00', '2025-07-31 05:40:00'),
(88, 'DOC-20260429-7126', 'سياسة أخلاقيات الموظفين ومدونة قواعد السلوك', 'آلية تقديم الشكاوى والتحقيق فيها، وضوابط فرض الجزاءات التأديبية، مع ضمان سرية الإجراءات وحماية حقوق الموظفين وتحقيق العدالة التنظيمية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0019', NULL, NULL, NULL, 'documents/1753176961_214_Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf\",\"new_name\":\"1753176961_214_Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf\"}]', '2025-07-22 06:36:00', '2025-07-22 06:36:00'),
(89, 'DOC-20260429-5538', 'سياسة أخلاقيات الموظفين ومدونة قواعد السلوك', 'سلوكيات الموظف المتوقعة داخل بيئة العمل وخارجها، وتحدد مبادئ النزاهة، السرية، احترام الزملاء، وتجنب تضارب المصالح، مع تصنيف المخالفات ور...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0019', NULL, NULL, NULL, 'documents/1753177045_214_Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf\",\"new_name\":\"1753177045_214_Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf\"}]', '2025-07-22 06:37:00', '2025-07-31 05:40:00'),
(90, 'DOC-20260429-1513', 'سياسة الأمن وحماية السرية', 'ضوابط تصنيف وحماية بيانات الموظفين، وتحدد صلاحيات الوصول، وآليات المشاركة الداخلية والخارجية، وتفرض عقوبات صارمة على أي خرق للسرية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0020', NULL, NULL, NULL, 'documents/1753177098_214_Security_and_Confidentiality_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Security_and_Confidentiality_Policy_Arabic.pdf\",\"new_name\":\"1753177098_214_Security_and_Confidentiality_Policy_Arabic.pdf\"}]', '2025-07-22 06:38:00', '2025-07-31 05:40:00');
INSERT INTO `documents` (`id`, `document_no`, `title`, `description`, `category_id`, `owner_id`, `reviewer_id`, `approver_id`, `department_id`, `type`, `status`, `version`, `effective_date`, `review_date`, `expiry_date`, `file_path`, `file_size`, `mime_type`, `is_controlled`, `requires_signature`, `rejection_reason`, `submitted_at`, `approved_at`, `tags`, `metadata`, `created_at`, `updated_at`) VALUES
(91, 'DOC-20260429-6769', 'سياسة الموارد البشرية العامة', 'الجوانب الإدارية المتعلقة بالموظفين من التوظيف وحتى إنهاء الخدمة، لتحقيق بيئة عمل عادلة ومنظمة', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0006', NULL, NULL, NULL, 'documents/1753340794_214_General_Human_Resources_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"General_Human_Resources_Policy___Arabic.pdf\",\"new_name\":\"1753340794_214_General_Human_Resources_Policy___Arabic.pdf\"}]', '2025-07-24 04:06:00', '2025-11-16 08:48:00'),
(92, 'DOC-20260429-3681', 'سياسة التوظيف', 'جميع مراحل التوظيف من الإعلان وحتى التعيين، مع ضمان الامتثال لمعايير العدالة، السعودة، التنوع، والتحقق المهني، لضمان استقطاب الكفاءات بك...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0007', NULL, NULL, NULL, 'documents/1753340867_214_Recruitment_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Recruitment_Policy___Arabic.pdf\",\"new_name\":\"1753340867_214_Recruitment_Policy___Arabic.pdf\"}]', '2025-07-24 04:07:00', '2025-08-21 07:24:00'),
(93, 'DOC-20260429-8261', 'سياسة مكافآت وتعويضات الموظفين', 'أنواع المكافآت والتعويضات وآلية صرفها، بما يعزز التحفيز والعدالة، مع ضمان الالتزام بالميزانية والضوابط التنظيمية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0010', NULL, NULL, NULL, 'documents/1753340923_214_Employee_Rewards_and_Compensation_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Rewards_and_Compensation_Policy___Arabic.pdf\",\"new_name\":\"1753340923_214_Employee_Rewards_and_Compensation_Policy___Arabic.pdf\"}]', '2025-07-24 04:08:00', '2025-07-31 05:42:00'),
(94, 'DOC-20260429-1383', 'سياسة إنهاء خدمات الموظفين', 'إجراءات إنهاء الخدمة بأنواعه، بما في ذلك الاستقالة، عدم التجديد، الفصل التأديبي، والمخالصة، مع ضمان الشفافية، الحقوق النظامية، وحق الاعت...', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0012', NULL, NULL, NULL, 'documents/1753340971_214_Employee_Termination_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Termination_Policy___Arabic.pdf\",\"new_name\":\"1753340971_214_Employee_Termination_Policy___Arabic.pdf\"}]', '2025-07-24 04:09:00', '2025-11-16 08:47:00'),
(95, 'DOC-20260429-3907', 'سياسة تقييم أداء الموظفين', 'آليات تقييم أداء الموظفين بشكل ربع سنوي وسنوي، باستخدام نماذج موحدة، وربط النتائج بالترقيات والمكافآت وخطط التطوير، مع ضمان الشفافية وال...', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0015', NULL, NULL, NULL, 'documents/1753341020_214_Employee_Performance_Evaluation_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Performance_Evaluation_Policy___Arabic.pdf\",\"new_name\":\"1753341020_214_Employee_Performance_Evaluation_Policy___Arabic.pdf\"}]', '2025-07-24 04:10:00', '2025-11-16 08:46:00'),
(96, 'DOC-20260429-3944', 'سياسة تطوير المسار الوظيفي', 'بناء مسارات وظيفية واضحة للموظفين، وتطويرهم من خلال خطط فردية، وربط الترقية بالجاهزية والإنجاز، بما يضمن النمو المهني المتوازن داخل الشر...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0017', NULL, NULL, NULL, 'documents/1753341059_214_Career_Development_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Career_Development_Policy___Arabic.pdf\",\"new_name\":\"1753341059_214_Career_Development_Policy___Arabic.pdf\"}]', '2025-07-24 04:11:00', '2025-07-31 05:42:00'),
(97, 'DOC-20260429-1065', 'سياسة الشكاوى والإجراءات التأديبية', 'آلية تقديم الشكاوى والتحقيق فيها، وضوابط فرض الجزاءات التأديبية، مع ضمان سرية الإجراءات وحماية حقوق الموظفين وتحقيق العدالة التنظيمية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0018', NULL, NULL, NULL, 'documents/1753341131_214_Employee_Complaints_and_Disciplinary_Actions_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Complaints_and_Disciplinary_Actions_Policy___Arabic.pdf\",\"new_name\":\"1753341131_214_Employee_Complaints_and_Disciplinary_Actions_Policy___Arabic.pdf\"}]', '2025-07-24 04:12:00', '2025-07-31 05:42:00'),
(98, 'DOC-20260429-8151', 'سياسة العمل عن بُعد', 'شروط العمل عن بُعد، وضوابط الأداء والتواصل والإنتاجية، وتحدد آلية الموافقات، المتابعة، والتعامل مع المخالفات، بما يضمن استمرارية العمل ب...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1HRM0021', NULL, NULL, NULL, 'documents/1753341181_214_Remote_Work_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Remote_Work_Policy___Arabic.pdf\",\"new_name\":\"1753341181_214_Remote_Work_Policy___Arabic.pdf\"}]', '2025-07-24 04:13:00', '2025-07-31 05:42:00'),
(99, 'DOC-20260429-7947', 'سياسة القروض', 'شروط وضوابط منح القروض السكنية والشخصية للموظفين، وآلية السداد، والضمانات، بما يضمن العدالة والامتثال المالي وتقليل المخاطر', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0005', NULL, NULL, NULL, 'documents/1753353099_214_Loan_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Loan_Policy___Arabic.pdf\",\"new_name\":\"1753353099_214_Loan_Policy___Arabic.pdf\"}]', '2025-07-24 07:32:00', '2025-11-16 08:44:00'),
(100, 'DOC-20260429-7541', 'سياسة الإجازات', 'أنواع الإجازات المستحقة للموظفين وشروطها، بما يشمل الإجازات السنوية، المرضية، الرسمية، والحالات الخاصة، لضمان التوازن بين متطلبات العمل...', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0009', NULL, NULL, NULL, 'documents/1753353198_214_Leave_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Leave_Policy___Arabic.pdf\",\"new_name\":\"1753353198_214_Leave_Policy___Arabic.pdf\"}]', '2025-07-24 07:33:00', '2025-11-16 08:43:00'),
(101, 'DOC-20260429-2946', 'سياسة الحضور والانصراف', 'ضوابط الحضور والانصراف،التأخيرات، والاستئذانات لضمان الانضباط الوظيفي، وتحدد آلية التعامل مع المخالفات والخصومات وفق اللوائح المعتمدة', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0001', NULL, NULL, NULL, 'documents/1753353237_214_Attendance_and_Punctuality_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Attendance_and_Punctuality_Policy___Arabic.pdf\",\"new_name\":\"1753353237_214_Attendance_and_Punctuality_Policy___Arabic.pdf\"}]', '2025-07-24 07:33:00', '2025-11-16 08:24:00'),
(102, 'DOC-20260429-9379', 'سياسة النقل والتكليف', 'ضوابط النقل والتكليف الداخلي والخارجي، وشروط الموافقة والاعتراض، وتضمن توافق القرارات مع الاحتياج التشغيلي ومعايير العدالة الوظيفية', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0022', NULL, NULL, NULL, 'documents/1753353392_214_Employee_Transfer_and_Delegation_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Transfer_and_Delegation_Policy___Arabic.pdf\",\"new_name\":\"1753353392_214_Employee_Transfer_and_Delegation_Policy___Arabic.pdf\"}]', '2025-07-24 07:37:00', '2025-11-16 08:42:00'),
(103, 'DOC-20260429-6438', 'سياسة المبيعات والتسويق', 'المبادئ المتعلقة بالتواصل مع العملاء، والإفصاح الكامل عن المنتجات التأمينية، وضمان تقديم خدمات ومشورة تتسم بالشفافية والمصداقية لتحقيق أ...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0001', NULL, NULL, NULL, 'documents/1753701365_214_Sales_and_Marketing_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Sales_and_Marketing_Policy_Arabic.pdf\",\"new_name\":\"1753701365_214_Sales_and_Marketing_Policy_Arabic.pdf\"}]', '2025-07-28 08:16:00', '2025-07-28 08:16:00'),
(104, 'DOC-20260429-5129', 'سياسة التسويق العامة', 'العمليات التسويقية والإدارية المتعلقة بإعداد وتنفيذ الحملات، الأدوار والمسؤوليات، التقييم السنوي، الالتزام بالهوية المؤسسية، التدريب، ...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0003', NULL, NULL, NULL, 'documents/1753701598_214_General_Marketing_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"General_Marketing_Policy_Arabic.pdf\",\"new_name\":\"1753701598_214_General_Marketing_Policy_Arabic.pdf\"}]', '2025-07-28 08:20:00', '2025-07-28 08:20:00'),
(105, 'DOC-20260429-7999', 'سياسة العلامة التجارية والإعلان', 'معايير الالتزام بالهوية البصرية، اعتماد المحتوى الإعلاني، الضوابط التنظيمية للنشر، الأرشفة، والتدابير التصحيحية لضمان الشفافية والجودة ...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0004', NULL, NULL, NULL, 'documents/1753701666_214_Branding_and_Advertising_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Branding_and_Advertising_Policy_Arabic.pdf\",\"new_name\":\"1753701666_214_Branding_and_Advertising_Policy_Arabic.pdf\"}]', '2025-07-28 08:21:00', '2025-07-28 08:21:00'),
(106, 'DOC-20260429-7878', 'سياسة الاتصال والتواصل مع العميل', 'أسس التواصل الرسمي مع العملاء، مع التركيز على التوثيق، السرعة في الاستجابة، والالتزام بالمعايير المهنية لحماية خصوصية العميل وضمان الجودة', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0005', NULL, NULL, NULL, 'documents/1753701747_214_Client_Communication_and_Interaction_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Communication_and_Interaction_Policy_Arabic.pdf\",\"new_name\":\"1753701747_214_Client_Communication_and_Interaction_Policy_Arabic.pdf\"}]', '2025-07-28 08:23:00', '2025-07-28 08:23:00'),
(107, 'DOC-20260429-9139', 'سياسة المواد الترويجية', 'ضوابط إعداد ونشر المواد الترويجية، القنوات المعتمدة، آلية المراجعة، ضوابط المحتوى، والتحليل، بالإضافة إلى الإجراءات التصحيحية للمخالفات', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0006', NULL, NULL, NULL, 'documents/1753701849_214_Promotional_Materials_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Promotional_Materials_Policy_Arabic.pdf\",\"new_name\":\"1753701849_214_Promotional_Materials_Policy_Arabic.pdf\"}]', '2025-07-28 08:24:00', '2025-07-28 08:24:00'),
(108, 'DOC-20260429-7704', 'سياسة أبحاث السوق', 'منهجية أبحاث السوق وضوابط جمع البيانات، النزاهة، الخصوصية، والتدقيق لضمان دقة وشفافية الأبحاث وتأثيرها على تطوير المنتجات والحملات التسو...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0007', NULL, NULL, NULL, 'documents/1753701885_214_Market_Research_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Market_Research_Policy_Arabic.pdf\",\"new_name\":\"1753701885_214_Market_Research_Policy_Arabic.pdf\"}]', '2025-07-28 08:25:00', '2025-07-28 08:25:00'),
(109, 'DOC-20260429-9601', 'سياسة بروتوكولات المبيعات والتسويق', 'بروتوكولات التواصل مع العملاء، المظهر والسلوك المهني، الإقناع، والخصوصية، مع ضمان التدريب المستمر والتقييم الدوري لتحقيق الامتثال الكام...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0008', NULL, NULL, NULL, 'documents/1753701919_214_Sales_and_Marketing_Protocols_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Sales_and_Marketing_Protocols_Policy_Arabic.pdf\",\"new_name\":\"1753701919_214_Sales_and_Marketing_Protocols_Policy_Arabic.pdf\"}]', '2025-07-28 08:25:00', '2025-07-28 08:25:00'),
(110, 'DOC-20260429-2850', 'سياسة إدارة الخدمات والفعاليات', 'ضوابط تقديم وتنفيذ الفعاليات الداخلية والخارجية، من خلال تنسيق الموارد، الموافقات، التوثيق، التقييم، والأداء لضمان فعالية ودقة التنظيم', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0009', NULL, NULL, NULL, 'documents/1753702122_214_Services_and_Events_Management_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Services_and_Events_Management_Policy_Arabic.pdf\",\"new_name\":\"1753702122_214_Services_and_Events_Management_Policy_Arabic.pdf\"}]', '2025-07-28 08:29:00', '2025-07-28 08:29:00'),
(111, 'DOC-20260429-4516', 'سياسة إدارة وكالات التسويق', 'شروط التعاقد مع الوكالات التسويقية، بدءًا من الاتفاقيات ومراجعة الأداء، إلى الإجراءات التصحيحية في حال الإخفاق، وضمان الالتزام بالمعايير...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0010', NULL, NULL, NULL, 'documents/1753702197_214_Marketing_Agencies_Management_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Marketing_Agencies_Management_Policy_Arabic.pdf\",\"new_name\":\"1753702197_214_Marketing_Agencies_Management_Policy_Arabic.pdf\"}]', '2025-07-28 08:30:00', '2025-07-29 05:36:00'),
(112, 'DOC-20260429-2791', 'سياسة ممارسات البيع', 'ضوابط عرض المنتجات بوضوح، تجنب الضغط البيعي، وضمان الامتثال والشفافية في جميع عمليات البيع', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0011', NULL, NULL, NULL, 'documents/1753702266_214_Sales_Practices_Policy__Transparency_and_Clarity__Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Sales_Practices_Policy__Transparency_and_Clarity__Arabic.pdf\",\"new_name\":\"1753702266_214_Sales_Practices_Policy__Transparency_and_Clarity__Arabic.pdf\"}]', '2025-07-28 08:31:00', '2025-07-28 08:31:00'),
(113, 'DOC-20260429-6788', 'سياسة تأهيل واعتماد موظفي المبيعات', 'شروط التعاقد والتأهيل لموظفي المبيعات، مع التركيز على الامتثال للمتطلبات التنظيمية، تقييم الأداء، تدريب التصحيح، والتحديثات السنوية لضم...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0012', NULL, NULL, NULL, 'documents/1753702308_214_Sales_Staff_Qualification_and_Accreditation_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Sales_Staff_Qualification_and_Accreditation_Policy_Arabic.pdf\",\"new_name\":\"1753702308_214_Sales_Staff_Qualification_and_Accreditation_Policy_Arabic.pdf\"}]', '2025-07-28 08:32:00', '2025-07-28 08:32:00'),
(114, 'DOC-20260429-9189', 'سياسة الإفصاح عن المنتجات التأمينية', 'ضوابط الإفصاح الشامل والواضح للعملاء عن المنتجات التأمينية، مع ضمان التوثيق والامتثال الكامل للشروط التنظيمية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0013', NULL, NULL, NULL, 'documents/1753702367_214_Insurance_Product_Disclosure_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Product_Disclosure_Policy_Arabic.pdf\",\"new_name\":\"1753702367_214_Insurance_Product_Disclosure_Policy_Arabic.pdf\"}]', '2025-07-28 08:33:00', '2025-07-28 08:33:00'),
(115, 'DOC-20260429-8107', 'سياسة حدود التفويض لدايموند', 'ضوابط التفويض الرسمي للعملاء في دايموند، بما في ذلك توثيق التفويض، نطاقه الزمني، آلية المراجعة، وضمان الامتثال لجميع الإجراءات والضوابط ا...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0014', NULL, NULL, NULL, 'documents/1753702428_214_Diamond_Authorization_Limits_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Diamond_Authorization_Limits_Policy_Arabic.pdf\",\"new_name\":\"1753702428_214_Diamond_Authorization_Limits_Policy_Arabic.pdf\"}]', '2025-07-28 08:33:00', '2025-07-28 08:33:00'),
(116, 'DOC-20260429-7480', 'سياسة إدارة حملات العروض الخاصة والترويجية', 'ضوابط إطلاق وتنفيذ الحملات الترويجية، بما في ذلك إعداد المقترحات، إعداد المحتوى، التنسيق مع شركات التأمين، المتابعة والتقييم، وضمان الام...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0015', NULL, NULL, NULL, 'documents/1753702454_214_Special_Offers_and_Promotional_Campaigns_Management_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Special_Offers_and_Promotional_Campaigns_Management_Policy_Arabic.pdf\",\"new_name\":\"1753702454_214_Special_Offers_and_Promotional_Campaigns_Management_Policy_Arabic.pdf\"}]', '2025-07-28 08:34:00', '2025-07-28 08:34:00'),
(117, 'DOC-20260429-7311', 'سياسة البيع التكميلي', 'بيع المنتجات التكملية من خلال الإفصاح الشفاف، التوثيق المناسب، وضمان أن تكون العروض ذات صلة وملائمة لاحتياجات العميل مع الالتزام بأعلى مع...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0016', NULL, NULL, NULL, 'documents/1753702540_214_Cross_selling_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Cross_selling_Policy_Arabic.pdf\",\"new_name\":\"1753702540_214_Cross_selling_Policy_Arabic.pdf\"}]', '2025-07-28 08:35:00', '2025-07-28 08:35:00'),
(118, 'DOC-20260429-5302', 'سياسة الأداء البيعي', 'قياس الأداء البيعي من خلال مؤشرات دقيقة تعتمد على جودة المبيعات، الالتزام التنظيمي، رضا العملاء، وتقييم الأداء المستمر لضمان تحقيق الأهدا...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0017', NULL, NULL, NULL, 'documents/1753702580_214_Sales_Performance_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Sales_Performance_Policy_Arabic.pdf\",\"new_name\":\"1753702580_214_Sales_Performance_Policy_Arabic.pdf\"}]', '2025-07-28 08:36:00', '2025-07-28 08:36:00'),
(119, 'DOC-20260429-6250', 'سياسة دعم أنشطة المبيعات', 'التزام الإدارات المختلفة بتقديم الدعم المستمر والفعال للمبيعات، مع تحديد آليات استجابة سريعة، تصعيد الطلبات غير المستجاب لها، وضمان التن...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0018', NULL, NULL, NULL, 'documents/1753702613_214_Sales_Support_Activities_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Sales_Support_Activities_Policy_Arabic.pdf\",\"new_name\":\"1753702613_214_Sales_Support_Activities_Policy_Arabic.pdf\"}]', '2025-07-28 08:37:00', '2025-07-28 08:37:00'),
(120, 'DOC-20260429-6500', 'سياسة تطوير المنتجات', 'تتبع الشركة مراحل تطوير المنتج من التحليل الأولي وحتى الإطلاق، مع التركيز على الامتثال التنظيمي، دراسة السوق، والقياس المستمر لأداء المنت...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0019', NULL, NULL, NULL, 'documents/1753702673_214_Product_Development_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Product_Development_Policy_Arabic.pdf\",\"new_name\":\"1753702673_214_Product_Development_Policy_Arabic.pdf\"}]', '2025-07-28 08:38:00', '2025-07-28 08:38:00'),
(121, 'DOC-20260429-1409', 'سياسة توليد العملاء المحتملين', 'تلتزم الشركة بتوليد العملاء المحتملين عبر قنوات معتمدة، مع توثيق شامل للبيانات، التفاعل الفعّال، وتحليل الأداء لضمان الجودة والامتثال ال...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0020', NULL, NULL, NULL, 'documents/1753702698_214_Lead_Generation_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Lead_Generation_Policy_Arabic.pdf\",\"new_name\":\"1753702698_214_Lead_Generation_Policy_Arabic.pdf\"}]', '2025-07-28 08:38:00', '2025-07-28 08:38:00'),
(122, 'DOC-20260429-4469', 'سياسة متابعة التواصل مع العملاء', '\"تنظم هذه السياسة آلية التواصل مع العملاء قبل إصدار أو تجديد الوثائق التأمينية، وتضمن متابعة العروض، إعلام العملاء بالتحديثات، وضمان رضاه...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0002', NULL, NULL, NULL, 'documents/1753702768_214_Client_Communication_Follow_up_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Communication_Follow_up_Policy_Arabic.pdf\",\"new_name\":\"1753702768_214_Client_Communication_Follow_up_Policy_Arabic.pdf\"}]', '2025-07-28 08:39:00', '2025-07-28 08:39:00'),
(123, 'DOC-20260429-5860', 'إجراءات إدارة المبيعات', NULL, 2, 44, 44, NULL, NULL, 'procedure', 'draft', 'v1.0', NULL, NULL, NULL, 'documents/1753704241_214_Sales_procedures___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Sales_procedures___Arabic.pdf\",\"new_name\":\"1753704241_214_Sales_procedures___Arabic.pdf\"}]', '2025-07-28 09:04:00', '2025-07-28 09:04:00'),
(124, 'DOC-20260429-7177', 'إجراءات إدارة التسويق', NULL, 2, 44, 44, NULL, NULL, 'procedure', 'draft', 'v1.0', NULL, NULL, NULL, 'documents/1753705364_214_Marketing_procedures___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Marketing_procedures___Arabic.pdf\",\"new_name\":\"1753705364_214_Marketing_procedures___Arabic.pdf\"}]', '2025-07-28 09:23:00', '2025-07-28 09:23:00'),
(125, 'DOC-20260429-9666', 'سياسة إدارة وكالات التسويق', 'شروط التعاقد مع الوكالات التسويقية، بدءًا من الاتفاقيات ومراجعة الأداء، إلى الإجراءات التصحيحية في حال الإخفاق، وضمان الالتزام بالمعايير...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1SMM0010', NULL, NULL, NULL, 'documents/1753778268_214_Marketing_Agencies_Management_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Marketing_Agencies_Management_Policy_Arabic.pdf\",\"new_name\":\"1753778268_214_Marketing_Agencies_Management_Policy_Arabic.pdf\"}]', '2025-07-29 05:39:00', '2025-07-29 05:39:00'),
(126, 'DOC-20260429-7415', 'سياسة حوكمة تقنية المعلومات', 'إطار الحوكمة التقنية في الشركة، بما في ذلك تنفيذ المشاريع التقنية وفق الأهداف التشغيلية، حماية البيانات، ضمان استمرارية العمل، وتحديد مسؤ...', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0001', NULL, NULL, NULL, 'documents/1753788000_214_Information_Technology_Governance_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Technology_Governance_Policy_Arabic.pdf\",\"new_name\":\"1753788000_214_Information_Technology_Governance_Policy_Arabic.pdf\"}]', '2025-07-29 08:20:00', '2025-09-04 07:18:00'),
(127, 'DOC-20260429-5223', 'سياسة إدارة تقنية المعلومات', 'إدارة الأصول التقنية، الشبكات، البرمجيات، وحماية البيانات لضمان الأمان والامتثال التنظيمي، مع التأكيد على تحديث الأنظمة بشكل دوري وتدريب...', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0002', NULL, NULL, NULL, 'documents/1753788154_214_Information_Technology_Management_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Technology_Management_Policy_Arabic.pdf\",\"new_name\":\"1753788154_214_Information_Technology_Management_Policy_Arabic.pdf\"}]', '2025-07-29 08:22:00', '2025-09-04 07:21:00'),
(128, 'DOC-20260429-2584', 'سياسة أمن مستخدمي تقنية المعلومات', 'قواعد استخدام الحسابات التقنية، حماية المعلومات، إدارة صلاحيات الوصول، والإبلاغ عن الحوادث الأمنية. كما تركز على أهمية حماية البيانات، اس...', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0003', NULL, NULL, NULL, 'documents/1753788438_214_Information_Technology_User_Security_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Technology_User_Security_Policy_Arabic.pdf\",\"new_name\":\"1753788438_214_Information_Technology_User_Security_Policy_Arabic.pdf\"}]', '2025-07-29 08:27:00', '2025-09-04 07:23:00'),
(129, 'DOC-20260429-2029', 'سياسة أمن أنظمة تقنية المعلومات', 'معايير الأمان لأنظمة تقنية المعلومات في الشركة، بما في ذلك التكوين الآمن، التحكم في الوصول، حماية البيانات، وأمن الشبكات. تركز على مراقبة ...', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0004', NULL, NULL, NULL, 'documents/1753788571_214_Information_Technology_Systems_Security_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Technology_Systems_Security_Policy_Arabic.pdf\",\"new_name\":\"1753788571_214_Information_Technology_Systems_Security_Policy_Arabic.pdf\"}]', '2025-07-29 08:29:00', '2025-09-04 07:25:00'),
(130, 'DOC-20260429-4520', 'سياسة أجهزة تقنية المعلومات', 'كيفية إدارة الأجهزة التقنية داخل الشركة، بدءًا من التخصيص والصيانة إلى التحديثات والمراجعات الدورية، مع التأكيد على الأمان وحماية البيان...', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0005', NULL, NULL, NULL, 'documents/1753788672_214_Information_Technology_Devices_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Technology_Devices_Policy_Arabic.pdf\",\"new_name\":\"1753788672_214_Information_Technology_Devices_Policy_Arabic.pdf\"}]', '2025-07-29 08:31:00', '2025-09-04 07:27:00'),
(131, 'DOC-20260429-9675', 'سياسة برمجيات تقنية المعلومات', 'ضوابط تصنيف البرمجيات واستخدامها، بما في ذلك البرمجيات الجاهزة، المطورة داخليًا، والمفتوحة المصدر، مع تحديد شروط تقييم الجدوى، الدعم الف...', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0006', NULL, NULL, NULL, 'documents/1753788749_214_Information_Technology_Software_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Technology_Software_Policy_Arabic.pdf\",\"new_name\":\"1753788749_214_Information_Technology_Software_Policy_Arabic.pdf\"}]', '2025-07-29 08:32:00', '2025-09-04 07:28:00'),
(132, 'DOC-20260429-5166', 'سياسة أنظمة الهاتف والاتصال الهاتفي', 'ضوابط إدارة وتخصيص الخطوط الهاتفية والأجهزة المحمولة، بما في ذلك تحديد الاحتياجات، اختيار مزود الخدمة، مراقبة الاستخدام، الأمان، إدارة ا...', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0007', NULL, NULL, NULL, 'documents/1753788851_214_Telephone_and_Communication_Systems_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Telephone_and_Communication_Systems_Policy_Arabic.pdf\",\"new_name\":\"1753788851_214_Telephone_and_Communication_Systems_Policy_Arabic.pdf\"}]', '2025-07-29 08:34:00', '2025-09-04 07:30:00'),
(133, 'DOC-20260429-2288', 'سياسة إدارة المعلومات الإدارية', 'ضوابط إنشاء، تصنيف، حفظ، تداول، تعديل، وحذف المعلومات الإدارية داخل النظام المعتمد، مع ضمان الأمان، المراقبة، التوثيق، والتدريب لضمان ال...', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0008', NULL, NULL, NULL, 'documents/1753788922_214_Administrative_Information_Management_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Administrative_Information_Management_Policy_Arabic.pdf\",\"new_name\":\"1753788922_214_Administrative_Information_Management_Policy_Arabic.pdf\"}]', '2025-07-29 08:35:00', '2025-09-04 07:31:00'),
(134, 'DOC-20260429-2920', 'سياسة إدارة الموقع الإلكتروني', 'ضوابط إنشاء، تحديث، أمن، وحفظ المحتوى على الموقع الإلكتروني، مع ضمان التوافق مع المعايير الأمنية والتقنية، وتحديد آليات المراجعة الدورية...', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0009', NULL, NULL, NULL, 'documents/1753788981_214_Website_Management_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Website_Management_Policy_Arabic.pdf\",\"new_name\":\"1753788981_214_Website_Management_Policy_Arabic.pdf\"}]', '2025-07-29 08:36:00', '2025-09-04 07:32:00'),
(135, 'DOC-20260429-2986', 'سياسة النسخ الاحتياطي', 'نفيذ نسخ يومية وتزايدية، وتخزين النسخ في مواقع آمنة، مع مراقبة دورية، وإجراءات للطوارئ، وإتلاف آمن للوسائط لضمان استمرارية البيانات وحماي...', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0011', NULL, NULL, NULL, 'documents/1753789137_214_Backup_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Backup_Policy_Arabic.pdf\",\"new_name\":\"1753789137_214_Backup_Policy_Arabic.pdf\"}]', '2025-07-29 08:38:00', '2025-09-04 07:34:00'),
(136, 'DOC-20260429-9261', 'سياسة إدارة الوصول', 'إنشاء الحسابات، مراجعة الصلاحيات، تطبيق مبدأ \"أقل صلاحية\"، وتفعيل المصادقة متعددة العوامل، مع توثيق الوصول والتدريب لضمان الأمان والامتثال', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0012', NULL, NULL, NULL, 'documents/1753789191_214_Access_Management_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Access_Management_Policy_Arabic.pdf\",\"new_name\":\"1753789191_214_Access_Management_Policy_Arabic.pdf\"}]', '2025-07-29 08:39:00', '2025-09-04 07:35:00'),
(137, 'DOC-20260429-1329', 'سياسة استخدام البريد الإلكتروني والإنترنت', 'إنشاء الحسابات، مراجعة الصلاحيات، تطبيق مبدأ \"أقل صلاحية\"، وتفعيل المصادقة متعددة العوامل، مع توثيق الوصول والتدريب لضمان الأمان والامتثال', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0013', NULL, NULL, NULL, 'documents/1753789249_214_Email_and_Internet_Usage_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Email_and_Internet_Usage_Policy_Arabic.pdf\",\"new_name\":\"1753789249_214_Email_and_Internet_Usage_Policy_Arabic.pdf\"}]', '2025-07-29 08:40:00', '2025-09-04 07:36:00'),
(138, 'DOC-20260429-4769', 'سياسة تحديثات البرمجيات', 'إجراءات تحديث البرمجيات، بدءًا من التخطيط والتقييم قبل التنفيذ، مرورًا بتصنيف التحديثات، والتوثيق، والمراجعة بعد التنفيذ، مع التأكيد على...', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0014', NULL, NULL, NULL, 'documents/1753789350_214_Software_Updates_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Software_Updates_Policy_Arabic.pdf\",\"new_name\":\"1753789350_214_Software_Updates_Policy_Arabic.pdf\"}]', '2025-07-29 08:42:00', '2025-09-04 07:38:00'),
(139, 'DOC-20260429-1233', 'سياسة الشراكات الإستراتيجية', 'منهجية لإقامة شراكات استراتيجية من خلال مراحل التحليل، التقييم، التفاوض، التنفيذ، والتقييم الدوري لضمان نجاح الشراكة', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1QDM0001', NULL, NULL, NULL, 'documents/1753868709_214_Strategic_Partnerships_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Strategic_Partnerships_Policy___Arabic.pdf\",\"new_name\":\"1753868709_214_Strategic_Partnerships_Policy___Arabic.pdf\"}]', '2025-07-30 06:45:00', '2025-07-30 06:45:00'),
(140, 'DOC-20260429-4321', 'سياسة إدارة الشركاء', 'إدارة العلاقات مع الشركاء الاستراتيجيين بعد اعتمادهم رسميًا، لضمان تنفيذ الشراكات بشكل فعال ومتوافق مع الأهداف التشغيلية والتطويرية', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1QDM0002', NULL, NULL, NULL, 'documents/1753868787_214_Partner_Management_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Partner_Management_Policy___Arabic.pdf\",\"new_name\":\"1753868787_214_Partner_Management_Policy___Arabic.pdf\"}]', '2025-07-30 06:46:00', '2025-08-02 12:05:00'),
(141, 'DOC-20260429-9647', 'سياسة إدارة الجودة والتطوير', 'تحقيق الجودة الشاملة والتحسين المستمر في جميع العمليات المؤسسية، وضمان الامتثال للسياسات والإجراءات المعتمدة', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1QDM0003', NULL, NULL, NULL, 'documents/1753868844_214_Quality_and_Development_Management_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Quality_and_Development_Management_Policy___Arabic.pdf\",\"new_name\":\"1753868844_214_Quality_and_Development_Management_Policy___Arabic.pdf\"}]', '2025-07-30 06:47:00', '2025-07-30 06:47:00'),
(142, 'DOC-20260429-9895', 'سياسة اتفاقيات مستوى الخدمة (SLA)', 'تنظيم وإدارة اتفاقيات مستوى الخدمة لضمان تقديم خدمات متوافقة مع المعايير المتفق عليها، والامتثال للإجراءات المتبعة، ومعالجة حالات الإخلا...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1QDM0004', NULL, NULL, NULL, 'documents/1753868899_214_Service_Level_Agreements__SLA__Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Service_Level_Agreements__SLA__Policy.pdf\",\"new_name\":\"1753868899_214_Service_Level_Agreements__SLA__Policy.pdf\"}]', '2025-07-30 06:48:00', '2025-07-30 06:48:00'),
(143, 'DOC-20260429-6475', 'سياسة إدارة التحسين المستمر', 'تعزيز ثقافة التحسين المستمر من خلال تحديد فرص التحسين، متابعة تنفيذها، وتقييم نتائجها لتحقيق الأداء الأمثل في جميع أنشطة الشركة', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1QDM0005', NULL, NULL, NULL, 'documents/1753868939_214_Continuous_Improvement_Management_Policy___PDF.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Continuous_Improvement_Management_Policy___PDF.pdf\",\"new_name\":\"1753868939_214_Continuous_Improvement_Management_Policy___PDF.pdf\"}]', '2025-07-30 06:49:00', '2025-07-30 06:49:00'),
(144, 'DOC-20260429-3988', 'سياسة تحليل أداء العمليات', 'تحليل أداء جميع عمليات الشركة، مع التركيز على جمع البيانات الدقيقة، وتحليل الانحرافات، ووضع خطط تحسين تضمن تنفيذ الأهداف المؤسسية وتحقيق ...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1QDM0006', NULL, NULL, NULL, 'documents/1753869197_214_Operational_Performance_Analysis_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Operational_Performance_Analysis_Policy___Arabic.pdf\",\"new_name\":\"1753869197_214_Operational_Performance_Analysis_Policy___Arabic.pdf\"}]', '2025-07-30 06:53:00', '2025-07-30 06:53:00'),
(145, 'DOC-20260429-4418', 'سياسة إدارة المخاطر المرتبطة بالجودة', 'إدارة وتحليل المخاطر المرتبطة بالجودة عبر تحديد، تقييم، معالجة، وتوثيق المخاطر المؤسسية، مع تطبيق آليات فعالة للوقاية والتحسين المستمر', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1QDM0007', NULL, NULL, NULL, 'documents/1753869253_214_Risk_Management_Policy_Related_to_Quality___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Risk_Management_Policy_Related_to_Quality___Arabic.pdf\",\"new_name\":\"1753869253_214_Risk_Management_Policy_Related_to_Quality___Arabic.pdf\"}]', '2025-07-30 06:54:00', '2025-07-30 06:54:00'),
(146, 'DOC-20260429-1587', 'سياسة رضا  العملاء', 'تحسين رضا العملاء من خلال نظام رقابي شامل يتابع جميع مراحل رحلة العميل، ويشمل قياس الأداء، تحليل الشكاوى، وتطبيق خطط التحسين المستمر لتعزي...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1QDM0008', NULL, NULL, NULL, 'documents/1753869403_214_Client_Satisfaction_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Satisfaction_Policy___Arabic.pdf\",\"new_name\":\"1753869403_214_Client_Satisfaction_Policy___Arabic.pdf\"}]', '2025-07-30 06:56:00', '2025-07-30 06:56:00'),
(147, 'DOC-20260429-6102', 'سياسة رضا الموظفين', 'قياس وتحليل رضا الموظفين سنويًا، تهدف لتحسين بيئة العمل من خلال استبيانات سرية، مع متابعة النتائج واتخاذ إجراءات تصحيحية لتطوير الأداء ال...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1QDM0009', NULL, NULL, NULL, 'documents/1753869428_214_Employee_Satisfaction_Policy___Aarbic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Satisfaction_Policy___Aarbic.pdf\",\"new_name\":\"1753869428_214_Employee_Satisfaction_Policy___Aarbic.pdf\"}]', '2025-07-30 06:57:00', '2025-07-30 06:57:00'),
(148, 'DOC-20260429-2103', 'سياسة بيئة العمل', 'تحسين بيئة العمل من خلال تقييم دوري وشامل لعدة جوانب مثل التواصل الإداري، العدالة، وسلامة توزيع المهام، مع ضمان سرية البيانات وتحليل النتا...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1QDM0010', NULL, NULL, NULL, 'documents/1753869535_214_Workplace_Environment_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Workplace_Environment_Policy___Arabic.pdf\",\"new_name\":\"1753869535_214_Workplace_Environment_Policy___Arabic.pdf\"}]', '2025-07-30 06:59:00', '2025-07-30 06:59:00'),
(149, 'DOC-20260429-5207', 'سياسة إنشاء سياسات وإجراءات لعمل غير محوكم', 'ISO 9001:2015 تطبيق معايير الجودة الشاملة وضمان التعاون مع جميع الإدارات عند تحديث السياسات والإجراءات. يتم مراجعة السياسات دورياً، مع الالتزا...', 2, 44, 44, NULL, NULL, 'policy', 'draft', '1QDM0011', NULL, NULL, NULL, 'documents/1753869571_214_Policy_for_Creating_Policies_and_Procedures_for_Uncontrolled_Work___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Policy_for_Creating_Policies_and_Procedures_for_Uncontrolled_Work___Arabic.pdf\",\"new_name\":\"1753869571_214_Policy_for_Creating_Policies_and_Procedures_for_Uncontrolled_Work___Arabic.pdf\"}]', '2025-07-30 06:59:00', '2025-07-30 06:59:00'),
(150, 'DOC-20260429-1729', 'سياسة إدارة وأمان موارد الأجهزة', 'ضوابط قفل الأجهزة عند عدم الاستخدام، وتنظيف القرص بشكل دوري لحذف الملفات غير الضرورية، مع الالتزام بتدريب الموظفين على الأمان الرقمي وحما...', 1, 44, 44, NULL, NULL, 'policy', 'draft', '1ITM0010', NULL, NULL, NULL, 'documents/1753870540_214_IT_Resources_Management_and_Security_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"IT_Resources_Management_and_Security_Policy___Arabic.pdf\",\"new_name\":\"1753870540_214_IT_Resources_Management_and_Security_Policy___Arabic.pdf\"}]', '2025-07-30 07:16:00', '2025-09-04 07:54:00'),
(151, 'DOC-20260429-1016', 'إجراءات قسم الأمن السيبراني', NULL, 1, 54, 54, NULL, NULL, 'procedure', 'draft', 'v1.0', NULL, NULL, NULL, 'documents/1753874943_214_Cybersecurity_Procedures___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Cybersecurity_Procedures___Arabic.pdf\",\"new_name\":\"1753874943_214_Cybersecurity_Procedures___Arabic.pdf\"}]', '2025-07-30 08:29:00', '2025-09-08 05:33:00'),
(152, 'DOC-20260429-4719', 'سياسة التدريب', 'آلية استقطاب المتدربين وتدريب الموظفين الجدد والحاليين، بهدف تطوير المهارات ورفع الكفاءة بما يتماشى مع احتياجات الشركة وأهدافها الاسترات...', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0016', NULL, NULL, NULL, 'documents/1753951571_214_Training_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Training_Policy_Arabic.pdf\",\"new_name\":\"1753951571_214_Training_Policy_Arabic.pdf\"}]', '2025-07-31 05:46:00', '2025-11-16 08:42:00'),
(153, 'DOC-20260429-4497', 'سياسة أخلاقيات الموظفين ومدونة قواعد السلوك', 'توضح السياسة سلوكيات الموظف المتوقعة داخل بيئة العمل وخارجها، وتحدد مبادئ النزاهة، السرية، احترام الزملاء، وتجنب تضارب المصالح، مع تصنيف ...', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0019', NULL, NULL, NULL, 'documents/1753951705_214_Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf\",\"new_name\":\"1753951705_214_Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf\"}]', '2025-07-31 05:48:00', '2025-11-16 08:41:00'),
(154, 'DOC-20260429-7528', 'سياسة الأمن وحماية السرية', 'ضوابط تصنيف وحماية بيانات الموظفين، وتحدد صلاحيات الوصول، وآليات المشاركة الداخلية والخارجية، وتفرض عقوبات صارمة على أي خرق للسرية', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0020', NULL, NULL, NULL, 'documents/1753951808_214_Security_and_Confidentiality_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Security_and_Confidentiality_Policy_Arabic.pdf\",\"new_name\":\"1753951808_214_Security_and_Confidentiality_Policy_Arabic.pdf\"}]', '2025-07-31 05:50:00', '2025-11-16 08:40:00'),
(155, 'DOC-20260429-6562', 'سياسة الانضمام الوظيفي (التوجيه الوظيفي للموظفين الجدد)', 'تنظم السياسة إجراءات استقبال وتوجيه الموظفين الجدد خلال أول 30 يوم عمل لضمان تكيفهم السلس مع بيئة العمل وتعزيز جاهزيتهم المهنية منذ اليوم ا...', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0008', NULL, NULL, NULL, 'documents/1753951872_214_Employee_Onboarding_and_Orientation_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Onboarding_and_Orientation_Policy_Arabic.pdf\",\"new_name\":\"1753951872_214_Employee_Onboarding_and_Orientation_Policy_Arabic.pdf\"}]', '2025-07-31 05:51:00', '2025-11-16 08:39:00'),
(156, 'DOC-20260429-8864', 'سياسة البدلات والترقيات', 'ضوابط صرف البدلات وشروط الترقية، بما يضمن العدالة وتحفيز الأداء، مع مراعاة التدرج الوظيفي والاستحقاقات المرتبطة بالمهام الفعلية', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0011', NULL, NULL, NULL, 'documents/1753951947_214_Allowances_and_Promotions_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Allowances_and_Promotions_Policy_Arabic.pdf\",\"new_name\":\"1753951947_214_Allowances_and_Promotions_Policy_Arabic.pdf\"}]', '2025-07-31 05:52:00', '2025-11-16 08:34:00'),
(157, 'DOC-20260429-9839', 'سياسة الترفيه والضيافة', 'ضوابط الصرف على الضيافة والفعاليات الداخلية، بما يضمن تعزيز بيئة العمل دون تجاوز الميزانيات أو إساءة الاستخدام', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0014', NULL, NULL, NULL, 'documents/1753952026_214_Entertainment_and_Hospitality_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Entertainment_and_Hospitality_Policy_Arabic.pdf\",\"new_name\":\"1753952026_214_Entertainment_and_Hospitality_Policy_Arabic.pdf\"}]', '2025-07-31 05:53:00', '2025-11-16 08:33:00'),
(158, 'DOC-20260429-3481', 'سياسة السفر لأغراض العمل', 'سفر الموظفين في المهام الرسمية داخل المملكة وخارجها، وتشمل ضوابط التكليف، التكاليف، البدلات، والتمثيل المهني للشركة', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0013', NULL, NULL, NULL, 'documents/1753952082_214_Business_Travel_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Business_Travel_Policy_Arabic.pdf\",\"new_name\":\"1753952082_214_Business_Travel_Policy_Arabic.pdf\"}]', '2025-07-31 05:54:00', '2025-11-16 08:32:00'),
(159, 'DOC-20260429-3615', 'سياسة الشكاوى والإجراءات التأديبية', 'آلية تقديم الشكاوى والتحقيق فيها، وضوابط فرض الجزاءات التأديبية، مع ضمان سرية الإجراءات وحماية حقوق الموظفين وتحقيق العدالة التنظيمية', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0018', NULL, NULL, NULL, 'documents/1753952217_214_Employee_Complaints_and_Disciplinary_Actions_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Complaints_and_Disciplinary_Actions_Policy_Arabic.pdf\",\"new_name\":\"1753952217_214_Employee_Complaints_and_Disciplinary_Actions_Policy_Arabic.pdf\"}]', '2025-07-31 05:57:00', '2025-11-16 08:32:00'),
(160, 'DOC-20260429-2728', 'سياسة العمل عن بُعد', 'شروط العمل عن بُعد، وضوابط الأداء والتواصل والإنتاجية، وتحدد آلية الموافقات، المتابعة، والتعامل مع المخالفات، بما يضمن استمرارية العمل ب...', 2, 54, 54, NULL, NULL, 'policy', 'draft', '1HRM0021', NULL, NULL, NULL, 'documents/1753952299_214_Remote_Work_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Remote_Work_Policy_Arabic.pdf\",\"new_name\":\"1753952299_214_Remote_Work_Policy_Arabic.pdf\"}]', '2025-07-31 05:58:00', '2025-11-16 08:30:00'),
(161, 'DOC-20260429-4310', 'سياسة المسؤولية الاجتماعية', 'التزام الشركة بالمساهمة المجتمعية من خلال مبادرات بيئية، تعليمية، وتوظيفية، بما يعزز التنمية المستدامة ويعكس قيم دايموند المؤسسية', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0004', NULL, NULL, NULL, 'documents/1753952372_214_Corporate_Social_Responsibility__CSR__Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Corporate_Social_Responsibility__CSR__Policy.pdf\",\"new_name\":\"1753952372_214_Corporate_Social_Responsibility__CSR__Policy.pdf\"}]', '2025-07-31 05:59:00', '2025-11-16 08:29:00'),
(162, 'DOC-20260429-1708', 'سياسة تطوير المسار الوظيفي', 'بناء مسارات وظيفية واضحة للموظفين، وتطويرهم من خلال خطط فردية، وربط الترقية بالجاهزية والإنجاز، بما يضمن النمو المهني المتوازن داخل الشركة', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0017', NULL, NULL, NULL, 'documents/1753952455_214_Career_Development_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Career_Development_Policy_Arabic.pdf\",\"new_name\":\"1753952455_214_Career_Development_Policy_Arabic.pdf\"}]', '2025-07-31 06:00:00', '2025-11-16 08:28:00'),
(163, 'DOC-20260429-4809', 'سياسة مكافآت وتعويضات الموظفين', 'أنواع المكافآت والتعويضات وآلية صرفها، بما يعزز التحفيز والعدالة، مع ضمان الالتزام بالميزانية والضوابط التنظيمية', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0010', NULL, NULL, NULL, 'documents/1753952522_214_Employee_Rewards_and_Compensation_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Rewards_and_Compensation_Policy_Arabic.pdf\",\"new_name\":\"1753952522_214_Employee_Rewards_and_Compensation_Policy_Arabic.pdf\"}]', '2025-07-31 06:02:00', '2025-11-16 08:26:00'),
(164, 'DOC-20260429-1796', 'سياسة إدارة البائعين', 'تلتزم الشركة بإدارة علاقاتها مع البائعين من خلال اتباع إجراءات معتمدة لضمان الشفافية، التقييم العادل، وحماية سرية العروض، مع الالتزام بسي...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1PD0001', NULL, NULL, NULL, 'documents/1753952785_214_Vendor_Management_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Vendor_Management_Policy_Arabic.pdf\",\"new_name\":\"1753952785_214_Vendor_Management_Policy_Arabic.pdf\"}]', '2025-07-31 06:06:00', '2025-07-31 06:06:00'),
(165, 'DOC-20260429-6733', 'سياسة إدارة المشتريات', 'خطوات شراء المنتجات والخدمات بدءًا من تقديم الطلب وتقييم العروض وصولًا إلى الاستلام والتوثيق مع ضمان الشفافية والامتثال للمعايير القانون...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1PD0002', NULL, NULL, NULL, 'documents/1753952838_214_Procurement_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Procurement_Policy_Arabic.pdf\",\"new_name\":\"1753952838_214_Procurement_Policy_Arabic.pdf\"}]', '2025-07-31 06:07:00', '2025-07-31 06:07:00'),
(166, 'DOC-20260429-6732', 'سياسة الأمن والسلامة', 'تدابير السلامة والصحة المهنية، بما في ذلك تعزيز ثقافة الأمان، توفير بيئة صحية، تطبيق الوقاية من المخاطر، والاستجابة للطوارئ وحوادث العمل،...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1PD0003', NULL, NULL, NULL, 'documents/1753952883_214_Health_and_Safety_Policy_Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Health_and_Safety_Policy_Arabic.pdf\",\"new_name\":\"1753952883_214_Health_and_Safety_Policy_Arabic.pdf\"}]', '2025-07-31 06:08:00', '2025-08-02 12:11:00'),
(167, 'DOC-20260429-8309', 'سياسة المطالبات', 'آليات استلام ومعالجة المطالبات والشكاوى والتظلمات، وضوابط الإلغاء، والتزامات الشركة الزمنية وفق اللوائح، مع ضمان توثيق جميع العمليات وإص...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0001', NULL, NULL, NULL, 'documents/1753953836_214_Claims_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Claims_Policy___Arabic.pdf\",\"new_name\":\"1753953836_214_Claims_Policy___Arabic.pdf\"}]', '2025-07-31 06:24:00', '2025-07-31 06:24:00'),
(168, 'DOC-20260429-4577', 'سياسة العمليات اليومية', 'آلية عمل إدارة العمليات بكافة أقسامها ، موضحةً مهام كل قسم في استقبال الطلبات، تنفيذها، توثيقها في نظام إدارة علاقات العملاء وضمان الالتزا...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0002', NULL, NULL, NULL, 'documents/1753953912_214_Daily_Operations_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Daily_Operations_Policy___Arabic.pdf\",\"new_name\":\"1753953912_214_Daily_Operations_Policy___Arabic.pdf\"}]', '2025-07-31 06:27:00', '2025-07-31 06:27:00'),
(169, 'DOC-20260429-9896', 'سياسة العمليات اليومية', 'آلية استلام الوثائق التأمينية وتعيين مسؤول علاقات العملاء، ومعالجة جميع أنواع التأمين (طبي، مركبات، عام، حياة) منذ استقبال الطلب وحتى الإص...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0002', NULL, NULL, NULL, 'documents/1753954381_214_Daily_Operations_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Daily_Operations_Policy___Arabic.pdf\",\"new_name\":\"1753954381_214_Daily_Operations_Policy___Arabic.pdf\"}]', '2025-07-31 06:33:00', '2025-07-31 06:33:00'),
(170, 'DOC-20260429-6920', 'سياسة التجديدات', 'دورة متابعة تجديد الوثائق التأمينية بدءًا من إشعارات ما قبل الانتهاء وحتى إصدار الوثيقة الجديدة، مرورًا بالتفويضات، العروض الفنية، وآليا...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0003', NULL, NULL, NULL, 'documents/1753954446_214_Renewals_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Renewals_Policy___Arabic.pdf\",\"new_name\":\"1753954446_214_Renewals_Policy___Arabic.pdf\"}]', '2025-07-31 06:34:00', '2025-07-31 06:34:00'),
(171, 'DOC-20260429-5296', 'سياسة ضمان الاستجابة الفورية للعملاء', 'آلية التجاوب الفوري مع العملاء خلال ساعات العمل، وضمان التغطية البديلة عند الغياب، وتوثيق جميع الطلبات في نظام CRM، بما يحقق استمرارية الخد...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0004', NULL, NULL, NULL, 'documents/1753954558_214_Immediate_Client_Response_Assurance_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Immediate_Client_Response_Assurance_Policy___Arabic.pdf\",\"new_name\":\"1753954558_214_Immediate_Client_Response_Assurance_Policy___Arabic.pdf\"}]', '2025-07-31 06:36:00', '2025-07-31 06:36:00'),
(172, 'DOC-20260429-2053', 'سياسة العمليات العامة', 'آلية عمل إدارة العمليات بكافة أقسامها ، موضحةً مهام كل قسم في استقبال الطلبات، تنفيذها، توثيقها في نظام إدارة علاقات العملاء وضمان الالتزا...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0005', NULL, NULL, NULL, 'documents/1753954659_214_General_Operations_Policy__Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"General_Operations_Policy__Arabic.pdf\",\"new_name\":\"1753954659_214_General_Operations_Policy__Arabic.pdf\"}]', '2025-07-31 06:37:00', '2025-07-31 06:37:00'),
(173, 'DOC-20260429-1509', 'سياسة العناية بالعملاء', 'معايير العناية بالعملاء داخل إدارة العمليات، بما يشمل سرعة الاستجابة، توثيق جميع الطلبات والشكاوى عبر نظام CRM، الالتزام باتفاقيات مستوى ...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0006', NULL, NULL, NULL, 'documents/1753954896_214_Client_Care_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Care_Policy___Arabic.pdf\",\"new_name\":\"1753954896_214_Client_Care_Policy___Arabic.pdf\"}]', '2025-07-31 06:41:00', '2025-07-31 06:41:00'),
(174, 'DOC-20260429-3053', 'سياسة إدارة شكاوى العملاء', 'آلية استقبال وتصنيف ومعالجة شكاوى العملاء عبر قنوات متعددة وبأطر زمنية محددة، مع ضمان السرية، التوثيق الكامل في نظام CRM، والتصعيد الفوري ع...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0007', NULL, NULL, NULL, 'documents/1753954955_214_Client_Complaints_Management_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Complaints_Management_Policy___Arabic.pdf\",\"new_name\":\"1753954955_214_Client_Complaints_Management_Policy___Arabic.pdf\"}]', '2025-07-31 06:42:00', '2025-07-31 06:42:00'),
(175, 'DOC-20260429-6623', 'سياسة دعم العملاء في معالجة المطالبات التأمينية', 'التزامات الشركة في دعم العملاء خلال معالجة المطالبات التأمينية، بما يشمل الإرشاد الفني، متابعة الطلبات، آليات التصعيد، حماية البيانات، و...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0008', NULL, NULL, NULL, 'documents/1753955033_214_Client_Support_in_Handling_Insurance_Claims_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Support_in_Handling_Insurance_Claims_Policy___Arabic.pdf\",\"new_name\":\"1753955033_214_Client_Support_in_Handling_Insurance_Claims_Policy___Arabic.pdf\"}]', '2025-07-31 06:44:00', '2025-07-31 06:44:00'),
(176, 'DOC-20260429-5687', 'السياسة التنظيمية لمسؤولي ومختصي المطالبات التأمينية', 'إجراءات استلام ومراجعة ومتابعة وتسوية المطالبات التأمينية وفق ضوابط محوكمة تضمن السرعة، الشفافية، وتوثيق جميع المراحل في نظام CRM، مع تحدي...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0009', NULL, NULL, NULL, 'documents/1753955113_214_Regulatory_Policy_for_Insurance_Claims_Officers_and_Specialists___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Regulatory_Policy_for_Insurance_Claims_Officers_and_Specialists___Arabic.pdf\",\"new_name\":\"1753955113_214_Regulatory_Policy_for_Insurance_Claims_Officers_and_Specialists___Arabic.pdf\"}]', '2025-07-31 06:45:00', '2025-07-31 06:45:00');
INSERT INTO `documents` (`id`, `document_no`, `title`, `description`, `category_id`, `owner_id`, `reviewer_id`, `approver_id`, `department_id`, `type`, `status`, `version`, `effective_date`, `review_date`, `expiry_date`, `file_path`, `file_size`, `mime_type`, `is_controlled`, `requires_signature`, `rejection_reason`, `submitted_at`, `approved_at`, `tags`, `metadata`, `created_at`, `updated_at`) VALUES
(177, 'DOC-20260429-6803', 'سياسة دعم العمليات', 'مهام فرق دعم العمليات وآليات التنسيق مع الإدارات المساندة لضمان انسيابية الطلبات وجودة الخدمة، وتشمل توثيق المعاملات، إدارة الوقت والتصع...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0010', NULL, NULL, NULL, 'documents/1753955181_214_Operations_Support_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Operations_Support_Policy___Arabic.pdf\",\"new_name\":\"1753955181_214_Operations_Support_Policy___Arabic.pdf\"}]', '2025-07-31 06:46:00', '2025-07-31 06:46:00'),
(178, 'DOC-20260429-5437', 'سياسة الإدارة العامة لإدارة العمليات', 'آليات العمل الموحدة لإدارة العمليات، بما يشمل الالتزام المؤسسي، التوثيق، التنسيق مع العملاء وشركات التأمين، وضبط الأداء لضمان جودة الخدم...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0011', NULL, NULL, NULL, 'documents/1753955243_214_General_Administration_Policy_for_the_Operations_Management___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"General_Administration_Policy_for_the_Operations_Management___Arabic.pdf\",\"new_name\":\"1753955243_214_General_Administration_Policy_for_the_Operations_Management___Arabic.pdf\"}]', '2025-07-31 06:47:00', '2025-07-31 06:47:00'),
(179, 'DOC-20260429-9247', 'سياسة العلاقات مع شركات التأمين', 'قنوات التواصل الرسمية وآليات التنسيق والتوثيق بين قسم إدارة الوثائق التأمينية وشركات التأمين، لضمان السرية، سرعة الاستجابة، وحوكمة الأدا...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0012', NULL, NULL, NULL, 'documents/1753955298_214_Relations_with_Insurance_Companies_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Relations_with_Insurance_Companies_Policy___Arabic.pdf\",\"new_name\":\"1753955298_214_Relations_with_Insurance_Companies_Policy___Arabic.pdf\"}]', '2025-07-31 06:48:00', '2025-07-31 06:48:00'),
(180, 'DOC-20260429-5690', 'سياسة حفظ السجلات', 'حفظ السجلات التشغيلية من حيث فترات الاحتفاظ، التصنيف، الوصول، الإتلاف الآمن، واستخدام التخزين السحابي، بما يضمن الامتثال للمتطلبات النظا...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0013', NULL, NULL, NULL, 'documents/1753955354_214_Records_Retention_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Records_Retention_Policy___Arabic.pdf\",\"new_name\":\"1753955354_214_Records_Retention_Policy___Arabic.pdf\"}]', '2025-07-31 06:49:00', '2025-07-31 06:49:00'),
(181, 'DOC-20260429-4461', 'سياسة تغيير وسيط التأمين أثناء فترة سريان الوثيقة', 'ضوابط وإجراءات تغيير وسيط التأمين خلال فترة سريان الوثيقة، بدءًا من تقديم الطلب الرسمي ومتطلباته، مرورًا بالتحقق والتصعيد والاعتراضات، و...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0014', NULL, NULL, NULL, 'documents/1753955400_214_Insurance_Broker_Change_Policy_During_Policy_Term___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Broker_Change_Policy_During_Policy_Term___Arabic.pdf\",\"new_name\":\"1753955400_214_Insurance_Broker_Change_Policy_During_Policy_Term___Arabic.pdf\"}]', '2025-07-31 06:50:00', '2025-07-31 06:50:00'),
(182, 'DOC-20260429-5052', 'سياسة إدارة الشركاء', 'إدارة العلاقات مع الشركاء الاستراتيجيين بعد اعتمادهم رسميًا، لضمان تنفيذ الشراكات بشكل فعال ومتوافق مع الأهداف التشغيلية والتطويرية', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1QDM0002', NULL, NULL, NULL, 'documents/1754147184_214_Partner_Management_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Partner_Management_Policy___Arabic.pdf\",\"new_name\":\"1754147184_214_Partner_Management_Policy___Arabic.pdf\"}]', '2025-08-02 12:06:00', '2025-08-02 12:06:00'),
(183, 'DOC-20260429-4141', 'سياسة الأمن والسلامة', 'تدابير السلامة والصحة المهنية، بما في ذلك تعزيز ثقافة الأمان، توفير بيئة صحية، تطبيق الوقاية من المخاطر، والاستجابة للطوارئ وحوادث العمل،...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1PD0003', NULL, NULL, NULL, 'documents/1754147626_214_Health_and_Safety_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Health_and_Safety_Policy___Arabic.pdf\",\"new_name\":\"1754147626_214_Health_and_Safety_Policy___Arabic.pdf\"}]', '2025-08-02 12:13:00', '2025-08-02 12:13:00'),
(184, 'DOC-20260429-1677', 'إجراءات إدارة تقنية المعلومات', NULL, 1, 44, 44, NULL, NULL, 'procedure', 'approved', 'v1.0', NULL, NULL, NULL, 'documents/1754149425_214_Information_Technology_Procedures___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Technology_Procedures___Arabic.pdf\",\"new_name\":\"1754149425_214_Information_Technology_Procedures___Arabic.pdf\"}]', '2025-08-02 12:44:00', '2025-09-07 07:35:00'),
(185, 'DOC-20260429-3903', 'إجراءات إدارة الجودة والتطوير', NULL, 2, 44, 44, NULL, NULL, 'procedure', 'approved', 'v1.0', NULL, NULL, NULL, 'documents/1754149509_214_Quality___Development_Procedures___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Quality___Development_Procedures___Arabic.pdf\",\"new_name\":\"1754149509_214_Quality___Development_Procedures___Arabic.pdf\"}]', '2025-08-02 12:45:00', '2025-08-02 12:45:00'),
(186, 'DOC-20260429-4054', 'إجراءات إدارة العمليات', NULL, 2, 44, 44, NULL, NULL, 'procedure', 'approved', 'v1.0', NULL, NULL, NULL, 'documents/1754210626_214_operations_procedures___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"operations_procedures___Arabic.pdf\",\"new_name\":\"1754210626_214_operations_procedures___Arabic.pdf\"}]', '2025-08-03 05:43:00', '2025-08-03 05:43:00'),
(187, 'DOC-20260429-8740', 'سياسة تفويض الصلاحيات', 'كيفية تفويض الصلاحيات داخل الشركة، بما في ذلك توثيق الصلاحيات، تحديد نطاقها، ومراجعتها دوريًا، مع ضمان الامتثال للأطر التنظيمية وتقييد ال...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0001', NULL, NULL, NULL, 'documents/1754217251_214_Delegation_of_Authority_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Delegation_of_Authority_Policy___Arabic.pdf\",\"new_name\":\"1754217251_214_Delegation_of_Authority_Policy___Arabic.pdf\"}]', '2025-08-03 07:34:00', '2025-08-03 07:34:00'),
(188, 'DOC-20260429-6582', 'سياسة مكافآت أعضاء مجلس الإدارة', 'شروط صرف المكافآت لأعضاء مجلس الإدارة بناءً على الأداء، مع توثيق دقيق ومراجعة دورية، وتمنع المكافآت المرتبطة بالأرباح القصيرة الأجل أو أي ...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0002', NULL, NULL, NULL, 'documents/1754217314_214_Board_Members____Remuneration_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Board_Members____Remuneration_Policy___Arabic.pdf\",\"new_name\":\"1754217314_214_Board_Members____Remuneration_Policy___Arabic.pdf\"}]', '2025-08-03 07:35:00', '2025-08-03 07:35:00'),
(189, 'DOC-20260429-8547', 'سياسة السرية وحماية المعلومات', 'ضمان حماية سرية المعلومات التي يطلع عليها أعضاء مجلس الإدارة أثناء أداء مهامهم، من خلال وضع ضوابط واضحة للتعامل مع البيانات الحساسة ومنع ت...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0003', NULL, NULL, NULL, 'documents/1754217474_214_Confidentiality_and_Information_Protection_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Confidentiality_and_Information_Protection_Policy___Arabic.pdf\",\"new_name\":\"1754217474_214_Confidentiality_and_Information_Protection_Policy___Arabic.pdf\"}]', '2025-08-03 07:37:00', '2025-08-03 07:37:00'),
(190, 'DOC-20260429-4944', 'سياسة الاتفاقيات غير القياسية', 'ضوابط التعامل مع العقود غير القياسية، بما يشمل المراجعة، التصنيف، التوثيق، والموافقة المبدئية من الإدارة التنفيذية، بالإضافة إلى ضمان ال...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0004', NULL, NULL, NULL, 'documents/1754217508_214_Non_Standard_Agreements_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Non_Standard_Agreements_Policy.pdf\",\"new_name\":\"1754217508_214_Non_Standard_Agreements_Policy.pdf\"}]', '2025-08-03 07:44:00', '2025-08-03 07:44:00'),
(191, 'DOC-20260429-8712', 'سياسة الحوكمة المؤسسية', 'تنظيم مهام ومسؤوليات مجلس الإدارة والإدارة التنفيذية ولجان الشركة، وضبط قواعد السلوك المهني والالتزام بالحوكمة والشفافية، بما يضمن حماية...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0005', NULL, NULL, NULL, 'documents/1754218070_214_Corporate_Governance_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Corporate_Governance_Policy___Arabic.pdf\",\"new_name\":\"1754218070_214_Corporate_Governance_Policy___Arabic.pdf\"}]', '2025-08-03 07:47:00', '2025-08-03 07:47:00'),
(192, 'DOC-20260429-4870', 'سياسة الرقابة المحلية للرئيس التنفيذي ونائبه', 'معايير تقييم الأداء والمساءلة للرئيس التنفيذي ونائبه، بما في ذلك التزامات الشفافية، تقييم الأداء، إدارة التعارضات، وحقوق البلاغ عن المخا...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0006', NULL, NULL, NULL, 'documents/1754218221_214_Local_Oversight_Policy_for_the_CEO_and_Deputy_CEO___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Local_Oversight_Policy_for_the_CEO_and_Deputy_CEO___Arabic.pdf\",\"new_name\":\"1754218221_214_Local_Oversight_Policy_for_the_CEO_and_Deputy_CEO___Arabic.pdf\"}]', '2025-08-03 07:50:00', '2025-08-03 07:50:00'),
(193, 'DOC-20260429-1981', 'سياسة الاندماجات والاستحواذات', 'الضوابط والإجراءات الخاصة بالاندماج والاستحواذ التقييم، الموافقة على العقود، الفحص النافي للجهالة، وتنفيذ الصفقة مع التركيز على الشفافي...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0007', NULL, NULL, NULL, 'documents/1754218592_214_Mergers_and_Acquisitions_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Mergers_and_Acquisitions_Policy___Arabic.pdf\",\"new_name\":\"1754218592_214_Mergers_and_Acquisitions_Policy___Arabic.pdf\"}]', '2025-08-03 07:56:00', '2025-08-03 07:56:00'),
(194, 'DOC-20260429-5434', 'سياسة انعقاد المجلس', 'ضوابط اجتماعات مجلس الإدارة تشمل الالتزام بالتنظيمات، توثيق الاجتماعات، الشفافية، تقييم الأداء، وضمان السرية، مع استخدام الأنظمة الإلكت...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0008', NULL, NULL, NULL, 'documents/1754218663_214_Board_Meetings_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Board_Meetings_Policy___Arabic.pdf\",\"new_name\":\"1754218663_214_Board_Meetings_Policy___Arabic.pdf\"}]', '2025-08-03 07:57:00', '2025-08-03 07:57:00'),
(195, 'DOC-20260429-3196', 'سياسة الجمعية العمومية', 'تنظيم اجتماعات الجمعية العمومية بما يضمن الالتزام الكامل بالأنظمة واللوائح، وضبط الدعوات، الحضور، النصاب، إجراءات التصويت، والتوثيق بما ...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0009', NULL, NULL, NULL, 'documents/1754218728_214_General_Assembly_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"General_Assembly_Policy___Arabic.pdf\",\"new_name\":\"1754218728_214_General_Assembly_Policy___Arabic.pdf\"}]', '2025-08-03 07:58:00', '2025-08-03 07:58:00'),
(196, 'DOC-20260429-7953', 'سياسة تعيين أمين المجلس', 'تنظيم تعيين أمين مجلس الإدارة، وتحديد مهامه واختصاصاته وضوابط عمله وسريته، بما يضمن التزامه بالأنظمة والحوكمة ودعمه لفاعلية قرارات المجلس', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0010', NULL, NULL, NULL, 'documents/1754218759_214_Board_Secretary_Appointment_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Board_Secretary_Appointment_Policy___Arabic.pdf\",\"new_name\":\"1754218759_214_Board_Secretary_Appointment_Policy___Arabic.pdf\"}]', '2025-08-03 07:59:00', '2025-08-03 07:59:00'),
(197, 'DOC-20260429-6457', 'سياسة قرارات المجلس', 'آلية اتخاذ قرارات مجلس الإدارة وتصنيفها، وضوابط التصويت والتوثيق والسرية، بما يضمن الشفافية، الالتزام النظامي، وسرعة التنفيذ مع متابعة و...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0011', NULL, NULL, NULL, 'documents/1754218810_214_Board_Decisions_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Board_Decisions_Policy___Arabic.pdf\",\"new_name\":\"1754218810_214_Board_Decisions_Policy___Arabic.pdf\"}]', '2025-08-03 08:00:00', '2025-08-03 08:00:00'),
(198, 'DOC-20260429-1671', 'سياسة النصاب', 'ضوابط تحقق النصاب في اجتماعات مجلس الإدارة والجمعيات العمومية، وآليات التوثيق والرقابة والإجراءات النظامية عند فقدانه، بما يضمن سلامة ال...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0012', NULL, NULL, NULL, 'documents/1754218833_214_Quorum_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Quorum_Policy___Arabic.pdf\",\"new_name\":\"1754218833_214_Quorum_Policy___Arabic.pdf\"}]', '2025-08-03 08:00:00', '2025-08-03 08:00:00'),
(199, 'DOC-20260429-2492', 'سياسة اللجان المنبثقة من المجلس', 'إطارًا ملزمًا لإعداد واعتماد لوائح تنظيمية مستقلة لكل لجنة منبثقة عن مجلس الإدارة، تشمل مهامها وصلاحياتها وآليات مراجعتها الدورية لضمان ا...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0013', NULL, NULL, NULL, 'documents/1754218880_214_Board_Committees_Policy____Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Board_Committees_Policy____Arabic.pdf\",\"new_name\":\"1754218880_214_Board_Committees_Policy____Arabic.pdf\"}]', '2025-08-03 08:01:00', '2025-08-03 08:01:00'),
(200, 'DOC-20260429-3188', 'سياسة تعارض المصالح', 'ضوابط إدارة حالات تعارض المصالح والإفصاح عنها، وآليات التقييم والمعالجة والجزاءات المترتبة، بما يضمن النزاهة والشفافية في قرارات الشركة ...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1EM0014', NULL, NULL, NULL, 'documents/1754218936_214_Conflict_of_Interest_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Conflict_of_Interest_Policy___Arabic.pdf\",\"new_name\":\"1754218936_214_Conflict_of_Interest_Policy___Arabic.pdf\"}]', '2025-08-03 08:02:00', '2025-08-03 08:02:00'),
(201, 'DOC-20260429-2975', 'سياسة ا ستمرارية الأعمال', 'آليات الحفاظ على استمرارية العمليات الحيوية أثناء الأزمات والطوارئ، من خلال خطط الاستجابة والتعافي، النسخ الاحتياطي، والتدريب الدوري', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1LCM0013', NULL, NULL, NULL, 'documents/1754805117_214_Business_Continuity_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Business_Continuity_Policy___Arabic.pdf\",\"new_name\":\"1754805117_214_Business_Continuity_Policy___Arabic.pdf\"}]', '2025-08-10 02:51:00', '2025-08-10 02:51:00'),
(202, 'DOC-20260429-8746', 'سياسة إدارة التدفقات النقدية', 'إدارة التدفقات النقدية عبر تحديث الجداول الدورية، وضبط أولويات الصرف، وإعداد تقارير شهرية، مع فرض ضوابط لضمان التوازن النقدي والسيولة.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1FM0022', NULL, NULL, NULL, 'documents/1754825842_214_Cash_Flow_Management_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Cash_Flow_Management_Policy___Arabic.pdf\",\"new_name\":\"1754825842_214_Cash_Flow_Management_Policy___Arabic.pdf\"}]', '2025-08-10 08:37:00', '2025-08-10 08:37:00'),
(203, 'DOC-20260429-5290', 'سياسة التوظيف', 'جميع مراحل التوظيف من الإعلان وحتى التعيين، مع ضمان الامتثال لمعايير العدالة، السعودة، التنوع، والتحقق المهني، لضمان استقطاب الكفاءات بك...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0007', NULL, NULL, NULL, 'documents/1755772028_214_Employment_Policy____Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employment_Policy____Arabic.pdf\",\"new_name\":\"1755772028_214_Employment_Policy____Arabic.pdf\"}]', '2025-08-21 07:28:00', '2025-11-16 08:26:00'),
(204, 'DOC-20260429-4479', 'سياسة مكافحة التحرش الجنسي', 'توفير بيئة عمل آمنة خالية من التحرش، مع تحديد أنواع السلوك المحظور، وطرق الإبلاغ، وآليات التحقيق والعقوبات لحماية جميع الموظفين', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1HRM0002', NULL, NULL, NULL, 'documents/1755772369_214_Anti_Sexual_Harassment_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Anti_Sexual_Harassment_Policy___Arabic.pdf\",\"new_name\":\"1755772369_214_Anti_Sexual_Harassment_Policy___Arabic.pdf\"}]', '2025-08-21 07:33:00', '2025-08-21 08:52:00'),
(205, 'DOC-20260429-5995', 'سياسة الفنية والاكتتاب', 'استخدام التقنية والبيانات لضمان حماية المعلومات، تكامل الأنظمة، وجودة الخدمة والامتثال التنظيمي', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0001', NULL, NULL, NULL, 'documents/1756978632_214_Technical___Underwriting_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Technical___Underwriting_Policy.pdf\",\"new_name\":\"1756978632_214_Technical___Underwriting_Policy.pdf\"}]', '2025-09-04 06:37:00', '2025-09-18 10:17:00'),
(206, 'DOC-20260429-3273', 'سياسة خطابات التعهد', 'إصدار واستخدام خطابات التعهد وفق ضوابط موثقة وموافقات داخلية لضمان الالتزام القانوني والتشغيلي دون استبدال الوثائق التأمينية الرسمية', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1TM0002', NULL, NULL, NULL, 'documents/1756978686_214_Letters_of_Undertaking_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Letters_of_Undertaking_Policy.pdf\",\"new_name\":\"1756978686_214_Letters_of_Undertaking_Policy.pdf\"}]', '2025-09-04 06:38:00', '2025-09-04 06:39:00'),
(207, 'DOC-20260429-5291', 'سياسة خطابات التعهد', 'إصدار واستخدام خطابات التعهد وفق ضوابط موثقة وموافقات داخلية لضمان الالتزام القانوني والتشغيلي دون استبدال الوثائق التأمينية الرسمية', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0002', NULL, NULL, NULL, 'documents/1756978809_214_Letters_of_Undertaking_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Letters_of_Undertaking_Policy.pdf\",\"new_name\":\"1756978809_214_Letters_of_Undertaking_Policy.pdf\"}]', '2025-09-04 06:40:00', '2025-09-18 10:17:00'),
(208, 'DOC-20260429-1644', 'سياسة إعداد وتوثيق نماذج عروض التأمين..', 'تنظم السياسة آلية استلام ومعالجة طلبات عروض التأمين عبر النظام ، لضمان اكتمال المستندات، دقة الإجراءات، وسرية البيانات وفق ضوابط رسمية.', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0003', NULL, NULL, NULL, 'documents/1756978938_214_Policy_for_Preparing_and_Documenting_Insurance_Quotation_Forms.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Policy_for_Preparing_and_Documenting_Insurance_Quotation_Forms.pdf\",\"new_name\":\"1756978938_214_Policy_for_Preparing_and_Documenting_Insurance_Quotation_Forms.pdf\"}]', '2025-09-04 06:42:00', '2025-09-18 10:17:00'),
(209, 'DOC-20260429-5846', 'سياسة الوضوح التعاقدي', 'الالتزام بعدم تنفيذ أي إجراء تأميني دون وجود خطاب تعيين رسمي، وضمان وضوح وتوثيق كافة عناصر العقد قبل الإصدار لتحقيق الشفافية والامتثال الك...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0004', NULL, NULL, NULL, 'documents/1756978983_214_Contractual_Clarity_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Contractual_Clarity_Policy.pdf\",\"new_name\":\"1756978983_214_Contractual_Clarity_Policy.pdf\"}]', '2025-09-04 06:43:00', '2025-09-18 10:17:00'),
(210, 'DOC-20260429-7305', 'سياسة الاستجابة للطوارئ واستمرارية الأعمال', 'تصنيف المهام الحيوية، وتفعيل خطط بديلة للطوارئ، وضمان حماية البيانات والتشغيل دون انقطاع', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0005', NULL, NULL, NULL, 'documents/1756979470_214_Emergency_Response_and_Business_Continuity_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Emergency_Response_and_Business_Continuity_Policy.pdf\",\"new_name\":\"1756979470_214_Emergency_Response_and_Business_Continuity_Policy.pdf\"}]', '2025-09-04 06:51:00', '2025-09-18 10:18:00'),
(211, 'DOC-20260429-6552', 'سياسة التعافي من الكوارث', 'استمرارية الخدمة من خلال نسخ احتياطي مشفر، جاهزية الفريق، بدائل تشغيلية، وتوثيق كامل للإجراءات وتحديث الخطة بناءً على الدروس المستفادة', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0006', NULL, NULL, NULL, 'documents/1756979594_214_Disaster_Recovery_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Disaster_Recovery_Policy.pdf\",\"new_name\":\"1756979594_214_Disaster_Recovery_Policy.pdf\"}]', '2025-09-04 06:53:00', '2025-09-18 10:18:00'),
(212, 'DOC-20260429-6313', 'سياسة الأخطاء والإغفالات', 'الوقاية من الأخطاء من خلال مراجعة دقيقة، توثيق الإجراءات، استخدام النماذج المعتمدة، تحليل الملاحظات، تصحيح الأخطاء فوراً، ومتابعة الأداء...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0007', NULL, NULL, NULL, 'documents/1756979679_214_Errors_and_Omissions__E_O__Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Errors_and_Omissions__E_O__Policy.pdf\",\"new_name\":\"1756979679_214_Errors_and_Omissions__E_O__Policy.pdf\"}]', '2025-09-04 06:54:00', '2025-09-18 10:18:00'),
(213, 'DOC-20260429-9422', 'سياسة التعامل مع شركات التأمين', 'التعامل المهني والشفاف مع شركات التأمين عبر توثيق دقيق، مراجعة مستمرة، وتواصل رسمي يحفظ الحقوق ويلتزم بالضوابط التنظيمية', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0008', NULL, NULL, NULL, 'documents/1756979801_214_Insurance_Companies_Engagement_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Companies_Engagement_Policy.pdf\",\"new_name\":\"1756979801_214_Insurance_Companies_Engagement_Policy.pdf\"}]', '2025-09-04 06:56:00', '2025-09-18 10:18:00'),
(214, 'DOC-20260429-4063', 'سياسة العلاقات مع شركات التأمين', 'الوقاية من الأخطاء من خلال مراجعة دقيقة، توثيق الإجراءات، استخدام النماذج المعتمدة، تحليل الملاحظات، تصحيح الأخطاء فوراً، ومتابعة الأداء...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1TM0007', NULL, NULL, NULL, 'documents/1756979867_214_Insurance_Companies_Relationship_Management_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Companies_Relationship_Management_Policy.pdf\",\"new_name\":\"1756979867_214_Insurance_Companies_Relationship_Management_Policy.pdf\"}]', '2025-09-04 06:57:00', '2025-09-04 06:58:00'),
(215, 'DOC-20260429-2654', 'سياسة العلاقات مع شركات التأمين', 'تنظيم علاقات مهنية وشفافة مع شركات التأمين عبر قنوات رسمية، مراجعة دقيقة للعروض، توثيق كامل، تقييم دوري، وإدارة النزاعات مع الالتزام الكا...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0009', NULL, NULL, NULL, 'documents/1756979919_214_Insurance_Companies_Relationship_Management_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Companies_Relationship_Management_Policy.pdf\",\"new_name\":\"1756979919_214_Insurance_Companies_Relationship_Management_Policy.pdf\"}]', '2025-09-04 06:59:00', '2025-09-18 10:18:00'),
(216, 'DOC-20260429-7453', 'سياسة تحليل المحفظة التأمينية', 'الالتزام بتحليل دوري للمحفظة التأمينية لتقييم الأداء، اكتشاف المخاطر، تحسين المنتجات، ومتابعة تنفيذ خطط التطوير.', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0010', NULL, NULL, NULL, 'documents/1756980041_214_Insurance_Portfolio_Analysis_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Portfolio_Analysis_Policy.pdf\",\"new_name\":\"1756980041_214_Insurance_Portfolio_Analysis_Policy.pdf\"}]', '2025-09-04 07:00:00', '2025-09-18 10:18:00'),
(217, 'DOC-20260429-4570', 'سياسة الإبلاغ عن المخالفات', 'تنظم الإبلاغ عن المخالفات لضمان النزاهة والشفافية، عبر قنوات آمنة، مع حماية المبلغين، والتحقيق الفوري، والتصعيد عند الضرورة، وضمان سرية ا...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0011', NULL, NULL, NULL, 'documents/1756980149_214_Whistleblowing_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Whistleblowing_Policy.pdf\",\"new_name\":\"1756980149_214_Whistleblowing_Policy.pdf\"}]', '2025-09-04 07:02:00', '2025-09-18 10:18:00'),
(218, 'DOC-20260429-6090', 'سياسة تأكيد تحصيل قسط العميل قبل إصدار الوثيقة التأمينية', 'الالتزام بتحصيل القسط الأول من العميل قبل بدء إصدار الوثيقة التأمينية، مع التحقق من صحة المستندات ومتابعة الإجراءات لضمان حماية حقوق الشر...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0012', NULL, NULL, NULL, 'documents/1756980235_214_Client_Premium_Collection_Confirmation_Before_Policy_Issuance_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Premium_Collection_Confirmation_Before_Policy_Issuance_Policy.pdf\",\"new_name\":\"1756980235_214_Client_Premium_Collection_Confirmation_Before_Policy_Issuance_Policy.pdf\"}]', '2025-09-04 07:03:00', '2025-09-18 10:19:00'),
(219, 'DOC-20260429-8056', 'السياسة العامة للفحص الدوري ومراجعة تقارير المعاينين الفنيين', 'تنظيم إجراءات وضوابط المعاينة الفنية للأصول التأمينية لضمان دقة التقارير وسلامة التغطية، من خلال تنسيق داخلي دقيق، مراجعة فنية صارمة، وحف...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0014', NULL, NULL, NULL, 'documents/1756980365_214_General_Policy_for_Periodic_Inspection.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"General_Policy_for_Periodic_Inspection.pdf\",\"new_name\":\"1756980365_214_General_Policy_for_Periodic_Inspection.pdf\"}]', '2025-09-04 07:06:00', '2025-09-18 10:18:00'),
(220, 'DOC-20260429-9260', 'سياسة مطالبات التأمين والأرشفة الإلكترونية', 'إجراءات استقبال ومتابعة وتسوية مطالبات التأمين بدقة وشفافية، مع حفظ المستندات وضمان حماية بيانات العملاء', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0015', NULL, NULL, NULL, 'documents/1756980460_214_Insurance_Claims_Management_and_Electronic_Archiving_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Claims_Management_and_Electronic_Archiving_Policy.pdf\",\"new_name\":\"1756980460_214_Insurance_Claims_Management_and_Electronic_Archiving_Policy.pdf\"}]', '2025-09-04 07:07:00', '2025-09-18 10:19:00'),
(221, 'DOC-20260429-9597', 'سياسة اتفاقيات شروط الأعمال مع العملاء', 'العلاقة التعاقدية مع العميل عبر اتفاقية وساطة موحدة مدتها ثلاث سنوات، تضمن الالتزام بالخدمات ومنع التغيير دون مبرر موثق', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0016', NULL, NULL, NULL, 'documents/1756980537_214_Policy_on_Terms_of_Business_Agreements__TOBA__with_Clients.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Policy_on_Terms_of_Business_Agreements__TOBA__with_Clients.pdf\",\"new_name\":\"1756980537_214_Policy_on_Terms_of_Business_Agreements__TOBA__with_Clients.pdf\"}]', '2025-09-04 07:08:00', '2025-09-18 10:18:00'),
(222, 'DOC-20260429-7525', 'سياسة حوكمة تقنية المعلومات', 'إطار الحوكمة التقنية في الشركة، بما في ذلك تنفيذ المشاريع التقنية وفق الأهداف التشغيلية، حماية البيانات، ضمان استمرارية العمل، وتحديد مسؤ...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0001', NULL, NULL, NULL, 'documents/1756981017_214____________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"___________________________________________________.pdf\",\"new_name\":\"1756981017_214____________________________________________________.pdf\"}]', '2025-09-04 07:17:00', '2025-09-09 04:30:00'),
(223, 'DOC-20260429-9065', 'سياسة إدارة تقنية المعلومات', 'إدارة الأصول التقنية، الشبكات، البرمجيات، وحماية البيانات لضمان الأمان والامتثال التنظيمي، مع التأكيد على تحديث الأنظمة بشكل دوري وتدريب...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0002', NULL, NULL, NULL, 'documents/1756981245_214____________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"___________________________________________________.pdf\",\"new_name\":\"1756981245_214____________________________________________________.pdf\"}]', '2025-09-04 07:20:00', '2025-09-09 04:33:00'),
(224, 'DOC-20260429-4263', 'سياسة أمن مستخدمي تقنية المعلومات', 'قواعد استخدام الحسابات التقنية، حماية المعلومات، إدارة صلاحيات الوصول، والإبلاغ عن الحوادث الأمنية. كما تركز على أهمية حماية البيانات، اس...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0003', NULL, NULL, NULL, 'documents/1756981413_214_______________________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"______________________________________________________________.pdf\",\"new_name\":\"1756981413_214_______________________________________________________________.pdf\"}]', '2025-09-04 07:23:00', '2025-09-09 04:36:00'),
(225, 'DOC-20260429-6222', 'سياسة أمن أنظمة تقنية المعلومات', 'معايير الأمان لأنظمة تقنية المعلومات في الشركة، بما في ذلك التكوين الآمن، التحكم في الوصول، حماية البيانات، وأمن الشبكات. تركز على مراقبة ...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0004', NULL, NULL, NULL, 'documents/1756981499_214___________________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"__________________________________________________________.pdf\",\"new_name\":\"1756981499_214___________________________________________________________.pdf\"}]', '2025-09-04 07:25:00', '2025-09-09 04:38:00'),
(226, 'DOC-20260429-4734', 'سياسة أجهزة تقنية المعلومات', 'كيفية إدارة الأجهزة التقنية داخل الشركة، بدءًا من التخصيص والصيانة إلى التحديثات والمراجعات الدورية، مع التأكيد على الأمان وحماية البيان...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0005', NULL, NULL, NULL, 'documents/1756981622_214____________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"___________________________________________________.pdf\",\"new_name\":\"1756981622_214____________________________________________________.pdf\"}]', '2025-09-04 07:27:00', '2025-09-09 04:39:00'),
(227, 'DOC-20260429-7500', 'سياسة برمجيات تقنية المعلومات', 'ضوابط تصنيف البرمجيات واستخدامها، بما في ذلك البرمجيات الجاهزة، المطورة داخليًا، والمفتوحة المصدر، مع تحديد شروط تقييم الجدوى، الدعم الف...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0006', NULL, NULL, NULL, 'documents/1756981719_214_____________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"____________________________________________.pdf\",\"new_name\":\"1756981719_214_____________________________________________.pdf\"}]', '2025-09-04 07:28:00', '2025-09-09 04:41:00'),
(228, 'DOC-20260429-7358', 'سياسة أنظمة الهاتف والاتصال الهاتفي', 'ضوابط إدارة وتخصيص الخطوط الهاتفية والأجهزة المحمولة، بما في ذلك تحديد الاحتياجات، اختيار مزود الخدمة، مراقبة الاستخدام، الأمان، إدارة ا...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0007', NULL, NULL, NULL, 'documents/1756981794_214___________________________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"__________________________________________________________________.pdf\",\"new_name\":\"1756981794_214___________________________________________________________________.pdf\"}]', '2025-09-04 07:30:00', '2025-09-09 04:43:00'),
(229, 'DOC-20260429-3878', 'سياسة إدارة المعلومات الإدارية', 'ضوابط إنشاء، تصنيف، حفظ، تداول، تعديل، وحذف المعلومات الإدارية داخل النظام المعتمد، مع ضمان الأمان، المراقبة، التوثيق، والتدريب لضمان ال...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0008', NULL, NULL, NULL, 'documents/1756981896_214__________________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"_________________________________________________________.pdf\",\"new_name\":\"1756981896_214__________________________________________________________.pdf\"}]', '2025-09-04 07:31:00', '2025-09-09 04:44:00'),
(230, 'DOC-20260429-5712', 'سياسة إدارة الموقع الإلكتروني', 'ضوابط إنشاء، تحديث، أمن، وحفظ المحتوى على الموقع الإلكتروني، مع ضمان التوافق مع المعايير الأمنية والتقنية، وتحديد آليات المراجعة الدورية...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0009', NULL, NULL, NULL, 'documents/1756981971_214________________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"_______________________________________________________.pdf\",\"new_name\":\"1756981971_214________________________________________________________.pdf\"}]', '2025-09-04 07:32:00', '2025-09-09 04:45:00'),
(231, 'DOC-20260429-1231', 'سياسة النسخ الاحتياطي', 'نفيذ نسخ يومية وتزايدية، وتخزين النسخ في مواقع آمنة، مع مراقبة دورية، وإجراءات للطوارئ، وإتلاف آمن للوسائط لضمان استمرارية البيانات وحماي...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0011', NULL, NULL, NULL, 'documents/1756982039_214_________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"________________________________________.pdf\",\"new_name\":\"1756982039_214_________________________________________.pdf\"}]', '2025-09-04 07:34:00', '2025-09-09 04:49:00'),
(232, 'DOC-20260429-5925', 'سياسة إدارة الوصول', 'إنشاء الحسابات، مراجعة الصلاحيات، تطبيق مبدأ \"أقل صلاحية\"، وتفعيل المصادقة متعددة العوامل، مع توثيق الوصول والتدريب لضمان الأمان والامتثال', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0012', NULL, NULL, NULL, 'documents/1756982119_214___________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"__________________________________.pdf\",\"new_name\":\"1756982119_214___________________________________.pdf\"}]', '2025-09-04 07:35:00', '2025-09-09 04:50:00'),
(233, 'DOC-20260429-4107', 'سياسة استخدام البريد الإلكتروني والإنترنت', 'إنشاء الحسابات، مراجعة الصلاحيات، تطبيق مبدأ \"أقل صلاحية\"، وتفعيل المصادقة متعددة العوامل، مع توثيق الوصول والتدريب لضمان الأمان والامتثال', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0013', NULL, NULL, NULL, 'documents/1756982199_214_______________________________________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"______________________________________________________________________________.pdf\",\"new_name\":\"1756982199_214_______________________________________________________________________________.pdf\"}]', '2025-09-04 07:36:00', '2025-09-09 04:51:00'),
(234, 'DOC-20260429-2062', 'سياسة تحديثات البرمجيات', 'إجراءات تحديث البرمجيات، بدءًا من التخطيط والتقييم قبل التنفيذ، مرورًا بتصنيف التحديثات، والتوثيق، والمراجعة بعد التنفيذ، مع التأكيد على...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0014', NULL, NULL, NULL, 'documents/1756982301_214_____________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"____________________________________________.pdf\",\"new_name\":\"1756982301_214_____________________________________________.pdf\"}]', '2025-09-04 07:38:00', '2025-09-09 04:53:00'),
(235, 'DOC-20260429-3678', 'سياسة إدارة وأمان موارد الأجهزة', 'ضوابط قفل الأجهزة عند عدم الاستخدام، وتنظيف القرص بشكل دوري لحذف الملفات غير الضرورية، مع الالتزام بتدريب الموظفين على الأمان الرقمي وحما...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0010', NULL, NULL, NULL, 'documents/1756983216_214___________________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"__________________________________________________________.pdf\",\"new_name\":\"1756983216_214___________________________________________________________.pdf\"}]', '2025-09-04 07:54:00', '2025-09-09 04:47:00'),
(236, 'DOC-20260429-9212', 'سياسة الإصدار', 'تنظيم استقبال ومراجعة طلبات الإصدار التأميني وضمان دقة البيانات وجودة الخدمة', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0013', NULL, NULL, NULL, 'documents/1756983725_214_Issuance_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Issuance_Policy.pdf\",\"new_name\":\"1756983725_214_Issuance_Policy.pdf\"}]', '2025-09-04 08:02:00', '2025-09-18 10:18:00'),
(237, 'DOC-20260429-6563', 'اجراءات إدارة تقنية المعلومات', NULL, 1, 44, 44, NULL, NULL, 'procedure', 'approved', 'V1', NULL, NULL, NULL, 'documents/1757241442_214_Information_Technology_Procedures.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Technology_Procedures.pdf\",\"new_name\":\"1757241442_214_Information_Technology_Procedures.pdf\"}]', '2025-09-07 07:40:00', '2025-09-07 07:40:00'),
(238, 'DOC-20260429-4311', 'اجراءات قسم الأمن السيبراني', NULL, 1, 54, 54, NULL, NULL, 'procedure', 'approved', 'V1.0', NULL, NULL, NULL, 'documents/1757320491_242_Cybersecurity_Department_Procedures.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Cybersecurity_Department_Procedures.pdf\",\"new_name\":\"1757320491_242_Cybersecurity_Department_Procedures.pdf\"}]', '2025-09-08 05:34:00', '2025-09-08 05:34:00'),
(239, 'DOC-20260429-8641', 'سياسة حوكمة تقنية المعلومات', 'إطار الحوكمة التقنية في الشركة، بما في ذلك تنفيذ المشاريع التقنية وفق الأهداف التشغيلية، حماية البيانات، ضمان استمرارية العمل، وتحديد مسؤ...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0001', NULL, NULL, NULL, 'documents/1757403101_242_IT_Governance_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"IT_Governance_Policy.pdf\",\"new_name\":\"1757403101_242_IT_Governance_Policy.pdf\"}]', '2025-09-09 04:31:00', '2025-09-09 04:31:00'),
(240, 'DOC-20260429-3250', 'سياسة إدارة تقنية المعلومات', 'إدارة الأصول التقنية، الشبكات، البرمجيات، وحماية البيانات لضمان الأمان والامتثال التنظيمي، مع التأكيد على تحديث الأنظمة بشكل دوري وتدريب...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0002', NULL, NULL, NULL, 'documents/1757403196_242_Information_Technology_Management_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Technology_Management_Policy.pdf\",\"new_name\":\"1757403196_242_Information_Technology_Management_Policy.pdf\"}]', '2025-09-09 04:33:00', '2025-09-09 04:33:00'),
(241, 'DOC-20260429-4998', 'سياسة أمن مستخدمي تقنية المعلومات', 'قواعد استخدام الحسابات التقنية، حماية المعلومات، إدارة صلاحيات الوصول، والإبلاغ عن الحوادث الأمنية. كما تركز على أهمية حماية البيانات، اس...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0003', NULL, NULL, NULL, 'documents/1757403279_242_IT_User_Security_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"IT_User_Security_Policy.pdf\",\"new_name\":\"1757403279_242_IT_User_Security_Policy.pdf\"}]', '2025-09-09 04:36:00', '2025-09-09 04:36:00'),
(242, 'DOC-20260429-1512', 'سياسة أمن أنظمة تقنية المعلومات', 'معايير الأمان لأنظمة تقنية المعلومات في الشركة، بما في ذلك التكوين الآمن، التحكم في الوصول، حماية البيانات، وأمن الشبكات. تركز على مراقبة ...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0004', NULL, NULL, NULL, 'documents/1757403490_242_IT_Systems_Security_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"IT_Systems_Security_Policy.pdf\",\"new_name\":\"1757403490_242_IT_Systems_Security_Policy.pdf\"}]', '2025-09-09 04:38:00', '2025-09-09 04:38:00'),
(243, 'DOC-20260429-3025', 'سياسة أجهزة تقنية المعلومات', 'كيفية إدارة الأجهزة التقنية داخل الشركة، بدءًا من التخصيص والصيانة إلى التحديثات والمراجعات الدورية، مع التأكيد على الأمان وحماية البيان...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0005', NULL, NULL, NULL, 'documents/1757403559_242_Information_Technology_Devices_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Technology_Devices_Policy.pdf\",\"new_name\":\"1757403559_242_Information_Technology_Devices_Policy.pdf\"}]', '2025-09-09 04:39:00', '2025-09-09 04:39:00'),
(244, 'DOC-20260429-5949', 'سياسة برمجيات تقنية المعلومات', 'ضوابط تصنيف البرمجيات واستخدامها، بما في ذلك البرمجيات الجاهزة، المطورة داخليًا، والمفتوحة المصدر، مع تحديد شروط تقييم الجدوى، الدعم الف...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0006', NULL, NULL, NULL, 'documents/1757403675_242_Information_Technology_Software_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Technology_Software_Policy.pdf\",\"new_name\":\"1757403675_242_Information_Technology_Software_Policy.pdf\"}]', '2025-09-09 04:41:00', '2025-09-09 04:41:00'),
(245, 'DOC-20260429-4776', 'سياسة أنظمة الهاتف والاتصال الهاتفي', 'ضوابط إدارة وتخصيص الخطوط الهاتفية والأجهزة المحمولة، بما في ذلك تحديد الاحتياجات، اختيار مزود الخدمة، مراقبة الاستخدام، الأمان، إدارة ا...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0007', NULL, NULL, NULL, 'documents/1757403762_242_Phone_and_Telecommunication_Systems_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Phone_and_Telecommunication_Systems_Policy.pdf\",\"new_name\":\"1757403762_242_Phone_and_Telecommunication_Systems_Policy.pdf\"}]', '2025-09-09 04:42:00', '2025-09-09 04:42:00'),
(246, 'DOC-20260429-2551', 'سياسة إدارة المعلومات الإدارية', 'ضوابط إنشاء، تصنيف، حفظ، تداول، تعديل، وحذف المعلومات الإدارية داخل النظام المعتمد، مع ضمان الأمان، المراقبة، التوثيق، والتدريب لضمان ال...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0008', NULL, NULL, NULL, 'documents/1757403839_242_Administrative_Information_Management_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Administrative_Information_Management_Policy.pdf\",\"new_name\":\"1757403839_242_Administrative_Information_Management_Policy.pdf\"}]', '2025-09-09 04:44:00', '2025-09-09 04:44:00'),
(247, 'DOC-20260429-7162', 'سياسة إدارة الموقع الإلكتروني', 'ضوابط إنشاء، تحديث، أمن، وحفظ المحتوى على الموقع الإلكتروني، مع ضمان التوافق مع المعايير الأمنية والتقنية، وتحديد آليات المراجعة الدورية...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0009', NULL, NULL, NULL, 'documents/1757403922_242_Website_Management_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Website_Management_Policy.pdf\",\"new_name\":\"1757403922_242_Website_Management_Policy.pdf\"}]', '2025-09-09 04:45:00', '2025-09-09 04:45:00'),
(248, 'DOC-20260429-8135', 'سياسة إدارة وأمان موارد الأجهزة', 'ضوابط قفل الأجهزة عند عدم الاستخدام، وتنظيف القرص بشكل دوري لحذف الملفات غير الضرورية، مع الالتزام بتدريب الموظفين على الأمان الرقمي وحما...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0010', NULL, NULL, NULL, 'documents/1757404009_242_Device_Resources_Management_and_Security_Policy_.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Device_Resources_Management_and_Security_Policy_.pdf\",\"new_name\":\"1757404009_242_Device_Resources_Management_and_Security_Policy_.pdf\"}]', '2025-09-09 04:47:00', '2025-09-09 04:47:00'),
(249, 'DOC-20260429-2045', 'سياسة النسخ الاحتياطي', 'نفيذ نسخ يومية وتزايدية، وتخزين النسخ في مواقع آمنة، مع مراقبة دورية، وإجراءات للطوارئ، وإتلاف آمن للوسائط لضمان استمرارية البيانات وحماي...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0011', NULL, NULL, NULL, 'documents/1757404117_242_Backup_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Backup_Policy.pdf\",\"new_name\":\"1757404117_242_Backup_Policy.pdf\"}]', '2025-09-09 04:48:00', '2025-09-09 04:48:00'),
(250, 'DOC-20260429-8745', 'سياسة إدارة الوصول', 'إنشاء الحسابات، مراجعة الصلاحيات، تطبيق مبدأ \"أقل صلاحية\"، وتفعيل المصادقة متعددة العوامل، مع توثيق الوصول والتدريب لضمان الأمان والامتثال', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0012', NULL, NULL, NULL, 'documents/1757404186_242_Access_Management_Policy_.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Access_Management_Policy_.pdf\",\"new_name\":\"1757404186_242_Access_Management_Policy_.pdf\"}]', '2025-09-09 04:50:00', '2025-09-09 04:50:00'),
(251, 'DOC-20260429-8288', 'سياسة استخدام البريد الإلكتروني والإنترنت', 'إنشاء الحسابات، مراجعة الصلاحيات، تطبيق مبدأ \"أقل صلاحية\"، وتفعيل المصادقة متعددة العوامل، مع توثيق الوصول والتدريب لضمان الأمان والامتثال', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0013', NULL, NULL, NULL, 'documents/1757404269_242_Email___Internet_Usage_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Email___Internet_Usage_Policy.pdf\",\"new_name\":\"1757404269_242_Email___Internet_Usage_Policy.pdf\"}]', '2025-09-09 04:51:00', '2026-01-27 05:23:00'),
(252, 'DOC-20260429-8038', 'سياسة تحديثات البرمجيات', 'إجراءات تحديث البرمجيات، بدءًا من التخطيط والتقييم قبل التنفيذ، مرورًا بتصنيف التحديثات، والتوثيق، والمراجعة بعد التنفيذ، مع التأكيد على...', 1, 54, 54, NULL, NULL, 'policy', 'approved', '1ITM0014', NULL, NULL, NULL, 'documents/1757404355_242_Software_Update_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Software_Update_Policy.pdf\",\"new_name\":\"1757404355_242_Software_Update_Policy.pdf\"}]', '2025-09-09 04:53:00', '2025-09-09 04:53:00'),
(253, 'DOC-20260429-6481', 'سياسة تنظيم وإدارة العمليات الفنية', 'استخدام التقنية والبيانات لضمان حماية المعلومات، تكامل الأنظمة، وجودة الخدمة والامتثال التنظيمي.', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0001', NULL, NULL, NULL, 'documents/1758201960_242_Policy_for_Organizing_and_Managing.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Policy_for_Organizing_and_Managing.pdf\",\"new_name\":\"1758201960_242_Policy_for_Organizing_and_Managing.pdf\"}]', '2025-09-18 10:26:00', '2025-09-18 10:26:00'),
(254, 'DOC-20260429-4671', 'سياسة إعداد وتوثيق نماذج عروض التأمين', 'تنظم السياسة آلية استلام ومعالجة طلبات عروض التأمين عبر النظام ، لضمان اكتمال المستندات، دقة الإجراءات، وسرية البيانات وفق ضوابط رسمية.', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0002', NULL, NULL, NULL, 'documents/1758202053_242_Policy_for_Preparing_and_Documenting_Insurance_Quotation_Forms.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Policy_for_Preparing_and_Documenting_Insurance_Quotation_Forms.pdf\",\"new_name\":\"1758202053_242_Policy_for_Preparing_and_Documenting_Insurance_Quotation_Forms.pdf\"}]', '2025-09-18 10:27:00', '2025-09-18 10:27:00'),
(255, 'DOC-20260429-6121', 'سياسة الوضوح التعاقدي', 'الالتزام بعدم تنفيذ أي إجراء تأميني دون وجود خطاب تعيين رسمي، وضمان وضوح وتوثيق كافة عناصر العقد قبل الإصدار لتحقيق الشفافية والامتثال الك...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0003', NULL, NULL, NULL, 'documents/1758202151_242_Contractual_Clarity_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Contractual_Clarity_Policy.pdf\",\"new_name\":\"1758202151_242_Contractual_Clarity_Policy.pdf\"}]', '2025-09-18 10:29:00', '2025-09-18 10:29:00'),
(256, 'DOC-20260429-5924', 'سياسة الاستجابة للطوارئ والتعافي من الكوارث واستمرارية الأعمال', 'تصنيف المهام الحيوية، وتفعيل خطط بديلة للطوارئ، وضمان حماية البيانات والتشغيل دون انقطاع استمرارية الخدمة من خلال نسخ احتياطي مشفر، جاهزي...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0004', NULL, NULL, NULL, 'documents/1758202207_242_Emergency_Response__Disaster_Recovery__and_Business_Continuity_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Emergency_Response__Disaster_Recovery__and_Business_Continuity_Policy.pdf\",\"new_name\":\"1758202207_242_Emergency_Response__Disaster_Recovery__and_Business_Continuity_Policy.pdf\"}]', '2025-09-18 10:30:00', '2025-09-18 10:30:00'),
(257, 'DOC-20260429-9793', 'سياسة الأخطاء والإغفالات', 'الوقاية من الأخطاء من خلال مراجعة دقيقة، توثيق الإجراءات، استخدام النماذج المعتمدة، تحليل الملاحظات، تصحيح الأخطاء فوراً، ومتابعة الأداء...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0005', NULL, NULL, NULL, 'documents/1758202250_242_Errors_and_Omissions__E_O__Policy_.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Errors_and_Omissions__E_O__Policy_.pdf\",\"new_name\":\"1758202250_242_Errors_and_Omissions__E_O__Policy_.pdf\"}]', '2025-09-18 10:31:00', '2025-09-18 10:31:00'),
(258, 'DOC-20260429-5906', 'سياسة التعامل والعلاقات مع شركات التأمين', 'سياسة تنظيمية تضمن التعامل المهني والشفاف مع شركات التأمين عبر توثيق دقيق، مراجعة مستمرة، وتواصل رسمي يحفظ الحقوق ويلتزم بالضوابط التنظيم...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0006', NULL, NULL, NULL, 'documents/1758202330_242_Policy_for_Dealing_and_Relations_with_Insurance_Companies.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Policy_for_Dealing_and_Relations_with_Insurance_Companies.pdf\",\"new_name\":\"1758202330_242_Policy_for_Dealing_and_Relations_with_Insurance_Companies.pdf\"}]', '2025-09-18 10:32:00', '2025-09-18 10:32:00'),
(259, 'DOC-20260429-5729', 'سياسة تحليل المحفظة التأمينية', 'الالتزام بتحليل دوري للمحفظة التأمينية لتقييم الأداء، اكتشاف المخاطر، تحسين المنتجات، ومتابعة تنفيذ خطط التطوير', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0007', NULL, NULL, NULL, 'documents/1758202372_242_Insurance_Portfolio_Analysis_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Portfolio_Analysis_Policy.pdf\",\"new_name\":\"1758202372_242_Insurance_Portfolio_Analysis_Policy.pdf\"}]', '2025-09-18 10:33:00', '2025-09-18 10:33:00'),
(260, 'DOC-20260429-9472', 'سياسة الإبلاغ عن المخالفات', 'تنظم الإبلاغ عن المخالفات لضمان النزاهة والشفافية، عبر قنوات آمنة، مع حماية المبلغين، والتحقيق الفوري، والتصعيد عند الضرورة، وضمان سرية ا...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0008', NULL, NULL, NULL, 'documents/1758202448_242_Whistleblowing_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Whistleblowing_Policy.pdf\",\"new_name\":\"1758202448_242_Whistleblowing_Policy.pdf\"}]', '2025-09-18 10:34:00', '2025-09-18 10:34:00'),
(261, 'DOC-20260429-1660', 'سياسة تأكيد تحصيل قسط العميل قبل إصدار الوثيقة التأمينية', 'الالتزام بتحصيل القسط الأول من العميل قبل بدء إصدار الوثيقة التأمينية، مع التحقق من صحة المستندات ومتابعة الإجراءات لضمان حماية حقوق الشر...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM0009', NULL, NULL, NULL, 'documents/1758202527_242_Client_Premium_Collection_Confirmation.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Premium_Collection_Confirmation.pdf\",\"new_name\":\"1758202527_242_Client_Premium_Collection_Confirmation.pdf\"}]', '2025-09-18 10:35:00', '2025-09-18 10:35:00'),
(262, 'DOC-20260429-7842', 'سياسة الإصدار', 'تنظيم استقبال ومراجعة طلبات الإصدار التأميني وضمان دقة البيانات وجودة الخدمة', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM00010', NULL, NULL, NULL, 'documents/1758202574_242_Issuance_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Issuance_Policy.pdf\",\"new_name\":\"1758202574_242_Issuance_Policy.pdf\"}]', '2025-09-18 10:36:00', '2025-09-18 10:36:00');
INSERT INTO `documents` (`id`, `document_no`, `title`, `description`, `category_id`, `owner_id`, `reviewer_id`, `approver_id`, `department_id`, `type`, `status`, `version`, `effective_date`, `review_date`, `expiry_date`, `file_path`, `file_size`, `mime_type`, `is_controlled`, `requires_signature`, `rejection_reason`, `submitted_at`, `approved_at`, `tags`, `metadata`, `created_at`, `updated_at`) VALUES
(263, 'DOC-20260429-8570', 'سياسة الأرشفة الإلكترونية', 'إجراءات استقبال ومتابعة وتسوية مطالبات التأمين بدقة وشفافية، مع حفظ المستندات وضمان حماية بيانات العملاء', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM00012', NULL, NULL, NULL, 'documents/1758202782_242_Electronic_Archiving_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Electronic_Archiving_Policy.pdf\",\"new_name\":\"1758202782_242_Electronic_Archiving_Policy.pdf\"}]', '2025-09-18 10:40:00', '2025-09-18 10:40:00'),
(264, 'DOC-20260429-9106', 'سياسة اتفاقيات شروط الأعمال مع العملاء', 'العلاقة التعاقدية مع العميل عبر اتفاقية وساطة موحدة مدتها ثلاث سنوات، تضمن الالتزام بالخدمات ومنع التغيير دون مبرر موثق', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1TM00013', NULL, NULL, NULL, 'documents/1758202862_242_Policy_on_Terms_of_Business_Agreements__TOBA__with_Clients.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Policy_on_Terms_of_Business_Agreements__TOBA__with_Clients.pdf\",\"new_name\":\"1758202862_242_Policy_on_Terms_of_Business_Agreements__TOBA__with_Clients.pdf\"}]', '2025-09-18 10:41:00', '2025-09-18 10:41:00'),
(265, 'DOC-20260429-1283', 'V01', NULL, 2, 54, 54, NULL, NULL, 'procedure', 'approved', 'NULL', NULL, NULL, NULL, 'documents/1758203050_242_Technical_Procedures.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Technical_Procedures.pdf\",\"new_name\":\"1758203050_242_Technical_Procedures.pdf\"}]', '2025-09-18 10:44:00', '2025-09-18 10:44:00'),
(266, 'DOC-20260429-6014', 'السياسة العامة للفحص الدوري ومراجعة تقارير المعاينين الفنيين', 'آلية الفحص ومراجعة تقارير المعاينين الفنيين لضمان حياد دايموند ودقة التوثيق والامتثال للأنظمة.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2TM0011', NULL, NULL, NULL, 'documents/1760856315_214_General_Policy_for_Periodic_Inspection_and_Review_of_Technical_Surveyors____Reports.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"General_Policy_for_Periodic_Inspection_and_Review_of_Technical_Surveyors____Reports.pdf\",\"new_name\":\"1760856315_214_General_Policy_for_Periodic_Inspection_and_Review_of_Technical_Surveyors____Reports.pdf\"}]', '2025-10-19 03:46:00', '2025-10-19 03:46:00'),
(267, 'DOC-20260429-9181', 'سياسة الحضور والانصراف', 'ضوابط الحضور والانصراف،التأخيرات، والاستئذانات لضمان الانضباط الوظيفي، وتحدد آلية التعامل مع المخالفات والخصومات وفق اللوائح المعتمدة', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0001', NULL, NULL, NULL, 'documents/1763292154_242_training_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"training_Policy.pdf\",\"new_name\":\"1763292154_242_training_Policy.pdf\"}]', '2025-11-16 08:23:00', '2025-11-16 09:00:00'),
(268, 'DOC-20260429-5909', 'سياسة التوظيف', 'جميع مراحل التوظيف من الإعلان وحتى التعيين، مع ضمان الامتثال لمعايير العدالة، السعودة، التنوع، والتحقق المهني، لضمان استقطاب الكفاءات بك...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0007', NULL, NULL, NULL, 'documents/1763292356_242_Recruitment_and_Hiring_Policy__.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Recruitment_and_Hiring_Policy__.pdf\",\"new_name\":\"1763292356_242_Recruitment_and_Hiring_Policy__.pdf\"}]', '2025-11-16 08:26:00', '2025-11-16 08:26:00'),
(269, 'DOC-20260429-5206', 'سياسة تطوير المسار الوظيفي', 'بناء مسارات وظيفية واضحة للموظفين، وتطويرهم من خلال خطط فردية، وربط الترقية بالجاهزية والإنجاز، بما يضمن النمو المهني المتوازن داخل الشرك...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0017', NULL, NULL, NULL, 'documents/1763292476_242_Career_Path_Development_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Career_Path_Development_Policy.pdf\",\"new_name\":\"1763292476_242_Career_Path_Development_Policy.pdf\"}]', '2025-11-16 08:27:00', '2025-11-16 08:27:00'),
(270, 'DOC-20260429-8331', 'سياسة المسؤولية الاجتماعية', 'التزام الشركة بالمساهمة المجتمعية من خلال مبادرات بيئية، تعليمية، وتوظيفية، بما يعزز التنمية المستدامة ويعكس قيم دايموند المؤسسية', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0004', NULL, NULL, NULL, 'documents/1763292538_242_Corporate_Social_Responsibility_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Corporate_Social_Responsibility_Policy.pdf\",\"new_name\":\"1763292538_242_Corporate_Social_Responsibility_Policy.pdf\"}]', '2025-11-16 08:29:00', '2025-11-16 08:29:00'),
(271, 'DOC-20260429-3693', 'سياسة العمل عن بُعد', 'شروط العمل عن بُعد، وضوابط الأداء والتواصل والإنتاجية، وتحدد آلية الموافقات، المتابعة، والتعامل مع المخالفات، بما يضمن استمرارية العمل ب...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0021', NULL, NULL, NULL, 'documents/1763292602_242_Remote_Work_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Remote_Work_Policy.pdf\",\"new_name\":\"1763292602_242_Remote_Work_Policy.pdf\"}]', '2025-11-16 08:30:00', '2025-11-16 08:30:00'),
(272, 'DOC-20260429-2190', 'سياسة الشكاوى والإجراءات التأديبية', 'آلية تقديم الشكاوى والتحقيق فيها، وضوابط فرض الجزاءات التأديبية، مع ضمان سرية الإجراءات وحماية حقوق الموظفين وتحقيق العدالة التنظيمية', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0018', NULL, NULL, NULL, 'documents/1763292715_242_Complaints_and_Disciplinary_Procedures_Policy__.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Complaints_and_Disciplinary_Procedures_Policy__.pdf\",\"new_name\":\"1763292715_242_Complaints_and_Disciplinary_Procedures_Policy__.pdf\"}]', '2025-11-16 08:31:00', '2025-11-16 08:31:00'),
(273, 'DOC-20260429-7363', 'سياسة السفر لأغراض العمل', 'سفر الموظفين في المهام الرسمية داخل المملكة وخارجها، وتشمل ضوابط التكليف، التكاليف، البدلات، والتمثيل المهني للشركة', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0013', NULL, NULL, NULL, 'documents/1763292765_242_Business_Travel_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Business_Travel_Policy.pdf\",\"new_name\":\"1763292765_242_Business_Travel_Policy.pdf\"}]', '2025-11-16 08:32:00', '2025-11-16 08:32:00'),
(274, 'DOC-20260429-2942', 'سياسة الترفيه والضيافة', 'ضوابط الصرف على الضيافة والفعاليات الداخلية، بما يضمن تعزيز بيئة العمل دون تجاوز الميزانيات أو إساءة الاستخدام', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0014', NULL, NULL, NULL, 'documents/1763292808_242_Entertainment_and_Hospitality_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Entertainment_and_Hospitality_Policy.pdf\",\"new_name\":\"1763292808_242_Entertainment_and_Hospitality_Policy.pdf\"}]', '2025-11-16 08:33:00', '2025-11-16 08:33:00'),
(275, 'DOC-20260429-6591', 'سياسة البدلات والترقيات', 'ضوابط صرف البدلات وشروط الترقية، بما يضمن العدالة وتحفيز الأداء، مع مراعاة التدرج الوظيفي والاستحقاقات المرتبطة بالمهام الفعلية', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0011', NULL, NULL, NULL, 'documents/1763292876_242_allowances_and_Promotions_Policy__.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"allowances_and_Promotions_Policy__.pdf\",\"new_name\":\"1763292876_242_allowances_and_Promotions_Policy__.pdf\"}]', '2025-11-16 08:34:00', '2025-11-16 08:34:00'),
(276, 'DOC-20260429-1610', 'سياسة الانضمام الوظيفي (التوجيه الوظيفي للموظفين الجدد)', 'تنظم السياسة إجراءات استقبال وتوجيه الموظفين الجدد خلال أول 30 يوم عمل لضمان تكيفهم السلس مع بيئة العمل وتعزيز جاهزيتهم المهنية منذ اليوم ا...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0008', NULL, NULL, NULL, 'documents/1763293106_242_Employee_Onboarding_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Onboarding_Policy.pdf\",\"new_name\":\"1763293106_242_Employee_Onboarding_Policy.pdf\"}]', '2025-11-16 08:38:00', '2025-11-16 08:38:00'),
(277, 'DOC-20260429-4129', 'سياسة الأمن وحماية السرية', 'ضوابط تصنيف وحماية بيانات الموظفين، وتحدد صلاحيات الوصول، وآليات المشاركة الداخلية والخارجية، وتفرض عقوبات صارمة على أي خرق للسرية', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0020', NULL, NULL, NULL, 'documents/1763293214_242_security___Confidentiality_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"security___Confidentiality_Policy.pdf\",\"new_name\":\"1763293214_242_security___Confidentiality_Policy.pdf\"}]', '2025-11-16 08:40:00', '2025-11-16 08:40:00'),
(278, 'DOC-20260429-9758', 'سياسة أخلاقيات الموظفين ومدونة قواعد السلوك', 'توضح السياسة سلوكيات الموظف المتوقعة داخل بيئة العمل وخارجها، وتحدد مبادئ النزاهة، السرية، احترام الزملاء، وتجنب تضارب المصالح، مع تصنيف ...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0019', NULL, NULL, NULL, 'documents/1763293280_242_Employee_Rewards_and_Compensation_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Rewards_and_Compensation_Policy.pdf\",\"new_name\":\"1763293280_242_Employee_Rewards_and_Compensation_Policy.pdf\"}]', '2025-11-16 08:41:00', '2025-11-16 08:57:00'),
(279, 'DOC-20260429-3450', 'سياسة التدريب', 'آلية استقطاب المتدربين وتدريب الموظفين الجدد والحاليين، بهدف تطوير المهارات ورفع الكفاءة بما يتماشى مع احتياجات الشركة وأهدافها الاسترات...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0016', NULL, NULL, NULL, 'documents/1763293325_242_training_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"training_Policy.pdf\",\"new_name\":\"1763293325_242_training_Policy.pdf\"}]', '2025-11-16 08:42:00', '2025-11-16 08:42:00'),
(280, 'DOC-20260429-1361', 'سياسة النقل والتكليف', 'ضوابط النقل والتكليف الداخلي والخارجي، وشروط الموافقة والاعتراض، وتضمن توافق القرارات مع الاحتياج التشغيلي ومعايير العدالة الوظيفية', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0022', NULL, NULL, NULL, 'documents/1763293365_242_Transportation_and_Assignment_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Transportation_and_Assignment_Policy.pdf\",\"new_name\":\"1763293365_242_Transportation_and_Assignment_Policy.pdf\"}]', '2025-11-16 08:42:00', '2025-11-16 08:42:00'),
(281, 'DOC-20260429-3004', 'سياسة الإجازات', 'أنواع الإجازات المستحقة للموظفين وشروطها، بما يشمل الإجازات السنوية، المرضية، الرسمية، والحالات الخاصة، لضمان التوازن بين متطلبات العمل ...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1HRM0009', NULL, NULL, NULL, 'documents/1763293409_242_Leave_policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Leave_policy.pdf\",\"new_name\":\"1763293409_242_Leave_policy.pdf\"}]', '2025-11-16 08:43:00', '2026-03-31 05:31:00'),
(282, 'DOC-20260429-5590', 'سياسة القروض', 'شروط وضوابط منح القروض السكنية والشخصية للموظفين، وآلية السداد، والضمانات، بما يضمن العدالة والامتثال المالي وتقليل المخاطر', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1HRM0005', NULL, NULL, NULL, 'documents/1763293459_242_Loan_Policy__.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Loan_Policy__.pdf\",\"new_name\":\"1763293459_242_Loan_Policy__.pdf\"}]', '2025-11-16 08:44:00', '2026-03-31 06:34:00'),
(283, 'DOC-20260429-8923', 'سياسة إدارة وتقييم الأداء الوظيفي', 'آليات تقييم أداء الموظفين بشكل ربع سنوي وسنوي، باستخدام نماذج موحدة، وربط النتائج بالترقيات والمكافآت وخطط التطوير، مع ضمان الشفافية والع...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0015', NULL, NULL, NULL, 'documents/1763293512_242_Performance_Management_and_Evaluation_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Performance_Management_and_Evaluation_Policy.pdf\",\"new_name\":\"1763293512_242_Performance_Management_and_Evaluation_Policy.pdf\"}]', '2025-11-16 08:46:00', '2025-11-16 08:46:00'),
(284, 'DOC-20260429-4067', 'سياسة إنهاء خدمات الموظفين', 'إجراءات إنهاء الخدمة بأنواعه، بما في ذلك الاستقالة، عدم التجديد، الفصل التأديبي، والمخالصة، مع ضمان الشفافية، الحقوق النظامية، وحق الاعت...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0012', NULL, NULL, NULL, 'documents/1763293663_242_Employee_Termination_Policy__.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Termination_Policy__.pdf\",\"new_name\":\"1763293663_242_Employee_Termination_Policy__.pdf\"}]', '2025-11-16 08:47:00', '2026-01-27 04:48:00'),
(285, 'DOC-20260429-2972', 'سياسة الموارد البشرية العامة', 'الجوانب الإدارية المتعلقة بالموظفين من التوظيف وحتى إنهاء الخدمة، لتحقيق بيئة عمل عادلة ومنظمة', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0006', NULL, NULL, NULL, 'documents/1763293719_242_General_Human_Resources_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"General_Human_Resources_Policy.pdf\",\"new_name\":\"1763293719_242_General_Human_Resources_Policy.pdf\"}]', '2025-11-16 08:48:00', '2025-11-16 08:48:00'),
(286, 'DOC-20260429-6973', 'سياسة الإحلال والتعاقب الوظيفي', 'تعزيز التوطين من خلال تخطيط التعاقب الوظيفي، الاستقطاب الفعّال، تطوير الكفاءات الوطنية، ومراجعة دورية لضمان جاهزية الكوادر المؤهلة', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0003', NULL, NULL, NULL, 'documents/1763293773_242_Succession_and_Job_Replacement_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Succession_and_Job_Replacement_Policy.pdf\",\"new_name\":\"1763293773_242_Succession_and_Job_Replacement_Policy.pdf\"}]', '2025-11-16 08:49:00', '2025-11-16 08:49:00'),
(287, 'DOC-20260429-8816', 'سسياسة مكافحة التحرش الجنسي', 'توفير بيئة عمل آمنة خالية من التحرش، مع تحديد أنواع السلوك المحظور، وطرق الإبلاغ، وآليات التحقيق والعقوبات لحماية جميع الموظفين', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0002', NULL, NULL, NULL, 'documents/1763293976_242_Sexual_Harassment_Prevention_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Sexual_Harassment_Prevention_Policy.pdf\",\"new_name\":\"1763293976_242_Sexual_Harassment_Prevention_Policy.pdf\"}]', '2025-11-16 08:52:00', '2025-11-16 08:52:00'),
(288, 'DOC-20260429-4417', 'سياسة أخلاقيات الموظفين ومدونة قواعد السلوك', 'توضح السياسة سلوكيات الموظف المتوقعة داخل بيئة العمل وخارجها، وتحدد مبادئ النزاهة، السرية، احترام الزملاء، وتجنب تضارب المصالح، مع تصنيف ...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0019', NULL, NULL, NULL, 'documents/1763294207_242_Employee_Ethics_Policy_and_Code_of_Conduct.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Ethics_Policy_and_Code_of_Conduct.pdf\",\"new_name\":\"1763294207_242_Employee_Ethics_Policy_and_Code_of_Conduct.pdf\"}]', '2025-11-16 08:56:00', '2025-11-16 08:56:00'),
(289, 'DOC-20260429-3898', 'سياسة مكافآت وتعويضات الموظفين', 'تهدف سياسة مكافآت وتعويضات الموظفين إلى وضع إطار عادل وشفاف لإدارة المزايا المالية والحوافز المقدمة للموظفين، بما يعزز الأداء ويحفّز الإن...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0010', NULL, NULL, NULL, 'documents/1763294315_242_Employee_Rewards_and_Compensation_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Rewards_and_Compensation_Policy.pdf\",\"new_name\":\"1763294315_242_Employee_Rewards_and_Compensation_Policy.pdf\"}]', '2025-11-16 08:58:00', '2025-11-16 08:58:00'),
(290, 'DOC-20260429-4442', 'سياسة الحضور والانصراف', 'ضوابط الحضور والانصراف،التأخيرات، والاستئذانات لضمان الانضباط الوظيفي، وتحدد آلية التعامل مع المخالفات والخصومات وفق اللوائح المعتمدة', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0001', NULL, NULL, NULL, 'documents/1763294440_242_Attendance_and_Punctuality_Policy__.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Attendance_and_Punctuality_Policy__.pdf\",\"new_name\":\"1763294440_242_Attendance_and_Punctuality_Policy__.pdf\"}]', '2025-11-16 09:00:00', '2025-11-16 09:00:00'),
(291, 'DOC-20260429-7637', 'Suspicious Financial Transaction Reporting Form', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', 'NULL', NULL, NULL, NULL, 'documents/1764068325_242_Suspicious_Financial_Transaction_Reporting_Form1.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Suspicious_Financial_Transaction_Reporting_Form1.pdf\",\"new_name\":\"1764068325_242_Suspicious_Financial_Transaction_Reporting_Form1.pdf\"}]', '2025-11-25 07:58:00', '2025-11-25 08:40:00'),
(292, 'DOC-20260429-2976', 'ﻧﻤﻮذج إﺑﻼغ ﻋﻦ ﻋﻤﻠﻴﺎت ﻣﺎﻟﻴﺔ ﻣﺸﺒﻮهﺔ', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM2', NULL, NULL, NULL, 'documents/1764135645_242_Suspicious_Financial_Transaction_Reporting_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Suspicious_Financial_Transaction_Reporting_Form.pdf\",\"new_name\":\"1764135645_242_Suspicious_Financial_Transaction_Reporting_Form.pdf\"}]', '2025-11-26 02:41:00', '2025-11-26 02:52:00'),
(293, 'DOC-20260429-5317', 'نموذج إبلاغ عن عمليات مالية مشبوهه', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM2', NULL, NULL, NULL, 'documents/1764135852_242_Suspicious_Financial_Transaction_Reporting_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Suspicious_Financial_Transaction_Reporting_Form.pdf\",\"new_name\":\"1764135852_242_Suspicious_Financial_Transaction_Reporting_Form.pdf\"}]', '2025-11-26 02:44:00', '2025-11-26 04:17:00'),
(294, 'DOC-20260429-1862', 'ﻧﻤﻮذج إﻓﺼﺎح ﻋﻦ هدﻳﺔ', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM26', NULL, NULL, NULL, 'documents/1764136145_242_Gift_Disclosure_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Gift_Disclosure_Form.pdf\",\"new_name\":\"1764136145_242_Gift_Disclosure_Form.pdf\"}]', '2025-11-26 02:49:00', '2025-11-26 04:17:00'),
(295, 'DOC-20260429-6346', 'نموذج تقرير مراجعة ملف', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM25', NULL, NULL, NULL, 'documents/1764136280_242_File_Review_Report_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"File_Review_Report_Form.pdf\",\"new_name\":\"1764136280_242_File_Review_Report_Form.pdf\"}]', '2025-11-26 02:51:00', '2025-11-26 04:17:00'),
(296, 'DOC-20260429-9619', 'نموذج تقييم التزام إدارة الجودة والتطوير', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM134', NULL, NULL, NULL, 'documents/1764136513_242_Quality___Development_Management_Commitment_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Quality___Development_Management_Commitment_Evaluation_Form.pdf\",\"new_name\":\"1764136513_242_Quality___Development_Management_Commitment_Evaluation_Form.pdf\"}]', '2025-11-26 02:55:00', '2025-11-26 04:17:00'),
(297, 'DOC-20260429-8287', 'نموذج تقييم التزام إدارة العمليات', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM13', NULL, NULL, NULL, 'documents/1764136677_242_Operations_Management_Commitment_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Operations_Management_Commitment_Evaluation_Form.pdf\",\"new_name\":\"1764136677_242_Operations_Management_Commitment_Evaluation_Form.pdf\"}]', '2025-11-26 02:58:00', '2025-11-26 04:17:00'),
(298, 'DOC-20260429-5693', 'نموذج تقييم التزام إدارة الفنية', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM135', NULL, NULL, NULL, 'documents/1764136881_242_Technical_Management_Commitment_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Technical_Management_Commitment_Evaluation_Form.pdf\",\"new_name\":\"1764136881_242_Technical_Management_Commitment_Evaluation_Form.pdf\"}]', '2025-11-26 03:01:00', '2025-11-26 04:17:00'),
(299, 'DOC-20260429-9539', 'نموذج تقييم التزام إدارة المبيعات والتسويق', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM138', NULL, NULL, NULL, 'documents/1764136974_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Sales___Marketing_Management_Commitment_Evaluation_Form.pdf\",\"new_name\":\"1764136974_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf\"}]', '2025-11-26 03:02:00', '2025-11-26 03:06:00'),
(300, 'DOC-20260429-3352', 'نموذج تقييم التزام إدارة المبيعات والتسويق', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM138', NULL, NULL, NULL, 'documents/1764137192_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Sales___Marketing_Management_Commitment_Evaluation_Form.pdf\",\"new_name\":\"1764137192_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf\"}]', '2025-11-26 03:06:00', '2025-11-26 04:16:00'),
(301, 'DOC-20260429-4852', 'ااا', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', 'NULL', NULL, NULL, NULL, 'documents/1764140056_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Sales___Marketing_Management_Commitment_Evaluation_Form.pdf\",\"new_name\":\"1764140056_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf\"}]', '2025-11-26 03:54:00', '2025-11-26 04:16:00'),
(302, 'DOC-20260429-8375', 'ddd', NULL, 2, 54, 54, NULL, NULL, 'announcement', 'approved', 'NULL', NULL, NULL, NULL, 'documents/1764142417_242________________________________________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"_______________________________________________________________________________.pdf\",\"new_name\":\"1764142417_242________________________________________________________________________________.pdf\"}]', '2025-11-26 04:33:00', '2025-11-26 04:34:00'),
(303, 'DOC-20260429-9271', 'ffff', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', 'NULL', NULL, NULL, NULL, 'documents/1764142454_242________________________________________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"_______________________________________________________________________________.pdf\",\"new_name\":\"1764142454_242________________________________________________________________________________.pdf\"}]', '2025-11-26 04:34:00', '2025-12-04 08:03:00'),
(304, 'DOC-20260429-4862', 'للل', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', 'NULL', NULL, NULL, NULL, 'documents/1764143300_242________________________________________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"_______________________________________________________________________________.pdf\",\"new_name\":\"1764143300_242________________________________________________________________________________.pdf\"}]', '2025-11-26 04:48:00', '2025-12-04 08:03:00'),
(305, 'DOC-20260429-3340', 'fff', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', 'NULL', NULL, NULL, NULL, 'documents/1764231816_242____________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"___________________________________________.pdf\",\"new_name\":\"1764231816_242____________________________________________.pdf\"}]', '2025-11-27 05:23:00', '2025-12-01 06:31:00'),
(306, 'DOC-20260429-4983', 'dd', NULL, 2, 54, 54, NULL, NULL, 'form', 'approved', 'NULL', NULL, NULL, NULL, 'documents/1764581519_242_Gift_Disclosure_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Gift_Disclosure_Form.pdf\",\"new_name\":\"1764581519_242_Gift_Disclosure_Form.pdf\"}]', '2025-12-01 06:32:00', '2025-12-01 09:23:00'),
(307, 'DOC-20260429-9607', 'نموذج مراجعة ملف', 'التأكد من صحة وسلامة الوثائق الرسمية المعتمدة في الشركة، رصد المخالفات النظامية أو الإدارية ومعالجتها قبل تصعيدها', 2, 54, 54, NULL, NULL, 'form', 'approved', 'QDMFRM25', NULL, NULL, NULL, 'documents/1764592348_242_File_Review_Report_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"File_Review_Report_Form.pdf\",\"new_name\":\"1764592348_242_File_Review_Report_Form.pdf\"}]', '2025-12-01 09:34:00', '2025-12-01 09:34:00'),
(308, 'DOC-20260429-1618', 'نموذج إفصاح عن هدية', 'لتوثيق أي هدية تم تقديمها أو تم قبولها', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM26', NULL, NULL, NULL, 'documents/1764592513_242_Gift_Disclosure_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Gift_Disclosure_Form.pdf\",\"new_name\":\"1764592513_242_Gift_Disclosure_Form.pdf\"}]', '2025-12-01 09:36:00', '2025-12-01 09:36:00'),
(309, 'DOC-20260429-9299', 'نموذج تقييم التزام إدارة الموارد البشرية', 'يستخدم بناءً على معايير خاصة لتقييم الإدارة  ومعرفة مستوى تقدمها', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM133', NULL, NULL, NULL, 'documents/1764592622_242_Human_Resources_Management_Commitment_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Human_Resources_Management_Commitment_Evaluation_Form.pdf\",\"new_name\":\"1764592622_242_Human_Resources_Management_Commitment_Evaluation_Form.pdf\"}]', '2025-12-01 09:39:00', '2025-12-01 09:39:00'),
(310, 'DOC-20260429-4047', 'نموذج تقييم التزام إدارة تقنية المعلومات', 'يستخدم بناءً على معايير خاصة لتقييم الإدارة  ومعرفة مستوى تقدمها', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM137', NULL, NULL, NULL, 'documents/1764592768_242_Information_Technology_Management_Commitment_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Technology_Management_Commitment_Evaluation_Form.pdf\",\"new_name\":\"1764592768_242_Information_Technology_Management_Commitment_Evaluation_Form.pdf\"}]', '2025-12-01 09:40:00', '2025-12-01 09:40:00'),
(311, 'DOC-20260429-1090', 'نموذج تقييم التزام إدارة العمليات', 'يستخدم بناءً على معايير خاصة لتقييم الإدارة  ومعرفة مستوى تقدمها', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM136', NULL, NULL, NULL, 'documents/1764592849_242_Operations_Management_Commitment_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Operations_Management_Commitment_Evaluation_Form.pdf\",\"new_name\":\"1764592849_242_Operations_Management_Commitment_Evaluation_Form.pdf\"}]', '2025-12-01 09:42:00', '2025-12-01 09:42:00'),
(312, 'DOC-20260429-9318', 'نموذج تقييم التزام إدارة الجودة والتطوير', 'يستخدم بناءً على معايير خاصة لتقييم الإدارة  ومعرفة مستوى تقدمها', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM134', NULL, NULL, NULL, 'documents/1764592954_242_Quality___Development_Management_Commitment_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Quality___Development_Management_Commitment_Evaluation_Form.pdf\",\"new_name\":\"1764592954_242_Quality___Development_Management_Commitment_Evaluation_Form.pdf\"}]', '2025-12-01 09:43:00', '2025-12-01 09:43:00'),
(313, 'DOC-20260429-6451', 'نموذج تقييم إدارة المبيعات والتسويق', 'يستخدم بناءً على معايير خاصة لتقييم الإدارة  ومعرفة مستوى تقدمها', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM138', NULL, NULL, NULL, 'documents/1764593014_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Sales___Marketing_Management_Commitment_Evaluation_Form.pdf\",\"new_name\":\"1764593014_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf\"}]', '2025-12-01 09:44:00', '2025-12-01 09:44:00'),
(314, 'DOC-20260429-1815', 'نموذج إبلاغ عن عمليات مالية مشبوهة', 'للإبلاغ عن العمليات المالية المشتبه بها', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM24', NULL, NULL, NULL, 'documents/1764593091_242_Suspicious_Financial_Transaction_Reporting_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Suspicious_Financial_Transaction_Reporting_Form.pdf\",\"new_name\":\"1764593091_242_Suspicious_Financial_Transaction_Reporting_Form.pdf\"}]', '2025-12-01 09:46:00', '2025-12-01 09:46:00'),
(315, 'DOC-20260429-7958', 'نموذج تقييم التزام الإدارة الفنية', 'يستخدم بناءً على معايير خاصة لتقييم الإدارة  ومعرفة مستوى تقدمها', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM135', NULL, NULL, NULL, 'documents/1764593197_242_Technical_Management_Commitment_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Technical_Management_Commitment_Evaluation_Form.pdf\",\"new_name\":\"1764593197_242_Technical_Management_Commitment_Evaluation_Form.pdf\"}]', '2025-12-01 09:47:00', '2025-12-01 09:47:00'),
(316, 'DOC-20260429-3639', 'نموذج مطالبة عميل', 'يستخدم عند تحقق الخطر المؤمن ضدة ويعبئ من قبل العميل للمطالبة بالتعويض', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM88', NULL, NULL, NULL, 'documents/1764657546_242_Client_Claim_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Claim_Form.pdf\",\"new_name\":\"1764657546_242_Client_Claim_Form.pdf\"}]', '2025-12-02 03:40:00', '2025-12-02 03:40:00'),
(317, 'DOC-20260429-1353', 'نموذج تظلم عميل', 'يستخدم  في حال عدم رضى العميل عن نتيجة تسوية المطالبة أو نتيجة الشكوى', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM89', NULL, NULL, NULL, 'documents/1764657618_242_Client_Grievance_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Grievance_Form.pdf\",\"new_name\":\"1764657618_242_Client_Grievance_Form.pdf\"}]', '2025-12-02 03:44:00', '2025-12-02 03:44:00'),
(318, 'DOC-20260429-8028', 'نموذج تسليم محفظة العملاء', 'التعهد بتسليم كافة المحظة لمسؤول آخر', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM152', NULL, NULL, NULL, 'documents/1764657877_242_Client_Portfolio_Handover_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Portfolio_Handover_Form.pdf\",\"new_name\":\"1764657877_242_Client_Portfolio_Handover_Form.pdf\"}]', '2025-12-02 03:46:00', '2025-12-02 03:46:00'),
(319, 'DOC-20260429-4555', 'نموذج توثيق شكوى عميل', 'يستخدم لتوثيق الشكاوى وأرشفتها', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM87', NULL, NULL, NULL, 'documents/1764658015_242_Complaint_Documentation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Complaint_Documentation_Form.pdf\",\"new_name\":\"1764658015_242_Complaint_Documentation_Form.pdf\"}]', '2025-12-02 03:48:00', '2025-12-02 03:48:00'),
(320, 'DOC-20260429-9725', 'نموذج تنسيق داخل', 'لتوضيح التنسيق بين الأقسام أو الإدارات داخل الشركة.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM84', NULL, NULL, NULL, 'documents/1764658105_242_Internal_Coordination_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Internal_Coordination_Form.pdf\",\"new_name\":\"1764658105_242_Internal_Coordination_Form.pdf\"}]', '2025-12-02 03:49:00', '2025-12-02 03:49:00'),
(321, 'DOC-20260429-6020', 'نموذج سبب خسارة عميل – التجديدات', 'تحليل أسباب خسارة العملاء بهدف تحسين الأداء', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM05', NULL, NULL, NULL, 'documents/1764658163_242_Loss_of_Renewal_Client_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Loss_of_Renewal_Client_Form.pdf\",\"new_name\":\"1764658163_242_Loss_of_Renewal_Client_Form.pdf\"}]', '2025-12-02 03:50:00', '2025-12-02 03:50:00'),
(322, 'DOC-20260429-2616', 'نموذج مشاركة مسؤولية', 'لتوضيح تقاسم أو توزيع المسؤوليات بين أكثر من قسم أو جهة.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM86', NULL, NULL, NULL, 'documents/1764658219_242_Responsibility_Sharing_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Responsibility_Sharing_Form.pdf\",\"new_name\":\"1764658219_242_Responsibility_Sharing_Form.pdf\"}]', '2025-12-02 03:51:00', '2025-12-02 03:51:00'),
(323, 'DOC-20260429-3859', 'نموذج إحالة مهمة', 'لتوثيق تكليف قسم أو موظف بتنفيذ مهمة محددة مع تحديد تفاصيلها وموعد التسليم.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM85', NULL, NULL, NULL, 'documents/1764658278_242_Task_Referral_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Task_Referral_Form.pdf\",\"new_name\":\"1764658278_242_Task_Referral_Form.pdf\"}]', '2025-12-02 03:51:00', '2025-12-02 03:51:00'),
(324, 'DOC-20260429-1691', 'نموذج إقرار الالتزام بضوابط أجهزة الهاتف المحمولة (العمل)', 'معرفة ضوابط استخدام هواتف العمل المحمولة والاقرار بهذه الضوابط', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM153', NULL, NULL, NULL, 'documents/1764658345_242_Work_Issued_Mobile_Phone_Acknowledgment_and_Compliance_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Work_Issued_Mobile_Phone_Acknowledgment_and_Compliance_Form.pdf\",\"new_name\":\"1764658345_242_Work_Issued_Mobile_Phone_Acknowledgment_and_Compliance_Form.pdf\"}]', '2025-12-02 03:54:00', '2025-12-02 03:54:00'),
(325, 'DOC-20260429-8819', 'نموذج إعداد الأهداف السنوية', 'لتحديد أهداف السنة وضمان تحقيقها', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM62', NULL, NULL, NULL, 'documents/1764664008_242_Annual_Objectives_Setting_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Annual_Objectives_Setting_Form.pdf\",\"new_name\":\"1764664008_242_Annual_Objectives_Setting_Form.pdf\"}]', '2025-12-02 05:26:00', '2025-12-02 05:26:00'),
(326, 'DOC-20260429-1914', 'نموذج مراجعة المسار الوظيفي', 'نموذج يُستخدم لمراجعة وتوثيق طلب نقل موظف من إدارة إلى أخرى داخل المنشأة', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM64', NULL, NULL, NULL, 'documents/1764664017_242_Career_Path_Review_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Career_Path_Review_Form.pdf\",\"new_name\":\"1764664017_242_Career_Path_Review_Form.pdf\"}]', '2025-12-02 05:27:00', '2025-12-02 05:27:00'),
(327, 'DOC-20260429-1002', 'شهادة إخلاء طرف', NULL, 2, 54, 54, NULL, NULL, 'procedure', 'approved', 'NULL', NULL, NULL, NULL, 'documents/1764664076_242_Clearance_Certificate.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Clearance_Certificate.pdf\",\"new_name\":\"1764664076_242_Clearance_Certificate.pdf\"}]', '2025-12-02 05:31:00', '2025-12-02 05:31:00'),
(328, 'DOC-20260429-3906', 'نموذج إخلاء طرف', 'إثبات خلو طرف الموظف من الالتزامات عند تركه العمل.', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM114', NULL, NULL, NULL, 'documents/1764664312_242_Clearance_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Clearance_Form.pdf\",\"new_name\":\"1764664312_242_Clearance_Form.pdf\"}]', '2025-12-02 05:33:00', '2025-12-02 05:33:00'),
(329, 'DOC-20260429-3926', 'نموذج استلام وتسليم العُهدة (للموظف/المتدرب)', 'توثيق تسليم أو استلام العُهد المخصصة للموظف أو المتدرب.', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM115', NULL, NULL, NULL, 'documents/1764664448_242_Custody_Receipt___Handover_Form_Employee_Trainee.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Custody_Receipt___Handover_Form_Employee_Trainee.pdf\",\"new_name\":\"1764664448_242_Custody_Receipt___Handover_Form_Employee_Trainee.pdf\"}]', '2025-12-02 05:36:00', '2025-12-02 05:36:00'),
(330, 'DOC-20260429-2947', 'إشعار مباشرة العمل', 'لتوثيق وإقرار الموظف الجديد بمباشرتة للعمل', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM60', NULL, NULL, NULL, 'documents/1764664603_242_Effective_Date_Notice.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Effective_Date_Notice.pdf\",\"new_name\":\"1764664603_242_Effective_Date_Notice.pdf\"}]', '2025-12-02 05:37:00', '2025-12-02 05:37:00'),
(331, 'DOC-20260429-1484', 'نموذج تقديم شكوى للموظفين', 'نموذج لتقديم شكاوى الموظفين بشأن أي ممارسات غير عادلة أو مشكلات', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM61', NULL, NULL, NULL, 'documents/1764664686_242_Employee_Complaint_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Complaint_Form.pdf\",\"new_name\":\"1764664686_242_Employee_Complaint_Form.pdf\"}]', '2025-12-02 05:38:00', '2025-12-02 05:38:00'),
(332, 'DOC-20260429-9435', 'نموذج تقييم رضا الموظفين عن البرامج التدريبية', 'قياس جودة المحتوى وأداء المدرب وبيئة التدريب وأثره على العمل، بهدف تحسين البرامج التدريبية المستقبلية وضمان تحقيق الأهداف التطويرية للمو...', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM52', NULL, NULL, NULL, 'documents/1764664743_242_Employee_Training_Satisfaction_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Training_Satisfaction_Evaluation_Form.pdf\",\"new_name\":\"1764664743_242_Employee_Training_Satisfaction_Evaluation_Form.pdf\"}]', '2025-12-02 05:40:00', '2025-12-02 05:40:00'),
(333, 'DOC-20260429-9343', 'شهادة خبرة', NULL, 2, 54, 54, NULL, NULL, 'procedure', 'approved', 'NULL', NULL, NULL, NULL, 'documents/1764664817_242_Experience_Certificate.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Experience_Certificate.pdf\",\"new_name\":\"1764664817_242_Experience_Certificate.pdf\"}]', '2025-12-02 05:40:00', '2025-12-02 05:40:00'),
(334, 'DOC-20260429-2273', 'نموذج تقييم الانضمام النهائي', 'يقيم الموظف الجديد  تجربتة في الشركة  خلال 30 يوماً من انضمامة', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM56', NULL, NULL, NULL, 'documents/1764664850_242_Final_Evaluation_Form_for_Employee_Onboarding.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Final_Evaluation_Form_for_Employee_Onboarding.pdf\",\"new_name\":\"1764664850_242_Final_Evaluation_Form_for_Employee_Onboarding.pdf\"}]', '2025-12-02 05:41:00', '2025-12-02 05:41:00'),
(335, 'DOC-20260429-6988', 'بيانات ملف الموظف', 'توثيق جميع المعلومات الشخصية والوظيفية الأساسية للموظف.', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM117', NULL, NULL, NULL, 'documents/1764664981_242_Employee_File_Information.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_File_Information.pdf\",\"new_name\":\"1764664981_242_Employee_File_Information.pdf\"}]', '2025-12-02 05:43:00', '2025-12-02 05:43:00'),
(336, 'DOC-20260429-7372', 'نموذج مخالصة نهائية', 'تأكيد استلام الموظف لجميع مستحقاته المالية عند انتهاء العلاقة.', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM113', NULL, NULL, NULL, 'documents/1764838091_242_Final_Settlement_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Final_Settlement_Form.pdf\",\"new_name\":\"1764838091_242_Final_Settlement_Form.pdf\"}]', '2025-12-04 05:50:00', '2025-12-04 05:50:00'),
(337, 'DOC-20260429-2000', 'نموذج مخالصة مالية', 'الإبلاغ عن العمليات المالية المشتبه فيها', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM24', NULL, NULL, NULL, 'documents/1764838246_242_Financial_Clearance_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Financial_Clearance_Form.pdf\",\"new_name\":\"1764838246_242_Financial_Clearance_Form.pdf\"}]', '2025-12-04 05:52:00', '2025-12-04 05:52:00'),
(338, 'DOC-20260429-3793', 'نموذج طلب ضيافة/ فعالية', 'لطلب تنفيذ أو صرف خدمات ضيافة أو فعاليات', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM57', NULL, NULL, NULL, 'documents/1764838365_242_Hospitality_Event_Request_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Hospitality_Event_Request_Form.pdf\",\"new_name\":\"1764838365_242_Hospitality_Event_Request_Form.pdf\"}]', '2025-12-04 05:53:00', '2025-12-04 05:53:00'),
(339, 'DOC-20260429-8587', 'نموذج تقييم التهيئة الأولية', 'يقيم الموظف الجديد  تجربتة في الشركة  خلال  15 يوماً من انضمامة', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM55', NULL, NULL, NULL, 'documents/1764838438_242_Initial_Onboarding_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Initial_Onboarding_Evaluation_Form.pdf\",\"new_name\":\"1764838438_242_Initial_Onboarding_Evaluation_Form.pdf\"}]', '2025-12-04 05:54:00', '2025-12-04 05:54:00'),
(340, 'DOC-20260429-3744', 'نموذج نقل موظف داخلياً', 'تنظيم إجراءات نقل الموظف من إدارة إلى أخرى وتوثيق موافقته.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM118', NULL, NULL, NULL, 'documents/1764838531_242_Internal_Transfer_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Internal_Transfer_Form.pdf\",\"new_name\":\"1764838531_242_Internal_Transfer_Form.pdf\"}]', '2025-12-04 05:56:00', '2025-12-04 05:56:00'),
(341, 'DOC-20260429-2939', 'نموذج تقييم المقابلات الوظيفية', 'لتوثيق المقابلات وتقييم المرشحين لفرز المتقدمين', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM59', NULL, NULL, NULL, 'documents/1764838612_242_Interview_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Interview_Evaluation_Form.pdf\",\"new_name\":\"1764838612_242_Interview_Evaluation_Form.pdf\"}]', '2025-12-04 05:59:00', '2025-12-04 05:59:00'),
(342, 'DOC-20260429-5014', 'العرض الوظيفي', NULL, 2, 54, 54, NULL, NULL, 'procedure', 'approved', 'NULL', NULL, NULL, NULL, 'documents/1764838758_242_Job_Offer.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Job_Offer.pdf\",\"new_name\":\"1764838758_242_Job_Offer.pdf\"}]', '2025-12-04 06:00:00', '2025-12-04 06:00:00'),
(343, 'DOC-20260429-2853', 'نموذج احتياج وظيفي', 'لتنظيم طلبات التوظيف من الإدارات وسد الإحتياج', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM58', NULL, NULL, NULL, 'documents/1764838828_242_Job_Requisition_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Job_Requisition_Form.pdf\",\"new_name\":\"1764838828_242_Job_Requisition_Form.pdf\"}]', '2025-12-04 06:02:00', '2025-12-04 06:02:00'),
(344, 'DOC-20260429-7575', 'نموذج استقبال وتهئية الموظف الجديد', 'القائمة المتبعة لتهيئة الموظف خلال الثلاث الأشهر الأولى من عمله', 2, 54, 54, NULL, NULL, 'form', 'approved', 'QDMFRM145', NULL, NULL, NULL, 'documents/1764838958_242_New_Employee_Onboarding.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"New_Employee_Onboarding.pdf\",\"new_name\":\"1764838958_242_New_Employee_Onboarding.pdf\"}]', '2025-12-04 06:05:00', '2026-01-14 06:19:00'),
(345, 'DOC-20260429-7602', 'اتفاقية السرية وعدم الإفصاح', 'حماية المعلومات الحساسة من التسريب وضمان سرية التعاملات.', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM166', NULL, NULL, NULL, 'documents/1764845086_242_Non_disclosure_Agreement.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Non_disclosure_Agreement.pdf\",\"new_name\":\"1764845086_242_Non_disclosure_Agreement.pdf\"}]', '2025-12-04 07:46:00', '2025-12-04 07:46:00'),
(346, 'DOC-20260429-5444', 'نموذج وسائل الإتصال الرسمية للموظفين', 'توثيق بيانات ووسائل الاتصال الرسمية للموظف', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM199', NULL, NULL, NULL, 'documents/1764845204_242_Official_Means_of_Communication_for_Staff_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Official_Means_of_Communication_for_Staff_Form.pdf\",\"new_name\":\"1764845204_242_Official_Means_of_Communication_for_Staff_Form.pdf\"}]', '2025-12-04 07:49:00', '2025-12-04 07:49:00'),
(347, 'DOC-20260429-3471', 'نموذج التقييم الذاتي', 'يقيم الموظف نفسة من خلال معرفة نقاط ضعفة أو معرفة أهم الإنجازات التي عمل بها', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM54', NULL, NULL, NULL, 'documents/1764845390_242_Self__Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Self__Evaluation_Form.pdf\",\"new_name\":\"1764845390_242_Self__Evaluation_Form.pdf\"}]', '2025-12-04 07:51:00', '2025-12-04 07:51:00'),
(348, 'DOC-20260429-4842', 'نموذج تكليف المهام الحساسة', 'توثيق تكليف الموظف بمهام حساسة مع تحديد نطاقها وضمان الالتزام بالسياسات وتفعيل الرقابة المزدوجة للحد من المخاطر', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM51', NULL, NULL, NULL, 'documents/1764845502_242_Sensitive_Tasks_Assignment_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Sensitive_Tasks_Assignment_Form.pdf\",\"new_name\":\"1764845502_242_Sensitive_Tasks_Assignment_Form.pdf\"}]', '2025-12-04 07:52:00', '2025-12-04 07:52:00'),
(349, 'DOC-20260429-7984', 'نموذج المبادرة التدريبية', 'لتقديم فعالية تعليمية أو تطويرية أو ترفيهية لموظفين الشركة', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM53', NULL, NULL, NULL, 'documents/1764845559_242_Training_Initiative_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Training_Initiative_Form.pdf\",\"new_name\":\"1764845559_242_Training_Initiative_Form.pdf\"}]', '2025-12-04 07:53:00', '2025-12-04 07:53:00'),
(350, 'DOC-20260429-2418', 'نموذج طلب ميزانية سنوية', 'تجميع وتوثيق احتياجات الإدارات من بنود مالية تشغيلية أو رأسمالية للسنة القادمة، مع تحديد الأولويات والتكاليف، لضمان التخطيط المالي الفعّ...', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM46', NULL, NULL, NULL, 'documents/1764846223_242_Annual_Budget_Request_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Annual_Budget_Request_Form.pdf\",\"new_name\":\"1764846223_242_Annual_Budget_Request_Form.pdf\"}]', '2025-12-04 08:04:00', '2025-12-04 08:04:00'),
(351, 'DOC-20260429-8947', 'نموذج تقديم طلبات الإنفاق الرأسمالي', 'تقييم طلبات الزيادات المالية للموظفين', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM03', NULL, NULL, NULL, 'documents/1764846303_242_Capital_Expenditure_Request_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Capital_Expenditure_Request_Form.pdf\",\"new_name\":\"1764846303_242_Capital_Expenditure_Request_Form.pdf\"}]', '2025-12-04 08:06:00', '2025-12-04 08:06:00'),
(352, 'DOC-20260429-5866', 'نموذج تذكير العميل بالدفعة المستحقة', 'توحيد وإضفاء الطابع الرسمي على رسائل التذكير بالسداد لعملاء الوساطة التأمينية، عبر تضمين بيانات العميل والفاتورة والمبلغ المستحق ونص تذك...', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM40', NULL, NULL, NULL, 'documents/1764846404_242_Client__Payment_Reminder_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client__Payment_Reminder_Form.pdf\",\"new_name\":\"1764846404_242_Client__Payment_Reminder_Form.pdf\"}]', '2025-12-04 08:07:00', '2025-12-04 08:07:00'),
(353, 'DOC-20260429-2221', 'نموذج الموافقة على منح الائتمان', 'تنظيم عمليات منح الائتمان ومراقبة الأرصدة المدينة، بما يضمن المحافظة على السيولة النقدية وتقليل مخاطر التعثر المالي.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM38', NULL, NULL, NULL, 'documents/1764846478_242_Credit_Approval_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Credit_Approval_Form.pdf\",\"new_name\":\"1764846478_242_Credit_Approval_Form.pdf\"}]', '2025-12-04 08:09:00', '2025-12-04 08:09:00'),
(354, 'DOC-20260429-1867', 'نموذج طلب التقييم الائتماني', 'تنظيم عمليات منح الائتمان ومراقبة الأرصدة المدينة، بما يضمن المحافظة على السيولة النقدية وتقليل مخاطر التعثر المالي.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM37', NULL, NULL, NULL, 'documents/1764846559_242_Payment_Request_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Payment_Request_Form.pdf\",\"new_name\":\"1764846559_242_Payment_Request_Form.pdf\"}]', '2025-12-04 08:10:00', '2025-12-04 08:10:00'),
(355, 'DOC-20260429-2829', 'نموذج طلب صرف', 'لتوثيق طلب صرف مبالغ مالية من حسابات الشركة، ويشمل بيانات المبلغ، الغرض من الصرف، طريقة الدفع، والموافقات المعتمدة.', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM41', NULL, NULL, NULL, 'documents/1764846627_242_Payment_Request_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Payment_Request_Form.pdf\",\"new_name\":\"1764846627_242_Payment_Request_Form.pdf\"}]', '2025-12-04 08:11:00', '2025-12-04 08:11:00'),
(356, 'DOC-20260429-3773', 'نموذج منح المطالبات', 'لتقديم طلبات تغطية استثنائية من الصندوق الاحتياطي، ويُرفق به شرح تفصيلي للحالة وموافقة الرئيس التنفيذي.', 2, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM45', NULL, NULL, NULL, 'documents/1764846688_242_Request_For_Ex_Gratia_Claim_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Request_For_Ex_Gratia_Claim_Form.pdf\",\"new_name\":\"1764846688_242_Request_For_Ex_Gratia_Claim_Form.pdf\"}]', '2025-12-04 08:12:00', '2025-12-04 08:12:00'),
(357, 'DOC-20260429-5802', 'نموذج فشل النسخ', 'used to document data backup failure incidents—whether daily or periodic backups—and includes the cause of the failure, the time it occurred, and the steps taken to resolve the issue.', 1, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM82', NULL, NULL, NULL, 'documents/1764846996_242_Backup_Failure_Report_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Backup_Failure_Report_Form.pdf\",\"new_name\":\"1764846996_242_Backup_Failure_Report_Form.pdf\"}]', '2025-12-04 08:19:00', '2025-12-04 08:19:00'),
(358, 'DOC-20260429-8761', 'نموذج طلب عميل للوصول إلى الخدمات الإلكترونية', 'used when a client requests access to the electronic services portal.', 1, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM139', NULL, NULL, NULL, 'documents/1764847156_242_Client_E_Service_Access_Request_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_E_Service_Access_Request_Form.pdf\",\"new_name\":\"1764847156_242_Client_E_Service_Access_Request_Form.pdf\"}]', '2025-12-04 08:28:00', '2025-12-04 08:28:00'),
(359, 'DOC-20260429-3869', 'نموذج بلاغ فقدان جهاز', 'This form is used to formally report the loss of a technical device (such as a laptop, mobile phone, or tablet) belonging to the organization. It includes information about the device, the circumstanc', 1, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM76', NULL, NULL, NULL, 'documents/1764847705_242_Device_Loss_Report_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Device_Loss_Report_Form.pdf\",\"new_name\":\"1764847705_242_Device_Loss_Report_Form.pdf\"}]', '2025-12-04 08:30:00', '2025-12-04 08:30:00'),
(360, 'DOC-20260429-2251', 'نموذج بلاغ خاص للحوادث التقنية', 'used to report an urgent technical incident such as a service outage, data leak, or security malfunction. It includes details of the incident and the initial actions taken.', 1, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM79', NULL, NULL, NULL, 'documents/1764847827_242_Emergency_Technical_Incident_Report_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Emergency_Technical_Incident_Report_Form.pdf\",\"new_name\":\"1764847827_242_Emergency_Technical_Incident_Report_Form.pdf\"}]', '2025-12-04 08:32:00', '2025-12-04 08:32:00');
INSERT INTO `documents` (`id`, `document_no`, `title`, `description`, `category_id`, `owner_id`, `reviewer_id`, `approver_id`, `department_id`, `type`, `status`, `version`, `effective_date`, `review_date`, `expiry_date`, `file_path`, `file_size`, `mime_type`, `is_controlled`, `requires_signature`, `rejection_reason`, `submitted_at`, `approved_at`, `tags`, `metadata`, `created_at`, `updated_at`) VALUES
(361, 'DOC-20260429-7726', 'نموذج توثيق مشاركة خارجية للمعلومات', 'used to document the sharing of technical information or data with an external party, whether for support or collaboration purposes. It includes details of the shared information, the receiving entity', 1, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM80', NULL, NULL, NULL, 'documents/1764847985_242_External_Information_Sharing_Record_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"External_Information_Sharing_Record_Form.pdf\",\"new_name\":\"1764847985_242_External_Information_Sharing_Record_Form.pdf\"}]', '2025-12-04 08:36:00', '2025-12-04 08:36:00'),
(362, 'DOC-20260429-7713', 'نموذج طلب خدمات تقنية للموظفين/ المتدربين', 'used to request access or a service from the Information Technology Department.', 1, 54, 54, NULL, NULL, 'form', 'approved', '2QDMFRM140', NULL, NULL, NULL, 'documents/1764848233_242_IT_Services_Request_Form_for_Employees_Trainees.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"IT_Services_Request_Form_for_Employees_Trainees.pdf\",\"new_name\":\"1764848233_242_IT_Services_Request_Form_for_Employees_Trainees.pdf\"}]', '2025-12-04 08:39:00', '2025-12-04 08:39:00'),
(363, 'DOC-20260429-6051', 'نموذج إخلاء طرف تقني', 'used when an employee’s relationship with the organization ends (resignation, transfer, or retirement) to ensure the return of all devices, access privileges, and technical data. It is considered part', 1, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM83', NULL, NULL, NULL, 'documents/1764848349_242_Technical_Clearance_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Technical_Clearance_Form.pdf\",\"new_name\":\"1764848349_242_Technical_Clearance_Form.pdf\"}]', '2025-12-04 08:40:00', '2025-12-04 08:40:00'),
(364, 'DOC-20260429-6561', 'نموذج تغيير تقني', 'used to document changes to a specific service, system, or device.', 1, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM78', NULL, NULL, NULL, 'documents/1764848422_242_Technical_or_Major_Content_Change_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Technical_or_Major_Content_Change_Form.pdf\",\"new_name\":\"1764848422_242_Technical_or_Major_Content_Change_Form.pdf\"}]', '2025-12-04 08:41:00', '2025-12-04 08:41:00'),
(365, 'DOC-20260429-6855', 'نموذج طلب استثناء للوصول المؤقت', 'used to submit an official request to grant an employee or entity temporary access to a specific system or data for defined reasons, specifying the duration, purpose, and required approvals.', 1, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM81', NULL, NULL, NULL, 'documents/1764848496_242_Temporary_Access_Exception_Request_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Temporary_Access_Exception_Request_Form.pdf\",\"new_name\":\"1764848496_242_Temporary_Access_Exception_Request_Form.pdf\"}]', '2025-12-04 08:43:00', '2025-12-04 08:43:00'),
(366, 'DOC-20260429-9133', 'نموذج استلام جهاز بديل مؤقت', 'used to document the temporary issuance of a replacement device to a user whose device is lost or under maintenance. It includes details of the replacement device, the period of use, and the return co', 1, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM77', NULL, NULL, NULL, 'documents/1764848597_242_Temporary_Receive_Replacement_Device_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Temporary_Receive_Replacement_Device_Form.pdf\",\"new_name\":\"1764848597_242_Temporary_Receive_Replacement_Device_Form.pdf\"}]', '2025-12-04 08:48:00', '2025-12-04 08:48:00'),
(367, 'DOC-20260429-5316', 'نموذج التقييم السنوي لأمين المجلس', 'قياس أداء أمين المجلس المهني والتنظيمي سنويًا، واعتماده كمرجع لاتخاذ قرار تجديد التكليف أو إنهائه من قبل مجلس الإدارة أو اللجنة المختصة.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM127', NULL, NULL, NULL, 'documents/1764849524_242_Annual_Evaluation_Form_____Board_Secretary.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Annual_Evaluation_Form_____Board_Secretary.pdf\",\"new_name\":\"1764849524_242_Annual_Evaluation_Form_____Board_Secretary.pdf\"}]', '2025-12-04 08:58:00', '2025-12-04 08:58:00'),
(368, 'DOC-20260429-2864', 'نموذج تقييم أداء مجلس الإدارة واللجان المنبثقة', 'يتم تقييم الاداء كأساس لصرف المكافآت', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM128', NULL, NULL, NULL, 'documents/1764849543_242_Board_of_Directors_and_Committees_Performance_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Board_of_Directors_and_Committees_Performance_Evaluation_Form.pdf\",\"new_name\":\"1764849543_242_Board_of_Directors_and_Committees_Performance_Evaluation_Form.pdf\"}]', '2025-12-04 09:00:00', '2025-12-04 09:00:00'),
(369, 'DOC-20260429-2528', 'نموذج تقييم اجتماعات مجلس الإدارة', 'تقييم جودة اجتماعات المجلس من حيث الحضور، التحضير، التفاعل والالتزام، بهدف تحسين كفاءة وفاعلية أداء المجلس بشكل دوري.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM125', NULL, NULL, NULL, 'documents/1764849664_242_Board_of_Directors_Meeting_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Board_of_Directors_Meeting_Evaluation_Form.pdf\",\"new_name\":\"1764849664_242_Board_of_Directors_Meeting_Evaluation_Form.pdf\"}]', '2025-12-04 09:02:00', '2025-12-04 09:02:00'),
(370, 'DOC-20260429-5483', 'نموذج الإفصاح عن تعارض المصالح', 'الإفصاح عن تعارض المصالح لتوثيق أي حالة قائمة أو محتملة قد تؤثر على حياد أو موضوعية الأعضاء أو الموظفين، وضمان معالجتها وفق ضوابط الحوكمة.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM126', NULL, NULL, NULL, 'documents/1764849742_242_Conflict_of_Interest_Disclosure_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Conflict_of_Interest_Disclosure_Form.pdf\",\"new_name\":\"1764849742_242_Conflict_of_Interest_Disclosure_Form.pdf\"}]', '2025-12-04 09:03:00', '2025-12-04 09:03:00'),
(371, 'DOC-20260429-4703', 'نموذج إجراء فحص نافي للجهالة', 'توثيق الفحص النافي للجهالة لصفقات الاندماج أو الاستحواذ عبر تقييم مالي، قانوني، تشغيلي، وتنظيمي لتحديد المخاطر وضمان الامتثال وحماية مصا...', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM122', NULL, NULL, NULL, 'documents/1764849830_242_Due_Diligence_Review_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Due_Diligence_Review_Form.pdf\",\"new_name\":\"1764849830_242_Due_Diligence_Review_Form.pdf\"}]', '2025-12-04 09:04:00', '2025-12-04 09:04:00'),
(372, 'DOC-20260429-2394', 'إقرار حماية المعلومات', 'توثيق التزام أعضاء المجلس أو الموظفين بالحفاظ على سرية المعلومات وعدم استخدامها خارج نطاق العمل، ويُجدد دوريًا لضمان الامتثال.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM124', NULL, NULL, NULL, 'documents/1764849899_242_Information_Protection_Undertaking.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Information_Protection_Undertaking.pdf\",\"new_name\":\"1764849899_242_Information_Protection_Undertaking.pdf\"}]', '2025-12-04 09:05:00', '2025-12-04 09:05:00'),
(373, 'DOC-20260429-8240', 'نموذج مراجعة العقد غير القياسي', 'ضمان مرور العقد بمراحل الفحص والتصنيف والتحليل والموافقة قبل التوقيع، حتى تكون الشركة ملتزمة بالحوكمة والأنظمة', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM121', NULL, NULL, NULL, 'documents/1764849974_242_Non_Standard_Contract_Review_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Non_Standard_Contract_Review_Form.pdf\",\"new_name\":\"1764849974_242_Non_Standard_Contract_Review_Form.pdf\"}]', '2025-12-04 09:07:00', '2025-12-04 09:07:00'),
(374, 'DOC-20260429-3598', 'نموذج التصويت الإلكتروني عن بعد', 'ستخدم لتمكين المساهمين من التصويت على بنود الجمعية العمومية دون الحضور الفعلي، مع توثيق أصواتهم رسميًا وفق الأنظمة واللوائح', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM123', NULL, NULL, NULL, 'documents/1764850039_242_Remote_Electronic_Voting_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Remote_Electronic_Voting_Form.pdf\",\"new_name\":\"1764850039_242_Remote_Electronic_Voting_Form.pdf\"}]', '2025-12-04 09:08:00', '2025-12-04 09:08:00'),
(375, 'DOC-20260429-5996', 'نموذج رضا العملاء وخطة العمل لمعالجة الشكاوى الحرجة', 'قياس رضا العملاء ومعالجة الشكاوى الحرجة بخطة تصحيحية واضحة.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM107', NULL, NULL, NULL, 'documents/1764850201_242_Client_Satisfaction_and_Critical_Complaint_Action_Plan_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Satisfaction_and_Critical_Complaint_Action_Plan_Form.pdf\",\"new_name\":\"1764850201_242_Client_Satisfaction_and_Critical_Complaint_Action_Plan_Form.pdf\"}]', '2025-12-04 09:11:00', '2025-12-04 09:11:00'),
(376, 'DOC-20260429-1391', 'نموذج سجل رضا العملاء', 'توثيق نتائج استبيانات العملاء لمتابعة مؤشرات رضاهم بشكل دوري.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM108', NULL, NULL, NULL, 'documents/1764850315_242_Client_Satisfaction_Log.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Satisfaction_Log.pdf\",\"new_name\":\"1764850315_242_Client_Satisfaction_Log.pdf\"}]', '2025-12-04 09:13:00', '2025-12-04 09:13:00'),
(377, 'DOC-20260429-5158', 'نموذج إشعار مبكر بخطر محتمل', 'الإبلاغ الاستباقي عن مخاطر متوقعة لتقليل أثرها ومعالجتها مبكرًا.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM103', NULL, NULL, NULL, 'documents/1764850435_242_Early_Risk_Notification_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Early_Risk_Notification_Form.pdf\",\"new_name\":\"1764850435_242_Early_Risk_Notification_Form.pdf\"}]', '2025-12-04 09:14:00', '2025-12-04 09:14:00'),
(378, 'DOC-20260429-6449', 'سجل اطلاع الموظف على اتفاقية مستوى الخدمة', 'إثبات اطلاع الموظفين على شروط اتفاقيات مستوى الخدمة والتزامهم بها.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM95', NULL, NULL, NULL, 'documents/1764850493_242_Employee_Acknowledgment_of_SLA_Awareness.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Acknowledgment_of_SLA_Awareness.pdf\",\"new_name\":\"1764850493_242_Employee_Acknowledgment_of_SLA_Awareness.pdf\"}]', '2025-12-04 09:17:00', '2025-12-04 09:17:00'),
(379, 'DOC-20260429-9866', 'نموذج استبيان رضا الموظفين', 'جمع آراء الموظفين حول بيئة العمل والسياسات لتطويرها.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM109', NULL, NULL, NULL, 'documents/1764850684_242_Employee_Satisfaction_Survey_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Satisfaction_Survey_Form.pdf\",\"new_name\":\"1764850684_242_Employee_Satisfaction_Survey_Form.pdf\"}]', '2025-12-04 09:18:00', '2025-12-04 09:18:00'),
(380, 'DOC-20260429-1987', 'تقرير نتائج استبيان رضا الموظفين', 'عرض وتحليل نتائج استبيان رضا الموظفين واقتراح الحلول.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM110', NULL, NULL, NULL, 'documents/1764850755_242_Employee_Satisfaction_Survey_Report.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Employee_Satisfaction_Survey_Report.pdf\",\"new_name\":\"1764850755_242_Employee_Satisfaction_Survey_Report.pdf\"}]', '2025-12-04 09:19:00', '2025-12-04 09:19:00'),
(381, 'DOC-20260429-8762', 'مصفوفة الأثر - الجهد', 'المساعدة في ترتيب الأولويات بناءً على حجم الأثر مقابل الجهد المبذول.', 2, 54, 54, NULL, NULL, 'procedure', 'approved', '1QDMFRM102', NULL, NULL, NULL, 'documents/1764850812_242_Impact___Effort_Matrix.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Impact___Effort_Matrix.pdf\",\"new_name\":\"1764850812_242_Impact___Effort_Matrix.pdf\"}]', '2025-12-04 09:22:00', '2025-12-04 09:22:00'),
(382, 'DOC-20260429-9101', 'نموذج متابعة تنفيذ خطة التحسين', 'متابعة مراحل تنفيذ خطة التحسين وقياس مدى التقدم.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM101', NULL, NULL, NULL, 'documents/1764850935_242_Improvement_Implementation_Tracking_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Improvement_Implementation_Tracking_Form.pdf\",\"new_name\":\"1764850935_242_Improvement_Implementation_Tracking_Form.pdf\"}]', '2025-12-04 09:23:00', '2025-12-04 09:23:00'),
(383, 'DOC-20260429-6560', 'نموذج خطة تحسين', 'متابعة مراحل تنفيذ خطة التحسين وقياس مدى التقدم.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM101', NULL, NULL, NULL, 'documents/1764851046_242_Improvement_Plan_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Improvement_Plan_Form.pdf\",\"new_name\":\"1764851046_242_Improvement_Plan_Form.pdf\"}]', '2025-12-04 09:25:00', '2025-12-04 09:25:00'),
(384, 'DOC-20260429-7783', 'تقرير الحادث التشغيلي', 'توثيق تفاصيل الحوادث التشغيلية وأسبابها والإجراءات المتخذة.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM104', NULL, NULL, NULL, 'documents/1764851211_242_Operational_Incident_Report.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Operational_Incident_Report.pdf\",\"new_name\":\"1764851211_242_Operational_Incident_Report.pdf\"}]', '2025-12-04 09:27:00', '2025-12-04 09:27:00'),
(385, 'DOC-20260429-9459', 'نموذج متابعة إخلال من الشريك', 'رصد وتوثيق حالات الإخلال بالاتفاقيات من قبل الشريك لاتخاذ الإجراءات.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM94', NULL, NULL, NULL, 'documents/1764851264_242_Partner_Breach_Follow_up_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Partner_Breach_Follow_up_Form.pdf\",\"new_name\":\"1764851264_242_Partner_Breach_Follow_up_Form.pdf\"}]', '2025-12-04 09:28:00', '2025-12-04 09:28:00'),
(386, 'DOC-20260429-3451', 'نموذج تقييم الشريك', 'قياس كفاءة الشريك وملاءمته الاستراتيجية قبل وأثناء العلاقة التعاقدية.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM91', NULL, NULL, NULL, 'documents/1764851327_242_Partner_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Partner_Evaluation_Form.pdf\",\"new_name\":\"1764851327_242_Partner_Evaluation_Form.pdf\"}]', '2025-12-04 09:31:00', '2025-12-04 09:31:00'),
(387, 'DOC-20260429-5135', 'نموذج طلب شراكة', 'توثيق الرغبة في إقامة شراكة جديدة مع جهة خارجية وتحديد نطاق التعاون المقترح.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM90', NULL, NULL, NULL, 'documents/1764851596_242_Partnership_Request_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Partnership_Request_Form.pdf\",\"new_name\":\"1764851596_242_Partnership_Request_Form.pdf\"}]', '2025-12-04 09:35:00', '2025-12-04 09:35:00'),
(388, 'DOC-20260429-6809', 'نموذج طلب إعداد أو تعديل سياسة', 'رفع طلب رسمي لإعداد سياسة جديدة أو تعديل سياسة قائمة.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM112', NULL, NULL, NULL, 'documents/1764851734_242_Policy_Creation_or_Update_Request_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Policy_Creation_or_Update_Request_Form.pdf\",\"new_name\":\"1764851734_242_Policy_Creation_or_Update_Request_Form.pdf\"}]', '2025-12-04 09:36:00', '2025-12-04 09:36:00'),
(389, 'DOC-20260429-7354', 'نموذج مقترح تحسين', 'توثيق مقترحات الموظفين أو الإدارات لتحسين العمليات والخدمات.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM99', NULL, NULL, NULL, 'documents/1764851809_242_Proposed_Improvement_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Proposed_Improvement_Form.pdf\",\"new_name\":\"1764851809_242_Proposed_Improvement_Form.pdf\"}]', '2025-12-04 09:37:00', '2025-12-04 09:37:00'),
(390, 'DOC-20260429-6675', 'سجل المخاطر المرتبطة بالجودة', 'حصر ومتابعة المخاطر التي قد تؤثر على جودة العمليات أو الخدمات.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM105', NULL, NULL, NULL, 'documents/1764851870_242_Quality_Risk_Register.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Quality_Risk_Register.pdf\",\"new_name\":\"1764851870_242_Quality_Risk_Register.pdf\"}]', '2025-12-04 09:38:00', '2025-12-04 09:38:00'),
(391, 'DOC-20260429-3982', 'نموذج تحليل السبب الجذري', 'تحديد الأسباب الحقيقية للمشكلات لضمان وضع حلول فعّالة ودائمة.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM106', NULL, NULL, NULL, 'documents/1764851921_242_Root_Cause_Analysis_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Root_Cause_Analysis_Form.pdf\",\"new_name\":\"1764851921_242_Root_Cause_Analysis_Form.pdf\"}]', '2025-12-04 09:40:00', '2025-12-04 09:40:00'),
(392, 'DOC-20260429-2934', 'سجل الإخلال باتفاقية مستوى الخدمة', 'توثيق مخالفات أو إخلالات مزود الخدمة لمتابعتها ومعالجتها.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM97', NULL, NULL, NULL, 'documents/1764852052_242_SLA_Breach_Report_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"SLA_Breach_Report_Form.pdf\",\"new_name\":\"1764852052_242_SLA_Breach_Report_Form.pdf\"}]', '2025-12-04 09:41:00', '2025-12-04 09:41:00'),
(393, 'DOC-20260429-2208', 'نموذج التقييم الدوري لاتفاقية مستوى الخدمة', 'تقييم أداء الخدمات المقدمة بشكل دوري للتأكد من التوافق مع المعايير.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM96', NULL, NULL, NULL, 'documents/1764852769_242_SLA_Periodic_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"SLA_Periodic_Evaluation_Form.pdf\",\"new_name\":\"1764852769_242_SLA_Periodic_Evaluation_Form.pdf\"}]', '2025-12-04 09:55:00', '2025-12-04 09:55:00'),
(394, 'DOC-20260429-4579', 'تسجيل نتائج مراجعات اتفاقيات الخدمة مع الأطراف الخارجية.', 'مستوى الخدمة مع طرف خارجي محضر مراجعة اتفاقية', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM98', NULL, NULL, NULL, 'documents/1764852992_242_SLA_Review_Minutes_____External_Vendor.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"SLA_Review_Minutes_____External_Vendor.pdf\",\"new_name\":\"1764852992_242_SLA_Review_Minutes_____External_Vendor.pdf\"}]', '2025-12-04 09:59:00', '2025-12-04 09:59:00'),
(395, 'DOC-20260429-2640', 'نموذج إبلاغ عن عملية غير محكومة', 'توثيق أي عملية تُنفذ دون التزام بالسياسات أو الإجراءات المعتمدة.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM111', NULL, NULL, NULL, 'documents/1764853184_242_Unstructured_Process_Reporting_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Unstructured_Process_Reporting_Form.pdf\",\"new_name\":\"1764853184_242_Unstructured_Process_Reporting_Form.pdf\"}]', '2025-12-04 10:00:00', '2025-12-04 10:00:00'),
(396, 'DOC-20260429-9327', 'نموذج مثلث القيمة', 'توضيح القيمة المضافة المتبادلة بين الشركة والشريك وتحديد عناصر المنفعة.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM92', NULL, NULL, NULL, 'documents/1764853242_242_Value_Triangle_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Value_Triangle_Form.pdf\",\"new_name\":\"1764853242_242_Value_Triangle_Form.pdf\"}]', '2025-12-04 10:02:00', '2025-12-04 10:02:00'),
(397, 'DOC-20260429-4289', 'نموذج تقييم اداء اعمال الوكالات', 'لتقييم أداء وكالات التسويق عن مخرجات الطلب المنفذ من قبلهم', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM70', NULL, NULL, NULL, 'documents/1765085861_242_Agency_Performance_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Agency_Performance_Evaluation_Form.pdf\",\"new_name\":\"1765085861_242_Agency_Performance_Evaluation_Form.pdf\"}]', '2025-12-07 02:39:00', '2025-12-07 02:39:00'),
(398, 'DOC-20260429-3126', 'نموذج تقييم داخلي لرضا الإدارات عن مخرجات أبحاث السوق', 'يُستخدم لقياس رضا الإدارات الداخلية عن خدمات وأداء أبحاث السوق', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM65', NULL, NULL, NULL, 'documents/1765085974_242_An_internal_evaluation_model_for_Management_satisfaction_with_market_research_outputs.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"An_internal_evaluation_model_for_Management_satisfaction_with_market_research_outputs.pdf\",\"new_name\":\"1765085974_242_An_internal_evaluation_model_for_Management_satisfaction_with_market_research_outputs.pdf\"}]', '2025-12-07 02:41:00', '2025-12-07 02:41:00'),
(399, 'DOC-20260429-6343', 'نموذج متابعة أداء الحملة', 'إدارة المبيعات والتسويق (سياسة إدارة حملات العروض الخاصة والترويجية)', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM69', NULL, NULL, NULL, 'documents/1765086084_242_Campaign_Performance_Follow_up_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Campaign_Performance_Follow_up_Form.pdf\",\"new_name\":\"1765086084_242_Campaign_Performance_Follow_up_Form.pdf\"}]', '2025-12-07 02:42:00', '2025-12-07 02:42:00'),
(400, 'DOC-20260429-9079', 'نموذج اقتراح حملة', 'لتقديم إفتراحات حملات إعلانية أو ترويجية قبل تنفيذها', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM68', NULL, NULL, NULL, 'documents/1765086154_242_Campaign_Proposal_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Campaign_Proposal_Form.pdf\",\"new_name\":\"1765086154_242_Campaign_Proposal_Form.pdf\"}]', '2025-12-07 02:43:00', '2025-12-07 02:43:00'),
(401, 'DOC-20260429-1977', 'نموذج طلب فعالية للعملاء', 'يستخدم لتقديم طلب تنظيم فعالية موجهة للعملاء بهدف الترويج أو التفاعل معهم', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM66', NULL, NULL, NULL, 'documents/1765086219_242_Client_Event_Request_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Event_Request_Form.pdf\",\"new_name\":\"1765086219_242_Client_Event_Request_Form.pdf\"}]', '2025-12-07 02:45:00', '2025-12-07 02:45:00'),
(402, 'DOC-20260429-3341', 'نموذج مدى رضا العميل عن الفعالية', 'يستخدم لقياس مدى رضا العميل عن الفعالية المقامة بهدف تطوير الفعاليات المقدمة', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM67', NULL, NULL, NULL, 'documents/1765086320_242_Client_Event_Satisfaction_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Event_Satisfaction_Evaluation_Form.pdf\",\"new_name\":\"1765086320_242_Client_Event_Satisfaction_Evaluation_Form.pdf\"}]', '2025-12-07 02:46:00', '2025-12-07 02:46:00'),
(403, 'DOC-20260429-9366', 'نموذج الافصاح عن المنتجات التأمينية', 'يُستخدم للإفصاح عن تفاصيل المنتجات التأمينية المقدمة للعملاء، بما يضمن الشفافية والامتثال للأنظمة', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM73', NULL, NULL, NULL, 'documents/1765086370_242_Insurance_Products_Disclosure_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Insurance_Products_Disclosure_Form.pdf\",\"new_name\":\"1765086370_242_Insurance_Products_Disclosure_Form.pdf\"}]', '2025-12-07 02:46:00', '2025-12-07 02:46:00'),
(404, 'DOC-20260429-3761', 'نموذج تطوير منتج', 'لتوثيق وتقديم مقترحات تطوير منتجات جديدة أو تحسين المنتجات الحالية', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM75', NULL, NULL, NULL, 'documents/1765086417_242_Internal_Evaluation_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Internal_Evaluation_Form.pdf\",\"new_name\":\"1765086417_242_Internal_Evaluation_Form.pdf\"}]', '2025-12-07 02:47:00', '2025-12-07 02:48:00'),
(405, 'DOC-20260429-2726', 'نموذج طلب مشروع تسويقي', 'يهدف إلى دعم الشركة وزيادة مبيعاتها وتعزيز العلامة التجارية من خلال الترويج أو التسويق', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM71', NULL, NULL, NULL, 'documents/1765086517_242_Marketing_Project_Request_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Marketing_Project_Request_Form.pdf\",\"new_name\":\"1765086517_242_Marketing_Project_Request_Form.pdf\"}]', '2025-12-07 02:49:00', '2025-12-07 02:49:00'),
(406, 'DOC-20260429-6185', 'اتفاقية عدم إفصاح للوكالات التسويقية', 'يضمان حماية سرية المعلومات والبيانات المتبادلة بين الشركة والوكالة التسويقية، ومنع الإفصاح أو الاستخدام غير المصرح به لأي محتوى أو مواد ت...', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM72', NULL, NULL, NULL, 'documents/1765086591_242_Non_Disclosure_Agreement_for_Marketing_Agencies.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Non_Disclosure_Agreement_for_Marketing_Agencies.pdf\",\"new_name\":\"1765086591_242_Non_Disclosure_Agreement_for_Marketing_Agencies.pdf\"}]', '2025-12-07 02:50:00', '2025-12-07 02:50:00'),
(407, 'DOC-20260429-5461', 'نموذج طلب المادة ترويجية', 'لطلب المواد اللازمة لدعم الحملات أو الفعاليات التسويقية', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM74', NULL, NULL, NULL, 'documents/1765086655_242_Promotional_Material_Request_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Promotional_Material_Request_Form.pdf\",\"new_name\":\"1765086655_242_Promotional_Material_Request_Form.pdf\"}]', '2025-12-07 02:52:00', '2025-12-07 02:52:00'),
(408, 'DOC-20260429-1286', 'نموذج تطوير منتج', 'لتوثيق وتقديم مقترحات تطوير منتجات جديدة أو تحسين المنتجات الحالية', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM75', NULL, NULL, NULL, 'documents/1765087196_242_Product_Development_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Product_Development_Form.pdf\",\"new_name\":\"1765087196_242_Product_Development_Form.pdf\"}]', '2025-12-07 03:00:00', '2025-12-07 03:00:00'),
(409, 'DOC-20260429-3488', 'خطاب تفويض وسيط', 'BROKER OF RECORD LETTER', 2, 54, 54, NULL, NULL, 'procedure', 'approved', 'NULL', NULL, NULL, NULL, 'documents/1765087342_242_BROKER_OF_RECORD_LETTER.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"BROKER_OF_RECORD_LETTER.pdf\",\"new_name\":\"1765087342_242_BROKER_OF_RECORD_LETTER.pdf\"}]', '2025-12-07 03:03:00', '2025-12-07 03:03:00'),
(410, 'DOC-20260429-6274', 'نموذج الإجراء التصحيحي', 'To document the details of the corrective actions taken to address the identified technical errors, ensure their implementation and approval within the specified timeframe, and follow up on them', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM32', NULL, NULL, NULL, 'documents/1765087437_242_Corrective_Action_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Corrective_Action_Form.pdf\",\"new_name\":\"1765087437_242_Corrective_Action_Form.pdf\"}]', '2025-12-07 03:05:00', '2025-12-07 03:05:00'),
(411, 'DOC-20260429-4246', 'نموذج استعادة النشاط بعد الطوارئ', 'To document the restoration of critical activities after emergencies, the underlying causes, the corrective actions taken, and the results of the final review.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM28', NULL, NULL, NULL, 'documents/1765087524_242_Emergency_Recovery_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Emergency_Recovery_Form.pdf\",\"new_name\":\"1765087524_242_Emergency_Recovery_Form.pdf\"}]', '2025-12-07 03:06:00', '2025-12-07 03:06:00'),
(412, 'DOC-20260429-7829', 'نموذج طلب معاينة', 'When a technical inspection of the insured asset is required.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM29', NULL, NULL, NULL, 'documents/1765087593_242_Request_for_Inspection_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Request_for_Inspection_Form.pdf\",\"new_name\":\"1765087593_242_Request_for_Inspection_Form.pdf\"}]', '2025-12-07 03:07:00', '2025-12-07 03:07:00'),
(413, 'DOC-20260429-5197', 'نموذج سجل الطارئ الفني', 'To document the details of technical incidents from the time they are detected until they are resolved, including basic information, affected systems, and the actions taken.', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM27', NULL, NULL, NULL, 'documents/1765087651_242_Technical_Emergency_Record_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Technical_Emergency_Record_Form.pdf\",\"new_name\":\"1765087651_242_Technical_Emergency_Record_Form.pdf\"}]', '2025-12-07 03:08:00', '2025-12-07 03:08:00'),
(414, 'DOC-20260429-4833', 'نموذج بلاغ عن خطأ فني', 'To report any technical error or omission identified in insurance quotations or documents, in order to document, follow up, and address it in accordance with the approved procedures of the Technical D', 2, 54, 54, NULL, NULL, 'form', 'approved', '1QDMFRM31', NULL, NULL, NULL, 'documents/1765087717_242_Technical_Error_Report_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Technical_Error_Report_Form.pdf\",\"new_name\":\"1765087717_242_Technical_Error_Report_Form.pdf\"}]', '2025-12-07 03:10:00', '2025-12-07 03:10:00'),
(415, 'DOC-20260429-4677', 'نموذج مذكرة التسوية المحاسبية', 'نموذج داخلي يوضح تفاصيل التسوية والفروقات والإجراء المحاسبي المصاحب. وصف الفروقات، أسبابها، الحسابات المتأثرة، والتوصية بالمعالجة.', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM3', NULL, NULL, NULL, 'documents/1765174218_214_Accounting_Reconciliation_Memo.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Accounting_Reconciliation_Memo.pdf\",\"new_name\":\"1765174218_214_Accounting_Reconciliation_Memo.pdf\"}]', '2025-12-08 03:10:00', '2025-12-08 03:11:00'),
(416, 'DOC-20260429-1125', 'نموذج مذكرة التسوية المحاسبية', 'نموذج داخلي يوضح تفاصيل التسوية والفروقات والإجراء المحاسبي المصاحب. وصف الفروقات، أسبابها، الحسابات المتأثرة، والتوصية بالمعالجة.', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM39', NULL, NULL, NULL, 'documents/1765174282_214_Accounting_Reconciliation_Memo.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Accounting_Reconciliation_Memo.pdf\",\"new_name\":\"1765174282_214_Accounting_Reconciliation_Memo.pdf\"}]', '2025-12-08 03:11:00', '2025-12-08 03:11:00'),
(417, 'DOC-20260429-6315', 'نموذج العهدة النثرية ', 'لتوثيق مصروفات العهدة النقدية المخصصة للنفقات اليومية البسيطة، ويتضمن تفاصيل المصروف، الفاتورة الداعمة، وقيمة الضريبة المضافة.', 2, 44, 44, NULL, NULL, 'form', 'approved', '2QDMFRM42', NULL, NULL, NULL, 'documents/1765174936_214_Petty_Cash_Form.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Petty_Cash_Form.xlsx\",\"new_name\":\"1765174936_214_Petty_Cash_Form.xlsx\"}]', '2025-12-08 03:22:00', '2025-12-08 03:22:00'),
(418, 'DOC-20260429-5489', 'نموذج ورقة تغطية الدفع ', 'لتوثيق المدفوعات اليومية والتسويات البنكية، ويُرفق مع سند الصرف.', 2, 44, 44, NULL, NULL, 'form', 'approved', '2QDMFRM43', NULL, NULL, NULL, 'documents/1765175028_214_Payment_Cover_form.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Payment_Cover_form.xlsx\",\"new_name\":\"1765175028_214_Payment_Cover_form.xlsx\"}]', '2025-12-08 03:23:00', '2025-12-08 03:23:00'),
(419, 'DOC-20260429-4007', 'نموذج المصروف للفعاليات ', 'يُستخدم من قبل إدارة التسويق عند طلب ميزانية لفعالية مخصصة للعميل، ويتضمن اسم العميل، تفاصيل الفعالية، والتكلفة الإجمالية.', 2, 44, 44, NULL, NULL, 'form', 'approved', '2QDMFRM44', NULL, NULL, NULL, 'documents/1765175094_214_Event_Expense_Form.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Event_Expense_Form.xlsx\",\"new_name\":\"1765175094_214_Event_Expense_Form.xlsx\"}]', '2025-12-08 03:25:00', '2025-12-08 03:25:00'),
(420, 'DOC-20260429-7928', 'نموذج الإقرار الضريبي', 'توثيق واعتماد البيانات الضريبية داخليًا قبل رفعها للهيئة، لضمان دقتها واتساقها مع الأنظمة وتقليل مخاطر الأخطاء.', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM47', NULL, NULL, NULL, 'documents/1765175170_214_Internal_Tax_Declaration_Form.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Internal_Tax_Declaration_Form.xlsx\",\"new_name\":\"1765175170_214_Internal_Tax_Declaration_Form.xlsx\"}]', '2025-12-08 03:28:00', '2025-12-08 03:28:00'),
(421, 'DOC-20260429-3114', 'نموذج المصروف للفعاليات ', 'يُستخدم من قبل إدارة التسويق عند طلب ميزانية لفعالية مخصصة للعميل، ويتضمن اسم العميل، تفاصيل الفعالية، والتكلفة الإجمالية.', 2, 44, 44, NULL, NULL, 'form', 'approved', '2QDMFRM44', NULL, NULL, NULL, 'documents/1765175375_214_Event_Expense_Form.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Event_Expense_Form.xlsx\",\"new_name\":\"1765175375_214_Event_Expense_Form.xlsx\"}]', '2025-12-08 03:33:00', '2025-12-08 03:33:00'),
(422, 'DOC-20260429-1308', 'نموذج شكوى عميل', 'عند رغبة العميل في تقديم شكوى تتعلق بخدمة أو وثيقة تأمينية، لتوثيق بيانات الشكوى ومتابعتها وفق الإجراءات المعتمدة في الإدارة الفنية', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM30', NULL, NULL, NULL, 'documents/1765177851_214_Client_Complaint_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Complaint_Form.pdf\",\"new_name\":\"1765177851_214_Client_Complaint_Form.pdf\"}]', '2025-12-08 04:11:00', '2025-12-08 04:11:00'),
(423, 'DOC-20260429-7329', 'نموذج تشغل يدوي', 'النموذج المستخدم قي حال تعطل نظام CRM المستخدم في استقبال الطلبات، المراسلات، أو إصدار الوثائق', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM33', NULL, NULL, NULL, 'documents/1765178456_214_Manual_Operation_Form.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Manual_Operation_Form.xlsx\",\"new_name\":\"1765178456_214_Manual_Operation_Form.xlsx\"}]', '2025-12-08 04:23:00', '2025-12-08 04:23:00'),
(424, 'DOC-20260429-9093', 'Brokerage Slip - نموذج إشعار الوساطة', 'توثيق طلبات التأمين من العملاء وتجميع البيانات الفنية والتجارية اللازمة للتسعير، بما يضمن التنسيق الفعّال بين إدارة المبيعات والإدارة ال...', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM34', NULL, NULL, NULL, 'documents/1765279882_214_Brokerage_Slip.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Brokerage_Slip.pdf\",\"new_name\":\"1765279882_214_Brokerage_Slip.pdf\"}]', '2025-12-09 08:35:00', '2025-12-09 08:35:00'),
(425, 'DOC-20260429-1774', 'Brokerage Slip - نموذج إشعار الوساطة', 'توثيق طلبات التأمين من العملاء وتجميع البيانات الفنية والتجارية اللازمة للتسعير، بما يضمن التنسيق الفعّال بين إدارة المبيعات والإدارة ال...', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM.33', NULL, NULL, NULL, 'documents/1765280345_214_Brokerage_Slip.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Brokerage_Slip.pdf\",\"new_name\":\"1765280345_214_Brokerage_Slip.pdf\"}]', '2025-12-09 08:39:00', '2025-12-09 08:39:00'),
(426, 'DOC-20260429-9809', 'اتفاقية شروط وأحكﺎم اﻷﻋﻤﺎل', 'تحديد الإطار الزمني الرسمي لاستمرار العلاقة التعاقدية بين شركة دايموند والعميل، وتوثيق التزام الطرفين بمدة محددة قابلة للتجديد', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM35', NULL, NULL, NULL, 'documents/1765280492_214_TOBA.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"TOBA.pdf\",\"new_name\":\"1765280492_214_TOBA.pdf\"}]', '2025-12-09 08:41:00', '2025-12-09 08:43:00'),
(427, 'DOC-20260429-4177', 'اتفاقية شروط وأحكام الأعمال', 'تحديد الإطار الزمني الرسمي لاستمرار العلاقة التعاقدية بين شركة دايموند والعميل، وتوثيق التزام الطرفين بمدة محددة قابلة للتجديد', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM35', NULL, NULL, NULL, 'documents/1765280618_214_TOBA.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"TOBA.pdf\",\"new_name\":\"1765280618_214_TOBA.pdf\"}]', '2025-12-09 08:44:00', '2025-12-09 08:44:00'),
(428, 'DOC-20260429-4286', 'نموذج تسجيل المورد', 'يخضع أي مورد جديد لإجراءات التسجيل المعتمدة', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM48', NULL, NULL, NULL, 'documents/1765284385_214_Supplier_Registration_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Supplier_Registration_Form.pdf\",\"new_name\":\"1765284385_214_Supplier_Registration_Form.pdf\"}]', '2025-12-09 09:48:00', '2025-12-09 09:48:00'),
(429, 'DOC-20260429-5832', 'نموذج طلب الشراء', 'عند أي إدارة ترغب في شراء منتج أو خدمة تقديم طلب شراء داخلي', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM49', NULL, NULL, NULL, 'documents/1765284506_214_Purchase_Request_Form__PR_.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Purchase_Request_Form__PR_.pdf\",\"new_name\":\"1765284506_214_Purchase_Request_Form__PR_.pdf\"}]', '2025-12-09 09:49:00', '2025-12-09 09:49:00'),
(430, 'DOC-20260429-2544', 'نموذج مقارنة الأسعار', 'يستخدم مقارنة الأسعار الرسمي لتقييم العروض المقدمة', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM50', NULL, NULL, NULL, 'documents/1765284789_214_Price_Comparison_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Price_Comparison_Form.pdf\",\"new_name\":\"1765284789_214_Price_Comparison_Form.pdf\"}]', '2025-12-09 09:53:00', '2025-12-09 09:53:00'),
(431, 'DOC-20260429-7968', 'نموذج منح المطالبات', 'لتقديم طلبات تغطية استثنائية من الصندوق الاحتياطي، ويُرفق به شرح تفصيلي للحالة وموافقة الرئيس التنفيذي.', 2, 44, 44, NULL, NULL, 'form', 'approved', '2QDMFRM.45', NULL, NULL, NULL, 'documents/1765799360_214_Request_For_Ex_Gratia_Claim_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Request_For_Ex_Gratia_Claim_Form.pdf\",\"new_name\":\"1765799360_214_Request_For_Ex_Gratia_Claim_Form.pdf\"}]', '2025-12-15 08:50:00', '2025-12-15 08:50:00'),
(432, 'DOC-20260429-6900', 'سياسة التجديدات', 'دورة متابعة تجديد الوثائق التأمينية بدءًا من إشعارات ما قبل الانتهاء وحتى إصدار الوثيقة الجديدة، مرورًا بالتفويضات، العروض الفنية، وآليا...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM000.3', NULL, NULL, NULL, 'documents/1766469015_214_Renewals_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Renewals_Policy___Arabic.pdf\",\"new_name\":\"1766469015_214_Renewals_Policy___Arabic.pdf\"}]', '2025-12-23 02:50:00', '2025-12-23 02:50:00'),
(433, 'DOC-20260429-9091', 'سياسة ضمان الاستجابة الفورية للعملاء', 'آلية التجاوب الفوري مع العملاء خلال ساعات العمل، وضمان التغطية البديلة عند الغياب، وتوثيق جميع الطلبات في نظام CRM، بما يحقق استمرارية الخد...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM000.4', NULL, NULL, NULL, 'documents/1766469080_214_Immediate_Client_Response_Assurance_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Immediate_Client_Response_Assurance_Policy___Arabic.pdf\",\"new_name\":\"1766469080_214_Immediate_Client_Response_Assurance_Policy___Arabic.pdf\"}]', '2025-12-23 02:51:00', '2025-12-23 02:51:00'),
(434, 'DOC-20260429-4640', 'سياسة العناية بالعملاء', 'معايير العناية بالعملاء داخل إدارة العمليات، بما يشمل سرعة الاستجابة، توثيق جميع الطلبات والشكاوى عبر نظام CRM، الالتزام باتفاقيات مستوى خ...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM000.6', NULL, NULL, NULL, 'documents/1766469109_214_Client_Care_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Care_Policy___Arabic.pdf\",\"new_name\":\"1766469109_214_Client_Care_Policy___Arabic.pdf\"}]', '2025-12-23 02:52:00', '2025-12-23 02:52:00'),
(435, 'DOC-20260429-3710', 'سياسة إدارة شكاوى العملاء', 'آلية استقبال وتصنيف ومعالجة شكاوى العملاء عبر قنوات متعددة وبأطر زمنية محددة، مع ضمان السرية، التوثيق الكامل في نظام CRM، والتصعيد الفوري ع...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM000.7', NULL, NULL, NULL, 'documents/1766469184_214_Client_Complaints_Management_Policy___Arabic.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Client_Complaints_Management_Policy___Arabic.pdf\",\"new_name\":\"1766469184_214_Client_Complaints_Management_Policy___Arabic.pdf\"}]', '2025-12-23 02:53:00', '2025-12-23 02:53:00'),
(436, 'DOC-20260429-4389', 'السياسة الداخلية لمطابقة الإنتاجية الشهرية', 'تنظيم وضبط آلية المطابقة الشهرية بين تقارير الإنتاجية المستخرجة من نظام دايموند والتقارير الرسمية الصادرة من شركات التأمين،بما يضمن دقة و...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM0015', NULL, NULL, NULL, 'documents/1767165609_214_Internal_Policy_for_Monthly_Productivity_Reconciliation.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Internal_Policy_for_Monthly_Productivity_Reconciliation.pdf\",\"new_name\":\"1767165609_214_Internal_Policy_for_Monthly_Productivity_Reconciliation.pdf\"}]', '2025-12-31 04:20:00', '2025-12-31 04:20:00'),
(437, 'DOC-20260429-1282', 'السياسة الداخلية لمطابقة الإنتاجية الشهرية', 'تنظيم وضبط آلية المطابقة الشهرية بين تقارير الإنتاجية المستخرجة من نظام دايموند والتقارير الرسمية الصادرة من شركات التأمين،بما يضمن دقة و...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1OM00.15', NULL, NULL, NULL, 'documents/1767165705_214_Internal_Policy_for_Monthly_Productivity_Reconciliation.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Internal_Policy_for_Monthly_Productivity_Reconciliation.pdf\",\"new_name\":\"1767165705_214_Internal_Policy_for_Monthly_Productivity_Reconciliation.pdf\"}]', '2025-12-31 04:21:00', '2025-12-31 04:21:00'),
(438, 'DOC-20260429-4154', 'IT Governance and Cybersecurity Policy', 'Allocation of roles and responsibilities across relevant departments to ensure compliance with Insurance Authority and NCA requirements, application of CIA information security principles, maintenance of electronic audit trails, and periodic internal rev...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0001', NULL, NULL, NULL, 'documents/1767609477_214_IT_Governance_and_Cybersecurity_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"IT_Governance_and_Cybersecurity_Policy.pdf\",\"new_name\":\"1767609477_214_IT_Governance_and_Cybersecurity_Policy.pdf\"}]', '2026-01-05 07:38:00', '2026-01-05 07:38:00'),
(439, 'DOC-20260429-6629', 'Digital Platform Operations and Business Continuity Policy', 'Regulation of daily platform operations and technical maintenance, ensuring regular backups, emergency data recovery, and effective technical risk management to maintain uninterrupted business continuity under an approved disaster recovery plan.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0002', NULL, NULL, NULL, 'documents/1767610087_214_Digital_Platform_Operations.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Digital_Platform_Operations.pdf\",\"new_name\":\"1767610087_214_Digital_Platform_Operations.pdf\"}]', '2026-01-05 07:48:00', '2026-01-05 07:48:00'),
(440, 'DOC-20260429-6411', 'Privacy and Data Protection Policy', 'Ensuring lawful and secure collection and processing of customer and user data in compliance with Saudi PDPL, including defined disclosure controls, data usage rules, retention periods, and secure data disposal mechanisms.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0003', NULL, NULL, NULL, 'documents/1767610128_214_Privacy_and_Data_Protection_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Privacy_and_Data_Protection_Policy.pdf\",\"new_name\":\"1767610128_214_Privacy_and_Data_Protection_Policy.pdf\"}]', '2026-01-05 07:49:00', '2026-01-05 07:49:00'),
(441, 'DOC-20260429-2725', 'Systems Development and Change Management Policy', 'Governance of internal software development and updates through segregated development and production environments, documented User Acceptance Testing (UAT), and formal technical and administrative approvals prior to deployment.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0004', NULL, NULL, NULL, 'documents/1767610263_214_Systems_Development_and_Change_Management_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Systems_Development_and_Change_Management_Policy.pdf\",\"new_name\":\"1767610263_214_Systems_Development_and_Change_Management_Policy.pdf\"}]', '2026-01-05 07:51:00', '2026-01-05 07:51:00'),
(442, 'DOC-20260429-9177', 'Systems Integration and Application Programming Interface (API) Policy', 'Establishing a secure framework for integrating the digital platform with insurance companies and external entities through APIs, including data flow documentation, validation of exchanged data, and implementation of required security controls.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0005', NULL, NULL, NULL, 'documents/1767610334_214_Systems_Integration_and_Application.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Systems_Integration_and_Application.pdf\",\"new_name\":\"1767610334_214_Systems_Integration_and_Application.pdf\"}]', '2026-01-05 07:52:00', '2026-01-05 07:52:00'),
(443, 'DOC-20260429-1205', 'Access Management and User Protection Policy', 'Defining controls for user account creation and access management, identity verification for internal and external users, enforcement of multi-factor authentication (MFA), and segregation of duties to prevent unauthorized access.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0006', NULL, NULL, NULL, 'documents/1767610419_214_Access_Management.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Access_Management.pdf\",\"new_name\":\"1767610419_214_Access_Management.pdf\"}]', '2026-01-05 07:54:00', '2026-01-05 07:54:00'),
(444, 'DOC-20260429-7813', 'Website and Mobile Application Management Policy', 'Managing and updating website and application content to ensure usability, compliance with user experience standards, and protection of publicly available data from unauthorized modification, in line with secure design principles.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0007', NULL, NULL, NULL, 'documents/1767610608_214_Website_and_Mobile_Application_Management_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Website_and_Mobile_Application_Management_Policy.pdf\",\"new_name\":\"1767610608_214_Website_and_Mobile_Application_Management_Policy.pdf\"}]', '2026-01-05 07:56:00', '2026-01-05 07:56:00'),
(445, 'DOC-20260429-9614', 'IT Vendors and Technical Services Management Policy', 'Regulating the selection, evaluation, and contracting of technical service providers and system vendors, defining security and performance requirements, confidentiality obligations, and periodic reviews to ensure service quality and continuity.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0008', NULL, NULL, NULL, 'documents/1767610683_214_IT_Vendors_and_Technical_Services.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"IT_Vendors_and_Technical_Services.pdf\",\"new_name\":\"1767610683_214_IT_Vendors_and_Technical_Services.pdf\"}]', '2026-01-05 07:58:00', '2026-01-05 07:58:00'),
(446, 'DOC-20260429-1719', 'Security Awareness and Training Policy', 'Enhancing cybersecurity awareness among employees and users through periodic training programs, continuous security guidance, and awareness alerts to ensure adherence to preventive security controls.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0009', NULL, NULL, NULL, 'documents/1767610767_214_Security_Awareness_and_Training_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Security_Awareness_and_Training_Policy.pdf\",\"new_name\":\"1767610767_214_Security_Awareness_and_Training_Policy.pdf\"}]', '2026-01-05 07:59:00', '2026-01-05 07:59:00'),
(447, 'DOC-20260429-6830', 'Platform Transactions and Financial Reconciliation Policy', 'Ensuring accuracy and integrity of financial transactions conducted through the Shahin Platform by regulating electronic collection and payment processes, performing periodic reconciliations, and maintaining financial documentation for transparency and c...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0010', NULL, NULL, NULL, 'documents/1767610868_214_Platform_Transactions_and_Financial.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Platform_Transactions_and_Financial.pdf\",\"new_name\":\"1767610868_214_Platform_Transactions_and_Financial.pdf\"}]', '2026-01-05 08:01:00', '2026-01-05 08:01:00'),
(448, 'DOC-20260429-9049', 'Partners Management Policy', 'Regulating relationships with strategic partners, insurance companies, and technical collaborators by defining roles, responsibilities, confidentiality obligations, and compliance requirements to ensure sustainable partnerships and shared objectives.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0011', NULL, NULL, NULL, 'documents/1767610897_214_Partners_Management_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Partners_Management_Policy.pdf\",\"new_name\":\"1767610897_214_Partners_Management_Policy.pdf\"}]', '2026-01-05 08:02:00', '2026-01-05 08:02:00'),
(449, 'DOC-20260429-4204', 'Marketing and Promotional Campaigns Management Policy', 'Governing the planning and execution of promotional and advertising campaigns to ensure regulatory compliance, fair disclosure, accuracy of marketing content, and documentation of approvals reflecting a professional platform image.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0012', NULL, NULL, NULL, 'documents/1767611089_214_Marketing_and_Promotional_Campaigns.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Marketing_and_Promotional_Campaigns.pdf\",\"new_name\":\"1767611089_214_Marketing_and_Promotional_Campaigns.pdf\"}]', '2026-01-05 08:05:00', '2026-01-05 08:05:00'),
(450, 'DOC-20260429-8788', 'Customer Service and User Experience Policy', 'Ensuring a consistent and high-quality digital customer experience through regulated communication channels, complaint and feedback management, service quality measurement, and fair and transparent electronic interactions.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0013', NULL, NULL, NULL, 'documents/1767611230_214_Customer_Service_and_User_Experience_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Customer_Service_and_User_Experience_Policy.pdf\",\"new_name\":\"1767611230_214_Customer_Service_and_User_Experience_Policy.pdf\"}]', '2026-01-05 08:07:00', '2026-01-05 08:07:00'),
(451, 'DOC-20260429-8312', 'Talent Acquisition Policy', 'Managing the attraction and training of talents, including fresh graduates and academic collaborators, by defining temporary system access controls, privilege restrictions, and protecting Shahin’s data and internal information during and after collabor...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1SP0014', NULL, NULL, NULL, 'documents/1767611280_214_Talent_Acquisition_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Talent_Acquisition_Policy.pdf\",\"new_name\":\"1767611280_214_Talent_Acquisition_Policy.pdf\"}]', '2026-01-05 08:08:00', '2026-01-05 08:08:00');
INSERT INTO `documents` (`id`, `document_no`, `title`, `description`, `category_id`, `owner_id`, `reviewer_id`, `approver_id`, `department_id`, `type`, `status`, `version`, `effective_date`, `review_date`, `expiry_date`, `file_path`, `file_size`, `mime_type`, `is_controlled`, `requires_signature`, `rejection_reason`, `submitted_at`, `approved_at`, `tags`, `metadata`, `created_at`, `updated_at`) VALUES
(452, 'DOC-20260429-8064', 'سياسة إدارة وتجديد خدمات النطاق والاشتراكات التقنية', 'تنظم هذه السياسة إدارة وتجديد النطاقات والاشتراكات التقنية لضمان استمرارية الخدمات الرقمية، ومنع الانقطاعات، وتحديد الصلاحيات والمسؤولي...', 1, 44, 44, NULL, NULL, 'policy', 'approved', '1ITM0016', NULL, NULL, NULL, 'documents/1767688238_214_Domain_and_Technical_Subscription_Management_and_Renewal_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Domain_and_Technical_Subscription_Management_and_Renewal_Policy.pdf\",\"new_name\":\"1767688238_214_Domain_and_Technical_Subscription_Management_and_Renewal_Policy.pdf\"}]', '2026-01-06 05:31:00', '2026-01-06 05:31:00'),
(453, 'DOC-20260429-9720', 'Central Subscription Register', 'A unified register used to document and manage all company domain services and technical subscriptions, covering provider details, contracts, service scope, dates, costs, responsibilities, renewal status, and payments, to ensure governance, effective tra...', 1, 44, 44, NULL, NULL, 'form', 'approved', 'QDMFRM163', NULL, NULL, NULL, 'documents/1767689122_214_______________________________________________.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"______________________________________________.xlsx\",\"new_name\":\"1767689122_214_______________________________________________.xlsx\"}]', '2026-01-06 05:49:00', '2026-01-06 05:49:00'),
(454, 'DOC-20260429-4405', 'سياسة مكافحة الاحتيال', 'مؤشرات الاحتيال وأساليب الوقاية منه داخليًا وخارجيًا، وتشمل ضوابط الإبلاغ، التحقق، التحقيق، حماية البيانات، والامتثال للأنظمة', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1LCM009', NULL, NULL, NULL, 'documents/1767858849_214_Anti_fraud_policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Anti_fraud_policy.pdf\",\"new_name\":\"1767858849_214_Anti_fraud_policy.pdf\"}]', '2026-01-08 04:54:00', '2026-01-08 09:08:00'),
(455, 'DOC-20260429-2338', 'سياسة مكافحة الاحتيال', 'مؤشرات الاحتيال وأساليب الوقاية منه داخليًا وخارجيًا، وتشمل ضوابط الإبلاغ، التحقق، التحقيق، حماية البيانات، والامتثال للأنظمة', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1LCM09', NULL, NULL, NULL, 'documents/1767858899_214_Anti_fraud_policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Anti_fraud_policy.pdf\",\"new_name\":\"1767858899_214_Anti_fraud_policy.pdf\"}]', '2026-01-08 04:55:00', '2026-01-08 09:09:00'),
(456, 'DOC-20260429-6812', 'سياسة مكافحة الاحتيال', 'مؤشرات الاحتيال وأساليب الوقاية منه داخليًا وخارجيًا، وتشمل ضوابط الإبلاغ، التحقق، التحقيق، حماية البيانات، والامتثال للأنظمة', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1LCM9', NULL, NULL, NULL, 'documents/1767858947_214_Anti_fraud_policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Anti_fraud_policy.pdf\",\"new_name\":\"1767858947_214_Anti_fraud_policy.pdf\"}]', '2026-01-08 04:56:00', '2026-01-08 09:08:00'),
(457, 'DOC-20260429-5130', 'سياسة مكافحة الاحتيال', 'مؤشرات الاحتيال وأساليب الوقاية منه داخليًا وخارجيًا، وتشمل ضوابط الإبلاغ، التحقق، التحقيق، حماية البيانات، والامتثال للأنظمة', 2, 44, 44, NULL, NULL, 'policy', 'approved', 'LCM009', NULL, NULL, NULL, 'documents/1767865044_214_Anti_fraud_policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Anti_fraud_policy.pdf\",\"new_name\":\"1767865044_214_Anti_fraud_policy.pdf\"}]', '2026-01-08 06:37:00', '2026-01-08 09:08:00'),
(458, 'DOC-20260429-9876', 'نموذج الانضمام الوظيفي', 'القائمة المتبعة لتهيئة الموظف خلال الثلاث الأشهر الأولى من عمله', 2, 54, 54, NULL, NULL, 'form', 'approved', 'QDMFRM145', NULL, NULL, NULL, 'documents/1768382451_242_New_Employee_Onboarding__Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"New_Employee_Onboarding__Form.pdf\",\"new_name\":\"1768382451_242_New_Employee_Onboarding__Form.pdf\"}]', '2026-01-14 06:21:00', '2026-01-14 06:21:00'),
(459, 'DOC-20260429-8494', 'إجراءات الإدارة الفنية', NULL, 2, 44, 44, NULL, NULL, 'procedure', 'approved', 'v2.0', NULL, NULL, NULL, 'documents/1768989040_214_technical_procedures.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"technical_procedures.pdf\",\"new_name\":\"1768989040_214_technical_procedures.pdf\"}]', '2026-01-21 06:51:00', '2026-01-21 06:51:00'),
(460, 'DOC-20260429-6380', 'سياسة إنهاء خدمات الموظفين', 'إجراءات إنهاء الخدمة بأنواعه، بما في ذلك الاستقالة، عدم التجديد، الفصل التأديبي، والمخالصة، مع ضمان الشفافية، الحقوق النظامية، وحق الاعت...', 2, 54, 54, NULL, NULL, 'policy', 'approved', '1HRM0012', NULL, NULL, NULL, 'documents/1769500117_242__________________________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"_________________________________________________.pdf\",\"new_name\":\"1769500117_242__________________________________________________.pdf\"}]', '2026-01-27 04:48:00', '2026-01-27 04:48:00'),
(461, 'DOC-20260429-6947', 'سياسة استخدام البريد الإلكتروني والإنترنت', 'إنشاء الحسابات، مراجعة الصلاحيات، تطبيق مبدأ \"أقل صلاحية\"، وتفعيل المصادقة متعددة العوامل، مع توثيق الوصول والتدريب لضمان الأمان والامتثا...', 1, 54, 54, NULL, NULL, 'procedure', 'approved', '1ITM0013', NULL, NULL, NULL, 'documents/1769502233_242_Email___Internet_Use_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Email___Internet_Use_Policy.pdf\",\"new_name\":\"1769502233_242_Email___Internet_Use_Policy.pdf\"}]', '2026-04-29 09:44:26', '2026-04-29 09:44:26'),
(462, 'DOC-20260429-5811', 'إجراءات إدارة الموارد البشرية', NULL, 2, 54, 54, NULL, NULL, 'procedure', 'draft', '1.0', NULL, NULL, NULL, 'documents/1769505178_242_Human_Resources_Procedure.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Human_Resources_Procedure.pdf\",\"new_name\":\"1769505178_242_Human_Resources_Procedure.pdf\"}]', '2026-01-27 06:12:00', '2026-01-28 04:23:00'),
(463, 'DOC-20260429-6161', 'إجراءات إدارة الموارد البشرية', NULL, 2, 54, 54, NULL, NULL, 'procedure', 'approved', '1.0', NULL, NULL, NULL, 'documents/1769595417_242_Human_Resources_Procedures.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Human_Resources_Procedures.pdf\",\"new_name\":\"1769595417_242_Human_Resources_Procedures.pdf\"}]', '2026-01-28 07:16:00', '2026-01-28 07:16:00'),
(464, 'DOC-20260429-7340', 'نموذج تسليم المهام', 'توثيق عملية تسليم المهام والمسؤوليات بين الموظفين، بما يضمن وضوح الحالة التشغيلية، نقل المعرفة، واستمرارية الأعمال وفق الضوابط المعتمدة.', 2, 44, 44, NULL, NULL, 'form', 'approved', '1.0', NULL, NULL, NULL, 'documents/1771156460_214_Handover_certificate_Diamond.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Handover_certificate_Diamond.xlsx\",\"new_name\":\"1771156460_214_Handover_certificate_Diamond.xlsx\"}]', '2026-02-15 08:56:00', '2026-02-15 08:56:00'),
(465, 'DOC-20260429-8995', 'سياسة التوظيف', 'جميع مراحل التوظيف من الإعلان وحتى التعيين، مع ضمان الامتثال لمعايير العدالة، السعودة، التنوع، والتحقق المهني، لضمان استقطاب الكفاءات بك...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2HRM0007', NULL, NULL, NULL, 'documents/1774526235_214_Hiring_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Hiring_Policy.pdf\",\"new_name\":\"1774526235_214_Hiring_Policy.pdf\"}]', '2026-03-26 08:59:00', '2026-03-26 08:59:00'),
(466, 'DOC-20260429-8533', 'سياسة إدارة السجلات المالية والأرشفة', 'تلتزم الإدارة المالية بإنشاء وتصنيف السجلات المالية بدقة، مع التحكم في التعديلات، والاحتفاظ بها لفترات محددة، وحفظها إلكترونيًا وورقيًا،...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2FM0021', NULL, NULL, NULL, 'documents/1774934654_214_Financial_Records_and_Archiving_Management_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Financial_Records_and_Archiving_Management_Policy.pdf\",\"new_name\":\"1774934654_214_Financial_Records_and_Archiving_Management_Policy.pdf\"}]', '2026-03-31 02:24:00', '2026-03-31 02:24:00'),
(467, 'DOC-20260429-8950', 'سياسة المحاسبة', 'الالتزام بمعايير المحاسبة، التسجيل الدقيق، التسويات اليومية، والرقابة الداخلية، بدعم تقني وتنظيمي شامل', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2FM0004', NULL, NULL, NULL, 'documents/1774934944_214_Accounting_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Accounting_Policy.pdf\",\"new_name\":\"1774934944_214_Accounting_Policy.pdf\"}]', '2026-03-31 02:29:00', '2026-03-31 02:29:00'),
(468, 'DOC-20260429-3336', 'سياسة تخطيط الموازنة', 'منهجية محكمة لإعداد وتنفيذ ومتابعة الميزانية السنوية وفق ضوابط تنظيمية وتعاون بين الإدارات', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2FM0002', NULL, NULL, NULL, 'documents/1774935145_214_Budget_Planning_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Budget_Planning_Policy.pdf\",\"new_name\":\"1774935145_214_Budget_Planning_Policy.pdf\"}]', '2026-03-31 02:33:00', '2026-03-31 02:33:00'),
(469, 'DOC-20260429-8150', 'سياسة الإنفاق الرأسمالي', 'تقديم طلبات الإنفاق الرأسمالي، تقييم الأصول، سياسة الإهلاك، المراجعة الدورية، وتنظيم التخلص من الأصول وفق الصلاحيات المعتمدة.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2FM0009', NULL, NULL, NULL, 'documents/1774935589_214_Capital_Expenditure_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Capital_Expenditure_Policy.pdf\",\"new_name\":\"1774935589_214_Capital_Expenditure_Policy.pdf\"}]', '2026-03-31 02:39:00', '2026-03-31 02:39:00'),
(470, 'DOC-20260429-4142', 'سياسة التحصيل وأعمار الديون', 'طرق فعّالة لتسجيل، تصنيف، وتحصيل مستحقات العملاء، بما في ذلك خطة تحصيل دورية، تصعيد الحالات، والتعامل مع الديون المشكوك في تحصيلها، مع ضما...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2FM0019', NULL, NULL, NULL, 'documents/1774935948_214_Collections_and_Aging_of_Receivables_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Collections_and_Aging_of_Receivables_Policy.pdf\",\"new_name\":\"1774935948_214_Collections_and_Aging_of_Receivables_Policy.pdf\"}]', '2026-03-31 02:46:00', '2026-03-31 02:46:00'),
(471, 'DOC-20260429-2651', 'سياسة التسويات المحاسبية', 'التسويات المحاسبية تتم بشكل دوري مع توثيق الفروقات وحفظ السجلات لمدة 10 سنوات، وتشمل جميع الجهات المالية مع إجراءات تصحيحية عند وجود أي فرو...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2FM0015', NULL, NULL, NULL, 'documents/1774936242_214_Accounting_Adjustments_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Accounting_Adjustments_Policy.pdf\",\"new_name\":\"1774936242_214_Accounting_Adjustments_Policy.pdf\"}]', '2026-03-31 02:50:00', '2026-03-31 02:50:00'),
(472, 'DOC-20260429-3557', 'سياسة التحكم في الائتمان', 'تقييم العملاء الائتماني، تحديد الحدود، متابعة الذمم المدينة، والتعامل مع التعثر، مع توثيق الموافقات وإعداد تقارير دورية، مع الالتزام بال...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2FM0013', NULL, NULL, NULL, 'documents/1774936470_214_Internal_Control_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Internal_Control_Policy.pdf\",\"new_name\":\"1774936470_214_Internal_Control_Policy.pdf\"}]', '2026-03-31 02:54:00', '2026-03-31 02:54:00'),
(473, 'DOC-20260429-1631', 'سياسة الاستثمارات', 'شروط وضوابط الاستثمارات تشمل الامتثال للتنظيمات والشريعة، تحديد المخاطر، موافقات الإدارة، تنوع المحفظة، وتقارير دورية لمراقبة الأداء', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2FM0010', NULL, NULL, NULL, 'documents/1774936584_214_Investments_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Investments_Policy.pdf\",\"new_name\":\"1774936584_214_Investments_Policy.pdf\"}]', '2026-03-31 02:56:00', '2026-03-31 02:56:00'),
(474, 'DOC-20260429-1838', 'سياسة العُهدة النثرية', 'تنظم منح واستخدام العهد النثرية المؤقتة والدائمة، بما في ذلك تحديد قيمتها وفقًا للمهام، وضمان استخدامها لأغراض محددة، مع الالتزام بالرقاب...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2FM0008', NULL, NULL, NULL, 'documents/1774936714_214_Petty_Cash_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Petty_Cash_Policy.pdf\",\"new_name\":\"1774936714_214_Petty_Cash_Policy.pdf\"}]', '2026-03-31 02:58:00', '2026-03-31 02:58:00'),
(475, 'DOC-20260429-1316', 'سياسة فصل المهام المالية', 'الالتزام بفصل المهام بين الموظفين لضمان النزاهة والشفافية، مع مراجعة دورية للصلاحيات وتنفيذ إجراءات تصعيدية في حال وجود مخالفات، والتأكد ...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2FM0020', NULL, NULL, NULL, 'documents/1774936897_214_Segregation_of_Financial_Duties_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Segregation_of_Financial_Duties_Policy.pdf\",\"new_name\":\"1774936897_214_Segregation_of_Financial_Duties_Policy.pdf\"}]', '2026-03-31 03:01:00', '2026-03-31 03:01:00'),
(476, 'DOC-20260429-3745', 'سياسة الإبلاغ عن الخسائر التشغيلية', 'الإبلاغ الفوري عن الخسائر التشغيلية، تحديد الإجراءات التصحيحية، تحليل الأسباب، وتقرير ربع سنوي للمخاطر مع متابعة التنفيذ من قبل الإدارة ا...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2FM0014', NULL, NULL, NULL, 'documents/1774937010_214_Loss_Reporting_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Loss_Reporting_Policy.pdf\",\"new_name\":\"1774937010_214_Loss_Reporting_Policy.pdf\"}]', '2026-03-31 03:03:00', '2026-03-31 03:03:00'),
(477, 'DOC-20260429-6888', 'نموذج إبلاغ عن خسارة تشغيلية', 'توثيق الخسائر التشغيلية لتحليل أسبابها واتخاذ الإجراءات التصحيحية', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM1', NULL, NULL, NULL, 'documents/1774937054_214_Operational_Loss_Reporting_Form.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Operational_Loss_Reporting_Form.pdf\",\"new_name\":\"1774937054_214_Operational_Loss_Reporting_Form.pdf\"}]', '2026-03-31 03:09:00', '2026-03-31 03:09:00'),
(478, 'DOC-20260429-4474', 'سياسة إدارة الأصول الثابتة', 'تنظيم وإدارة الأصول الثابتة المملوكة للشركة بطريقة حوكمية تضمن الحفاظ عليها، وضبط دورة حياتها، وتعزيز كفاءة استخدامها، وحماية حقوق الشرك...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1FM0024', NULL, NULL, NULL, 'documents/1774938401_214_Fixed_Assets_Management_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Fixed_Assets_Management_Policy.pdf\",\"new_name\":\"1774938401_214_Fixed_Assets_Management_Policy.pdf\"}]', '2026-03-31 03:31:00', '2026-03-31 03:31:00'),
(479, 'DOC-20260429-3147', 'سجل الأصول الثابتة الرئيسي', 'سجل الأصول الثابتة هو سجل يُستخدم لتوثيق وتتبع أصول المنشأة، ويشمل بيانات مثل رقم ووصف الأصل، فئته، موقعه، المستخدم، تكلفة وتاريخ الشراء، ...', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM155', NULL, NULL, NULL, 'documents/1774939625_214_Master_Asset_Register.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Master_Asset_Register.xlsx\",\"new_name\":\"1774939625_214_Master_Asset_Register.xlsx\"}]', '2026-03-31 03:50:00', '2026-03-31 03:50:00'),
(480, 'DOC-20260429-2903', 'سجل الجرد', 'أداة لمراجعة الأصول فعليًا ومقارنتها مع السجلات، ويشمل تاريخ الجرد، رقم ووصف الأصل، فئته، حالته الفعلية، مدى التطابق، ملاحظات الفروقات، ...', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM156', NULL, NULL, NULL, 'documents/1774939862_214_Inventory_Register.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Inventory_Register.xlsx\",\"new_name\":\"1774939862_214_Inventory_Register.xlsx\"}]', '2026-03-31 03:53:00', '2026-03-31 03:53:00'),
(481, 'DOC-20260429-7407', 'سجل عمليات الأصول (الصيانة – التخزين – الاستبعاد)', 'سجل يُستخدم لتوثيق جميع العمليات على الأصول، مثل الصيانة والتخزين والاستبعاد، ويشمل رقم العملية والأصل، نوع ووصف العملية، سببها، حالتها، ...', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM157', NULL, NULL, NULL, 'documents/1774940028_214_Asset_Operations_Log__Maintenance_____Storage_____Disposal_.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Asset_Operations_Log__Maintenance_____Storage_____Disposal_.xlsx\",\"new_name\":\"1774940028_214_Asset_Operations_Log__Maintenance_____Storage_____Disposal_.xlsx\"}]', '2026-03-31 03:56:00', '2026-03-31 03:56:00'),
(482, 'DOC-20260429-1807', 'سجل التلف أو الفقد', 'سجل يُستخدم لتوثيق حالات تلف أو فقد الأصول، ويشمل رقم البلاغ ورقم الأصل، نوع الحالة، اسم المبلّغ، تواريخ البلاغ والتحقيق، نتائج التحقيق، ا...', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM158', NULL, NULL, NULL, 'documents/1774940200_214_Damage___Loss_Register.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Damage___Loss_Register.xlsx\",\"new_name\":\"1774940200_214_Damage___Loss_Register.xlsx\"}]', '2026-03-31 03:58:00', '2026-03-31 03:58:00'),
(483, 'DOC-20260429-4330', 'سياسة إدارة ومتابعة الأرصدة المدينة المتقادمة', 'ضبط الانضباط المالي داخل الشركة، لما لها من أثر مباشر على سلامة التدفقات النقدية، واستدامة السيولة، واستقرار المراكز المالية، وحماية حقو...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '1FM0025', NULL, NULL, NULL, 'documents/1774940711_214_Policy_for_Managing_and_Monitoring_Aged_Receivables.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Policy_for_Managing_and_Monitoring_Aged_Receivables.pdf\",\"new_name\":\"1774940711_214_Policy_for_Managing_and_Monitoring_Aged_Receivables.pdf\"}]', '2026-03-31 04:05:00', '2026-03-31 04:05:00'),
(484, 'DOC-20260429-6130', 'نموذج متابعة الأرصدة المدينة المتقادمة', 'نموذج متابعة الأرصدة المدينة المتقادمة هو أداة لتتبع الديون المستحقة للعملاء، ويشمل رقم واسم العميل، رقم وتاريخ الفاتورة، تاريخ الاستحقا...', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM160', NULL, NULL, NULL, 'documents/1774940976_214_Aged_Receivables_Tracking_Form.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Aged_Receivables_Tracking_Form.xlsx\",\"new_name\":\"1774940976_214_Aged_Receivables_Tracking_Form.xlsx\"}]', '2026-03-31 04:11:00', '2026-03-31 04:11:00'),
(485, 'DOC-20260429-1455', 'نموذج تحليل الانحراف بين الإيرادات الفعلية والمقدّرة', 'سجل إدارة المخاطر هو أداة لتتبع وتحليل المخاطر المالية، ويشمل رقم الخطر والفترة المالية، الإيراد المقدّر والفعلي، الانحراف وقيمته ونسبته...', 2, 44, 44, NULL, NULL, 'form', 'approved', '1QDMFRM159', NULL, NULL, NULL, 'documents/1774941426_214.xlsx', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"____________________________________________________________________________________________________.xlsx\",\"new_name\":\"1774941426_214.xlsx\"}]', '2026-03-31 04:17:00', '2026-03-31 04:17:00'),
(486, 'DOC-20260429-6601', 'سياسة الإجازات', 'أنواع الإجازات المستحقة للموظفين وشروطها، بما يشمل الإجازات السنوية، المرضية، الرسمية، والحالات الخاصة، لضمان التوازن بين متطلبات العمل ...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2HRM0009', NULL, NULL, NULL, 'documents/1774945876_214_Leave_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Leave_Policy.pdf\",\"new_name\":\"1774945876_214_Leave_Policy.pdf\"}]', '2026-03-31 05:31:00', '2026-03-31 05:31:00'),
(487, 'DOC-20260429-1886', 'سياسة القروض', 'شروط وضوابط منح القروض السكنية والشخصية للموظفين، وآلية السداد، والضمانات، بما يضمن العدالة والامتثال المالي وتقليل المخاطر', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2HRM0005', NULL, NULL, NULL, 'documents/1774949602_214_Loan_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Loan_Policy.pdf\",\"new_name\":\"1774949602_214_Loan_Policy.pdf\"}]', '2026-03-31 06:34:00', '2026-03-31 06:34:00'),
(488, 'DOC-20260429-5242', 'نموذج التحقق من شكوى', 'للتحقق من شكاوى الموظفين', 2, 54, 54, NULL, NULL, 'form', 'approved', 'QDMFRM16', NULL, NULL, NULL, 'documents/1775464323_242______________________________________.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"_____________________________________.pdf\",\"new_name\":\"1775464323_242______________________________________.pdf\"}]', '2026-04-06 05:32:00', '2026-04-06 05:32:00'),
(489, 'DOC-20260429-1621', 'سياسة التوظيف', 'جميع مراحل التوظيف من الإعلان وحتى التعيين، مع ضمان الامتثال لمعايير العدالة، السعودة، التنوع، والتحقق المهني، لضمان استقطاب الكفاءات بك...', 2, 44, 44, NULL, NULL, 'policy', 'approved', '3HRM0007', NULL, NULL, NULL, 'documents/1776688644_214_Hiring_policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Hiring_policy.pdf\",\"new_name\":\"1776688644_214_Hiring_policy.pdf\"}]', '2026-04-20 09:37:00', '2026-04-20 09:37:00'),
(490, 'DOC-20260429-6374', 'سياسة صرف العمولات', 'النسبة المحددة لموظفي المبيعات حسب نوع التأمين، مع آلية صرف مرتبطة بتحصيل الأقساط، وتخضع للتعديل حسب مصلحة الشركة.', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2FM00.17', NULL, NULL, NULL, 'documents/1776941426_214_Commission_Disbursement.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Commission_Disbursement.pdf\",\"new_name\":\"1776941426_214_Commission_Disbursement.pdf\"}]', '2026-04-23 07:50:00', '2026-04-23 07:50:00'),
(491, 'DOC-20260429-4865', 'سياسة الحضور والإنصراف', 'ضوابط الحضور والانصراف،التأخيرات، والاستئذانات لضمان الانضباط الوظيفي، وتحدد آلية التعامل مع المخالفات والخصومات وفق اللوائح المعتمدة', 2, 44, 44, NULL, NULL, 'policy', 'approved', '2HRM0001', NULL, NULL, NULL, 'documents/1776952037_214_Attendance_and_Punctuality_Policy.pdf', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '[{\"original_name\":\"Attendance_and_Punctuality_Policy.pdf\",\"new_name\":\"1776952037_214_Attendance_and_Punctuality_Policy.pdf\"}]', '2026-04-23 10:47:00', '2026-04-23 10:47:00');

-- --------------------------------------------------------

--
-- Table structure for table `document_access_log`
--

CREATE TABLE `document_access_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `document_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `action` enum('view','download','print','share') NOT NULL DEFAULT 'view',
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `document_access_logs`
--

CREATE TABLE `document_access_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `document_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `action` varchar(255) NOT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `document_access_logs`
--

INSERT INTO `document_access_logs` (`id`, `document_id`, `user_id`, `action`, `ip_address`, `created_at`, `updated_at`) VALUES
(55, 489, 10, 'view', '::1', '2026-04-29 09:45:32', '2026-04-29 09:45:32'),
(56, 465, 10, 'view', '::1', '2026-04-29 09:45:44', '2026-04-29 09:45:44'),
(57, 460, 10, 'view', '::1', '2026-04-29 09:47:41', '2026-04-29 09:47:41'),
(58, 458, 10, 'download', '::1', '2026-04-29 09:47:59', '2026-04-29 09:47:59'),
(59, 342, 17, 'view', '::1', '2026-04-29 09:57:27', '2026-04-29 09:57:27'),
(60, 489, 26, 'view', '::1', '2026-04-29 10:07:18', '2026-04-29 10:07:18'),
(61, 463, 10, 'view', '::1', '2026-04-29 11:00:55', '2026-04-29 11:00:55'),
(62, 491, 18, 'view', '192.168.100.189', '2026-05-03 09:33:01', '2026-05-03 09:33:01'),
(63, 491, 39, 'view', '192.168.100.136', '2026-05-04 07:25:50', '2026-05-04 07:25:50');

-- --------------------------------------------------------

--
-- Table structure for table `document_categories`
--

CREATE TABLE `document_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `code` varchar(20) NOT NULL,
  `parent_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `document_categories`
--

INSERT INTO `document_categories` (`id`, `name`, `code`, `parent_id`) VALUES
(1, 'Policy', 'POL', NULL),
(2, 'Procedures', 'PRO', NULL),
(3, 'Work Instructions', 'WI', NULL),
(4, 'Form', 'FT', NULL),
(5, 'Manuals', 'MAN', NULL),
(6, 'Reports', 'RPT', NULL),
(7, 'Contracts', 'CON', NULL),
(22, 'Announcement', 'AN', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `document_departments`
--

CREATE TABLE `document_departments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `document_id` bigint(20) UNSIGNED NOT NULL,
  `department_id` bigint(20) UNSIGNED NOT NULL,
  `distributed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `document_departments`
--

INSERT INTO `document_departments` (`id`, `document_id`, `department_id`, `distributed_at`) VALUES
(77, 1, 3, '2026-04-29 09:44:25'),
(78, 2, 3, '2026-04-29 09:44:25'),
(79, 3, 1, '2026-04-29 09:44:25'),
(80, 4, 3, '2026-04-29 09:44:25'),
(81, 5, 9, '2026-04-29 09:44:25'),
(82, 6, 9, '2026-04-29 09:44:25'),
(83, 7, 9, '2026-04-29 09:44:25'),
(84, 8, 9, '2026-04-29 09:44:25'),
(85, 9, 9, '2026-04-29 09:44:25'),
(86, 10, 9, '2026-04-29 09:44:25'),
(87, 11, 9, '2026-04-29 09:44:25'),
(88, 12, 9, '2026-04-29 09:44:25'),
(89, 13, 9, '2026-04-29 09:44:25'),
(90, 14, 9, '2026-04-29 09:44:25'),
(91, 15, 9, '2026-04-29 09:44:25'),
(92, 16, 9, '2026-04-29 09:44:25'),
(93, 17, 9, '2026-04-29 09:44:25'),
(94, 18, 9, '2026-04-29 09:44:25'),
(95, 19, 9, '2026-04-29 09:44:25'),
(96, 20, 9, '2026-04-29 09:44:25'),
(97, 21, 9, '2026-04-29 09:44:25'),
(98, 22, 9, '2026-04-29 09:44:25'),
(99, 23, 7, '2026-04-29 09:44:25'),
(100, 24, 7, '2026-04-29 09:44:25'),
(101, 25, 7, '2026-04-29 09:44:25'),
(102, 26, 7, '2026-04-29 09:44:25'),
(103, 27, 7, '2026-04-29 09:44:25'),
(104, 28, 7, '2026-04-29 09:44:25'),
(105, 29, 7, '2026-04-29 09:44:25'),
(106, 30, 7, '2026-04-29 09:44:25'),
(107, 31, 7, '2026-04-29 09:44:25'),
(108, 32, 7, '2026-04-29 09:44:25'),
(109, 33, 7, '2026-04-29 09:44:25'),
(110, 34, 7, '2026-04-29 09:44:25'),
(111, 35, 1, '2026-04-29 09:44:25'),
(112, 35, 2, '2026-04-29 09:44:25'),
(113, 35, 3, '2026-04-29 09:44:25'),
(114, 35, 4, '2026-04-29 09:44:25'),
(115, 35, 5, '2026-04-29 09:44:25'),
(116, 35, 6, '2026-04-29 09:44:25'),
(117, 35, 7, '2026-04-29 09:44:25'),
(118, 35, 8, '2026-04-29 09:44:25'),
(119, 35, 9, '2026-04-29 09:44:25'),
(120, 35, 10, '2026-04-29 09:44:25'),
(121, 36, 1, '2026-04-29 09:44:25'),
(122, 36, 2, '2026-04-29 09:44:25'),
(123, 36, 3, '2026-04-29 09:44:25'),
(124, 36, 4, '2026-04-29 09:44:25'),
(125, 36, 5, '2026-04-29 09:44:25'),
(126, 36, 6, '2026-04-29 09:44:25'),
(127, 36, 7, '2026-04-29 09:44:25'),
(128, 36, 8, '2026-04-29 09:44:25'),
(129, 36, 9, '2026-04-29 09:44:25'),
(130, 36, 10, '2026-04-29 09:44:25'),
(131, 37, 1, '2026-04-29 09:44:25'),
(132, 37, 2, '2026-04-29 09:44:25'),
(133, 37, 3, '2026-04-29 09:44:25'),
(134, 37, 4, '2026-04-29 09:44:25'),
(135, 37, 5, '2026-04-29 09:44:25'),
(136, 37, 6, '2026-04-29 09:44:25'),
(137, 37, 7, '2026-04-29 09:44:25'),
(138, 37, 8, '2026-04-29 09:44:25'),
(139, 37, 9, '2026-04-29 09:44:25'),
(140, 37, 10, '2026-04-29 09:44:25'),
(141, 38, 1, '2026-04-29 09:44:25'),
(142, 38, 2, '2026-04-29 09:44:25'),
(143, 38, 3, '2026-04-29 09:44:25'),
(144, 38, 4, '2026-04-29 09:44:25'),
(145, 38, 5, '2026-04-29 09:44:25'),
(146, 38, 6, '2026-04-29 09:44:25'),
(147, 38, 7, '2026-04-29 09:44:25'),
(148, 38, 8, '2026-04-29 09:44:25'),
(149, 38, 9, '2026-04-29 09:44:25'),
(150, 38, 10, '2026-04-29 09:44:25'),
(151, 39, 1, '2026-04-29 09:44:25'),
(152, 39, 2, '2026-04-29 09:44:25'),
(153, 39, 3, '2026-04-29 09:44:25'),
(154, 39, 4, '2026-04-29 09:44:25'),
(155, 39, 5, '2026-04-29 09:44:25'),
(156, 39, 6, '2026-04-29 09:44:25'),
(157, 39, 7, '2026-04-29 09:44:25'),
(158, 39, 8, '2026-04-29 09:44:25'),
(159, 39, 9, '2026-04-29 09:44:25'),
(160, 39, 10, '2026-04-29 09:44:25'),
(161, 40, 1, '2026-04-29 09:44:25'),
(162, 40, 2, '2026-04-29 09:44:25'),
(163, 40, 3, '2026-04-29 09:44:25'),
(164, 40, 4, '2026-04-29 09:44:25'),
(165, 40, 5, '2026-04-29 09:44:25'),
(166, 40, 6, '2026-04-29 09:44:25'),
(167, 40, 7, '2026-04-29 09:44:25'),
(168, 40, 8, '2026-04-29 09:44:25'),
(169, 40, 9, '2026-04-29 09:44:25'),
(170, 40, 10, '2026-04-29 09:44:25'),
(171, 41, 1, '2026-04-29 09:44:25'),
(172, 41, 2, '2026-04-29 09:44:25'),
(173, 41, 3, '2026-04-29 09:44:25'),
(174, 41, 4, '2026-04-29 09:44:25'),
(175, 41, 5, '2026-04-29 09:44:25'),
(176, 41, 6, '2026-04-29 09:44:25'),
(177, 41, 7, '2026-04-29 09:44:25'),
(178, 41, 8, '2026-04-29 09:44:25'),
(179, 41, 9, '2026-04-29 09:44:25'),
(180, 41, 10, '2026-04-29 09:44:25'),
(181, 42, 1, '2026-04-29 09:44:25'),
(182, 42, 2, '2026-04-29 09:44:25'),
(183, 42, 3, '2026-04-29 09:44:25'),
(184, 42, 4, '2026-04-29 09:44:25'),
(185, 42, 5, '2026-04-29 09:44:25'),
(186, 42, 6, '2026-04-29 09:44:25'),
(187, 42, 7, '2026-04-29 09:44:25'),
(188, 42, 8, '2026-04-29 09:44:25'),
(189, 42, 9, '2026-04-29 09:44:25'),
(190, 42, 10, '2026-04-29 09:44:25'),
(191, 43, 1, '2026-04-29 09:44:25'),
(192, 43, 2, '2026-04-29 09:44:25'),
(193, 43, 3, '2026-04-29 09:44:25'),
(194, 43, 4, '2026-04-29 09:44:25'),
(195, 43, 5, '2026-04-29 09:44:25'),
(196, 43, 6, '2026-04-29 09:44:25'),
(197, 43, 7, '2026-04-29 09:44:25'),
(198, 43, 8, '2026-04-29 09:44:25'),
(199, 43, 9, '2026-04-29 09:44:25'),
(200, 43, 10, '2026-04-29 09:44:25'),
(201, 44, 1, '2026-04-29 09:44:25'),
(202, 44, 2, '2026-04-29 09:44:25'),
(203, 44, 3, '2026-04-29 09:44:25'),
(204, 44, 4, '2026-04-29 09:44:25'),
(205, 44, 5, '2026-04-29 09:44:25'),
(206, 44, 6, '2026-04-29 09:44:25'),
(207, 44, 7, '2026-04-29 09:44:25'),
(208, 44, 8, '2026-04-29 09:44:25'),
(209, 44, 9, '2026-04-29 09:44:25'),
(210, 44, 10, '2026-04-29 09:44:25'),
(211, 45, 1, '2026-04-29 09:44:25'),
(212, 45, 2, '2026-04-29 09:44:25'),
(213, 45, 3, '2026-04-29 09:44:25'),
(214, 45, 4, '2026-04-29 09:44:25'),
(215, 45, 5, '2026-04-29 09:44:25'),
(216, 45, 6, '2026-04-29 09:44:25'),
(217, 45, 7, '2026-04-29 09:44:25'),
(218, 45, 8, '2026-04-29 09:44:25'),
(219, 45, 9, '2026-04-29 09:44:25'),
(220, 45, 10, '2026-04-29 09:44:25'),
(221, 46, 1, '2026-04-29 09:44:25'),
(222, 46, 2, '2026-04-29 09:44:25'),
(223, 46, 3, '2026-04-29 09:44:25'),
(224, 46, 4, '2026-04-29 09:44:25'),
(225, 46, 5, '2026-04-29 09:44:25'),
(226, 46, 6, '2026-04-29 09:44:25'),
(227, 46, 7, '2026-04-29 09:44:25'),
(228, 46, 8, '2026-04-29 09:44:25'),
(229, 46, 9, '2026-04-29 09:44:25'),
(230, 46, 10, '2026-04-29 09:44:25'),
(231, 47, 1, '2026-04-29 09:44:25'),
(232, 47, 2, '2026-04-29 09:44:25'),
(233, 47, 3, '2026-04-29 09:44:25'),
(234, 47, 4, '2026-04-29 09:44:25'),
(235, 47, 5, '2026-04-29 09:44:25'),
(236, 47, 6, '2026-04-29 09:44:25'),
(237, 47, 7, '2026-04-29 09:44:25'),
(238, 47, 8, '2026-04-29 09:44:25'),
(239, 47, 9, '2026-04-29 09:44:25'),
(240, 47, 10, '2026-04-29 09:44:25'),
(241, 48, 4, '2026-04-29 09:44:25'),
(242, 49, 4, '2026-04-29 09:44:25'),
(243, 50, 4, '2026-04-29 09:44:25'),
(244, 51, 4, '2026-04-29 09:44:25'),
(245, 52, 4, '2026-04-29 09:44:25'),
(246, 53, 4, '2026-04-29 09:44:25'),
(247, 54, 4, '2026-04-29 09:44:25'),
(248, 55, 4, '2026-04-29 09:44:25'),
(249, 56, 4, '2026-04-29 09:44:25'),
(250, 57, 4, '2026-04-29 09:44:25'),
(251, 58, 4, '2026-04-29 09:44:25'),
(252, 59, 4, '2026-04-29 09:44:25'),
(253, 60, 4, '2026-04-29 09:44:25'),
(254, 61, 4, '2026-04-29 09:44:25'),
(255, 62, 4, '2026-04-29 09:44:25'),
(256, 63, 4, '2026-04-29 09:44:25'),
(257, 64, 4, '2026-04-29 09:44:25'),
(258, 65, 4, '2026-04-29 09:44:25'),
(259, 66, 4, '2026-04-29 09:44:25'),
(260, 67, 4, '2026-04-29 09:44:25'),
(261, 68, 4, '2026-04-29 09:44:25'),
(262, 69, 4, '2026-04-29 09:44:25'),
(263, 70, 4, '2026-04-29 09:44:25'),
(264, 71, 4, '2026-04-29 09:44:25'),
(265, 72, 4, '2026-04-29 09:44:25'),
(266, 73, 4, '2026-04-29 09:44:25'),
(267, 74, 4, '2026-04-29 09:44:25'),
(268, 75, 9, '2026-04-29 09:44:25'),
(269, 76, 7, '2026-04-29 09:44:25'),
(270, 77, 7, '2026-04-29 09:44:25'),
(271, 78, 7, '2026-04-29 09:44:25'),
(272, 79, 1, '2026-04-29 09:44:25'),
(273, 79, 2, '2026-04-29 09:44:25'),
(274, 79, 3, '2026-04-29 09:44:25'),
(275, 79, 4, '2026-04-29 09:44:25'),
(276, 79, 5, '2026-04-29 09:44:25'),
(277, 79, 6, '2026-04-29 09:44:25'),
(278, 79, 7, '2026-04-29 09:44:25'),
(279, 79, 8, '2026-04-29 09:44:25'),
(280, 79, 9, '2026-04-29 09:44:25'),
(281, 79, 10, '2026-04-29 09:44:25'),
(282, 80, 1, '2026-04-29 09:44:25'),
(283, 80, 2, '2026-04-29 09:44:25'),
(284, 80, 3, '2026-04-29 09:44:25'),
(285, 80, 4, '2026-04-29 09:44:25'),
(286, 80, 5, '2026-04-29 09:44:25'),
(287, 80, 6, '2026-04-29 09:44:25'),
(288, 80, 7, '2026-04-29 09:44:25'),
(289, 80, 8, '2026-04-29 09:44:25'),
(290, 80, 9, '2026-04-29 09:44:25'),
(291, 80, 10, '2026-04-29 09:44:25'),
(292, 81, 1, '2026-04-29 09:44:25'),
(293, 81, 2, '2026-04-29 09:44:25'),
(294, 81, 3, '2026-04-29 09:44:25'),
(295, 81, 4, '2026-04-29 09:44:25'),
(296, 81, 5, '2026-04-29 09:44:25'),
(297, 81, 6, '2026-04-29 09:44:25'),
(298, 81, 7, '2026-04-29 09:44:25'),
(299, 81, 8, '2026-04-29 09:44:25'),
(300, 81, 9, '2026-04-29 09:44:25'),
(301, 81, 10, '2026-04-29 09:44:25'),
(302, 82, 1, '2026-04-29 09:44:25'),
(303, 82, 2, '2026-04-29 09:44:25'),
(304, 82, 3, '2026-04-29 09:44:25'),
(305, 82, 4, '2026-04-29 09:44:25'),
(306, 82, 5, '2026-04-29 09:44:25'),
(307, 82, 6, '2026-04-29 09:44:25'),
(308, 82, 7, '2026-04-29 09:44:25'),
(309, 82, 8, '2026-04-29 09:44:25'),
(310, 82, 9, '2026-04-29 09:44:25'),
(311, 82, 10, '2026-04-29 09:44:25'),
(312, 83, 1, '2026-04-29 09:44:25'),
(313, 83, 2, '2026-04-29 09:44:25'),
(314, 83, 3, '2026-04-29 09:44:25'),
(315, 83, 4, '2026-04-29 09:44:25'),
(316, 83, 5, '2026-04-29 09:44:25'),
(317, 83, 6, '2026-04-29 09:44:25'),
(318, 83, 7, '2026-04-29 09:44:25'),
(319, 83, 8, '2026-04-29 09:44:25'),
(320, 83, 9, '2026-04-29 09:44:25'),
(321, 83, 10, '2026-04-29 09:44:25'),
(322, 84, 1, '2026-04-29 09:44:25'),
(323, 84, 2, '2026-04-29 09:44:25'),
(324, 84, 3, '2026-04-29 09:44:25'),
(325, 84, 4, '2026-04-29 09:44:25'),
(326, 84, 5, '2026-04-29 09:44:25'),
(327, 84, 6, '2026-04-29 09:44:25'),
(328, 84, 7, '2026-04-29 09:44:25'),
(329, 84, 8, '2026-04-29 09:44:25'),
(330, 84, 9, '2026-04-29 09:44:25'),
(331, 84, 10, '2026-04-29 09:44:25'),
(332, 85, 1, '2026-04-29 09:44:25'),
(333, 85, 2, '2026-04-29 09:44:25'),
(334, 85, 3, '2026-04-29 09:44:25'),
(335, 85, 4, '2026-04-29 09:44:25'),
(336, 85, 5, '2026-04-29 09:44:25'),
(337, 85, 6, '2026-04-29 09:44:25'),
(338, 85, 7, '2026-04-29 09:44:25'),
(339, 85, 8, '2026-04-29 09:44:25'),
(340, 85, 9, '2026-04-29 09:44:25'),
(341, 85, 10, '2026-04-29 09:44:25'),
(342, 86, 1, '2026-04-29 09:44:25'),
(343, 86, 2, '2026-04-29 09:44:25'),
(344, 86, 3, '2026-04-29 09:44:25'),
(345, 86, 4, '2026-04-29 09:44:25'),
(346, 86, 5, '2026-04-29 09:44:25'),
(347, 86, 6, '2026-04-29 09:44:25'),
(348, 86, 7, '2026-04-29 09:44:25'),
(349, 86, 8, '2026-04-29 09:44:25'),
(350, 86, 9, '2026-04-29 09:44:25'),
(351, 86, 10, '2026-04-29 09:44:25'),
(352, 87, 1, '2026-04-29 09:44:25'),
(353, 87, 2, '2026-04-29 09:44:25'),
(354, 87, 3, '2026-04-29 09:44:25'),
(355, 87, 4, '2026-04-29 09:44:25'),
(356, 87, 5, '2026-04-29 09:44:25'),
(357, 87, 6, '2026-04-29 09:44:25'),
(358, 87, 7, '2026-04-29 09:44:25'),
(359, 87, 8, '2026-04-29 09:44:25'),
(360, 87, 9, '2026-04-29 09:44:25'),
(361, 87, 10, '2026-04-29 09:44:25'),
(362, 88, 1, '2026-04-29 09:44:25'),
(363, 88, 2, '2026-04-29 09:44:25'),
(364, 88, 3, '2026-04-29 09:44:25'),
(365, 88, 4, '2026-04-29 09:44:25'),
(366, 88, 5, '2026-04-29 09:44:25'),
(367, 88, 6, '2026-04-29 09:44:25'),
(368, 88, 7, '2026-04-29 09:44:25'),
(369, 88, 8, '2026-04-29 09:44:25'),
(370, 88, 9, '2026-04-29 09:44:25'),
(371, 88, 10, '2026-04-29 09:44:25'),
(372, 89, 1, '2026-04-29 09:44:25'),
(373, 89, 2, '2026-04-29 09:44:25'),
(374, 89, 3, '2026-04-29 09:44:25'),
(375, 89, 4, '2026-04-29 09:44:25'),
(376, 89, 5, '2026-04-29 09:44:25'),
(377, 89, 6, '2026-04-29 09:44:25'),
(378, 89, 7, '2026-04-29 09:44:25'),
(379, 89, 8, '2026-04-29 09:44:25'),
(380, 89, 9, '2026-04-29 09:44:25'),
(381, 89, 10, '2026-04-29 09:44:25'),
(382, 90, 1, '2026-04-29 09:44:25'),
(383, 90, 2, '2026-04-29 09:44:25'),
(384, 90, 3, '2026-04-29 09:44:25'),
(385, 90, 4, '2026-04-29 09:44:25'),
(386, 90, 5, '2026-04-29 09:44:25'),
(387, 90, 6, '2026-04-29 09:44:25'),
(388, 90, 7, '2026-04-29 09:44:25'),
(389, 90, 8, '2026-04-29 09:44:25'),
(390, 90, 9, '2026-04-29 09:44:25'),
(391, 90, 10, '2026-04-29 09:44:25'),
(392, 91, 1, '2026-04-29 09:44:25'),
(393, 91, 2, '2026-04-29 09:44:25'),
(394, 91, 3, '2026-04-29 09:44:25'),
(395, 91, 4, '2026-04-29 09:44:25'),
(396, 91, 5, '2026-04-29 09:44:25'),
(397, 91, 6, '2026-04-29 09:44:25'),
(398, 91, 7, '2026-04-29 09:44:25'),
(399, 91, 8, '2026-04-29 09:44:25'),
(400, 91, 9, '2026-04-29 09:44:25'),
(401, 91, 10, '2026-04-29 09:44:25'),
(402, 92, 1, '2026-04-29 09:44:25'),
(403, 92, 2, '2026-04-29 09:44:25'),
(404, 92, 3, '2026-04-29 09:44:25'),
(405, 92, 4, '2026-04-29 09:44:25'),
(406, 92, 5, '2026-04-29 09:44:25'),
(407, 92, 6, '2026-04-29 09:44:25'),
(408, 92, 7, '2026-04-29 09:44:25'),
(409, 92, 8, '2026-04-29 09:44:25'),
(410, 92, 9, '2026-04-29 09:44:25'),
(411, 92, 10, '2026-04-29 09:44:25'),
(412, 93, 1, '2026-04-29 09:44:25'),
(413, 93, 2, '2026-04-29 09:44:25'),
(414, 93, 3, '2026-04-29 09:44:25'),
(415, 93, 4, '2026-04-29 09:44:25'),
(416, 93, 5, '2026-04-29 09:44:25'),
(417, 93, 6, '2026-04-29 09:44:25'),
(418, 93, 7, '2026-04-29 09:44:25'),
(419, 93, 8, '2026-04-29 09:44:25'),
(420, 93, 9, '2026-04-29 09:44:25'),
(421, 93, 10, '2026-04-29 09:44:25'),
(422, 94, 1, '2026-04-29 09:44:25'),
(423, 94, 2, '2026-04-29 09:44:25'),
(424, 94, 3, '2026-04-29 09:44:25'),
(425, 94, 4, '2026-04-29 09:44:25'),
(426, 94, 5, '2026-04-29 09:44:25'),
(427, 94, 6, '2026-04-29 09:44:25'),
(428, 94, 7, '2026-04-29 09:44:25'),
(429, 94, 8, '2026-04-29 09:44:25'),
(430, 94, 9, '2026-04-29 09:44:25'),
(431, 94, 10, '2026-04-29 09:44:25'),
(432, 95, 1, '2026-04-29 09:44:25'),
(433, 95, 2, '2026-04-29 09:44:25'),
(434, 95, 3, '2026-04-29 09:44:25'),
(435, 95, 4, '2026-04-29 09:44:25'),
(436, 95, 5, '2026-04-29 09:44:25'),
(437, 95, 6, '2026-04-29 09:44:25'),
(438, 95, 7, '2026-04-29 09:44:25'),
(439, 95, 8, '2026-04-29 09:44:25'),
(440, 95, 9, '2026-04-29 09:44:25'),
(441, 95, 10, '2026-04-29 09:44:25'),
(442, 96, 1, '2026-04-29 09:44:25'),
(443, 96, 2, '2026-04-29 09:44:25'),
(444, 96, 3, '2026-04-29 09:44:25'),
(445, 96, 4, '2026-04-29 09:44:25'),
(446, 96, 5, '2026-04-29 09:44:25'),
(447, 96, 6, '2026-04-29 09:44:25'),
(448, 96, 7, '2026-04-29 09:44:25'),
(449, 96, 8, '2026-04-29 09:44:25'),
(450, 96, 9, '2026-04-29 09:44:25'),
(451, 96, 10, '2026-04-29 09:44:25'),
(452, 97, 1, '2026-04-29 09:44:25'),
(453, 97, 2, '2026-04-29 09:44:25'),
(454, 97, 3, '2026-04-29 09:44:25'),
(455, 97, 4, '2026-04-29 09:44:25'),
(456, 97, 5, '2026-04-29 09:44:25'),
(457, 97, 6, '2026-04-29 09:44:25'),
(458, 97, 7, '2026-04-29 09:44:25'),
(459, 97, 8, '2026-04-29 09:44:25'),
(460, 97, 9, '2026-04-29 09:44:25'),
(461, 97, 10, '2026-04-29 09:44:25'),
(462, 98, 1, '2026-04-29 09:44:25'),
(463, 98, 2, '2026-04-29 09:44:25'),
(464, 98, 3, '2026-04-29 09:44:25'),
(465, 98, 4, '2026-04-29 09:44:25'),
(466, 98, 5, '2026-04-29 09:44:25'),
(467, 98, 6, '2026-04-29 09:44:25'),
(468, 98, 7, '2026-04-29 09:44:25'),
(469, 98, 8, '2026-04-29 09:44:25'),
(470, 98, 9, '2026-04-29 09:44:25'),
(471, 98, 10, '2026-04-29 09:44:25'),
(472, 99, 1, '2026-04-29 09:44:25'),
(473, 99, 2, '2026-04-29 09:44:25'),
(474, 99, 3, '2026-04-29 09:44:25'),
(475, 99, 4, '2026-04-29 09:44:25'),
(476, 99, 5, '2026-04-29 09:44:25'),
(477, 99, 6, '2026-04-29 09:44:25'),
(478, 99, 7, '2026-04-29 09:44:25'),
(479, 99, 8, '2026-04-29 09:44:25'),
(480, 99, 9, '2026-04-29 09:44:25'),
(481, 99, 10, '2026-04-29 09:44:25'),
(482, 100, 1, '2026-04-29 09:44:25'),
(483, 100, 2, '2026-04-29 09:44:25'),
(484, 100, 3, '2026-04-29 09:44:25'),
(485, 100, 4, '2026-04-29 09:44:25'),
(486, 100, 5, '2026-04-29 09:44:25'),
(487, 100, 6, '2026-04-29 09:44:25'),
(488, 100, 7, '2026-04-29 09:44:25'),
(489, 100, 8, '2026-04-29 09:44:25'),
(490, 100, 9, '2026-04-29 09:44:25'),
(491, 100, 10, '2026-04-29 09:44:25'),
(492, 101, 1, '2026-04-29 09:44:25'),
(493, 101, 2, '2026-04-29 09:44:25'),
(494, 101, 3, '2026-04-29 09:44:25'),
(495, 101, 4, '2026-04-29 09:44:25'),
(496, 101, 5, '2026-04-29 09:44:25'),
(497, 101, 6, '2026-04-29 09:44:25'),
(498, 101, 7, '2026-04-29 09:44:25'),
(499, 101, 8, '2026-04-29 09:44:25'),
(500, 101, 9, '2026-04-29 09:44:25'),
(501, 101, 10, '2026-04-29 09:44:25'),
(502, 102, 1, '2026-04-29 09:44:25'),
(503, 102, 2, '2026-04-29 09:44:25'),
(504, 102, 3, '2026-04-29 09:44:25'),
(505, 102, 4, '2026-04-29 09:44:25'),
(506, 102, 5, '2026-04-29 09:44:25'),
(507, 102, 6, '2026-04-29 09:44:25'),
(508, 102, 7, '2026-04-29 09:44:25'),
(509, 102, 8, '2026-04-29 09:44:25'),
(510, 102, 9, '2026-04-29 09:44:25'),
(511, 102, 10, '2026-04-29 09:44:25'),
(512, 103, 6, '2026-04-29 09:44:25'),
(513, 104, 6, '2026-04-29 09:44:25'),
(514, 105, 6, '2026-04-29 09:44:25'),
(515, 106, 6, '2026-04-29 09:44:25'),
(516, 107, 6, '2026-04-29 09:44:25'),
(517, 108, 6, '2026-04-29 09:44:25'),
(518, 109, 6, '2026-04-29 09:44:25'),
(519, 110, 6, '2026-04-29 09:44:25'),
(520, 111, 6, '2026-04-29 09:44:25'),
(521, 112, 6, '2026-04-29 09:44:25'),
(522, 113, 6, '2026-04-29 09:44:25'),
(523, 114, 6, '2026-04-29 09:44:25'),
(524, 115, 6, '2026-04-29 09:44:25'),
(525, 116, 6, '2026-04-29 09:44:25'),
(526, 117, 6, '2026-04-29 09:44:25'),
(527, 118, 6, '2026-04-29 09:44:25'),
(528, 119, 6, '2026-04-29 09:44:25'),
(529, 120, 6, '2026-04-29 09:44:25'),
(530, 121, 6, '2026-04-29 09:44:25'),
(531, 122, 6, '2026-04-29 09:44:25'),
(532, 123, 6, '2026-04-29 09:44:25'),
(533, 124, 6, '2026-04-29 09:44:25'),
(534, 125, 6, '2026-04-29 09:44:25'),
(535, 126, 3, '2026-04-29 09:44:25'),
(536, 127, 3, '2026-04-29 09:44:25'),
(537, 128, 3, '2026-04-29 09:44:25'),
(538, 129, 3, '2026-04-29 09:44:25'),
(539, 130, 3, '2026-04-29 09:44:25'),
(540, 131, 3, '2026-04-29 09:44:25'),
(541, 132, 3, '2026-04-29 09:44:25'),
(542, 133, 3, '2026-04-29 09:44:25'),
(543, 134, 3, '2026-04-29 09:44:25'),
(544, 135, 3, '2026-04-29 09:44:25'),
(545, 136, 3, '2026-04-29 09:44:25'),
(546, 137, 3, '2026-04-29 09:44:25'),
(547, 138, 3, '2026-04-29 09:44:25'),
(548, 139, 1, '2026-04-29 09:44:25'),
(549, 140, 1, '2026-04-29 09:44:25'),
(550, 141, 1, '2026-04-29 09:44:25'),
(551, 142, 1, '2026-04-29 09:44:25'),
(552, 143, 1, '2026-04-29 09:44:25'),
(553, 144, 1, '2026-04-29 09:44:25'),
(554, 145, 1, '2026-04-29 09:44:25'),
(555, 146, 1, '2026-04-29 09:44:25'),
(556, 147, 1, '2026-04-29 09:44:25'),
(557, 148, 1, '2026-04-29 09:44:25'),
(558, 149, 1, '2026-04-29 09:44:25'),
(559, 150, 3, '2026-04-29 09:44:25'),
(560, 151, 3, '2026-04-29 09:44:26'),
(561, 152, 1, '2026-04-29 09:44:26'),
(562, 152, 2, '2026-04-29 09:44:26'),
(563, 152, 3, '2026-04-29 09:44:26'),
(564, 152, 4, '2026-04-29 09:44:26'),
(565, 152, 5, '2026-04-29 09:44:26'),
(566, 152, 6, '2026-04-29 09:44:26'),
(567, 152, 7, '2026-04-29 09:44:26'),
(568, 152, 8, '2026-04-29 09:44:26'),
(569, 152, 9, '2026-04-29 09:44:26'),
(570, 152, 10, '2026-04-29 09:44:26'),
(571, 153, 1, '2026-04-29 09:44:26'),
(572, 153, 2, '2026-04-29 09:44:26'),
(573, 153, 3, '2026-04-29 09:44:26'),
(574, 153, 4, '2026-04-29 09:44:26'),
(575, 153, 5, '2026-04-29 09:44:26'),
(576, 153, 6, '2026-04-29 09:44:26'),
(577, 153, 7, '2026-04-29 09:44:26'),
(578, 153, 8, '2026-04-29 09:44:26'),
(579, 153, 9, '2026-04-29 09:44:26'),
(580, 153, 10, '2026-04-29 09:44:26'),
(581, 154, 1, '2026-04-29 09:44:26'),
(582, 154, 2, '2026-04-29 09:44:26'),
(583, 154, 3, '2026-04-29 09:44:26'),
(584, 154, 4, '2026-04-29 09:44:26'),
(585, 154, 5, '2026-04-29 09:44:26'),
(586, 154, 6, '2026-04-29 09:44:26'),
(587, 154, 7, '2026-04-29 09:44:26'),
(588, 154, 8, '2026-04-29 09:44:26'),
(589, 154, 9, '2026-04-29 09:44:26'),
(590, 154, 10, '2026-04-29 09:44:26'),
(591, 155, 1, '2026-04-29 09:44:26'),
(592, 155, 2, '2026-04-29 09:44:26'),
(593, 155, 3, '2026-04-29 09:44:26'),
(594, 155, 4, '2026-04-29 09:44:26'),
(595, 155, 5, '2026-04-29 09:44:26'),
(596, 155, 6, '2026-04-29 09:44:26'),
(597, 155, 7, '2026-04-29 09:44:26'),
(598, 155, 8, '2026-04-29 09:44:26'),
(599, 155, 9, '2026-04-29 09:44:26'),
(600, 155, 10, '2026-04-29 09:44:26'),
(601, 156, 1, '2026-04-29 09:44:26'),
(602, 156, 2, '2026-04-29 09:44:26'),
(603, 156, 3, '2026-04-29 09:44:26'),
(604, 156, 4, '2026-04-29 09:44:26'),
(605, 156, 5, '2026-04-29 09:44:26'),
(606, 156, 6, '2026-04-29 09:44:26'),
(607, 156, 7, '2026-04-29 09:44:26'),
(608, 156, 8, '2026-04-29 09:44:26'),
(609, 156, 9, '2026-04-29 09:44:26'),
(610, 156, 10, '2026-04-29 09:44:26'),
(611, 157, 1, '2026-04-29 09:44:26'),
(612, 157, 2, '2026-04-29 09:44:26'),
(613, 157, 3, '2026-04-29 09:44:26'),
(614, 157, 4, '2026-04-29 09:44:26'),
(615, 157, 5, '2026-04-29 09:44:26'),
(616, 157, 6, '2026-04-29 09:44:26'),
(617, 157, 7, '2026-04-29 09:44:26'),
(618, 157, 8, '2026-04-29 09:44:26'),
(619, 157, 9, '2026-04-29 09:44:26'),
(620, 157, 10, '2026-04-29 09:44:26'),
(621, 158, 1, '2026-04-29 09:44:26'),
(622, 158, 2, '2026-04-29 09:44:26'),
(623, 158, 3, '2026-04-29 09:44:26'),
(624, 158, 4, '2026-04-29 09:44:26'),
(625, 158, 5, '2026-04-29 09:44:26'),
(626, 158, 6, '2026-04-29 09:44:26'),
(627, 158, 7, '2026-04-29 09:44:26'),
(628, 158, 8, '2026-04-29 09:44:26'),
(629, 158, 9, '2026-04-29 09:44:26'),
(630, 158, 10, '2026-04-29 09:44:26'),
(631, 159, 1, '2026-04-29 09:44:26'),
(632, 159, 2, '2026-04-29 09:44:26'),
(633, 159, 3, '2026-04-29 09:44:26'),
(634, 159, 4, '2026-04-29 09:44:26'),
(635, 159, 5, '2026-04-29 09:44:26'),
(636, 159, 6, '2026-04-29 09:44:26'),
(637, 159, 7, '2026-04-29 09:44:26'),
(638, 159, 8, '2026-04-29 09:44:26'),
(639, 159, 9, '2026-04-29 09:44:26'),
(640, 159, 10, '2026-04-29 09:44:26'),
(641, 160, 1, '2026-04-29 09:44:26'),
(642, 160, 2, '2026-04-29 09:44:26'),
(643, 160, 3, '2026-04-29 09:44:26'),
(644, 160, 4, '2026-04-29 09:44:26'),
(645, 160, 5, '2026-04-29 09:44:26'),
(646, 160, 6, '2026-04-29 09:44:26'),
(647, 160, 7, '2026-04-29 09:44:26'),
(648, 160, 8, '2026-04-29 09:44:26'),
(649, 160, 9, '2026-04-29 09:44:26'),
(650, 160, 10, '2026-04-29 09:44:26'),
(651, 161, 1, '2026-04-29 09:44:26'),
(652, 161, 2, '2026-04-29 09:44:26'),
(653, 161, 3, '2026-04-29 09:44:26'),
(654, 161, 4, '2026-04-29 09:44:26'),
(655, 161, 5, '2026-04-29 09:44:26'),
(656, 161, 6, '2026-04-29 09:44:26'),
(657, 161, 7, '2026-04-29 09:44:26'),
(658, 161, 8, '2026-04-29 09:44:26'),
(659, 161, 9, '2026-04-29 09:44:26'),
(660, 161, 10, '2026-04-29 09:44:26'),
(661, 162, 1, '2026-04-29 09:44:26'),
(662, 162, 2, '2026-04-29 09:44:26'),
(663, 162, 3, '2026-04-29 09:44:26'),
(664, 162, 4, '2026-04-29 09:44:26'),
(665, 162, 5, '2026-04-29 09:44:26'),
(666, 162, 6, '2026-04-29 09:44:26'),
(667, 162, 7, '2026-04-29 09:44:26'),
(668, 162, 8, '2026-04-29 09:44:26'),
(669, 162, 9, '2026-04-29 09:44:26'),
(670, 162, 10, '2026-04-29 09:44:26'),
(671, 163, 1, '2026-04-29 09:44:26'),
(672, 163, 2, '2026-04-29 09:44:26'),
(673, 163, 3, '2026-04-29 09:44:26'),
(674, 163, 4, '2026-04-29 09:44:26'),
(675, 163, 5, '2026-04-29 09:44:26'),
(676, 163, 6, '2026-04-29 09:44:26'),
(677, 163, 7, '2026-04-29 09:44:26'),
(678, 163, 8, '2026-04-29 09:44:26'),
(679, 163, 9, '2026-04-29 09:44:26'),
(680, 163, 10, '2026-04-29 09:44:26'),
(681, 164, 6, '2026-04-29 09:44:26'),
(682, 165, 6, '2026-04-29 09:44:26'),
(683, 166, 6, '2026-04-29 09:44:26'),
(684, 167, 2, '2026-04-29 09:44:26'),
(685, 168, 2, '2026-04-29 09:44:26'),
(686, 169, 2, '2026-04-29 09:44:26'),
(687, 170, 2, '2026-04-29 09:44:26'),
(688, 171, 2, '2026-04-29 09:44:26'),
(689, 172, 2, '2026-04-29 09:44:26'),
(690, 173, 2, '2026-04-29 09:44:26'),
(691, 174, 2, '2026-04-29 09:44:26'),
(692, 175, 2, '2026-04-29 09:44:26'),
(693, 176, 2, '2026-04-29 09:44:26'),
(694, 177, 2, '2026-04-29 09:44:26'),
(695, 178, 2, '2026-04-29 09:44:26'),
(696, 179, 2, '2026-04-29 09:44:26'),
(697, 180, 2, '2026-04-29 09:44:26'),
(698, 181, 2, '2026-04-29 09:44:26'),
(699, 182, 1, '2026-04-29 09:44:26'),
(700, 183, 6, '2026-04-29 09:44:26'),
(701, 184, 3, '2026-04-29 09:44:26'),
(702, 185, 1, '2026-04-29 09:44:26'),
(703, 186, 2, '2026-04-29 09:44:26'),
(704, 187, 5, '2026-04-29 09:44:26'),
(705, 188, 5, '2026-04-29 09:44:26'),
(706, 189, 5, '2026-04-29 09:44:26'),
(707, 190, 5, '2026-04-29 09:44:26'),
(708, 191, 5, '2026-04-29 09:44:26'),
(709, 192, 5, '2026-04-29 09:44:26'),
(710, 193, 5, '2026-04-29 09:44:26'),
(711, 194, 5, '2026-04-29 09:44:26'),
(712, 195, 5, '2026-04-29 09:44:26'),
(713, 196, 5, '2026-04-29 09:44:26'),
(714, 197, 5, '2026-04-29 09:44:26'),
(715, 198, 5, '2026-04-29 09:44:26'),
(716, 199, 5, '2026-04-29 09:44:26'),
(717, 200, 5, '2026-04-29 09:44:26'),
(718, 201, 7, '2026-04-29 09:44:26'),
(719, 202, 4, '2026-04-29 09:44:26'),
(720, 203, 1, '2026-04-29 09:44:26'),
(721, 203, 2, '2026-04-29 09:44:26'),
(722, 203, 3, '2026-04-29 09:44:26'),
(723, 203, 4, '2026-04-29 09:44:26'),
(724, 203, 5, '2026-04-29 09:44:26'),
(725, 203, 6, '2026-04-29 09:44:26'),
(726, 203, 7, '2026-04-29 09:44:26'),
(727, 203, 8, '2026-04-29 09:44:26'),
(728, 203, 9, '2026-04-29 09:44:26'),
(729, 203, 10, '2026-04-29 09:44:26'),
(730, 204, 1, '2026-04-29 09:44:26'),
(731, 204, 2, '2026-04-29 09:44:26'),
(732, 204, 3, '2026-04-29 09:44:26'),
(733, 204, 4, '2026-04-29 09:44:26'),
(734, 204, 5, '2026-04-29 09:44:26'),
(735, 204, 6, '2026-04-29 09:44:26'),
(736, 204, 7, '2026-04-29 09:44:26'),
(737, 204, 8, '2026-04-29 09:44:26'),
(738, 204, 9, '2026-04-29 09:44:26'),
(739, 204, 10, '2026-04-29 09:44:26'),
(740, 205, 9, '2026-04-29 09:44:26'),
(741, 206, 9, '2026-04-29 09:44:26'),
(742, 207, 9, '2026-04-29 09:44:26'),
(743, 208, 9, '2026-04-29 09:44:26'),
(744, 209, 9, '2026-04-29 09:44:26'),
(745, 210, 9, '2026-04-29 09:44:26'),
(746, 211, 9, '2026-04-29 09:44:26'),
(747, 212, 9, '2026-04-29 09:44:26'),
(748, 213, 9, '2026-04-29 09:44:26'),
(749, 214, 9, '2026-04-29 09:44:26'),
(750, 215, 9, '2026-04-29 09:44:26'),
(751, 216, 9, '2026-04-29 09:44:26'),
(752, 217, 9, '2026-04-29 09:44:26'),
(753, 218, 9, '2026-04-29 09:44:26'),
(754, 219, 9, '2026-04-29 09:44:26'),
(755, 220, 9, '2026-04-29 09:44:26'),
(756, 221, 9, '2026-04-29 09:44:26'),
(757, 222, 3, '2026-04-29 09:44:26'),
(758, 223, 3, '2026-04-29 09:44:26'),
(759, 224, 3, '2026-04-29 09:44:26'),
(760, 225, 3, '2026-04-29 09:44:26'),
(761, 226, 3, '2026-04-29 09:44:26'),
(762, 227, 3, '2026-04-29 09:44:26'),
(763, 228, 3, '2026-04-29 09:44:26'),
(764, 229, 3, '2026-04-29 09:44:26'),
(765, 230, 3, '2026-04-29 09:44:26'),
(766, 231, 3, '2026-04-29 09:44:26'),
(767, 232, 3, '2026-04-29 09:44:26'),
(768, 233, 3, '2026-04-29 09:44:26'),
(769, 234, 3, '2026-04-29 09:44:26'),
(770, 235, 3, '2026-04-29 09:44:26'),
(771, 236, 9, '2026-04-29 09:44:26'),
(772, 237, 3, '2026-04-29 09:44:26'),
(773, 238, 3, '2026-04-29 09:44:26'),
(774, 239, 3, '2026-04-29 09:44:26'),
(775, 240, 3, '2026-04-29 09:44:26'),
(776, 241, 3, '2026-04-29 09:44:26'),
(777, 242, 3, '2026-04-29 09:44:26'),
(778, 243, 3, '2026-04-29 09:44:26'),
(779, 244, 3, '2026-04-29 09:44:26'),
(780, 245, 3, '2026-04-29 09:44:26'),
(781, 246, 3, '2026-04-29 09:44:26'),
(782, 247, 3, '2026-04-29 09:44:26'),
(783, 248, 3, '2026-04-29 09:44:26'),
(784, 249, 3, '2026-04-29 09:44:26'),
(785, 250, 3, '2026-04-29 09:44:26'),
(786, 251, 3, '2026-04-29 09:44:26'),
(787, 252, 3, '2026-04-29 09:44:26'),
(788, 253, 9, '2026-04-29 09:44:26'),
(789, 254, 9, '2026-04-29 09:44:26'),
(790, 255, 9, '2026-04-29 09:44:26'),
(791, 256, 9, '2026-04-29 09:44:26'),
(792, 257, 9, '2026-04-29 09:44:26'),
(793, 258, 9, '2026-04-29 09:44:26'),
(794, 259, 9, '2026-04-29 09:44:26'),
(795, 260, 9, '2026-04-29 09:44:26'),
(796, 261, 9, '2026-04-29 09:44:26'),
(797, 262, 9, '2026-04-29 09:44:26'),
(798, 263, 9, '2026-04-29 09:44:26'),
(799, 264, 9, '2026-04-29 09:44:26'),
(800, 265, 9, '2026-04-29 09:44:26'),
(801, 266, 9, '2026-04-29 09:44:26'),
(802, 267, 1, '2026-04-29 09:44:26'),
(803, 267, 2, '2026-04-29 09:44:26'),
(804, 267, 3, '2026-04-29 09:44:26'),
(805, 267, 4, '2026-04-29 09:44:26'),
(806, 267, 5, '2026-04-29 09:44:26'),
(807, 267, 6, '2026-04-29 09:44:26'),
(808, 267, 7, '2026-04-29 09:44:26'),
(809, 267, 8, '2026-04-29 09:44:26'),
(810, 267, 9, '2026-04-29 09:44:26'),
(811, 267, 10, '2026-04-29 09:44:26'),
(812, 268, 1, '2026-04-29 09:44:26'),
(813, 268, 2, '2026-04-29 09:44:26'),
(814, 268, 3, '2026-04-29 09:44:26'),
(815, 268, 4, '2026-04-29 09:44:26'),
(816, 268, 5, '2026-04-29 09:44:26'),
(817, 268, 6, '2026-04-29 09:44:26'),
(818, 268, 7, '2026-04-29 09:44:26'),
(819, 268, 8, '2026-04-29 09:44:26'),
(820, 268, 9, '2026-04-29 09:44:26'),
(821, 268, 10, '2026-04-29 09:44:26'),
(822, 269, 1, '2026-04-29 09:44:26'),
(823, 269, 2, '2026-04-29 09:44:26'),
(824, 269, 3, '2026-04-29 09:44:26'),
(825, 269, 4, '2026-04-29 09:44:26'),
(826, 269, 5, '2026-04-29 09:44:26'),
(827, 269, 6, '2026-04-29 09:44:26'),
(828, 269, 7, '2026-04-29 09:44:26'),
(829, 269, 8, '2026-04-29 09:44:26'),
(830, 269, 9, '2026-04-29 09:44:26'),
(831, 269, 10, '2026-04-29 09:44:26'),
(832, 270, 1, '2026-04-29 09:44:26'),
(833, 270, 2, '2026-04-29 09:44:26'),
(834, 270, 3, '2026-04-29 09:44:26'),
(835, 270, 4, '2026-04-29 09:44:26'),
(836, 270, 5, '2026-04-29 09:44:26'),
(837, 270, 6, '2026-04-29 09:44:26'),
(838, 270, 7, '2026-04-29 09:44:26'),
(839, 270, 8, '2026-04-29 09:44:26'),
(840, 270, 9, '2026-04-29 09:44:26'),
(841, 270, 10, '2026-04-29 09:44:26'),
(842, 271, 1, '2026-04-29 09:44:26'),
(843, 271, 2, '2026-04-29 09:44:26'),
(844, 271, 3, '2026-04-29 09:44:26'),
(845, 271, 4, '2026-04-29 09:44:26'),
(846, 271, 5, '2026-04-29 09:44:26'),
(847, 271, 6, '2026-04-29 09:44:26'),
(848, 271, 7, '2026-04-29 09:44:26'),
(849, 271, 8, '2026-04-29 09:44:26'),
(850, 271, 9, '2026-04-29 09:44:26'),
(851, 271, 10, '2026-04-29 09:44:26'),
(852, 272, 1, '2026-04-29 09:44:26'),
(853, 272, 2, '2026-04-29 09:44:26'),
(854, 272, 3, '2026-04-29 09:44:26'),
(855, 272, 4, '2026-04-29 09:44:26'),
(856, 272, 5, '2026-04-29 09:44:26'),
(857, 272, 6, '2026-04-29 09:44:26'),
(858, 272, 7, '2026-04-29 09:44:26'),
(859, 272, 8, '2026-04-29 09:44:26'),
(860, 272, 9, '2026-04-29 09:44:26'),
(861, 272, 10, '2026-04-29 09:44:26'),
(862, 273, 1, '2026-04-29 09:44:26'),
(863, 273, 2, '2026-04-29 09:44:26'),
(864, 273, 3, '2026-04-29 09:44:26'),
(865, 273, 4, '2026-04-29 09:44:26'),
(866, 273, 5, '2026-04-29 09:44:26'),
(867, 273, 6, '2026-04-29 09:44:26'),
(868, 273, 7, '2026-04-29 09:44:26'),
(869, 273, 8, '2026-04-29 09:44:26'),
(870, 273, 9, '2026-04-29 09:44:26'),
(871, 273, 10, '2026-04-29 09:44:26'),
(872, 274, 1, '2026-04-29 09:44:26'),
(873, 274, 2, '2026-04-29 09:44:26'),
(874, 274, 3, '2026-04-29 09:44:26'),
(875, 274, 4, '2026-04-29 09:44:26'),
(876, 274, 5, '2026-04-29 09:44:26'),
(877, 274, 6, '2026-04-29 09:44:26'),
(878, 274, 7, '2026-04-29 09:44:26'),
(879, 274, 8, '2026-04-29 09:44:26'),
(880, 274, 9, '2026-04-29 09:44:26'),
(881, 274, 10, '2026-04-29 09:44:26'),
(882, 275, 1, '2026-04-29 09:44:26'),
(883, 275, 2, '2026-04-29 09:44:26'),
(884, 275, 3, '2026-04-29 09:44:26'),
(885, 275, 4, '2026-04-29 09:44:26'),
(886, 275, 5, '2026-04-29 09:44:26'),
(887, 275, 6, '2026-04-29 09:44:26'),
(888, 275, 7, '2026-04-29 09:44:26'),
(889, 275, 8, '2026-04-29 09:44:26'),
(890, 275, 9, '2026-04-29 09:44:26'),
(891, 275, 10, '2026-04-29 09:44:26'),
(892, 276, 1, '2026-04-29 09:44:26'),
(893, 276, 2, '2026-04-29 09:44:26'),
(894, 276, 3, '2026-04-29 09:44:26'),
(895, 276, 4, '2026-04-29 09:44:26'),
(896, 276, 5, '2026-04-29 09:44:26'),
(897, 276, 6, '2026-04-29 09:44:26'),
(898, 276, 7, '2026-04-29 09:44:26'),
(899, 276, 8, '2026-04-29 09:44:26'),
(900, 276, 9, '2026-04-29 09:44:26'),
(901, 276, 10, '2026-04-29 09:44:26'),
(902, 277, 1, '2026-04-29 09:44:26'),
(903, 277, 2, '2026-04-29 09:44:26'),
(904, 277, 3, '2026-04-29 09:44:26'),
(905, 277, 4, '2026-04-29 09:44:26'),
(906, 277, 5, '2026-04-29 09:44:26'),
(907, 277, 6, '2026-04-29 09:44:26'),
(908, 277, 7, '2026-04-29 09:44:26'),
(909, 277, 8, '2026-04-29 09:44:26'),
(910, 277, 9, '2026-04-29 09:44:26'),
(911, 277, 10, '2026-04-29 09:44:26'),
(912, 278, 1, '2026-04-29 09:44:26'),
(913, 278, 2, '2026-04-29 09:44:26'),
(914, 278, 3, '2026-04-29 09:44:26'),
(915, 278, 4, '2026-04-29 09:44:26'),
(916, 278, 5, '2026-04-29 09:44:26'),
(917, 278, 6, '2026-04-29 09:44:26'),
(918, 278, 7, '2026-04-29 09:44:26'),
(919, 278, 8, '2026-04-29 09:44:26'),
(920, 278, 9, '2026-04-29 09:44:26'),
(921, 278, 10, '2026-04-29 09:44:26'),
(922, 279, 1, '2026-04-29 09:44:26'),
(923, 279, 2, '2026-04-29 09:44:26'),
(924, 279, 3, '2026-04-29 09:44:26'),
(925, 279, 4, '2026-04-29 09:44:26'),
(926, 279, 5, '2026-04-29 09:44:26'),
(927, 279, 6, '2026-04-29 09:44:26'),
(928, 279, 7, '2026-04-29 09:44:26'),
(929, 279, 8, '2026-04-29 09:44:26'),
(930, 279, 9, '2026-04-29 09:44:26'),
(931, 279, 10, '2026-04-29 09:44:26'),
(932, 280, 1, '2026-04-29 09:44:26'),
(933, 280, 2, '2026-04-29 09:44:26'),
(934, 280, 3, '2026-04-29 09:44:26'),
(935, 280, 4, '2026-04-29 09:44:26'),
(936, 280, 5, '2026-04-29 09:44:26'),
(937, 280, 6, '2026-04-29 09:44:26'),
(938, 280, 7, '2026-04-29 09:44:26'),
(939, 280, 8, '2026-04-29 09:44:26'),
(940, 280, 9, '2026-04-29 09:44:26'),
(941, 280, 10, '2026-04-29 09:44:26'),
(942, 281, 1, '2026-04-29 09:44:26'),
(943, 281, 2, '2026-04-29 09:44:26'),
(944, 281, 3, '2026-04-29 09:44:26'),
(945, 281, 4, '2026-04-29 09:44:26'),
(946, 281, 5, '2026-04-29 09:44:26'),
(947, 281, 6, '2026-04-29 09:44:26'),
(948, 281, 7, '2026-04-29 09:44:26'),
(949, 281, 8, '2026-04-29 09:44:26'),
(950, 281, 9, '2026-04-29 09:44:26'),
(951, 281, 10, '2026-04-29 09:44:26'),
(952, 282, 1, '2026-04-29 09:44:26'),
(953, 282, 2, '2026-04-29 09:44:26'),
(954, 282, 3, '2026-04-29 09:44:26'),
(955, 282, 4, '2026-04-29 09:44:26'),
(956, 282, 5, '2026-04-29 09:44:26'),
(957, 282, 6, '2026-04-29 09:44:26'),
(958, 282, 7, '2026-04-29 09:44:26'),
(959, 282, 8, '2026-04-29 09:44:26'),
(960, 282, 9, '2026-04-29 09:44:26'),
(961, 282, 10, '2026-04-29 09:44:26'),
(962, 283, 1, '2026-04-29 09:44:26'),
(963, 283, 2, '2026-04-29 09:44:26'),
(964, 283, 3, '2026-04-29 09:44:26'),
(965, 283, 4, '2026-04-29 09:44:26'),
(966, 283, 5, '2026-04-29 09:44:26'),
(967, 283, 6, '2026-04-29 09:44:26'),
(968, 283, 7, '2026-04-29 09:44:26'),
(969, 283, 8, '2026-04-29 09:44:26'),
(970, 283, 9, '2026-04-29 09:44:26'),
(971, 283, 10, '2026-04-29 09:44:26'),
(972, 284, 1, '2026-04-29 09:44:26'),
(973, 284, 2, '2026-04-29 09:44:26'),
(974, 284, 3, '2026-04-29 09:44:26'),
(975, 284, 4, '2026-04-29 09:44:26'),
(976, 284, 5, '2026-04-29 09:44:26'),
(977, 284, 6, '2026-04-29 09:44:26'),
(978, 284, 7, '2026-04-29 09:44:26'),
(979, 284, 8, '2026-04-29 09:44:26'),
(980, 284, 9, '2026-04-29 09:44:26'),
(981, 284, 10, '2026-04-29 09:44:26'),
(982, 285, 1, '2026-04-29 09:44:26'),
(983, 285, 2, '2026-04-29 09:44:26'),
(984, 285, 3, '2026-04-29 09:44:26'),
(985, 285, 4, '2026-04-29 09:44:26'),
(986, 285, 5, '2026-04-29 09:44:26'),
(987, 285, 6, '2026-04-29 09:44:26'),
(988, 285, 7, '2026-04-29 09:44:26'),
(989, 285, 8, '2026-04-29 09:44:26'),
(990, 285, 9, '2026-04-29 09:44:26'),
(991, 285, 10, '2026-04-29 09:44:26'),
(992, 286, 1, '2026-04-29 09:44:26'),
(993, 286, 2, '2026-04-29 09:44:26'),
(994, 286, 3, '2026-04-29 09:44:26'),
(995, 286, 4, '2026-04-29 09:44:26'),
(996, 286, 5, '2026-04-29 09:44:26'),
(997, 286, 6, '2026-04-29 09:44:26'),
(998, 286, 7, '2026-04-29 09:44:26'),
(999, 286, 8, '2026-04-29 09:44:26'),
(1000, 286, 9, '2026-04-29 09:44:26'),
(1001, 286, 10, '2026-04-29 09:44:26'),
(1002, 287, 1, '2026-04-29 09:44:26'),
(1003, 287, 2, '2026-04-29 09:44:26'),
(1004, 287, 3, '2026-04-29 09:44:26'),
(1005, 287, 4, '2026-04-29 09:44:26'),
(1006, 287, 5, '2026-04-29 09:44:26'),
(1007, 287, 6, '2026-04-29 09:44:26'),
(1008, 287, 7, '2026-04-29 09:44:26'),
(1009, 287, 8, '2026-04-29 09:44:26'),
(1010, 287, 9, '2026-04-29 09:44:26'),
(1011, 287, 10, '2026-04-29 09:44:26'),
(1012, 288, 1, '2026-04-29 09:44:26'),
(1013, 288, 2, '2026-04-29 09:44:26'),
(1014, 288, 3, '2026-04-29 09:44:26'),
(1015, 288, 4, '2026-04-29 09:44:26'),
(1016, 288, 5, '2026-04-29 09:44:26'),
(1017, 288, 6, '2026-04-29 09:44:26'),
(1018, 288, 7, '2026-04-29 09:44:26'),
(1019, 288, 8, '2026-04-29 09:44:26'),
(1020, 288, 9, '2026-04-29 09:44:26'),
(1021, 288, 10, '2026-04-29 09:44:26'),
(1022, 289, 1, '2026-04-29 09:44:26'),
(1023, 289, 2, '2026-04-29 09:44:26'),
(1024, 289, 3, '2026-04-29 09:44:26'),
(1025, 289, 4, '2026-04-29 09:44:26'),
(1026, 289, 5, '2026-04-29 09:44:26'),
(1027, 289, 6, '2026-04-29 09:44:26'),
(1028, 289, 7, '2026-04-29 09:44:26'),
(1029, 289, 8, '2026-04-29 09:44:26'),
(1030, 289, 9, '2026-04-29 09:44:26'),
(1031, 289, 10, '2026-04-29 09:44:26'),
(1032, 290, 1, '2026-04-29 09:44:26'),
(1033, 290, 2, '2026-04-29 09:44:26'),
(1034, 290, 3, '2026-04-29 09:44:26'),
(1035, 290, 4, '2026-04-29 09:44:26'),
(1036, 290, 5, '2026-04-29 09:44:26'),
(1037, 290, 6, '2026-04-29 09:44:26'),
(1038, 290, 7, '2026-04-29 09:44:26'),
(1039, 290, 8, '2026-04-29 09:44:26'),
(1040, 290, 9, '2026-04-29 09:44:26'),
(1041, 290, 10, '2026-04-29 09:44:26'),
(1042, 291, 7, '2026-04-29 09:44:26'),
(1043, 292, 7, '2026-04-29 09:44:26'),
(1044, 293, 7, '2026-04-29 09:44:26'),
(1045, 294, 7, '2026-04-29 09:44:26'),
(1046, 295, 7, '2026-04-29 09:44:26'),
(1047, 296, 7, '2026-04-29 09:44:26'),
(1048, 297, 7, '2026-04-29 09:44:26'),
(1049, 298, 7, '2026-04-29 09:44:26'),
(1050, 299, 7, '2026-04-29 09:44:26'),
(1051, 300, 7, '2026-04-29 09:44:26'),
(1052, 301, 7, '2026-04-29 09:44:26'),
(1053, 302, 4, '2026-04-29 09:44:26'),
(1054, 303, 4, '2026-04-29 09:44:26'),
(1055, 304, 4, '2026-04-29 09:44:26'),
(1056, 305, 7, '2026-04-29 09:44:26'),
(1057, 306, 7, '2026-04-29 09:44:26'),
(1058, 307, 7, '2026-04-29 09:44:26'),
(1059, 308, 7, '2026-04-29 09:44:26'),
(1060, 309, 7, '2026-04-29 09:44:26'),
(1061, 310, 7, '2026-04-29 09:44:26'),
(1062, 311, 7, '2026-04-29 09:44:26'),
(1063, 312, 7, '2026-04-29 09:44:26'),
(1064, 313, 7, '2026-04-29 09:44:26'),
(1065, 314, 7, '2026-04-29 09:44:26'),
(1066, 315, 7, '2026-04-29 09:44:26'),
(1067, 316, 2, '2026-04-29 09:44:26'),
(1068, 317, 2, '2026-04-29 09:44:26'),
(1069, 318, 2, '2026-04-29 09:44:26'),
(1070, 319, 2, '2026-04-29 09:44:26'),
(1071, 320, 2, '2026-04-29 09:44:26'),
(1072, 321, 2, '2026-04-29 09:44:26'),
(1073, 322, 2, '2026-04-29 09:44:26'),
(1074, 323, 2, '2026-04-29 09:44:26'),
(1075, 324, 2, '2026-04-29 09:44:26'),
(1076, 325, 1, '2026-04-29 09:44:26'),
(1077, 325, 2, '2026-04-29 09:44:26'),
(1078, 325, 3, '2026-04-29 09:44:26'),
(1079, 325, 4, '2026-04-29 09:44:26'),
(1080, 325, 5, '2026-04-29 09:44:26'),
(1081, 325, 6, '2026-04-29 09:44:26'),
(1082, 325, 7, '2026-04-29 09:44:26'),
(1083, 325, 8, '2026-04-29 09:44:26'),
(1084, 325, 9, '2026-04-29 09:44:26'),
(1085, 325, 10, '2026-04-29 09:44:26'),
(1086, 326, 1, '2026-04-29 09:44:26'),
(1087, 326, 2, '2026-04-29 09:44:26'),
(1088, 326, 3, '2026-04-29 09:44:26'),
(1089, 326, 4, '2026-04-29 09:44:26'),
(1090, 326, 5, '2026-04-29 09:44:26'),
(1091, 326, 6, '2026-04-29 09:44:26'),
(1092, 326, 7, '2026-04-29 09:44:26'),
(1093, 326, 8, '2026-04-29 09:44:26'),
(1094, 326, 9, '2026-04-29 09:44:26'),
(1095, 326, 10, '2026-04-29 09:44:26'),
(1096, 327, 1, '2026-04-29 09:44:26'),
(1097, 327, 2, '2026-04-29 09:44:26'),
(1098, 327, 3, '2026-04-29 09:44:26'),
(1099, 327, 4, '2026-04-29 09:44:26'),
(1100, 327, 5, '2026-04-29 09:44:26'),
(1101, 327, 6, '2026-04-29 09:44:26'),
(1102, 327, 7, '2026-04-29 09:44:26'),
(1103, 327, 8, '2026-04-29 09:44:26'),
(1104, 327, 9, '2026-04-29 09:44:26'),
(1105, 327, 10, '2026-04-29 09:44:26'),
(1106, 328, 1, '2026-04-29 09:44:26'),
(1107, 328, 2, '2026-04-29 09:44:26'),
(1108, 328, 3, '2026-04-29 09:44:26'),
(1109, 328, 4, '2026-04-29 09:44:26'),
(1110, 328, 5, '2026-04-29 09:44:26'),
(1111, 328, 6, '2026-04-29 09:44:26'),
(1112, 328, 7, '2026-04-29 09:44:26'),
(1113, 328, 8, '2026-04-29 09:44:26'),
(1114, 328, 9, '2026-04-29 09:44:26'),
(1115, 328, 10, '2026-04-29 09:44:26'),
(1116, 329, 1, '2026-04-29 09:44:26'),
(1117, 329, 2, '2026-04-29 09:44:26'),
(1118, 329, 3, '2026-04-29 09:44:26'),
(1119, 329, 4, '2026-04-29 09:44:26'),
(1120, 329, 5, '2026-04-29 09:44:26'),
(1121, 329, 6, '2026-04-29 09:44:26'),
(1122, 329, 7, '2026-04-29 09:44:26'),
(1123, 329, 8, '2026-04-29 09:44:26'),
(1124, 329, 9, '2026-04-29 09:44:26'),
(1125, 329, 10, '2026-04-29 09:44:26'),
(1126, 330, 1, '2026-04-29 09:44:26'),
(1127, 330, 2, '2026-04-29 09:44:26'),
(1128, 330, 3, '2026-04-29 09:44:26'),
(1129, 330, 4, '2026-04-29 09:44:26'),
(1130, 330, 5, '2026-04-29 09:44:26'),
(1131, 330, 6, '2026-04-29 09:44:26'),
(1132, 330, 7, '2026-04-29 09:44:26'),
(1133, 330, 8, '2026-04-29 09:44:26'),
(1134, 330, 9, '2026-04-29 09:44:26'),
(1135, 330, 10, '2026-04-29 09:44:26'),
(1136, 331, 1, '2026-04-29 09:44:26'),
(1137, 331, 2, '2026-04-29 09:44:26'),
(1138, 331, 3, '2026-04-29 09:44:26'),
(1139, 331, 4, '2026-04-29 09:44:26'),
(1140, 331, 5, '2026-04-29 09:44:26'),
(1141, 331, 6, '2026-04-29 09:44:26'),
(1142, 331, 7, '2026-04-29 09:44:26'),
(1143, 331, 8, '2026-04-29 09:44:26'),
(1144, 331, 9, '2026-04-29 09:44:26'),
(1145, 331, 10, '2026-04-29 09:44:26'),
(1146, 332, 1, '2026-04-29 09:44:26'),
(1147, 332, 2, '2026-04-29 09:44:26'),
(1148, 332, 3, '2026-04-29 09:44:26'),
(1149, 332, 4, '2026-04-29 09:44:26'),
(1150, 332, 5, '2026-04-29 09:44:26'),
(1151, 332, 6, '2026-04-29 09:44:26'),
(1152, 332, 7, '2026-04-29 09:44:26'),
(1153, 332, 8, '2026-04-29 09:44:26'),
(1154, 332, 9, '2026-04-29 09:44:26'),
(1155, 332, 10, '2026-04-29 09:44:26'),
(1156, 333, 1, '2026-04-29 09:44:26'),
(1157, 333, 2, '2026-04-29 09:44:26'),
(1158, 333, 3, '2026-04-29 09:44:26'),
(1159, 333, 4, '2026-04-29 09:44:26'),
(1160, 333, 5, '2026-04-29 09:44:26'),
(1161, 333, 6, '2026-04-29 09:44:26'),
(1162, 333, 7, '2026-04-29 09:44:26'),
(1163, 333, 8, '2026-04-29 09:44:26'),
(1164, 333, 9, '2026-04-29 09:44:26'),
(1165, 333, 10, '2026-04-29 09:44:26'),
(1166, 334, 1, '2026-04-29 09:44:26'),
(1167, 334, 2, '2026-04-29 09:44:26'),
(1168, 334, 3, '2026-04-29 09:44:26'),
(1169, 334, 4, '2026-04-29 09:44:26'),
(1170, 334, 5, '2026-04-29 09:44:26'),
(1171, 334, 6, '2026-04-29 09:44:26'),
(1172, 334, 7, '2026-04-29 09:44:26'),
(1173, 334, 8, '2026-04-29 09:44:26'),
(1174, 334, 9, '2026-04-29 09:44:26'),
(1175, 334, 10, '2026-04-29 09:44:26'),
(1176, 335, 1, '2026-04-29 09:44:26'),
(1177, 335, 2, '2026-04-29 09:44:26'),
(1178, 335, 3, '2026-04-29 09:44:26'),
(1179, 335, 4, '2026-04-29 09:44:26'),
(1180, 335, 5, '2026-04-29 09:44:26'),
(1181, 335, 6, '2026-04-29 09:44:26'),
(1182, 335, 7, '2026-04-29 09:44:26'),
(1183, 335, 8, '2026-04-29 09:44:26'),
(1184, 335, 9, '2026-04-29 09:44:26'),
(1185, 335, 10, '2026-04-29 09:44:26'),
(1186, 336, 1, '2026-04-29 09:44:26'),
(1187, 336, 2, '2026-04-29 09:44:26'),
(1188, 336, 3, '2026-04-29 09:44:26'),
(1189, 336, 4, '2026-04-29 09:44:26'),
(1190, 336, 5, '2026-04-29 09:44:26'),
(1191, 336, 6, '2026-04-29 09:44:26'),
(1192, 336, 7, '2026-04-29 09:44:26'),
(1193, 336, 8, '2026-04-29 09:44:26'),
(1194, 336, 9, '2026-04-29 09:44:26'),
(1195, 336, 10, '2026-04-29 09:44:26'),
(1196, 337, 1, '2026-04-29 09:44:26'),
(1197, 337, 2, '2026-04-29 09:44:26'),
(1198, 337, 3, '2026-04-29 09:44:26'),
(1199, 337, 4, '2026-04-29 09:44:26'),
(1200, 337, 5, '2026-04-29 09:44:26'),
(1201, 337, 6, '2026-04-29 09:44:26'),
(1202, 337, 7, '2026-04-29 09:44:26'),
(1203, 337, 8, '2026-04-29 09:44:26'),
(1204, 337, 9, '2026-04-29 09:44:26'),
(1205, 337, 10, '2026-04-29 09:44:26'),
(1206, 338, 1, '2026-04-29 09:44:26'),
(1207, 338, 2, '2026-04-29 09:44:26'),
(1208, 338, 3, '2026-04-29 09:44:26'),
(1209, 338, 4, '2026-04-29 09:44:26'),
(1210, 338, 5, '2026-04-29 09:44:26'),
(1211, 338, 6, '2026-04-29 09:44:26'),
(1212, 338, 7, '2026-04-29 09:44:26'),
(1213, 338, 8, '2026-04-29 09:44:26'),
(1214, 338, 9, '2026-04-29 09:44:26'),
(1215, 338, 10, '2026-04-29 09:44:26'),
(1216, 339, 1, '2026-04-29 09:44:26'),
(1217, 339, 2, '2026-04-29 09:44:26'),
(1218, 339, 3, '2026-04-29 09:44:26'),
(1219, 339, 4, '2026-04-29 09:44:26'),
(1220, 339, 5, '2026-04-29 09:44:26'),
(1221, 339, 6, '2026-04-29 09:44:26'),
(1222, 339, 7, '2026-04-29 09:44:26'),
(1223, 339, 8, '2026-04-29 09:44:26'),
(1224, 339, 9, '2026-04-29 09:44:26'),
(1225, 339, 10, '2026-04-29 09:44:26'),
(1226, 340, 1, '2026-04-29 09:44:26'),
(1227, 340, 2, '2026-04-29 09:44:26'),
(1228, 340, 3, '2026-04-29 09:44:26'),
(1229, 340, 4, '2026-04-29 09:44:26'),
(1230, 340, 5, '2026-04-29 09:44:26'),
(1231, 340, 6, '2026-04-29 09:44:26'),
(1232, 340, 7, '2026-04-29 09:44:26'),
(1233, 340, 8, '2026-04-29 09:44:26'),
(1234, 340, 9, '2026-04-29 09:44:26'),
(1235, 340, 10, '2026-04-29 09:44:26'),
(1236, 341, 1, '2026-04-29 09:44:26'),
(1237, 341, 2, '2026-04-29 09:44:26'),
(1238, 341, 3, '2026-04-29 09:44:26'),
(1239, 341, 4, '2026-04-29 09:44:26'),
(1240, 341, 5, '2026-04-29 09:44:26'),
(1241, 341, 6, '2026-04-29 09:44:26'),
(1242, 341, 7, '2026-04-29 09:44:26'),
(1243, 341, 8, '2026-04-29 09:44:26'),
(1244, 341, 9, '2026-04-29 09:44:26'),
(1245, 341, 10, '2026-04-29 09:44:26'),
(1246, 342, 1, '2026-04-29 09:44:26'),
(1247, 342, 2, '2026-04-29 09:44:26'),
(1248, 342, 3, '2026-04-29 09:44:26'),
(1249, 342, 4, '2026-04-29 09:44:26'),
(1250, 342, 5, '2026-04-29 09:44:26'),
(1251, 342, 6, '2026-04-29 09:44:26'),
(1252, 342, 7, '2026-04-29 09:44:26'),
(1253, 342, 8, '2026-04-29 09:44:26'),
(1254, 342, 9, '2026-04-29 09:44:26'),
(1255, 342, 10, '2026-04-29 09:44:26'),
(1256, 343, 1, '2026-04-29 09:44:26'),
(1257, 343, 2, '2026-04-29 09:44:26'),
(1258, 343, 3, '2026-04-29 09:44:26'),
(1259, 343, 4, '2026-04-29 09:44:26'),
(1260, 343, 5, '2026-04-29 09:44:26'),
(1261, 343, 6, '2026-04-29 09:44:26'),
(1262, 343, 7, '2026-04-29 09:44:26'),
(1263, 343, 8, '2026-04-29 09:44:26'),
(1264, 343, 9, '2026-04-29 09:44:26'),
(1265, 343, 10, '2026-04-29 09:44:26'),
(1266, 344, 1, '2026-04-29 09:44:26'),
(1267, 344, 2, '2026-04-29 09:44:26'),
(1268, 344, 3, '2026-04-29 09:44:26'),
(1269, 344, 4, '2026-04-29 09:44:26'),
(1270, 344, 5, '2026-04-29 09:44:26'),
(1271, 344, 6, '2026-04-29 09:44:26'),
(1272, 344, 7, '2026-04-29 09:44:26'),
(1273, 344, 8, '2026-04-29 09:44:26'),
(1274, 344, 9, '2026-04-29 09:44:26'),
(1275, 344, 10, '2026-04-29 09:44:26'),
(1276, 345, 1, '2026-04-29 09:44:26'),
(1277, 345, 2, '2026-04-29 09:44:26'),
(1278, 345, 3, '2026-04-29 09:44:26'),
(1279, 345, 4, '2026-04-29 09:44:26'),
(1280, 345, 5, '2026-04-29 09:44:26'),
(1281, 345, 6, '2026-04-29 09:44:26'),
(1282, 345, 7, '2026-04-29 09:44:26'),
(1283, 345, 8, '2026-04-29 09:44:26'),
(1284, 345, 9, '2026-04-29 09:44:26'),
(1285, 345, 10, '2026-04-29 09:44:26'),
(1286, 346, 1, '2026-04-29 09:44:26'),
(1287, 346, 2, '2026-04-29 09:44:26'),
(1288, 346, 3, '2026-04-29 09:44:26'),
(1289, 346, 4, '2026-04-29 09:44:26'),
(1290, 346, 5, '2026-04-29 09:44:26'),
(1291, 346, 6, '2026-04-29 09:44:26'),
(1292, 346, 7, '2026-04-29 09:44:26'),
(1293, 346, 8, '2026-04-29 09:44:26'),
(1294, 346, 9, '2026-04-29 09:44:26'),
(1295, 346, 10, '2026-04-29 09:44:26'),
(1296, 347, 1, '2026-04-29 09:44:26'),
(1297, 347, 2, '2026-04-29 09:44:26'),
(1298, 347, 3, '2026-04-29 09:44:26'),
(1299, 347, 4, '2026-04-29 09:44:26'),
(1300, 347, 5, '2026-04-29 09:44:26'),
(1301, 347, 6, '2026-04-29 09:44:26'),
(1302, 347, 7, '2026-04-29 09:44:26'),
(1303, 347, 8, '2026-04-29 09:44:26'),
(1304, 347, 9, '2026-04-29 09:44:26'),
(1305, 347, 10, '2026-04-29 09:44:26'),
(1306, 348, 1, '2026-04-29 09:44:26'),
(1307, 348, 2, '2026-04-29 09:44:26'),
(1308, 348, 3, '2026-04-29 09:44:26'),
(1309, 348, 4, '2026-04-29 09:44:26'),
(1310, 348, 5, '2026-04-29 09:44:26'),
(1311, 348, 6, '2026-04-29 09:44:26'),
(1312, 348, 7, '2026-04-29 09:44:26'),
(1313, 348, 8, '2026-04-29 09:44:26'),
(1314, 348, 9, '2026-04-29 09:44:26'),
(1315, 348, 10, '2026-04-29 09:44:26'),
(1316, 349, 1, '2026-04-29 09:44:26'),
(1317, 349, 2, '2026-04-29 09:44:26'),
(1318, 349, 3, '2026-04-29 09:44:26'),
(1319, 349, 4, '2026-04-29 09:44:26'),
(1320, 349, 5, '2026-04-29 09:44:26'),
(1321, 349, 6, '2026-04-29 09:44:26'),
(1322, 349, 7, '2026-04-29 09:44:26'),
(1323, 349, 8, '2026-04-29 09:44:26'),
(1324, 349, 9, '2026-04-29 09:44:26'),
(1325, 349, 10, '2026-04-29 09:44:26'),
(1326, 350, 4, '2026-04-29 09:44:26'),
(1327, 351, 4, '2026-04-29 09:44:26'),
(1328, 352, 4, '2026-04-29 09:44:26'),
(1329, 353, 4, '2026-04-29 09:44:26'),
(1330, 354, 4, '2026-04-29 09:44:26'),
(1331, 355, 4, '2026-04-29 09:44:26'),
(1332, 356, 4, '2026-04-29 09:44:26'),
(1333, 357, 3, '2026-04-29 09:44:26'),
(1334, 358, 3, '2026-04-29 09:44:26'),
(1335, 359, 3, '2026-04-29 09:44:26'),
(1336, 360, 3, '2026-04-29 09:44:26'),
(1337, 361, 3, '2026-04-29 09:44:26'),
(1338, 362, 3, '2026-04-29 09:44:26'),
(1339, 363, 3, '2026-04-29 09:44:26'),
(1340, 364, 3, '2026-04-29 09:44:26'),
(1341, 365, 3, '2026-04-29 09:44:26'),
(1342, 366, 3, '2026-04-29 09:44:26'),
(1343, 367, 5, '2026-04-29 09:44:26'),
(1344, 368, 5, '2026-04-29 09:44:26'),
(1345, 369, 5, '2026-04-29 09:44:26'),
(1346, 370, 5, '2026-04-29 09:44:26'),
(1347, 371, 5, '2026-04-29 09:44:26'),
(1348, 372, 5, '2026-04-29 09:44:26'),
(1349, 373, 5, '2026-04-29 09:44:26'),
(1350, 374, 5, '2026-04-29 09:44:26'),
(1351, 375, 1, '2026-04-29 09:44:26'),
(1352, 376, 1, '2026-04-29 09:44:26'),
(1353, 377, 1, '2026-04-29 09:44:26'),
(1354, 378, 1, '2026-04-29 09:44:26'),
(1355, 379, 1, '2026-04-29 09:44:26'),
(1356, 380, 1, '2026-04-29 09:44:26'),
(1357, 381, 1, '2026-04-29 09:44:26'),
(1358, 382, 1, '2026-04-29 09:44:26'),
(1359, 383, 1, '2026-04-29 09:44:26'),
(1360, 384, 1, '2026-04-29 09:44:26'),
(1361, 385, 1, '2026-04-29 09:44:26'),
(1362, 386, 1, '2026-04-29 09:44:26'),
(1363, 387, 1, '2026-04-29 09:44:26'),
(1364, 388, 1, '2026-04-29 09:44:26'),
(1365, 389, 1, '2026-04-29 09:44:26'),
(1366, 390, 1, '2026-04-29 09:44:26'),
(1367, 391, 1, '2026-04-29 09:44:26'),
(1368, 392, 1, '2026-04-29 09:44:26'),
(1369, 393, 1, '2026-04-29 09:44:26'),
(1370, 394, 1, '2026-04-29 09:44:26'),
(1371, 395, 1, '2026-04-29 09:44:26'),
(1372, 396, 1, '2026-04-29 09:44:26'),
(1373, 397, 6, '2026-04-29 09:44:26'),
(1374, 398, 6, '2026-04-29 09:44:26'),
(1375, 399, 6, '2026-04-29 09:44:26'),
(1376, 400, 6, '2026-04-29 09:44:26'),
(1377, 401, 6, '2026-04-29 09:44:26'),
(1378, 402, 6, '2026-04-29 09:44:26'),
(1379, 403, 6, '2026-04-29 09:44:26'),
(1380, 404, 6, '2026-04-29 09:44:26'),
(1381, 405, 6, '2026-04-29 09:44:26'),
(1382, 406, 6, '2026-04-29 09:44:26'),
(1383, 407, 6, '2026-04-29 09:44:26'),
(1384, 408, 6, '2026-04-29 09:44:26'),
(1385, 409, 9, '2026-04-29 09:44:26'),
(1386, 410, 9, '2026-04-29 09:44:26'),
(1387, 411, 9, '2026-04-29 09:44:26'),
(1388, 412, 9, '2026-04-29 09:44:26'),
(1389, 413, 9, '2026-04-29 09:44:26'),
(1390, 414, 9, '2026-04-29 09:44:26'),
(1391, 415, 4, '2026-04-29 09:44:26'),
(1392, 416, 4, '2026-04-29 09:44:26'),
(1393, 417, 4, '2026-04-29 09:44:26'),
(1394, 418, 4, '2026-04-29 09:44:26'),
(1395, 419, 4, '2026-04-29 09:44:26'),
(1396, 420, 4, '2026-04-29 09:44:26'),
(1397, 421, 6, '2026-04-29 09:44:26'),
(1398, 422, 9, '2026-04-29 09:44:26'),
(1399, 423, 9, '2026-04-29 09:44:26'),
(1400, 424, 9, '2026-04-29 09:44:26'),
(1401, 425, 6, '2026-04-29 09:44:26'),
(1402, 426, 9, '2026-04-29 09:44:26'),
(1403, 427, 9, '2026-04-29 09:44:26'),
(1404, 428, 6, '2026-04-29 09:44:26'),
(1405, 429, 6, '2026-04-29 09:44:26'),
(1406, 430, 6, '2026-04-29 09:44:26'),
(1407, 431, 2, '2026-04-29 09:44:26'),
(1408, 432, 6, '2026-04-29 09:44:26'),
(1409, 433, 6, '2026-04-29 09:44:26'),
(1410, 434, 6, '2026-04-29 09:44:26'),
(1411, 435, 6, '2026-04-29 09:44:26'),
(1412, 436, 2, '2026-04-29 09:44:26'),
(1413, 437, 4, '2026-04-29 09:44:26'),
(1414, 438, 3, '2026-04-29 09:44:26'),
(1415, 439, 3, '2026-04-29 09:44:26'),
(1416, 440, 3, '2026-04-29 09:44:26'),
(1417, 441, 3, '2026-04-29 09:44:26'),
(1418, 442, 3, '2026-04-29 09:44:26'),
(1419, 443, 3, '2026-04-29 09:44:26'),
(1420, 444, 3, '2026-04-29 09:44:26'),
(1421, 445, 3, '2026-04-29 09:44:26'),
(1422, 446, 3, '2026-04-29 09:44:26'),
(1423, 447, 3, '2026-04-29 09:44:26'),
(1424, 448, 3, '2026-04-29 09:44:26'),
(1425, 449, 3, '2026-04-29 09:44:26'),
(1426, 450, 3, '2026-04-29 09:44:26'),
(1427, 451, 3, '2026-04-29 09:44:26'),
(1428, 452, 3, '2026-04-29 09:44:26'),
(1429, 453, 3, '2026-04-29 09:44:26'),
(1430, 454, 4, '2026-04-29 09:44:26'),
(1431, 455, 2, '2026-04-29 09:44:26'),
(1432, 456, 9, '2026-04-29 09:44:26'),
(1433, 457, 6, '2026-04-29 09:44:26'),
(1434, 458, 1, '2026-04-29 09:44:26'),
(1435, 458, 2, '2026-04-29 09:44:26'),
(1436, 458, 3, '2026-04-29 09:44:26'),
(1437, 458, 4, '2026-04-29 09:44:26'),
(1438, 458, 5, '2026-04-29 09:44:26'),
(1439, 458, 6, '2026-04-29 09:44:26'),
(1440, 458, 7, '2026-04-29 09:44:26'),
(1441, 458, 8, '2026-04-29 09:44:26'),
(1442, 458, 9, '2026-04-29 09:44:26'),
(1443, 458, 10, '2026-04-29 09:44:26'),
(1444, 459, 9, '2026-04-29 09:44:26'),
(1445, 460, 1, '2026-04-29 09:44:26'),
(1446, 460, 2, '2026-04-29 09:44:26'),
(1447, 460, 3, '2026-04-29 09:44:26'),
(1448, 460, 4, '2026-04-29 09:44:26'),
(1449, 460, 5, '2026-04-29 09:44:26'),
(1450, 460, 6, '2026-04-29 09:44:26'),
(1451, 460, 7, '2026-04-29 09:44:26'),
(1452, 460, 8, '2026-04-29 09:44:26'),
(1453, 460, 9, '2026-04-29 09:44:26'),
(1454, 460, 10, '2026-04-29 09:44:26'),
(1455, 461, 3, '2026-04-29 09:44:26'),
(1456, 462, 1, '2026-04-29 09:44:26'),
(1457, 462, 2, '2026-04-29 09:44:26'),
(1458, 462, 3, '2026-04-29 09:44:26');
INSERT INTO `document_departments` (`id`, `document_id`, `department_id`, `distributed_at`) VALUES
(1459, 462, 4, '2026-04-29 09:44:26'),
(1460, 462, 5, '2026-04-29 09:44:26'),
(1461, 462, 6, '2026-04-29 09:44:26'),
(1462, 462, 7, '2026-04-29 09:44:26'),
(1463, 462, 8, '2026-04-29 09:44:26'),
(1464, 462, 9, '2026-04-29 09:44:26'),
(1465, 462, 10, '2026-04-29 09:44:26'),
(1466, 463, 1, '2026-04-29 09:44:26'),
(1467, 463, 2, '2026-04-29 09:44:26'),
(1468, 463, 3, '2026-04-29 09:44:26'),
(1469, 463, 4, '2026-04-29 09:44:26'),
(1470, 463, 5, '2026-04-29 09:44:26'),
(1471, 463, 6, '2026-04-29 09:44:26'),
(1472, 463, 7, '2026-04-29 09:44:26'),
(1473, 463, 8, '2026-04-29 09:44:26'),
(1474, 463, 9, '2026-04-29 09:44:26'),
(1475, 463, 10, '2026-04-29 09:44:26'),
(1476, 464, 1, '2026-04-29 09:44:26'),
(1477, 464, 2, '2026-04-29 09:44:26'),
(1478, 464, 3, '2026-04-29 09:44:26'),
(1479, 464, 4, '2026-04-29 09:44:26'),
(1480, 464, 5, '2026-04-29 09:44:26'),
(1481, 464, 6, '2026-04-29 09:44:26'),
(1482, 464, 7, '2026-04-29 09:44:26'),
(1483, 464, 8, '2026-04-29 09:44:26'),
(1484, 464, 9, '2026-04-29 09:44:26'),
(1485, 464, 10, '2026-04-29 09:44:26'),
(1486, 465, 1, '2026-04-29 09:44:26'),
(1487, 465, 2, '2026-04-29 09:44:26'),
(1488, 465, 3, '2026-04-29 09:44:26'),
(1489, 465, 4, '2026-04-29 09:44:26'),
(1490, 465, 5, '2026-04-29 09:44:26'),
(1491, 465, 6, '2026-04-29 09:44:26'),
(1492, 465, 7, '2026-04-29 09:44:26'),
(1493, 465, 8, '2026-04-29 09:44:26'),
(1494, 465, 9, '2026-04-29 09:44:26'),
(1495, 465, 10, '2026-04-29 09:44:26'),
(1496, 466, 4, '2026-04-29 09:44:26'),
(1497, 467, 4, '2026-04-29 09:44:26'),
(1498, 468, 4, '2026-04-29 09:44:26'),
(1499, 469, 4, '2026-04-29 09:44:26'),
(1500, 470, 4, '2026-04-29 09:44:26'),
(1501, 471, 4, '2026-04-29 09:44:26'),
(1502, 472, 4, '2026-04-29 09:44:26'),
(1503, 473, 4, '2026-04-29 09:44:26'),
(1504, 474, 4, '2026-04-29 09:44:26'),
(1505, 475, 4, '2026-04-29 09:44:26'),
(1506, 476, 4, '2026-04-29 09:44:26'),
(1507, 477, 4, '2026-04-29 09:44:26'),
(1508, 478, 4, '2026-04-29 09:44:26'),
(1509, 479, 4, '2026-04-29 09:44:26'),
(1510, 480, 4, '2026-04-29 09:44:26'),
(1511, 481, 4, '2026-04-29 09:44:26'),
(1512, 482, 4, '2026-04-29 09:44:26'),
(1513, 483, 4, '2026-04-29 09:44:26'),
(1514, 484, 4, '2026-04-29 09:44:26'),
(1515, 485, 4, '2026-04-29 09:44:26'),
(1516, 486, 1, '2026-04-29 09:44:26'),
(1517, 486, 2, '2026-04-29 09:44:26'),
(1518, 486, 3, '2026-04-29 09:44:26'),
(1519, 486, 4, '2026-04-29 09:44:26'),
(1520, 486, 5, '2026-04-29 09:44:26'),
(1521, 486, 6, '2026-04-29 09:44:26'),
(1522, 486, 7, '2026-04-29 09:44:26'),
(1523, 486, 8, '2026-04-29 09:44:26'),
(1524, 486, 9, '2026-04-29 09:44:26'),
(1525, 486, 10, '2026-04-29 09:44:26'),
(1526, 487, 1, '2026-04-29 09:44:26'),
(1527, 487, 2, '2026-04-29 09:44:26'),
(1528, 487, 3, '2026-04-29 09:44:26'),
(1529, 487, 4, '2026-04-29 09:44:26'),
(1530, 487, 5, '2026-04-29 09:44:26'),
(1531, 487, 6, '2026-04-29 09:44:26'),
(1532, 487, 7, '2026-04-29 09:44:26'),
(1533, 487, 8, '2026-04-29 09:44:26'),
(1534, 487, 9, '2026-04-29 09:44:26'),
(1535, 487, 10, '2026-04-29 09:44:26'),
(1536, 488, 1, '2026-04-29 09:44:26'),
(1537, 488, 2, '2026-04-29 09:44:26'),
(1538, 488, 3, '2026-04-29 09:44:26'),
(1539, 488, 4, '2026-04-29 09:44:26'),
(1540, 488, 5, '2026-04-29 09:44:26'),
(1541, 488, 6, '2026-04-29 09:44:26'),
(1542, 488, 7, '2026-04-29 09:44:26'),
(1543, 488, 8, '2026-04-29 09:44:26'),
(1544, 488, 9, '2026-04-29 09:44:26'),
(1545, 488, 10, '2026-04-29 09:44:26'),
(1546, 489, 1, '2026-04-29 09:44:26'),
(1547, 489, 2, '2026-04-29 09:44:26'),
(1548, 489, 3, '2026-04-29 09:44:26'),
(1549, 489, 4, '2026-04-29 09:44:26'),
(1550, 489, 5, '2026-04-29 09:44:26'),
(1551, 489, 6, '2026-04-29 09:44:26'),
(1552, 489, 7, '2026-04-29 09:44:26'),
(1553, 489, 8, '2026-04-29 09:44:26'),
(1554, 489, 9, '2026-04-29 09:44:26'),
(1555, 489, 10, '2026-04-29 09:44:26'),
(1556, 490, 1, '2026-04-29 09:44:26'),
(1557, 490, 2, '2026-04-29 09:44:26'),
(1558, 490, 3, '2026-04-29 09:44:26'),
(1559, 490, 4, '2026-04-29 09:44:26'),
(1560, 490, 5, '2026-04-29 09:44:26'),
(1561, 490, 6, '2026-04-29 09:44:26'),
(1562, 490, 7, '2026-04-29 09:44:26'),
(1563, 490, 8, '2026-04-29 09:44:26'),
(1564, 490, 9, '2026-04-29 09:44:26'),
(1565, 490, 10, '2026-04-29 09:44:26'),
(1566, 491, 1, '2026-04-29 09:44:26'),
(1567, 491, 2, '2026-04-29 09:44:26'),
(1568, 491, 3, '2026-04-29 09:44:26'),
(1569, 491, 4, '2026-04-29 09:44:26'),
(1570, 491, 5, '2026-04-29 09:44:26'),
(1571, 491, 6, '2026-04-29 09:44:26'),
(1572, 491, 7, '2026-04-29 09:44:26'),
(1573, 491, 8, '2026-04-29 09:44:26'),
(1574, 491, 9, '2026-04-29 09:44:26'),
(1575, 491, 10, '2026-04-29 09:44:26');

-- --------------------------------------------------------

--
-- Table structure for table `document_distributions`
--

CREATE TABLE `document_distributions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `document_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `distributed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `acknowledged_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `document_versions`
--

CREATE TABLE `document_versions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `document_id` bigint(20) UNSIGNED NOT NULL,
  `version` varchar(20) NOT NULL,
  `change_summary` text DEFAULT NULL,
  `changed_by_id` bigint(20) UNSIGNED NOT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `document_versions`
--

INSERT INTO `document_versions` (`id`, `document_id`, `version`, `change_summary`, `changed_by_id`, `file_path`, `approved_at`, `created_at`) VALUES
(2129, 2125, '1', 'Initial import', 38, '1671711806_1_Renewal_process.pdf', NULL, '2026-04-29 08:13:40'),
(2130, 2126, '1', 'Initial import', 38, '1750246935_194_Certificate59967.pdf', NULL, '2026-04-29 08:13:40'),
(2131, 2127, '1', 'Initial import', 44, '1750315769_194_Strategic_partnership_policy.pdf', NULL, '2026-04-29 08:13:40'),
(2132, 2128, '1', 'Initial import', 38, '1751268889_194_Electronic_Receipt_065_2183088365_Jithin_Varkey.pdf', NULL, '2026-04-29 08:13:40'),
(2133, 2129, '1TM0001', 'Initial import', 44, '1751351851_214_______________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2134, 2130, '1TM0001', 'Initial import', 44, '1751352335_214_Technical_and_Underwriting_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2135, 2131, '1TM0002', 'Initial import', 44, '1751352636_214_Letters_of_Undertaking_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2136, 2132, ' 1TM0003', 'Initial import', 44, '1751352776_214_Insurance_Quotation_Preparation_and_Documentation_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2137, 2133, '1TM0003', 'Initial import', 44, '1751352888_214_Insurance_Quotation_Preparation_and_Documentation_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2138, 2134, '1TM0004', 'Initial import', 44, '1751352973_214_Contractual_Clarity_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2139, 2135, '1TM0005', 'Initial import', 44, '1751353978_214_Emergency_Response_and_Business_Continuity_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2140, 2136, '1TM0006', 'Initial import', 44, '1751354052_214_Disaster_Recovery_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2141, 2137, '1TM0007', 'Initial import', 44, '1751354124_214_Errors_and_Omissions_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2142, 2138, '1TM0008', 'Initial import', 44, '1751354259_214_Insurance_Company_Engagement_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2143, 2139, '1TM0009', 'Initial import', 44, '1751354658_214_Insurance_Company_Relationship_Management_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2144, 2140, '1TM0010', 'Initial import', 44, '1751355476_214_Insurance_Portfolio_Analysis_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2145, 2141, '1TM0011', 'Initial import', 44, '1751355768_214_Whistleblowing_and_Violations_Reporting_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2146, 2142, '1TM0012', 'Initial import', 44, '1751356100_214_Client_Premium_Collection_Confirmation_Before_Policy_Issuance_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2147, 2143, '1TM0013', 'Initial import', 44, '1751356242_214_Issuance_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2148, 2144, '1TM0014', 'Initial import', 44, '1751356381_214_General_Policy_for_Periodic_Inspection_and_Review_of_Technical_Survey_Reports___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2149, 2145, '1TM0015', 'Initial import', 44, '1751356484_214_Insurance_Claims_and_Electronic_Archiving_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2150, 2146, '1TM0016', 'Initial import', 44, '1751356580_214_Client_Business_Terms_Agreement_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2151, 2147, '1LCM0001', 'Initial import', 44, '1751361731_214_Regulatory_Compliance_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2152, 2148, '1LCM0002', 'Initial import', 44, '1751361824_214_Anti_Corruption_and_Anti_Bribery_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2153, 2149, '1LCM0003', 'Initial import', 44, '1751361864_214_Anti_Money_Laundering_and_Counter_Terrorism_Financing_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2154, 2150, '1LCM0004', 'Initial import', 44, '1751362218_214_Whistleblower_Protection_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2155, 2151, '1LCM0005', 'Initial import', 44, '1751362281_214_Risk_Management_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2156, 2152, '1LCM0006', 'Initial import', 44, '1751362370_214_Information_Classification__Security__and_Disposal_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2157, 2153, '1LCM0007', 'Initial import', 44, '1751362561_214_File_Review_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2158, 2154, '1LCM0008', 'Initial import', 44, '1751362672_214_Internal_Audit_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2159, 2155, '1LCM0008', 'Initial import', 44, '1751362961_214_Internal_Audit_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2160, 2156, '1LCM0010', 'Initial import', 44, '1751363067_214_External_Agency_Agreement_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2161, 2157, '1LCM0011', 'Initial import', 44, '1751363188_214_Outsourcing_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2162, 2158, '1LCM0012', 'Initial import', 44, '1751363406_214_Compliance_with_International_and_Local_Standards_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2163, 2159, 'NULL', 'Initial import', 38, '1751541639_194__________________________________________2024_1.pdf', NULL, '2026-04-29 08:13:40'),
(2164, 2160, 'NULL', 'Initial import', 38, '1751541922_194___________________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2165, 2161, 'NULL', 'Initial import', 38, '1751541948_194___________________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2166, 2162, 'HR250518', 'Initial import', 38, '1751542050_194_______________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2167, 2163, 'NULL', 'Initial import', 38, '1751542183_194_______________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2168, 2164, 'NULL', 'Initial import', 38, '1751542303_194_____________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2169, 2165, 'NULL', 'Initial import', 38, '1751542463_194_____________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2170, 2166, 'NULL', 'Initial import', 38, '1751542564_194________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2171, 2167, 'NULL', 'Initial import', 38, '1751542652_194___________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2172, 2168, 'HR250408', 'Initial import', 38, '1751542743_194__________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2173, 2169, 'NULL', 'Initial import', 38, '1751542834_194_______.pdf', NULL, '2026-04-29 08:13:40'),
(2174, 2170, 'NULL', 'Initial import', 38, '1751542914_194__________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2175, 2171, 'NULL', 'Initial import', 38, '1751542992_194______________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2176, 2172, '1FM0001', 'Initial import', 44, '1751787372_214_General_Financial_Affairs_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2177, 2173, '1FM0002', 'Initial import', 44, '1751787442_214_Budget_Planning_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2178, 2174, '1FM0003', 'Initial import', 44, '1751787525_214_Financial_Reporting_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2179, 2175, '1FM0004', 'Initial import', 44, '1751787611_214_Accounting_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2180, 2176, '1FM0005', 'Initial import', 44, '1751787741_214_External_Financial_Transactions_and_Transfers_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2181, 2177, '1FM0006', 'Initial import', 44, '1751787908_214_Expenses_and_Payments_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2182, 2178, '1FM0006', 'Initial import', 44, '1751788358_214_Expenses_and_Payments_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2183, 2179, '1FM0007', 'Initial import', 44, '1751788484_214_Financial_Dealings_with_Insurance_Companies_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2184, 2180, '1FM0008', 'Initial import', 44, '1751788562_214_Petty_Cash_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2185, 2181, '1FM0009', 'Initial import', 44, '1751788698_214_Capital_Expenditure_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2186, 2182, '1FM0010', 'Initial import', 44, '1751788885_214_Investment_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2187, 2183, '1FM0011', 'Initial import', 44, '1751789001_214_Tax_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2188, 2184, '1FM0011', 'Initial import', 44, '1751789190_214_Tax_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2189, 2185, '1FM0012', 'Initial import', 44, '1751789273_214_Financial_Closing_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2190, 2186, '1FM0013', 'Initial import', 44, '1751789358_214_Credit_Control_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2191, 2187, '1FM0014', 'Initial import', 44, '1751789452_214_Operational_Loss_Reporting_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2192, 2188, '1FM0015', 'Initial import', 44, '1751791247_214_Accounting_Reconciliation_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2193, 2189, '1FM0016', 'Initial import', 44, '1751791308_214_External_Auditor_and_Legal_Accountant_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2194, 2190, '1FM0017', 'Initial import', 44, '1751791415_214_Commission_Disbursement_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2195, 2191, '1FM0018', 'Initial import', 44, '1751791472_214_Financial_Risk_Management_and_Debt_Aging_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2196, 2192, '2FM0017', 'Initial import', 44, '1751791678_214_Commission_Disbursement_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2197, 2193, '1FM0019', 'Initial import', 44, '1751791947_214_Debt_Collection_and_Aging_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2198, 2194, '1FM0020', 'Initial import', 44, '1751792029_214_Financial_Segregation_of_Duties_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2199, 2195, '1FM0021', 'Initial import', 44, '1751792176_214_Financial_Records_Management_and_Archiving_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2200, 2196, '1FM0023', 'Initial import', 44, '1751792373_214_Financial_Data_Protection_and_Confidentiality_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2201, 2197, 'v1.0', 'Initial import', 44, '1751793163_214_Financial_Procedures___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2202, 2198, 'v1.0', 'Initial import', 44, '1751793195_214_Financial_Procedures___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2203, 2199, 'v1.0', 'Initial import', 54, '1751796750_214_Tinancial_Procedures____Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2204, 2200, 'v1.0', 'Initial import', 44, '1751799437_214_Compliance_Procedures___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2205, 2201, '1LCM0009', 'Initial import', 44, '1752655593_214_Anti_Fraud_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2206, 2202, '1LCM0012', 'Initial import', 44, '1752655946_214_Business_Continuity_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2207, 2203, '1HRM0002', 'Initial import', 54, '1753172892_214_Anti_Sexual_Harassment_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2208, 2204, '1HRM0003', 'Initial import', 54, '1753172970_214_Succession_and_Replacement_Policy__Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2209, 2205, '1HRM0004', 'Initial import', 44, '1753173260_214_Corporate_Social_Responsibility__CSR__Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2210, 2206, '1HRM0008', 'Initial import', 44, '1753175310_214_Employee_Onboarding_and_Orientation_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2211, 2207, '1HRM0010', 'Initial import', 44, '1753175403_214_Allowances_and_Promotions_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2212, 2208, '1HRM0013', 'Initial import', 44, '1753175546_214_Business_Travel_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2213, 2209, '1HRM0014', 'Initial import', 44, '1753175592_214_Entertainment_and_Hospitality_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2214, 2210, '1HRM0016', 'Initial import', 44, '1753175688_214_Training_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2215, 2211, '1HRM0016', 'Initial import', 44, '1753176878_214_Training_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2216, 2212, '1HRM0019', 'Initial import', 44, '1753176961_214_Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2217, 2213, '1HRM0019', 'Initial import', 44, '1753177045_214_Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2218, 2214, '1HRM0020', 'Initial import', 44, '1753177098_214_Security_and_Confidentiality_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2219, 2215, '1HRM0006', 'Initial import', 54, '1753340794_214_General_Human_Resources_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2220, 2216, '1HRM0007', 'Initial import', 44, '1753340867_214_Recruitment_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2221, 2217, '1HRM0010', 'Initial import', 44, '1753340923_214_Employee_Rewards_and_Compensation_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2222, 2218, '1HRM0012', 'Initial import', 54, '1753340971_214_Employee_Termination_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2223, 2219, '1HRM0015', 'Initial import', 54, '1753341020_214_Employee_Performance_Evaluation_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2224, 2220, '1HRM0017', 'Initial import', 44, '1753341059_214_Career_Development_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2225, 2221, '1HRM0018', 'Initial import', 44, '1753341131_214_Employee_Complaints_and_Disciplinary_Actions_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2226, 2222, '1HRM0021', 'Initial import', 44, '1753341181_214_Remote_Work_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2227, 2223, '1HRM0005', 'Initial import', 54, '1753353099_214_Loan_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2228, 2224, '1HRM0009', 'Initial import', 54, '1753353198_214_Leave_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2229, 2225, '1HRM0001', 'Initial import', 54, '1753353237_214_Attendance_and_Punctuality_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2230, 2226, '1HRM0022', 'Initial import', 54, '1753353392_214_Employee_Transfer_and_Delegation_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2231, 2227, '1SMM0001', 'Initial import', 44, '1753701365_214_Sales_and_Marketing_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2232, 2228, '1SMM0003', 'Initial import', 44, '1753701598_214_General_Marketing_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2233, 2229, '1SMM0004', 'Initial import', 44, '1753701666_214_Branding_and_Advertising_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2234, 2230, '1SMM0005', 'Initial import', 44, '1753701747_214_Client_Communication_and_Interaction_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2235, 2231, '1SMM0006', 'Initial import', 44, '1753701849_214_Promotional_Materials_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2236, 2232, '1SMM0007', 'Initial import', 44, '1753701885_214_Market_Research_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2237, 2233, '1SMM0008', 'Initial import', 44, '1753701919_214_Sales_and_Marketing_Protocols_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2238, 2234, '1SMM0009', 'Initial import', 44, '1753702122_214_Services_and_Events_Management_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2239, 2235, '1SMM0010', 'Initial import', 44, '1753702197_214_Marketing_Agencies_Management_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2240, 2236, '1SMM0011', 'Initial import', 44, '1753702266_214_Sales_Practices_Policy__Transparency_and_Clarity__Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2241, 2237, '1SMM0012', 'Initial import', 44, '1753702308_214_Sales_Staff_Qualification_and_Accreditation_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2242, 2238, '1SMM0013', 'Initial import', 44, '1753702367_214_Insurance_Product_Disclosure_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2243, 2239, '1SMM0014', 'Initial import', 44, '1753702428_214_Diamond_Authorization_Limits_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2244, 2240, '1SMM0015', 'Initial import', 44, '1753702454_214_Special_Offers_and_Promotional_Campaigns_Management_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2245, 2241, '1SMM0016', 'Initial import', 44, '1753702540_214_Cross_selling_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2246, 2242, '1SMM0017', 'Initial import', 44, '1753702580_214_Sales_Performance_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2247, 2243, '1SMM0018', 'Initial import', 44, '1753702613_214_Sales_Support_Activities_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2248, 2244, '1SMM0019', 'Initial import', 44, '1753702673_214_Product_Development_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2249, 2245, '1SMM0020', 'Initial import', 44, '1753702698_214_Lead_Generation_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2250, 2246, '1SMM0002', 'Initial import', 44, '1753702768_214_Client_Communication_Follow_up_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2251, 2247, 'v1.0', 'Initial import', 44, '1753704241_214_Sales_procedures___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2252, 2248, 'v1.0', 'Initial import', 44, '1753705364_214_Marketing_procedures___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2253, 2249, '1SMM0010', 'Initial import', 44, '1753778268_214_Marketing_Agencies_Management_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2254, 2250, '1ITM0001', 'Initial import', 44, '1753788000_214_Information_Technology_Governance_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2255, 2251, '1ITM0002', 'Initial import', 44, '1753788154_214_Information_Technology_Management_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2256, 2252, '1ITM0003', 'Initial import', 44, '1753788438_214_Information_Technology_User_Security_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2257, 2253, '1ITM0004', 'Initial import', 44, '1753788571_214_Information_Technology_Systems_Security_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2258, 2254, '1ITM0005', 'Initial import', 44, '1753788672_214_Information_Technology_Devices_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2259, 2255, '1ITM0006', 'Initial import', 44, '1753788749_214_Information_Technology_Software_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2260, 2256, '1ITM0007', 'Initial import', 44, '1753788851_214_Telephone_and_Communication_Systems_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2261, 2257, '1ITM0008', 'Initial import', 44, '1753788922_214_Administrative_Information_Management_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2262, 2258, '1ITM0009', 'Initial import', 44, '1753788981_214_Website_Management_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2263, 2259, '1ITM0011', 'Initial import', 44, '1753789137_214_Backup_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2264, 2260, '1ITM0012', 'Initial import', 44, '1753789191_214_Access_Management_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2265, 2261, '1ITM0013', 'Initial import', 44, '1753789249_214_Email_and_Internet_Usage_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2266, 2262, '1ITM0014', 'Initial import', 44, '1753789350_214_Software_Updates_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2267, 2263, '1QDM0001', 'Initial import', 44, '1753868709_214_Strategic_Partnerships_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2268, 2264, '1QDM0002', 'Initial import', 44, '1753868787_214_Partner_Management_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2269, 2265, '1QDM0003', 'Initial import', 44, '1753868844_214_Quality_and_Development_Management_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2270, 2266, '1QDM0004', 'Initial import', 44, '1753868899_214_Service_Level_Agreements__SLA__Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2271, 2267, '1QDM0005', 'Initial import', 44, '1753868939_214_Continuous_Improvement_Management_Policy___PDF.pdf', NULL, '2026-04-29 08:13:40'),
(2272, 2268, '1QDM0006', 'Initial import', 44, '1753869197_214_Operational_Performance_Analysis_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2273, 2269, '1QDM0007', 'Initial import', 44, '1753869253_214_Risk_Management_Policy_Related_to_Quality___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2274, 2270, '1QDM0008', 'Initial import', 44, '1753869403_214_Client_Satisfaction_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2275, 2271, '1QDM0009', 'Initial import', 44, '1753869428_214_Employee_Satisfaction_Policy___Aarbic.pdf', NULL, '2026-04-29 08:13:40'),
(2276, 2272, '1QDM0010', 'Initial import', 44, '1753869535_214_Workplace_Environment_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2277, 2273, '1QDM0011', 'Initial import', 44, '1753869571_214_Policy_for_Creating_Policies_and_Procedures_for_Uncontrolled_Work___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2278, 2274, '1ITM0010', 'Initial import', 44, '1753870540_214_IT_Resources_Management_and_Security_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2279, 2275, 'v1.0', 'Initial import', 54, '1753874943_214_Cybersecurity_Procedures___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2280, 2276, '1HRM0016', 'Initial import', 54, '1753951571_214_Training_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2281, 2277, '1HRM0019', 'Initial import', 54, '1753951705_214_Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2282, 2278, '1HRM0020', 'Initial import', 54, '1753951808_214_Security_and_Confidentiality_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2283, 2279, '1HRM0008', 'Initial import', 54, '1753951872_214_Employee_Onboarding_and_Orientation_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2284, 2280, '1HRM0011', 'Initial import', 54, '1753951947_214_Allowances_and_Promotions_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2285, 2281, '1HRM0014', 'Initial import', 54, '1753952026_214_Entertainment_and_Hospitality_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2286, 2282, '1HRM0013', 'Initial import', 54, '1753952082_214_Business_Travel_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2287, 2283, '1HRM0018', 'Initial import', 54, '1753952217_214_Employee_Complaints_and_Disciplinary_Actions_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2288, 2284, '1HRM0021', 'Initial import', 54, '1753952299_214_Remote_Work_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2289, 2285, '1HRM0004', 'Initial import', 54, '1753952372_214_Corporate_Social_Responsibility__CSR__Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2290, 2286, '1HRM0017', 'Initial import', 54, '1753952455_214_Career_Development_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2291, 2287, '1HRM0010', 'Initial import', 54, '1753952522_214_Employee_Rewards_and_Compensation_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2292, 2288, '1PD0001', 'Initial import', 44, '1753952785_214_Vendor_Management_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2293, 2289, '1PD0002', 'Initial import', 44, '1753952838_214_Procurement_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2294, 2290, '1PD0003', 'Initial import', 44, '1753952883_214_Health_and_Safety_Policy_Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2295, 2291, '1OM0001', 'Initial import', 44, '1753953836_214_Claims_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2296, 2292, '1OM0002', 'Initial import', 44, '1753953912_214_Daily_Operations_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2297, 2293, '1OM0002', 'Initial import', 44, '1753954381_214_Daily_Operations_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2298, 2294, '1OM0003', 'Initial import', 44, '1753954446_214_Renewals_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2299, 2295, '1OM0004', 'Initial import', 44, '1753954558_214_Immediate_Client_Response_Assurance_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2300, 2296, '1OM0005', 'Initial import', 44, '1753954659_214_General_Operations_Policy__Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2301, 2297, '1OM0006', 'Initial import', 44, '1753954896_214_Client_Care_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2302, 2298, '1OM0007', 'Initial import', 44, '1753954955_214_Client_Complaints_Management_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2303, 2299, '1OM0008', 'Initial import', 44, '1753955033_214_Client_Support_in_Handling_Insurance_Claims_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2304, 2300, '1OM0009', 'Initial import', 44, '1753955113_214_Regulatory_Policy_for_Insurance_Claims_Officers_and_Specialists___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2305, 2301, '1OM0010', 'Initial import', 44, '1753955181_214_Operations_Support_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2306, 2302, '1OM0011', 'Initial import', 44, '1753955243_214_General_Administration_Policy_for_the_Operations_Management___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2307, 2303, '1OM0012', 'Initial import', 44, '1753955298_214_Relations_with_Insurance_Companies_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2308, 2304, '1OM0013', 'Initial import', 44, '1753955354_214_Records_Retention_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2309, 2305, '1OM0014', 'Initial import', 44, '1753955400_214_Insurance_Broker_Change_Policy_During_Policy_Term___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2310, 2306, '1QDM0002', 'Initial import', 44, '1754147184_214_Partner_Management_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2311, 2307, '1PD0003', 'Initial import', 44, '1754147626_214_Health_and_Safety_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2312, 2308, 'v1.0', 'Initial import', 44, '1754149425_214_Information_Technology_Procedures___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2313, 2309, 'v1.0', 'Initial import', 44, '1754149509_214_Quality___Development_Procedures___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2314, 2310, 'v1.0', 'Initial import', 44, '1754210626_214_operations_procedures___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2315, 2311, '1EM0001', 'Initial import', 44, '1754217251_214_Delegation_of_Authority_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2316, 2312, '1EM0002', 'Initial import', 44, '1754217314_214_Board_Members____Remuneration_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2317, 2313, '1EM0003', 'Initial import', 44, '1754217474_214_Confidentiality_and_Information_Protection_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2318, 2314, '1EM0004', 'Initial import', 44, '1754217508_214_Non_Standard_Agreements_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2319, 2315, '1EM0005', 'Initial import', 44, '1754218070_214_Corporate_Governance_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2320, 2316, '1EM0006', 'Initial import', 44, '1754218221_214_Local_Oversight_Policy_for_the_CEO_and_Deputy_CEO___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2321, 2317, '1EM0007', 'Initial import', 44, '1754218592_214_Mergers_and_Acquisitions_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2322, 2318, '1EM0008', 'Initial import', 44, '1754218663_214_Board_Meetings_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2323, 2319, '1EM0009', 'Initial import', 44, '1754218728_214_General_Assembly_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2324, 2320, '1EM0010', 'Initial import', 44, '1754218759_214_Board_Secretary_Appointment_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2325, 2321, '1EM0011', 'Initial import', 44, '1754218810_214_Board_Decisions_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2326, 2322, '1EM0012', 'Initial import', 44, '1754218833_214_Quorum_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2327, 2323, '1EM0013', 'Initial import', 44, '1754218880_214_Board_Committees_Policy____Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2328, 2324, '1EM0014', 'Initial import', 44, '1754218936_214_Conflict_of_Interest_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2329, 2325, '1LCM0013', 'Initial import', 44, '1754805117_214_Business_Continuity_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2330, 2326, '1FM0022', 'Initial import', 44, '1754825842_214_Cash_Flow_Management_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2331, 2327, '1HRM0007', 'Initial import', 54, '1755772028_214_Employment_Policy____Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2332, 2328, '1HRM0002', 'Initial import', 44, '1755772369_214_Anti_Sexual_Harassment_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2333, 2329, '1TM0001', 'Initial import', 54, '1756978632_214_Technical___Underwriting_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2334, 2330, '1TM0002', 'Initial import', 44, '1756978686_214_Letters_of_Undertaking_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2335, 2331, '1TM0002', 'Initial import', 54, '1756978809_214_Letters_of_Undertaking_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2336, 2332, '1TM0003', 'Initial import', 54, '1756978938_214_Policy_for_Preparing_and_Documenting_Insurance_Quotation_Forms.pdf', NULL, '2026-04-29 08:13:40'),
(2337, 2333, '1TM0004', 'Initial import', 54, '1756978983_214_Contractual_Clarity_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2338, 2334, '1TM0005', 'Initial import', 54, '1756979470_214_Emergency_Response_and_Business_Continuity_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2339, 2335, '1TM0006', 'Initial import', 54, '1756979594_214_Disaster_Recovery_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2340, 2336, '1TM0007', 'Initial import', 54, '1756979679_214_Errors_and_Omissions__E_O__Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2341, 2337, '1TM0008', 'Initial import', 54, '1756979801_214_Insurance_Companies_Engagement_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2342, 2338, '1TM0007', 'Initial import', 44, '1756979867_214_Insurance_Companies_Relationship_Management_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2343, 2339, '1TM0009', 'Initial import', 54, '1756979919_214_Insurance_Companies_Relationship_Management_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2344, 2340, '1TM0010', 'Initial import', 54, '1756980041_214_Insurance_Portfolio_Analysis_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2345, 2341, '1TM0011', 'Initial import', 54, '1756980149_214_Whistleblowing_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2346, 2342, '1TM0012', 'Initial import', 54, '1756980235_214_Client_Premium_Collection_Confirmation_Before_Policy_Issuance_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2347, 2343, '1TM0014', 'Initial import', 54, '1756980365_214_General_Policy_for_Periodic_Inspection.pdf', NULL, '2026-04-29 08:13:40'),
(2348, 2344, '1TM0015', 'Initial import', 54, '1756980460_214_Insurance_Claims_Management_and_Electronic_Archiving_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2349, 2345, '1TM0016', 'Initial import', 54, '1756980537_214_Policy_on_Terms_of_Business_Agreements__TOBA__with_Clients.pdf', NULL, '2026-04-29 08:13:40'),
(2350, 2346, '1ITM0001', 'Initial import', 54, '1756981017_214____________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2351, 2347, '1ITM0002', 'Initial import', 54, '1756981245_214____________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2352, 2348, '1ITM0003', 'Initial import', 54, '1756981413_214_______________________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2353, 2349, '1ITM0004', 'Initial import', 54, '1756981499_214___________________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2354, 2350, '1ITM0005', 'Initial import', 54, '1756981622_214____________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2355, 2351, '1ITM0006', 'Initial import', 54, '1756981719_214_____________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2356, 2352, '1ITM0007', 'Initial import', 54, '1756981794_214___________________________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2357, 2353, '1ITM0008', 'Initial import', 54, '1756981896_214__________________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2358, 2354, '1ITM0009', 'Initial import', 54, '1756981971_214________________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2359, 2355, '1ITM0011', 'Initial import', 54, '1756982039_214_________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2360, 2356, '1ITM0012', 'Initial import', 54, '1756982119_214___________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2361, 2357, '1ITM0013', 'Initial import', 54, '1756982199_214_______________________________________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2362, 2358, '1ITM0014', 'Initial import', 54, '1756982301_214_____________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2363, 2359, '1ITM0010', 'Initial import', 54, '1756983216_214___________________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2364, 2360, '1TM0013', 'Initial import', 54, '1756983725_214_Issuance_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2365, 2361, 'V1', 'Initial import', 44, '1757241442_214_Information_Technology_Procedures.pdf', NULL, '2026-04-29 08:13:40'),
(2366, 2362, 'V1.0', 'Initial import', 54, '1757320491_242_Cybersecurity_Department_Procedures.pdf', NULL, '2026-04-29 08:13:40'),
(2367, 2363, '1ITM0001', 'Initial import', 54, '1757403101_242_IT_Governance_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2368, 2364, '1ITM0002', 'Initial import', 54, '1757403196_242_Information_Technology_Management_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2369, 2365, '1ITM0003', 'Initial import', 54, '1757403279_242_IT_User_Security_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2370, 2366, '1ITM0004', 'Initial import', 54, '1757403490_242_IT_Systems_Security_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2371, 2367, '1ITM0005', 'Initial import', 54, '1757403559_242_Information_Technology_Devices_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2372, 2368, '1ITM0006', 'Initial import', 54, '1757403675_242_Information_Technology_Software_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2373, 2369, '1ITM0007', 'Initial import', 54, '1757403762_242_Phone_and_Telecommunication_Systems_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2374, 2370, '1ITM0008', 'Initial import', 54, '1757403839_242_Administrative_Information_Management_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2375, 2371, '1ITM0009', 'Initial import', 54, '1757403922_242_Website_Management_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2376, 2372, '1ITM0010', 'Initial import', 54, '1757404009_242_Device_Resources_Management_and_Security_Policy_.pdf', NULL, '2026-04-29 08:13:40'),
(2377, 2373, '1ITM0011', 'Initial import', 54, '1757404117_242_Backup_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2378, 2374, '1ITM0012', 'Initial import', 54, '1757404186_242_Access_Management_Policy_.pdf', NULL, '2026-04-29 08:13:40'),
(2379, 2375, '1ITM0013', 'Initial import', 54, '1757404269_242_Email___Internet_Usage_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2380, 2376, '1ITM0014', 'Initial import', 54, '1757404355_242_Software_Update_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2381, 2377, '1TM0001', 'Initial import', 54, '1758201960_242_Policy_for_Organizing_and_Managing.pdf', NULL, '2026-04-29 08:13:40'),
(2382, 2378, '1TM0002', 'Initial import', 54, '1758202053_242_Policy_for_Preparing_and_Documenting_Insurance_Quotation_Forms.pdf', NULL, '2026-04-29 08:13:40'),
(2383, 2379, '1TM0003', 'Initial import', 54, '1758202151_242_Contractual_Clarity_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2384, 2380, '1TM0004', 'Initial import', 54, '1758202207_242_Emergency_Response__Disaster_Recovery__and_Business_Continuity_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2385, 2381, '1TM0005', 'Initial import', 54, '1758202250_242_Errors_and_Omissions__E_O__Policy_.pdf', NULL, '2026-04-29 08:13:40'),
(2386, 2382, '1TM0006', 'Initial import', 54, '1758202330_242_Policy_for_Dealing_and_Relations_with_Insurance_Companies.pdf', NULL, '2026-04-29 08:13:40'),
(2387, 2383, '1TM0007', 'Initial import', 54, '1758202372_242_Insurance_Portfolio_Analysis_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2388, 2384, '1TM0008', 'Initial import', 54, '1758202448_242_Whistleblowing_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2389, 2385, '1TM0009', 'Initial import', 54, '1758202527_242_Client_Premium_Collection_Confirmation.pdf', NULL, '2026-04-29 08:13:40'),
(2390, 2386, '1TM00010', 'Initial import', 54, '1758202574_242_Issuance_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2391, 2387, '1TM00012', 'Initial import', 54, '1758202782_242_Electronic_Archiving_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2392, 2388, '1TM00013', 'Initial import', 54, '1758202862_242_Policy_on_Terms_of_Business_Agreements__TOBA__with_Clients.pdf', NULL, '2026-04-29 08:13:40'),
(2393, 2389, 'NULL', 'Initial import', 54, '1758203050_242_Technical_Procedures.pdf', NULL, '2026-04-29 08:13:40'),
(2394, 2390, '2TM0011', 'Initial import', 44, '1760856315_214_General_Policy_for_Periodic_Inspection_and_Review_of_Technical_Surveyors____Reports.pdf', NULL, '2026-04-29 08:13:40'),
(2395, 2391, '1HRM0001', 'Initial import', 54, '1763292154_242_training_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2396, 2392, '1HRM0007', 'Initial import', 54, '1763292356_242_Recruitment_and_Hiring_Policy__.pdf', NULL, '2026-04-29 08:13:40'),
(2397, 2393, '1HRM0017', 'Initial import', 54, '1763292476_242_Career_Path_Development_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2398, 2394, '1HRM0004', 'Initial import', 54, '1763292538_242_Corporate_Social_Responsibility_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2399, 2395, '1HRM0021', 'Initial import', 54, '1763292602_242_Remote_Work_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2400, 2396, '1HRM0018', 'Initial import', 54, '1763292715_242_Complaints_and_Disciplinary_Procedures_Policy__.pdf', NULL, '2026-04-29 08:13:40'),
(2401, 2397, '1HRM0013', 'Initial import', 54, '1763292765_242_Business_Travel_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2402, 2398, '1HRM0014', 'Initial import', 54, '1763292808_242_Entertainment_and_Hospitality_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2403, 2399, '1HRM0011', 'Initial import', 54, '1763292876_242_allowances_and_Promotions_Policy__.pdf', NULL, '2026-04-29 08:13:40'),
(2404, 2400, '1HRM0008', 'Initial import', 54, '1763293106_242_Employee_Onboarding_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2405, 2401, '1HRM0020', 'Initial import', 54, '1763293214_242_security___Confidentiality_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2406, 2402, '1HRM0019', 'Initial import', 54, '1763293280_242_Employee_Rewards_and_Compensation_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2407, 2403, '1HRM0016', 'Initial import', 54, '1763293325_242_training_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2408, 2404, '1HRM0022', 'Initial import', 54, '1763293365_242_Transportation_and_Assignment_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2409, 2405, '1HRM0009', 'Initial import', 44, '1763293409_242_Leave_policy.pdf', NULL, '2026-04-29 08:13:40'),
(2410, 2406, '1HRM0005', 'Initial import', 44, '1763293459_242_Loan_Policy__.pdf', NULL, '2026-04-29 08:13:40'),
(2411, 2407, '1HRM0015', 'Initial import', 54, '1763293512_242_Performance_Management_and_Evaluation_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2412, 2408, '1HRM0012', 'Initial import', 54, '1763293663_242_Employee_Termination_Policy__.pdf', NULL, '2026-04-29 08:13:40'),
(2413, 2409, '1HRM0006', 'Initial import', 54, '1763293719_242_General_Human_Resources_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2414, 2410, '1HRM0003', 'Initial import', 54, '1763293773_242_Succession_and_Job_Replacement_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2415, 2411, '1HRM0002', 'Initial import', 54, '1763293976_242_Sexual_Harassment_Prevention_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2416, 2412, '1HRM0019', 'Initial import', 54, '1763294207_242_Employee_Ethics_Policy_and_Code_of_Conduct.pdf', NULL, '2026-04-29 08:13:40'),
(2417, 2413, '1HRM0010', 'Initial import', 54, '1763294315_242_Employee_Rewards_and_Compensation_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2418, 2414, '1HRM0001', 'Initial import', 54, '1763294440_242_Attendance_and_Punctuality_Policy__.pdf', NULL, '2026-04-29 08:13:40'),
(2419, 2415, 'NULL', 'Initial import', 54, '1764068325_242_Suspicious_Financial_Transaction_Reporting_Form1.pdf', NULL, '2026-04-29 08:13:40'),
(2420, 2416, '1QDMFRM2', 'Initial import', 54, '1764135645_242_Suspicious_Financial_Transaction_Reporting_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2421, 2417, '1QDMFRM2', 'Initial import', 54, '1764135852_242_Suspicious_Financial_Transaction_Reporting_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2422, 2418, '1QDMFRM26', 'Initial import', 54, '1764136145_242_Gift_Disclosure_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2423, 2419, '1QDMFRM25', 'Initial import', 54, '1764136280_242_File_Review_Report_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2424, 2420, '2QDMFRM134', 'Initial import', 54, '1764136513_242_Quality___Development_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2425, 2421, '2QDMFRM13', 'Initial import', 54, '1764136677_242_Operations_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2426, 2422, '2QDMFRM135', 'Initial import', 54, '1764136881_242_Technical_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2427, 2423, '2QDMFRM138', 'Initial import', 54, '1764136974_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2428, 2424, '2QDMFRM138', 'Initial import', 54, '1764137192_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2429, 2425, 'NULL', 'Initial import', 54, '1764140056_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2430, 2426, 'NULL', 'Initial import', 54, '1764142417_242________________________________________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2431, 2427, 'NULL', 'Initial import', 54, '1764142454_242________________________________________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2432, 2428, 'NULL', 'Initial import', 54, '1764143300_242________________________________________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2433, 2429, 'NULL', 'Initial import', 54, '1764231816_242____________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2434, 2430, 'NULL', 'Initial import', 54, '1764581519_242_Gift_Disclosure_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2435, 2431, 'QDMFRM25', 'Initial import', 54, '1764592348_242_File_Review_Report_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2436, 2432, '1QDMFRM26', 'Initial import', 54, '1764592513_242_Gift_Disclosure_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2437, 2433, '2QDMFRM133', 'Initial import', 54, '1764592622_242_Human_Resources_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2438, 2434, '2QDMFRM137', 'Initial import', 54, '1764592768_242_Information_Technology_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2439, 2435, '2QDMFRM136', 'Initial import', 54, '1764592849_242_Operations_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2440, 2436, '2QDMFRM134', 'Initial import', 54, '1764592954_242_Quality___Development_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2441, 2437, '2QDMFRM138', 'Initial import', 54, '1764593014_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2442, 2438, '1QDMFRM24', 'Initial import', 54, '1764593091_242_Suspicious_Financial_Transaction_Reporting_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2443, 2439, '2QDMFRM135', 'Initial import', 54, '1764593197_242_Technical_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2444, 2440, '1QDMFRM88', 'Initial import', 54, '1764657546_242_Client_Claim_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2445, 2441, '1QDMFRM89', 'Initial import', 54, '1764657618_242_Client_Grievance_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2446, 2442, '1QDMFRM152', 'Initial import', 54, '1764657877_242_Client_Portfolio_Handover_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2447, 2443, '1QDMFRM87', 'Initial import', 54, '1764658015_242_Complaint_Documentation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2448, 2444, '1QDMFRM84', 'Initial import', 54, '1764658105_242_Internal_Coordination_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2449, 2445, '1QDMFRM05', 'Initial import', 54, '1764658163_242_Loss_of_Renewal_Client_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2450, 2446, '1QDMFRM86', 'Initial import', 54, '1764658219_242_Responsibility_Sharing_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2451, 2447, '1QDMFRM85', 'Initial import', 54, '1764658278_242_Task_Referral_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2452, 2448, '1QDMFRM153', 'Initial import', 54, '1764658345_242_Work_Issued_Mobile_Phone_Acknowledgment_and_Compliance_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2453, 2449, '1QDMFRM62', 'Initial import', 54, '1764664008_242_Annual_Objectives_Setting_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2454, 2450, '1QDMFRM64', 'Initial import', 54, '1764664017_242_Career_Path_Review_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2455, 2451, 'NULL', 'Initial import', 54, '1764664076_242_Clearance_Certificate.pdf', NULL, '2026-04-29 08:13:40'),
(2456, 2452, '2QDMFRM114', 'Initial import', 54, '1764664312_242_Clearance_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2457, 2453, '2QDMFRM115', 'Initial import', 54, '1764664448_242_Custody_Receipt___Handover_Form_Employee_Trainee.pdf', NULL, '2026-04-29 08:13:40'),
(2458, 2454, '2QDMFRM60', 'Initial import', 54, '1764664603_242_Effective_Date_Notice.pdf', NULL, '2026-04-29 08:13:40'),
(2459, 2455, '1QDMFRM61', 'Initial import', 54, '1764664686_242_Employee_Complaint_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2460, 2456, '1QDMFRM52', 'Initial import', 54, '1764664743_242_Employee_Training_Satisfaction_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2461, 2457, 'NULL', 'Initial import', 54, '1764664817_242_Experience_Certificate.pdf', NULL, '2026-04-29 08:13:40'),
(2462, 2458, '1QDMFRM56', 'Initial import', 54, '1764664850_242_Final_Evaluation_Form_for_Employee_Onboarding.pdf', NULL, '2026-04-29 08:13:40'),
(2463, 2459, '2QDMFRM117', 'Initial import', 54, '1764664981_242_Employee_File_Information.pdf', NULL, '2026-04-29 08:13:40'),
(2464, 2460, '2QDMFRM113', 'Initial import', 54, '1764838091_242_Final_Settlement_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2465, 2461, '1QDMFRM24', 'Initial import', 54, '1764838246_242_Financial_Clearance_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2466, 2462, '1QDMFRM57', 'Initial import', 54, '1764838365_242_Hospitality_Event_Request_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2467, 2463, '1QDMFRM55', 'Initial import', 54, '1764838438_242_Initial_Onboarding_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2468, 2464, '1QDMFRM118', 'Initial import', 54, '1764838531_242_Internal_Transfer_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2469, 2465, '1QDMFRM59', 'Initial import', 54, '1764838612_242_Interview_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2470, 2466, 'NULL', 'Initial import', 54, '1764838758_242_Job_Offer.pdf', NULL, '2026-04-29 08:13:40'),
(2471, 2467, '1QDMFRM58', 'Initial import', 54, '1764838828_242_Job_Requisition_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2472, 2468, 'QDMFRM145', 'Initial import', 54, '1764838958_242_New_Employee_Onboarding.pdf', NULL, '2026-04-29 08:13:40'),
(2473, 2469, '2QDMFRM166', 'Initial import', 54, '1764845086_242_Non_disclosure_Agreement.pdf', NULL, '2026-04-29 08:13:40'),
(2474, 2470, '2QDMFRM199', 'Initial import', 54, '1764845204_242_Official_Means_of_Communication_for_Staff_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2475, 2471, '1QDMFRM54', 'Initial import', 54, '1764845390_242_Self__Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2476, 2472, '1QDMFRM51', 'Initial import', 54, '1764845502_242_Sensitive_Tasks_Assignment_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2477, 2473, '1QDMFRM53', 'Initial import', 54, '1764845559_242_Training_Initiative_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2478, 2474, '1QDMFRM46', 'Initial import', 54, '1764846223_242_Annual_Budget_Request_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2479, 2475, '1QDMFRM03', 'Initial import', 54, '1764846303_242_Capital_Expenditure_Request_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2480, 2476, '2QDMFRM40', 'Initial import', 54, '1764846404_242_Client__Payment_Reminder_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2481, 2477, '1QDMFRM38', 'Initial import', 54, '1764846478_242_Credit_Approval_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2482, 2478, '1QDMFRM37', 'Initial import', 54, '1764846559_242_Payment_Request_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2483, 2479, '2QDMFRM41', 'Initial import', 54, '1764846627_242_Payment_Request_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2484, 2480, '2QDMFRM45', 'Initial import', 54, '1764846688_242_Request_For_Ex_Gratia_Claim_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2485, 2481, '1QDMFRM82', 'Initial import', 54, '1764846996_242_Backup_Failure_Report_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2486, 2482, '2QDMFRM139', 'Initial import', 54, '1764847156_242_Client_E_Service_Access_Request_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2487, 2483, '1QDMFRM76', 'Initial import', 54, '1764847705_242_Device_Loss_Report_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2488, 2484, '1QDMFRM79', 'Initial import', 54, '1764847827_242_Emergency_Technical_Incident_Report_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2489, 2485, '1QDMFRM80', 'Initial import', 54, '1764847985_242_External_Information_Sharing_Record_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2490, 2486, '2QDMFRM140', 'Initial import', 54, '1764848233_242_IT_Services_Request_Form_for_Employees_Trainees.pdf', NULL, '2026-04-29 08:13:40'),
(2491, 2487, '1QDMFRM83', 'Initial import', 54, '1764848349_242_Technical_Clearance_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2492, 2488, '1QDMFRM78', 'Initial import', 54, '1764848422_242_Technical_or_Major_Content_Change_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2493, 2489, '1QDMFRM81', 'Initial import', 54, '1764848496_242_Temporary_Access_Exception_Request_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2494, 2490, '1QDMFRM77', 'Initial import', 54, '1764848597_242_Temporary_Receive_Replacement_Device_Form.pdf', NULL, '2026-04-29 08:13:40');
INSERT INTO `document_versions` (`id`, `document_id`, `version`, `change_summary`, `changed_by_id`, `file_path`, `approved_at`, `created_at`) VALUES
(2495, 2491, '1QDMFRM127', 'Initial import', 54, '1764849524_242_Annual_Evaluation_Form_____Board_Secretary.pdf', NULL, '2026-04-29 08:13:40'),
(2496, 2492, '1QDMFRM128', 'Initial import', 54, '1764849543_242_Board_of_Directors_and_Committees_Performance_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2497, 2493, '1QDMFRM125', 'Initial import', 54, '1764849664_242_Board_of_Directors_Meeting_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2498, 2494, '1QDMFRM126', 'Initial import', 54, '1764849742_242_Conflict_of_Interest_Disclosure_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2499, 2495, '1QDMFRM122', 'Initial import', 54, '1764849830_242_Due_Diligence_Review_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2500, 2496, '1QDMFRM124', 'Initial import', 54, '1764849899_242_Information_Protection_Undertaking.pdf', NULL, '2026-04-29 08:13:40'),
(2501, 2497, '1QDMFRM121', 'Initial import', 54, '1764849974_242_Non_Standard_Contract_Review_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2502, 2498, '1QDMFRM123', 'Initial import', 54, '1764850039_242_Remote_Electronic_Voting_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2503, 2499, '1QDMFRM107', 'Initial import', 54, '1764850201_242_Client_Satisfaction_and_Critical_Complaint_Action_Plan_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2504, 2500, '1QDMFRM108', 'Initial import', 54, '1764850315_242_Client_Satisfaction_Log.pdf', NULL, '2026-04-29 08:13:40'),
(2505, 2501, '1QDMFRM103', 'Initial import', 54, '1764850435_242_Early_Risk_Notification_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2506, 2502, '1QDMFRM95', 'Initial import', 54, '1764850493_242_Employee_Acknowledgment_of_SLA_Awareness.pdf', NULL, '2026-04-29 08:13:40'),
(2507, 2503, '1QDMFRM109', 'Initial import', 54, '1764850684_242_Employee_Satisfaction_Survey_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2508, 2504, '1QDMFRM110', 'Initial import', 54, '1764850755_242_Employee_Satisfaction_Survey_Report.pdf', NULL, '2026-04-29 08:13:40'),
(2509, 2505, '1QDMFRM102', 'Initial import', 54, '1764850812_242_Impact___Effort_Matrix.pdf', NULL, '2026-04-29 08:13:40'),
(2510, 2506, '1QDMFRM101', 'Initial import', 54, '1764850935_242_Improvement_Implementation_Tracking_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2511, 2507, '1QDMFRM101', 'Initial import', 54, '1764851046_242_Improvement_Plan_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2512, 2508, '1QDMFRM104', 'Initial import', 54, '1764851211_242_Operational_Incident_Report.pdf', NULL, '2026-04-29 08:13:40'),
(2513, 2509, '1QDMFRM94', 'Initial import', 54, '1764851264_242_Partner_Breach_Follow_up_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2514, 2510, '1QDMFRM91', 'Initial import', 54, '1764851327_242_Partner_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2515, 2511, '1QDMFRM90', 'Initial import', 54, '1764851596_242_Partnership_Request_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2516, 2512, '1QDMFRM112', 'Initial import', 54, '1764851734_242_Policy_Creation_or_Update_Request_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2517, 2513, '1QDMFRM99', 'Initial import', 54, '1764851809_242_Proposed_Improvement_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2518, 2514, '1QDMFRM105', 'Initial import', 54, '1764851870_242_Quality_Risk_Register.pdf', NULL, '2026-04-29 08:13:40'),
(2519, 2515, '1QDMFRM106', 'Initial import', 54, '1764851921_242_Root_Cause_Analysis_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2520, 2516, '1QDMFRM97', 'Initial import', 54, '1764852052_242_SLA_Breach_Report_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2521, 2517, '1QDMFRM96', 'Initial import', 54, '1764852769_242_SLA_Periodic_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2522, 2518, '1QDMFRM98', 'Initial import', 54, '1764852992_242_SLA_Review_Minutes_____External_Vendor.pdf', NULL, '2026-04-29 08:13:40'),
(2523, 2519, '1QDMFRM111', 'Initial import', 54, '1764853184_242_Unstructured_Process_Reporting_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2524, 2520, '1QDMFRM92', 'Initial import', 54, '1764853242_242_Value_Triangle_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2525, 2521, '1QDMFRM70', 'Initial import', 54, '1765085861_242_Agency_Performance_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2526, 2522, '1QDMFRM65', 'Initial import', 54, '1765085974_242_An_internal_evaluation_model_for_Management_satisfaction_with_market_research_outputs.pdf', NULL, '2026-04-29 08:13:40'),
(2527, 2523, '1QDMFRM69', 'Initial import', 54, '1765086084_242_Campaign_Performance_Follow_up_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2528, 2524, '1QDMFRM68', 'Initial import', 54, '1765086154_242_Campaign_Proposal_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2529, 2525, '1QDMFRM66', 'Initial import', 54, '1765086219_242_Client_Event_Request_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2530, 2526, '1QDMFRM67', 'Initial import', 54, '1765086320_242_Client_Event_Satisfaction_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2531, 2527, '1QDMFRM73', 'Initial import', 54, '1765086370_242_Insurance_Products_Disclosure_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2532, 2528, '1QDMFRM75', 'Initial import', 54, '1765086417_242_Internal_Evaluation_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2533, 2529, '1QDMFRM71', 'Initial import', 54, '1765086517_242_Marketing_Project_Request_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2534, 2530, '1QDMFRM72', 'Initial import', 54, '1765086591_242_Non_Disclosure_Agreement_for_Marketing_Agencies.pdf', NULL, '2026-04-29 08:13:40'),
(2535, 2531, '1QDMFRM74', 'Initial import', 54, '1765086655_242_Promotional_Material_Request_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2536, 2532, '1QDMFRM75', 'Initial import', 54, '1765087196_242_Product_Development_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2537, 2533, 'NULL', 'Initial import', 54, '1765087342_242_BROKER_OF_RECORD_LETTER.pdf', NULL, '2026-04-29 08:13:40'),
(2538, 2534, '1QDMFRM32', 'Initial import', 54, '1765087437_242_Corrective_Action_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2539, 2535, '1QDMFRM28', 'Initial import', 54, '1765087524_242_Emergency_Recovery_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2540, 2536, '1QDMFRM29', 'Initial import', 54, '1765087593_242_Request_for_Inspection_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2541, 2537, '1QDMFRM27', 'Initial import', 54, '1765087651_242_Technical_Emergency_Record_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2542, 2538, '1QDMFRM31', 'Initial import', 54, '1765087717_242_Technical_Error_Report_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2543, 2539, '1QDMFRM3', 'Initial import', 44, '1765174218_214_Accounting_Reconciliation_Memo.pdf', NULL, '2026-04-29 08:13:40'),
(2544, 2540, '1QDMFRM39', 'Initial import', 44, '1765174282_214_Accounting_Reconciliation_Memo.pdf', NULL, '2026-04-29 08:13:40'),
(2545, 2541, '2QDMFRM42', 'Initial import', 44, '1765174936_214_Petty_Cash_Form.xlsx', NULL, '2026-04-29 08:13:40'),
(2546, 2542, '2QDMFRM43', 'Initial import', 44, '1765175028_214_Payment_Cover_form.xlsx', NULL, '2026-04-29 08:13:40'),
(2547, 2543, '2QDMFRM44', 'Initial import', 44, '1765175094_214_Event_Expense_Form.xlsx', NULL, '2026-04-29 08:13:40'),
(2548, 2544, '1QDMFRM47', 'Initial import', 44, '1765175170_214_Internal_Tax_Declaration_Form.xlsx', NULL, '2026-04-29 08:13:40'),
(2549, 2545, '2QDMFRM44', 'Initial import', 44, '1765175375_214_Event_Expense_Form.xlsx', NULL, '2026-04-29 08:13:40'),
(2550, 2546, '1QDMFRM30', 'Initial import', 44, '1765177851_214_Client_Complaint_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2551, 2547, '1QDMFRM33', 'Initial import', 44, '1765178456_214_Manual_Operation_Form.xlsx', NULL, '2026-04-29 08:13:40'),
(2552, 2548, '1QDMFRM34', 'Initial import', 44, '1765279882_214_Brokerage_Slip.pdf', NULL, '2026-04-29 08:13:40'),
(2553, 2549, '1QDMFRM.33', 'Initial import', 44, '1765280345_214_Brokerage_Slip.pdf', NULL, '2026-04-29 08:13:40'),
(2554, 2550, '1QDMFRM35', 'Initial import', 44, '1765280492_214_TOBA.pdf', NULL, '2026-04-29 08:13:40'),
(2555, 2551, '1QDMFRM35', 'Initial import', 44, '1765280618_214_TOBA.pdf', NULL, '2026-04-29 08:13:40'),
(2556, 2552, '1QDMFRM48', 'Initial import', 44, '1765284385_214_Supplier_Registration_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2557, 2553, '1QDMFRM49', 'Initial import', 44, '1765284506_214_Purchase_Request_Form__PR_.pdf', NULL, '2026-04-29 08:13:40'),
(2558, 2554, '1QDMFRM50', 'Initial import', 44, '1765284789_214_Price_Comparison_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2559, 2555, '2QDMFRM.45', 'Initial import', 44, '1765799360_214_Request_For_Ex_Gratia_Claim_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2560, 2556, '1OM000.3', 'Initial import', 44, '1766469015_214_Renewals_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2561, 2557, '1OM000.4', 'Initial import', 44, '1766469080_214_Immediate_Client_Response_Assurance_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2562, 2558, '1OM000.6', 'Initial import', 44, '1766469109_214_Client_Care_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2563, 2559, '1OM000.7', 'Initial import', 44, '1766469184_214_Client_Complaints_Management_Policy___Arabic.pdf', NULL, '2026-04-29 08:13:40'),
(2564, 2560, '1OM0015', 'Initial import', 44, '1767165609_214_Internal_Policy_for_Monthly_Productivity_Reconciliation.pdf', NULL, '2026-04-29 08:13:40'),
(2565, 2561, '1OM00.15', 'Initial import', 44, '1767165705_214_Internal_Policy_for_Monthly_Productivity_Reconciliation.pdf', NULL, '2026-04-29 08:13:40'),
(2566, 2562, '1SP0001', 'Initial import', 44, '1767609477_214_IT_Governance_and_Cybersecurity_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2567, 2563, '1SP0002', 'Initial import', 44, '1767610087_214_Digital_Platform_Operations.pdf', NULL, '2026-04-29 08:13:40'),
(2568, 2564, '1SP0003', 'Initial import', 44, '1767610128_214_Privacy_and_Data_Protection_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2569, 2565, '1SP0004', 'Initial import', 44, '1767610263_214_Systems_Development_and_Change_Management_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2570, 2566, '1SP0005', 'Initial import', 44, '1767610334_214_Systems_Integration_and_Application.pdf', NULL, '2026-04-29 08:13:40'),
(2571, 2567, '1SP0006', 'Initial import', 44, '1767610419_214_Access_Management.pdf', NULL, '2026-04-29 08:13:40'),
(2572, 2568, '1SP0007', 'Initial import', 44, '1767610608_214_Website_and_Mobile_Application_Management_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2573, 2569, '1SP0008', 'Initial import', 44, '1767610683_214_IT_Vendors_and_Technical_Services.pdf', NULL, '2026-04-29 08:13:40'),
(2574, 2570, '1SP0009', 'Initial import', 44, '1767610767_214_Security_Awareness_and_Training_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2575, 2571, '1SP0010', 'Initial import', 44, '1767610868_214_Platform_Transactions_and_Financial.pdf', NULL, '2026-04-29 08:13:40'),
(2576, 2572, '1SP0011', 'Initial import', 44, '1767610897_214_Partners_Management_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2577, 2573, '1SP0012', 'Initial import', 44, '1767611089_214_Marketing_and_Promotional_Campaigns.pdf', NULL, '2026-04-29 08:13:40'),
(2578, 2574, '1SP0013', 'Initial import', 44, '1767611230_214_Customer_Service_and_User_Experience_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2579, 2575, '1SP0014', 'Initial import', 44, '1767611280_214_Talent_Acquisition_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2580, 2576, '1ITM0016', 'Initial import', 44, '1767688238_214_Domain_and_Technical_Subscription_Management_and_Renewal_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2581, 2577, 'QDMFRM163', 'Initial import', 44, '1767689122_214_______________________________________________.xlsx', NULL, '2026-04-29 08:13:40'),
(2582, 2578, '1LCM009', 'Initial import', 44, '1767858849_214_Anti_fraud_policy.pdf', NULL, '2026-04-29 08:13:40'),
(2583, 2579, '1LCM09', 'Initial import', 44, '1767858899_214_Anti_fraud_policy.pdf', NULL, '2026-04-29 08:13:40'),
(2584, 2580, '1LCM9', 'Initial import', 44, '1767858947_214_Anti_fraud_policy.pdf', NULL, '2026-04-29 08:13:40'),
(2585, 2581, 'LCM009', 'Initial import', 44, '1767865044_214_Anti_fraud_policy.pdf', NULL, '2026-04-29 08:13:40'),
(2586, 2582, 'QDMFRM145', 'Initial import', 54, '1768382451_242_New_Employee_Onboarding__Form.pdf', NULL, '2026-04-29 08:13:40'),
(2587, 2583, 'v2.0', 'Initial import', 44, '1768989040_214_technical_procedures.pdf', NULL, '2026-04-29 08:13:40'),
(2588, 2584, '1HRM0012', 'Initial import', 54, '1769500117_242__________________________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2589, 2585, '1ITM0013', 'Initial import', 54, '1769502233_242_Email___Internet_Use_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2590, 2586, '1.0', 'Initial import', 54, '1769505178_242_Human_Resources_Procedure.pdf', NULL, '2026-04-29 08:13:40'),
(2591, 2587, '1.0', 'Initial import', 54, '1769595417_242_Human_Resources_Procedures.pdf', NULL, '2026-04-29 08:13:40'),
(2592, 2588, '1.0', 'Initial import', 44, '1771156460_214_Handover_certificate_Diamond.xlsx', NULL, '2026-04-29 08:13:40'),
(2593, 2589, '2HRM0007', 'Initial import', 44, '1774526235_214_Hiring_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2594, 2590, '2FM0021', 'Initial import', 44, '1774934654_214_Financial_Records_and_Archiving_Management_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2595, 2591, '2FM0004', 'Initial import', 44, '1774934944_214_Accounting_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2596, 2592, '2FM0002', 'Initial import', 44, '1774935145_214_Budget_Planning_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2597, 2593, '2FM0009', 'Initial import', 44, '1774935589_214_Capital_Expenditure_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2598, 2594, '2FM0019', 'Initial import', 44, '1774935948_214_Collections_and_Aging_of_Receivables_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2599, 2595, '2FM0015', 'Initial import', 44, '1774936242_214_Accounting_Adjustments_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2600, 2596, '2FM0013', 'Initial import', 44, '1774936470_214_Internal_Control_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2601, 2597, '2FM0010', 'Initial import', 44, '1774936584_214_Investments_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2602, 2598, '2FM0008', 'Initial import', 44, '1774936714_214_Petty_Cash_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2603, 2599, '2FM0020', 'Initial import', 44, '1774936897_214_Segregation_of_Financial_Duties_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2604, 2600, '2FM0014', 'Initial import', 44, '1774937010_214_Loss_Reporting_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2605, 2601, '1QDMFRM1', 'Initial import', 44, '1774937054_214_Operational_Loss_Reporting_Form.pdf', NULL, '2026-04-29 08:13:40'),
(2606, 2602, '1FM0024', 'Initial import', 44, '1774938401_214_Fixed_Assets_Management_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2607, 2603, '1QDMFRM155', 'Initial import', 44, '1774939625_214_Master_Asset_Register.xlsx', NULL, '2026-04-29 08:13:40'),
(2608, 2604, '1QDMFRM156', 'Initial import', 44, '1774939862_214_Inventory_Register.xlsx', NULL, '2026-04-29 08:13:40'),
(2609, 2605, '1QDMFRM157', 'Initial import', 44, '1774940028_214_Asset_Operations_Log__Maintenance_____Storage_____Disposal_.xlsx', NULL, '2026-04-29 08:13:40'),
(2610, 2606, '1QDMFRM158', 'Initial import', 44, '1774940200_214_Damage___Loss_Register.xlsx', NULL, '2026-04-29 08:13:40'),
(2611, 2607, '1FM0025', 'Initial import', 44, '1774940711_214_Policy_for_Managing_and_Monitoring_Aged_Receivables.pdf', NULL, '2026-04-29 08:13:40'),
(2612, 2608, '1QDMFRM160', 'Initial import', 44, '1774940976_214_Aged_Receivables_Tracking_Form.xlsx', NULL, '2026-04-29 08:13:40'),
(2613, 2609, '1QDMFRM159', 'Initial import', 44, '1774941426_214.xlsx', NULL, '2026-04-29 08:13:40'),
(2614, 2610, '2HRM0009', 'Initial import', 44, '1774945876_214_Leave_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2615, 2611, '2HRM0005', 'Initial import', 44, '1774949602_214_Loan_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(2616, 2612, 'QDMFRM16', 'Initial import', 54, '1775464323_242______________________________________.pdf', NULL, '2026-04-29 08:13:40'),
(2617, 2613, '3HRM0007', 'Initial import', 44, '1776688644_214_Hiring_policy.pdf', NULL, '2026-04-29 08:13:40'),
(2618, 2614, '2FM00.17', 'Initial import', 44, '1776941426_214_Commission_Disbursement.pdf', NULL, '2026-04-29 08:13:40'),
(2619, 2615, '2HRM0001', 'Initial import', 44, '1776952037_214_Attendance_and_Punctuality_Policy.pdf', NULL, '2026-04-29 08:13:40'),
(4586, 1, '1', 'Initial import', 38, '1671711806_1_Renewal_process.pdf', NULL, '2026-04-29 09:44:25'),
(4587, 2, '1', 'Initial import', 38, '1750246935_194_Certificate59967.pdf', NULL, '2026-04-29 09:44:25'),
(4588, 3, '1', 'Initial import', 44, '1750315769_194_Strategic_partnership_policy.pdf', NULL, '2026-04-29 09:44:25'),
(4589, 4, '1', 'Initial import', 38, '1751268889_194_Electronic_Receipt_065_2183088365_Jithin_Varkey.pdf', NULL, '2026-04-29 09:44:25'),
(4590, 5, '1TM0001', 'Initial import', 44, '1751351851_214_______________________________________________.pdf', NULL, '2026-04-29 09:44:25'),
(4591, 6, '1TM0001', 'Initial import', 44, '1751352335_214_Technical_and_Underwriting_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4592, 7, '1TM0002', 'Initial import', 44, '1751352636_214_Letters_of_Undertaking_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4593, 8, ' 1TM0003', 'Initial import', 44, '1751352776_214_Insurance_Quotation_Preparation_and_Documentation_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4594, 9, '1TM0003', 'Initial import', 44, '1751352888_214_Insurance_Quotation_Preparation_and_Documentation_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4595, 10, '1TM0004', 'Initial import', 44, '1751352973_214_Contractual_Clarity_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4596, 11, '1TM0005', 'Initial import', 44, '1751353978_214_Emergency_Response_and_Business_Continuity_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4597, 12, '1TM0006', 'Initial import', 44, '1751354052_214_Disaster_Recovery_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4598, 13, '1TM0007', 'Initial import', 44, '1751354124_214_Errors_and_Omissions_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4599, 14, '1TM0008', 'Initial import', 44, '1751354259_214_Insurance_Company_Engagement_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4600, 15, '1TM0009', 'Initial import', 44, '1751354658_214_Insurance_Company_Relationship_Management_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4601, 16, '1TM0010', 'Initial import', 44, '1751355476_214_Insurance_Portfolio_Analysis_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4602, 17, '1TM0011', 'Initial import', 44, '1751355768_214_Whistleblowing_and_Violations_Reporting_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4603, 18, '1TM0012', 'Initial import', 44, '1751356100_214_Client_Premium_Collection_Confirmation_Before_Policy_Issuance_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4604, 19, '1TM0013', 'Initial import', 44, '1751356242_214_Issuance_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4605, 20, '1TM0014', 'Initial import', 44, '1751356381_214_General_Policy_for_Periodic_Inspection_and_Review_of_Technical_Survey_Reports___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4606, 21, '1TM0015', 'Initial import', 44, '1751356484_214_Insurance_Claims_and_Electronic_Archiving_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4607, 22, '1TM0016', 'Initial import', 44, '1751356580_214_Client_Business_Terms_Agreement_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4608, 23, '1LCM0001', 'Initial import', 44, '1751361731_214_Regulatory_Compliance_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4609, 24, '1LCM0002', 'Initial import', 44, '1751361824_214_Anti_Corruption_and_Anti_Bribery_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4610, 25, '1LCM0003', 'Initial import', 44, '1751361864_214_Anti_Money_Laundering_and_Counter_Terrorism_Financing_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4611, 26, '1LCM0004', 'Initial import', 44, '1751362218_214_Whistleblower_Protection_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4612, 27, '1LCM0005', 'Initial import', 44, '1751362281_214_Risk_Management_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4613, 28, '1LCM0006', 'Initial import', 44, '1751362370_214_Information_Classification__Security__and_Disposal_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4614, 29, '1LCM0007', 'Initial import', 44, '1751362561_214_File_Review_Policy.pdf', NULL, '2026-04-29 09:44:25'),
(4615, 30, '1LCM0008', 'Initial import', 44, '1751362672_214_Internal_Audit_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4616, 31, '1LCM0008', 'Initial import', 44, '1751362961_214_Internal_Audit_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4617, 32, '1LCM0010', 'Initial import', 44, '1751363067_214_External_Agency_Agreement_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4618, 33, '1LCM0011', 'Initial import', 44, '1751363188_214_Outsourcing_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4619, 34, '1LCM0012', 'Initial import', 44, '1751363406_214_Compliance_with_International_and_Local_Standards_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4620, 35, 'NULL', 'Initial import', 38, '1751541639_194__________________________________________2024_1.pdf', NULL, '2026-04-29 09:44:25'),
(4621, 36, 'NULL', 'Initial import', 38, '1751541922_194___________________________________________________________.pdf', NULL, '2026-04-29 09:44:25'),
(4622, 37, 'NULL', 'Initial import', 38, '1751541948_194___________________________________________________________.pdf', NULL, '2026-04-29 09:44:25'),
(4623, 38, 'HR250518', 'Initial import', 38, '1751542050_194_______________________________.pdf', NULL, '2026-04-29 09:44:25'),
(4624, 39, 'NULL', 'Initial import', 38, '1751542183_194_______________________________.pdf', NULL, '2026-04-29 09:44:25'),
(4625, 40, 'NULL', 'Initial import', 38, '1751542303_194_____________________________________.pdf', NULL, '2026-04-29 09:44:25'),
(4626, 41, 'NULL', 'Initial import', 38, '1751542463_194_____________________________________.pdf', NULL, '2026-04-29 09:44:25'),
(4627, 42, 'NULL', 'Initial import', 38, '1751542564_194________________________.pdf', NULL, '2026-04-29 09:44:25'),
(4628, 43, 'NULL', 'Initial import', 38, '1751542652_194___________________________________.pdf', NULL, '2026-04-29 09:44:25'),
(4629, 44, 'HR250408', 'Initial import', 38, '1751542743_194__________________________.pdf', NULL, '2026-04-29 09:44:25'),
(4630, 45, 'NULL', 'Initial import', 38, '1751542834_194_______.pdf', NULL, '2026-04-29 09:44:25'),
(4631, 46, 'NULL', 'Initial import', 38, '1751542914_194__________________________.pdf', NULL, '2026-04-29 09:44:25'),
(4632, 47, 'NULL', 'Initial import', 38, '1751542992_194______________________________________________.pdf', NULL, '2026-04-29 09:44:25'),
(4633, 48, '1FM0001', 'Initial import', 44, '1751787372_214_General_Financial_Affairs_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4634, 49, '1FM0002', 'Initial import', 44, '1751787442_214_Budget_Planning_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4635, 50, '1FM0003', 'Initial import', 44, '1751787525_214_Financial_Reporting_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4636, 51, '1FM0004', 'Initial import', 44, '1751787611_214_Accounting_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4637, 52, '1FM0005', 'Initial import', 44, '1751787741_214_External_Financial_Transactions_and_Transfers_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4638, 53, '1FM0006', 'Initial import', 44, '1751787908_214_Expenses_and_Payments_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4639, 54, '1FM0006', 'Initial import', 44, '1751788358_214_Expenses_and_Payments_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4640, 55, '1FM0007', 'Initial import', 44, '1751788484_214_Financial_Dealings_with_Insurance_Companies_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4641, 56, '1FM0008', 'Initial import', 44, '1751788562_214_Petty_Cash_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4642, 57, '1FM0009', 'Initial import', 44, '1751788698_214_Capital_Expenditure_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4643, 58, '1FM0010', 'Initial import', 44, '1751788885_214_Investment_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4644, 59, '1FM0011', 'Initial import', 44, '1751789001_214_Tax_Policy.pdf', NULL, '2026-04-29 09:44:25'),
(4645, 60, '1FM0011', 'Initial import', 44, '1751789190_214_Tax_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4646, 61, '1FM0012', 'Initial import', 44, '1751789273_214_Financial_Closing_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4647, 62, '1FM0013', 'Initial import', 44, '1751789358_214_Credit_Control_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4648, 63, '1FM0014', 'Initial import', 44, '1751789452_214_Operational_Loss_Reporting_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4649, 64, '1FM0015', 'Initial import', 44, '1751791247_214_Accounting_Reconciliation_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4650, 65, '1FM0016', 'Initial import', 44, '1751791308_214_External_Auditor_and_Legal_Accountant_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4651, 66, '1FM0017', 'Initial import', 44, '1751791415_214_Commission_Disbursement_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4652, 67, '1FM0018', 'Initial import', 44, '1751791472_214_Financial_Risk_Management_and_Debt_Aging_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4653, 68, '2FM0017', 'Initial import', 44, '1751791678_214_Commission_Disbursement_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4654, 69, '1FM0019', 'Initial import', 44, '1751791947_214_Debt_Collection_and_Aging_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4655, 70, '1FM0020', 'Initial import', 44, '1751792029_214_Financial_Segregation_of_Duties_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4656, 71, '1FM0021', 'Initial import', 44, '1751792176_214_Financial_Records_Management_and_Archiving_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4657, 72, '1FM0023', 'Initial import', 44, '1751792373_214_Financial_Data_Protection_and_Confidentiality_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4658, 73, 'v1.0', 'Initial import', 44, '1751793163_214_Financial_Procedures___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4659, 74, 'v1.0', 'Initial import', 44, '1751793195_214_Financial_Procedures___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4660, 75, 'v1.0', 'Initial import', 54, '1751796750_214_Tinancial_Procedures____Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4661, 76, 'v1.0', 'Initial import', 44, '1751799437_214_Compliance_Procedures___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4662, 77, '1LCM0009', 'Initial import', 44, '1752655593_214_Anti_Fraud_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4663, 78, '1LCM0012', 'Initial import', 44, '1752655946_214_Business_Continuity_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4664, 79, '1HRM0002', 'Initial import', 54, '1753172892_214_Anti_Sexual_Harassment_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4665, 80, '1HRM0003', 'Initial import', 54, '1753172970_214_Succession_and_Replacement_Policy__Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4666, 81, '1HRM0004', 'Initial import', 44, '1753173260_214_Corporate_Social_Responsibility__CSR__Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4667, 82, '1HRM0008', 'Initial import', 44, '1753175310_214_Employee_Onboarding_and_Orientation_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4668, 83, '1HRM0010', 'Initial import', 44, '1753175403_214_Allowances_and_Promotions_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4669, 84, '1HRM0013', 'Initial import', 44, '1753175546_214_Business_Travel_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4670, 85, '1HRM0014', 'Initial import', 44, '1753175592_214_Entertainment_and_Hospitality_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4671, 86, '1HRM0016', 'Initial import', 44, '1753175688_214_Training_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4672, 87, '1HRM0016', 'Initial import', 44, '1753176878_214_Training_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4673, 88, '1HRM0019', 'Initial import', 44, '1753176961_214_Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4674, 89, '1HRM0019', 'Initial import', 44, '1753177045_214_Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4675, 90, '1HRM0020', 'Initial import', 44, '1753177098_214_Security_and_Confidentiality_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4676, 91, '1HRM0006', 'Initial import', 54, '1753340794_214_General_Human_Resources_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4677, 92, '1HRM0007', 'Initial import', 44, '1753340867_214_Recruitment_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4678, 93, '1HRM0010', 'Initial import', 44, '1753340923_214_Employee_Rewards_and_Compensation_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4679, 94, '1HRM0012', 'Initial import', 54, '1753340971_214_Employee_Termination_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4680, 95, '1HRM0015', 'Initial import', 54, '1753341020_214_Employee_Performance_Evaluation_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4681, 96, '1HRM0017', 'Initial import', 44, '1753341059_214_Career_Development_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4682, 97, '1HRM0018', 'Initial import', 44, '1753341131_214_Employee_Complaints_and_Disciplinary_Actions_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4683, 98, '1HRM0021', 'Initial import', 44, '1753341181_214_Remote_Work_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4684, 99, '1HRM0005', 'Initial import', 54, '1753353099_214_Loan_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4685, 100, '1HRM0009', 'Initial import', 54, '1753353198_214_Leave_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4686, 101, '1HRM0001', 'Initial import', 54, '1753353237_214_Attendance_and_Punctuality_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4687, 102, '1HRM0022', 'Initial import', 54, '1753353392_214_Employee_Transfer_and_Delegation_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4688, 103, '1SMM0001', 'Initial import', 44, '1753701365_214_Sales_and_Marketing_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4689, 104, '1SMM0003', 'Initial import', 44, '1753701598_214_General_Marketing_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4690, 105, '1SMM0004', 'Initial import', 44, '1753701666_214_Branding_and_Advertising_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4691, 106, '1SMM0005', 'Initial import', 44, '1753701747_214_Client_Communication_and_Interaction_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4692, 107, '1SMM0006', 'Initial import', 44, '1753701849_214_Promotional_Materials_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4693, 108, '1SMM0007', 'Initial import', 44, '1753701885_214_Market_Research_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4694, 109, '1SMM0008', 'Initial import', 44, '1753701919_214_Sales_and_Marketing_Protocols_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4695, 110, '1SMM0009', 'Initial import', 44, '1753702122_214_Services_and_Events_Management_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4696, 111, '1SMM0010', 'Initial import', 44, '1753702197_214_Marketing_Agencies_Management_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4697, 112, '1SMM0011', 'Initial import', 44, '1753702266_214_Sales_Practices_Policy__Transparency_and_Clarity__Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4698, 113, '1SMM0012', 'Initial import', 44, '1753702308_214_Sales_Staff_Qualification_and_Accreditation_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4699, 114, '1SMM0013', 'Initial import', 44, '1753702367_214_Insurance_Product_Disclosure_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4700, 115, '1SMM0014', 'Initial import', 44, '1753702428_214_Diamond_Authorization_Limits_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4701, 116, '1SMM0015', 'Initial import', 44, '1753702454_214_Special_Offers_and_Promotional_Campaigns_Management_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4702, 117, '1SMM0016', 'Initial import', 44, '1753702540_214_Cross_selling_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4703, 118, '1SMM0017', 'Initial import', 44, '1753702580_214_Sales_Performance_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4704, 119, '1SMM0018', 'Initial import', 44, '1753702613_214_Sales_Support_Activities_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4705, 120, '1SMM0019', 'Initial import', 44, '1753702673_214_Product_Development_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4706, 121, '1SMM0020', 'Initial import', 44, '1753702698_214_Lead_Generation_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4707, 122, '1SMM0002', 'Initial import', 44, '1753702768_214_Client_Communication_Follow_up_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4708, 123, 'v1.0', 'Initial import', 44, '1753704241_214_Sales_procedures___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4709, 124, 'v1.0', 'Initial import', 44, '1753705364_214_Marketing_procedures___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4710, 125, '1SMM0010', 'Initial import', 44, '1753778268_214_Marketing_Agencies_Management_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4711, 126, '1ITM0001', 'Initial import', 44, '1753788000_214_Information_Technology_Governance_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4712, 127, '1ITM0002', 'Initial import', 44, '1753788154_214_Information_Technology_Management_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4713, 128, '1ITM0003', 'Initial import', 44, '1753788438_214_Information_Technology_User_Security_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4714, 129, '1ITM0004', 'Initial import', 44, '1753788571_214_Information_Technology_Systems_Security_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4715, 130, '1ITM0005', 'Initial import', 44, '1753788672_214_Information_Technology_Devices_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4716, 131, '1ITM0006', 'Initial import', 44, '1753788749_214_Information_Technology_Software_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4717, 132, '1ITM0007', 'Initial import', 44, '1753788851_214_Telephone_and_Communication_Systems_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4718, 133, '1ITM0008', 'Initial import', 44, '1753788922_214_Administrative_Information_Management_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4719, 134, '1ITM0009', 'Initial import', 44, '1753788981_214_Website_Management_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4720, 135, '1ITM0011', 'Initial import', 44, '1753789137_214_Backup_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4721, 136, '1ITM0012', 'Initial import', 44, '1753789191_214_Access_Management_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4722, 137, '1ITM0013', 'Initial import', 44, '1753789249_214_Email_and_Internet_Usage_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4723, 138, '1ITM0014', 'Initial import', 44, '1753789350_214_Software_Updates_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4724, 139, '1QDM0001', 'Initial import', 44, '1753868709_214_Strategic_Partnerships_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4725, 140, '1QDM0002', 'Initial import', 44, '1753868787_214_Partner_Management_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4726, 141, '1QDM0003', 'Initial import', 44, '1753868844_214_Quality_and_Development_Management_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4727, 142, '1QDM0004', 'Initial import', 44, '1753868899_214_Service_Level_Agreements__SLA__Policy.pdf', NULL, '2026-04-29 09:44:25'),
(4728, 143, '1QDM0005', 'Initial import', 44, '1753868939_214_Continuous_Improvement_Management_Policy___PDF.pdf', NULL, '2026-04-29 09:44:25'),
(4729, 144, '1QDM0006', 'Initial import', 44, '1753869197_214_Operational_Performance_Analysis_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4730, 145, '1QDM0007', 'Initial import', 44, '1753869253_214_Risk_Management_Policy_Related_to_Quality___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4731, 146, '1QDM0008', 'Initial import', 44, '1753869403_214_Client_Satisfaction_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4732, 147, '1QDM0009', 'Initial import', 44, '1753869428_214_Employee_Satisfaction_Policy___Aarbic.pdf', NULL, '2026-04-29 09:44:25'),
(4733, 148, '1QDM0010', 'Initial import', 44, '1753869535_214_Workplace_Environment_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4734, 149, '1QDM0011', 'Initial import', 44, '1753869571_214_Policy_for_Creating_Policies_and_Procedures_for_Uncontrolled_Work___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4735, 150, '1ITM0010', 'Initial import', 44, '1753870540_214_IT_Resources_Management_and_Security_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:25'),
(4736, 151, 'v1.0', 'Initial import', 54, '1753874943_214_Cybersecurity_Procedures___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4737, 152, '1HRM0016', 'Initial import', 54, '1753951571_214_Training_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4738, 153, '1HRM0019', 'Initial import', 54, '1753951705_214_Employee_Ethics_and_Code_of_Conduct_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4739, 154, '1HRM0020', 'Initial import', 54, '1753951808_214_Security_and_Confidentiality_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4740, 155, '1HRM0008', 'Initial import', 54, '1753951872_214_Employee_Onboarding_and_Orientation_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4741, 156, '1HRM0011', 'Initial import', 54, '1753951947_214_Allowances_and_Promotions_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4742, 157, '1HRM0014', 'Initial import', 54, '1753952026_214_Entertainment_and_Hospitality_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4743, 158, '1HRM0013', 'Initial import', 54, '1753952082_214_Business_Travel_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4744, 159, '1HRM0018', 'Initial import', 54, '1753952217_214_Employee_Complaints_and_Disciplinary_Actions_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4745, 160, '1HRM0021', 'Initial import', 54, '1753952299_214_Remote_Work_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4746, 161, '1HRM0004', 'Initial import', 54, '1753952372_214_Corporate_Social_Responsibility__CSR__Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4747, 162, '1HRM0017', 'Initial import', 54, '1753952455_214_Career_Development_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4748, 163, '1HRM0010', 'Initial import', 54, '1753952522_214_Employee_Rewards_and_Compensation_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4749, 164, '1PD0001', 'Initial import', 44, '1753952785_214_Vendor_Management_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4750, 165, '1PD0002', 'Initial import', 44, '1753952838_214_Procurement_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4751, 166, '1PD0003', 'Initial import', 44, '1753952883_214_Health_and_Safety_Policy_Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4752, 167, '1OM0001', 'Initial import', 44, '1753953836_214_Claims_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4753, 168, '1OM0002', 'Initial import', 44, '1753953912_214_Daily_Operations_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4754, 169, '1OM0002', 'Initial import', 44, '1753954381_214_Daily_Operations_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4755, 170, '1OM0003', 'Initial import', 44, '1753954446_214_Renewals_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4756, 171, '1OM0004', 'Initial import', 44, '1753954558_214_Immediate_Client_Response_Assurance_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4757, 172, '1OM0005', 'Initial import', 44, '1753954659_214_General_Operations_Policy__Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4758, 173, '1OM0006', 'Initial import', 44, '1753954896_214_Client_Care_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4759, 174, '1OM0007', 'Initial import', 44, '1753954955_214_Client_Complaints_Management_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4760, 175, '1OM0008', 'Initial import', 44, '1753955033_214_Client_Support_in_Handling_Insurance_Claims_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4761, 176, '1OM0009', 'Initial import', 44, '1753955113_214_Regulatory_Policy_for_Insurance_Claims_Officers_and_Specialists___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4762, 177, '1OM0010', 'Initial import', 44, '1753955181_214_Operations_Support_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4763, 178, '1OM0011', 'Initial import', 44, '1753955243_214_General_Administration_Policy_for_the_Operations_Management___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4764, 179, '1OM0012', 'Initial import', 44, '1753955298_214_Relations_with_Insurance_Companies_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4765, 180, '1OM0013', 'Initial import', 44, '1753955354_214_Records_Retention_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4766, 181, '1OM0014', 'Initial import', 44, '1753955400_214_Insurance_Broker_Change_Policy_During_Policy_Term___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4767, 182, '1QDM0002', 'Initial import', 44, '1754147184_214_Partner_Management_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4768, 183, '1PD0003', 'Initial import', 44, '1754147626_214_Health_and_Safety_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4769, 184, 'v1.0', 'Initial import', 44, '1754149425_214_Information_Technology_Procedures___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4770, 185, 'v1.0', 'Initial import', 44, '1754149509_214_Quality___Development_Procedures___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4771, 186, 'v1.0', 'Initial import', 44, '1754210626_214_operations_procedures___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4772, 187, '1EM0001', 'Initial import', 44, '1754217251_214_Delegation_of_Authority_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4773, 188, '1EM0002', 'Initial import', 44, '1754217314_214_Board_Members____Remuneration_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4774, 189, '1EM0003', 'Initial import', 44, '1754217474_214_Confidentiality_and_Information_Protection_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4775, 190, '1EM0004', 'Initial import', 44, '1754217508_214_Non_Standard_Agreements_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4776, 191, '1EM0005', 'Initial import', 44, '1754218070_214_Corporate_Governance_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4777, 192, '1EM0006', 'Initial import', 44, '1754218221_214_Local_Oversight_Policy_for_the_CEO_and_Deputy_CEO___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4778, 193, '1EM0007', 'Initial import', 44, '1754218592_214_Mergers_and_Acquisitions_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4779, 194, '1EM0008', 'Initial import', 44, '1754218663_214_Board_Meetings_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4780, 195, '1EM0009', 'Initial import', 44, '1754218728_214_General_Assembly_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4781, 196, '1EM0010', 'Initial import', 44, '1754218759_214_Board_Secretary_Appointment_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4782, 197, '1EM0011', 'Initial import', 44, '1754218810_214_Board_Decisions_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4783, 198, '1EM0012', 'Initial import', 44, '1754218833_214_Quorum_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4784, 199, '1EM0013', 'Initial import', 44, '1754218880_214_Board_Committees_Policy____Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4785, 200, '1EM0014', 'Initial import', 44, '1754218936_214_Conflict_of_Interest_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4786, 201, '1LCM0013', 'Initial import', 44, '1754805117_214_Business_Continuity_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4787, 202, '1FM0022', 'Initial import', 44, '1754825842_214_Cash_Flow_Management_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4788, 203, '1HRM0007', 'Initial import', 54, '1755772028_214_Employment_Policy____Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4789, 204, '1HRM0002', 'Initial import', 44, '1755772369_214_Anti_Sexual_Harassment_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(4790, 205, '1TM0001', 'Initial import', 54, '1756978632_214_Technical___Underwriting_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4791, 206, '1TM0002', 'Initial import', 44, '1756978686_214_Letters_of_Undertaking_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4792, 207, '1TM0002', 'Initial import', 54, '1756978809_214_Letters_of_Undertaking_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4793, 208, '1TM0003', 'Initial import', 54, '1756978938_214_Policy_for_Preparing_and_Documenting_Insurance_Quotation_Forms.pdf', NULL, '2026-04-29 09:44:26'),
(4794, 209, '1TM0004', 'Initial import', 54, '1756978983_214_Contractual_Clarity_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4795, 210, '1TM0005', 'Initial import', 54, '1756979470_214_Emergency_Response_and_Business_Continuity_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4796, 211, '1TM0006', 'Initial import', 54, '1756979594_214_Disaster_Recovery_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4797, 212, '1TM0007', 'Initial import', 54, '1756979679_214_Errors_and_Omissions__E_O__Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4798, 213, '1TM0008', 'Initial import', 54, '1756979801_214_Insurance_Companies_Engagement_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4799, 214, '1TM0007', 'Initial import', 44, '1756979867_214_Insurance_Companies_Relationship_Management_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4800, 215, '1TM0009', 'Initial import', 54, '1756979919_214_Insurance_Companies_Relationship_Management_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4801, 216, '1TM0010', 'Initial import', 54, '1756980041_214_Insurance_Portfolio_Analysis_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4802, 217, '1TM0011', 'Initial import', 54, '1756980149_214_Whistleblowing_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4803, 218, '1TM0012', 'Initial import', 54, '1756980235_214_Client_Premium_Collection_Confirmation_Before_Policy_Issuance_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4804, 219, '1TM0014', 'Initial import', 54, '1756980365_214_General_Policy_for_Periodic_Inspection.pdf', NULL, '2026-04-29 09:44:26'),
(4805, 220, '1TM0015', 'Initial import', 54, '1756980460_214_Insurance_Claims_Management_and_Electronic_Archiving_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4806, 221, '1TM0016', 'Initial import', 54, '1756980537_214_Policy_on_Terms_of_Business_Agreements__TOBA__with_Clients.pdf', NULL, '2026-04-29 09:44:26'),
(4807, 222, '1ITM0001', 'Initial import', 54, '1756981017_214____________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4808, 223, '1ITM0002', 'Initial import', 54, '1756981245_214____________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4809, 224, '1ITM0003', 'Initial import', 54, '1756981413_214_______________________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4810, 225, '1ITM0004', 'Initial import', 54, '1756981499_214___________________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4811, 226, '1ITM0005', 'Initial import', 54, '1756981622_214____________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4812, 227, '1ITM0006', 'Initial import', 54, '1756981719_214_____________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4813, 228, '1ITM0007', 'Initial import', 54, '1756981794_214___________________________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4814, 229, '1ITM0008', 'Initial import', 54, '1756981896_214__________________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4815, 230, '1ITM0009', 'Initial import', 54, '1756981971_214________________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4816, 231, '1ITM0011', 'Initial import', 54, '1756982039_214_________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4817, 232, '1ITM0012', 'Initial import', 54, '1756982119_214___________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4818, 233, '1ITM0013', 'Initial import', 54, '1756982199_214_______________________________________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4819, 234, '1ITM0014', 'Initial import', 54, '1756982301_214_____________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4820, 235, '1ITM0010', 'Initial import', 54, '1756983216_214___________________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4821, 236, '1TM0013', 'Initial import', 54, '1756983725_214_Issuance_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4822, 237, 'V1', 'Initial import', 44, '1757241442_214_Information_Technology_Procedures.pdf', NULL, '2026-04-29 09:44:26'),
(4823, 238, 'V1.0', 'Initial import', 54, '1757320491_242_Cybersecurity_Department_Procedures.pdf', NULL, '2026-04-29 09:44:26'),
(4824, 239, '1ITM0001', 'Initial import', 54, '1757403101_242_IT_Governance_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4825, 240, '1ITM0002', 'Initial import', 54, '1757403196_242_Information_Technology_Management_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4826, 241, '1ITM0003', 'Initial import', 54, '1757403279_242_IT_User_Security_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4827, 242, '1ITM0004', 'Initial import', 54, '1757403490_242_IT_Systems_Security_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4828, 243, '1ITM0005', 'Initial import', 54, '1757403559_242_Information_Technology_Devices_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4829, 244, '1ITM0006', 'Initial import', 54, '1757403675_242_Information_Technology_Software_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4830, 245, '1ITM0007', 'Initial import', 54, '1757403762_242_Phone_and_Telecommunication_Systems_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4831, 246, '1ITM0008', 'Initial import', 54, '1757403839_242_Administrative_Information_Management_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4832, 247, '1ITM0009', 'Initial import', 54, '1757403922_242_Website_Management_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4833, 248, '1ITM0010', 'Initial import', 54, '1757404009_242_Device_Resources_Management_and_Security_Policy_.pdf', NULL, '2026-04-29 09:44:26');
INSERT INTO `document_versions` (`id`, `document_id`, `version`, `change_summary`, `changed_by_id`, `file_path`, `approved_at`, `created_at`) VALUES
(4834, 249, '1ITM0011', 'Initial import', 54, '1757404117_242_Backup_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4835, 250, '1ITM0012', 'Initial import', 54, '1757404186_242_Access_Management_Policy_.pdf', NULL, '2026-04-29 09:44:26'),
(4836, 251, '1ITM0013', 'Initial import', 54, '1757404269_242_Email___Internet_Usage_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4837, 252, '1ITM0014', 'Initial import', 54, '1757404355_242_Software_Update_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4838, 253, '1TM0001', 'Initial import', 54, '1758201960_242_Policy_for_Organizing_and_Managing.pdf', NULL, '2026-04-29 09:44:26'),
(4839, 254, '1TM0002', 'Initial import', 54, '1758202053_242_Policy_for_Preparing_and_Documenting_Insurance_Quotation_Forms.pdf', NULL, '2026-04-29 09:44:26'),
(4840, 255, '1TM0003', 'Initial import', 54, '1758202151_242_Contractual_Clarity_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4841, 256, '1TM0004', 'Initial import', 54, '1758202207_242_Emergency_Response__Disaster_Recovery__and_Business_Continuity_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4842, 257, '1TM0005', 'Initial import', 54, '1758202250_242_Errors_and_Omissions__E_O__Policy_.pdf', NULL, '2026-04-29 09:44:26'),
(4843, 258, '1TM0006', 'Initial import', 54, '1758202330_242_Policy_for_Dealing_and_Relations_with_Insurance_Companies.pdf', NULL, '2026-04-29 09:44:26'),
(4844, 259, '1TM0007', 'Initial import', 54, '1758202372_242_Insurance_Portfolio_Analysis_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4845, 260, '1TM0008', 'Initial import', 54, '1758202448_242_Whistleblowing_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4846, 261, '1TM0009', 'Initial import', 54, '1758202527_242_Client_Premium_Collection_Confirmation.pdf', NULL, '2026-04-29 09:44:26'),
(4847, 262, '1TM00010', 'Initial import', 54, '1758202574_242_Issuance_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4848, 263, '1TM00012', 'Initial import', 54, '1758202782_242_Electronic_Archiving_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4849, 264, '1TM00013', 'Initial import', 54, '1758202862_242_Policy_on_Terms_of_Business_Agreements__TOBA__with_Clients.pdf', NULL, '2026-04-29 09:44:26'),
(4850, 265, 'NULL', 'Initial import', 54, '1758203050_242_Technical_Procedures.pdf', NULL, '2026-04-29 09:44:26'),
(4851, 266, '2TM0011', 'Initial import', 44, '1760856315_214_General_Policy_for_Periodic_Inspection_and_Review_of_Technical_Surveyors____Reports.pdf', NULL, '2026-04-29 09:44:26'),
(4852, 267, '1HRM0001', 'Initial import', 54, '1763292154_242_training_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4853, 268, '1HRM0007', 'Initial import', 54, '1763292356_242_Recruitment_and_Hiring_Policy__.pdf', NULL, '2026-04-29 09:44:26'),
(4854, 269, '1HRM0017', 'Initial import', 54, '1763292476_242_Career_Path_Development_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4855, 270, '1HRM0004', 'Initial import', 54, '1763292538_242_Corporate_Social_Responsibility_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4856, 271, '1HRM0021', 'Initial import', 54, '1763292602_242_Remote_Work_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4857, 272, '1HRM0018', 'Initial import', 54, '1763292715_242_Complaints_and_Disciplinary_Procedures_Policy__.pdf', NULL, '2026-04-29 09:44:26'),
(4858, 273, '1HRM0013', 'Initial import', 54, '1763292765_242_Business_Travel_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4859, 274, '1HRM0014', 'Initial import', 54, '1763292808_242_Entertainment_and_Hospitality_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4860, 275, '1HRM0011', 'Initial import', 54, '1763292876_242_allowances_and_Promotions_Policy__.pdf', NULL, '2026-04-29 09:44:26'),
(4861, 276, '1HRM0008', 'Initial import', 54, '1763293106_242_Employee_Onboarding_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4862, 277, '1HRM0020', 'Initial import', 54, '1763293214_242_security___Confidentiality_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4863, 278, '1HRM0019', 'Initial import', 54, '1763293280_242_Employee_Rewards_and_Compensation_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4864, 279, '1HRM0016', 'Initial import', 54, '1763293325_242_training_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4865, 280, '1HRM0022', 'Initial import', 54, '1763293365_242_Transportation_and_Assignment_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4866, 281, '1HRM0009', 'Initial import', 44, '1763293409_242_Leave_policy.pdf', NULL, '2026-04-29 09:44:26'),
(4867, 282, '1HRM0005', 'Initial import', 44, '1763293459_242_Loan_Policy__.pdf', NULL, '2026-04-29 09:44:26'),
(4868, 283, '1HRM0015', 'Initial import', 54, '1763293512_242_Performance_Management_and_Evaluation_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4869, 284, '1HRM0012', 'Initial import', 54, '1763293663_242_Employee_Termination_Policy__.pdf', NULL, '2026-04-29 09:44:26'),
(4870, 285, '1HRM0006', 'Initial import', 54, '1763293719_242_General_Human_Resources_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4871, 286, '1HRM0003', 'Initial import', 54, '1763293773_242_Succession_and_Job_Replacement_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4872, 287, '1HRM0002', 'Initial import', 54, '1763293976_242_Sexual_Harassment_Prevention_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4873, 288, '1HRM0019', 'Initial import', 54, '1763294207_242_Employee_Ethics_Policy_and_Code_of_Conduct.pdf', NULL, '2026-04-29 09:44:26'),
(4874, 289, '1HRM0010', 'Initial import', 54, '1763294315_242_Employee_Rewards_and_Compensation_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(4875, 290, '1HRM0001', 'Initial import', 54, '1763294440_242_Attendance_and_Punctuality_Policy__.pdf', NULL, '2026-04-29 09:44:26'),
(4876, 291, 'NULL', 'Initial import', 54, '1764068325_242_Suspicious_Financial_Transaction_Reporting_Form1.pdf', NULL, '2026-04-29 09:44:26'),
(4877, 292, '1QDMFRM2', 'Initial import', 54, '1764135645_242_Suspicious_Financial_Transaction_Reporting_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4878, 293, '1QDMFRM2', 'Initial import', 54, '1764135852_242_Suspicious_Financial_Transaction_Reporting_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4879, 294, '1QDMFRM26', 'Initial import', 54, '1764136145_242_Gift_Disclosure_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4880, 295, '1QDMFRM25', 'Initial import', 54, '1764136280_242_File_Review_Report_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4881, 296, '2QDMFRM134', 'Initial import', 54, '1764136513_242_Quality___Development_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4882, 297, '2QDMFRM13', 'Initial import', 54, '1764136677_242_Operations_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4883, 298, '2QDMFRM135', 'Initial import', 54, '1764136881_242_Technical_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4884, 299, '2QDMFRM138', 'Initial import', 54, '1764136974_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4885, 300, '2QDMFRM138', 'Initial import', 54, '1764137192_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4886, 301, 'NULL', 'Initial import', 54, '1764140056_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4887, 302, 'NULL', 'Initial import', 54, '1764142417_242________________________________________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4888, 303, 'NULL', 'Initial import', 54, '1764142454_242________________________________________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4889, 304, 'NULL', 'Initial import', 54, '1764143300_242________________________________________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4890, 305, 'NULL', 'Initial import', 54, '1764231816_242____________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(4891, 306, 'NULL', 'Initial import', 54, '1764581519_242_Gift_Disclosure_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4892, 307, 'QDMFRM25', 'Initial import', 54, '1764592348_242_File_Review_Report_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4893, 308, '1QDMFRM26', 'Initial import', 54, '1764592513_242_Gift_Disclosure_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4894, 309, '2QDMFRM133', 'Initial import', 54, '1764592622_242_Human_Resources_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4895, 310, '2QDMFRM137', 'Initial import', 54, '1764592768_242_Information_Technology_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4896, 311, '2QDMFRM136', 'Initial import', 54, '1764592849_242_Operations_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4897, 312, '2QDMFRM134', 'Initial import', 54, '1764592954_242_Quality___Development_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4898, 313, '2QDMFRM138', 'Initial import', 54, '1764593014_242_Sales___Marketing_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4899, 314, '1QDMFRM24', 'Initial import', 54, '1764593091_242_Suspicious_Financial_Transaction_Reporting_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4900, 315, '2QDMFRM135', 'Initial import', 54, '1764593197_242_Technical_Management_Commitment_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4901, 316, '1QDMFRM88', 'Initial import', 54, '1764657546_242_Client_Claim_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4902, 317, '1QDMFRM89', 'Initial import', 54, '1764657618_242_Client_Grievance_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4903, 318, '1QDMFRM152', 'Initial import', 54, '1764657877_242_Client_Portfolio_Handover_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4904, 319, '1QDMFRM87', 'Initial import', 54, '1764658015_242_Complaint_Documentation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4905, 320, '1QDMFRM84', 'Initial import', 54, '1764658105_242_Internal_Coordination_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4906, 321, '1QDMFRM05', 'Initial import', 54, '1764658163_242_Loss_of_Renewal_Client_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4907, 322, '1QDMFRM86', 'Initial import', 54, '1764658219_242_Responsibility_Sharing_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4908, 323, '1QDMFRM85', 'Initial import', 54, '1764658278_242_Task_Referral_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4909, 324, '1QDMFRM153', 'Initial import', 54, '1764658345_242_Work_Issued_Mobile_Phone_Acknowledgment_and_Compliance_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4910, 325, '1QDMFRM62', 'Initial import', 54, '1764664008_242_Annual_Objectives_Setting_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4911, 326, '1QDMFRM64', 'Initial import', 54, '1764664017_242_Career_Path_Review_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4912, 327, 'NULL', 'Initial import', 54, '1764664076_242_Clearance_Certificate.pdf', NULL, '2026-04-29 09:44:26'),
(4913, 328, '2QDMFRM114', 'Initial import', 54, '1764664312_242_Clearance_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4914, 329, '2QDMFRM115', 'Initial import', 54, '1764664448_242_Custody_Receipt___Handover_Form_Employee_Trainee.pdf', NULL, '2026-04-29 09:44:26'),
(4915, 330, '2QDMFRM60', 'Initial import', 54, '1764664603_242_Effective_Date_Notice.pdf', NULL, '2026-04-29 09:44:26'),
(4916, 331, '1QDMFRM61', 'Initial import', 54, '1764664686_242_Employee_Complaint_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4917, 332, '1QDMFRM52', 'Initial import', 54, '1764664743_242_Employee_Training_Satisfaction_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4918, 333, 'NULL', 'Initial import', 54, '1764664817_242_Experience_Certificate.pdf', NULL, '2026-04-29 09:44:26'),
(4919, 334, '1QDMFRM56', 'Initial import', 54, '1764664850_242_Final_Evaluation_Form_for_Employee_Onboarding.pdf', NULL, '2026-04-29 09:44:26'),
(4920, 335, '2QDMFRM117', 'Initial import', 54, '1764664981_242_Employee_File_Information.pdf', NULL, '2026-04-29 09:44:26'),
(4921, 336, '2QDMFRM113', 'Initial import', 54, '1764838091_242_Final_Settlement_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4922, 337, '1QDMFRM24', 'Initial import', 54, '1764838246_242_Financial_Clearance_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4923, 338, '1QDMFRM57', 'Initial import', 54, '1764838365_242_Hospitality_Event_Request_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4924, 339, '1QDMFRM55', 'Initial import', 54, '1764838438_242_Initial_Onboarding_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4925, 340, '1QDMFRM118', 'Initial import', 54, '1764838531_242_Internal_Transfer_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4926, 341, '1QDMFRM59', 'Initial import', 54, '1764838612_242_Interview_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4927, 342, 'NULL', 'Initial import', 54, '1764838758_242_Job_Offer.pdf', NULL, '2026-04-29 09:44:26'),
(4928, 343, '1QDMFRM58', 'Initial import', 54, '1764838828_242_Job_Requisition_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4929, 344, 'QDMFRM145', 'Initial import', 54, '1764838958_242_New_Employee_Onboarding.pdf', NULL, '2026-04-29 09:44:26'),
(4930, 345, '2QDMFRM166', 'Initial import', 54, '1764845086_242_Non_disclosure_Agreement.pdf', NULL, '2026-04-29 09:44:26'),
(4931, 346, '2QDMFRM199', 'Initial import', 54, '1764845204_242_Official_Means_of_Communication_for_Staff_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4932, 347, '1QDMFRM54', 'Initial import', 54, '1764845390_242_Self__Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4933, 348, '1QDMFRM51', 'Initial import', 54, '1764845502_242_Sensitive_Tasks_Assignment_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4934, 349, '1QDMFRM53', 'Initial import', 54, '1764845559_242_Training_Initiative_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4935, 350, '1QDMFRM46', 'Initial import', 54, '1764846223_242_Annual_Budget_Request_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4936, 351, '1QDMFRM03', 'Initial import', 54, '1764846303_242_Capital_Expenditure_Request_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4937, 352, '2QDMFRM40', 'Initial import', 54, '1764846404_242_Client__Payment_Reminder_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4938, 353, '1QDMFRM38', 'Initial import', 54, '1764846478_242_Credit_Approval_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4939, 354, '1QDMFRM37', 'Initial import', 54, '1764846559_242_Payment_Request_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4940, 355, '2QDMFRM41', 'Initial import', 54, '1764846627_242_Payment_Request_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4941, 356, '2QDMFRM45', 'Initial import', 54, '1764846688_242_Request_For_Ex_Gratia_Claim_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4942, 357, '1QDMFRM82', 'Initial import', 54, '1764846996_242_Backup_Failure_Report_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4943, 358, '2QDMFRM139', 'Initial import', 54, '1764847156_242_Client_E_Service_Access_Request_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4944, 359, '1QDMFRM76', 'Initial import', 54, '1764847705_242_Device_Loss_Report_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4945, 360, '1QDMFRM79', 'Initial import', 54, '1764847827_242_Emergency_Technical_Incident_Report_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4946, 361, '1QDMFRM80', 'Initial import', 54, '1764847985_242_External_Information_Sharing_Record_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4947, 362, '2QDMFRM140', 'Initial import', 54, '1764848233_242_IT_Services_Request_Form_for_Employees_Trainees.pdf', NULL, '2026-04-29 09:44:26'),
(4948, 363, '1QDMFRM83', 'Initial import', 54, '1764848349_242_Technical_Clearance_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4949, 364, '1QDMFRM78', 'Initial import', 54, '1764848422_242_Technical_or_Major_Content_Change_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4950, 365, '1QDMFRM81', 'Initial import', 54, '1764848496_242_Temporary_Access_Exception_Request_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4951, 366, '1QDMFRM77', 'Initial import', 54, '1764848597_242_Temporary_Receive_Replacement_Device_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4952, 367, '1QDMFRM127', 'Initial import', 54, '1764849524_242_Annual_Evaluation_Form_____Board_Secretary.pdf', NULL, '2026-04-29 09:44:26'),
(4953, 368, '1QDMFRM128', 'Initial import', 54, '1764849543_242_Board_of_Directors_and_Committees_Performance_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4954, 369, '1QDMFRM125', 'Initial import', 54, '1764849664_242_Board_of_Directors_Meeting_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4955, 370, '1QDMFRM126', 'Initial import', 54, '1764849742_242_Conflict_of_Interest_Disclosure_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4956, 371, '1QDMFRM122', 'Initial import', 54, '1764849830_242_Due_Diligence_Review_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4957, 372, '1QDMFRM124', 'Initial import', 54, '1764849899_242_Information_Protection_Undertaking.pdf', NULL, '2026-04-29 09:44:26'),
(4958, 373, '1QDMFRM121', 'Initial import', 54, '1764849974_242_Non_Standard_Contract_Review_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4959, 374, '1QDMFRM123', 'Initial import', 54, '1764850039_242_Remote_Electronic_Voting_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4960, 375, '1QDMFRM107', 'Initial import', 54, '1764850201_242_Client_Satisfaction_and_Critical_Complaint_Action_Plan_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4961, 376, '1QDMFRM108', 'Initial import', 54, '1764850315_242_Client_Satisfaction_Log.pdf', NULL, '2026-04-29 09:44:26'),
(4962, 377, '1QDMFRM103', 'Initial import', 54, '1764850435_242_Early_Risk_Notification_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4963, 378, '1QDMFRM95', 'Initial import', 54, '1764850493_242_Employee_Acknowledgment_of_SLA_Awareness.pdf', NULL, '2026-04-29 09:44:26'),
(4964, 379, '1QDMFRM109', 'Initial import', 54, '1764850684_242_Employee_Satisfaction_Survey_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4965, 380, '1QDMFRM110', 'Initial import', 54, '1764850755_242_Employee_Satisfaction_Survey_Report.pdf', NULL, '2026-04-29 09:44:26'),
(4966, 381, '1QDMFRM102', 'Initial import', 54, '1764850812_242_Impact___Effort_Matrix.pdf', NULL, '2026-04-29 09:44:26'),
(4967, 382, '1QDMFRM101', 'Initial import', 54, '1764850935_242_Improvement_Implementation_Tracking_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4968, 383, '1QDMFRM101', 'Initial import', 54, '1764851046_242_Improvement_Plan_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4969, 384, '1QDMFRM104', 'Initial import', 54, '1764851211_242_Operational_Incident_Report.pdf', NULL, '2026-04-29 09:44:26'),
(4970, 385, '1QDMFRM94', 'Initial import', 54, '1764851264_242_Partner_Breach_Follow_up_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4971, 386, '1QDMFRM91', 'Initial import', 54, '1764851327_242_Partner_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4972, 387, '1QDMFRM90', 'Initial import', 54, '1764851596_242_Partnership_Request_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4973, 388, '1QDMFRM112', 'Initial import', 54, '1764851734_242_Policy_Creation_or_Update_Request_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4974, 389, '1QDMFRM99', 'Initial import', 54, '1764851809_242_Proposed_Improvement_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4975, 390, '1QDMFRM105', 'Initial import', 54, '1764851870_242_Quality_Risk_Register.pdf', NULL, '2026-04-29 09:44:26'),
(4976, 391, '1QDMFRM106', 'Initial import', 54, '1764851921_242_Root_Cause_Analysis_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4977, 392, '1QDMFRM97', 'Initial import', 54, '1764852052_242_SLA_Breach_Report_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4978, 393, '1QDMFRM96', 'Initial import', 54, '1764852769_242_SLA_Periodic_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4979, 394, '1QDMFRM98', 'Initial import', 54, '1764852992_242_SLA_Review_Minutes_____External_Vendor.pdf', NULL, '2026-04-29 09:44:26'),
(4980, 395, '1QDMFRM111', 'Initial import', 54, '1764853184_242_Unstructured_Process_Reporting_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4981, 396, '1QDMFRM92', 'Initial import', 54, '1764853242_242_Value_Triangle_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4982, 397, '1QDMFRM70', 'Initial import', 54, '1765085861_242_Agency_Performance_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4983, 398, '1QDMFRM65', 'Initial import', 54, '1765085974_242_An_internal_evaluation_model_for_Management_satisfaction_with_market_research_outputs.pdf', NULL, '2026-04-29 09:44:26'),
(4984, 399, '1QDMFRM69', 'Initial import', 54, '1765086084_242_Campaign_Performance_Follow_up_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4985, 400, '1QDMFRM68', 'Initial import', 54, '1765086154_242_Campaign_Proposal_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4986, 401, '1QDMFRM66', 'Initial import', 54, '1765086219_242_Client_Event_Request_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4987, 402, '1QDMFRM67', 'Initial import', 54, '1765086320_242_Client_Event_Satisfaction_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4988, 403, '1QDMFRM73', 'Initial import', 54, '1765086370_242_Insurance_Products_Disclosure_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4989, 404, '1QDMFRM75', 'Initial import', 54, '1765086417_242_Internal_Evaluation_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4990, 405, '1QDMFRM71', 'Initial import', 54, '1765086517_242_Marketing_Project_Request_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4991, 406, '1QDMFRM72', 'Initial import', 54, '1765086591_242_Non_Disclosure_Agreement_for_Marketing_Agencies.pdf', NULL, '2026-04-29 09:44:26'),
(4992, 407, '1QDMFRM74', 'Initial import', 54, '1765086655_242_Promotional_Material_Request_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4993, 408, '1QDMFRM75', 'Initial import', 54, '1765087196_242_Product_Development_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4994, 409, 'NULL', 'Initial import', 54, '1765087342_242_BROKER_OF_RECORD_LETTER.pdf', NULL, '2026-04-29 09:44:26'),
(4995, 410, '1QDMFRM32', 'Initial import', 54, '1765087437_242_Corrective_Action_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4996, 411, '1QDMFRM28', 'Initial import', 54, '1765087524_242_Emergency_Recovery_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4997, 412, '1QDMFRM29', 'Initial import', 54, '1765087593_242_Request_for_Inspection_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4998, 413, '1QDMFRM27', 'Initial import', 54, '1765087651_242_Technical_Emergency_Record_Form.pdf', NULL, '2026-04-29 09:44:26'),
(4999, 414, '1QDMFRM31', 'Initial import', 54, '1765087717_242_Technical_Error_Report_Form.pdf', NULL, '2026-04-29 09:44:26'),
(5000, 415, '1QDMFRM3', 'Initial import', 44, '1765174218_214_Accounting_Reconciliation_Memo.pdf', NULL, '2026-04-29 09:44:26'),
(5001, 416, '1QDMFRM39', 'Initial import', 44, '1765174282_214_Accounting_Reconciliation_Memo.pdf', NULL, '2026-04-29 09:44:26'),
(5002, 417, '2QDMFRM42', 'Initial import', 44, '1765174936_214_Petty_Cash_Form.xlsx', NULL, '2026-04-29 09:44:26'),
(5003, 418, '2QDMFRM43', 'Initial import', 44, '1765175028_214_Payment_Cover_form.xlsx', NULL, '2026-04-29 09:44:26'),
(5004, 419, '2QDMFRM44', 'Initial import', 44, '1765175094_214_Event_Expense_Form.xlsx', NULL, '2026-04-29 09:44:26'),
(5005, 420, '1QDMFRM47', 'Initial import', 44, '1765175170_214_Internal_Tax_Declaration_Form.xlsx', NULL, '2026-04-29 09:44:26'),
(5006, 421, '2QDMFRM44', 'Initial import', 44, '1765175375_214_Event_Expense_Form.xlsx', NULL, '2026-04-29 09:44:26'),
(5007, 422, '1QDMFRM30', 'Initial import', 44, '1765177851_214_Client_Complaint_Form.pdf', NULL, '2026-04-29 09:44:26'),
(5008, 423, '1QDMFRM33', 'Initial import', 44, '1765178456_214_Manual_Operation_Form.xlsx', NULL, '2026-04-29 09:44:26'),
(5009, 424, '1QDMFRM34', 'Initial import', 44, '1765279882_214_Brokerage_Slip.pdf', NULL, '2026-04-29 09:44:26'),
(5010, 425, '1QDMFRM.33', 'Initial import', 44, '1765280345_214_Brokerage_Slip.pdf', NULL, '2026-04-29 09:44:26'),
(5011, 426, '1QDMFRM35', 'Initial import', 44, '1765280492_214_TOBA.pdf', NULL, '2026-04-29 09:44:26'),
(5012, 427, '1QDMFRM35', 'Initial import', 44, '1765280618_214_TOBA.pdf', NULL, '2026-04-29 09:44:26'),
(5013, 428, '1QDMFRM48', 'Initial import', 44, '1765284385_214_Supplier_Registration_Form.pdf', NULL, '2026-04-29 09:44:26'),
(5014, 429, '1QDMFRM49', 'Initial import', 44, '1765284506_214_Purchase_Request_Form__PR_.pdf', NULL, '2026-04-29 09:44:26'),
(5015, 430, '1QDMFRM50', 'Initial import', 44, '1765284789_214_Price_Comparison_Form.pdf', NULL, '2026-04-29 09:44:26'),
(5016, 431, '2QDMFRM.45', 'Initial import', 44, '1765799360_214_Request_For_Ex_Gratia_Claim_Form.pdf', NULL, '2026-04-29 09:44:26'),
(5017, 432, '1OM000.3', 'Initial import', 44, '1766469015_214_Renewals_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(5018, 433, '1OM000.4', 'Initial import', 44, '1766469080_214_Immediate_Client_Response_Assurance_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(5019, 434, '1OM000.6', 'Initial import', 44, '1766469109_214_Client_Care_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(5020, 435, '1OM000.7', 'Initial import', 44, '1766469184_214_Client_Complaints_Management_Policy___Arabic.pdf', NULL, '2026-04-29 09:44:26'),
(5021, 436, '1OM0015', 'Initial import', 44, '1767165609_214_Internal_Policy_for_Monthly_Productivity_Reconciliation.pdf', NULL, '2026-04-29 09:44:26'),
(5022, 437, '1OM00.15', 'Initial import', 44, '1767165705_214_Internal_Policy_for_Monthly_Productivity_Reconciliation.pdf', NULL, '2026-04-29 09:44:26'),
(5023, 438, '1SP0001', 'Initial import', 44, '1767609477_214_IT_Governance_and_Cybersecurity_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5024, 439, '1SP0002', 'Initial import', 44, '1767610087_214_Digital_Platform_Operations.pdf', NULL, '2026-04-29 09:44:26'),
(5025, 440, '1SP0003', 'Initial import', 44, '1767610128_214_Privacy_and_Data_Protection_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5026, 441, '1SP0004', 'Initial import', 44, '1767610263_214_Systems_Development_and_Change_Management_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5027, 442, '1SP0005', 'Initial import', 44, '1767610334_214_Systems_Integration_and_Application.pdf', NULL, '2026-04-29 09:44:26'),
(5028, 443, '1SP0006', 'Initial import', 44, '1767610419_214_Access_Management.pdf', NULL, '2026-04-29 09:44:26'),
(5029, 444, '1SP0007', 'Initial import', 44, '1767610608_214_Website_and_Mobile_Application_Management_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5030, 445, '1SP0008', 'Initial import', 44, '1767610683_214_IT_Vendors_and_Technical_Services.pdf', NULL, '2026-04-29 09:44:26'),
(5031, 446, '1SP0009', 'Initial import', 44, '1767610767_214_Security_Awareness_and_Training_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5032, 447, '1SP0010', 'Initial import', 44, '1767610868_214_Platform_Transactions_and_Financial.pdf', NULL, '2026-04-29 09:44:26'),
(5033, 448, '1SP0011', 'Initial import', 44, '1767610897_214_Partners_Management_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5034, 449, '1SP0012', 'Initial import', 44, '1767611089_214_Marketing_and_Promotional_Campaigns.pdf', NULL, '2026-04-29 09:44:26'),
(5035, 450, '1SP0013', 'Initial import', 44, '1767611230_214_Customer_Service_and_User_Experience_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5036, 451, '1SP0014', 'Initial import', 44, '1767611280_214_Talent_Acquisition_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5037, 452, '1ITM0016', 'Initial import', 44, '1767688238_214_Domain_and_Technical_Subscription_Management_and_Renewal_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5038, 453, 'QDMFRM163', 'Initial import', 44, '1767689122_214_______________________________________________.xlsx', NULL, '2026-04-29 09:44:26'),
(5039, 454, '1LCM009', 'Initial import', 44, '1767858849_214_Anti_fraud_policy.pdf', NULL, '2026-04-29 09:44:26'),
(5040, 455, '1LCM09', 'Initial import', 44, '1767858899_214_Anti_fraud_policy.pdf', NULL, '2026-04-29 09:44:26'),
(5041, 456, '1LCM9', 'Initial import', 44, '1767858947_214_Anti_fraud_policy.pdf', NULL, '2026-04-29 09:44:26'),
(5042, 457, 'LCM009', 'Initial import', 44, '1767865044_214_Anti_fraud_policy.pdf', NULL, '2026-04-29 09:44:26'),
(5043, 458, 'QDMFRM145', 'Initial import', 54, '1768382451_242_New_Employee_Onboarding__Form.pdf', NULL, '2026-04-29 09:44:26'),
(5044, 459, 'v2.0', 'Initial import', 44, '1768989040_214_technical_procedures.pdf', NULL, '2026-04-29 09:44:26'),
(5045, 460, '1HRM0012', 'Initial import', 54, '1769500117_242__________________________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(5046, 461, '1ITM0013', 'Initial import', 54, '1769502233_242_Email___Internet_Use_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5047, 462, '1.0', 'Initial import', 54, '1769505178_242_Human_Resources_Procedure.pdf', NULL, '2026-04-29 09:44:26'),
(5048, 463, '1.0', 'Initial import', 54, '1769595417_242_Human_Resources_Procedures.pdf', NULL, '2026-04-29 09:44:26'),
(5049, 464, '1.0', 'Initial import', 44, '1771156460_214_Handover_certificate_Diamond.xlsx', NULL, '2026-04-29 09:44:26'),
(5050, 465, '2HRM0007', 'Initial import', 44, '1774526235_214_Hiring_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5051, 466, '2FM0021', 'Initial import', 44, '1774934654_214_Financial_Records_and_Archiving_Management_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5052, 467, '2FM0004', 'Initial import', 44, '1774934944_214_Accounting_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5053, 468, '2FM0002', 'Initial import', 44, '1774935145_214_Budget_Planning_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5054, 469, '2FM0009', 'Initial import', 44, '1774935589_214_Capital_Expenditure_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5055, 470, '2FM0019', 'Initial import', 44, '1774935948_214_Collections_and_Aging_of_Receivables_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5056, 471, '2FM0015', 'Initial import', 44, '1774936242_214_Accounting_Adjustments_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5057, 472, '2FM0013', 'Initial import', 44, '1774936470_214_Internal_Control_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5058, 473, '2FM0010', 'Initial import', 44, '1774936584_214_Investments_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5059, 474, '2FM0008', 'Initial import', 44, '1774936714_214_Petty_Cash_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5060, 475, '2FM0020', 'Initial import', 44, '1774936897_214_Segregation_of_Financial_Duties_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5061, 476, '2FM0014', 'Initial import', 44, '1774937010_214_Loss_Reporting_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5062, 477, '1QDMFRM1', 'Initial import', 44, '1774937054_214_Operational_Loss_Reporting_Form.pdf', NULL, '2026-04-29 09:44:26'),
(5063, 478, '1FM0024', 'Initial import', 44, '1774938401_214_Fixed_Assets_Management_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5064, 479, '1QDMFRM155', 'Initial import', 44, '1774939625_214_Master_Asset_Register.xlsx', NULL, '2026-04-29 09:44:26'),
(5065, 480, '1QDMFRM156', 'Initial import', 44, '1774939862_214_Inventory_Register.xlsx', NULL, '2026-04-29 09:44:26'),
(5066, 481, '1QDMFRM157', 'Initial import', 44, '1774940028_214_Asset_Operations_Log__Maintenance_____Storage_____Disposal_.xlsx', NULL, '2026-04-29 09:44:26'),
(5067, 482, '1QDMFRM158', 'Initial import', 44, '1774940200_214_Damage___Loss_Register.xlsx', NULL, '2026-04-29 09:44:26'),
(5068, 483, '1FM0025', 'Initial import', 44, '1774940711_214_Policy_for_Managing_and_Monitoring_Aged_Receivables.pdf', NULL, '2026-04-29 09:44:26'),
(5069, 484, '1QDMFRM160', 'Initial import', 44, '1774940976_214_Aged_Receivables_Tracking_Form.xlsx', NULL, '2026-04-29 09:44:26'),
(5070, 485, '1QDMFRM159', 'Initial import', 44, '1774941426_214.xlsx', NULL, '2026-04-29 09:44:26'),
(5071, 486, '2HRM0009', 'Initial import', 44, '1774945876_214_Leave_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5072, 487, '2HRM0005', 'Initial import', 44, '1774949602_214_Loan_Policy.pdf', NULL, '2026-04-29 09:44:26'),
(5073, 488, 'QDMFRM16', 'Initial import', 54, '1775464323_242______________________________________.pdf', NULL, '2026-04-29 09:44:26'),
(5074, 489, '3HRM0007', 'Initial import', 44, '1776688644_214_Hiring_policy.pdf', NULL, '2026-04-29 09:44:26'),
(5075, 490, '2FM00.17', 'Initial import', 44, '1776941426_214_Commission_Disbursement.pdf', NULL, '2026-04-29 09:44:26'),
(5076, 491, '2HRM0001', 'Initial import', 44, '1776952037_214_Attendance_and_Punctuality_Policy.pdf', NULL, '2026-04-29 09:44:26');

-- --------------------------------------------------------

--
-- Table structure for table `email_templates`
--

CREATE TABLE `email_templates` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `slug` varchar(100) NOT NULL,
  `name` varchar(255) NOT NULL,
  `module` varchar(50) NOT NULL,
  `trigger_event` varchar(100) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `body_html` text NOT NULL,
  `variables` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`variables`)),
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `email_templates`
--

INSERT INTO `email_templates` (`id`, `slug`, `name`, `module`, `trigger_event`, `subject`, `body_html`, `variables`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'request_created', 'Request Created', 'requests', 'created', 'New Request {{ref}}: {{title}}', '<p>Dear Team,</p><p>A new request has been submitted by <strong>{{requester}}</strong>.</p><ul><li><strong>Reference:</strong> {{ref}}</li><li><strong>Title:</strong> {{title}}</li><li><strong>Due Date:</strong> {{due_date}}</li></ul><p>Please review it at: <a href=\'{{link}}\'>{{link}}</a></p><p>Regards,<br>QMS Pro System</p>', '[{\"key\":\"{{ref}}\",\"desc\":\"Request reference number\"},{\"key\":\"{{title}}\",\"desc\":\"Request title\"},{\"key\":\"{{requester}}\",\"desc\":\"Requester name\"},{\"key\":\"{{status}}\",\"desc\":\"Current status\"},{\"key\":\"{{due_date}}\",\"desc\":\"Due date\"},{\"key\":\"{{link}}\",\"desc\":\"Link to the request\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(2, 'request_approved', 'Request Approved', 'requests', 'approved', 'Request {{ref}} has been Approved', '<p>Dear {{requester}},</p><p>Your request <strong>{{ref}} — {{title}}</strong> has been <strong style=\'color:green\'>approved</strong>.</p><p>View details: <a href=\'{{link}}\'>{{link}}</a></p><p>Regards,<br>QMS Pro System</p>', '[{\"key\":\"{{ref}}\",\"desc\":\"Request reference number\"},{\"key\":\"{{title}}\",\"desc\":\"Request title\"},{\"key\":\"{{requester}}\",\"desc\":\"Requester name\"},{\"key\":\"{{status}}\",\"desc\":\"Current status\"},{\"key\":\"{{due_date}}\",\"desc\":\"Due date\"},{\"key\":\"{{link}}\",\"desc\":\"Link to the request\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(3, 'request_rejected', 'Request Rejected', 'requests', 'rejected', 'Request {{ref}} was Rejected', '<p>Dear {{requester}},</p><p>Your request <strong>{{ref}} — {{title}}</strong> has been <strong style=\'color:red\'>rejected</strong>.</p><p>View details: <a href=\'{{link}}\'>{{link}}</a></p><p>Regards,<br>QMS Pro System</p>', '[{\"key\":\"{{ref}}\",\"desc\":\"Request reference number\"},{\"key\":\"{{title}}\",\"desc\":\"Request title\"},{\"key\":\"{{requester}}\",\"desc\":\"Requester name\"},{\"key\":\"{{status}}\",\"desc\":\"Current status\"},{\"key\":\"{{due_date}}\",\"desc\":\"Due date\"},{\"key\":\"{{link}}\",\"desc\":\"Link to the request\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(4, 'request_overdue', 'Request Overdue', 'requests', 'overdue', 'OVERDUE: Request {{ref}} past due date', '<p>Attention,</p><p>Request <strong>{{ref}} — {{title}}</strong> assigned to <strong>{{requester}}</strong> is now <strong style=\'color:red\'>overdue</strong> (was due {{due_date}}).</p><p><a href=\'{{link}}\'>View Request</a></p>', '[{\"key\":\"{{ref}}\",\"desc\":\"Request reference number\"},{\"key\":\"{{title}}\",\"desc\":\"Request title\"},{\"key\":\"{{requester}}\",\"desc\":\"Requester name\"},{\"key\":\"{{status}}\",\"desc\":\"Current status\"},{\"key\":\"{{due_date}}\",\"desc\":\"Due date\"},{\"key\":\"{{link}}\",\"desc\":\"Link to the request\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(5, 'nc_created', 'NC Raised', 'nc', 'created', 'New Non-Conformance Raised: {{ref}}', '<p>A new non-conformance has been raised.</p><ul><li><strong>Ref:</strong> {{ref}}</li><li><strong>Title:</strong> {{title}}</li><li><strong>Severity:</strong> {{severity}}</li><li><strong>Assigned To:</strong> {{assignee}}</li><li><strong>Due:</strong> {{due_date}}</li></ul><p><a href=\'{{link}}\'>View NC</a></p>', '[{\"key\":\"{{ref}}\",\"desc\":\"NC reference number\"},{\"key\":\"{{title}}\",\"desc\":\"NC title\"},{\"key\":\"{{severity}}\",\"desc\":\"Severity level\"},{\"key\":\"{{assignee}}\",\"desc\":\"Assigned to\"},{\"key\":\"{{due_date}}\",\"desc\":\"Due date\"},{\"key\":\"{{link}}\",\"desc\":\"Link to the NC\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(6, 'nc_overdue', 'NC Overdue', 'nc', 'overdue', 'OVERDUE NC: {{ref}} — {{title}}', '<p>Non-conformance <strong>{{ref}}</strong> assigned to <strong>{{assignee}}</strong> is past its due date of {{due_date}}.</p><p>Severity: <strong>{{severity}}</strong></p><p><a href=\'{{link}}\'>View NC</a></p>', '[{\"key\":\"{{ref}}\",\"desc\":\"NC reference number\"},{\"key\":\"{{title}}\",\"desc\":\"NC title\"},{\"key\":\"{{severity}}\",\"desc\":\"Severity level\"},{\"key\":\"{{assignee}}\",\"desc\":\"Assigned to\"},{\"key\":\"{{due_date}}\",\"desc\":\"Due date\"},{\"key\":\"{{link}}\",\"desc\":\"Link to the NC\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(7, 'capa_assigned', 'CAPA Assigned', 'capa', 'assigned', 'CAPA Assigned to You: {{ref}}', '<p>Dear {{assignee}},</p><p>A CAPA action has been assigned to you.</p><ul><li><strong>Ref:</strong> {{ref}}</li><li><strong>Title:</strong> {{title}}</li><li><strong>Due Date:</strong> {{due_date}}</li></ul><p><a href=\'{{link}}\'>View CAPA</a></p>', '[{\"key\":\"{{ref}}\",\"desc\":\"CAPA reference number\"},{\"key\":\"{{title}}\",\"desc\":\"CAPA title\"},{\"key\":\"{{assignee}}\",\"desc\":\"Assigned to\"},{\"key\":\"{{due_date}}\",\"desc\":\"Due date\"},{\"key\":\"{{status}}\",\"desc\":\"Current status\"},{\"key\":\"{{link}}\",\"desc\":\"Link to the CAPA\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(8, 'capa_overdue', 'CAPA Overdue', 'capa', 'overdue', 'OVERDUE CAPA: {{ref}} — Action Required', '<p>CAPA <strong>{{ref}} — {{title}}</strong> is overdue.</p><p>Responsible: <strong>{{assignee}}</strong><br>Was due: <strong>{{due_date}}</strong></p><p>Please update immediately: <a href=\'{{link}}\'>{{link}}</a></p>', '[{\"key\":\"{{ref}}\",\"desc\":\"CAPA reference number\"},{\"key\":\"{{title}}\",\"desc\":\"CAPA title\"},{\"key\":\"{{assignee}}\",\"desc\":\"Assigned to\"},{\"key\":\"{{due_date}}\",\"desc\":\"Due date\"},{\"key\":\"{{status}}\",\"desc\":\"Current status\"},{\"key\":\"{{link}}\",\"desc\":\"Link to the CAPA\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(9, 'capa_closed', 'CAPA Closed', 'capa', 'closed', 'CAPA Closed: {{ref}}', '<p>CAPA <strong>{{ref}} — {{title}}</strong> has been <strong style=\'color:green\'>closed</strong> successfully.</p><p>Closed by: {{assignee}}</p><p><a href=\'{{link}}\'>View CAPA</a></p>', '[{\"key\":\"{{ref}}\",\"desc\":\"CAPA reference number\"},{\"key\":\"{{title}}\",\"desc\":\"CAPA title\"},{\"key\":\"{{assignee}}\",\"desc\":\"Assigned to\"},{\"key\":\"{{due_date}}\",\"desc\":\"Due date\"},{\"key\":\"{{status}}\",\"desc\":\"Current status\"},{\"key\":\"{{link}}\",\"desc\":\"Link to the CAPA\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(10, 'risk_high_identified', 'High/Critical Risk Identified', 'risk', 'high_risk', 'High Risk Identified: {{ref}} — {{title}}', '<p>A <strong>{{level}}</strong> risk has been identified.</p><ul><li><strong>Ref:</strong> {{ref}}</li><li><strong>Title:</strong> {{title}}</li><li><strong>Score:</strong> {{score}}</li><li><strong>Owner:</strong> {{owner}}</li><li><strong>Next Review:</strong> {{review_date}}</li></ul>', '[{\"key\":\"{{ref}}\",\"desc\":\"Risk reference number\"},{\"key\":\"{{title}}\",\"desc\":\"Risk title\"},{\"key\":\"{{level}}\",\"desc\":\"Risk level (critical\\/high\\/medium\\/low)\"},{\"key\":\"{{score}}\",\"desc\":\"Risk score\"},{\"key\":\"{{owner}}\",\"desc\":\"Risk owner\"},{\"key\":\"{{review_date}}\",\"desc\":\"Next review date\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(11, 'risk_review_due', 'Risk Review Due', 'risk', 'review_due', 'Risk Review Due: {{ref}} — {{title}}', '<p>Risk <strong>{{ref}} — {{title}}</strong> is due for review on <strong>{{review_date}}</strong>.</p><p>Current level: <strong>{{level}}</strong> (Score: {{score}})</p><p>Owner: {{owner}}</p>', '[{\"key\":\"{{ref}}\",\"desc\":\"Risk reference number\"},{\"key\":\"{{title}}\",\"desc\":\"Risk title\"},{\"key\":\"{{level}}\",\"desc\":\"Risk level (critical\\/high\\/medium\\/low)\"},{\"key\":\"{{score}}\",\"desc\":\"Risk score\"},{\"key\":\"{{owner}}\",\"desc\":\"Risk owner\"},{\"key\":\"{{review_date}}\",\"desc\":\"Next review date\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(12, 'audit_planned', 'Audit Planned', 'audit', 'planned', 'Audit Scheduled: {{ref}} — {{title}}', '<p>An audit has been scheduled.</p><ul><li><strong>Ref:</strong> {{ref}}</li><li><strong>Title:</strong> {{title}}</li><li><strong>Department:</strong> {{department}}</li><li><strong>Lead Auditor:</strong> {{lead_auditor}}</li><li><strong>Start Date:</strong> {{start_date}}</li></ul>', '[{\"key\":\"{{ref}}\",\"desc\":\"Audit reference number\"},{\"key\":\"{{title}}\",\"desc\":\"Audit title\"},{\"key\":\"{{lead_auditor}}\",\"desc\":\"Lead auditor name\"},{\"key\":\"{{start_date}}\",\"desc\":\"Planned start date\"},{\"key\":\"{{department}}\",\"desc\":\"Auditee department\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(13, 'audit_completed', 'Audit Completed', 'audit', 'completed', 'Audit Completed: {{ref}} — {{title}}', '<p>Audit <strong>{{ref}} — {{title}}</strong> has been completed by <strong>{{lead_auditor}}</strong>.</p><p>Department: {{department}}</p><p>Please review the findings in the system.</p>', '[{\"key\":\"{{ref}}\",\"desc\":\"Audit reference number\"},{\"key\":\"{{title}}\",\"desc\":\"Audit title\"},{\"key\":\"{{lead_auditor}}\",\"desc\":\"Lead auditor name\"},{\"key\":\"{{start_date}}\",\"desc\":\"Planned start date\"},{\"key\":\"{{department}}\",\"desc\":\"Auditee department\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(14, 'complaint_received', 'Complaint Received', 'complaints', 'created', 'New Complaint Received: {{ref}}', '<p>A new complaint has been received.</p><ul><li><strong>Ref:</strong> {{ref}}</li><li><strong>Subject:</strong> {{subject}}</li><li><strong>From:</strong> {{complainant}}</li><li><strong>Priority:</strong> {{priority}}</li><li><strong>Due:</strong> {{due_date}}</li></ul>', '[{\"key\":\"{{ref}}\",\"desc\":\"Complaint reference number\"},{\"key\":\"{{subject}}\",\"desc\":\"Complaint subject\"},{\"key\":\"{{complainant}}\",\"desc\":\"Complainant name\"},{\"key\":\"{{priority}}\",\"desc\":\"Priority level\"},{\"key\":\"{{due_date}}\",\"desc\":\"Resolution due date\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(15, 'complaint_resolved', 'Complaint Resolved', 'complaints', 'resolved', 'Complaint Resolved: {{ref}}', '<p>Dear {{complainant}},</p><p>Your complaint <strong>{{ref}} — {{subject}}</strong> has been resolved.</p><p>Thank you for bringing this to our attention.</p><p>Regards,<br>Quality Team</p>', '[{\"key\":\"{{ref}}\",\"desc\":\"Complaint reference number\"},{\"key\":\"{{subject}}\",\"desc\":\"Complaint subject\"},{\"key\":\"{{complainant}}\",\"desc\":\"Complainant name\"},{\"key\":\"{{priority}}\",\"desc\":\"Priority level\"},{\"key\":\"{{due_date}}\",\"desc\":\"Resolution due date\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(16, 'visit_confirmed', 'Visit Confirmed', 'visits', 'confirmed', 'Visit Confirmed: {{ref}} — {{client}}', '<p>A client visit has been confirmed.</p><ul><li><strong>Client:</strong> {{client}}</li><li><strong>Date:</strong> {{date}}</li><li><strong>Time:</strong> {{time}}</li><li><strong>Location:</strong> {{location}}</li><li><strong>Host:</strong> {{host}}</li></ul>', '[{\"key\":\"{{ref}}\",\"desc\":\"Visit reference number\"},{\"key\":\"{{client}}\",\"desc\":\"Client name\"},{\"key\":\"{{date}}\",\"desc\":\"Visit date\"},{\"key\":\"{{time}}\",\"desc\":\"Visit time\"},{\"key\":\"{{host}}\",\"desc\":\"Host name\"},{\"key\":\"{{location}}\",\"desc\":\"Visit location\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23'),
(17, 'visit_reminder', 'Visit Reminder', 'visits', 'reminder', 'Visit Reminder Tomorrow: {{client}} — {{date}}', '<p>Reminder: You have a visit scheduled tomorrow.</p><ul><li><strong>Client:</strong> {{client}}</li><li><strong>Date:</strong> {{date}} at {{time}}</li><li><strong>Location:</strong> {{location}}</li><li><strong>Ref:</strong> {{ref}}</li></ul>', '[{\"key\":\"{{ref}}\",\"desc\":\"Visit reference number\"},{\"key\":\"{{client}}\",\"desc\":\"Client name\"},{\"key\":\"{{date}}\",\"desc\":\"Visit date\"},{\"key\":\"{{time}}\",\"desc\":\"Visit time\"},{\"key\":\"{{host}}\",\"desc\":\"Host name\"},{\"key\":\"{{location}}\",\"desc\":\"Visit location\"}]', 1, '2026-03-05 09:55:23', '2026-03-05 09:55:23');

-- --------------------------------------------------------

--
-- Table structure for table `key_results`
--

CREATE TABLE `key_results` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `objective_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `metric_type` enum('percentage','number','boolean','currency') NOT NULL DEFAULT 'percentage',
  `start_value` decimal(10,2) NOT NULL DEFAULT 0.00,
  `target_value` decimal(10,2) NOT NULL,
  `current_value` decimal(10,2) NOT NULL DEFAULT 0.00,
  `progress_percent` decimal(5,2) GENERATED ALWAYS AS (case when `target_value` = `start_value` then 100 else least(100,(`current_value` - `start_value`) / (`target_value` - `start_value`) * 100) end) STORED,
  `status` enum('on_track','at_risk','off_track','completed') NOT NULL DEFAULT 'on_track',
  `unit` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kr_check_ins`
--

CREATE TABLE `kr_check_ins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key_result_id` bigint(20) UNSIGNED NOT NULL,
  `value` decimal(10,2) NOT NULL,
  `notes` text DEFAULT NULL,
  `confidence_level` tinyint(4) DEFAULT NULL,
  `checked_by_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2024_01_01_000001_create_departments_table', 1),
(2, '2024_01_01_000002_create_roles_table', 1),
(3, '2024_01_01_000003_create_users_table', 1),
(4, '2024_01_01_000004_create_personal_access_tokens_table', 1),
(5, '2024_01_01_000005_create_module1_request_management_tables', 1),
(6, '2024_01_01_000005b_add_missing_request_columns', 1),
(7, '2024_01_01_000006_create_module2_nc_capa_tables', 1),
(8, '2024_01_01_000007_create_module3_risk_management_tables', 1),
(9, '2024_01_01_000008_create_module4_document_control_tables', 1),
(10, '2024_01_01_000009_create_module5_audit_management_tables', 1),
(11, '2024_01_01_000010_create_module6_client_visit_tables', 1),
(12, '2024_01_01_000011_create_module7_sla_okr_tables', 1),
(13, '2024_01_01_000012_create_module8_vendor_partnership_tables', 1),
(14, '2024_01_01_000013_create_module9_complaints_and_system_tables', 1),
(15, '2024_01_01_000014_create_module10_csat_survey_tables', 1),
(16, '2024_01_02_000001_create_admin_tables', 1),
(17, '2026_03_03_131301_create_sessions_table', 1),
(18, '2026_03_04_150200_create_cache_table', 1),
(19, '2024_01_01_000008b_add_document_departments_table', 2),
(20, '2024_01_03_000001_add_target_department_to_requests', 3),
(21, '2026_03_12_124533_create_document_access_logs_table', 3),
(22, '2026_05_01_add_qdm_fields_to_requests_table', 4),
(23, '2026_05_02_update_request_categories', 5),
(24, '2026_05_03_reset_request_category_ids', 6),
(25, '2026_05_10_add_description_to_departments', 7),
(26, '2026_04_30_112032_create_password_reset_tokens_table', 8),
(27, '2026_05_04_114310_add_created_by_to_complaints_table', 9),
(28, '2026_05_04_114312_add_created_by_to_complaints_table', 10);

-- --------------------------------------------------------

--
-- Table structure for table `nc_categories`
--

CREATE TABLE `nc_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `severity_default` enum('minor','major','critical') NOT NULL DEFAULT 'minor'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nc_categories`
--

INSERT INTO `nc_categories` (`id`, `name`, `description`, `severity_default`) VALUES
(1, 'Process Non-Conformance', 'Deviations from defined processes', 'minor'),
(2, 'Product/Service Quality', 'Quality failures in products or services', 'major'),
(3, 'Documentation', 'Documentation errors or gaps', 'minor'),
(4, 'Regulatory Compliance', 'Regulatory requirement breaches', 'critical'),
(5, 'Customer Requirement', 'Failure to meet customer requirements', 'major'),
(6, 'Supplier / Vendor Issue', 'Non-conformances originating from vendors', 'major'),
(7, 'Process Non-Conformance', 'Deviations from defined processes', 'minor'),
(8, 'Product/Service Quality', 'Quality failures in products or services', 'major'),
(9, 'Documentation', 'Documentation errors or gaps', 'minor'),
(10, 'Regulatory Compliance', 'Regulatory requirement breaches', 'critical'),
(11, 'Customer Requirement', 'Failure to meet customer requirements', 'major'),
(12, 'Supplier / Vendor Issue', 'Non-conformances originating from vendors', 'major'),
(13, 'Process Non-Conformance', 'Deviations from defined processes', 'minor'),
(14, 'Product/Service Quality', 'Quality failures in products or services', 'major'),
(15, 'Documentation', 'Documentation errors or gaps', 'minor'),
(16, 'Regulatory Compliance', 'Regulatory requirement breaches', 'critical'),
(17, 'Customer Requirement', 'Failure to meet customer requirements', 'major'),
(18, 'Supplier / Vendor Issue', 'Non-conformances originating from vendors', 'major');

-- --------------------------------------------------------

--
-- Table structure for table `nonconformances`
--

CREATE TABLE `nonconformances` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reference_no` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `detected_by_id` bigint(20) UNSIGNED NOT NULL,
  `assigned_to_id` bigint(20) UNSIGNED DEFAULT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `severity` enum('minor','major','critical') NOT NULL DEFAULT 'minor',
  `status` enum('open','under_investigation','pending_capa','capa_in_progress','effectiveness_check','closed','cancelled') NOT NULL DEFAULT 'open',
  `source` enum('internal_audit','external_audit','client_complaint','process_review','supplier_issue','regulatory','other') NOT NULL DEFAULT 'other',
  `detection_date` date NOT NULL,
  `target_closure_date` date DEFAULT NULL,
  `actual_closure_date` date DEFAULT NULL,
  `immediate_action` text DEFAULT NULL,
  `root_cause` text DEFAULT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nonconformances`
--

INSERT INTO `nonconformances` (`id`, `reference_no`, `title`, `description`, `category_id`, `detected_by_id`, `assigned_to_id`, `department_id`, `severity`, `status`, `source`, `detection_date`, `target_closure_date`, `actual_closure_date`, `immediate_action`, `root_cause`, `attachments`, `created_at`, `updated_at`) VALUES
(1, 'NC-2024-0001', 'Missing Audit Trail in Claims Processing', 'Audit trail records missing for 23 claims processed between Dec 10-15. Violates ISO 9001 clause 9.1.3.', 3, 8, 5, 3, 'major', 'capa_in_progress', 'internal_audit', '2024-01-08', '2024-02-15', NULL, 'Claims processing halted and manual review initiated for affected period.', 'Logging module disabled during patch deployment on Dec 9.', NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(2, 'NC-2024-0002', 'Non-Compliant Document Retention Policy', 'HR department retaining employee personal data beyond the 5-year policy limit.', 4, 9, 6, 5, 'critical', 'under_investigation', 'regulatory', '2024-01-15', '2024-01-31', NULL, 'Data access restricted pending investigation. DPO notified.', NULL, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(3, 'NC-2024-0003', 'Service Response Time SLA Breach', 'Customer service response time averaged 6.2 hours vs. SLA target of 4 hours for Q4 2023.', 5, 2, 13, 8, 'major', 'pending_capa', 'client_complaint', '2024-01-10', '2024-02-28', NULL, 'Additional customer service agents brought in. Escalation thresholds reduced to 3 hours.', 'Understaffing during peak season. Absence of automated routing system.', NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(4, 'NC-2024-0004', 'Vendor Invoice Without PO Reference', '3 vendor invoices processed in December without corresponding purchase orders.', 1, 8, 12, 4, 'minor', 'open', 'process_review', '2024-01-20', '2024-02-10', NULL, 'Invoices placed on hold. Finance team notified.', NULL, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(5, 'NC-2024-0005', 'IT System Downtime Exceeding RTO', 'Core banking integration was unavailable for 6.5 hours on Jan 5, exceeding the 4-hour RTO target.', 2, 5, 5, 3, 'critical', 'closed', 'internal_audit', '2024-01-05', '2024-01-25', '2024-01-22', 'Failover system activated. Vendor engaged for emergency support.', 'Primary database server failure. Backup procedure not properly documented.', NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(6, 'NC-2026-0006', 'IT documentation missing', 'We identified that there is no doumentation for IT systems', 3, 1, NULL, 3, 'major', 'open', 'internal_audit', '2026-04-15', '2026-05-15', NULL, 'Informed IT department to create the documentation', NULL, NULL, '2026-04-15 08:06:50', '2026-04-15 08:06:50'),
(7, 'NC-2026-0007', 'IT documentation is missing', 'We identified that IT department is missing IT documentaiton', 3, 2, 10, 3, 'major', 'closed', 'internal_audit', '2026-04-15', '2026-05-15', '2026-04-15', 'Infomed IT department about missing documentation', NULL, NULL, '2026-04-15 08:22:12', '2026-04-15 08:26:06');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(100) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text DEFAULT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data`)),
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `type`, `title`, `message`, `data`, `read_at`, `created_at`) VALUES
(1, 1, 'request_approved', 'Your Request Has Been Approved', 'Request REQ-2026-0017 has been approved.', '{\"request_id\":17}', NULL, '2026-04-16 11:58:20'),
(2, 26, 'request_approved', 'Your Request Has Been Approved', 'Request REQ-2026-0020 has been approved.', '{\"request_id\":20}', NULL, '2026-05-03 08:56:09');

-- --------------------------------------------------------

--
-- Table structure for table `objectives`
--

CREATE TABLE `objectives` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `type` enum('company','department','team','individual') NOT NULL DEFAULT 'department',
  `status` enum('draft','active','at_risk','completed','cancelled') NOT NULL DEFAULT 'draft',
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `progress_percent` decimal(5,2) NOT NULL DEFAULT 0.00,
  `parent_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `partnerships`
--

CREATE TABLE `partnerships` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `partner_type` enum('strategic','technology','channel','referral','joint_venture','other') NOT NULL DEFAULT 'strategic',
  `vendor_id` bigint(20) UNSIGNED DEFAULT NULL,
  `client_id` bigint(20) UNSIGNED DEFAULT NULL,
  `description` text DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('active','inactive','negotiating','terminated') NOT NULL DEFAULT 'negotiating',
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `value_proposition` text DEFAULT NULL,
  `kpis` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`kpis`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'qms-token', '85135242494d204207b084804471653cb798b30d5b2dbb23caca27aac01d8a5c', '[\"*\"]', '2026-03-05 09:59:03', NULL, '2026-03-05 09:48:09', '2026-03-05 09:59:03'),
(8, 'App\\Models\\User', 1, 'qms-token', '2e74fc73493801371d4fe93ac18a68b11ce93674b3c9d263d119b44d692ffbf4', '[\"*\"]', '2026-03-05 10:15:26', NULL, '2026-03-05 10:10:42', '2026-03-05 10:15:26'),
(9, 'App\\Models\\User', 1, 'qms-token', 'b46791ab4a665569f73f543790c72efabb6daeff74da74ca15dac9e7a3347014', '[\"*\"]', '2026-03-05 10:24:28', NULL, '2026-03-05 10:21:56', '2026-03-05 10:24:28'),
(10, 'App\\Models\\User', 1, 'qms-token', '4de5872c2501a7a5fcc98cf341773e483fd83436c74d00ba5d18443484f96f91', '[\"*\"]', '2026-03-05 10:41:52', NULL, '2026-03-05 10:27:19', '2026-03-05 10:41:52'),
(12, 'App\\Models\\User', 1, 'qms-token', 'c7b430085e80ecd95d56bfd7cb2b32fcd9b0fe5bbd97b8351e99d16b8160d2d0', '[\"*\"]', '2026-03-05 10:56:32', NULL, '2026-03-05 10:49:09', '2026-03-05 10:56:32'),
(13, 'App\\Models\\User', 1, 'qms-token', '1565d830ef992374127a364fe6006c57a27b18a33f9ca97c001c77e087d46342', '[\"*\"]', '2026-03-05 11:17:06', NULL, '2026-03-05 11:06:22', '2026-03-05 11:17:06'),
(17, 'App\\Models\\User', 16, 'qms-token', '866cb49ca5e17ec590392585da51cfd3f04a619c6daf03f03d3d0b57c01ab437', '[\"*\"]', '2026-03-05 11:25:24', NULL, '2026-03-05 11:23:10', '2026-03-05 11:25:24'),
(19, 'App\\Models\\User', 16, 'qms-token', 'f7576ac4ad6303b4f0917c9ceca365b3f17ecc81a51d986896bd2439e15bbeac', '[\"*\"]', '2026-03-05 11:36:20', NULL, '2026-03-05 11:31:32', '2026-03-05 11:36:20'),
(20, 'App\\Models\\User', 16, 'qms-token', 'c019c01496aa6c9ee3a8a235793e06b328edefd27f3b02b9a23e751dbd6af43d', '[\"*\"]', '2026-03-05 11:40:12', NULL, '2026-03-05 11:39:19', '2026-03-05 11:40:12'),
(22, 'App\\Models\\User', 16, 'qms-token', '136c7c7d3c792592d0841dca43834e3d8bf3f1e04fd11ee7ca51894dd66e4ae6', '[\"*\"]', '2026-03-05 12:03:08', NULL, '2026-03-05 12:00:12', '2026-03-05 12:03:08'),
(23, 'App\\Models\\User', 1, 'qms-token', 'aaf34f54edc11b3c92b65d8e1f583eea251b11090243f81eda6a7a29ebb4ea89', '[\"*\"]', '2026-03-05 12:12:22', NULL, '2026-03-05 12:07:51', '2026-03-05 12:12:22'),
(24, 'App\\Models\\User', 1, 'qms-token', 'e43fd823926c12e5faacb5357fbbf5c029d701324ef650d44c7ebfb5392f0d94', '[\"*\"]', '2026-03-05 12:44:05', NULL, '2026-03-05 12:27:33', '2026-03-05 12:44:05'),
(25, 'App\\Models\\User', 1, 'qms-token', '583f1940c99ea86d2fbcc4191333517bc180342596d7fd558791a28b69ebe506', '[\"*\"]', '2026-03-05 13:03:54', NULL, '2026-03-05 12:50:16', '2026-03-05 13:03:54'),
(26, 'App\\Models\\User', 1, 'qms-token', 'c88524b26e13c1b3fa9500862690d6d84503609fb922c2894ab365421c260859', '[\"*\"]', NULL, NULL, '2026-03-08 10:03:59', '2026-03-08 10:03:59'),
(27, 'App\\Models\\User', 1, 'qms-token', '70d7e35c51988be8e852600bdfca456efac0586ea5d9e0ba3bcf9ef773ed7e2f', '[\"*\"]', '2026-03-08 10:14:10', NULL, '2026-03-08 10:04:39', '2026-03-08 10:14:10'),
(28, 'App\\Models\\User', 1, 'qms-token', '29de5b8267ad3859b5a019a3a08f11db1e312786d4662604092817c2e1cd75bf', '[\"*\"]', '2026-03-08 11:20:29', NULL, '2026-03-08 11:19:54', '2026-03-08 11:20:29'),
(29, 'App\\Models\\User', 2, 'qms-token', 'fa9df11f4b5b53fbf02588899d34309326b0f02d0c658da07b0c318475035923', '[\"*\"]', '2026-04-14 07:39:04', NULL, '2026-04-14 07:38:50', '2026-04-14 07:39:04'),
(30, 'App\\Models\\User', 1, 'qms-token', '8d869a26b1ec66d06d8657f2ce632df06b841aef08456550011f00bd930f2519', '[\"*\"]', '2026-04-14 07:45:55', NULL, '2026-04-14 07:39:06', '2026-04-14 07:45:55'),
(31, 'App\\Models\\User', 1, 'qms-token', 'ccb63ec27c7cfd431d4e659480fc84cee001a3531bb69c6b11d8df6c798e5343', '[\"*\"]', '2026-04-14 07:50:34', NULL, '2026-04-14 07:48:20', '2026-04-14 07:50:34'),
(32, 'App\\Models\\User', 2, 'qms-token', 'ff6ad1fce0bcb332ceb26e927827a825700eab617b56e474c4f2710a02807d57', '[\"*\"]', '2026-04-14 07:55:25', NULL, '2026-04-14 07:55:13', '2026-04-14 07:55:25'),
(33, 'App\\Models\\User', 1, 'qms-token', 'dba13a2b18bed0bbccb5f007d61042df202067ce5d470ca3b1f06d30dabf88d5', '[\"*\"]', '2026-04-14 08:23:02', NULL, '2026-04-14 07:55:26', '2026-04-14 08:23:02'),
(34, 'App\\Models\\User', 1, 'qms-token', '4cee49168d7af3807628a58c2588cef3e9212787f05d3c6b3e1b640d8cd6c361', '[\"*\"]', '2026-04-14 08:18:00', NULL, '2026-04-14 08:12:23', '2026-04-14 08:18:00'),
(35, 'App\\Models\\User', 1, 'qms-token', 'a388af2b7c5589b53655b5804ac16719dadb135ddfbe1cfddfe746dd8b1f3af2', '[\"*\"]', '2026-04-14 08:26:22', NULL, '2026-04-14 08:24:50', '2026-04-14 08:26:22'),
(36, 'App\\Models\\User', 1, 'qms-token', 'c1c7e6e3a46aa79410267e3cf70a949772f4ef6f15bf51900c849afcfbd3469e', '[\"*\"]', '2026-04-14 08:40:25', NULL, '2026-04-14 08:37:43', '2026-04-14 08:40:25'),
(38, 'App\\Models\\User', 1, 'qms-token', 'ff605ea06f2eb3b75f809dedb9133e30d5f74e3a3d6b96c9ad3611815512b652', '[\"*\"]', '2026-04-14 08:47:57', NULL, '2026-04-14 08:47:52', '2026-04-14 08:47:57'),
(39, 'App\\Models\\User', 1, 'qms-token', '7aeefb76eac424752e36ec6cf98f52ae0529e63ba45b8c39c4e4d49dd8119bae', '[\"*\"]', '2026-04-14 08:49:49', NULL, '2026-04-14 08:48:57', '2026-04-14 08:49:49'),
(40, 'App\\Models\\User', 1, 'qms-token', 'd19e708c596b2d8a8e8021bbbfef064ad1169779cd269b06d1391b9266edc849', '[\"*\"]', '2026-04-14 09:04:32', NULL, '2026-04-14 09:02:47', '2026-04-14 09:04:32'),
(41, 'App\\Models\\User', 1, 'qms-token', 'dde03d48f69124de6ca6e798420d780231edd5aa2d7483ec236c9e3a1ab17579', '[\"*\"]', '2026-04-14 09:21:57', NULL, '2026-04-14 09:21:50', '2026-04-14 09:21:57'),
(42, 'App\\Models\\User', 1, 'qms-token', '0099a13c3e26786f2cd91362749cb96868957c9e7a863290cb6d46c67ad77a9b', '[\"*\"]', '2026-04-14 09:29:16', NULL, '2026-04-14 09:29:03', '2026-04-14 09:29:16'),
(43, 'App\\Models\\User', 1, 'qms-token', 'a3242f2dfc04a6c82cbb938c694cf0244f69f2bbf597e8860488fbaaa286b283', '[\"*\"]', '2026-04-14 09:38:45', NULL, '2026-04-14 09:37:11', '2026-04-14 09:38:45'),
(44, 'App\\Models\\User', 1, 'qms-token', 'b8e72561ceb0bcbea89ffe666c64eb9b2f4ee604866a6c406233712ead075e96', '[\"*\"]', '2026-04-14 09:48:57', NULL, '2026-04-14 09:42:00', '2026-04-14 09:48:57'),
(45, 'App\\Models\\User', 1, 'qms-token', '31f0cc311ddebf9d9ed39c8c32bbc67b1f07f1ed6d2afb1cd82f9153f28df05f', '[\"*\"]', '2026-04-14 09:57:15', NULL, '2026-04-14 09:49:36', '2026-04-14 09:57:15'),
(46, 'App\\Models\\User', 1, 'qms-token', '17453abd98f5c4fb4829528d20fb0b6dcabf5131f49845b685e354961ca8c482', '[\"*\"]', '2026-04-14 09:58:41', NULL, '2026-04-14 09:57:54', '2026-04-14 09:58:41'),
(47, 'App\\Models\\User', 1, 'qms-token', '198fbf0eb0a116256629a669c4e64c47a04b956fc6b17c6a02d6a87f83918097', '[\"*\"]', '2026-04-14 10:01:29', NULL, '2026-04-14 10:01:00', '2026-04-14 10:01:29'),
(48, 'App\\Models\\User', 1, 'qms-token', 'f8332ca4b8b9af693b7a4a0de026c7d6e6c058c1931ea71c65422efe148636da', '[\"*\"]', '2026-04-14 11:13:29', NULL, '2026-04-14 10:13:56', '2026-04-14 11:13:29'),
(56, 'App\\Models\\User', 1, 'qms-token', 'a2b42d03445538497603ae65e76a843851a2425ddf99cb74c2610e64c8411a36', '[\"*\"]', '2026-04-15 11:57:29', NULL, '2026-04-15 08:37:18', '2026-04-15 11:57:29'),
(57, 'App\\Models\\User', 1, 'qms-token', 'dbeaf07ed0f6fe5e957a4e85deba17fb8575d4c6d8880d4c60160dba58bcfcdc', '[\"*\"]', '2026-04-15 13:10:16', NULL, '2026-04-15 13:10:08', '2026-04-15 13:10:16'),
(58, 'App\\Models\\User', 1, 'qms-token', 'f2c66b6dd7244f4c65ca2de3b4d6118558ef22e253f5ef275275d387368c7b90', '[\"*\"]', '2026-04-15 13:15:55', NULL, '2026-04-15 13:15:45', '2026-04-15 13:15:55'),
(59, 'App\\Models\\User', 1, 'qms-token', '8b9a24b47c571118c11d8795399fdef8e5362b3b74f87b3d4db6555d83ad534b', '[\"*\"]', '2026-04-15 13:17:25', NULL, '2026-04-15 13:17:16', '2026-04-15 13:17:25'),
(60, 'App\\Models\\User', 1, 'qms-token', '554e753a9bb643de29183bcafe72b7f701068d1a0a31e60ffe183b247d53db36', '[\"*\"]', '2026-04-15 13:24:10', NULL, '2026-04-15 13:20:33', '2026-04-15 13:24:10'),
(61, 'App\\Models\\User', 1, 'qms-token', '47d7c8f59979259536fe66a6773dcd7809fb06ca3e5f14a2cfb2db12b7ef54fe', '[\"*\"]', '2026-04-15 13:21:09', NULL, '2026-04-15 13:20:52', '2026-04-15 13:21:09'),
(62, 'App\\Models\\User', 1, 'qms-token', '815e0ae4fbacf95095c905b4854652cccb0ec7ce9f4b57133946598fb89f73a8', '[\"*\"]', NULL, NULL, '2026-04-15 13:25:18', '2026-04-15 13:25:18'),
(63, 'App\\Models\\User', 1, 'qms-token', '7a2acdbec7cf140c8da9939e0dc50f00b51d69e7c0db4c306f54fe3d207e0167', '[\"*\"]', NULL, NULL, '2026-04-15 13:25:27', '2026-04-15 13:25:27'),
(64, 'App\\Models\\User', 1, 'qms-token', 'c5edd54e52ed66fe0acad9bc9155b6d7cd7f064b5e5b0faabbe5a90618948f02', '[\"*\"]', '2026-04-15 13:26:12', NULL, '2026-04-15 13:25:51', '2026-04-15 13:26:12'),
(65, 'App\\Models\\User', 1, 'qms-token', '8b12d71d8b18765f347ac8b56be035b05502aabd9b974808cf6a82ef8cd31266', '[\"*\"]', '2026-04-15 13:31:05', NULL, '2026-04-15 13:30:07', '2026-04-15 13:31:05'),
(66, 'App\\Models\\User', 1, 'qms-token', '86e2c1bbb7e3135fb7fe5a29eef33c8b33acfcac30d533d603c2a9d1292bb0ee', '[\"*\"]', '2026-04-15 13:35:09', NULL, '2026-04-15 13:34:38', '2026-04-15 13:35:09'),
(67, 'App\\Models\\User', 1, 'qms-token', '1bcc54937a0cc61f52d8c2cc2e61046c5522e77a7f3c5e8edfd1e94c68a7d866', '[\"*\"]', '2026-04-15 13:35:49', NULL, '2026-04-15 13:35:20', '2026-04-15 13:35:49'),
(68, 'App\\Models\\User', 1, 'qms-token', 'e8519537bd671109efda2bf8f5eb0bed393686745afdac28f2b326890ffeb76d', '[\"*\"]', '2026-04-15 13:40:00', NULL, '2026-04-15 13:39:35', '2026-04-15 13:40:00'),
(69, 'App\\Models\\User', 1, 'qms-token', 'c67bfbe57cbc34736dffbccd847e5859ddb7bb7b0bac70a0327e79aecd8ae406', '[\"*\"]', '2026-04-15 13:45:20', NULL, '2026-04-15 13:44:48', '2026-04-15 13:45:20'),
(70, 'App\\Models\\User', 1, 'qms-token', '12bcd00e58296404aff606e255099e847a10f99b350a612adf3963f2991d08b3', '[\"*\"]', '2026-04-16 07:52:33', NULL, '2026-04-16 05:53:16', '2026-04-16 07:52:33'),
(71, 'App\\Models\\User', 1, 'qms-token', 'dfefe0322e0581675dd3cccd5f6f5d8b00f52d3ea57d351f94cb5493e32702bd', '[\"*\"]', '2026-04-16 08:14:59', NULL, '2026-04-16 08:14:41', '2026-04-16 08:14:59'),
(72, 'App\\Models\\User', 1, 'qms-token', 'c080f129c835bfdae25538e10388f7e1ff00c623790b3b6a7f17308c6eda66e8', '[\"*\"]', '2026-04-16 10:22:44', NULL, '2026-04-16 10:21:09', '2026-04-16 10:22:44'),
(73, 'App\\Models\\User', 1, 'qms-token', 'f40149380a35ad979e52a7301f55ad7600cf0b0bbc9081d07c3a1a1a771142d5', '[\"*\"]', NULL, NULL, '2026-04-16 10:51:07', '2026-04-16 10:51:07'),
(74, 'App\\Models\\User', 2, 'qms-token', 'c999d4f073d9c0581690cc7b46de4381e856ba7fb76e84c88410f831037b3107', '[\"*\"]', NULL, NULL, '2026-04-16 10:51:21', '2026-04-16 10:51:21'),
(75, 'App\\Models\\User', 1, 'qms-token', 'c1dd7c27cb23e542c03e79d4bc76bf74c0b8652c236916547018f99a360e4954', '[\"*\"]', NULL, NULL, '2026-04-16 10:51:25', '2026-04-16 10:51:25'),
(76, 'App\\Models\\User', 1, 'qms-token', 'c3759e644eff2f1f00a2a69dd22b91433d39a820e3e376f670e8e03da3ee4908', '[\"*\"]', NULL, NULL, '2026-04-16 10:51:55', '2026-04-16 10:51:55'),
(77, 'App\\Models\\User', 1, 'qms-token', '3f64c7972e160f1cdae7d6b3e6605fecb481e34e467217206b380f89cf4348bc', '[\"*\"]', NULL, NULL, '2026-04-16 10:57:21', '2026-04-16 10:57:21'),
(78, 'App\\Models\\User', 1, 'qms-token', '62065e85ab1f1ea2c24d5dda7fc0e90908f40b63e5014ab68efe64c3d5bb9027', '[\"*\"]', NULL, NULL, '2026-04-16 10:58:50', '2026-04-16 10:58:50'),
(79, 'App\\Models\\User', 1, 'qms-token', 'd74ded4031dadccbffd80d78222bde216056bda257907258631dfb40abe19e36', '[\"*\"]', NULL, NULL, '2026-04-16 10:59:33', '2026-04-16 10:59:33'),
(80, 'App\\Models\\User', 1, 'qms-token', '0e88e0bc92229695a49a59e1dade0141435fe37115b342b3f65b68dc2f96ed6b', '[\"*\"]', NULL, NULL, '2026-04-16 11:25:53', '2026-04-16 11:25:53'),
(81, 'App\\Models\\User', 1, 'qms-token', '8bef9a7051f2017c6519319b95fe58dffe230ed4aa0f05c46d05095019fa2d6d', '[\"*\"]', NULL, NULL, '2026-04-16 11:25:55', '2026-04-16 11:25:55'),
(82, 'App\\Models\\User', 2, 'qms-token', '2396a1db205ac73a642cd6b3aefa15014a1e3a7bad24b485067cccfc66e5928b', '[\"*\"]', NULL, NULL, '2026-04-16 11:26:08', '2026-04-16 11:26:08'),
(83, 'App\\Models\\User', 1, 'qms-token', 'bcc5f5496ad5187a87ad244fc206e27a3011bbbf527f69ef68337c9d5e76c161', '[\"*\"]', NULL, NULL, '2026-04-16 11:26:14', '2026-04-16 11:26:14'),
(84, 'App\\Models\\User', 1, 'qms-token', 'fac5e09ca6c48c10170d2bdeee59d74000eaa3e55367d87085ddbb6ae588b5b1', '[\"*\"]', '2026-04-16 11:33:22', NULL, '2026-04-16 11:33:11', '2026-04-16 11:33:22'),
(85, 'App\\Models\\User', 1, 'qms-token', '0b7160458a5b25f11e18dc3d6bd6a74973e665e1957d9db7c569a6c17b13a166', '[\"*\"]', '2026-04-16 11:42:32', NULL, '2026-04-16 11:42:24', '2026-04-16 11:42:32'),
(86, 'App\\Models\\User', 1, 'qms-token', 'c2aea007d37c3e10c3544ff9760bd3501fc9e7322aeb34ba3daa8250ac39cea7', '[\"*\"]', '2026-04-16 11:45:48', NULL, '2026-04-16 11:45:17', '2026-04-16 11:45:48'),
(87, 'App\\Models\\User', 1, 'qms-token', '0195b41a53ddf4c6f8d9ddea7e53774122cb3a97128d9dd0826ce4968bdfa71d', '[\"*\"]', '2026-04-16 11:53:27', NULL, '2026-04-16 11:52:53', '2026-04-16 11:53:27'),
(89, 'App\\Models\\User', 2, 'qms-token', '7015f018fe03e30e2863debb27628428076c01cdf67be9ca1d9b76f4b280593f', '[\"*\"]', '2026-04-16 11:58:40', NULL, '2026-04-16 11:58:34', '2026-04-16 11:58:40'),
(90, 'App\\Models\\User', 1, 'qms-token', '13f5c0c2c91d2fea50cabf28c14288832449185cae8a66aecbc3fb63669fb7a7', '[\"*\"]', '2026-04-16 12:08:48', NULL, '2026-04-16 12:08:46', '2026-04-16 12:08:48'),
(91, 'App\\Models\\User', 1, 'qms-token', 'a76c99963cf03d57b4cf5db7edf91a5c9892682408e87f14d4f7d2981e9afc6d', '[\"*\"]', '2026-04-16 12:12:22', NULL, '2026-04-16 12:12:20', '2026-04-16 12:12:22'),
(92, 'App\\Models\\User', 1, 'qms-token', '52e8a95b637f7a087bc8239a713a6f71809e3c2ba150d95e71dea40fb2538f7e', '[\"*\"]', '2026-04-16 12:23:54', NULL, '2026-04-16 12:23:42', '2026-04-16 12:23:54'),
(93, 'App\\Models\\User', 1, 'qms-token', '10dc9cec8bd8dddd2cede3e2cf7f21a147b945cc8dad9dd78e59172e47a52bff', '[\"*\"]', '2026-04-16 12:35:04', NULL, '2026-04-16 12:34:07', '2026-04-16 12:35:04'),
(94, 'App\\Models\\User', 1, 'qms-token', 'fc6619bbc3a399bce18f4705cd1ab0791bf8d4719b1ea61513cd355b3e1d464c', '[\"*\"]', '2026-04-16 12:44:33', NULL, '2026-04-16 12:44:32', '2026-04-16 12:44:33'),
(95, 'App\\Models\\User', 1, 'qms-token', '8e6b24946db6e8dc2e1b1517a45b19b1b6ec6e1c466cbe17c4174f40773c370c', '[\"*\"]', '2026-04-16 12:50:25', NULL, '2026-04-16 12:50:02', '2026-04-16 12:50:25'),
(96, 'App\\Models\\User', 1, 'qms-token', '16595cf4cfbdb19a472fe4b7e0aba389b55258d15bd41e94b84e04fa6d6eebe2', '[\"*\"]', '2026-04-16 12:54:02', NULL, '2026-04-16 12:54:01', '2026-04-16 12:54:02'),
(97, 'App\\Models\\User', 1, 'qms-token', '4316467fd072e56ebc28648da3e5c987012ed6c174f5f45841b8787ed40d925c', '[\"*\"]', '2026-04-16 13:02:56', NULL, '2026-04-16 13:02:55', '2026-04-16 13:02:56'),
(98, 'App\\Models\\User', 1, 'qms-token', '1dcd9a787c7107bcc812ca6a9cb19693832cd882dc3ea7149b8103f64b3167ad', '[\"*\"]', '2026-04-16 13:08:06', NULL, '2026-04-16 13:08:05', '2026-04-16 13:08:06'),
(99, 'App\\Models\\User', 1, 'qms-token', 'b7016534a973bde49a69678a074da15d1d5748dfaf17974bfd37430633e47384', '[\"*\"]', '2026-04-16 13:08:21', NULL, '2026-04-16 13:08:20', '2026-04-16 13:08:21'),
(100, 'App\\Models\\User', 1, 'qms-token', '6a3ad49371fc17bda36f2ed3cfef66896de51b9d530323af97027d241b8306d7', '[\"*\"]', '2026-04-16 13:13:20', NULL, '2026-04-16 13:11:17', '2026-04-16 13:13:20'),
(103, 'App\\Models\\User', 1, 'qms-token', '51fc21a0f0229fe8ca650de629fe14ee376cfde7fdc416290fec3e8d16015e56', '[\"*\"]', '2026-04-16 13:25:38', NULL, '2026-04-16 13:22:50', '2026-04-16 13:25:38'),
(104, 'App\\Models\\User', 1, 'qms-token', 'dedb8566cf1a2432d616fec261cdb9fb0c3c2dd39ebda5ce957e1426f10645f0', '[\"*\"]', '2026-04-16 13:26:05', NULL, '2026-04-16 13:25:45', '2026-04-16 13:26:05'),
(105, 'App\\Models\\User', 1, 'qms-token', '31bbd838cc4674984a4cffe8547c9f9cdc01c804a47fd9b72307a7e1a4f8720f', '[\"*\"]', '2026-04-16 13:38:52', NULL, '2026-04-16 13:38:40', '2026-04-16 13:38:52'),
(107, 'App\\Models\\User', 17, 'qms-token', 'b301b4b2fd14489338dd54e16108b4758b1f550175a5f821fafd90b7700ba642', '[\"*\"]', '2026-04-19 11:47:54', NULL, '2026-04-19 11:47:53', '2026-04-19 11:47:54'),
(109, 'App\\Models\\User', 17, 'qms-token', 'e36748915d8cdae5866ed05dbd42c78a53104ed70b365aa79c0b1df5e4bc8cc9', '[\"*\"]', '2026-04-19 11:48:28', NULL, '2026-04-19 11:48:27', '2026-04-19 11:48:28'),
(110, 'App\\Models\\User', 17, 'qms-token', '91ec8cb8f8962e47aba9cf78eed703043700596eb9d4ffa46e78800ef4d4fd59', '[\"*\"]', '2026-04-19 11:48:51', NULL, '2026-04-19 11:48:49', '2026-04-19 11:48:51'),
(112, 'App\\Models\\User', 8, 'qms-token', '342681aff0d76b774d5f63f84ddf97e73dc2520ddfadd670901e5a568cf87d29', '[\"*\"]', '2026-04-19 11:50:31', NULL, '2026-04-19 11:50:30', '2026-04-19 11:50:31'),
(113, 'App\\Models\\User', 1, 'qms-token', '02f53ac10ab496c76b53b268dbf6de5478589d9c2e18b44a8b169b093a8757f5', '[\"*\"]', '2026-04-19 12:31:46', NULL, '2026-04-19 11:50:52', '2026-04-19 12:31:46'),
(114, 'App\\Models\\User', 4, 'qms-token', '7cbf799736f33fe6cc894f386d9684d82711479c540f89c3ad7b9a5bd8f9b867', '[\"*\"]', '2026-04-19 12:34:23', NULL, '2026-04-19 12:34:22', '2026-04-19 12:34:23'),
(115, 'App\\Models\\User', 4, 'qms-token', 'ff302136cbe4479f940f9fa4112947803c882bb07e1d7dc461789151353b90ce', '[\"*\"]', '2026-04-19 12:34:28', NULL, '2026-04-19 12:34:27', '2026-04-19 12:34:28'),
(116, 'App\\Models\\User', 4, 'qms-token', '5590249d4588c5ffd6346e9bcef04bbb6568cbad54e92fe086d61e3b0a7613b1', '[\"*\"]', '2026-04-19 12:56:16', NULL, '2026-04-19 12:34:52', '2026-04-19 12:56:16'),
(118, 'App\\Models\\User', 1, 'qms-token', '717ff06c47f4c37133486b33b08e6566d23dd98b1393bf5ce9349ac9cc44ba3e', '[\"*\"]', NULL, NULL, '2026-04-20 07:35:36', '2026-04-20 07:35:36'),
(119, 'App\\Models\\User', 1, 'qms-token', '9d2c5cb540c64a8fd7cb60581933ca6fa2f0a967297a54eaa2a6455b5023bbde', '[\"*\"]', '2026-04-20 07:41:57', NULL, '2026-04-20 07:37:24', '2026-04-20 07:41:57'),
(121, 'App\\Models\\User', 17, 'qms-token', 'effee16eb933163a0bc0fc58aed5b2024a6f622a82f991684fb6ebfcee9c02fe', '[\"*\"]', '2026-04-27 09:08:35', NULL, '2026-04-27 09:08:18', '2026-04-27 09:08:35'),
(122, 'App\\Models\\User', 8, 'qms-token', '790e61b187eb088946fca4651d89601cb70c2d34e89689d5890aca614313436a', '[\"*\"]', '2026-04-27 09:34:20', NULL, '2026-04-27 09:34:19', '2026-04-27 09:34:20'),
(133, 'App\\Models\\User', 10, 'qms-token', '4defa0c007c79de9051157e80ca0c068c7d609ef89d5d56a40b66aa9f930c345', '[\"*\"]', '2026-04-27 09:46:43', NULL, '2026-04-27 09:46:38', '2026-04-27 09:46:43'),
(135, 'App\\Models\\User', 17, 'qms-token', '2a3e5e1a00b9c83505ae58cee6c01da70c1454791dd18b2aedbaa629c696ad33', '[\"*\"]', '2026-04-27 10:13:08', NULL, '2026-04-27 10:13:07', '2026-04-27 10:13:08'),
(136, 'App\\Models\\User', 17, 'qms-token', '0e5ec8286ddfa7fb219174744d6ff00102de8cef1e4f56db42b556d69b77e729', '[\"*\"]', '2026-04-27 10:13:23', NULL, '2026-04-27 10:13:12', '2026-04-27 10:13:23'),
(137, 'App\\Models\\User', 17, 'qms-token', '75ea735173409b9d2257b389cf19ff35fe08cbccbaea3935e9b6e526aea2ccc2', '[\"*\"]', '2026-04-27 10:15:50', NULL, '2026-04-27 10:15:49', '2026-04-27 10:15:50'),
(140, 'App\\Models\\User', 10, 'qms-token', '364baa7b07c2628b0fad2f52e761f86c213f350060beb2d7613a9e7635a4c600', '[\"*\"]', '2026-04-27 10:25:55', NULL, '2026-04-27 10:22:39', '2026-04-27 10:25:55'),
(141, 'App\\Models\\User', 10, 'qms-token', 'ec2cd06ba5b235d558e255ddcc6d0c0b0aca302aae0773f369d489a44191ee86', '[\"*\"]', '2026-04-27 10:26:41', NULL, '2026-04-27 10:26:40', '2026-04-27 10:26:41'),
(143, 'App\\Models\\User', 17, 'qms-token', '4d275d7a563751941fe3f865c7196e67b08485f7f0e532965a53824f6b1c82ec', '[\"*\"]', '2026-04-27 10:27:34', NULL, '2026-04-27 10:27:25', '2026-04-27 10:27:34'),
(144, 'App\\Models\\User', 17, 'qms-token', '75f7828ad10150a5ee7d564abb5dd40bfc72d5baeb4483be3803d799091d62b7', '[\"*\"]', '2026-04-27 10:32:32', NULL, '2026-04-27 10:31:46', '2026-04-27 10:32:32'),
(145, 'App\\Models\\User', 17, 'qms-token', '6dc4ac16d666a425cd72a787692d957181ac6b5dabe294bd09c4cd983b1878da', '[\"*\"]', '2026-04-27 10:33:00', NULL, '2026-04-27 10:32:58', '2026-04-27 10:33:00'),
(147, 'App\\Models\\User', 10, 'qms-token', 'e20d83dfb3192bf934ebeda288ae4488cba22421c16dc1e042a9bec59b2c4ae9', '[\"*\"]', '2026-04-27 10:35:45', NULL, '2026-04-27 10:34:11', '2026-04-27 10:35:45'),
(151, 'App\\Models\\User', 1, 'qms-token', '605bf7280da046000e27fe63367595014748a8d0bcd6aac051240dc8aaf0e9df', '[\"*\"]', '2026-04-27 10:37:45', NULL, '2026-04-27 10:37:43', '2026-04-27 10:37:45'),
(152, 'App\\Models\\User', 1, 'qms-token', '7f35655bec01bc0117b9b0dcd45463aa1da654a34d62ce2b42f8dd24430c5a25', '[\"*\"]', '2026-04-27 10:37:49', NULL, '2026-04-27 10:37:48', '2026-04-27 10:37:49'),
(153, 'App\\Models\\User', 1, 'qms-token', '72d6e1c49b86b2a46620941e8b5b672e477a238d49befdd0b2e6003116ae7c5c', '[\"*\"]', '2026-04-27 10:37:53', NULL, '2026-04-27 10:37:52', '2026-04-27 10:37:53'),
(154, 'App\\Models\\User', 1, 'qms-token', 'dea2c3e8861c7539c5aee6bffd8dd8238b514e7febf7beddd32c3b3e76976220', '[\"*\"]', '2026-04-27 10:41:02', NULL, '2026-04-27 10:38:03', '2026-04-27 10:41:02'),
(155, 'App\\Models\\User', 1, 'qms-token', '4aaa02f9a5ebb7ca5e081b72fa5cc239d6624cc87a6709dfa2a8149d2bba6949', '[\"*\"]', '2026-04-27 11:35:15', NULL, '2026-04-27 11:35:13', '2026-04-27 11:35:15'),
(157, 'App\\Models\\User', 8, 'qms-token', '087c51293c65e66dd13c2ad5b7480ccabfc141b0b89d62c9aa73846325a00071', '[\"*\"]', '2026-04-27 11:36:03', NULL, '2026-04-27 11:35:55', '2026-04-27 11:36:03'),
(158, 'App\\Models\\User', 17, 'qms-token', '9fee5f5c3640ddb9d61b5ffd29a85a695ae04034e95e253400ac12ac2c4f29c4', '[\"*\"]', '2026-04-27 12:37:48', NULL, '2026-04-27 12:37:47', '2026-04-27 12:37:48'),
(159, 'App\\Models\\User', 17, 'qms-token', '5b16bd6b7a2156b19e435721470b98c62a015d1482fd8b86eb8bfe519be9bb21', '[\"*\"]', '2026-04-27 12:38:36', NULL, '2026-04-27 12:37:51', '2026-04-27 12:38:36'),
(160, 'App\\Models\\User', 17, 'qms-token', '34e200434b900c5eb404aff9ba877bca0ab857745920587fe5a5b8c871a362ab', '[\"*\"]', '2026-04-27 12:50:25', NULL, '2026-04-27 12:50:23', '2026-04-27 12:50:25'),
(161, 'App\\Models\\User', 17, 'qms-token', '377c348e0d537de802d5b9d95bafd972d662969c8a902f3628955e169b7289dc', '[\"*\"]', '2026-04-27 12:51:48', NULL, '2026-04-27 12:50:27', '2026-04-27 12:51:48'),
(162, 'App\\Models\\User', 2, 'qms-token', '150a1a3285eb98326d139a38b1fd2f1982da4b8f09c838f0103c953d54560e2f', '[\"*\"]', '2026-04-28 06:58:29', NULL, '2026-04-28 06:58:28', '2026-04-28 06:58:29'),
(163, 'App\\Models\\User', 2, 'qms-token', '0eb841ee3476b4af8ccca620ea591d5665db1c717d6845e33088b4c7adb19dd2', '[\"*\"]', '2026-04-28 06:59:01', NULL, '2026-04-28 06:58:31', '2026-04-28 06:59:01'),
(164, 'App\\Models\\User', 1, 'qms-token', '375d30bfc657e999642cb5fd4811f37f1019137d8113ffa5ba3a2cca26cbbdb6', '[\"*\"]', '2026-04-28 09:22:47', NULL, '2026-04-28 09:22:45', '2026-04-28 09:22:47'),
(165, 'App\\Models\\User', 1, 'qms-token', 'ae80d4b703a5f4680843947fe0a86d2143614a3829154d15bc8d3351af16a75d', '[\"*\"]', '2026-04-28 09:24:09', NULL, '2026-04-28 09:22:49', '2026-04-28 09:24:09'),
(166, 'App\\Models\\User', 1, 'qms-token', 'b2c8bab082eebd0b0f3b9b8ce79a85719a5224f9bcad40707e00550eec951eec', '[\"*\"]', '2026-04-28 09:32:38', NULL, '2026-04-28 09:31:30', '2026-04-28 09:32:38'),
(167, 'App\\Models\\User', 1, 'qms-token', 'ab3f3c0810014bbc061ca4c47fd6d3c6870c07c648a73a9d8ac549763886da57', '[\"*\"]', '2026-04-28 09:33:31', NULL, '2026-04-28 09:33:13', '2026-04-28 09:33:31'),
(168, 'App\\Models\\User', 1, 'qms-token', '1d2899f34f2277fab093180fe48a91bebd11bc3b20f7a0761c6c894e04cf7255', '[\"*\"]', '2026-04-28 09:35:06', NULL, '2026-04-28 09:35:02', '2026-04-28 09:35:06'),
(169, 'App\\Models\\User', 1, 'qms-token', 'fcff25d5b00dc2290fc0975505b4c461c597f41dcbcfeff10307c6957ddae0b0', '[\"*\"]', '2026-04-28 09:38:06', NULL, '2026-04-28 09:36:55', '2026-04-28 09:38:06'),
(170, 'App\\Models\\User', 1, 'qms-token', '2de390874c576c1ab9620f60b2511927d1f18dfec399930a16efa5490024fb1e', '[\"*\"]', '2026-04-28 09:38:33', NULL, '2026-04-28 09:38:32', '2026-04-28 09:38:33'),
(171, 'App\\Models\\User', 1, 'qms-token', 'ddc0f3fb62fb99b1d5afe9a7e7724ba724bab2a6b77480163a5dfb5d433e5902', '[\"*\"]', '2026-04-28 09:39:03', NULL, '2026-04-28 09:38:37', '2026-04-28 09:39:03'),
(172, 'App\\Models\\User', 1, 'qms-token', '3da9576d47b62a81cbcda9ec9bb1e222e568d72243805620baf85e72d5c8259d', '[\"*\"]', '2026-04-28 09:39:55', NULL, '2026-04-28 09:39:26', '2026-04-28 09:39:55'),
(173, 'App\\Models\\User', 1, 'qms-token', '7cb18c3a6d61d5e210f29e685ec21a8a245f1355424a1a5ab8153c5d2fef1a74', '[\"*\"]', '2026-04-28 09:46:47', NULL, '2026-04-28 09:46:45', '2026-04-28 09:46:47'),
(174, 'App\\Models\\User', 1, 'qms-token', 'e69b8859c515c692d3ba94493306ba9c230fe89bfff714ed6599aea272eb7454', '[\"*\"]', '2026-04-28 09:47:13', NULL, '2026-04-28 09:46:50', '2026-04-28 09:47:13'),
(175, 'App\\Models\\User', 1, 'qms-token', '525b4350cb707de0a1d61af201ee3402af1a4dde9bfbfa92053a8104dce2203f', '[\"*\"]', '2026-04-28 10:26:55', NULL, '2026-04-28 09:56:02', '2026-04-28 10:26:55'),
(177, 'App\\Models\\User', 1, 'qms-token', 'c96c34201dac5d5f33802d1c41d5f06d07e7bc2fea0e3f0e6c180f5efcc79f34', '[\"*\"]', '2026-04-28 10:45:53', NULL, '2026-04-28 10:45:52', '2026-04-28 10:45:53'),
(178, 'App\\Models\\User', 1, 'qms-token', '309643510fc807fdca35896cf196cc15843bf8e9e237bff695059c47d1fcf304', '[\"*\"]', '2026-04-28 10:56:42', NULL, '2026-04-28 10:56:28', '2026-04-28 10:56:42'),
(179, 'App\\Models\\User', 1, 'qms-token', '5fa48d50f42e0e039e253f1b811e50ebba42e5fb4536a8e98233e9b503e878d5', '[\"*\"]', '2026-04-28 10:56:57', NULL, '2026-04-28 10:56:56', '2026-04-28 10:56:57'),
(185, 'App\\Models\\User', 1, 'qms-token', '48e596258a9e7fff4c96b5272c6e6e25759ce0c8ea0135110c52d6032f5566a6', '[\"*\"]', '2026-04-28 11:12:04', NULL, '2026-04-28 11:12:02', '2026-04-28 11:12:04'),
(186, 'App\\Models\\User', 1, 'qms-token', 'bfa90345400d82bfcafd9ad7d2b5678304df7155c028ccecd17ae374c33099c6', '[\"*\"]', '2026-04-28 11:12:10', NULL, '2026-04-28 11:12:09', '2026-04-28 11:12:10'),
(187, 'App\\Models\\User', 1, 'qms-token', 'f452f22e78b26304983d6a77e235c664213ec52efc8c041a0374c0cd3d8d827e', '[\"*\"]', '2026-04-28 11:15:20', NULL, '2026-04-28 11:14:36', '2026-04-28 11:15:20'),
(188, 'App\\Models\\User', 2, 'qms-token', '3c28753cbfd4aa8307495be7ecf61401b26e6180c102a6b57babebe98747868c', '[\"*\"]', '2026-04-28 12:21:07', NULL, '2026-04-28 11:56:00', '2026-04-28 12:21:07'),
(189, 'App\\Models\\User', 1, 'qms-token', 'f8f0107d6dd80d8fc52bab3a7078a3212c31e958360b628a5e68a62de459143e', '[\"*\"]', '2026-04-28 12:23:10', NULL, '2026-04-28 12:21:14', '2026-04-28 12:23:10'),
(190, 'App\\Models\\User', 1, 'qms-token', '42898ecee26b5c5b2aa8f3b630a277d87c744c7e08a473b9e28a54667c9de512', '[\"*\"]', '2026-04-28 12:27:50', NULL, '2026-04-28 12:27:35', '2026-04-28 12:27:50'),
(192, 'App\\Models\\User', 8, 'qms-token', '7c89db4eadc3525d131777418fdc875b4d7692f55e3e3e6ddf4b7a67eef37e56', '[\"*\"]', '2026-04-29 08:55:26', NULL, '2026-04-29 08:45:32', '2026-04-29 08:55:26'),
(193, 'App\\Models\\User', 2, 'qms-token', '30e20702ca1a5aaf726ba57826ad55cb334bb7942e52efc358724a93c3fc9d58', '[\"*\"]', '2026-04-29 09:24:08', NULL, '2026-04-29 09:00:57', '2026-04-29 09:24:08'),
(194, 'App\\Models\\User', 10, 'qms-token', 'd414a04c6c62045120b14f2f7fbf8dfd6acb9c9ecdcedaf493df79447b6d49d0', '[\"*\"]', '2026-04-29 09:45:44', NULL, '2026-04-29 09:45:17', '2026-04-29 09:45:44'),
(196, 'App\\Models\\User', 17, 'qms-token', '74cc0aa578b5918214a846f877fc5be6fcf63441467d013d76d89cfe7992d118', '[\"*\"]', '2026-04-29 09:58:58', NULL, '2026-04-29 09:49:34', '2026-04-29 09:58:58'),
(200, 'App\\Models\\User', 10, 'qms-token', '2703fc7065fb56e05296a97bd8407b9e0984d3164ed1528f43fc5b8ca23bb723', '[\"*\"]', '2026-04-29 10:42:48', NULL, '2026-04-29 10:42:47', '2026-04-29 10:42:48'),
(202, 'App\\Models\\User', 1, 'qms-token', '6008a0ca9f174b9d1f4e58a0efd97b2751b1441c185fb62b5d071b09e5477e90', '[\"*\"]', '2026-04-29 11:06:14', NULL, '2026-04-29 11:04:07', '2026-04-29 11:06:14'),
(207, 'App\\Models\\User', 39, 'qms-token', '19df63ec8ddee3382b30b978208a29c60d828e64686f9e7257b750dd9bc6415d', '[\"*\"]', '2026-04-29 11:43:08', NULL, '2026-04-29 11:43:07', '2026-04-29 11:43:08'),
(210, 'App\\Models\\User', 39, 'qms-token', '6af3d914c6c4ad6ec8075ca9c3d065ca3abeafc3430b664310326a84c210c3c1', '[\"*\"]', '2026-04-29 11:59:38', NULL, '2026-04-29 11:59:36', '2026-04-29 11:59:38'),
(212, 'App\\Models\\User', 1, 'qms-token', 'bd958dd8c7b6a12758e3d63870f7513f19971880f7ddaf8ca037690134a28e81', '[\"*\"]', '2026-04-29 12:03:01', NULL, '2026-04-29 12:03:00', '2026-04-29 12:03:01'),
(214, 'App\\Models\\User', 44, 'qms-token', 'b712032e1907bc16936e84de70de7d308a7f582a550e7d4b81367b257e1ed979', '[\"*\"]', '2026-04-29 12:03:22', NULL, '2026-04-29 12:03:21', '2026-04-29 12:03:22'),
(215, 'App\\Models\\User', 39, 'qms-token', '9338f1c2e66ad6e622cff6bb60862fed78bb6427309a62269dc63f19627c6dfa', '[\"*\"]', '2026-04-29 12:12:22', NULL, '2026-04-29 12:12:20', '2026-04-29 12:12:22'),
(216, 'App\\Models\\User', 39, 'qms-token', '7b398320a0fd6148fd528a06e539a8960a57b1003160d4149b8985165d210745', '[\"*\"]', '2026-04-29 12:14:08', NULL, '2026-04-29 12:14:06', '2026-04-29 12:14:08'),
(217, 'App\\Models\\User', 39, 'qms-token', 'f52f8aa5cc261930289e1a29c9c513b4e7305a0edb39cc91b7a9baf4364c26c3', '[\"*\"]', '2026-04-29 12:47:15', NULL, '2026-04-29 12:47:13', '2026-04-29 12:47:15'),
(218, 'App\\Models\\User', 39, 'qms-token', '9e8d570362c77f4152f387709281a281bcc4648df61d8197cedffca84db1b7c8', '[\"*\"]', '2026-04-29 13:05:19', NULL, '2026-04-29 13:05:18', '2026-04-29 13:05:19'),
(226, 'App\\Models\\User', 1, 'qms-token', 'a8e2d556a243ef97f81ce32e0a6baef55d2d281ededaf02ed12b0622b57addde', '[\"*\"]', '2026-04-30 05:54:43', NULL, '2026-04-30 05:54:15', '2026-04-30 05:54:43'),
(227, 'App\\Models\\User', 1, 'qms-token', '28cceb9d162e57ea0a42a18075ad893781929e86d8382ce63b1055b91c0da028', '[\"*\"]', '2026-04-30 05:54:57', NULL, '2026-04-30 05:54:47', '2026-04-30 05:54:57'),
(228, 'App\\Models\\User', 39, 'qms-token', 'c622f38e4ae6c42d3a7dd56fe8ea9d0402e0ff4497f9308f44fcf1ebc7616087', '[\"*\"]', '2026-04-30 07:41:49', NULL, '2026-04-30 07:41:47', '2026-04-30 07:41:49'),
(230, 'App\\Models\\User', 44, 'qms-token', '5b99c9819dd6c759556ee8e4936ae7ec800e2bc481029b17437190d822b197ab', '[\"*\"]', '2026-04-30 07:42:07', NULL, '2026-04-30 07:42:06', '2026-04-30 07:42:07'),
(231, 'App\\Models\\User', 26, 'qms-token', 'c5da54bd4a5ec21431cae871daf15ad18b46bd7b708ea0c2d18131ffaba5abfd', '[\"*\"]', '2026-04-30 13:27:32', NULL, '2026-04-30 13:27:31', '2026-04-30 13:27:32'),
(233, 'App\\Models\\User', 26, 'qms-token', 'cb2718142899d8e446c9d7636afe97bba843bc60c2b087b2b4913563d098ef9c', '[\"*\"]', '2026-05-03 08:09:45', NULL, '2026-05-03 08:08:01', '2026-05-03 08:09:45'),
(239, 'App\\Models\\User', 16, 'qms-token', '7e1af40c8e06ebf2d0df7f0a842db6757974c9e0c81d84b282463fa95225367f', '[\"*\"]', '2026-05-03 08:55:25', NULL, '2026-05-03 08:55:23', '2026-05-03 08:55:25'),
(242, 'App\\Models\\User', 1, 'qms-token', '6c123344a2785f36c23bff140bee5a33e4d4275004734486fb0987755bf57d27', '[\"*\"]', '2026-05-03 10:53:18', NULL, '2026-05-03 10:28:13', '2026-05-03 10:53:18'),
(243, 'App\\Models\\User', 1, 'qms-token', 'e98379139755c34b573c2e67e640237f2df664f516c772782d6596228a081c07', '[\"*\"]', '2026-05-03 10:53:25', NULL, '2026-05-03 10:53:24', '2026-05-03 10:53:25'),
(244, 'App\\Models\\User', 1, 'qms-token', '9d23f12cc28c2d960eca51ef8f00a81eef6f3571e1c919957bb0b0b782419b8f', '[\"*\"]', '2026-05-03 10:54:26', NULL, '2026-05-03 10:54:24', '2026-05-03 10:54:26'),
(245, 'App\\Models\\User', 1, 'qms-token', '526a74b240904ebd852d3886df1fc1b3b2b0cafaad1f8e19598566c3474a4378', '[\"*\"]', '2026-05-03 11:01:16', NULL, '2026-05-03 10:54:43', '2026-05-03 11:01:16'),
(246, 'App\\Models\\User', 1, 'qms-token', '14443f8b3e20aa8dc67129d7458d61a569d368130c9e5169f5760d0dc4fe851c', '[\"*\"]', '2026-05-03 11:35:20', NULL, '2026-05-03 11:18:19', '2026-05-03 11:35:20'),
(247, 'App\\Models\\User', 1, 'qms-token', '77e3d09f8890ad4acb4a388c3d8b62549a784c99f4dd5767509f5a7976493b1c', '[\"*\"]', '2026-05-03 11:36:44', NULL, '2026-05-03 11:36:43', '2026-05-03 11:36:44'),
(249, 'App\\Models\\User', 44, 'qms-token', '2136bc84efcbdd6b96cf4ce5a4753d427f7a4ec76e5c50f5882047ef6cd7d526', '[\"*\"]', '2026-05-03 11:57:33', NULL, '2026-05-03 11:57:31', '2026-05-03 11:57:33'),
(250, 'App\\Models\\User', 44, 'qms-token', 'ec9761357a03d5b47d04d9d85974f2cb40c8ea959507e936d7f79d4b77da9403', '[\"*\"]', '2026-05-03 11:58:44', NULL, '2026-05-03 11:57:35', '2026-05-03 11:58:44'),
(251, 'App\\Models\\User', 44, 'qms-token', '3524827204fb1f76023715f0964c727421c9ccb719613823d309fae7fd4c33d3', '[\"*\"]', '2026-05-03 11:59:35', NULL, '2026-05-03 11:59:34', '2026-05-03 11:59:35'),
(259, 'App\\Models\\User', 10, 'qms-token', '6b09de492473f354ab62c84a1cf7e024d4af53aa6182249305173ab868f6ceba', '[\"*\"]', '2026-05-04 09:04:42', NULL, '2026-05-03 13:06:11', '2026-05-04 09:04:42'),
(260, 'App\\Models\\User', 39, 'qms-token', '22825d4d7e871284afb745964757b32d62a1951a52fa712d577b5d1c42b5c83c', '[\"*\"]', '2026-05-04 07:26:54', NULL, '2026-05-04 07:24:03', '2026-05-04 07:26:54'),
(262, 'App\\Models\\User', 4, 'qms-token', '3a39fc2a24ee795699c2a8ce121e331a555b65e6d5a503b3aee65822e80f7dae', '[\"*\"]', '2026-05-04 09:42:34', NULL, '2026-05-04 09:09:14', '2026-05-04 09:42:34');

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

CREATE TABLE `requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reference_no` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `requester_id` bigint(20) UNSIGNED NOT NULL,
  `assignee_id` bigint(20) UNSIGNED DEFAULT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `priority` enum('low','medium','high','critical') NOT NULL DEFAULT 'medium',
  `risk_level` enum('low','medium','high') NOT NULL DEFAULT 'medium' COMMENT 'Risk level as defined by QDM: low/medium/high',
  `estimated_completion_days` smallint(5) UNSIGNED DEFAULT NULL COMMENT 'Estimated processing time in business days set by QDM Manager on acknowledge',
  `eta_set_at` timestamp NULL DEFAULT NULL COMMENT 'When QDM Manager set the ETA',
  `acknowledged_at` timestamp NULL DEFAULT NULL COMMENT 'When QDM Manager acknowledged the request',
  `clarification_requested_at` timestamp NULL DEFAULT NULL COMMENT 'When clarification was last requested from requester',
  `clarification_submitted_at` timestamp NULL DEFAULT NULL COMMENT 'When requester submitted the requested clarification',
  `completed_at` timestamp NULL DEFAULT NULL COMMENT 'When QDM staff marked the request as completed (before requester confirmation)',
  `receipt_confirmed_at` timestamp NULL DEFAULT NULL COMMENT 'When requester clicked Confirm Receipt — triggers status=closed',
  `cancelled_at` timestamp NULL DEFAULT NULL COMMENT 'When the request was cancelled',
  `cycle_time_hours` decimal(10,2) DEFAULT NULL COMMENT 'Auto-calculated: hours from submitted to closed/cancelled',
  `delay_reason` text DEFAULT NULL COMMENT 'Documents reason when actual completion exceeds ETA',
  `status` enum('draft','submitted','pending_clarification','acknowledged','under_review','in_progress','completed','pending_approval','approved','rejected','closed','cancelled') NOT NULL DEFAULT 'draft' COMMENT 'QDM workflow status',
  `type` enum('internal','external','client','vendor','regulatory') NOT NULL DEFAULT 'internal',
  `request_sub_type` varchar(100) DEFAULT NULL COMMENT 'Specific sub-type from QDM form: policy_update, new_policy, procedure_update, sla_update, unregulated_work, document_review, quality_review, issue_analysis, kpi_measurement, form_update, new_form, manual_update, new_project, new_development, quality_note, external_audit_prep, other',
  `dynamic_fields` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Type-specific question answers stored as key-value JSON per Appendix A' CHECK (json_valid(`dynamic_fields`)),
  `target_department` enum('quality','compliance') NOT NULL DEFAULT 'quality' COMMENT 'Which department receives this request after Dept Manager approval',
  `due_date` date DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `closed_at` timestamp NULL DEFAULT NULL,
  `resolution` text DEFAULT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `closed_by` bigint(20) UNSIGNED DEFAULT NULL,
  `status_updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `status_updated_at` timestamp NULL DEFAULT NULL COMMENT 'Timestamp of the most recent status update',
  `clarification_notes` text DEFAULT NULL COMMENT 'Clarification information submitted by requester'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `requests`
--

INSERT INTO `requests` (`id`, `reference_no`, `title`, `description`, `category_id`, `requester_id`, `assignee_id`, `department_id`, `priority`, `risk_level`, `estimated_completion_days`, `eta_set_at`, `acknowledged_at`, `clarification_requested_at`, `clarification_submitted_at`, `completed_at`, `receipt_confirmed_at`, `cancelled_at`, `cycle_time_hours`, `delay_reason`, `status`, `type`, `request_sub_type`, `dynamic_fields`, `target_department`, `due_date`, `submitted_at`, `approved_at`, `closed_at`, `resolution`, `attachments`, `metadata`, `created_at`, `updated_at`, `approved_by`, `closed_by`, `status_updated_by`, `status_updated_at`, `clarification_notes`) VALUES
(1, 'REQ-2024-0001', 'Laptop Replacement for Finance Team', 'Current laptops in Finance are 5+ years old and causing productivity issues.', NULL, 12, NULL, 4, 'high', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'submitted', 'internal', NULL, NULL, 'quality', '2024-02-15', NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-08 09:43:27', '2026-03-05 09:43:27', NULL, NULL, NULL, NULL, NULL),
(2, 'REQ-2024-0002', 'ISO 9001 Internal Audit Scheduling', 'Need to schedule Q1 internal audit for QA department.', NULL, 2, 2, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'in_progress', 'internal', NULL, NULL, 'quality', '2024-02-01', NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-15 09:43:27', '2026-03-05 12:09:23', NULL, NULL, NULL, NULL, NULL),
(3, 'REQ-2024-0003', 'Employee Training - Data Privacy', 'Mandatory PDPA awareness training for all staff.', NULL, 6, NULL, 5, 'medium', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'in_progress', 'internal', NULL, NULL, 'quality', '2024-03-01', NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-03 09:43:27', '2026-03-05 09:43:27', NULL, NULL, NULL, NULL, NULL),
(4, 'REQ-2024-0004', 'Office Renovation - 3rd Floor', 'The 3rd floor meeting rooms require refurbishment.', NULL, 4, NULL, 2, 'low', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'draft', 'internal', NULL, NULL, 'quality', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-17 09:43:27', '2026-03-05 09:43:27', NULL, NULL, NULL, NULL, NULL),
(5, 'REQ-2024-0005', 'Regulatory Filing - SAMA Q4 Report', 'Quarterly compliance report submission to SAMA.', NULL, 3, 2, 7, 'critical', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'pending_approval', 'regulatory', NULL, NULL, 'quality', '2024-01-31', NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-11 09:43:27', '2026-03-05 09:43:27', NULL, NULL, NULL, NULL, NULL),
(6, 'REQ-2024-0006', 'New HR Policy Review', 'Review and update the Remote Work Policy document.', NULL, 6, 2, 5, 'medium', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 'internal', NULL, NULL, 'quality', '2024-02-28', NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-14 09:43:27', '2026-03-05 09:43:27', NULL, NULL, NULL, NULL, NULL),
(7, 'REQ-2024-0007', 'Client Portal Enhancement Request', 'SABIC has requested additional reporting features in the portal.', NULL, 7, 5, 6, 'high', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'submitted', 'client', NULL, NULL, 'quality', '2024-02-20', NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-06 09:43:27', '2026-03-05 09:43:27', NULL, NULL, NULL, NULL, NULL),
(8, 'REQ-2024-0008', 'Vendor Qualification - Tahakom Digital', 'Initiate qualification process for new digital marketing vendor.', NULL, 7, 3, 6, 'medium', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'in_progress', 'vendor', NULL, NULL, 'quality', '2024-03-15', NULL, '2026-03-05 09:54:42', NULL, NULL, NULL, NULL, '2026-02-27 09:43:27', '2026-03-05 12:08:21', 1, NULL, NULL, NULL, NULL),
(9, 'REQ-2024-0009', 'Access Control System Upgrade', 'Upgrade physical access control system in server room.', NULL, 5, 9, 3, 'critical', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'in_progress', 'internal', NULL, NULL, 'quality', '2024-01-25', NULL, '2026-03-05 11:58:07', NULL, NULL, NULL, NULL, '2026-02-27 09:43:27', '2026-03-05 12:08:45', 1, NULL, NULL, NULL, NULL),
(10, 'REQ-2024-0010', 'Annual Quality Report - 2023', 'Prepare and circulate the annual quality performance report.', NULL, 2, NULL, 1, 'high', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'closed', 'internal', NULL, NULL, 'quality', '2024-01-31', NULL, NULL, '2026-03-05 09:43:27', 'Annual quality report successfully prepared and distributed to all stakeholders.', NULL, NULL, '2026-02-27 09:43:27', '2026-03-05 09:43:27', NULL, NULL, NULL, NULL, NULL),
(11, 'REQ-2026-0011', 'ffffffffffffffffffff', 'ffffffffffffffffffffffffffffffffffffffffff', NULL, 1, NULL, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'submitted', 'internal', NULL, NULL, 'quality', '2026-04-18', '2026-04-14 08:26:06', NULL, NULL, NULL, NULL, NULL, '2026-04-14 08:26:05', '2026-04-14 08:26:06', NULL, NULL, NULL, NULL, NULL),
(12, 'REQ-2026-0012', 'fffffffffffffffffffffffffff', 'dffffffffffffff', NULL, 1, NULL, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'submitted', 'internal', NULL, NULL, 'quality', '2026-04-15', '2026-04-14 08:38:02', NULL, NULL, NULL, NULL, NULL, '2026-04-14 08:38:01', '2026-04-14 08:38:02', NULL, NULL, NULL, NULL, NULL),
(13, 'REQ-2026-0013', 'Require a form for Diamond system', 'I require to prepare a form for diamond system', NULL, 10, 2, 2, 'medium', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'approved', 'internal', NULL, NULL, 'quality', '2026-12-05', '2026-04-15 08:09:23', '2026-04-15 08:10:19', NULL, NULL, NULL, NULL, '2026-04-15 08:09:22', '2026-04-15 08:10:19', 4, NULL, NULL, NULL, NULL),
(14, 'REQ-2026-0014', 'require form for DIamond QMS', 'I require to create a form for QMS', NULL, 10, 3, 2, 'medium', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'in_progress', 'internal', NULL, NULL, 'quality', '2026-04-25', '2026-04-15 08:14:03', '2026-04-15 08:14:55', NULL, NULL, NULL, NULL, '2026-04-15 08:14:02', '2026-04-15 08:15:47', 4, NULL, NULL, NULL, NULL),
(15, 'REQ-2026-0015', 'ABDCF', 'dddddddddddddddddddddd', 10, 1, NULL, 1, 'high', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'submitted', 'internal', NULL, NULL, 'quality', '2026-04-19', NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-16 08:14:58', '2026-04-16 08:14:59', NULL, NULL, NULL, NULL, NULL),
(16, 'REQ-2026-0016', 'dddddddddddddddddddddddd', 'ddddddddddddddddddd', 8, 1, NULL, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'submitted', 'internal', NULL, NULL, 'quality', '2026-04-18', NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-16 10:22:26', '2026-04-16 10:22:27', NULL, NULL, NULL, NULL, NULL),
(17, 'REQ-2026-0017', 'ssssssssssssssssssss', 'sssssssssssssssssssss', 7, 1, NULL, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'approved', 'internal', NULL, NULL, 'quality', '2026-04-19', NULL, NULL, NULL, NULL, '[\"requests\\/2026\\/04\\/f0ccd5de-af97-4594-8774-02cbeeb03914.docx\"]', NULL, '2026-04-16 11:45:43', '2026-04-16 11:58:20', NULL, NULL, NULL, NULL, NULL),
(18, 'REQ-2026-0018', 'fgfgf', 'fg fgfgfg', 2, 1, NULL, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'submitted', 'internal', NULL, NULL, 'quality', '2026-04-21', NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-19 12:04:44', '2026-04-19 12:04:45', NULL, NULL, NULL, NULL, NULL),
(19, 'REQ-2026-0019', 'complaint test', 'dfd dfd fdddf dfdf', 5, 1, NULL, 1, 'high', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'submitted', 'internal', NULL, NULL, 'quality', '2026-04-20', NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-19 12:05:34', '2026-04-19 12:05:34', NULL, NULL, NULL, NULL, NULL),
(20, 'REQ-2026-0020', 'test complaint', 'test complaint', 3, 26, NULL, 3, 'medium', 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'approved', 'internal', NULL, NULL, 'quality', '2026-05-05', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-03 08:13:24', '2026-05-03 08:56:09', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `request_approvals`
--

CREATE TABLE `request_approvals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `request_id` bigint(20) UNSIGNED NOT NULL,
  `approver_id` bigint(20) UNSIGNED NOT NULL,
  `sequence` int(11) NOT NULL DEFAULT 1,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `comments` text DEFAULT NULL,
  `decided_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `request_approvals`
--

INSERT INTO `request_approvals` (`id`, `request_id`, `approver_id`, `sequence`, `status`, `comments`, `decided_at`, `created_at`) VALUES
(1, 5, 2, 1, 'pending', NULL, NULL, '2026-03-04 09:43:27'),
(2, 8, 1, 1, 'approved', NULL, '2026-03-05 09:54:42', '2026-03-05 09:54:42'),
(3, 9, 1, 1, 'approved', 'Approved by System Administrator. Forwarded to Quality Department.', '2026-03-05 11:58:07', '2026-03-05 11:58:07'),
(4, 8, 1, 2, 'approved', 'Assigned to Ahmed Al-Rashid by QA Manager System Administrator.', '2026-03-05 12:08:21', '2026-03-05 12:08:21'),
(5, 9, 1, 2, 'approved', 'Assigned to Hana Al-Otaibi by QA Manager System Administrator.', '2026-03-05 12:08:45', '2026-03-05 12:08:45'),
(6, 2, 1, 2, 'approved', 'Assigned to Fatima Al-Hassan by QA Manager System Administrator.', '2026-03-05 12:09:23', '2026-03-05 12:09:23'),
(7, 11, 1, 1, 'pending', 'Submitted by System Administrator. Awaiting Department Manager approval before routing to Quality Department.', NULL, '2026-04-14 08:26:06'),
(8, 12, 1, 1, 'pending', 'Submitted by System Administrator. Awaiting Department Manager approval before routing to Quality Department.', NULL, '2026-04-14 08:38:02'),
(9, 13, 10, 1, 'pending', 'Submitted by Mohammed Al-Ghamdi. Awaiting Department Manager approval before routing to Quality Department.', NULL, '2026-04-15 08:09:23'),
(10, 13, 4, 1, 'approved', 'Approved by Omar Al-Farsi. Forwarded to Quality Department.', '2026-04-15 08:10:20', '2026-04-15 08:10:20'),
(11, 14, 10, 1, 'pending', 'Submitted by Mohammed Al-Ghamdi. Awaiting Department Manager approval before routing to Quality Department.', NULL, '2026-04-15 08:14:03'),
(12, 14, 4, 1, 'approved', 'approved', '2026-04-15 08:14:55', '2026-04-15 08:14:55'),
(13, 14, 2, 2, 'approved', 'Assigned to Ahmed Al-Rashid by Fatima Al-Hassan.', '2026-04-15 08:15:47', '2026-04-15 08:15:47'),
(14, 5, 2, 1, 'pending', NULL, NULL, '2026-04-15 11:04:36'),
(15, 5, 2, 1, 'pending', NULL, NULL, '2026-04-15 11:12:58'),
(16, 17, 1, 1, 'approved', NULL, '2026-04-16 11:58:20', '2026-04-16 11:58:20'),
(17, 20, 16, 1, 'approved', 'please check the request', '2026-05-03 08:56:09', '2026-05-03 08:56:09');

-- --------------------------------------------------------

--
-- Table structure for table `request_categories`
--

CREATE TABLE `request_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `sla_hours` int(11) NOT NULL DEFAULT 48,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `request_categories`
--

INSERT INTO `request_categories` (`id`, `name`, `description`, `sla_hours`, `created_at`) VALUES
(1, 'Policy & Procedure', 'New or updated policies, procedures, and work instructions', 72, '2026-04-15 13:44:20'),
(2, 'Document Control', 'Form updates, manuals, and document reviews', 48, '2026-04-15 13:44:20'),
(3, 'Quality & Compliance', 'Quality reviews, audits, and ISO 9001 requirements', 48, '2026-04-15 13:44:20'),
(4, 'Regulatory & SLA', 'SLA changes and regulatory compliance requests', 24, '2026-04-15 13:44:20'),
(5, 'IT & Cyber Security', 'Technology, systems, and cybersecurity requests', 24, '2026-04-15 13:44:20'),
(6, 'HR & Training', 'Human resources and training & development requests', 96, '2026-04-15 13:44:20'),
(7, 'Operations', 'Day-to-day unregulated and operational process work', 72, '2026-04-15 13:44:20'),
(8, 'Analysis & KPI', 'Issue analysis, KPI measurement, and performance reporting', 48, '2026-04-15 13:44:20'),
(9, 'Projects', 'New projects and system development initiatives', 120, '2026-04-15 13:44:20'),
(10, 'General', 'Other requests not covered by the above categories', 72, '2026-04-15 13:44:20');

-- --------------------------------------------------------

--
-- Table structure for table `request_comments`
--

CREATE TABLE `request_comments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `request_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `comment` text NOT NULL,
  `is_internal` tinyint(1) NOT NULL DEFAULT 0,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `request_comments`
--

INSERT INTO `request_comments` (`id`, `request_id`, `user_id`, `comment`, `is_internal`, `attachments`, `created_at`) VALUES
(1, 1, 12, 'The Dell Latitude models have been identified as suitable replacements. Estimated cost: SAR 15,000.', 0, NULL, '2026-03-03 09:43:27'),
(2, 1, 2, 'Please provide the IT asset replacement policy for justification.', 1, NULL, '2026-03-04 09:43:27'),
(3, 5, 3, 'SAMA portal submission confirmed. Reference number: SAMA-2024-Q4-001892.', 0, NULL, '2026-03-02 09:43:27'),
(4, 7, 7, 'SABIC requirements document attached. Development estimated at 3 weeks.', 0, NULL, '2026-03-04 09:43:27'),
(5, 14, 2, 'fffeeffef', 0, NULL, '2026-04-15 08:16:43'),
(6, 1, 12, 'The Dell Latitude models have been identified as suitable replacements. Estimated cost: SAR 15,000.', 0, NULL, '2026-04-14 11:04:36'),
(7, 1, 2, 'Please provide the IT asset replacement policy for justification.', 1, NULL, '2026-04-15 11:04:36'),
(8, 5, 3, 'SAMA portal submission confirmed. Reference number: SAMA-2024-Q4-001892.', 0, NULL, '2026-04-13 11:04:36'),
(9, 7, 7, 'SABIC requirements document attached. Development estimated at 3 weeks.', 0, NULL, '2026-04-15 11:04:36'),
(10, 1, 12, 'The Dell Latitude models have been identified as suitable replacements. Estimated cost: SAR 15,000.', 0, NULL, '2026-04-14 11:12:58'),
(11, 1, 2, 'Please provide the IT asset replacement policy for justification.', 1, NULL, '2026-04-15 11:12:58'),
(12, 5, 3, 'SAMA portal submission confirmed. Reference number: SAMA-2024-Q4-001892.', 0, NULL, '2026-04-13 11:12:58'),
(13, 7, 7, 'SABIC requirements document attached. Development estimated at 3 weeks.', 0, NULL, '2026-04-15 11:12:58');

-- --------------------------------------------------------

--
-- Table structure for table `risks`
--

CREATE TABLE `risks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reference_no` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `type` enum('strategic','operational','financial','compliance','reputational','technical','environmental','other') NOT NULL DEFAULT 'operational',
  `status` enum('identified','assessed','treatment_in_progress','monitored','closed','accepted') NOT NULL DEFAULT 'identified',
  `likelihood` tinyint(4) NOT NULL DEFAULT 3,
  `impact` tinyint(4) NOT NULL DEFAULT 3,
  `risk_score` tinyint(4) GENERATED ALWAYS AS (`likelihood` * `impact`) STORED,
  `risk_level` varchar(20) GENERATED ALWAYS AS (case when `likelihood` * `impact` <= 4 then 'low' when `likelihood` * `impact` <= 9 then 'medium' when `likelihood` * `impact` <= 16 then 'high' else 'critical' end) STORED,
  `residual_likelihood` tinyint(4) DEFAULT NULL,
  `residual_impact` tinyint(4) DEFAULT NULL,
  `treatment_strategy` enum('avoid','mitigate','transfer','accept') DEFAULT NULL,
  `treatment_plan` text DEFAULT NULL,
  `review_date` date DEFAULT NULL,
  `next_review_date` date DEFAULT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `risks`
--

INSERT INTO `risks` (`id`, `reference_no`, `title`, `description`, `category_id`, `owner_id`, `department_id`, `type`, `status`, `likelihood`, `impact`, `residual_likelihood`, `residual_impact`, `treatment_strategy`, `treatment_plan`, `review_date`, `next_review_date`, `attachments`, `created_at`, `updated_at`) VALUES
(1, 'RSK-2026-0001', 'fvfdvfdv', 'fbbfgbvgfb', 4, 1, 7, 'operational', 'identified', 2, 1, NULL, NULL, 'mitigate', NULL, NULL, '2026-04-15', NULL, '2026-04-14 08:08:10', '2026-04-14 08:08:10');

-- --------------------------------------------------------

--
-- Table structure for table `risk_categories`
--

CREATE TABLE `risk_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `risk_categories`
--

INSERT INTO `risk_categories` (`id`, `name`, `description`) VALUES
(1, 'Strategic Risk', 'Risks to strategic objectives'),
(2, 'Operational Risk', 'Risks in day-to-day operations'),
(3, 'Financial Risk', 'Financial exposure and losses'),
(4, 'Compliance & Legal Risk', 'Regulatory and legal exposure'),
(5, 'Technology & Cyber Risk', 'IT and cybersecurity threats'),
(6, 'Reputational Risk', 'Brand and reputation damage'),
(7, 'Environmental Risk', 'Environmental and sustainability risks'),
(8, 'Strategic Risk', 'Risks to strategic objectives'),
(9, 'Operational Risk', 'Risks in day-to-day operations'),
(10, 'Financial Risk', 'Financial exposure and losses'),
(11, 'Compliance & Legal Risk', 'Regulatory and legal exposure'),
(12, 'Technology & Cyber Risk', 'IT and cybersecurity threats'),
(13, 'Reputational Risk', 'Brand and reputation damage'),
(14, 'Environmental Risk', 'Environmental and sustainability risks'),
(15, 'Strategic Risk', 'Risks to strategic objectives'),
(16, 'Operational Risk', 'Risks in day-to-day operations'),
(17, 'Financial Risk', 'Financial exposure and losses'),
(18, 'Compliance & Legal Risk', 'Regulatory and legal exposure'),
(19, 'Technology & Cyber Risk', 'IT and cybersecurity threats'),
(20, 'Reputational Risk', 'Brand and reputation damage'),
(21, 'Environmental Risk', 'Environmental and sustainability risks');

-- --------------------------------------------------------

--
-- Table structure for table `risk_controls`
--

CREATE TABLE `risk_controls` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `risk_id` bigint(20) UNSIGNED NOT NULL,
  `control_description` text NOT NULL,
  `control_type` enum('preventive','detective','corrective') NOT NULL DEFAULT 'preventive',
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `effectiveness` enum('effective','partially_effective','ineffective','not_tested') NOT NULL DEFAULT 'not_tested',
  `last_tested_date` date DEFAULT NULL,
  `next_test_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `risk_reviews`
--

CREATE TABLE `risk_reviews` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `risk_id` bigint(20) UNSIGNED NOT NULL,
  `reviewed_by_id` bigint(20) UNSIGNED NOT NULL,
  `review_date` date NOT NULL,
  `likelihood_reviewed` tinyint(4) DEFAULT NULL,
  `impact_reviewed` tinyint(4) DEFAULT NULL,
  `status_after` varchar(50) DEFAULT NULL,
  `comments` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `slug`, `description`, `permissions`, `created_at`, `updated_at`) VALUES
(1, 'Super Admin', 'super_admin', 'Full system access — all modules, settings, and user management.', '[\"*\"]', NULL, NULL),
(2, 'QA Manager', 'qa_manager', 'Leads the Quality department. Receives approved requests, assigns to QA team, oversees all quality modules.', '[\"request.*\",\"nc.*\",\"capa.*\",\"risk.*\",\"document.*\",\"audit.*\",\"complaint.*\",\"vendor.*\",\"visit.*\",\"sla.view\",\"okr.view\",\"report.view\",\"survey.view\",\"admin.access\"]', NULL, NULL),
(3, 'Department Manager', 'dept_manager', 'Approves/rejects requests from their department before forwarding to QA.', '[\"request.view\",\"request.create\",\"request.approve\",\"nc.view\",\"nc.create\",\"capa.view\",\"capa.create\",\"complaint.view\",\"complaint.create\",\"document.view\",\"risk.view\",\"audit.view\",\"report.view\"]', NULL, NULL),
(4, 'Auditor', 'auditor', 'Internal auditor — executes audit programmes and raises NC/CAPA findings.', '[\"audit.*\",\"nc.create\",\"nc.view\",\"capa.view\",\"request.view\",\"document.view\",\"risk.view\",\"report.view\"]', NULL, NULL),
(5, 'Employee', 'employee', 'General staff — can raise requests and submit complaints.', '[\"request.create\",\"request.view_own\",\"nc.view\",\"capa.view\",\"complaint.create\",\"document.view\"]', NULL, NULL),
(6, 'Client', 'client', 'External client portal — complaint submission and visit tracking only.', '[\"complaint.create\",\"visit.view\"]', NULL, NULL),
(7, 'Quality Officer', 'qa_officer', 'QA team member — processes requests assigned by the QA Manager or Supervisor.', '[\"request.view\",\"request.process\",\"nc.view\",\"nc.create\",\"capa.view\",\"capa.create\",\"document.view\",\"risk.view\",\"audit.view\",\"complaint.view\",\"report.view\",\"document.create\"]', NULL, '2026-04-27 11:35:41'),
(8, 'Quality Supervisor', 'quality_supervisor', 'Supervises QA Officers. Processes NCs, CAPAs, audits, and assigns tasks. Reports to QA Manager.', '[\"request.view\",\"request.create\",\"request.approve\",\"nc.*\",\"capa.*\",\"risk.view\",\"risk.create\",\"document.view\",\"document.create\",\"audit.*\",\"complaint.view\",\"complaint.create\",\"visit.view\",\"sla.view\",\"okr.view\",\"report.view\",\"survey.view\"]', NULL, NULL),
(9, 'Compliance Manager', 'compliance_manager', 'Leads Compliance & Risk. Manages regulatory complaints, NC/CAPA, risk register, and audit findings.', '[\"request.view\",\"request.create\",\"nc.*\",\"capa.*\",\"risk.*\",\"document.view\",\"document.create\",\"audit.view\",\"audit.create\",\"complaint.*\",\"sla.view\",\"report.view\"]', NULL, NULL),
(10, 'Compliance Officer', 'compliance_officer', 'Compliance team member — handles regulatory complaints, NC records, and risk assessments.', '[\"request.view\",\"nc.view\",\"nc.create\",\"capa.view\",\"capa.create\",\"risk.view\",\"risk.create\",\"document.view\",\"audit.view\",\"complaint.view\",\"complaint.create\",\"report.view\"]', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sla_definitions`
--

CREATE TABLE `sla_definitions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `client_id` bigint(20) UNSIGNED DEFAULT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `category` varchar(150) DEFAULT NULL,
  `response_time_hours` int(11) DEFAULT NULL,
  `resolution_time_hours` int(11) DEFAULT NULL,
  `availability_percent` decimal(5,2) DEFAULT NULL,
  `penalty_clause` text DEFAULT NULL,
  `reward_clause` text DEFAULT NULL,
  `effective_from` date DEFAULT NULL,
  `effective_to` date DEFAULT NULL,
  `status` enum('draft','active','expired','suspended') NOT NULL DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sla_measurements`
--

CREATE TABLE `sla_measurements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sla_id` bigint(20) UNSIGNED NOT NULL,
  `metric_id` bigint(20) UNSIGNED NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `actual_value` decimal(10,2) NOT NULL,
  `target_value` decimal(10,2) NOT NULL,
  `threshold_warning` decimal(10,2) DEFAULT NULL,
  `status` varchar(20) GENERATED ALWAYS AS (case when `actual_value` >= `target_value` then 'met' when `threshold_warning` is not null and `actual_value` >= `threshold_warning` then 'warning' else 'breached' end) STORED,
  `notes` text DEFAULT NULL,
  `recorded_by_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sla_metrics`
--

CREATE TABLE `sla_metrics` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sla_id` bigint(20) UNSIGNED NOT NULL,
  `metric_name` varchar(150) NOT NULL,
  `target_value` decimal(10,2) NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `measurement_frequency` enum('daily','weekly','monthly','quarterly') NOT NULL DEFAULT 'monthly',
  `threshold_warning` decimal(10,2) DEFAULT NULL,
  `threshold_critical` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `surveys`
--

CREATE TABLE `surveys` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reference_no` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `type` enum('csat','nps','ces','custom') NOT NULL DEFAULT 'csat',
  `status` enum('draft','active','paused','closed') NOT NULL DEFAULT 'draft',
  `target_type` enum('client','complaint','visit','general') NOT NULL DEFAULT 'general',
  `target_id` bigint(20) UNSIGNED DEFAULT NULL,
  `send_date` date DEFAULT NULL,
  `close_date` date DEFAULT NULL,
  `created_by_id` bigint(20) UNSIGNED NOT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `response_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `avg_score` decimal(5,2) DEFAULT NULL,
  `nps_score` decimal(6,2) DEFAULT NULL,
  `thank_you_message` text DEFAULT NULL,
  `is_anonymous` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `survey_answers`
--

CREATE TABLE `survey_answers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `response_id` bigint(20) UNSIGNED NOT NULL,
  `question_id` bigint(20) UNSIGNED NOT NULL,
  `answer_text` text DEFAULT NULL,
  `answer_rating` tinyint(4) DEFAULT NULL,
  `answer_choices` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`answer_choices`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `survey_questions`
--

CREATE TABLE `survey_questions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `survey_id` bigint(20) UNSIGNED NOT NULL,
  `question_text` text NOT NULL,
  `question_type` enum('rating','nps','text','choice','checkbox','yes_no') NOT NULL DEFAULT 'rating',
  `rating_max` int(11) NOT NULL DEFAULT 5,
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options`)),
  `is_required` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `survey_responses`
--

CREATE TABLE `survey_responses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `survey_id` bigint(20) UNSIGNED NOT NULL,
  `respondent_name` varchar(255) DEFAULT NULL,
  `respondent_email` varchar(255) DEFAULT NULL,
  `respondent_type` enum('client','staff','anonymous') NOT NULL DEFAULT 'anonymous',
  `client_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `token` varchar(64) DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_settings`
--

CREATE TABLE `system_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(100) NOT NULL,
  `group` varchar(50) NOT NULL DEFAULT 'general',
  `label` varchar(255) NOT NULL,
  `value` text DEFAULT NULL,
  `type` varchar(30) NOT NULL DEFAULT 'text',
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options`)),
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `system_settings`
--

INSERT INTO `system_settings` (`id`, `key`, `group`, `label`, `value`, `type`, `options`, `description`, `created_at`, `updated_at`) VALUES
(1, 'org_name', 'general', 'Organization Name', 'Diamond Insurance Broker', 'text', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(2, 'org_logo_url', 'general', 'Logo URL', '', 'text', NULL, 'URL or path to organization logo', '2026-03-05 09:55:23', '2026-03-05 10:20:59'),
(3, 'org_country', 'general', 'Country', 'Saudi Arabia', 'text', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(4, 'org_industry', 'general', 'Industry', 'Insurance & Financial Services', 'text', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(5, 'qms_standard', 'general', 'QMS Standard', 'ISO 9001:2015', 'text', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(6, 'fiscal_year_start', 'general', 'Fiscal Year Start', '01-01', 'text', NULL, 'MM-DD format', '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(7, 'default_language', 'general', 'Default Language', 'en', 'select', '[\"en\",\"ar\"]', NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(8, 'date_format', 'general', 'Date Format', 'DD MMM YYYY', 'select', '[\"DD MMM YYYY\",\"MM\\/DD\\/YYYY\",\"YYYY-MM-DD\"]', NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(9, 'email_notifications', 'notifications', 'Email Notifications', '1', 'boolean', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(10, 'email_from_name', 'notifications', 'Email From Name', 'QMS Pro System', 'text', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(11, 'email_from_address', 'notifications', 'Email From Address', 'noreply@qms.com', 'text', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(12, 'notify_on_nc_created', 'notifications', 'Notify on NC Created', '1', 'boolean', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(13, 'notify_on_capa_overdue', 'notifications', 'Notify on CAPA Overdue', '1', 'boolean', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(14, 'notify_on_risk_high', 'notifications', 'Notify on High Risk', '1', 'boolean', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(15, 'notify_on_audit', 'notifications', 'Notify on Audit Due', '1', 'boolean', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(16, 'overdue_reminder_days', 'notifications', 'Overdue Reminder (Days)', '3', 'number', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(17, 'session_timeout_min', 'security', 'Session Timeout (min)', '60', 'number', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(18, 'max_login_attempts', 'security', 'Max Login Attempts', '5', 'number', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(19, 'password_min_length', 'security', 'Min Password Length', '8', 'number', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(20, 'require_2fa', 'security', 'Require 2FA', '0', 'boolean', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(21, 'audit_log_retention', 'security', 'Audit Log Retention (days)', '365', 'number', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(22, 'theme', 'appearance', 'Theme', 'dark', 'select', '[\"dark\",\"light\",\"midnight\",\"ocean\",\"forest\",\"crimson\",\"slate\",\"dracula\"]', NULL, '2026-03-05 09:55:23', '2026-03-05 10:20:59'),
(23, 'primary_color', 'appearance', 'Primary Color', '#3b82f6', 'color', NULL, NULL, '2026-03-05 09:55:23', '2026-03-05 10:10:58'),
(24, 'items_per_page', 'appearance', 'Items Per Page', '15', 'select', '[\"10\",\"15\",\"25\",\"50\"]', NULL, '2026-03-05 09:55:23', '2026-03-05 10:20:59');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `employee_id` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role_id`, `department_id`, `employee_id`, `phone`, `avatar`, `is_active`, `email_verified_at`, `remember_token`, `last_login_at`, `created_at`, `updated_at`) VALUES
(1, 'System Administrator', 'admin@qms.com', '$2y$12$OqIa3zIV5FeWCdzniP8MTOMA9yKtVqRGTce/i4su1mOhe0qPIfzLK', 1, 1, 'EMP001', '+966 506623623', NULL, 1, '2026-04-16 11:12:48', NULL, '2026-05-03 12:12:53', '2026-04-16 11:12:48', '2026-05-03 12:12:53'),
(2, 'Fatima Al-Hassan', 'fatima.h@qms.com', '$2y$12$5AZfEwBFg4/82HK4pDx4peokc3yncXDCC6HDhlKBkvHRNG72gIj4y', 2, 1, 'EMP002', '+966 506998435', NULL, 1, '2026-04-16 11:12:48', NULL, '2026-04-29 09:00:57', '2026-04-16 11:12:48', '2026-04-29 09:00:57'),
(3, 'Ahmed Al-Rashid', 'ahmed.r@qms.com', '$2y$12$L/2dbT4Px9QKBmo8tg..W.zMlpGgKj/S1PQfEue2ibLwbB9tknJ3y', 7, 1, 'EMP004', '+966 509891722', NULL, 1, '2026-04-16 11:12:48', NULL, NULL, '2026-04-16 11:12:48', '2026-04-16 11:12:48'),
(4, 'Omar Al-Farsi', 'omar.f@qms.com', '$2y$12$zMdpF/S6f3b2Z6FsEgu/8.9B4xWBlRpJsZPJ5krsj5Z13yXYvDTya', 3, 2, 'EMP010', '+966 505568862', NULL, 1, '2026-04-16 11:12:48', NULL, '2026-05-04 09:09:14', '2026-04-16 11:12:48', '2026-05-04 09:09:14'),
(5, 'Sara Al-Mohri', 'sara.m@qms.com', '$2y$12$54BXZvB0xxgVgY0..AtMhO6tTvKtYligDfpMUvxs8AZSdsR8iitxq', 3, 3, 'EMP011', '+966 505018372', NULL, 1, '2026-04-16 11:12:48', NULL, NULL, '2026-04-16 11:12:48', '2026-04-16 11:12:48'),
(6, 'Khalid Al-Sabah', 'khalid.s@qms.com', '$2y$12$e6INdLFoQSzgN7dio55P8OgWiGCAKYk61lpw4M6tUkFnAARf6lKsu', 3, 5, 'EMP013', '+966 505280714', NULL, 1, '2026-04-16 11:12:48', NULL, NULL, '2026-04-16 11:12:48', '2026-04-16 11:12:48'),
(7, 'Noura Al-Qassim', 'noura.q@qms.com', '$2y$12$2YH9qFzMYsPLcrsz8rwnXeFJfM9VoTDHAMz5jWZ6vdYtAfkmEGGTe', 3, 6, 'EMP014', '+966 505924903', NULL, 1, '2026-04-16 11:12:48', NULL, NULL, '2026-04-16 11:12:48', '2026-04-16 11:12:48'),
(8, 'Yusuf Al-Amri', 'yusuf.a@qms.com', '$2y$12$A0X2de9Va2he2PdcCn8kWeHq8JdGJ7d7My4Z7AnaU1YkKJkFQFxTi', 7, 1, 'EMP006', '+966 508129165', NULL, 1, '2026-04-16 11:12:48', NULL, '2026-04-29 08:45:32', '2026-04-16 11:12:48', '2026-04-29 08:45:32'),
(9, 'Hana Al-Otaibi', 'hana.o@qms.com', '$2y$12$huMYDNNd9BOjXdWpOEu.S.NL74bi/kGzcG5JXLMoTpF7DlNPWOZMO', 7, 1, 'EMP005', '+966 504057357', NULL, 1, '2026-04-16 11:12:48', NULL, NULL, '2026-04-16 11:12:48', '2026-04-16 11:12:48'),
(10, 'Mohammed Al-Ghamdi', 'mohammed.g@qms.com', '$2y$12$LI13X1BQiObz/FCU0D2kyuNxuCdAwQ0UweIsWL.mExloFIn53I5US', 5, 2, 'EMP017', '+966 502809307', NULL, 1, '2026-04-16 11:12:48', NULL, '2026-05-04 09:04:54', '2026-04-16 11:12:48', '2026-05-04 09:04:54'),
(11, 'Layla Al-Shehri', 'layla.s@qms.com', '$2y$12$4aRGEcUPnLJNJlgYepzE3uUkUR7lcrN/ZLRhfqhs2zURaDe/pZhZS', 5, 3, 'EMP018', '+966 506276812', NULL, 1, '2026-04-16 11:12:48', NULL, NULL, '2026-04-16 11:12:48', '2026-04-16 11:12:48'),
(12, 'Abdullah Al-Zahrani', 'abdullah.z@qms.com', '$2y$12$At5X/xfcTRPFvtMTA.VbWeMnS7MpGCcvTOc473IUsN.xKmvkltkwe', 5, 4, 'EMP019', '+966 503699822', NULL, 1, '2026-04-16 11:12:48', NULL, NULL, '2026-04-16 11:12:48', '2026-04-16 11:12:48'),
(13, 'Reem Al-Harbi', 'reem.h@qms.com', '$2y$12$L9zomlojcbtF7F7M/c8c5.22sPtl226k9e7jYkhOhPV75Yqnvs8te', 5, 8, 'EMP020', '+966 501496422', NULL, 1, '2026-04-16 11:12:48', NULL, NULL, '2026-04-16 11:12:48', '2026-04-16 11:12:48'),
(14, 'Tariq Al-Dosari', 'tariq.d@qms.com', '$2y$12$1Bh1BTT4NgOHlC1cV5HPi.GBkpVCi/6iqiG9sZ3WUUeH4PS.qg2UW', 4, 1, 'EMP016', '+966 503766172', NULL, 1, '2026-04-16 11:12:48', NULL, NULL, '2026-04-16 11:12:48', '2026-04-16 11:12:48'),
(15, 'Client Portal User', 'client@example.com', '$2y$12$YYb05ODLzajdMT0nOZrw4u1neW/72wgEO.geCwEeNgpSgU7gwCNIK', 6, NULL, 'CLI001', '+966 509221039', NULL, 1, '2026-04-16 11:12:48', NULL, NULL, '2026-04-16 11:12:48', '2026-04-16 11:12:48'),
(16, 'jithin  qms', 'j.varkey@qms.com', '$2y$12$KYJTY5RDAExGiF8ejrylDe.fg.gxkduChTpYGpmzFSUD2sG0nckMC', 3, 3, '129', '+966546496620', NULL, 1, NULL, NULL, '2026-05-03 08:55:38', '2026-03-05 11:20:52', '2026-05-03 08:55:38'),
(17, 'Shaden Al-Otaibi', 'shaden.a@qms.com', '$2y$12$8OKJRU.qUqgr52YMedEPr.gtZjMOdRbsm3GKftrcLI1B092C4ugpq', 8, 1, 'EMP003', '+966 502112885', NULL, 1, '2026-04-16 11:12:48', NULL, '2026-04-29 09:49:34', '2026-04-16 11:12:48', '2026-04-29 09:49:34'),
(18, 'Turki Al-Abdali', 'turki.a@qms.com', '$2y$12$1aCPYrWXRWOD3G0O.n2FXOfCNlgWCwl0hUpZSzsATjYh4m.mjAKcO', 9, 7, 'EMP007', '+966 509835813', NULL, 1, '2026-04-16 11:12:48', NULL, '2026-05-03 08:56:21', '2026-04-16 11:12:48', '2026-05-03 08:56:21'),
(19, 'Rawan Al-Yayani', 'rawan.y@qms.com', '$2y$12$N1jZ2CE2V57fjCy/xCtAgO9fSoNsIBdrffNiZFfQ1DlFmuTy69GjC', 10, 7, 'EMP008', '+966 504846728', NULL, 1, '2026-04-16 11:12:48', NULL, NULL, '2026-04-16 11:12:48', '2026-04-16 11:12:48'),
(21, 'Nouf Al-Raoji', 'nouf.r@qms.com', '$2y$12$cXfZ0EumdQC1VohsUCf.8OFS0GPec0pvUlJirdTHWgaS.nf7ULy/m', 3, 4, 'EMP012', '+966 502189106', NULL, 1, '2026-04-16 11:12:48', NULL, NULL, '2026-04-16 11:12:48', '2026-04-16 11:12:48'),
(22, 'Shahad Al-Harti', 'shahad.h@qms.com', '$2y$12$QEWz/gPSIj2pEhLRrSO8Suys3ELoVYvQdWr1Oy2c.TEdEI21MVyrS', 3, 8, 'EMP015', '+966 506291261', NULL, 1, '2026-04-16 11:12:48', NULL, NULL, '2026-04-16 11:12:48', '2026-04-16 11:12:48'),
(23, 'Super Admin', 'j.varkey1@dbroker.com.sa', '$2y$12$BTaoD7U5a/r0akNzUPHcIumBzIoTxkBU1HT/jyTH1YfnoxvQ8DqC.', 1, 1, 'EMPP0001', 'NULL', 'NULL', 1, '2026-04-28 09:57:23', NULL, NULL, '2013-11-20 21:00:00', '2013-11-20 21:00:00'),
(24, 'Badr Alshaya', 'b.alshaya@dbroker.com.sa', '$2y$12$wiE2n14LS3GFWTbdic5mg.2rphy5KO.7BdmfqD1A/h67nWwktGC6G', 1, 3, '106', '555558880', 'preview_143123.jpg', 1, '2026-04-28 09:57:23', NULL, NULL, '2023-01-29 08:43:00', '2026-04-28 10:17:46'),
(25, 'Jithin varkey Varkey', 'j.varkey@dbroker.com.sa', '$2y$12$E8odnNt3Uf8YX/n2vr2rFOwvKSUKk9dctzXeBA5SLbTaFAzALooeG', 3, 3, '129', '546496620', 'preview_132607.jpg', 1, '2026-04-28 09:57:24', 'OXKhPdZLsnwYMrcuiU4hKQFBYnUgmFW5A5Gp0cFonzLUIoHwUHZeSKGaf7DC', '2026-04-30 13:33:48', '2023-01-30 09:11:00', '2026-05-03 08:55:03'),
(26, 'Jinesh Mani', 'j.mani@dbroker.com.sa', '$2y$12$hHkHtD.BfE0QOoRytExO4eyGkdjjdH5ePl2LNcWbg8x7.52ZdqxU2', 5, 3, '182', '552816197', 'NULL', 1, '2026-04-28 09:57:24', 'u6CCWBKo3r9OOAzwh07ZFnzPYhLXrFzEYtWuo0wfR91fqjrEt0324laJ3mAs', '2026-05-03 08:51:24', '2023-02-01 05:02:00', '2026-05-03 08:51:24'),
(27, 'Hany Hashem', 'h.hashem@dbroker.com.sa', '$2y$12$/Lf2Fy5OKQCc.NOBuvGLw.zHjr3SPNUTmf5MPBt2vPe.WE3Q0vama', 3, 9, '236', '530685650', 'preview_132658.jpg', 1, '2026-04-28 09:57:24', NULL, NULL, '2023-02-01 05:07:00', '2026-04-28 10:25:23'),
(28, 'Azher ahmed mohammed Ahmed', 'm.ahmed@dbroker.com.sa', '$2y$12$8StPd6lC9i7Hjo3CN9MaheAnUfmx9EUgXiF9JkdOG8Rx0RFXRLmwC', 5, 9, '150', '550110571', 'NULL', 1, '2026-04-28 09:57:24', NULL, NULL, '2023-02-01 05:11:00', '2026-04-28 10:25:30'),
(29, 'Ahmed Helmy Elsaid', 'a.helmy@dbroker.com.sa', '$2y$12$DLiKvmniAXBgPsju2uKMiOF9BvJA0RiAFg6ZP35elrJAjQNAZ/5Pm', 3, 4, '158', '549765206', 'preview_151208.jpg', 1, '2026-04-28 09:57:25', NULL, NULL, '2023-02-01 05:13:00', '2026-04-28 10:16:06'),
(30, 'Manal Thakaa Al Mubarak', 'm.almubarak@dbroker.com.sa', '$2y$12$7GeOLQzitQv00ZEmg6pLc.vgA2fCaai13TIa6.Va8N2aGIDwiEUQ.', 5, 6, '186', '559934427', 'preview_145231.jpg', 1, '2026-04-28 09:57:25', NULL, NULL, '2023-02-01 05:25:00', '2026-04-29 11:05:12'),
(31, 'Shadi fahmy', 's.fahmy@dbroker.com.sa', '$2y$12$IMQ9eZZPQalC6G5Y6l8x/umiGQrMs80BkDq/6lG8EbmVo4GEdLSPa', 5, 9, '228', 'NULL', 'NULL', 1, '2026-04-28 09:57:25', NULL, NULL, '2023-08-07 03:12:00', '2026-04-28 10:25:37'),
(32, 'Raed Abdallah Al Garhy', 'r.algarhy@dbroker.com.sa', '$2y$12$wKwOAOF1.TE9VkXrbFqzb.dc0O7dk1zyqaxYl2YQadkHc.t5I4jae', 5, 5, '251', 'NULL', 'NULL', 1, '2026-04-28 09:57:25', NULL, NULL, '2023-08-07 03:39:00', '2026-04-28 10:17:14'),
(33, 'Mohammed Alhossan', 'm.alhossan@dbroker.com.sa', '$2y$12$kqOwi23dwXkeOmDoXfvMGudZv7F/SHQdpTKi8x2Sxwm80J0fcuWXu', 5, 5, '263', '556585669', 'preview_155929.jpg', 1, '2026-04-28 09:57:26', NULL, NULL, '2023-08-07 04:11:00', '2026-04-28 10:17:23'),
(34, 'Sara Said', 's.said@dbroker.com.sa', '$2y$12$GQXN9R9whm1lJqbzUUPjkOlhZaAvOWAAYGHrPYbRX0247XNdtEiN6', 5, 2, '264', '546727330', 'preview_140744.jpg', 1, '2026-04-28 09:57:26', NULL, NULL, '2023-08-07 04:14:00', '2026-04-28 10:18:56'),
(35, 'Fay alshalawi', 'f.alshalawi@dbroker.com.sa', '$2y$12$JKmOCbeAmwXKpKQ41dNfr.IpKiQuqY5hO0B9IhCxk8IApDkjNJXsa', 5, 4, '278', '597860027', 'preview_124153.jpg', 1, '2026-04-28 09:57:26', NULL, NULL, '2023-08-07 05:03:00', '2026-04-28 10:16:17'),
(36, 'Mohammed Alhayif', 'm.alhayif@dbroker.com.sa', '$2y$12$B0aLAlwAyDou.ENo7H9uwOwiPcn/pOEB1JEwCc555gqe2jEzMpJVC', 5, 9, '280', '583114380', 'preview_135223.jpg', 1, '2026-04-28 09:57:26', NULL, NULL, '2023-08-09 08:43:00', '2026-04-28 10:25:46'),
(37, 'Alanoud alshaya', 'a.alshayea@dbroker.com.sa', '$2y$12$/j1vAZHDDf0cjArMpSfjTuTw0scuYA91.aitAQZexAKrg27GlUvSC', 5, 4, '284', '543363301', 'preview_145705.jpg', 1, '2026-04-28 09:57:26', NULL, NULL, '2023-11-08 08:28:00', '2026-04-28 10:16:25'),
(38, 'HR Administrator', 'diamond-hr@dbroker.com.sa', '$2y$12$ZRKNfx9PMj9Jd8jUI1.cv.vU8p/AJ1sZYfjZ642aMSpWTIZ1Icemy', 2, 1, '999', 'NULL', 'NULL', 0, '2026-04-28 09:57:27', NULL, NULL, '2024-01-11 07:19:00', '2026-04-28 10:07:23'),
(39, 'Shaden Alotaibi', 's.alotaibi@dbroker.com.sa', '$2y$12$ZeQH0sw5A1A5.pZknU2PwuAtk1okqmH8S3ZjESy7Lng6sNxKW2Ldm', 2, 1, '291', 'NULL', 'NULL', 1, '2026-04-28 09:57:27', NULL, '2026-05-04 07:24:03', '2024-01-31 04:44:00', '2026-05-04 07:24:03'),
(40, 'Renad Alanazi', 'r.alenezi@dbroker.com.sa', '$2y$12$EwPrOh.UI76NEjKisx/o7O75G2MNsdp5EpfbSfXNaszLA92EqCY7a', 5, 6, '294', 'NULL', 'NULL', 1, '2026-04-28 09:57:27', NULL, NULL, '2024-02-25 08:28:00', '2026-04-28 10:23:53'),
(41, 'Turki Alabdli', 't.alabdali@dbroker.com.sa', '$2y$12$q1Iuu4FuR86dxTskueKvZ.7oAkpw5VAekj2zTJMNMe3H7W0NYg0.m', 9, 7, '300', 'NULL', 'preview_124051.jpeg', 1, '2026-04-28 09:57:27', NULL, '2026-04-28 10:58:57', '2024-05-06 03:43:00', '2026-04-28 10:58:57'),
(42, 'KHALID Abu Humeid', 'khaled.abo.homaid.58@gmail.com', '$2y$12$IT.fSflFdv3KQX5r5yXc7OHjyDmmgikY9Kco9FskM8IAKPeROx4tG', 5, 6, '301', 'NULL', 'NULL', 1, '2026-04-28 09:57:28', NULL, NULL, '2024-05-15 06:15:00', '2026-04-28 10:24:05'),
(43, 'Abduallah Alquthami', 'a.alquthami@dbroker.com.sa', '$2y$12$HZwJlBB/2/DPH8A/Dns2M.S3yHqA2lRE4CalpqIl0uKI0OqNzDcZq', 3, 6, '305', 'NULL', 'NULL', 1, '2026-04-28 09:57:28', NULL, NULL, '2024-07-14 05:26:00', '2026-04-28 10:24:16'),
(44, 'Nouf Alraouji', 'n.alraouji@shahin.com.sa', '$2y$12$h7ipPVhd3wZ28fT1EwegZu2ZJj8uS3Q3U980upvTQtDNqWYHpj7te', 8, 1, '309', 'NULL', 'NULL', 1, '2026-04-28 09:57:28', NULL, '2026-05-03 12:13:58', '2024-08-12 10:34:00', '2026-05-03 12:13:58'),
(45, 'Essra Alsurihi', 'e.abdulmohsen@dbroker.com.sa', '$2y$12$7hvp2NKyhfg.OlTAQExQveMsuavDR9X.uddh3PS6.vaJAKlPYkAQO', 5, 6, '313', 'NULL', 'NULL', 1, '2026-04-28 09:57:28', NULL, NULL, '2024-08-23 17:59:00', '2026-04-28 10:24:24'),
(46, 'Alanoud Alshammri', 'a.alshamri@dbroker.com.sa', '$2y$12$RL/u4mN23Y.SwryGpn.hEuRHL9MdWcwz6nmBSPXkF8E.Rq6PfiGuq', 5, 6, '316', 'NULL', 'NULL', 1, '2026-04-28 09:57:29', NULL, NULL, '2024-10-03 05:55:00', '2026-04-28 10:24:32'),
(47, 'Sumaih Altalhi', 's.altalhi@shahin.com.sa', '$2y$12$2nvUfTE3eRIJtcpuRlSytePmo2g0qqzq58T6tjMrRMi4mPtKzZbKS', 5, 3, '329', '552980056', 'NULL', 1, '2026-04-28 09:57:29', NULL, NULL, '2025-03-26 11:14:00', '2026-04-28 10:18:15'),
(48, 'Rawan Alalyany', 'r.alalyany@dbroker.com.sa', '$2y$12$j2MAT3F3HGnx3dfTfNnNf.zChVsqWbdKKgD/hEF3qoIObL0/3NXe6', 5, 2, '330', 'NULL', 'NULL', 1, '2026-04-28 09:57:29', NULL, NULL, '2025-05-04 05:36:00', '2026-04-28 10:19:04'),
(49, 'Hussam Altwajiri', 'h.twaijari@dbroker.com.sa', '$2y$12$BwFOTuEPwdm8QiV/6KXGb.Z1N7jzczHZVq6opUU9V9h5Eekug.HVe', 3, 2, '334', '504182029', 'NULL', 1, '2026-04-28 09:57:29', NULL, NULL, '2025-07-07 09:34:00', '2026-04-28 10:19:11'),
(50, 'Jood Sami Kalakttawi', 'j.kalkattawi@dbroker.com.sa', '$2y$12$Zaxql6nzEgsl3e87WH7ww.xHNkoNmKRQR2ZebAhFYEvPnAd20k0VG', 5, 6, '335', 'NULL', 'NULL', 1, '2026-04-28 09:57:30', NULL, NULL, '2025-08-05 03:47:00', '2026-04-28 10:24:40'),
(51, 'Saddam Yahya', 's.yahya@shahin.com.sa', '$2y$12$IVIpmJorHB3yd.2BE7Pe/eGqmAA43/1AUEIPtG16Fq0BZl3sWfHbm', 5, 3, '327', 'NULL', 'NULL', 1, '2026-04-28 09:57:30', NULL, NULL, '2025-08-20 13:52:00', '2026-04-28 10:18:22'),
(52, 'Layan AlHarbi', 'l.alharbi@dbroker.com.sa', '$2y$12$ctqf/v5hOA38kcnvBdAR8eJJcaThUUkvXf0i7Ti4R4dClIlpQsUA.', 5, 2, '339', 'NULL', 'NULL', 1, '2026-04-28 09:57:30', NULL, NULL, '2025-08-21 03:54:00', '2026-04-28 10:19:19'),
(53, 'Amal Muhammad', 'a.kamal@dbroker.com.sa', '$2y$12$JVX9Xtpu0Z9hkpP2GiRmVu5vz.a4oRYvsj3CM/gpPa6eoiFYTi.E6', 5, 2, '336', 'NULL', 'NULL', 1, '2026-04-28 09:57:30', NULL, NULL, '2025-08-21 05:26:00', '2026-04-28 10:19:28'),
(54, 'Shahad Alharthi', 's.alharthi@dbroker.com.sa', '$2y$12$BBLJgnJbiBV2X34cZT1egexTh7YqabNicqAPeUYODC7e4Tt2nCqmO', 7, 1, '338', 'NULL', 'NULL', 1, '2026-04-28 09:57:30', NULL, '2026-04-29 11:13:04', '2025-09-07 07:51:00', '2026-04-29 11:13:04'),
(55, 'Atheer Alanazi', 'a.alanazi@dbroker.com.sa', '$2y$12$grimkyhTmPKJXTm6UhQnAOimswf.Uzr9/f3m/Wb.J30sZD.8qiou6', 5, 2, '340', 'NULL', 'NULL', 1, '2026-04-28 09:57:31', NULL, NULL, '2025-09-07 08:39:00', '2026-04-28 10:19:37'),
(56, 'Atheer Abdulsalam', 'a.abdulsalam@dbroker.com.sa', '$2y$12$kkiqGgGliOEDiQtMMmvMruKAkSJy0pK1gS5GahSW.c7/dT/QBBQHW', 5, 6, '342', '593684060', 'NULL', 1, '2026-04-28 09:57:31', NULL, NULL, '2025-09-10 09:07:00', '2026-04-28 10:24:52'),
(57, 'HESSA ALGHAFIS', 'h.alghafis@dbroker.com.sa', '$2y$12$bcwnTGUQnCd.zOHyzq0rCewJtlFhqgyNZhdi5PiJPelvqOkpndUqO', 5, 2, '343', 'NULL', 'NULL', 1, '2026-04-28 09:57:31', NULL, NULL, '2025-09-21 08:56:00', '2026-04-28 10:19:54'),
(58, 'Haya AlKhamis', 'h.alKhamis@dbroker.com.sa', '$2y$12$m4uaLiiQ8kFL2x1dX6hSdeL9hDFUBOOQs4klQgq1CyaGNGi0P4txu', 5, 2, '346', 'NULL', 'NULL', 1, '2026-04-28 09:57:31', NULL, NULL, '2025-10-16 07:56:00', '2026-04-28 10:20:02'),
(59, 'Ghala Al Jarallah', 'g.aljarallah@dbroker.com.sa', '$2y$12$wMHEWgSFGnwmDjWNfnZV8.s2YSo9FfS6vTH3mVyhn19wKENZsAlpq', 5, 2, '350', 'NULL', 'NULL', 1, '2026-04-28 09:57:32', NULL, NULL, '2025-12-04 06:37:00', '2026-04-28 10:20:08'),
(60, 'Anas Almmri', 'a.almmari@shahin.com.sa', '$2y$12$neWv4NhA8eT74IbCthLRxuS9Z6v2l8eFUoDj0KhnqoUFfg8D.Vjhu', 5, 3, '349', '543688299', 'NULL', 1, '2026-04-28 09:57:32', NULL, NULL, '2025-12-08 10:02:00', '2026-04-28 10:18:38'),
(61, 'Mohammed Abdulfaisal', 'm.abdulfaisal@dbroker.com.sa', '$2y$12$pACqqvWiyw.a6xmyBbDLhuV44rWsGQzR.RNKXsNok/8kCmGr0QVp.', 5, 2, '354', 'NULL', 'NULL', 1, '2026-04-28 09:57:32', NULL, NULL, '2026-01-26 06:44:00', '2026-04-28 10:20:35'),
(62, 'Abdulaziz Medkhali', 'a.medkhali@dbroker.com.sa', '$2y$12$JbTYYmsndwNETWUGhOgNmu0xQNSbvvERLBZVfdWG.w62cY3wTdUaO', 5, 6, '353', '591066657', 'NULL', 1, '2026-04-28 09:57:32', NULL, NULL, '2026-02-01 10:12:00', '2026-04-28 10:25:00'),
(63, 'Turki mahdi', 't.mahdi@dbroker.com.sa', '$2y$12$HG2ueH8SKk8t3mGfOu.DjeGSk4Zf.vJLepBbz32utTNUzm1iFtqNa', 5, 6, '355', 'NULL', 'NULL', 1, '2026-04-28 09:57:33', NULL, NULL, '2026-02-01 10:14:00', '2026-04-28 10:25:09'),
(64, 'Bandar Dhafer', 'b.dhafer@shahin.com.sa', '$2y$12$Eh7F7nmadiG0OdRIOgfEhOYwwEfZ.e6owzLq9MExjj3URx2RYy8/W', 5, 3, '337', 'NULL', 'NULL', 1, '2026-04-28 09:57:33', NULL, NULL, '2026-02-17 04:10:00', '2026-04-28 10:26:55');

-- --------------------------------------------------------

--
-- Table structure for table `vendors`
--

CREATE TABLE `vendors` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `type` enum('supplier','service_provider','contractor','partner','consultant') NOT NULL DEFAULT 'supplier',
  `registration_no` varchar(100) DEFAULT NULL,
  `tax_no` varchar(100) DEFAULT NULL,
  `contact_name` varchar(200) DEFAULT NULL,
  `contact_email` varchar(200) DEFAULT NULL,
  `contact_phone` varchar(50) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `account_manager_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('prospect','active','approved','suspended','blacklisted','inactive') NOT NULL DEFAULT 'prospect',
  `risk_level` enum('low','medium','high','critical') NOT NULL DEFAULT 'low',
  `qualification_status` enum('not_qualified','pending','qualified','expired') NOT NULL DEFAULT 'not_qualified',
  `qualification_date` date DEFAULT NULL,
  `qualification_expiry` date DEFAULT NULL,
  `overall_rating` decimal(3,1) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `vendors`
--

INSERT INTO `vendors` (`id`, `name`, `code`, `category_id`, `type`, `registration_no`, `tax_no`, `contact_name`, `contact_email`, `contact_phone`, `address`, `country`, `website`, `account_manager_id`, `status`, `risk_level`, `qualification_status`, `qualification_date`, `qualification_expiry`, `overall_rating`, `metadata`, `created_at`, `updated_at`) VALUES
(1, 'Oracle Corporation', 'VND001', 1, 'service_provider', NULL, NULL, 'Account Manager', 'ae@oracle.com', NULL, NULL, 'USA', NULL, 5, 'approved', 'low', 'qualified', '2023-01-15', '2025-01-15', 4.2, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(2, 'Al-Futtaim Tech Services', 'VND002', 1, 'service_provider', NULL, NULL, 'Saleh Al-Futtaim', 'saleh@alfuttaim-tech.ae', NULL, NULL, 'UAE', NULL, 5, 'active', 'medium', 'qualified', '2023-06-01', '2025-06-01', 3.8, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(3, 'KPMG Saudi Arabia', 'VND003', 2, 'consultant', NULL, NULL, 'Partner Office', 'riyadh@kpmg.com.sa', NULL, NULL, 'Saudi Arabia', NULL, 3, 'approved', 'low', 'qualified', '2024-01-01', '2026-01-01', 4.5, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(4, 'Jadawel Facilities Mgmt', 'VND004', 3, 'supplier', NULL, NULL, 'Operations Team', 'ops@jadawel.com.sa', NULL, NULL, 'Saudi Arabia', NULL, 4, 'active', 'low', 'qualified', '2023-03-01', '2024-03-01', 3.5, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(5, 'DHL Express KSA', 'VND005', 4, 'supplier', NULL, NULL, 'Corporate Sales', 'corporate@dhl.com.sa', NULL, NULL, 'Saudi Arabia', NULL, 4, 'approved', 'low', 'qualified', '2023-01-01', '2025-01-01', 4.0, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(6, 'Tahakom Digital', 'VND006', 5, 'service_provider', NULL, NULL, 'Ibrahim Al-Shehri', 'ibrahim@tahakom.com', NULL, NULL, 'Saudi Arabia', NULL, 7, 'prospect', 'medium', 'pending', NULL, NULL, NULL, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(7, 'Bupa Arabia', 'VND007', 6, 'service_provider', NULL, NULL, 'Corporate Team', 'corporate@bupa.com.sa', NULL, NULL, 'Saudi Arabia', NULL, 3, 'approved', 'low', 'qualified', '2024-06-01', '2026-06-01', 4.1, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(8, 'Inaya Medical Clinics', 'VND008', 6, 'service_provider', NULL, NULL, 'Admin Office', 'admin@inaya.sa', NULL, NULL, 'Saudi Arabia', NULL, 6, 'active', 'low', 'qualified', '2024-02-01', '2026-02-01', 3.9, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27');

-- --------------------------------------------------------

--
-- Table structure for table `vendor_categories`
--

CREATE TABLE `vendor_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `vendor_categories`
--

INSERT INTO `vendor_categories` (`id`, `name`, `description`) VALUES
(27, 'Technology & Software', 'IT products, software, and SaaS vendors'),
(28, 'Professional Services', 'Consulting, advisory, and professional services'),
(29, 'Facility Management', 'Building, maintenance, and facility services'),
(30, 'Logistics & Transport', 'Shipping, courier, and logistics providers'),
(31, 'Marketing & Communications', 'Marketing agencies and media companies'),
(32, 'Financial Services', 'Banking, insurance, and financial providers'),
(33, 'Training & Development', 'Training providers and e-learning platforms'),
(34, 'Legal Services', 'Law firms and legal advisory services');

-- --------------------------------------------------------

--
-- Table structure for table `vendor_contracts`
--

CREATE TABLE `vendor_contracts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `vendor_id` bigint(20) UNSIGNED NOT NULL,
  `contract_no` varchar(100) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `type` enum('service','supply','nda','partnership','maintenance','other') NOT NULL DEFAULT 'service',
  `value` decimal(15,2) DEFAULT NULL,
  `currency` varchar(10) NOT NULL DEFAULT 'SAR',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `auto_renewal` tinyint(1) NOT NULL DEFAULT 0,
  `renewal_notice_days` int(11) NOT NULL DEFAULT 30,
  `status` enum('draft','active','expired','terminated','suspended') NOT NULL DEFAULT 'draft',
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `vendor_contracts`
--

INSERT INTO `vendor_contracts` (`id`, `vendor_id`, `contract_no`, `title`, `description`, `type`, `value`, `currency`, `start_date`, `end_date`, `auto_renewal`, `renewal_notice_days`, `status`, `owner_id`, `file_path`, `created_at`, `updated_at`) VALUES
(1, 1, 'CON-2024-001', 'Oracle ERP Licensing & Support', NULL, 'service', 450000.00, 'SAR', '2024-01-01', '2026-12-31', 1, 90, 'active', 5, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(2, 2, 'CON-2024-002', 'IT Infrastructure Managed Services', NULL, 'service', 280000.00, 'SAR', '2024-03-01', '2025-02-28', 0, 60, 'expired', 5, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(3, 3, 'CON-2024-003', 'Annual Audit & Assurance Services', NULL, 'service', 120000.00, 'SAR', '2024-01-01', '2024-12-31', 0, 30, 'expired', 3, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(4, 4, 'CON-2024-004', 'Facility Management & Cleaning', NULL, 'maintenance', 95000.00, 'SAR', '2024-01-01', '2025-12-31', 1, 30, 'active', 4, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(5, 5, 'CON-2025-001', 'Express Logistics Agreement', NULL, 'service', 65000.00, 'SAR', '2025-01-01', '2025-12-31', 1, 30, 'active', 4, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(6, 7, 'CON-2025-002', 'Group Health Insurance Policy', NULL, 'service', 380000.00, 'SAR', '2025-06-01', '2026-05-31', 1, 60, 'active', 3, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(7, 1, 'CON-2026-001', 'Oracle Cloud Infrastructure 2026', NULL, 'service', 520000.00, 'SAR', '2026-01-01', '2026-12-31', 1, 90, 'active', 5, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(8, 1, 'CON-2024-0001', 'IT Infrastructure Maintenance Agreement', NULL, 'maintenance', 250000.00, 'SAR', '2024-01-01', '2024-12-31', 0, 30, 'active', 1, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(9, 2, 'CON-2024-0002', 'Cybersecurity Consulting Services', NULL, 'service', 180000.00, 'SAR', '2024-02-01', '2024-07-31', 0, 30, 'expired', 1, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(10, 3, 'CON-2025-0001', 'Cloud Hosting & Support SLA', NULL, 'service', 420000.00, 'SAR', '2025-01-01', '2025-12-31', 0, 30, 'active', 1, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(11, 4, 'CON-2025-0002', 'Legal & Compliance Advisory NDA', NULL, 'nda', 60000.00, 'SAR', '2025-03-01', '2026-02-28', 0, 30, 'active', 1, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(12, 5, 'CON-2025-0003', 'HR Recruitment Partnership Agreement', NULL, 'partnership', 95000.00, 'SAR', '2025-06-01', '2026-05-31', 0, 30, 'active', 1, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(13, 6, 'CON-2026-0001', 'Office Facilities Management Contract', NULL, 'supply', 310000.00, 'SAR', '2026-01-01', '2026-12-31', 0, 30, 'active', 1, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(14, 7, 'CON-2026-0002', 'Marketing & Brand Services Agreement', NULL, 'service', 140000.00, 'SAR', '2026-01-15', '2026-12-31', 0, 30, 'active', 1, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(15, 8, 'CON-2026-0003', 'Software Licensing Agreement — ERP', NULL, 'service', 560000.00, 'SAR', '2026-02-01', '2027-01-31', 0, 30, 'active', 1, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(16, 1, 'CON-2026-0004', 'Insurance Brokerage Platform NDA', NULL, 'nda', NULL, 'SAR', '2026-02-15', '2028-02-14', 0, 30, 'active', 1, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(17, 2, 'CON-2025-0004', 'HVAC Maintenance Service', NULL, 'maintenance', 85000.00, 'SAR', '2025-04-01', '2025-09-30', 0, 30, 'expired', 1, NULL, '2026-03-05 09:43:27', '2026-03-05 09:43:27'),
(18, 5, 'CON-2026-0018', 'ffffffffffgfgff', NULL, 'maintenance', 300000.00, 'SAR', '2026-04-15', '2027-04-14', 0, 30, 'draft', 2, NULL, '2026-04-15 08:36:29', '2026-04-15 08:36:29');

-- --------------------------------------------------------

--
-- Table structure for table `vendor_evaluations`
--

CREATE TABLE `vendor_evaluations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `vendor_id` bigint(20) UNSIGNED NOT NULL,
  `evaluated_by_id` bigint(20) UNSIGNED NOT NULL,
  `evaluation_date` date NOT NULL,
  `period` varchar(50) DEFAULT NULL,
  `quality_score` decimal(4,2) DEFAULT NULL,
  `delivery_score` decimal(4,2) DEFAULT NULL,
  `price_score` decimal(4,2) DEFAULT NULL,
  `service_score` decimal(4,2) DEFAULT NULL,
  `compliance_score` decimal(4,2) DEFAULT NULL,
  `overall_score` decimal(4,2) GENERATED ALWAYS AS ((`quality_score` + `delivery_score` + `price_score` + `service_score` + `compliance_score`) / 5) STORED,
  `comments` text DEFAULT NULL,
  `recommendations` text DEFAULT NULL,
  `status` enum('draft','submitted','approved') NOT NULL DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `visits`
--

CREATE TABLE `visits` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reference_no` varchar(50) NOT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `type` enum('client_visit','insurer_audit','regulatory_inspection','partnership_review','sales_meeting','technical_review') NOT NULL DEFAULT 'client_visit',
  `purpose` text NOT NULL,
  `visit_date` date NOT NULL,
  `visit_time` time DEFAULT NULL,
  `duration_hours` decimal(4,1) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `is_virtual` tinyint(1) NOT NULL DEFAULT 0,
  `meeting_link` varchar(255) DEFAULT NULL,
  `host_id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('planned','confirmed','in_progress','completed','cancelled','rescheduled') NOT NULL DEFAULT 'planned',
  `agenda` text DEFAULT NULL,
  `minutes` text DEFAULT NULL,
  `action_items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`action_items`)),
  `outcome` text DEFAULT NULL,
  `rating` tinyint(4) DEFAULT NULL,
  `rating_comments` text DEFAULT NULL,
  `follow_up_date` date DEFAULT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `visits`
--

INSERT INTO `visits` (`id`, `reference_no`, `client_id`, `type`, `purpose`, `visit_date`, `visit_time`, `duration_hours`, `location`, `is_virtual`, `meeting_link`, `host_id`, `status`, `agenda`, `minutes`, `action_items`, `outcome`, `rating`, `rating_comments`, `follow_up_date`, `attachments`, `created_at`, `updated_at`) VALUES
(1, 'VIS-2026-0001', 1, 'client_visit', 'weeeeeeeeeeee', '2026-11-11', NULL, NULL, 'wwwwwwwwwwwwww', 0, NULL, 1, 'completed', 'eeeeeeeeeeeeeeeeeee', 'vvvvvvvvvvvvvvvvvvv', '\"[{\\\"description\\\":\\\"vvvvvvvv\\\",\\\"responsible\\\":\\\"vvvvvvvvvv\\\",\\\"due_date\\\":\\\"\\\",\\\"done\\\":false},{\\\"description\\\":\\\"vvvvvvvvvv\\\",\\\"responsible\\\":\\\"vvvvvvvvvvv\\\",\\\"due_date\\\":\\\"\\\",\\\"done\\\":false},{\\\"description\\\":\\\"vvvvvvvvv\\\",\\\"responsible\\\":\\\"vvvvvvvv\\\",\\\"due_date\\\":\\\"\\\",\\\"done\\\":false}]\"', NULL, 3, NULL, NULL, NULL, '2026-04-14 09:46:54', '2026-04-14 09:48:26'),
(2, 'VIS-2026-0002', 1, 'client_visit', 'quality visit', '2026-04-15', '14:30:00', 1.0, 'meeting room', 0, NULL, 2, 'completed', '1......', 'we discussed bla l\'pvjbmnjmlm nl', '\"[{\\\"description\\\":\\\"ABC \\\",\\\"responsible\\\":\\\"DIAMOND \\\",\\\"due_date\\\":\\\"2026-04-30\\\",\\\"done\\\":false},{\\\"description\\\":\\\"fde\\\",\\\"responsible\\\":\\\"jithin \\\",\\\"due_date\\\":\\\"2026-04-30\\\",\\\"done\\\":false}]\"', NULL, 5, 'fhjffdjfdkjkjgfnf', NULL, NULL, '2026-04-15 08:30:54', '2026-04-15 08:33:19');

-- --------------------------------------------------------

--
-- Table structure for table `visit_findings`
--

CREATE TABLE `visit_findings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `visit_id` bigint(20) UNSIGNED NOT NULL,
  `finding_type` enum('positive','concern','requirement','action_item','observation') NOT NULL DEFAULT 'observation',
  `description` text NOT NULL,
  `priority` enum('low','medium','high','critical') NOT NULL DEFAULT 'medium',
  `responsible_id` bigint(20) UNSIGNED DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `status` enum('open','in_progress','closed') NOT NULL DEFAULT 'open'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `visit_findings`
--

INSERT INTO `visit_findings` (`id`, `visit_id`, `finding_type`, `description`, `priority`, `responsible_id`, `due_date`, `status`) VALUES
(1, 1, 'observation', 'vvvvvvvvvvvvvvvvvvvv', 'medium', NULL, NULL, 'open');

-- --------------------------------------------------------

--
-- Table structure for table `visit_participants`
--

CREATE TABLE `visit_participants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `visit_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `external_name` varchar(200) DEFAULT NULL,
  `external_email` varchar(200) DEFAULT NULL,
  `external_role` varchar(100) DEFAULT NULL,
  `is_internal` tinyint(1) NOT NULL DEFAULT 1,
  `attended` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `visit_participants`
--

INSERT INTO `visit_participants` (`id`, `visit_id`, `user_id`, `external_name`, `external_email`, `external_role`, `is_internal`, `attended`) VALUES
(1, 2, NULL, 'Abdullah', NULL, 'Sales and marketing', 1, NULL),
(2, 2, NULL, 'jithin', NULL, 'IT', 1, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `activity_logs_user_id_foreign` (`user_id`),
  ADD KEY `activity_logs_module_action_index` (`module`,`action`),
  ADD KEY `activity_logs_model_type_model_id_index` (`model_type`,`model_id`);

--
-- Indexes for table `audits`
--
ALTER TABLE `audits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `audits_reference_no_unique` (`reference_no`),
  ADD KEY `audits_program_id_foreign` (`program_id`),
  ADD KEY `audits_lead_auditor_id_foreign` (`lead_auditor_id`),
  ADD KEY `audits_department_id_foreign` (`department_id`);

--
-- Indexes for table `audit_checklists`
--
ALTER TABLE `audit_checklists`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_checklists_audit_id_foreign` (`audit_id`);

--
-- Indexes for table `audit_findings`
--
ALTER TABLE `audit_findings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_findings_audit_id_foreign` (`audit_id`),
  ADD KEY `audit_findings_department_id_foreign` (`department_id`),
  ADD KEY `audit_findings_assignee_id_foreign` (`assignee_id`),
  ADD KEY `audit_findings_capa_id_foreign` (`capa_id`);

--
-- Indexes for table `audit_programs`
--
ALTER TABLE `audit_programs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_programs_created_by_id_foreign` (`created_by_id`);

--
-- Indexes for table `audit_team`
--
ALTER TABLE `audit_team`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `audit_team_audit_id_user_id_unique` (`audit_id`,`user_id`),
  ADD KEY `audit_team_user_id_foreign` (`user_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `capas`
--
ALTER TABLE `capas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `capas_reference_no_unique` (`reference_no`),
  ADD KEY `capas_nc_id_foreign` (`nc_id`),
  ADD KEY `capas_owner_id_foreign` (`owner_id`),
  ADD KEY `capas_department_id_foreign` (`department_id`),
  ADD KEY `capas_effectiveness_verified_by_id_foreign` (`effectiveness_verified_by_id`);

--
-- Indexes for table `capa_tasks`
--
ALTER TABLE `capa_tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `capa_tasks_capa_id_foreign` (`capa_id`),
  ADD KEY `capa_tasks_responsible_id_foreign` (`responsible_id`);

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clients_code_unique` (`code`),
  ADD KEY `clients_account_manager_id_foreign` (`account_manager_id`);

--
-- Indexes for table `complaints`
--
ALTER TABLE `complaints`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `complaints_reference_no_unique` (`reference_no`),
  ADD KEY `complaints_category_id_foreign` (`category_id`),
  ADD KEY `complaints_client_id_foreign` (`client_id`),
  ADD KEY `complaints_assignee_id_foreign` (`assignee_id`),
  ADD KEY `complaints_department_id_foreign` (`department_id`),
  ADD KEY `complaints_escalated_to_id_foreign` (`escalated_to_id`),
  ADD KEY `complaints_capa_id_foreign` (`capa_id`);

--
-- Indexes for table `complaint_categories`
--
ALTER TABLE `complaint_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `complaint_updates`
--
ALTER TABLE `complaint_updates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `complaint_updates_complaint_id_foreign` (`complaint_id`),
  ADD KEY `complaint_updates_user_id_foreign` (`user_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `departments_code_unique` (`code`),
  ADD KEY `departments_head_user_id_foreign` (`head_user_id`);

--
-- Indexes for table `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `documents_document_no_unique` (`document_no`),
  ADD KEY `documents_category_id_foreign` (`category_id`),
  ADD KEY `documents_owner_id_foreign` (`owner_id`),
  ADD KEY `documents_reviewer_id_foreign` (`reviewer_id`),
  ADD KEY `documents_approver_id_foreign` (`approver_id`),
  ADD KEY `documents_department_id_foreign` (`department_id`);

--
-- Indexes for table `document_access_log`
--
ALTER TABLE `document_access_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `document_access_log_document_id_foreign` (`document_id`),
  ADD KEY `document_access_log_user_id_foreign` (`user_id`);

--
-- Indexes for table `document_access_logs`
--
ALTER TABLE `document_access_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `document_access_logs_document_id_foreign` (`document_id`),
  ADD KEY `document_access_logs_user_id_foreign` (`user_id`);

--
-- Indexes for table `document_categories`
--
ALTER TABLE `document_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `document_categories_code_unique` (`code`),
  ADD KEY `document_categories_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `document_departments`
--
ALTER TABLE `document_departments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `document_departments_document_id_department_id_unique` (`document_id`,`department_id`),
  ADD KEY `document_departments_department_id_foreign` (`department_id`);

--
-- Indexes for table `document_distributions`
--
ALTER TABLE `document_distributions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `document_distributions_document_id_user_id_unique` (`document_id`,`user_id`),
  ADD KEY `document_distributions_user_id_foreign` (`user_id`);

--
-- Indexes for table `document_versions`
--
ALTER TABLE `document_versions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `document_versions_document_id_foreign` (`document_id`),
  ADD KEY `document_versions_changed_by_id_foreign` (`changed_by_id`);

--
-- Indexes for table `email_templates`
--
ALTER TABLE `email_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email_templates_slug_unique` (`slug`);

--
-- Indexes for table `key_results`
--
ALTER TABLE `key_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `key_results_objective_id_foreign` (`objective_id`),
  ADD KEY `key_results_owner_id_foreign` (`owner_id`);

--
-- Indexes for table `kr_check_ins`
--
ALTER TABLE `kr_check_ins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `kr_check_ins_key_result_id_foreign` (`key_result_id`),
  ADD KEY `kr_check_ins_checked_by_id_foreign` (`checked_by_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nc_categories`
--
ALTER TABLE `nc_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nonconformances`
--
ALTER TABLE `nonconformances`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nonconformances_reference_no_unique` (`reference_no`),
  ADD KEY `nonconformances_category_id_foreign` (`category_id`),
  ADD KEY `nonconformances_detected_by_id_foreign` (`detected_by_id`),
  ADD KEY `nonconformances_assigned_to_id_foreign` (`assigned_to_id`),
  ADD KEY `nonconformances_department_id_foreign` (`department_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_user_id_read_at_index` (`user_id`,`read_at`);

--
-- Indexes for table `objectives`
--
ALTER TABLE `objectives`
  ADD PRIMARY KEY (`id`),
  ADD KEY `objectives_owner_id_foreign` (`owner_id`),
  ADD KEY `objectives_department_id_foreign` (`department_id`),
  ADD KEY `objectives_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `partnerships`
--
ALTER TABLE `partnerships`
  ADD PRIMARY KEY (`id`),
  ADD KEY `partnerships_vendor_id_foreign` (`vendor_id`),
  ADD KEY `partnerships_client_id_foreign` (`client_id`),
  ADD KEY `partnerships_owner_id_foreign` (`owner_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `requests`
--
ALTER TABLE `requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `requests_reference_no_unique` (`reference_no`),
  ADD KEY `requests_category_id_foreign` (`category_id`),
  ADD KEY `requests_requester_id_foreign` (`requester_id`),
  ADD KEY `requests_assignee_id_foreign` (`assignee_id`),
  ADD KEY `requests_department_id_foreign` (`department_id`),
  ADD KEY `requests_approved_by_foreign` (`approved_by`),
  ADD KEY `requests_closed_by_foreign` (`closed_by`),
  ADD KEY `requests_status_updated_by_foreign` (`status_updated_by`),
  ADD KEY `idx_requests_risk_level` (`risk_level`),
  ADD KEY `idx_requests_sub_type` (`request_sub_type`),
  ADD KEY `idx_requests_acknowledged_at` (`acknowledged_at`),
  ADD KEY `idx_requests_completed_at` (`completed_at`);

--
-- Indexes for table `request_approvals`
--
ALTER TABLE `request_approvals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `request_approvals_request_id_foreign` (`request_id`),
  ADD KEY `request_approvals_approver_id_foreign` (`approver_id`);

--
-- Indexes for table `request_categories`
--
ALTER TABLE `request_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `request_comments`
--
ALTER TABLE `request_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `request_comments_request_id_foreign` (`request_id`),
  ADD KEY `request_comments_user_id_foreign` (`user_id`);

--
-- Indexes for table `risks`
--
ALTER TABLE `risks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `risks_reference_no_unique` (`reference_no`),
  ADD KEY `risks_category_id_foreign` (`category_id`),
  ADD KEY `risks_owner_id_foreign` (`owner_id`),
  ADD KEY `risks_department_id_foreign` (`department_id`);

--
-- Indexes for table `risk_categories`
--
ALTER TABLE `risk_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `risk_controls`
--
ALTER TABLE `risk_controls`
  ADD PRIMARY KEY (`id`),
  ADD KEY `risk_controls_risk_id_foreign` (`risk_id`),
  ADD KEY `risk_controls_owner_id_foreign` (`owner_id`);

--
-- Indexes for table `risk_reviews`
--
ALTER TABLE `risk_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `risk_reviews_risk_id_foreign` (`risk_id`),
  ADD KEY `risk_reviews_reviewed_by_id_foreign` (`reviewed_by_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_unique` (`name`),
  ADD UNIQUE KEY `roles_slug_unique` (`slug`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `sla_definitions`
--
ALTER TABLE `sla_definitions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sla_definitions_client_id_foreign` (`client_id`),
  ADD KEY `sla_definitions_department_id_foreign` (`department_id`);

--
-- Indexes for table `sla_measurements`
--
ALTER TABLE `sla_measurements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sla_measurements_sla_id_foreign` (`sla_id`),
  ADD KEY `sla_measurements_metric_id_foreign` (`metric_id`),
  ADD KEY `sla_measurements_recorded_by_id_foreign` (`recorded_by_id`);

--
-- Indexes for table `sla_metrics`
--
ALTER TABLE `sla_metrics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sla_metrics_sla_id_foreign` (`sla_id`);

--
-- Indexes for table `surveys`
--
ALTER TABLE `surveys`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `surveys_reference_no_unique` (`reference_no`),
  ADD KEY `surveys_created_by_id_foreign` (`created_by_id`),
  ADD KEY `surveys_department_id_foreign` (`department_id`);

--
-- Indexes for table `survey_answers`
--
ALTER TABLE `survey_answers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `survey_answers_response_id_foreign` (`response_id`),
  ADD KEY `survey_answers_question_id_foreign` (`question_id`);

--
-- Indexes for table `survey_questions`
--
ALTER TABLE `survey_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `survey_questions_survey_id_foreign` (`survey_id`);

--
-- Indexes for table `survey_responses`
--
ALTER TABLE `survey_responses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `survey_responses_token_unique` (`token`),
  ADD KEY `survey_responses_survey_id_foreign` (`survey_id`),
  ADD KEY `survey_responses_client_id_foreign` (`client_id`),
  ADD KEY `survey_responses_user_id_foreign` (`user_id`);

--
-- Indexes for table `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `system_settings_key_unique` (`key`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_role_id_foreign` (`role_id`),
  ADD KEY `users_department_id_foreign` (`department_id`);

--
-- Indexes for table `vendors`
--
ALTER TABLE `vendors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `vendors_code_unique` (`code`),
  ADD KEY `vendors_category_id_foreign` (`category_id`),
  ADD KEY `vendors_account_manager_id_foreign` (`account_manager_id`);

--
-- Indexes for table `vendor_categories`
--
ALTER TABLE `vendor_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vendor_contracts`
--
ALTER TABLE `vendor_contracts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `vendor_contracts_contract_no_unique` (`contract_no`),
  ADD KEY `vendor_contracts_vendor_id_foreign` (`vendor_id`),
  ADD KEY `vendor_contracts_owner_id_foreign` (`owner_id`);

--
-- Indexes for table `vendor_evaluations`
--
ALTER TABLE `vendor_evaluations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vendor_evaluations_vendor_id_foreign` (`vendor_id`),
  ADD KEY `vendor_evaluations_evaluated_by_id_foreign` (`evaluated_by_id`);

--
-- Indexes for table `visits`
--
ALTER TABLE `visits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `visits_reference_no_unique` (`reference_no`),
  ADD KEY `visits_client_id_foreign` (`client_id`),
  ADD KEY `visits_host_id_foreign` (`host_id`);

--
-- Indexes for table `visit_findings`
--
ALTER TABLE `visit_findings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `visit_findings_visit_id_foreign` (`visit_id`),
  ADD KEY `visit_findings_responsible_id_foreign` (`responsible_id`);

--
-- Indexes for table `visit_participants`
--
ALTER TABLE `visit_participants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `visit_participants_visit_id_foreign` (`visit_id`),
  ADD KEY `visit_participants_user_id_foreign` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `audits`
--
ALTER TABLE `audits`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `audit_checklists`
--
ALTER TABLE `audit_checklists`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `audit_findings`
--
ALTER TABLE `audit_findings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `audit_programs`
--
ALTER TABLE `audit_programs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `audit_team`
--
ALTER TABLE `audit_team`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `capas`
--
ALTER TABLE `capas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `capa_tasks`
--
ALTER TABLE `capa_tasks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `clients`
--
ALTER TABLE `clients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=306;

--
-- AUTO_INCREMENT for table `complaints`
--
ALTER TABLE `complaints`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `complaint_categories`
--
ALTER TABLE `complaint_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `complaint_updates`
--
ALTER TABLE `complaint_updates`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `documents`
--
ALTER TABLE `documents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=492;

--
-- AUTO_INCREMENT for table `document_access_log`
--
ALTER TABLE `document_access_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `document_access_logs`
--
ALTER TABLE `document_access_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `document_categories`
--
ALTER TABLE `document_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `document_departments`
--
ALTER TABLE `document_departments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1576;

--
-- AUTO_INCREMENT for table `document_distributions`
--
ALTER TABLE `document_distributions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `document_versions`
--
ALTER TABLE `document_versions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5077;

--
-- AUTO_INCREMENT for table `email_templates`
--
ALTER TABLE `email_templates`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `key_results`
--
ALTER TABLE `key_results`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kr_check_ins`
--
ALTER TABLE `kr_check_ins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `nc_categories`
--
ALTER TABLE `nc_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `nonconformances`
--
ALTER TABLE `nonconformances`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `objectives`
--
ALTER TABLE `objectives`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `partnerships`
--
ALTER TABLE `partnerships`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=263;

--
-- AUTO_INCREMENT for table `requests`
--
ALTER TABLE `requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `request_approvals`
--
ALTER TABLE `request_approvals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `request_categories`
--
ALTER TABLE `request_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `request_comments`
--
ALTER TABLE `request_comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `risks`
--
ALTER TABLE `risks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `risk_categories`
--
ALTER TABLE `risk_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `risk_controls`
--
ALTER TABLE `risk_controls`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `risk_reviews`
--
ALTER TABLE `risk_reviews`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `sla_definitions`
--
ALTER TABLE `sla_definitions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sla_measurements`
--
ALTER TABLE `sla_measurements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sla_metrics`
--
ALTER TABLE `sla_metrics`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `surveys`
--
ALTER TABLE `surveys`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `survey_answers`
--
ALTER TABLE `survey_answers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `survey_questions`
--
ALTER TABLE `survey_questions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `survey_responses`
--
ALTER TABLE `survey_responses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `vendors`
--
ALTER TABLE `vendors`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `vendor_categories`
--
ALTER TABLE `vendor_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `vendor_contracts`
--
ALTER TABLE `vendor_contracts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `vendor_evaluations`
--
ALTER TABLE `vendor_evaluations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `visits`
--
ALTER TABLE `visits`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `visit_findings`
--
ALTER TABLE `visit_findings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `visit_participants`
--
ALTER TABLE `visit_participants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `audits`
--
ALTER TABLE `audits`
  ADD CONSTRAINT `audits_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  ADD CONSTRAINT `audits_lead_auditor_id_foreign` FOREIGN KEY (`lead_auditor_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `audits_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `audit_programs` (`id`);

--
-- Constraints for table `audit_checklists`
--
ALTER TABLE `audit_checklists`
  ADD CONSTRAINT `audit_checklists_audit_id_foreign` FOREIGN KEY (`audit_id`) REFERENCES `audits` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `audit_findings`
--
ALTER TABLE `audit_findings`
  ADD CONSTRAINT `audit_findings_assignee_id_foreign` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `audit_findings_audit_id_foreign` FOREIGN KEY (`audit_id`) REFERENCES `audits` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `audit_findings_capa_id_foreign` FOREIGN KEY (`capa_id`) REFERENCES `capas` (`id`),
  ADD CONSTRAINT `audit_findings_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`);

--
-- Constraints for table `audit_programs`
--
ALTER TABLE `audit_programs`
  ADD CONSTRAINT `audit_programs_created_by_id_foreign` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `audit_team`
--
ALTER TABLE `audit_team`
  ADD CONSTRAINT `audit_team_audit_id_foreign` FOREIGN KEY (`audit_id`) REFERENCES `audits` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `audit_team_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `capas`
--
ALTER TABLE `capas`
  ADD CONSTRAINT `capas_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  ADD CONSTRAINT `capas_effectiveness_verified_by_id_foreign` FOREIGN KEY (`effectiveness_verified_by_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `capas_nc_id_foreign` FOREIGN KEY (`nc_id`) REFERENCES `nonconformances` (`id`),
  ADD CONSTRAINT `capas_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `capa_tasks`
--
ALTER TABLE `capa_tasks`
  ADD CONSTRAINT `capa_tasks_capa_id_foreign` FOREIGN KEY (`capa_id`) REFERENCES `capas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `capa_tasks_responsible_id_foreign` FOREIGN KEY (`responsible_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `clients_account_manager_id_foreign` FOREIGN KEY (`account_manager_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `complaints`
--
ALTER TABLE `complaints`
  ADD CONSTRAINT `complaints_assignee_id_foreign` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `complaints_capa_id_foreign` FOREIGN KEY (`capa_id`) REFERENCES `capas` (`id`),
  ADD CONSTRAINT `complaints_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `complaint_categories` (`id`),
  ADD CONSTRAINT `complaints_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `complaints_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  ADD CONSTRAINT `complaints_escalated_to_id_foreign` FOREIGN KEY (`escalated_to_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `complaint_updates`
--
ALTER TABLE `complaint_updates`
  ADD CONSTRAINT `complaint_updates_complaint_id_foreign` FOREIGN KEY (`complaint_id`) REFERENCES `complaints` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `complaint_updates_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `departments_head_user_id_foreign` FOREIGN KEY (`head_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `documents`
--
ALTER TABLE `documents`
  ADD CONSTRAINT `documents_approver_id_foreign` FOREIGN KEY (`approver_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `documents_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `document_categories` (`id`),
  ADD CONSTRAINT `documents_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  ADD CONSTRAINT `documents_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `documents_reviewer_id_foreign` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `document_access_log`
--
ALTER TABLE `document_access_log`
  ADD CONSTRAINT `document_access_log_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`),
  ADD CONSTRAINT `document_access_log_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `document_access_logs`
--
ALTER TABLE `document_access_logs`
  ADD CONSTRAINT `document_access_logs_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `document_access_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `document_categories`
--
ALTER TABLE `document_categories`
  ADD CONSTRAINT `document_categories_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `document_categories` (`id`);

--
-- Constraints for table `document_departments`
--
ALTER TABLE `document_departments`
  ADD CONSTRAINT `document_departments_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `document_departments_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `document_distributions`
--
ALTER TABLE `document_distributions`
  ADD CONSTRAINT `document_distributions_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`),
  ADD CONSTRAINT `document_distributions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `document_versions`
--
ALTER TABLE `document_versions`
  ADD CONSTRAINT `document_versions_changed_by_id_foreign` FOREIGN KEY (`changed_by_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `document_versions_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `key_results`
--
ALTER TABLE `key_results`
  ADD CONSTRAINT `key_results_objective_id_foreign` FOREIGN KEY (`objective_id`) REFERENCES `objectives` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `key_results_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `kr_check_ins`
--
ALTER TABLE `kr_check_ins`
  ADD CONSTRAINT `kr_check_ins_checked_by_id_foreign` FOREIGN KEY (`checked_by_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `kr_check_ins_key_result_id_foreign` FOREIGN KEY (`key_result_id`) REFERENCES `key_results` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `nonconformances`
--
ALTER TABLE `nonconformances`
  ADD CONSTRAINT `nonconformances_assigned_to_id_foreign` FOREIGN KEY (`assigned_to_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `nonconformances_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `nc_categories` (`id`),
  ADD CONSTRAINT `nonconformances_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  ADD CONSTRAINT `nonconformances_detected_by_id_foreign` FOREIGN KEY (`detected_by_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `objectives`
--
ALTER TABLE `objectives`
  ADD CONSTRAINT `objectives_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  ADD CONSTRAINT `objectives_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `objectives_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `objectives` (`id`);

--
-- Constraints for table `partnerships`
--
ALTER TABLE `partnerships`
  ADD CONSTRAINT `partnerships_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `partnerships_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `partnerships_vendor_id_foreign` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`);

--
-- Constraints for table `requests`
--
ALTER TABLE `requests`
  ADD CONSTRAINT `requests_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `requests_assignee_id_foreign` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `requests_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `request_categories` (`id`),
  ADD CONSTRAINT `requests_closed_by_foreign` FOREIGN KEY (`closed_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `requests_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  ADD CONSTRAINT `requests_requester_id_foreign` FOREIGN KEY (`requester_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `requests_status_updated_by_foreign` FOREIGN KEY (`status_updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `request_approvals`
--
ALTER TABLE `request_approvals`
  ADD CONSTRAINT `request_approvals_approver_id_foreign` FOREIGN KEY (`approver_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `request_approvals_request_id_foreign` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `request_comments`
--
ALTER TABLE `request_comments`
  ADD CONSTRAINT `request_comments_request_id_foreign` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `request_comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `risks`
--
ALTER TABLE `risks`
  ADD CONSTRAINT `risks_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `risk_categories` (`id`),
  ADD CONSTRAINT `risks_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  ADD CONSTRAINT `risks_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `risk_controls`
--
ALTER TABLE `risk_controls`
  ADD CONSTRAINT `risk_controls_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `risk_controls_risk_id_foreign` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `risk_reviews`
--
ALTER TABLE `risk_reviews`
  ADD CONSTRAINT `risk_reviews_reviewed_by_id_foreign` FOREIGN KEY (`reviewed_by_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `risk_reviews_risk_id_foreign` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sla_definitions`
--
ALTER TABLE `sla_definitions`
  ADD CONSTRAINT `sla_definitions_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `sla_definitions_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`);

--
-- Constraints for table `sla_measurements`
--
ALTER TABLE `sla_measurements`
  ADD CONSTRAINT `sla_measurements_metric_id_foreign` FOREIGN KEY (`metric_id`) REFERENCES `sla_metrics` (`id`),
  ADD CONSTRAINT `sla_measurements_recorded_by_id_foreign` FOREIGN KEY (`recorded_by_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `sla_measurements_sla_id_foreign` FOREIGN KEY (`sla_id`) REFERENCES `sla_definitions` (`id`);

--
-- Constraints for table `sla_metrics`
--
ALTER TABLE `sla_metrics`
  ADD CONSTRAINT `sla_metrics_sla_id_foreign` FOREIGN KEY (`sla_id`) REFERENCES `sla_definitions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `surveys`
--
ALTER TABLE `surveys`
  ADD CONSTRAINT `surveys_created_by_id_foreign` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `surveys_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`);

--
-- Constraints for table `survey_answers`
--
ALTER TABLE `survey_answers`
  ADD CONSTRAINT `survey_answers_question_id_foreign` FOREIGN KEY (`question_id`) REFERENCES `survey_questions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `survey_answers_response_id_foreign` FOREIGN KEY (`response_id`) REFERENCES `survey_responses` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `survey_questions`
--
ALTER TABLE `survey_questions`
  ADD CONSTRAINT `survey_questions_survey_id_foreign` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `survey_responses`
--
ALTER TABLE `survey_responses`
  ADD CONSTRAINT `survey_responses_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `survey_responses_survey_id_foreign` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `survey_responses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Constraints for table `vendor_contracts`
--
ALTER TABLE `vendor_contracts`
  ADD CONSTRAINT `vendor_contracts_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `vendor_contracts_vendor_id_foreign` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
