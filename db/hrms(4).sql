-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 12, 2019 at 11:15 AM
-- Server version: 10.1.36-MariaDB
-- PHP Version: 7.0.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hrms`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_calculateEmployeeLeaveBalance` (IN `employeeId` INT(10), IN `leaveTypeId` INT(10))  BEGIN  

          SELECT SUM(number_of_day) AS totalNumberOfDays FROM leave_application WHERE employee_id=employeeId AND leave_type_id=leaveTypeId and status = 2

          AND (approve_date  BETWEEN DATE_FORMAT(NOW(),'%Y-01-01') AND DATE_FORMAT(NOW(),'%Y-12-31'));

         END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DailyAttendance` (IN `input_date` DATE)  BEGIN 

 

select employee.employee_id,employee.photo,CONCAT(COALESCE(employee.first_name,''),' ',COALESCE(employee.last_name,'')) AS fullName,department_name,

                        view_employee_in_out_data.employee_attendance_id,view_employee_in_out_data.finger_print_id,view_employee_in_out_data.date,view_employee_in_out_data.working_time,

                        DATE_FORMAT(view_employee_in_out_data.in_time,'%h:%i %p') AS in_time,DATE_FORMAT(view_employee_in_out_data.out_time,'%h:%i %p') AS out_time, 

		TIME_FORMAT( work_shift.late_count_time, '%H:%i:%s' ) as lateCountTime,

	(SELECT CASE WHEN DATE_FORMAT(MIN(view_employee_in_out_data.in_time),'%H:%i:00')  > lateCountTime

            THEN 'Yes' 

            ELSE 'No' END) AS  ifLate,

 

            (SELECT CASE WHEN TIMEDIFF((DATE_FORMAT(MIN(view_employee_in_out_data.in_time),'%H:%i:%s')),work_shift.late_count_time)  > '0'

            THEN TIMEDIFF((DATE_FORMAT(MIN(view_employee_in_out_data.in_time),'%H:%i:%s')),work_shift.late_count_time) 

            ELSE '00:00:00' END) AS  totalLateTime,

             TIMEDIFF((DATE_FORMAT(work_shift.`end_time`,'%H:%i:%s')),work_shift.`start_time`) AS workingHour

                        from employee

                        inner join view_employee_in_out_data on view_employee_in_out_data.finger_print_id = employee.finger_id

                        inner join department on department.department_id = employee.department_id

JOIN work_shift on work_shift.work_shift_id = employee.work_shift_id

                        where `status`=1 AND `date`=input_date GROUP BY view_employee_in_out_data.finger_print_id ORDER BY employee_attendance_id DESC;

   



 

 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_getEmployeeInfo` (IN `employeeId` INT(10))  BEGIN

	       SELECT employee.*,user.`user_name` FROM employee 

            INNER JOIN `user` ON `user`.`user_id` = employee.`user_id`

            WHERE employee_id = employeeId;

        END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_getHoliday` (IN `fromDate` DATE, IN `toDate` DATE)  BEGIN 

 

SELECT from_date,to_date FROM holiday_details WHERE from_date >= fromDate AND to_date <=toDate;

   



 

 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_getWeeklyHoliday` ()  BEGIN

	        select day_name from  weekly_holiday where status=1;

        END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_monthlyAttendance` (IN `employeeId` INT(10), IN `from_date` DATE, IN `to_date` DATE)  BEGIN 

 

select employee.employee_id,CONCAT(COALESCE(employee.first_name,''),' ',COALESCE(employee.last_name,'')) AS fullName,department_name,

                        view_employee_in_out_data.finger_print_id,view_employee_in_out_data.date,view_employee_in_out_data.working_time,

                        DATE_FORMAT(view_employee_in_out_data.in_time,'%h:%i %p') AS in_time,DATE_FORMAT(view_employee_in_out_data.out_time,'%h:%i %p') AS out_time, 

		TIME_FORMAT( work_shift.late_count_time, '%H:%i:%s' ) as lateCountTime,

	(SELECT CASE WHEN DATE_FORMAT(MIN(view_employee_in_out_data.in_time),'%H:%i:00')  > lateCountTime

            THEN 'Yes' 

            ELSE 'No' END) AS  ifLate,

 

            (SELECT CASE WHEN TIMEDIFF((DATE_FORMAT(MIN(view_employee_in_out_data.in_time),'%H:%i:%s')),work_shift.late_count_time)  > '0'

            THEN TIMEDIFF((DATE_FORMAT(MIN(view_employee_in_out_data.in_time),'%H:%i:%s')),work_shift.late_count_time) 

            ELSE '00:00:00' END) AS  totalLateTime,

             TIMEDIFF((DATE_FORMAT(work_shift.`end_time`,'%H:%i:%s')),work_shift.`start_time`) AS workingHour

                        from employee

                        inner join view_employee_in_out_data on view_employee_in_out_data.finger_print_id = employee.finger_id

                        inner join department on department.department_id = employee.department_id

JOIN work_shift on work_shift.work_shift_id = employee.work_shift_id

                        where `status`=1 

                       AND `date` between from_date and to_date and employee_id=employeeId

                        GROUP BY view_employee_in_out_data.date,view_employee_in_out_data.`finger_print_id`;

   



 

 END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `allowance`
--

CREATE TABLE `allowance` (
  `allowance_id` int(10) UNSIGNED NOT NULL,
  `allowance_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `allowance_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `percentage_of_basic` int(11) NOT NULL,
  `limit_per_month` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `allowance`
--

INSERT INTO `allowance` (`allowance_id`, `allowance_name`, `allowance_type`, `percentage_of_basic`, `limit_per_month`, `created_at`, `updated_at`) VALUES
(1, 'House Rent', 'Percentage', 50, 25000, '2017-12-26 09:07:43', '2017-12-26 09:07:43'),
(2, 'Convince', 'Fixed', 0, 2500, '2017-12-26 09:08:48', '2017-12-26 09:08:48'),
(3, 'Medical Allowance', 'Percentage', 10, 10000, '2017-12-26 09:10:38', '2017-12-26 09:10:38');

-- --------------------------------------------------------

--
-- Table structure for table `bonus_setting`
--

CREATE TABLE `bonus_setting` (
  `bonus_setting_id` int(10) UNSIGNED NOT NULL,
  `festival_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `percentage_of_bonus` int(11) NOT NULL,
  `bonus_type` enum('Gross','Basic') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bonus_setting`
--

INSERT INTO `bonus_setting` (`bonus_setting_id`, `festival_name`, `percentage_of_bonus`, `bonus_type`, `created_at`, `updated_at`) VALUES
(3, 'Eid ul Fitr', 100, 'Basic', '2018-01-14 08:45:00', '2018-01-14 08:45:00'),
(4, 'Eid ul adhz', 100, 'Basic', '2018-01-14 08:45:19', '2018-01-14 08:45:19');

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `branch_id` int(10) UNSIGNED NOT NULL,
  `branch_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`branch_id`, `branch_name`, `created_at`, `updated_at`) VALUES
(2, 'Dhaka Branch', '2017-12-19 05:10:19', '2017-12-19 05:10:19'),
(4, 'Ashulia Branch', '2018-01-03 07:22:10', '2018-12-05 05:13:21');

-- --------------------------------------------------------

--
-- Table structure for table `company_address_settings`
--

CREATE TABLE `company_address_settings` (
  `company_address_setting_id` int(10) UNSIGNED NOT NULL,
  `address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `company_address_settings`
--

INSERT INTO `company_address_settings` (`company_address_setting_id`, `address`, `created_at`, `updated_at`) VALUES
(1, '<div><b>My company Ltd</b><br>My Tower,<br>104/6,Kakrail,Ramna, Dhaka-1000</div><div><a target=\"_blank\" rel=\"nofollow\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</a></div> <br>', '2017-12-26 10:39:05', '2019-09-12 09:10:47');

-- --------------------------------------------------------

--
-- Table structure for table `deduction`
--

CREATE TABLE `deduction` (
  `deduction_id` int(10) UNSIGNED NOT NULL,
  `deduction_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deduction_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `percentage_of_basic` int(11) NOT NULL,
  `limit_per_month` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `deduction`
--

INSERT INTO `deduction` (`deduction_id`, `deduction_name`, `deduction_type`, `percentage_of_basic`, `limit_per_month`, `created_at`, `updated_at`) VALUES
(1, 'Provident Fund', 'Percentage', 3, 0, '2017-12-26 09:15:56', '2018-01-03 10:40:26');

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `department_id` int(10) UNSIGNED NOT NULL,
  `department_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`department_id`, `department_name`, `created_at`, `updated_at`) VALUES
(2, 'Management', '2017-12-19 05:10:20', '2018-12-05 05:13:07'),
(6, 'IT', '2017-12-20 06:46:19', '2017-12-20 06:46:19'),
(7, 'Accounts', '2017-12-26 06:29:06', '2017-12-26 06:29:06'),
(8, 'Human Resource', '2018-01-03 06:48:14', '2018-01-03 06:48:14'),
(10, 'Business Development', '2018-12-05 05:48:14', '2018-12-05 05:48:14'),
(11, 'Equipement Division', '2019-02-05 06:02:38', '2019-09-11 11:44:44');

-- --------------------------------------------------------

--
-- Table structure for table `designation`
--

CREATE TABLE `designation` (
  `designation_id` int(10) UNSIGNED NOT NULL,
  `designation_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `designation`
--

INSERT INTO `designation` (`designation_id`, `designation_name`, `created_at`, `updated_at`) VALUES
(1, 'CEO', '2017-12-19 05:10:20', '2017-12-20 06:54:58'),
(2, 'Admin Manager', '2017-12-19 05:10:20', '2017-12-20 06:56:53'),
(3, 'Sales & Marketing', '2017-12-19 05:10:20', '2017-12-20 07:00:18'),
(4, 'Web Developer', '2017-12-19 05:10:20', '2017-12-20 07:00:33'),
(5, 'IOS Developer', '2017-12-19 05:10:20', '2017-12-20 07:00:55'),
(6, 'Android Developer', '2017-12-20 07:01:52', '2017-12-20 07:01:52'),
(7, 'Designer', '2017-12-20 07:02:21', '2017-12-20 07:02:21'),
(8, 'Office Assistant', '2017-12-20 07:02:59', '2017-12-20 07:02:59'),
(9, 'Driver', '2017-12-20 07:03:21', '2017-12-20 07:03:21'),
(11, 'Sr. Executive', '2018-01-03 06:52:03', '2018-01-03 07:12:15'),
(12, 'Jr. Executive', '2018-01-03 07:11:15', '2018-01-03 07:11:15'),
(15, 'Business Development Executive', '2018-01-03 07:16:49', '2018-01-03 07:16:49'),
(16, 'General Manager', '2018-01-03 07:18:54', '2018-01-03 07:18:54'),
(17, 'Deputy General Manager', '2018-01-03 07:21:13', '2018-01-03 07:21:13'),
(18, 'Head of Accounts', '2018-12-05 05:17:22', '2018-12-05 05:17:22'),
(19, 'Sr Software Engineer', '2018-12-05 05:18:55', '2018-12-05 05:18:55'),
(20, 'Assistent General Manager', '2018-12-05 05:45:53', '2018-12-05 05:45:53'),
(21, 'Manager', '2018-12-05 05:46:14', '2018-12-05 05:46:14'),
(23, 'Managing Director', '2018-12-17 07:46:56', '2018-12-17 07:46:56'),
(24, 'Deputy Managing Director', '2019-02-13 06:19:12', '2019-02-13 06:19:12'),
(25, 'Accountant', '2019-05-02 06:00:16', '2019-05-02 06:00:31'),
(26, 'Assistant Manager', '2019-05-04 10:22:15', '2019-05-04 10:22:15'),
(27, 'Jr accountent', '2019-08-28 03:57:05', '2019-08-28 03:57:05'),
(28, 'Executive Director', '2019-09-05 20:56:29', '2019-09-05 20:56:29');

-- --------------------------------------------------------

--
-- Table structure for table `earn_leave_rule`
--

CREATE TABLE `earn_leave_rule` (
  `earn_leave_rule_id` int(10) UNSIGNED NOT NULL,
  `for_month` int(11) NOT NULL,
  `day_of_earn_leave` double(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `earn_leave_rule`
--

INSERT INTO `earn_leave_rule` (`earn_leave_rule_id`, `for_month`, `day_of_earn_leave`, `created_at`, `updated_at`) VALUES
(1, 1, 1.50, '2017-12-19 05:10:24', '2019-02-06 07:19:57');

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `employee_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `finger_id` int(11) NOT NULL,
  `department_id` int(10) UNSIGNED NOT NULL,
  `designation_id` int(10) UNSIGNED NOT NULL,
  `branch_id` int(10) UNSIGNED DEFAULT NULL,
  `supervisor_id` int(11) DEFAULT NULL,
  `work_shift_id` int(10) UNSIGNED NOT NULL,
  `pay_grade_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `hourly_salaries_id` int(10) UNSIGNED DEFAULT '0',
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_birth` date NOT NULL,
  `date_of_joining` date NOT NULL,
  `date_of_leaving` date DEFAULT NULL,
  `gender` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `religion` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `marital_status` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `emergency_contacts` text COLLATE utf8mb4_unicode_ci,
  `phone` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `permanent_status` tinyint(4) NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`employee_id`, `user_id`, `finger_id`, `department_id`, `designation_id`, `branch_id`, `supervisor_id`, `work_shift_id`, `pay_grade_id`, `hourly_salaries_id`, `email`, `first_name`, `last_name`, `date_of_birth`, `date_of_joining`, `date_of_leaving`, `gender`, `religion`, `marital_status`, `photo`, `address`, `emergency_contacts`, `phone`, `status`, `permanent_status`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(2, 2, 4, 6, 19, 2, 24, 1, 1, NULL, 'jhon@example.com', 'Jhon', 'Doe', '1994-11-13', '2017-01-01', '2019-08-30', 'Male', 'Islam', 'Unmarried', 'default.jpg', NULL, NULL, 1832944234, 1, 1, 23, 23, '2017-12-20 06:24:19', '2019-09-12 09:03:07'),
(16, 16, 26, 11, 15, 2, 24, 1, 1, NULL, NULL, 'Shamim', 'Buiyan', '2000-01-01', '2018-12-01', NULL, 'Male', NULL, 'Unmarried', 'default.jpg', NULL, NULL, 1639128954, 1, 1, 16, 16, '2017-12-20 07:46:26', '2019-05-04 10:07:49'),
(17, 17, 3, 10, 26, 2, 24, 1, 2, NULL, 'suvose1@example.com', 'Shadu', 'Sen', '1991-09-14', '2015-11-01', NULL, 'Male', 'Hindu', 'Unmarried', 'default.jpg', 'Jatrabari,Dhaka', '01737187956', 1700660098, 1, 1, 2, 2, '2017-12-20 07:48:53', '2019-05-04 10:44:06'),
(18, 18, 2, 10, 20, 2, 24, 1, 1, NULL, 'mohammedislon@yoyo.com', 'Mohammed Fokhrul', 'Islam', '1989-01-03', '2015-01-01', '2019-08-30', 'Male', 'Islam', 'Married', 'default.jpg', ', Tolarbag, Mirpur-1, Dhaka-1216', '01700600466', 1766558089, 2, 1, 2, 2, '2017-12-20 07:52:40', '2019-09-03 15:00:58'),
(20, 20, 5, 11, 11, 2, 24, 1, 1, NULL, 'mdyounugmail.com', 'Md', 'Younus', '1994-02-02', '2017-07-01', NULL, 'Male', 'Islam', 'Unmarried', 'default.jpg', 'wapdha Road, West Rampura', '01821333178', 1827233078, 1, 1, 20, 20, '2017-12-20 08:15:02', '2019-05-04 10:45:46'),
(21, 21, 9, 8, 8, 2, NULL, 1, 1, NULL, NULL, 'Monir', 'Hossain', '1970-01-01', '2017-01-01', NULL, 'Male', 'Islam', 'Married', 'default.jpg', NULL, NULL, 1617715278, 1, 1, 2, 2, '2017-12-20 08:17:17', '2018-12-17 08:33:28'),
(22, 22, 24, 8, 8, 2, 24, 1, 0, 1, NULL, 'Rajib', 'Hossain', '2000-01-01', '2018-12-01', NULL, 'Male', NULL, 'Unmarried', NULL, NULL, NULL, 1797185765, 1, 1, 2, 2, '2017-12-20 08:19:24', '2019-09-12 08:36:39'),
(23, 23, 8, 8, 2, 2, 2, 1, 1, NULL, NULL, 'Moutushi', 'Radhuni', '1990-09-30', '2018-11-01', NULL, 'Female', 'Islam', 'Unmarried', 'default.jpg', NULL, NULL, 1789479155, 1, 1, 23, 23, '2017-12-20 08:21:08', '2019-09-12 09:04:08'),
(24, 24, 1, 2, 1, 2, 29, 1, 1, NULL, 'tushar@example.com', 'Tushar', 'Khan', '2000-01-01', '2015-01-04', NULL, 'Female', NULL, 'Married', 'default.jpg', NULL, NULL, 1700600499, 1, 1, 2, 2, '2017-12-20 08:22:44', '2019-02-06 07:24:57'),
(26, 26, 7, 7, 18, 2, 24, 1, 2, NULL, 'polash@example.com', 'Polash', 'Khan', '1989-06-13', '2017-11-01', NULL, 'Male', 'Hindu', 'Married', 'default.jpg', 'Saydabad', '01234567898', 1234567888, 1, 1, 2, 2, '2018-01-03 06:55:17', '2019-02-06 07:24:24'),
(28, 28, 10, 8, 8, 2, 24, 1, 2, NULL, 'raihan@example.com', 'Rayhan', 'Khan', '1997-06-10', '2018-12-29', NULL, 'Male', 'Islam', 'Married', NULL, NULL, NULL, 1698545277, 1, 1, 2, 2, '2018-12-05 11:23:11', '2019-05-02 06:04:27'),
(29, 29, 11, 2, 23, NULL, NULL, 1, 1, NULL, 'jahirul@example.com', 'Jahir', 'Khan', '1980-02-11', '2012-02-06', NULL, 'Male', 'Islam', 'Married', 'default.jpg', NULL, NULL, 1955200689, 1, 1, 2, 2, '2018-12-17 07:53:35', '2019-05-02 06:04:19'),
(30, 30, 12, 2, 24, 2, 29, 1, 1, NULL, 'sohel@example.com', 'Sariful', 'Bahadur', '1989-02-08', '2013-03-03', NULL, 'Male', 'Islam', 'Unmarried', 'default.jpg', 'Santinagar Dhaka', NULL, 1725648899, 1, 1, 2, 2, '2019-02-13 06:26:42', '2019-05-02 06:04:21'),
(31, 31, 30, 7, 11, 2, 26, 1, 2, NULL, NULL, 'Junaed', 'Khan', '1993-12-15', '2019-05-02', '2019-08-18', 'Male', 'Islam', 'Unmarried', NULL, 'Azimpur Government Colony, Dhaka-1205', NULL, 1791919006, 2, 0, 2, 2, '2019-05-02 06:17:26', '2019-08-28 04:00:29'),
(32, 32, 32, 7, 27, 2, 26, 1, 1, NULL, 'mohsin@example.com', 'Mohsin', 'Ahmed', '1992-03-04', '2019-08-01', NULL, 'Male', 'Islam', 'Unmarried', NULL, NULL, NULL, 1717301089, 1, 0, 2, 2, '2019-08-28 03:59:33', '2019-08-28 03:59:33'),
(33, 33, 33, 2, 28, 2, 29, 1, 1, NULL, 'saifur.rahman@example.com', 'Saifur', 'Rahman', '1982-05-14', '2019-09-01', NULL, 'Male', 'Islam', 'Married', NULL, 'Heritage,gulbagh,malibagh,Dhaka.', NULL, 1791696889, 1, 1, 2, 2, '2019-09-05 21:00:24', '2019-09-12 06:50:04');

-- --------------------------------------------------------

--
-- Table structure for table `employee_attendance`
--

CREATE TABLE `employee_attendance` (
  `employee_attendance_id` int(10) UNSIGNED NOT NULL,
  `finger_print_id` int(11) NOT NULL,
  `in_out_time` datetime NOT NULL,
  `check_type` text COLLATE utf8mb4_unicode_ci,
  `verify_code` bigint(20) DEFAULT NULL,
  `sensor_id` text COLLATE utf8mb4_unicode_ci,
  `Memoinfo` text COLLATE utf8mb4_unicode_ci,
  `WorkCode` text COLLATE utf8mb4_unicode_ci,
  `sn` text COLLATE utf8mb4_unicode_ci,
  `UserExtFmt` int(11) DEFAULT NULL,
  `mechine_sl` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `employee_attendance`
--

INSERT INTO `employee_attendance` (`employee_attendance_id`, `finger_print_id`, `in_out_time`, `check_type`, `verify_code`, `sensor_id`, `Memoinfo`, `WorkCode`, `sn`, `UserExtFmt`, `mechine_sl`, `created_at`, `updated_at`) VALUES
(1, 2, '2018-12-17 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-17 09:08:42', '2018-12-17 09:08:42'),
(2, 1, '2018-12-17 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-17 09:08:42', '2018-12-17 09:08:42'),
(3, 11, '2018-12-17 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-17 09:08:42', '2018-12-17 09:08:42'),
(4, 4, '2018-12-17 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-17 09:09:28', '2018-12-17 09:09:28'),
(5, 7, '2018-12-17 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-17 09:10:05', '2018-12-17 09:10:05'),
(13, 5, '2018-12-17 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-17 09:14:44', '2018-12-17 09:14:44'),
(14, 9, '2018-12-17 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-17 09:14:44', '2018-12-17 09:14:44'),
(15, 24, '2018-12-17 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-17 09:14:44', '2018-12-17 09:14:44'),
(16, 8, '2018-12-17 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-17 09:14:44', '2018-12-17 09:14:44'),
(17, 10, '2018-12-17 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-17 09:14:44', '2018-12-17 09:14:44'),
(20, 26, '2018-12-17 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-17 09:15:37', '2018-12-17 09:15:37'),
(21, 3, '2018-12-17 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-17 09:15:37', '2018-12-17 09:15:37'),
(39, 2, '2018-12-18 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 04:50:39', '2018-12-19 04:50:39'),
(40, 2, '2018-12-18 19:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 04:50:39', '2018-12-19 04:50:39'),
(41, 1, '2018-12-18 11:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 04:50:39', '2018-12-19 04:50:39'),
(42, 1, '2018-12-18 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 04:50:39', '2018-12-19 04:50:39'),
(43, 4, '2018-12-18 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 04:52:44', '2018-12-19 04:52:44'),
(44, 4, '2018-12-18 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 04:52:44', '2018-12-19 04:52:44'),
(45, 7, '2018-12-18 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 04:54:03', '2018-12-19 04:54:03'),
(46, 7, '2018-12-18 18:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 04:54:03', '2018-12-19 04:54:03'),
(49, 887, '2018-12-18 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 05:00:24', '2018-12-19 05:00:24'),
(50, 887, '2018-12-18 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 05:00:24', '2018-12-19 05:00:24'),
(55, 13, '2018-12-18 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 05:07:21', '2018-12-19 05:07:21'),
(56, 13, '2018-12-18 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 05:07:21', '2018-12-19 05:07:21'),
(58, 13, '2018-12-19 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 05:09:33', '2018-12-19 05:09:33'),
(68, 26, '2018-12-18 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 05:15:17', '2018-12-19 05:15:17'),
(69, 26, '2018-12-18 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 05:15:17', '2018-12-19 05:15:17'),
(70, 3, '2018-12-18 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 05:15:17', '2018-12-19 05:15:17'),
(95, 5, '2018-12-18 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 07:04:19', '2018-12-19 07:04:19'),
(96, 5, '2018-12-18 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 07:04:19', '2018-12-19 07:04:19'),
(97, 9, '2018-12-18 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 07:04:19', '2018-12-19 07:04:19'),
(98, 9, '2018-12-18 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 07:04:19', '2018-12-19 07:04:19'),
(99, 24, '2018-12-18 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 07:04:19', '2018-12-19 07:04:19'),
(100, 24, '2018-12-18 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 07:04:19', '2018-12-19 07:04:19'),
(101, 8, '2018-12-18 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 07:04:19', '2018-12-19 07:04:19'),
(102, 8, '2018-12-18 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 07:04:19', '2018-12-19 07:04:19'),
(103, 10, '2018-12-18 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 07:04:19', '2018-12-19 07:04:19'),
(104, 10, '2018-12-18 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-19 07:04:19', '2018-12-19 07:04:19'),
(113, 2, '2018-12-19 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:38:51', '2018-12-20 04:38:51'),
(114, 2, '2018-12-19 18:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:38:51', '2018-12-20 04:38:51'),
(115, 1, '2018-12-19 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:38:51', '2018-12-20 04:38:51'),
(116, 1, '2018-12-19 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:38:51', '2018-12-20 04:38:51'),
(117, 4, '2018-12-19 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:39:53', '2018-12-20 04:39:53'),
(118, 4, '2018-12-19 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:39:53', '2018-12-20 04:39:53'),
(119, 7, '2018-12-19 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:41:53', '2018-12-20 04:41:53'),
(120, 7, '2018-12-19 17:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:41:53', '2018-12-20 04:41:53'),
(121, 5, '2018-12-19 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:45:40', '2018-12-20 04:45:40'),
(122, 5, '2018-12-19 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:45:40', '2018-12-20 04:45:40'),
(123, 9, '2018-12-19 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:45:40', '2018-12-20 04:45:40'),
(124, 9, '2018-12-19 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:45:40', '2018-12-20 04:45:40'),
(125, 24, '2018-12-19 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:45:40', '2018-12-20 04:45:40'),
(126, 24, '2018-12-19 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:45:40', '2018-12-20 04:45:40'),
(127, 8, '2018-12-19 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:45:40', '2018-12-20 04:45:40'),
(128, 8, '2018-12-19 18:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:45:40', '2018-12-20 04:45:40'),
(129, 10, '2018-12-19 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:45:40', '2018-12-20 04:45:40'),
(130, 10, '2018-12-19 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:45:40', '2018-12-20 04:45:40'),
(131, 26, '2018-12-19 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:46:58', '2018-12-20 04:46:58'),
(132, 26, '2018-12-19 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:46:58', '2018-12-20 04:46:58'),
(133, 3, '2018-12-19 11:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:46:58', '2018-12-20 04:46:58'),
(134, 3, '2018-12-19 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-20 04:46:58', '2018-12-20 04:46:58'),
(143, 2, '2018-12-20 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:32:54', '2018-12-22 04:32:54'),
(144, 2, '2018-12-20 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:32:54', '2018-12-22 04:32:54'),
(145, 1, '2018-12-20 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:32:54', '2018-12-22 04:32:54'),
(146, 1, '2018-12-20 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:32:54', '2018-12-22 04:32:54'),
(147, 4, '2018-12-20 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:34:20', '2018-12-22 04:34:20'),
(148, 4, '2018-12-20 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:34:20', '2018-12-22 04:34:20'),
(149, 7, '2018-12-20 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:35:50', '2018-12-22 04:35:50'),
(150, 7, '2018-12-20 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:35:50', '2018-12-22 04:35:50'),
(151, 5, '2018-12-20 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:37:39', '2018-12-22 04:37:39'),
(152, 5, '2018-12-20 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:37:39', '2018-12-22 04:37:39'),
(153, 9, '2018-12-20 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:37:39', '2018-12-22 04:37:39'),
(154, 9, '2018-12-20 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:37:39', '2018-12-22 04:37:39'),
(155, 24, '2018-12-20 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:37:39', '2018-12-22 04:37:39'),
(156, 24, '2018-12-20 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:37:39', '2018-12-22 04:37:39'),
(157, 8, '2018-12-20 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:37:39', '2018-12-22 04:37:39'),
(158, 8, '2018-12-20 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:37:39', '2018-12-22 04:37:39'),
(159, 10, '2018-12-20 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:37:39', '2018-12-22 04:37:39'),
(160, 10, '2018-12-20 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:37:39', '2018-12-22 04:37:39'),
(161, 26, '2018-12-20 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:38:43', '2018-12-22 04:38:43'),
(162, 26, '2018-12-20 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:38:43', '2018-12-22 04:38:43'),
(163, 3, '2018-12-20 11:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:38:43', '2018-12-22 04:38:43'),
(164, 3, '2018-12-20 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-22 04:38:43', '2018-12-22 04:38:43'),
(176, 1, '2018-12-22 10:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:28:17', '2018-12-23 05:28:17'),
(177, 1, '2018-12-22 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:28:17', '2018-12-23 05:28:17'),
(178, 4, '2018-12-22 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:29:08', '2018-12-23 05:29:08'),
(179, 4, '2018-12-22 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:29:08', '2018-12-23 05:29:08'),
(180, 7, '2018-12-22 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:29:44', '2018-12-23 05:29:44'),
(181, 7, '2018-12-22 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:29:44', '2018-12-23 05:29:44'),
(182, 5, '2018-12-22 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:31:29', '2018-12-23 05:31:29'),
(183, 5, '2018-12-22 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:31:29', '2018-12-23 05:31:29'),
(184, 9, '2018-12-22 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:31:29', '2018-12-23 05:31:29'),
(185, 9, '2018-12-22 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:31:29', '2018-12-23 05:31:29'),
(186, 24, '2018-12-22 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:31:29', '2018-12-23 05:31:29'),
(187, 24, '2018-12-22 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:31:29', '2018-12-23 05:31:29'),
(188, 8, '2018-12-22 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:31:29', '2018-12-23 05:31:29'),
(189, 8, '2018-12-22 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:31:29', '2018-12-23 05:31:29'),
(190, 10, '2018-12-22 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:31:29', '2018-12-23 05:31:29'),
(191, 10, '2018-12-22 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:31:29', '2018-12-23 05:31:29'),
(192, 26, '2018-12-22 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:32:13', '2018-12-23 05:32:13'),
(193, 26, '2018-12-22 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:32:13', '2018-12-23 05:32:13'),
(194, 3, '2018-12-22 11:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:32:13', '2018-12-23 05:32:13'),
(195, 3, '2018-12-22 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-23 05:32:13', '2018-12-23 05:32:13'),
(216, 2, '2018-12-23 11:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:04:02', '2018-12-24 05:04:02'),
(217, 2, '2018-12-23 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:04:02', '2018-12-24 05:04:02'),
(218, 1, '2018-12-23 11:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:04:02', '2018-12-24 05:04:02'),
(219, 1, '2018-12-23 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:04:02', '2018-12-24 05:04:02'),
(220, 4, '2018-12-23 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:04:44', '2018-12-24 05:04:44'),
(221, 4, '2018-12-23 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:04:44', '2018-12-24 05:04:44'),
(222, 7, '2018-12-23 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:06:24', '2018-12-24 05:06:24'),
(223, 7, '2018-12-23 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:06:24', '2018-12-24 05:06:24'),
(224, 5, '2018-12-23 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:08:18', '2018-12-24 05:08:18'),
(225, 5, '2018-12-23 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:08:18', '2018-12-24 05:08:18'),
(226, 9, '2018-12-23 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:08:18', '2018-12-24 05:08:18'),
(227, 9, '2018-12-23 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:08:18', '2018-12-24 05:08:18'),
(228, 24, '2018-12-23 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:08:18', '2018-12-24 05:08:18'),
(229, 24, '2018-12-23 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:08:18', '2018-12-24 05:08:18'),
(230, 8, '2018-12-23 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:08:18', '2018-12-24 05:08:18'),
(231, 8, '2018-12-23 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:08:18', '2018-12-24 05:08:18'),
(232, 10, '2018-12-23 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:08:18', '2018-12-24 05:08:18'),
(233, 10, '2018-12-23 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:08:18', '2018-12-24 05:08:18'),
(234, 26, '2018-12-23 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:09:24', '2018-12-24 05:09:24'),
(235, 26, '2018-12-23 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:09:24', '2018-12-24 05:09:24'),
(236, 3, '2018-12-23 11:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:09:24', '2018-12-24 05:09:24'),
(237, 3, '2018-12-23 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 05:09:24', '2018-12-24 05:09:24'),
(250, 2, '2018-12-01 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 06:50:10', '2018-12-24 06:50:10'),
(251, 2, '2018-12-01 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 06:50:10', '2018-12-24 06:50:10'),
(252, 1, '2018-12-01 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 06:50:10', '2018-12-24 06:50:10'),
(253, 1, '2018-12-01 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 06:50:10', '2018-12-24 06:50:10'),
(254, 4, '2018-12-01 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 06:52:16', '2018-12-24 06:52:16'),
(255, 4, '2018-12-01 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 06:52:16', '2018-12-24 06:52:16'),
(256, 9, '2018-12-01 09:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 06:56:29', '2018-12-24 06:56:29'),
(257, 9, '2018-12-01 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 06:56:29', '2018-12-24 06:56:29'),
(258, 8, '2018-12-01 09:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 06:56:29', '2018-12-24 06:56:29'),
(259, 8, '2018-12-01 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 06:56:29', '2018-12-24 06:56:29'),
(260, 10, '2018-12-01 09:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 06:56:29', '2018-12-24 06:56:29'),
(261, 10, '2018-12-01 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 06:56:29', '2018-12-24 06:56:29'),
(262, 26, '2018-12-01 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 07:04:25', '2018-12-24 07:04:25'),
(263, 26, '2018-12-01 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 07:04:25', '2018-12-24 07:04:25'),
(264, 3, '2018-12-01 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 07:04:25', '2018-12-24 07:04:25'),
(265, 3, '2018-12-01 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 07:04:25', '2018-12-24 07:04:25'),
(266, 5, '2018-12-01 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 07:04:25', '2018-12-24 07:04:25'),
(267, 5, '2018-12-01 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-24 07:04:25', '2018-12-24 07:04:25'),
(268, 2, '2018-12-24 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:46:43', '2018-12-26 04:46:43'),
(269, 2, '2018-12-24 21:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:46:43', '2018-12-26 04:46:43'),
(270, 1, '2018-12-24 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:46:43', '2018-12-26 04:46:43'),
(271, 1, '2018-12-24 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:46:43', '2018-12-26 04:46:43'),
(272, 4, '2018-12-24 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:47:26', '2018-12-26 04:47:26'),
(273, 4, '2018-12-24 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:47:26', '2018-12-26 04:47:26'),
(274, 7, '2018-12-24 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:49:09', '2018-12-26 04:49:09'),
(275, 7, '2018-12-24 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:49:09', '2018-12-26 04:49:09'),
(276, 9, '2018-12-24 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:53:11', '2018-12-26 04:53:11'),
(277, 9, '2018-12-24 18:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:53:11', '2018-12-26 04:53:11'),
(278, 24, '2018-12-24 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:53:11', '2018-12-26 04:53:11'),
(279, 24, '2018-12-24 21:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:53:11', '2018-12-26 04:53:11'),
(280, 8, '2018-12-24 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:53:11', '2018-12-26 04:53:11'),
(281, 8, '2018-12-24 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:53:11', '2018-12-26 04:53:11'),
(282, 10, '2018-12-24 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:53:11', '2018-12-26 04:53:11'),
(283, 10, '2018-12-24 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:53:11', '2018-12-26 04:53:11'),
(284, 26, '2018-12-24 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:54:57', '2018-12-26 04:54:57'),
(285, 26, '2018-12-24 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:54:57', '2018-12-26 04:54:57'),
(286, 3, '2018-12-24 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:54:57', '2018-12-26 04:54:57'),
(287, 3, '2018-12-24 20:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:54:57', '2018-12-26 04:54:57'),
(288, 5, '2018-12-24 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:54:57', '2018-12-26 04:54:57'),
(289, 5, '2018-12-24 21:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-26 04:54:57', '2018-12-26 04:54:57'),
(299, 2, '2018-12-26 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:48:46', '2018-12-27 04:48:46'),
(300, 2, '2018-12-26 19:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:48:46', '2018-12-27 04:48:46'),
(301, 1, '2018-12-26 10:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:48:46', '2018-12-27 04:48:46'),
(302, 1, '2018-12-26 19:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:48:46', '2018-12-27 04:48:46'),
(303, 4, '2018-12-26 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:49:29', '2018-12-27 04:49:29'),
(304, 4, '2018-12-26 18:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:49:29', '2018-12-27 04:49:29'),
(305, 7, '2018-12-26 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:50:17', '2018-12-27 04:50:17'),
(306, 7, '2018-12-26 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:50:17', '2018-12-27 04:50:17'),
(307, 9, '2018-12-26 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:51:38', '2018-12-27 04:51:38'),
(308, 9, '2018-12-26 19:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:51:38', '2018-12-27 04:51:38'),
(309, 24, '2018-12-26 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:51:38', '2018-12-27 04:51:38'),
(310, 24, '2018-12-26 19:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:51:38', '2018-12-27 04:51:38'),
(311, 8, '2018-12-26 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:51:38', '2018-12-27 04:51:38'),
(312, 8, '2018-12-26 18:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:51:38', '2018-12-27 04:51:38'),
(313, 10, '2018-12-26 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:51:38', '2018-12-27 04:51:38'),
(314, 10, '2018-12-26 19:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:51:38', '2018-12-27 04:51:38'),
(315, 26, '2018-12-26 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:52:57', '2018-12-27 04:52:57'),
(316, 26, '2018-12-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:52:57', '2018-12-27 04:52:57'),
(317, 3, '2018-12-26 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:52:57', '2018-12-27 04:52:57'),
(318, 3, '2018-12-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:52:57', '2018-12-27 04:52:57'),
(319, 5, '2018-12-26 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:52:57', '2018-12-27 04:52:57'),
(320, 5, '2018-12-26 19:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-27 04:52:57', '2018-12-27 04:52:57'),
(334, 2, '2018-12-27 10:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:34:45', '2018-12-31 06:34:45'),
(335, 2, '2018-12-27 17:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:34:45', '2018-12-31 06:34:45'),
(336, 1, '2018-12-27 10:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:34:45', '2018-12-31 06:34:45'),
(337, 1, '2018-12-27 17:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:34:45', '2018-12-31 06:34:45'),
(338, 4, '2018-12-27 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:39:19', '2018-12-31 06:39:19'),
(339, 4, '2018-12-27 17:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:39:19', '2018-12-31 06:39:19'),
(340, 7, '2018-12-27 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:39:47', '2018-12-31 06:39:47'),
(341, 7, '2018-12-27 17:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:39:47', '2018-12-31 06:39:47'),
(342, 9, '2018-12-27 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:40:42', '2018-12-31 06:40:42'),
(343, 9, '2018-12-27 17:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:40:42', '2018-12-31 06:40:42'),
(344, 24, '2018-12-27 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:40:42', '2018-12-31 06:40:42'),
(345, 24, '2018-12-27 17:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:40:42', '2018-12-31 06:40:42'),
(346, 8, '2018-12-27 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:40:42', '2018-12-31 06:40:42'),
(347, 8, '2018-12-27 05:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:40:42', '2018-12-31 06:40:42'),
(348, 10, '2018-12-27 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:40:42', '2018-12-31 06:40:42'),
(349, 10, '2018-12-27 05:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:40:42', '2018-12-31 06:40:42'),
(350, 26, '2018-12-27 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:41:52', '2018-12-31 06:41:52'),
(351, 26, '2018-12-27 17:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:41:52', '2018-12-31 06:41:52'),
(352, 3, '2018-12-27 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:41:52', '2018-12-31 06:41:52'),
(353, 3, '2018-12-27 17:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:41:52', '2018-12-31 06:41:52'),
(354, 5, '2018-12-27 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:41:52', '2018-12-31 06:41:52'),
(355, 5, '2018-12-27 17:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-31 06:41:52', '2018-12-31 06:41:52'),
(364, 2, '2018-12-31 10:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:51:13', '2019-01-01 04:51:13'),
(365, 2, '2018-12-31 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:51:13', '2019-01-01 04:51:13'),
(366, 1, '2018-12-31 10:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:51:13', '2019-01-01 04:51:13'),
(367, 1, '2018-12-31 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:51:13', '2019-01-01 04:51:13'),
(368, 4, '2018-12-31 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:51:44', '2019-01-01 04:51:44'),
(369, 4, '2018-12-31 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:51:44', '2019-01-01 04:51:44'),
(370, 7, '2018-12-31 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:52:44', '2019-01-01 04:52:44'),
(371, 7, '2018-12-31 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:52:44', '2019-01-01 04:52:44'),
(372, 24, '2018-12-31 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:53:48', '2019-01-01 04:53:48'),
(373, 24, '2018-12-31 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:53:48', '2019-01-01 04:53:48'),
(374, 8, '2018-12-31 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:53:48', '2019-01-01 04:53:48'),
(375, 8, '2018-12-31 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:53:48', '2019-01-01 04:53:48'),
(376, 10, '2018-12-31 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:53:48', '2019-01-01 04:53:48'),
(377, 10, '2018-12-31 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:53:48', '2019-01-01 04:53:48'),
(378, 3, '2018-12-31 11:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:54:24', '2019-01-01 04:54:24'),
(379, 3, '2018-12-31 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-01 04:54:24', '2019-01-01 04:54:24'),
(392, 2, '2019-01-01 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:12:58', '2019-01-02 05:12:58'),
(393, 2, '2019-01-01 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:12:58', '2019-01-02 05:12:58'),
(394, 1, '2019-01-01 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:12:58', '2019-01-02 05:12:58'),
(395, 1, '2019-01-01 16:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:12:58', '2019-01-02 05:12:58'),
(396, 4, '2019-01-01 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:13:55', '2019-01-02 05:13:55'),
(397, 4, '2019-01-01 17:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:13:55', '2019-01-02 05:13:55'),
(398, 7, '2019-01-01 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:14:42', '2019-01-02 05:14:42'),
(399, 7, '2019-01-01 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:14:42', '2019-01-02 05:14:42'),
(400, 9, '2019-01-01 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:16:04', '2019-01-02 05:16:04'),
(401, 9, '2019-01-01 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:16:04', '2019-01-02 05:16:04'),
(402, 24, '2019-01-01 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:16:04', '2019-01-02 05:16:04'),
(403, 24, '2019-01-01 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:16:04', '2019-01-02 05:16:04'),
(404, 8, '2019-01-01 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:16:04', '2019-01-02 05:16:04'),
(405, 8, '2019-01-01 17:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:16:04', '2019-01-02 05:16:04'),
(406, 10, '2019-01-01 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:16:04', '2019-01-02 05:16:04'),
(407, 10, '2019-01-01 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:16:04', '2019-01-02 05:16:04'),
(408, 26, '2019-01-01 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:17:30', '2019-01-02 05:17:30'),
(409, 26, '2019-01-01 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:17:30', '2019-01-02 05:17:30'),
(410, 3, '2019-01-01 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:17:30', '2019-01-02 05:17:30'),
(411, 3, '2019-01-01 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:17:30', '2019-01-02 05:17:30'),
(412, 5, '2019-01-01 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:17:30', '2019-01-02 05:17:30'),
(413, 5, '2019-01-01 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-02 05:17:30', '2019-01-02 05:17:30'),
(426, 2, '2019-01-02 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:25:51', '2019-01-03 05:25:51'),
(427, 2, '2019-01-02 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:25:51', '2019-01-03 05:25:51'),
(428, 1, '2019-01-02 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:25:51', '2019-01-03 05:25:51'),
(429, 1, '2019-01-02 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:25:51', '2019-01-03 05:25:51'),
(430, 4, '2019-01-02 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:26:16', '2019-01-03 05:26:16'),
(431, 4, '2019-01-02 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:26:16', '2019-01-03 05:26:16'),
(432, 7, '2019-01-02 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:26:42', '2019-01-03 05:26:42'),
(433, 7, '2019-01-02 18:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:26:42', '2019-01-03 05:26:42'),
(434, 9, '2019-01-02 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:28:29', '2019-01-03 05:28:29'),
(435, 9, '2019-01-02 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:28:29', '2019-01-03 05:28:29'),
(436, 24, '2019-01-02 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:28:29', '2019-01-03 05:28:29'),
(437, 24, '2019-01-02 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:28:29', '2019-01-03 05:28:29'),
(438, 8, '2019-01-02 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:28:29', '2019-01-03 05:28:29'),
(439, 8, '2019-01-02 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:28:29', '2019-01-03 05:28:29'),
(440, 10, '2019-01-02 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:28:29', '2019-01-03 05:28:29'),
(441, 10, '2019-01-02 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:28:29', '2019-01-03 05:28:29'),
(442, 26, '2019-01-02 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:29:28', '2019-01-03 05:29:28'),
(443, 26, '2019-01-02 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:29:28', '2019-01-03 05:29:28'),
(444, 3, '2019-01-02 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:29:28', '2019-01-03 05:29:28'),
(445, 3, '2019-01-02 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:29:28', '2019-01-03 05:29:28'),
(446, 5, '2019-01-02 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:29:28', '2019-01-03 05:29:28'),
(447, 5, '2019-01-02 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-03 05:29:28', '2019-01-03 05:29:28'),
(461, 1, '2019-01-03 11:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:11:09', '2019-01-05 05:11:09'),
(462, 1, '2019-01-03 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:11:09', '2019-01-05 05:11:09'),
(463, 4, '2019-01-03 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:12:11', '2019-01-05 05:12:11'),
(464, 4, '2019-01-03 18:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:12:11', '2019-01-05 05:12:11'),
(465, 7, '2019-01-03 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:12:54', '2019-01-05 05:12:54'),
(466, 7, '2019-01-03 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:12:54', '2019-01-05 05:12:54'),
(467, 9, '2019-01-03 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:14:06', '2019-01-05 05:14:06'),
(468, 9, '2019-01-03 20:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:14:06', '2019-01-05 05:14:06'),
(469, 24, '2019-01-03 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:14:06', '2019-01-05 05:14:06'),
(470, 24, '2019-01-03 20:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:14:06', '2019-01-05 05:14:06'),
(471, 8, '2019-01-03 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:14:06', '2019-01-05 05:14:06'),
(472, 8, '2019-01-03 18:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:14:06', '2019-01-05 05:14:06'),
(473, 10, '2019-01-03 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:14:06', '2019-01-05 05:14:06'),
(474, 10, '2019-01-03 20:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:14:06', '2019-01-05 05:14:06'),
(475, 26, '2019-01-03 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:15:13', '2019-01-05 05:15:13'),
(476, 26, '2019-01-03 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:15:13', '2019-01-05 05:15:13'),
(477, 3, '2019-01-03 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:15:13', '2019-01-05 05:15:13'),
(478, 3, '2019-01-03 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:15:13', '2019-01-05 05:15:13'),
(479, 5, '2019-01-03 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:15:13', '2019-01-05 05:15:13'),
(480, 5, '2019-01-03 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-05 05:15:13', '2019-01-05 05:15:13'),
(497, 2, '2019-01-05 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:22:32', '2019-01-06 05:22:32'),
(498, 2, '2019-01-05 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:22:32', '2019-01-06 05:22:32'),
(499, 4, '2019-01-05 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:23:10', '2019-01-06 05:23:10'),
(500, 4, '2019-01-05 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:23:10', '2019-01-06 05:23:10'),
(501, 7, '2019-01-05 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:23:45', '2019-01-06 05:23:45'),
(502, 7, '2019-01-05 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:23:45', '2019-01-06 05:23:45'),
(503, 9, '2019-01-05 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:25:40', '2019-01-06 05:25:40'),
(504, 9, '2019-01-05 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:25:40', '2019-01-06 05:25:40'),
(505, 24, '2019-01-05 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:25:40', '2019-01-06 05:25:40'),
(506, 24, '2019-01-05 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:25:40', '2019-01-06 05:25:40'),
(507, 8, '2019-01-05 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:25:40', '2019-01-06 05:25:40'),
(508, 8, '2019-01-05 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:25:40', '2019-01-06 05:25:40'),
(509, 10, '2019-01-05 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:25:40', '2019-01-06 05:25:40'),
(510, 10, '2019-01-05 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:25:40', '2019-01-06 05:25:40'),
(511, 26, '2019-01-05 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:27:37', '2019-01-06 05:27:37'),
(512, 26, '2019-01-05 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:27:37', '2019-01-06 05:27:37'),
(513, 3, '2019-01-05 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:27:38', '2019-01-06 05:27:38'),
(514, 3, '2019-01-05 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:27:38', '2019-01-06 05:27:38'),
(515, 5, '2019-01-05 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:27:38', '2019-01-06 05:27:38'),
(516, 5, '2019-01-05 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-06 05:27:38', '2019-01-06 05:27:38'),
(523, 2, '2019-01-06 11:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:20:12', '2019-01-07 04:20:12'),
(524, 2, '2019-01-06 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:20:13', '2019-01-07 04:20:13'),
(525, 1, '2019-01-06 12:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:20:13', '2019-01-07 04:20:13'),
(526, 1, '2019-01-06 16:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:20:13', '2019-01-07 04:20:13'),
(527, 4, '2019-01-06 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:21:00', '2019-01-07 04:21:00'),
(528, 4, '2019-01-06 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:21:00', '2019-01-07 04:21:00'),
(529, 7, '2019-01-06 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:22:28', '2019-01-07 04:22:28'),
(530, 7, '2019-01-06 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:22:28', '2019-01-07 04:22:28'),
(531, 9, '2019-01-06 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:23:52', '2019-01-07 04:23:52'),
(532, 9, '2019-01-06 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:23:52', '2019-01-07 04:23:52'),
(533, 24, '2019-01-06 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:23:52', '2019-01-07 04:23:52'),
(534, 24, '2019-01-06 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:23:52', '2019-01-07 04:23:52'),
(535, 8, '2019-01-06 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:23:52', '2019-01-07 04:23:52'),
(536, 8, '2019-01-06 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:23:52', '2019-01-07 04:23:52'),
(537, 10, '2019-01-06 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:23:52', '2019-01-07 04:23:52'),
(538, 10, '2019-01-06 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:23:52', '2019-01-07 04:23:52'),
(539, 26, '2019-01-06 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:25:00', '2019-01-07 04:25:00'),
(540, 26, '2019-01-06 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:25:00', '2019-01-07 04:25:00'),
(541, 3, '2019-01-06 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:25:00', '2019-01-07 04:25:00'),
(542, 3, '2019-01-06 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:25:00', '2019-01-07 04:25:00'),
(543, 5, '2019-01-06 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:25:01', '2019-01-07 04:25:01'),
(544, 5, '2019-01-06 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-07 04:25:01', '2019-01-07 04:25:01'),
(561, 2, '2019-01-07 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:41:08', '2019-01-08 05:41:08'),
(562, 2, '2019-01-07 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:41:08', '2019-01-08 05:41:08'),
(563, 1, '2019-01-07 12:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:41:08', '2019-01-08 05:41:08'),
(564, 1, '2019-01-07 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:41:08', '2019-01-08 05:41:08'),
(565, 4, '2019-01-07 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:41:48', '2019-01-08 05:41:48'),
(566, 4, '2019-01-07 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:41:48', '2019-01-08 05:41:48'),
(567, 7, '2019-01-07 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:43:34', '2019-01-08 05:43:34'),
(568, 7, '2019-01-07 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:43:34', '2019-01-08 05:43:34'),
(569, 9, '2019-01-07 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:44:43', '2019-01-08 05:44:43'),
(570, 9, '2019-01-07 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:44:43', '2019-01-08 05:44:43'),
(571, 24, '2019-01-07 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:44:43', '2019-01-08 05:44:43'),
(572, 24, '2019-01-07 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:44:43', '2019-01-08 05:44:43'),
(573, 8, '2019-01-07 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:44:43', '2019-01-08 05:44:43'),
(574, 8, '2019-01-07 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:44:43', '2019-01-08 05:44:43'),
(575, 10, '2019-01-07 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:44:43', '2019-01-08 05:44:43'),
(576, 10, '2019-01-07 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:44:43', '2019-01-08 05:44:43'),
(577, 26, '2019-01-07 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:45:42', '2019-01-08 05:45:42'),
(578, 26, '2019-01-07 19:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:45:42', '2019-01-08 05:45:42'),
(579, 3, '2019-01-07 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:45:42', '2019-01-08 05:45:42'),
(580, 3, '2019-01-07 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:45:42', '2019-01-08 05:45:42'),
(581, 5, '2019-01-07 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:45:42', '2019-01-08 05:45:42'),
(582, 5, '2019-01-07 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-08 05:45:42', '2019-01-08 05:45:42'),
(605, 2, '2019-01-08 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 05:57:26', '2019-01-09 05:57:26'),
(606, 2, '2019-01-08 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 05:57:26', '2019-01-09 05:57:26'),
(607, 4, '2019-01-08 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 05:58:03', '2019-01-09 05:58:03'),
(608, 4, '2019-01-08 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 05:58:03', '2019-01-09 05:58:03'),
(609, 7, '2019-01-08 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 05:58:40', '2019-01-09 05:58:40'),
(610, 7, '2019-01-08 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 05:58:40', '2019-01-09 05:58:40'),
(611, 9, '2019-01-08 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:00:02', '2019-01-09 06:00:02'),
(612, 9, '2019-01-08 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:00:02', '2019-01-09 06:00:02'),
(613, 24, '2019-01-08 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:00:02', '2019-01-09 06:00:02'),
(614, 24, '2019-01-08 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:00:02', '2019-01-09 06:00:02'),
(615, 8, '2019-01-08 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:00:02', '2019-01-09 06:00:02'),
(616, 8, '2019-01-08 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:00:02', '2019-01-09 06:00:02'),
(617, 10, '2019-01-08 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:00:02', '2019-01-09 06:00:02'),
(618, 10, '2019-01-08 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:00:02', '2019-01-09 06:00:02'),
(619, 26, '2019-01-08 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:01:32', '2019-01-09 06:01:32'),
(620, 26, '2019-01-08 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:01:32', '2019-01-09 06:01:32'),
(621, 3, '2019-01-08 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:01:32', '2019-01-09 06:01:32'),
(622, 3, '2019-01-08 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:01:32', '2019-01-09 06:01:32'),
(623, 5, '2019-01-08 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:01:32', '2019-01-09 06:01:32'),
(624, 5, '2019-01-08 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-09 06:01:32', '2019-01-09 06:01:32'),
(630, 2, '2019-01-09 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:07:19', '2019-01-10 05:07:19'),
(631, 2, '2019-01-09 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:07:19', '2019-01-10 05:07:19'),
(632, 1, '2019-01-09 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:07:19', '2019-01-10 05:07:19'),
(633, 1, '2019-01-09 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:07:19', '2019-01-10 05:07:19'),
(634, 4, '2019-01-09 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:08:08', '2019-01-10 05:08:08'),
(635, 4, '2019-01-09 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:08:08', '2019-01-10 05:08:08'),
(636, 7, '2019-01-09 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:08:47', '2019-01-10 05:08:47'),
(637, 7, '2019-01-09 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:08:47', '2019-01-10 05:08:47'),
(638, 9, '2019-01-09 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:09:52', '2019-01-10 05:09:52'),
(639, 9, '2019-01-09 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:09:52', '2019-01-10 05:09:52'),
(640, 24, '2019-01-09 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:09:52', '2019-01-10 05:09:52'),
(641, 24, '2019-01-09 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:09:52', '2019-01-10 05:09:52'),
(642, 8, '2019-01-09 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:09:52', '2019-01-10 05:09:52'),
(643, 8, '2019-01-09 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:09:52', '2019-01-10 05:09:52'),
(644, 10, '2019-01-09 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:09:52', '2019-01-10 05:09:52'),
(645, 10, '2019-01-09 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:09:52', '2019-01-10 05:09:52'),
(646, 26, '2019-01-09 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:11:02', '2019-01-10 05:11:02'),
(647, 26, '2019-01-09 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:11:02', '2019-01-10 05:11:02'),
(648, 3, '2019-01-09 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:11:02', '2019-01-10 05:11:02'),
(649, 3, '2019-01-09 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:11:02', '2019-01-10 05:11:02'),
(650, 5, '2019-01-09 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:11:02', '2019-01-10 05:11:02'),
(651, 5, '2019-01-09 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-10 05:11:02', '2019-01-10 05:11:02'),
(663, 2, '2019-01-10 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:49:30', '2019-01-12 04:49:30'),
(664, 2, '2019-01-10 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:49:30', '2019-01-12 04:49:30'),
(665, 1, '2019-01-10 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:49:30', '2019-01-12 04:49:30');
INSERT INTO `employee_attendance` (`employee_attendance_id`, `finger_print_id`, `in_out_time`, `check_type`, `verify_code`, `sensor_id`, `Memoinfo`, `WorkCode`, `sn`, `UserExtFmt`, `mechine_sl`, `created_at`, `updated_at`) VALUES
(666, 1, '2019-01-10 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:49:30', '2019-01-12 04:49:30'),
(667, 4, '2019-01-10 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:51:04', '2019-01-12 04:51:04'),
(668, 4, '2019-01-10 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:51:04', '2019-01-12 04:51:04'),
(669, 7, '2019-01-10 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:51:30', '2019-01-12 04:51:30'),
(670, 7, '2019-01-10 19:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:51:30', '2019-01-12 04:51:30'),
(671, 9, '2019-01-10 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:52:34', '2019-01-12 04:52:34'),
(672, 9, '2019-01-10 19:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:52:34', '2019-01-12 04:52:34'),
(673, 24, '2019-01-10 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:52:34', '2019-01-12 04:52:34'),
(674, 24, '2019-01-10 19:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:52:34', '2019-01-12 04:52:34'),
(675, 8, '2019-01-10 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:52:34', '2019-01-12 04:52:34'),
(676, 8, '2019-01-10 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:52:34', '2019-01-12 04:52:34'),
(677, 10, '2019-01-10 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:52:34', '2019-01-12 04:52:34'),
(678, 10, '2019-01-10 19:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:52:34', '2019-01-12 04:52:34'),
(679, 26, '2019-01-10 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:53:46', '2019-01-12 04:53:46'),
(680, 26, '2019-01-10 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:53:46', '2019-01-12 04:53:46'),
(681, 3, '2019-01-10 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:53:46', '2019-01-12 04:53:46'),
(682, 3, '2019-01-10 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:53:46', '2019-01-12 04:53:46'),
(683, 5, '2019-01-10 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:53:46', '2019-01-12 04:53:46'),
(684, 5, '2019-01-10 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-12 04:53:46', '2019-01-12 04:53:46'),
(695, 2, '2019-01-12 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:38:34', '2019-01-14 04:38:34'),
(696, 2, '2019-01-12 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:38:34', '2019-01-14 04:38:34'),
(697, 1, '2019-01-12 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:38:34', '2019-01-14 04:38:34'),
(698, 1, '2019-01-12 19:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:38:34', '2019-01-14 04:38:34'),
(699, 4, '2019-01-12 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:39:06', '2019-01-14 04:39:06'),
(700, 4, '2019-01-12 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:39:07', '2019-01-14 04:39:07'),
(701, 7, '2019-01-12 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:39:58', '2019-01-14 04:39:58'),
(702, 7, '2019-01-12 19:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:39:58', '2019-01-14 04:39:58'),
(703, 9, '2019-01-12 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:43:07', '2019-01-14 04:43:07'),
(704, 9, '2019-01-12 20:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:43:07', '2019-01-14 04:43:07'),
(705, 24, '2019-01-12 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:43:07', '2019-01-14 04:43:07'),
(706, 24, '2019-01-12 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:43:07', '2019-01-14 04:43:07'),
(707, 8, '2019-01-12 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:43:07', '2019-01-14 04:43:07'),
(708, 8, '2019-01-12 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:43:07', '2019-01-14 04:43:07'),
(709, 10, '2019-01-12 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:43:07', '2019-01-14 04:43:07'),
(710, 10, '2019-01-12 20:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:43:07', '2019-01-14 04:43:07'),
(711, 26, '2019-01-12 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:45:47', '2019-01-14 04:45:47'),
(712, 26, '2019-01-12 19:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:45:47', '2019-01-14 04:45:47'),
(713, 5, '2019-01-12 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:45:47', '2019-01-14 04:45:47'),
(714, 5, '2019-01-12 19:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:45:47', '2019-01-14 04:45:47'),
(719, 7, '2019-01-13 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:51:34', '2019-01-14 04:51:34'),
(720, 7, '2019-01-13 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:51:34', '2019-01-14 04:51:34'),
(721, 9, '2019-01-13 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:54:55', '2019-01-14 04:54:55'),
(722, 9, '2019-01-13 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:54:55', '2019-01-14 04:54:55'),
(723, 24, '2019-01-13 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:54:55', '2019-01-14 04:54:55'),
(724, 24, '2019-01-13 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:54:55', '2019-01-14 04:54:55'),
(725, 10, '2019-01-13 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:54:55', '2019-01-14 04:54:55'),
(726, 10, '2019-01-13 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 04:54:55', '2019-01-14 04:54:55'),
(733, 26, '2019-01-13 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 05:07:12', '2019-01-14 05:07:12'),
(734, 26, '2019-01-13 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 05:07:12', '2019-01-14 05:07:12'),
(735, 3, '2019-01-13 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 05:07:12', '2019-01-14 05:07:12'),
(736, 3, '2019-01-13 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 05:07:12', '2019-01-14 05:07:12'),
(737, 5, '2019-01-13 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 05:07:12', '2019-01-14 05:07:12'),
(738, 5, '2019-01-13 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 05:07:12', '2019-01-14 05:07:12'),
(751, 2, '2019-01-13 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 08:51:32', '2019-01-14 08:51:32'),
(752, 2, '2019-01-13 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 08:51:32', '2019-01-14 08:51:32'),
(753, 1, '2019-01-13 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 08:51:32', '2019-01-14 08:51:32'),
(754, 1, '2019-01-13 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-14 08:51:32', '2019-01-14 08:51:32'),
(755, 2, '2019-01-14 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:48:18', '2019-01-15 06:48:18'),
(756, 2, '2019-01-14 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:48:18', '2019-01-15 06:48:18'),
(757, 1, '2019-01-14 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:48:18', '2019-01-15 06:48:18'),
(758, 1, '2019-01-14 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:48:18', '2019-01-15 06:48:18'),
(761, 4, '2019-01-14 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:51:21', '2019-01-15 06:51:21'),
(762, 4, '2019-01-14 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:51:21', '2019-01-15 06:51:21'),
(763, 7, '2019-01-14 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:52:07', '2019-01-15 06:52:07'),
(764, 7, '2019-01-14 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:52:07', '2019-01-15 06:52:07'),
(765, 9, '2019-01-14 09:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:53:40', '2019-01-15 06:53:40'),
(766, 9, '2019-01-14 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:53:40', '2019-01-15 06:53:40'),
(767, 24, '2019-01-14 09:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:53:40', '2019-01-15 06:53:40'),
(768, 24, '2019-01-14 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:53:40', '2019-01-15 06:53:40'),
(769, 8, '2019-01-14 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:53:40', '2019-01-15 06:53:40'),
(770, 8, '2019-01-14 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:53:40', '2019-01-15 06:53:40'),
(771, 10, '2019-01-14 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:53:40', '2019-01-15 06:53:40'),
(772, 10, '2019-01-14 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:53:40', '2019-01-15 06:53:40'),
(773, 26, '2019-01-14 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:55:40', '2019-01-15 06:55:40'),
(774, 26, '2019-01-14 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:55:40', '2019-01-15 06:55:40'),
(775, 3, '2019-01-14 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:55:40', '2019-01-15 06:55:40'),
(776, 3, '2019-01-14 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:55:40', '2019-01-15 06:55:40'),
(777, 5, '2019-01-14 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:55:40', '2019-01-15 06:55:40'),
(778, 5, '2019-01-14 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-15 06:55:40', '2019-01-15 06:55:40'),
(789, 2, '2019-01-15 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:12:27', '2019-01-17 05:12:27'),
(790, 2, '2019-01-15 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:12:27', '2019-01-17 05:12:27'),
(791, 1, '2019-01-15 11:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:12:27', '2019-01-17 05:12:27'),
(792, 1, '2019-01-15 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:12:27', '2019-01-17 05:12:27'),
(793, 4, '2019-01-15 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:12:47', '2019-01-17 05:12:47'),
(794, 4, '2019-01-15 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:12:47', '2019-01-17 05:12:47'),
(795, 7, '2019-01-15 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:13:43', '2019-01-17 05:13:43'),
(796, 7, '2019-01-15 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:13:43', '2019-01-17 05:13:43'),
(797, 9, '2019-01-15 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:14:53', '2019-01-17 05:14:53'),
(798, 9, '2019-01-15 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:14:53', '2019-01-17 05:14:53'),
(799, 24, '2019-01-15 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:14:53', '2019-01-17 05:14:53'),
(800, 24, '2019-01-15 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:14:53', '2019-01-17 05:14:53'),
(801, 8, '2019-01-15 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:14:53', '2019-01-17 05:14:53'),
(802, 8, '2019-01-15 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:14:53', '2019-01-17 05:14:53'),
(803, 10, '2019-01-15 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:14:53', '2019-01-17 05:14:53'),
(804, 10, '2019-01-15 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:14:53', '2019-01-17 05:14:53'),
(805, 26, '2019-01-15 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:15:37', '2019-01-17 05:15:37'),
(806, 26, '2019-01-15 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:15:37', '2019-01-17 05:15:37'),
(807, 3, '2019-01-15 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:15:37', '2019-01-17 05:15:37'),
(808, 3, '2019-01-15 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:15:37', '2019-01-17 05:15:37'),
(809, 5, '2019-01-15 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:15:37', '2019-01-17 05:15:37'),
(810, 5, '2019-01-15 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:15:37', '2019-01-17 05:15:37'),
(811, 2, '2019-01-16 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:21:21', '2019-01-17 05:21:21'),
(812, 2, '2019-01-16 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:21:22', '2019-01-17 05:21:22'),
(813, 1, '2019-01-16 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:21:22', '2019-01-17 05:21:22'),
(814, 1, '2019-01-16 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:21:22', '2019-01-17 05:21:22'),
(815, 7, '2019-01-16 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:23:00', '2019-01-17 05:23:00'),
(816, 7, '2019-01-16 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:23:00', '2019-01-17 05:23:00'),
(817, 9, '2019-01-16 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:26:28', '2019-01-17 05:26:28'),
(818, 9, '2019-01-16 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:26:28', '2019-01-17 05:26:28'),
(819, 24, '2019-01-16 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:26:28', '2019-01-17 05:26:28'),
(820, 24, '2019-01-16 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:26:28', '2019-01-17 05:26:28'),
(821, 26, '2019-01-16 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:28:50', '2019-01-17 05:28:50'),
(822, 26, '2019-01-16 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:28:50', '2019-01-17 05:28:50'),
(823, 3, '2019-01-16 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:28:50', '2019-01-17 05:28:50'),
(824, 3, '2019-01-16 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:28:50', '2019-01-17 05:28:50'),
(825, 5, '2019-01-16 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:28:50', '2019-01-17 05:28:50'),
(826, 5, '2019-01-16 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-17 05:28:50', '2019-01-17 05:28:50'),
(837, 2, '2019-01-17 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:34:26', '2019-01-19 05:34:26'),
(838, 2, '2019-01-17 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:34:26', '2019-01-19 05:34:26'),
(839, 1, '2019-01-17 11:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:34:26', '2019-01-19 05:34:26'),
(840, 1, '2019-01-17 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:34:26', '2019-01-19 05:34:26'),
(841, 4, '2019-01-17 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:34:51', '2019-01-19 05:34:51'),
(842, 4, '2019-01-17 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:34:51', '2019-01-19 05:34:51'),
(843, 7, '2019-01-17 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:35:21', '2019-01-19 05:35:21'),
(844, 7, '2019-01-17 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:35:21', '2019-01-19 05:35:21'),
(845, 9, '2019-01-17 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:36:13', '2019-01-19 05:36:13'),
(846, 9, '2019-01-17 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:36:13', '2019-01-19 05:36:13'),
(847, 24, '2019-01-17 09:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:36:13', '2019-01-19 05:36:13'),
(848, 24, '2019-01-17 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:36:13', '2019-01-19 05:36:13'),
(849, 8, '2019-01-17 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:36:13', '2019-01-19 05:36:13'),
(850, 8, '2019-01-17 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:36:13', '2019-01-19 05:36:13'),
(857, 26, '2019-01-17 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:43:05', '2019-01-19 05:43:05'),
(858, 26, '2019-01-17 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:43:05', '2019-01-19 05:43:05'),
(859, 3, '2019-01-17 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:43:05', '2019-01-19 05:43:05'),
(860, 3, '2019-01-17 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:43:05', '2019-01-19 05:43:05'),
(861, 5, '2019-01-17 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:43:05', '2019-01-19 05:43:05'),
(862, 5, '2019-01-17 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-19 05:43:05', '2019-01-19 05:43:05'),
(872, 1, '2019-01-19 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 05:58:03', '2019-01-20 05:58:03'),
(873, 1, '2019-01-19 20:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 05:58:03', '2019-01-20 05:58:03'),
(874, 4, '2019-01-19 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:01:30', '2019-01-20 06:01:30'),
(875, 4, '2019-01-19 20:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:01:30', '2019-01-20 06:01:30'),
(876, 7, '2019-01-19 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:02:03', '2019-01-20 06:02:03'),
(877, 7, '2019-01-19 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:02:03', '2019-01-20 06:02:03'),
(878, 9, '2019-01-19 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:04:26', '2019-01-20 06:04:26'),
(879, 9, '2019-01-19 20:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:04:26', '2019-01-20 06:04:26'),
(880, 24, '2019-01-19 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:04:26', '2019-01-20 06:04:26'),
(881, 24, '2019-01-19 20:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:04:26', '2019-01-20 06:04:26'),
(882, 8, '2019-01-19 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:04:26', '2019-01-20 06:04:26'),
(883, 8, '2019-01-19 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:04:26', '2019-01-20 06:04:26'),
(884, 26, '2019-01-19 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:05:49', '2019-01-20 06:05:49'),
(885, 26, '2019-01-19 20:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:05:49', '2019-01-20 06:05:49'),
(886, 3, '2019-01-19 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:05:49', '2019-01-20 06:05:49'),
(887, 3, '2019-01-19 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:05:49', '2019-01-20 06:05:49'),
(888, 5, '2019-01-19 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:05:49', '2019-01-20 06:05:49'),
(889, 5, '2019-01-19 20:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-20 06:05:49', '2019-01-20 06:05:49'),
(900, 1, '2019-01-20 11:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:36:36', '2019-01-21 05:36:36'),
(901, 1, '2019-01-20 19:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:36:36', '2019-01-21 05:36:36'),
(902, 4, '2019-01-20 10:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:37:42', '2019-01-21 05:37:42'),
(903, 4, '2019-01-20 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:37:42', '2019-01-21 05:37:42'),
(904, 7, '2019-01-20 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:39:14', '2019-01-21 05:39:14'),
(905, 7, '2019-01-20 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:39:14', '2019-01-21 05:39:14'),
(906, 9, '2019-01-20 09:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:41:49', '2019-01-21 05:41:49'),
(907, 9, '2019-01-20 21:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:41:49', '2019-01-21 05:41:49'),
(908, 24, '2019-01-20 09:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:41:49', '2019-01-21 05:41:49'),
(909, 24, '2019-01-20 19:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:41:49', '2019-01-21 05:41:49'),
(910, 8, '2019-01-20 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:41:49', '2019-01-21 05:41:49'),
(911, 8, '2019-01-20 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:41:49', '2019-01-21 05:41:49'),
(912, 10, '2019-01-20 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:41:49', '2019-01-21 05:41:49'),
(913, 10, '2019-01-20 21:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:41:49', '2019-01-21 05:41:49'),
(914, 26, '2019-01-20 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:55:39', '2019-01-21 05:55:39'),
(915, 26, '2019-01-20 19:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:55:39', '2019-01-21 05:55:39'),
(916, 3, '2019-01-20 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:55:39', '2019-01-21 05:55:39'),
(917, 3, '2019-01-20 19:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:55:39', '2019-01-21 05:55:39'),
(918, 5, '2019-01-20 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:55:39', '2019-01-21 05:55:39'),
(919, 5, '2019-01-20 19:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-21 05:55:39', '2019-01-21 05:55:39'),
(932, 2, '2019-01-21 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:18:37', '2019-01-22 05:18:37'),
(933, 2, '2019-01-21 20:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:18:37', '2019-01-22 05:18:37'),
(934, 1, '2019-01-21 12:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:18:37', '2019-01-22 05:18:37'),
(935, 1, '2019-01-21 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:18:37', '2019-01-22 05:18:37'),
(936, 4, '2019-01-21 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:19:18', '2019-01-22 05:19:18'),
(937, 4, '2019-01-21 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:19:18', '2019-01-22 05:19:18'),
(938, 7, '2019-01-21 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:19:50', '2019-01-22 05:19:50'),
(939, 7, '2019-01-21 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:19:50', '2019-01-22 05:19:50'),
(940, 9, '2019-01-21 09:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:21:19', '2019-01-22 05:21:19'),
(941, 9, '2019-01-21 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:21:19', '2019-01-22 05:21:19'),
(942, 24, '2019-01-21 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:21:19', '2019-01-22 05:21:19'),
(943, 24, '2019-01-21 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:21:19', '2019-01-22 05:21:19'),
(944, 8, '2019-01-21 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:21:19', '2019-01-22 05:21:19'),
(945, 8, '2019-01-21 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:21:19', '2019-01-22 05:21:19'),
(946, 10, '2019-01-21 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:21:19', '2019-01-22 05:21:19'),
(947, 10, '2019-01-21 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:21:19', '2019-01-22 05:21:19'),
(948, 26, '2019-01-21 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:22:08', '2019-01-22 05:22:08'),
(949, 26, '2019-01-21 20:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:22:08', '2019-01-22 05:22:08'),
(950, 3, '2019-01-21 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:22:08', '2019-01-22 05:22:08'),
(951, 3, '2019-01-21 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:22:08', '2019-01-22 05:22:08'),
(952, 5, '2019-01-21 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:22:08', '2019-01-22 05:22:08'),
(953, 5, '2019-01-21 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-22 05:22:08', '2019-01-22 05:22:08'),
(966, 2, '2019-01-22 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:09:09', '2019-01-23 06:09:09'),
(967, 2, '2019-01-22 20:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:09:09', '2019-01-23 06:09:09'),
(968, 1, '2019-01-22 12:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:09:09', '2019-01-23 06:09:09'),
(969, 1, '2019-01-22 20:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:09:09', '2019-01-23 06:09:09'),
(970, 4, '2019-01-22 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:09:40', '2019-01-23 06:09:40'),
(971, 4, '2019-01-22 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:09:40', '2019-01-23 06:09:40'),
(972, 7, '2019-01-22 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:10:22', '2019-01-23 06:10:22'),
(973, 7, '2019-01-22 18:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:10:22', '2019-01-23 06:10:22'),
(974, 9, '2019-01-22 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:11:31', '2019-01-23 06:11:31'),
(975, 9, '2019-01-22 20:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:11:31', '2019-01-23 06:11:31'),
(976, 24, '2019-01-22 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:11:31', '2019-01-23 06:11:31'),
(977, 24, '2019-01-22 20:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:11:31', '2019-01-23 06:11:31'),
(978, 8, '2019-01-22 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:11:31', '2019-01-23 06:11:31'),
(979, 8, '2019-01-22 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:11:31', '2019-01-23 06:11:31'),
(980, 10, '2019-01-22 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:11:31', '2019-01-23 06:11:31'),
(981, 10, '2019-01-22 20:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:11:31', '2019-01-23 06:11:31'),
(982, 26, '2019-01-22 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:14:30', '2019-01-23 06:14:30'),
(983, 26, '2019-01-22 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:14:30', '2019-01-23 06:14:30'),
(984, 3, '2019-01-22 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:14:30', '2019-01-23 06:14:30'),
(985, 3, '2019-01-22 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:14:30', '2019-01-23 06:14:30'),
(986, 5, '2019-01-22 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:14:30', '2019-01-23 06:14:30'),
(987, 5, '2019-01-22 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-23 06:14:30', '2019-01-23 06:14:30'),
(999, 2, '2019-01-23 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:12:30', '2019-01-24 05:12:30'),
(1000, 2, '2019-01-23 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:12:30', '2019-01-24 05:12:30'),
(1001, 1, '2019-01-23 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:12:30', '2019-01-24 05:12:30'),
(1002, 1, '2019-01-23 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:12:30', '2019-01-24 05:12:30'),
(1003, 4, '2019-01-23 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:12:57', '2019-01-24 05:12:57'),
(1004, 4, '2019-01-23 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:12:57', '2019-01-24 05:12:57'),
(1005, 7, '2019-01-23 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:18:40', '2019-01-24 05:18:40'),
(1006, 7, '2019-01-23 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:18:40', '2019-01-24 05:18:40'),
(1007, 9, '2019-01-23 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:20:05', '2019-01-24 05:20:05'),
(1008, 9, '2019-01-23 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:20:05', '2019-01-24 05:20:05'),
(1009, 24, '2019-01-23 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:20:05', '2019-01-24 05:20:05'),
(1010, 24, '2019-01-23 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:20:05', '2019-01-24 05:20:05'),
(1011, 8, '2019-01-23 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:20:05', '2019-01-24 05:20:05'),
(1012, 8, '2019-01-23 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:20:05', '2019-01-24 05:20:05'),
(1013, 10, '2019-01-23 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:20:05', '2019-01-24 05:20:05'),
(1014, 10, '2019-01-23 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:20:05', '2019-01-24 05:20:05'),
(1015, 26, '2019-01-23 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:21:10', '2019-01-24 05:21:10'),
(1016, 26, '2019-01-23 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:21:10', '2019-01-24 05:21:10'),
(1017, 3, '2019-01-23 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:21:10', '2019-01-24 05:21:10'),
(1018, 3, '2019-01-23 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:21:10', '2019-01-24 05:21:10'),
(1019, 5, '2019-01-23 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:21:10', '2019-01-24 05:21:10'),
(1020, 5, '2019-01-23 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-24 05:21:10', '2019-01-24 05:21:10'),
(1034, 2, '2019-01-24 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:37:52', '2019-01-27 07:37:52'),
(1035, 2, '2019-01-24 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:37:52', '2019-01-27 07:37:52'),
(1036, 1, '2019-01-24 11:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:37:52', '2019-01-27 07:37:52'),
(1037, 1, '2019-01-24 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:37:52', '2019-01-27 07:37:52'),
(1038, 4, '2019-01-24 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:38:32', '2019-01-27 07:38:32'),
(1039, 4, '2019-01-24 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:38:32', '2019-01-27 07:38:32'),
(1040, 7, '2019-01-24 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:39:04', '2019-01-27 07:39:04'),
(1041, 7, '2019-01-24 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:39:04', '2019-01-27 07:39:04'),
(1042, 9, '2019-01-24 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:41:13', '2019-01-27 07:41:13'),
(1043, 9, '2019-01-24 20:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:41:13', '2019-01-27 07:41:13'),
(1044, 24, '2019-01-24 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:41:13', '2019-01-27 07:41:13'),
(1045, 24, '2019-01-24 20:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:41:13', '2019-01-27 07:41:13'),
(1046, 8, '2019-01-24 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:41:13', '2019-01-27 07:41:13'),
(1047, 8, '2019-01-24 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:41:13', '2019-01-27 07:41:13'),
(1048, 10, '2019-01-24 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:41:13', '2019-01-27 07:41:13'),
(1049, 10, '2019-01-24 20:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:41:13', '2019-01-27 07:41:13'),
(1050, 26, '2019-01-24 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:42:19', '2019-01-27 07:42:19'),
(1051, 26, '2019-01-24 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:42:19', '2019-01-27 07:42:19'),
(1052, 3, '2019-01-24 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:42:19', '2019-01-27 07:42:19'),
(1053, 3, '2019-01-24 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:42:19', '2019-01-27 07:42:19'),
(1054, 5, '2019-01-24 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:42:19', '2019-01-27 07:42:19'),
(1055, 5, '2019-01-24 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:42:19', '2019-01-27 07:42:19'),
(1062, 7, '2019-01-26 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:48:32', '2019-01-27 07:48:32'),
(1063, 7, '2019-01-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-27 07:48:32', '2019-01-27 07:48:32'),
(1089, 2, '2019-01-27 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:01:38', '2019-01-29 07:01:38'),
(1090, 2, '2019-01-27 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:01:38', '2019-01-29 07:01:38'),
(1091, 1, '2019-01-27 12:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:01:38', '2019-01-29 07:01:38'),
(1092, 1, '2019-01-27 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:01:38', '2019-01-29 07:01:38'),
(1093, 4, '2019-01-27 11:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:02:08', '2019-01-29 07:02:08'),
(1094, 4, '2019-01-27 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:02:08', '2019-01-29 07:02:08'),
(1095, 7, '2019-01-27 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:02:29', '2019-01-29 07:02:29'),
(1096, 7, '2019-01-27 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:02:29', '2019-01-29 07:02:29'),
(1097, 9, '2019-01-27 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:05', '2019-01-29 07:03:05'),
(1098, 9, '2019-01-27 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:05', '2019-01-29 07:03:05'),
(1099, 24, '2019-01-27 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:05', '2019-01-29 07:03:05'),
(1100, 24, '2019-01-27 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:05', '2019-01-29 07:03:05'),
(1101, 8, '2019-01-27 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:05', '2019-01-29 07:03:05'),
(1102, 8, '2019-01-27 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:05', '2019-01-29 07:03:05'),
(1103, 10, '2019-01-27 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:05', '2019-01-29 07:03:05'),
(1104, 10, '2019-01-27 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:05', '2019-01-29 07:03:05'),
(1105, 26, '2019-01-27 11:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:30', '2019-01-29 07:03:30'),
(1106, 26, '2019-01-27 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:30', '2019-01-29 07:03:30'),
(1107, 3, '2019-01-27 11:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:30', '2019-01-29 07:03:30'),
(1108, 3, '2019-01-27 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:30', '2019-01-29 07:03:30'),
(1109, 5, '2019-01-27 11:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:30', '2019-01-29 07:03:30'),
(1110, 5, '2019-01-27 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:03:30', '2019-01-29 07:03:30'),
(1111, 2, '2019-01-28 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:04:54', '2019-01-29 07:04:54'),
(1112, 2, '2019-01-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:04:54', '2019-01-29 07:04:54'),
(1113, 1, '2019-01-28 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:04:54', '2019-01-29 07:04:54'),
(1114, 1, '2019-01-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:04:54', '2019-01-29 07:04:54'),
(1115, 4, '2019-01-28 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:05:36', '2019-01-29 07:05:36'),
(1116, 4, '2019-01-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:05:36', '2019-01-29 07:05:36'),
(1117, 7, '2019-01-28 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:06:07', '2019-01-29 07:06:07'),
(1118, 7, '2019-01-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:06:07', '2019-01-29 07:06:07'),
(1119, 9, '2019-01-28 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:10', '2019-01-29 07:07:10'),
(1120, 9, '2019-01-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:10', '2019-01-29 07:07:10'),
(1121, 24, '2019-01-28 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:10', '2019-01-29 07:07:10'),
(1122, 24, '2019-01-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:10', '2019-01-29 07:07:10'),
(1123, 8, '2019-01-28 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:10', '2019-01-29 07:07:10'),
(1124, 8, '2019-01-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:10', '2019-01-29 07:07:10'),
(1125, 10, '2019-01-28 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:10', '2019-01-29 07:07:10'),
(1126, 10, '2019-01-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:10', '2019-01-29 07:07:10'),
(1127, 26, '2019-01-28 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:51', '2019-01-29 07:07:51'),
(1128, 26, '2019-01-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:51', '2019-01-29 07:07:51'),
(1129, 3, '2019-01-28 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:51', '2019-01-29 07:07:51'),
(1130, 3, '2019-01-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:51', '2019-01-29 07:07:51'),
(1131, 5, '2019-01-28 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:51', '2019-01-29 07:07:51'),
(1132, 5, '2019-01-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:07:51', '2019-01-29 07:07:51'),
(1133, 2, '2019-01-26 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:09:09', '2019-01-29 07:09:09'),
(1134, 2, '2019-01-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:09:09', '2019-01-29 07:09:09'),
(1135, 1, '2019-01-26 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:09:09', '2019-01-29 07:09:09'),
(1136, 1, '2019-01-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:09:09', '2019-01-29 07:09:09'),
(1137, 4, '2019-01-26 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:09:32', '2019-01-29 07:09:32'),
(1138, 4, '2019-01-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:09:32', '2019-01-29 07:09:32'),
(1139, 9, '2019-01-26 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:06', '2019-01-29 07:10:06'),
(1140, 9, '2019-01-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:06', '2019-01-29 07:10:06'),
(1141, 24, '2019-01-26 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:06', '2019-01-29 07:10:06'),
(1142, 24, '2019-01-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:06', '2019-01-29 07:10:06'),
(1143, 8, '2019-01-26 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:06', '2019-01-29 07:10:06'),
(1144, 8, '2019-01-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:06', '2019-01-29 07:10:06'),
(1145, 10, '2019-01-26 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:06', '2019-01-29 07:10:06'),
(1146, 10, '2019-01-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:06', '2019-01-29 07:10:06'),
(1147, 26, '2019-01-26 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:29', '2019-01-29 07:10:29'),
(1148, 26, '2019-01-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:29', '2019-01-29 07:10:29'),
(1149, 3, '2019-01-26 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:29', '2019-01-29 07:10:29'),
(1150, 3, '2019-01-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:29', '2019-01-29 07:10:29'),
(1151, 5, '2019-01-26 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:29', '2019-01-29 07:10:29'),
(1152, 5, '2019-01-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-29 07:10:29', '2019-01-29 07:10:29'),
(1163, 2, '2019-01-29 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:55:25', '2019-01-30 05:55:25'),
(1164, 2, '2019-01-29 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:55:25', '2019-01-30 05:55:25'),
(1165, 1, '2019-01-29 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:55:25', '2019-01-30 05:55:25'),
(1166, 1, '2019-01-29 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:55:25', '2019-01-30 05:55:25'),
(1167, 4, '2019-01-29 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:55:49', '2019-01-30 05:55:49'),
(1168, 4, '2019-01-29 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:55:49', '2019-01-30 05:55:49'),
(1169, 7, '2019-01-29 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:56:26', '2019-01-30 05:56:26'),
(1170, 7, '2019-01-29 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:56:26', '2019-01-30 05:56:26'),
(1171, 9, '2019-01-29 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:57:19', '2019-01-30 05:57:19'),
(1172, 9, '2019-01-29 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:57:19', '2019-01-30 05:57:19'),
(1173, 24, '2019-01-29 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:57:19', '2019-01-30 05:57:19'),
(1174, 24, '2019-01-29 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:57:19', '2019-01-30 05:57:19'),
(1175, 8, '2019-01-29 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:57:19', '2019-01-30 05:57:19'),
(1176, 8, '2019-01-29 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:57:19', '2019-01-30 05:57:19'),
(1177, 26, '2019-01-29 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:58:15', '2019-01-30 05:58:15'),
(1178, 26, '2019-01-29 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:58:15', '2019-01-30 05:58:15'),
(1179, 3, '2019-01-29 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:58:15', '2019-01-30 05:58:15'),
(1180, 3, '2019-01-29 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:58:15', '2019-01-30 05:58:15'),
(1181, 5, '2019-01-29 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:58:15', '2019-01-30 05:58:15'),
(1182, 5, '2019-01-29 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-30 05:58:15', '2019-01-30 05:58:15'),
(1194, 2, '2019-01-30 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:36:22', '2019-01-31 06:36:22'),
(1195, 2, '2019-01-30 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:36:22', '2019-01-31 06:36:22'),
(1196, 1, '2019-01-30 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:36:22', '2019-01-31 06:36:22'),
(1197, 1, '2019-01-30 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:36:22', '2019-01-31 06:36:22'),
(1198, 4, '2019-01-30 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:37:16', '2019-01-31 06:37:16'),
(1199, 4, '2019-01-30 18:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:37:16', '2019-01-31 06:37:16'),
(1200, 7, '2019-01-30 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:37:39', '2019-01-31 06:37:39'),
(1201, 7, '2019-01-30 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:37:39', '2019-01-31 06:37:39'),
(1202, 9, '2019-01-30 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:39:41', '2019-01-31 06:39:41'),
(1203, 9, '2019-01-30 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:39:41', '2019-01-31 06:39:41'),
(1204, 24, '2019-01-30 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:39:41', '2019-01-31 06:39:41'),
(1205, 24, '2019-01-30 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:39:41', '2019-01-31 06:39:41'),
(1206, 8, '2019-01-30 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:39:41', '2019-01-31 06:39:41'),
(1207, 8, '2019-01-30 18:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:39:41', '2019-01-31 06:39:41'),
(1208, 10, '2019-01-30 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:39:41', '2019-01-31 06:39:41'),
(1209, 10, '2019-01-30 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:39:41', '2019-01-31 06:39:41'),
(1210, 26, '2019-01-30 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:41:13', '2019-01-31 06:41:13'),
(1211, 26, '2019-01-30 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:41:13', '2019-01-31 06:41:13'),
(1212, 3, '2019-01-30 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:41:13', '2019-01-31 06:41:13'),
(1213, 3, '2019-01-30 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:41:13', '2019-01-31 06:41:13'),
(1214, 5, '2019-01-30 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:41:13', '2019-01-31 06:41:13'),
(1215, 5, '2019-01-30 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-01-31 06:41:13', '2019-01-31 06:41:13'),
(1226, 2, '2019-01-31 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:52:06', '2019-02-02 04:52:06'),
(1227, 2, '2019-01-31 19:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:52:06', '2019-02-02 04:52:06'),
(1228, 1, '2019-01-31 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:52:06', '2019-02-02 04:52:06'),
(1229, 1, '2019-01-31 19:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:52:06', '2019-02-02 04:52:06'),
(1230, 4, '2019-01-31 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:53:31', '2019-02-02 04:53:31'),
(1231, 4, '2019-01-31 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:53:31', '2019-02-02 04:53:31'),
(1232, 7, '2019-01-31 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:54:00', '2019-02-02 04:54:00'),
(1233, 7, '2019-01-31 19:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:54:00', '2019-02-02 04:54:00'),
(1234, 9, '2019-01-31 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:55:54', '2019-02-02 04:55:54'),
(1235, 9, '2019-01-31 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:55:54', '2019-02-02 04:55:54'),
(1236, 24, '2019-01-31 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:55:54', '2019-02-02 04:55:54'),
(1237, 24, '2019-01-31 19:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:55:54', '2019-02-02 04:55:54'),
(1238, 8, '2019-01-31 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:55:54', '2019-02-02 04:55:54'),
(1239, 8, '2019-01-31 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:55:54', '2019-02-02 04:55:54'),
(1240, 10, '2019-01-31 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:55:54', '2019-02-02 04:55:54'),
(1241, 10, '2019-01-31 19:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:55:54', '2019-02-02 04:55:54'),
(1242, 3, '2019-01-31 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:56:17', '2019-02-02 04:56:17'),
(1243, 3, '2019-01-31 19:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:56:17', '2019-02-02 04:56:17'),
(1244, 5, '2019-01-31 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:56:17', '2019-02-02 04:56:17'),
(1245, 5, '2019-01-31 19:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-02 04:56:17', '2019-02-02 04:56:17'),
(1383, 2, '2019-02-02 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:43:00', '2019-02-07 04:43:00'),
(1384, 2, '2019-02-02 19:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:43:00', '2019-02-07 04:43:00'),
(1385, 1, '2019-02-02 12:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:43:00', '2019-02-07 04:43:00'),
(1386, 1, '2019-02-02 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:43:00', '2019-02-07 04:43:00');
INSERT INTO `employee_attendance` (`employee_attendance_id`, `finger_print_id`, `in_out_time`, `check_type`, `verify_code`, `sensor_id`, `Memoinfo`, `WorkCode`, `sn`, `UserExtFmt`, `mechine_sl`, `created_at`, `updated_at`) VALUES
(1387, 4, '2019-02-02 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:44:03', '2019-02-07 04:44:03'),
(1388, 4, '2019-02-02 19:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:44:03', '2019-02-07 04:44:03'),
(1389, 24, '2019-02-02 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:46:51', '2019-02-07 04:46:51'),
(1390, 24, '2019-02-02 20:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:46:51', '2019-02-07 04:46:51'),
(1391, 8, '2019-02-02 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:46:51', '2019-02-07 04:46:51'),
(1392, 8, '2019-02-02 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:46:51', '2019-02-07 04:46:51'),
(1393, 10, '2019-02-02 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:46:51', '2019-02-07 04:46:51'),
(1394, 10, '2019-02-02 20:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:46:51', '2019-02-07 04:46:51'),
(1395, 26, '2019-02-02 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:48:01', '2019-02-07 04:48:01'),
(1396, 26, '2019-02-02 19:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:48:01', '2019-02-07 04:48:01'),
(1397, 3, '2019-02-02 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:48:01', '2019-02-07 04:48:01'),
(1398, 3, '2019-02-02 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:48:01', '2019-02-07 04:48:01'),
(1399, 5, '2019-02-02 10:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:49:36', '2019-02-07 04:49:36'),
(1400, 5, '2019-02-02 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:49:36', '2019-02-07 04:49:36'),
(1401, 2, '2019-02-03 10:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:51:22', '2019-02-07 04:51:22'),
(1402, 2, '2019-02-03 20:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:51:22', '2019-02-07 04:51:22'),
(1403, 1, '2019-02-03 10:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:51:22', '2019-02-07 04:51:22'),
(1404, 1, '2019-02-03 19:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:51:22', '2019-02-07 04:51:22'),
(1405, 4, '2019-02-03 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:52:28', '2019-02-07 04:52:28'),
(1406, 4, '2019-02-03 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:52:28', '2019-02-07 04:52:28'),
(1407, 7, '2019-02-03 10:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:53:03', '2019-02-07 04:53:03'),
(1408, 7, '2019-02-03 20:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:53:03', '2019-02-07 04:53:03'),
(1409, 9, '2019-02-03 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:55:17', '2019-02-07 04:55:17'),
(1410, 9, '2019-02-03 20:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:55:17', '2019-02-07 04:55:17'),
(1411, 24, '2019-02-03 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:55:17', '2019-02-07 04:55:17'),
(1412, 24, '2019-02-03 20:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:55:17', '2019-02-07 04:55:17'),
(1413, 8, '2019-02-03 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:55:17', '2019-02-07 04:55:17'),
(1414, 8, '2019-02-03 17:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:55:17', '2019-02-07 04:55:17'),
(1415, 10, '2019-02-03 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:55:17', '2019-02-07 04:55:17'),
(1416, 10, '2019-02-03 17:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 04:55:17', '2019-02-07 04:55:17'),
(1417, 26, '2019-02-03 10:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:01:41', '2019-02-07 05:01:41'),
(1418, 26, '2019-02-03 19:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:01:41', '2019-02-07 05:01:41'),
(1419, 3, '2019-02-03 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:01:41', '2019-02-07 05:01:41'),
(1420, 3, '2019-02-03 20:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:01:41', '2019-02-07 05:01:41'),
(1421, 5, '2019-02-03 11:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:02:38', '2019-02-07 05:02:38'),
(1422, 5, '2019-02-03 20:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:02:38', '2019-02-07 05:02:38'),
(1423, 2, '2019-02-04 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:03:39', '2019-02-07 05:03:39'),
(1424, 2, '2019-02-04 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:03:39', '2019-02-07 05:03:39'),
(1425, 1, '2019-02-04 11:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:03:39', '2019-02-07 05:03:39'),
(1426, 1, '2019-02-04 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:03:39', '2019-02-07 05:03:39'),
(1427, 4, '2019-02-04 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:05:16', '2019-02-07 05:05:16'),
(1428, 4, '2019-02-04 18:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:05:16', '2019-02-07 05:05:16'),
(1429, 7, '2019-02-04 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:05:52', '2019-02-07 05:05:52'),
(1430, 7, '2019-02-04 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:05:52', '2019-02-07 05:05:52'),
(1431, 9, '2019-02-04 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:08:22', '2019-02-07 05:08:22'),
(1432, 9, '2019-02-04 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:08:22', '2019-02-07 05:08:22'),
(1433, 24, '2019-02-04 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:08:22', '2019-02-07 05:08:22'),
(1434, 24, '2019-02-04 18:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:08:22', '2019-02-07 05:08:22'),
(1435, 8, '2019-02-04 10:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:08:22', '2019-02-07 05:08:22'),
(1436, 8, '2019-02-04 18:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:08:22', '2019-02-07 05:08:22'),
(1437, 10, '2019-02-04 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:08:22', '2019-02-07 05:08:22'),
(1438, 10, '2019-02-04 18:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:08:22', '2019-02-07 05:08:22'),
(1439, 26, '2019-02-04 11:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:09:11', '2019-02-07 05:09:11'),
(1440, 26, '2019-02-04 18:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:09:11', '2019-02-07 05:09:11'),
(1441, 3, '2019-02-04 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:09:11', '2019-02-07 05:09:11'),
(1442, 3, '2019-02-04 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:09:11', '2019-02-07 05:09:11'),
(1443, 5, '2019-02-04 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:09:49', '2019-02-07 05:09:49'),
(1444, 5, '2019-02-04 18:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:09:49', '2019-02-07 05:09:49'),
(1445, 2, '2019-02-05 10:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:11:18', '2019-02-07 05:11:18'),
(1446, 2, '2019-02-05 19:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:11:18', '2019-02-07 05:11:18'),
(1447, 1, '2019-02-05 12:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:11:18', '2019-02-07 05:11:18'),
(1448, 1, '2019-02-05 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:11:18', '2019-02-07 05:11:18'),
(1449, 4, '2019-02-05 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:11:48', '2019-02-07 05:11:48'),
(1450, 4, '2019-02-05 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:11:48', '2019-02-07 05:11:48'),
(1451, 7, '2019-02-05 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:12:27', '2019-02-07 05:12:27'),
(1452, 7, '2019-02-05 19:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:12:27', '2019-02-07 05:12:27'),
(1453, 9, '2019-02-05 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:14:49', '2019-02-07 05:14:49'),
(1454, 9, '2019-02-05 19:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:14:49', '2019-02-07 05:14:49'),
(1455, 24, '2019-02-05 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:14:49', '2019-02-07 05:14:49'),
(1456, 24, '2019-02-05 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:14:49', '2019-02-07 05:14:49'),
(1457, 8, '2019-02-05 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:14:49', '2019-02-07 05:14:49'),
(1458, 8, '2019-02-05 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:14:49', '2019-02-07 05:14:49'),
(1459, 10, '2019-02-05 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:14:49', '2019-02-07 05:14:49'),
(1460, 10, '2019-02-05 19:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:14:49', '2019-02-07 05:14:49'),
(1461, 26, '2019-02-05 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:15:52', '2019-02-07 05:15:52'),
(1462, 26, '2019-02-05 18:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:15:52', '2019-02-07 05:15:52'),
(1463, 3, '2019-02-05 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:15:52', '2019-02-07 05:15:52'),
(1464, 3, '2019-02-05 19:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:15:52', '2019-02-07 05:15:52'),
(1465, 5, '2019-02-05 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:16:29', '2019-02-07 05:16:29'),
(1466, 5, '2019-02-05 19:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:16:29', '2019-02-07 05:16:29'),
(1467, 2, '2019-02-06 10:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:18:25', '2019-02-07 05:18:25'),
(1468, 2, '2019-02-06 18:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:18:25', '2019-02-07 05:18:25'),
(1469, 1, '2019-02-06 10:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:18:25', '2019-02-07 05:18:25'),
(1470, 1, '2019-02-06 18:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:18:25', '2019-02-07 05:18:25'),
(1473, 7, '2019-02-06 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:22:08', '2019-02-07 05:22:08'),
(1474, 7, '2019-02-06 20:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:22:08', '2019-02-07 05:22:08'),
(1485, 26, '2019-02-06 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:30:10', '2019-02-07 05:30:10'),
(1486, 26, '2019-02-06 19:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:30:10', '2019-02-07 05:30:10'),
(1487, 3, '2019-02-06 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:30:10', '2019-02-07 05:30:10'),
(1488, 3, '2019-02-06 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:30:10', '2019-02-07 05:30:10'),
(1489, 5, '2019-02-06 10:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:30:51', '2019-02-07 05:30:51'),
(1490, 5, '2019-02-06 19:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 05:30:51', '2019-02-07 05:30:51'),
(1500, 4, '2019-02-06 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 09:44:34', '2019-02-07 09:44:34'),
(1501, 4, '2019-02-06 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 09:44:34', '2019-02-07 09:44:34'),
(1504, 9, '2019-02-06 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 09:48:30', '2019-02-07 09:48:30'),
(1505, 9, '2019-02-06 20:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 09:48:30', '2019-02-07 09:48:30'),
(1506, 8, '2019-02-06 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 09:48:30', '2019-02-07 09:48:30'),
(1507, 8, '2019-02-06 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 09:48:30', '2019-02-07 09:48:30'),
(1508, 10, '2019-02-06 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 09:48:30', '2019-02-07 09:48:30'),
(1509, 10, '2019-02-06 20:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-07 09:48:30', '2019-02-07 09:48:30'),
(1510, 2, '2019-02-07 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:42:49', '2019-02-09 05:42:49'),
(1511, 2, '2019-02-07 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:42:49', '2019-02-09 05:42:49'),
(1512, 1, '2019-02-07 11:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:42:49', '2019-02-09 05:42:49'),
(1513, 1, '2019-02-07 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:42:49', '2019-02-09 05:42:49'),
(1514, 4, '2019-02-07 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:43:23', '2019-02-09 05:43:23'),
(1515, 4, '2019-02-07 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:43:23', '2019-02-09 05:43:23'),
(1516, 7, '2019-02-07 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:44:32', '2019-02-09 05:44:32'),
(1517, 7, '2019-02-07 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:44:32', '2019-02-09 05:44:32'),
(1518, 9, '2019-02-07 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:46:28', '2019-02-09 05:46:28'),
(1519, 9, '2019-02-07 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:46:28', '2019-02-09 05:46:28'),
(1520, 8, '2019-02-07 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:46:28', '2019-02-09 05:46:28'),
(1521, 8, '2019-02-07 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:46:28', '2019-02-09 05:46:28'),
(1522, 10, '2019-02-07 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:46:28', '2019-02-09 05:46:28'),
(1523, 10, '2019-02-07 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:46:28', '2019-02-09 05:46:28'),
(1524, 26, '2019-02-07 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:47:42', '2019-02-09 05:47:42'),
(1525, 26, '2019-02-07 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:47:42', '2019-02-09 05:47:42'),
(1526, 3, '2019-02-07 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:47:42', '2019-02-09 05:47:42'),
(1527, 3, '2019-02-07 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-09 05:47:42', '2019-02-09 05:47:42'),
(1538, 1, '2019-02-09 11:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:47:24', '2019-02-10 05:47:24'),
(1539, 1, '2019-02-09 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:47:24', '2019-02-10 05:47:24'),
(1540, 7, '2019-02-09 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:50:00', '2019-02-10 05:50:00'),
(1541, 7, '2019-02-09 19:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:50:00', '2019-02-10 05:50:00'),
(1542, 9, '2019-02-09 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:51:12', '2019-02-10 05:51:12'),
(1543, 9, '2019-02-09 19:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:51:12', '2019-02-10 05:51:12'),
(1544, 8, '2019-02-09 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:51:12', '2019-02-10 05:51:12'),
(1545, 8, '2019-02-09 18:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:51:12', '2019-02-10 05:51:12'),
(1546, 10, '2019-02-09 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:51:12', '2019-02-10 05:51:12'),
(1547, 10, '2019-02-09 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:51:12', '2019-02-10 05:51:12'),
(1548, 26, '2019-02-09 10:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:52:07', '2019-02-10 05:52:07'),
(1549, 26, '2019-02-09 19:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:52:07', '2019-02-10 05:52:07'),
(1550, 3, '2019-02-09 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:52:07', '2019-02-10 05:52:07'),
(1551, 3, '2019-02-09 18:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:52:07', '2019-02-10 05:52:07'),
(1552, 5, '2019-02-09 10:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:52:54', '2019-02-10 05:52:54'),
(1553, 5, '2019-02-09 18:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-10 05:52:54', '2019-02-10 05:52:54'),
(1563, 2, '2019-02-10 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:53:51', '2019-02-11 05:53:51'),
(1564, 2, '2019-02-10 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:53:51', '2019-02-11 05:53:51'),
(1565, 1, '2019-02-10 11:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:53:51', '2019-02-11 05:53:51'),
(1566, 1, '2019-02-10 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:53:51', '2019-02-11 05:53:51'),
(1567, 4, '2019-02-10 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:54:35', '2019-02-11 05:54:35'),
(1568, 4, '2019-02-10 19:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:54:35', '2019-02-11 05:54:35'),
(1569, 7, '2019-02-10 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:55:07', '2019-02-11 05:55:07'),
(1570, 7, '2019-02-10 18:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:55:07', '2019-02-11 05:55:07'),
(1571, 9, '2019-02-10 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:56:15', '2019-02-11 05:56:15'),
(1572, 9, '2019-02-10 19:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:56:15', '2019-02-11 05:56:15'),
(1573, 8, '2019-02-10 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:56:15', '2019-02-11 05:56:15'),
(1574, 8, '2019-02-10 19:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:56:15', '2019-02-11 05:56:15'),
(1575, 10, '2019-02-10 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:56:15', '2019-02-11 05:56:15'),
(1576, 10, '2019-02-10 19:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:56:15', '2019-02-11 05:56:15'),
(1577, 26, '2019-02-10 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:57:42', '2019-02-11 05:57:42'),
(1578, 26, '2019-02-10 19:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:57:42', '2019-02-11 05:57:42'),
(1579, 3, '2019-02-10 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:57:42', '2019-02-11 05:57:42'),
(1580, 3, '2019-02-10 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:57:42', '2019-02-11 05:57:42'),
(1581, 5, '2019-02-10 10:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:58:06', '2019-02-11 05:58:06'),
(1582, 5, '2019-02-10 18:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-11 05:58:06', '2019-02-11 05:58:06'),
(1596, 2, '2019-02-11 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:55:20', '2019-02-12 06:55:20'),
(1597, 2, '2019-02-11 18:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:55:20', '2019-02-12 06:55:20'),
(1598, 1, '2019-02-11 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:55:20', '2019-02-12 06:55:20'),
(1599, 1, '2019-02-11 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:55:20', '2019-02-12 06:55:20'),
(1600, 4, '2019-02-11 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:55:55', '2019-02-12 06:55:55'),
(1601, 4, '2019-02-11 18:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:55:55', '2019-02-12 06:55:55'),
(1602, 7, '2019-02-11 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:56:26', '2019-02-12 06:56:26'),
(1603, 7, '2019-02-11 18:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:56:26', '2019-02-12 06:56:26'),
(1604, 9, '2019-02-11 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:57:33', '2019-02-12 06:57:33'),
(1605, 9, '2019-02-11 18:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:57:33', '2019-02-12 06:57:33'),
(1606, 8, '2019-02-11 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:57:33', '2019-02-12 06:57:33'),
(1607, 8, '2019-02-11 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:57:33', '2019-02-12 06:57:33'),
(1608, 10, '2019-02-11 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:57:33', '2019-02-12 06:57:33'),
(1609, 10, '2019-02-11 18:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:57:33', '2019-02-12 06:57:33'),
(1610, 26, '2019-02-11 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:58:33', '2019-02-12 06:58:33'),
(1611, 26, '2019-02-11 18:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:58:33', '2019-02-12 06:58:33'),
(1612, 3, '2019-02-11 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:58:33', '2019-02-12 06:58:33'),
(1613, 3, '2019-02-11 18:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:58:33', '2019-02-12 06:58:33'),
(1614, 5, '2019-02-11 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:59:06', '2019-02-12 06:59:06'),
(1615, 5, '2019-02-11 18:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-12 06:59:06', '2019-02-12 06:59:06'),
(1627, 2, '2019-02-12 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:26:23', '2019-02-13 05:26:23'),
(1628, 2, '2019-02-12 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:26:23', '2019-02-13 05:26:23'),
(1629, 1, '2019-02-12 11:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:26:23', '2019-02-13 05:26:23'),
(1630, 1, '2019-02-12 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:26:23', '2019-02-13 05:26:23'),
(1631, 4, '2019-02-12 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:26:53', '2019-02-13 05:26:53'),
(1632, 4, '2019-02-12 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:26:53', '2019-02-13 05:26:53'),
(1633, 7, '2019-02-12 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:27:09', '2019-02-13 05:27:09'),
(1634, 7, '2019-02-12 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:27:09', '2019-02-13 05:27:09'),
(1635, 9, '2019-02-12 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:28:05', '2019-02-13 05:28:05'),
(1636, 9, '2019-02-12 18:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:28:05', '2019-02-13 05:28:05'),
(1637, 8, '2019-02-12 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:28:05', '2019-02-13 05:28:05'),
(1638, 8, '2019-02-12 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:28:05', '2019-02-13 05:28:05'),
(1639, 10, '2019-02-12 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:28:05', '2019-02-13 05:28:05'),
(1640, 10, '2019-02-12 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:28:05', '2019-02-13 05:28:05'),
(1641, 26, '2019-02-12 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:28:46', '2019-02-13 05:28:46'),
(1642, 26, '2019-02-12 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:28:46', '2019-02-13 05:28:46'),
(1643, 3, '2019-02-12 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:28:46', '2019-02-13 05:28:46'),
(1644, 3, '2019-02-12 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:28:46', '2019-02-13 05:28:46'),
(1645, 5, '2019-02-12 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:29:13', '2019-02-13 05:29:13'),
(1646, 5, '2019-02-12 18:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-13 05:29:13', '2019-02-13 05:29:13'),
(1657, 2, '2019-02-13 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:51:42', '2019-02-14 05:51:42'),
(1658, 2, '2019-02-13 18:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:51:42', '2019-02-14 05:51:42'),
(1659, 1, '2019-02-13 11:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:51:42', '2019-02-14 05:51:42'),
(1660, 1, '2019-02-13 20:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:51:42', '2019-02-14 05:51:42'),
(1661, 4, '2019-02-13 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:52:32', '2019-02-14 05:52:32'),
(1662, 4, '2019-02-13 18:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:52:32', '2019-02-14 05:52:32'),
(1663, 7, '2019-02-13 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:53:01', '2019-02-14 05:53:01'),
(1664, 7, '2019-02-13 20:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:53:01', '2019-02-14 05:53:01'),
(1665, 9, '2019-02-13 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:54:06', '2019-02-14 05:54:06'),
(1666, 9, '2019-02-13 20:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:54:06', '2019-02-14 05:54:06'),
(1667, 8, '2019-02-13 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:54:06', '2019-02-14 05:54:06'),
(1668, 8, '2019-02-13 18:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:54:06', '2019-02-14 05:54:06'),
(1669, 10, '2019-02-13 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:54:06', '2019-02-14 05:54:06'),
(1670, 10, '2019-02-13 20:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:54:06', '2019-02-14 05:54:06'),
(1671, 26, '2019-02-13 10:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:55:31', '2019-02-14 05:55:31'),
(1672, 26, '2019-02-13 17:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:55:31', '2019-02-14 05:55:31'),
(1673, 3, '2019-02-13 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:55:31', '2019-02-14 05:55:31'),
(1674, 3, '2019-02-13 20:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:55:31', '2019-02-14 05:55:31'),
(1675, 5, '2019-02-13 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:56:16', '2019-02-14 05:56:16'),
(1676, 5, '2019-02-13 20:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-14 05:56:16', '2019-02-14 05:56:16'),
(1689, 2, '2019-02-14 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:05:12', '2019-02-17 06:05:12'),
(1690, 2, '2019-02-14 19:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:05:12', '2019-02-17 06:05:12'),
(1691, 1, '2019-02-14 11:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:05:12', '2019-02-17 06:05:12'),
(1692, 1, '2019-02-14 19:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:05:12', '2019-02-17 06:05:12'),
(1693, 4, '2019-02-14 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:05:56', '2019-02-17 06:05:56'),
(1694, 4, '2019-02-14 18:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:05:56', '2019-02-17 06:05:56'),
(1695, 7, '2019-02-14 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:10:41', '2019-02-17 06:10:41'),
(1696, 7, '2019-02-14 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:10:41', '2019-02-17 06:10:41'),
(1697, 9, '2019-02-14 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:13:23', '2019-02-17 06:13:23'),
(1698, 9, '2019-02-14 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:13:23', '2019-02-17 06:13:23'),
(1699, 24, '2019-02-14 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:13:23', '2019-02-17 06:13:23'),
(1700, 24, '2019-02-14 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:13:23', '2019-02-17 06:13:23'),
(1701, 8, '2019-02-14 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:13:23', '2019-02-17 06:13:23'),
(1702, 8, '2019-02-14 18:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:13:23', '2019-02-17 06:13:23'),
(1703, 10, '2019-02-14 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:13:23', '2019-02-17 06:13:23'),
(1704, 10, '2019-02-14 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:13:23', '2019-02-17 06:13:23'),
(1705, 26, '2019-02-14 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:14:41', '2019-02-17 06:14:41'),
(1706, 26, '2019-02-14 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:14:41', '2019-02-17 06:14:41'),
(1707, 3, '2019-02-14 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:14:41', '2019-02-17 06:14:41'),
(1708, 3, '2019-02-14 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:14:41', '2019-02-17 06:14:41'),
(1709, 5, '2019-02-14 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:15:19', '2019-02-17 06:15:19'),
(1710, 5, '2019-02-14 19:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:15:19', '2019-02-17 06:15:19'),
(1711, 2, '2019-02-16 11:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:18:09', '2019-02-17 06:18:09'),
(1712, 2, '2019-02-16 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:18:09', '2019-02-17 06:18:09'),
(1713, 4, '2019-02-16 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:19:25', '2019-02-17 06:19:25'),
(1714, 4, '2019-02-16 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:19:25', '2019-02-17 06:19:25'),
(1715, 7, '2019-02-16 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:21:22', '2019-02-17 06:21:22'),
(1716, 7, '2019-02-16 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:21:22', '2019-02-17 06:21:22'),
(1717, 9, '2019-02-16 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:28:48', '2019-02-17 06:28:48'),
(1718, 9, '2019-02-16 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:28:48', '2019-02-17 06:28:48'),
(1719, 24, '2019-02-16 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:28:48', '2019-02-17 06:28:48'),
(1720, 24, '2019-02-16 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:28:48', '2019-02-17 06:28:48'),
(1721, 8, '2019-02-16 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:28:48', '2019-02-17 06:28:48'),
(1722, 8, '2019-02-16 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:28:48', '2019-02-17 06:28:48'),
(1723, 10, '2019-02-16 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:28:48', '2019-02-17 06:28:48'),
(1724, 10, '2019-02-16 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:28:48', '2019-02-17 06:28:48'),
(1725, 26, '2019-02-16 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:31:59', '2019-02-17 06:31:59'),
(1726, 26, '2019-02-16 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:31:59', '2019-02-17 06:31:59'),
(1727, 3, '2019-02-16 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:31:59', '2019-02-17 06:31:59'),
(1728, 3, '2019-02-16 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:31:59', '2019-02-17 06:31:59'),
(1729, 5, '2019-02-16 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:33:06', '2019-02-17 06:33:06'),
(1730, 5, '2019-02-16 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-17 06:33:06', '2019-02-17 06:33:06'),
(1741, 2, '2019-02-17 10:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:15:28', '2019-02-18 06:15:28'),
(1742, 2, '2019-02-17 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:15:28', '2019-02-18 06:15:28'),
(1743, 1, '2019-02-17 11:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:15:28', '2019-02-18 06:15:28'),
(1744, 1, '2019-02-17 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:15:28', '2019-02-18 06:15:28'),
(1745, 4, '2019-02-17 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:16:55', '2019-02-18 06:16:55'),
(1746, 4, '2019-02-17 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:16:55', '2019-02-18 06:16:55'),
(1747, 7, '2019-02-17 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:17:32', '2019-02-18 06:17:32'),
(1748, 7, '2019-02-17 18:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:17:32', '2019-02-18 06:17:32'),
(1749, 9, '2019-02-17 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:18:55', '2019-02-18 06:18:55'),
(1750, 9, '2019-02-17 18:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:18:55', '2019-02-18 06:18:55'),
(1751, 24, '2019-02-17 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:18:55', '2019-02-18 06:18:55'),
(1752, 24, '2019-02-17 18:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:18:55', '2019-02-18 06:18:55'),
(1753, 8, '2019-02-17 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:18:55', '2019-02-18 06:18:55'),
(1754, 8, '2019-02-17 18:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:18:55', '2019-02-18 06:18:55'),
(1755, 10, '2019-02-17 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:18:55', '2019-02-18 06:18:55'),
(1756, 10, '2019-02-17 18:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:18:55', '2019-02-18 06:18:55'),
(1757, 26, '2019-02-17 10:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:19:23', '2019-02-18 06:19:23'),
(1758, 26, '2019-02-17 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:19:23', '2019-02-18 06:19:23'),
(1759, 5, '2019-02-17 10:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:20:50', '2019-02-18 06:20:50'),
(1760, 5, '2019-02-17 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-18 06:20:50', '2019-02-18 06:20:50'),
(1773, 2, '2019-02-18 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 05:59:33', '2019-02-19 05:59:33'),
(1774, 2, '2019-02-18 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 05:59:33', '2019-02-19 05:59:33'),
(1775, 1, '2019-02-18 12:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 05:59:33', '2019-02-19 05:59:33'),
(1776, 1, '2019-02-18 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 05:59:33', '2019-02-19 05:59:33'),
(1777, 7, '2019-02-18 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:00:22', '2019-02-19 06:00:22'),
(1778, 7, '2019-02-18 17:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:00:23', '2019-02-19 06:00:23'),
(1779, 9, '2019-02-18 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:03:18', '2019-02-19 06:03:18'),
(1780, 9, '2019-02-18 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:03:18', '2019-02-19 06:03:18'),
(1781, 24, '2019-02-18 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:03:18', '2019-02-19 06:03:18'),
(1782, 24, '2019-02-18 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:03:18', '2019-02-19 06:03:18'),
(1783, 8, '2019-02-18 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:03:18', '2019-02-19 06:03:18'),
(1784, 8, '2019-02-18 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:03:18', '2019-02-19 06:03:18'),
(1785, 10, '2019-02-18 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:03:18', '2019-02-19 06:03:18'),
(1786, 10, '2019-02-18 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:03:18', '2019-02-19 06:03:18'),
(1787, 26, '2019-02-18 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:04:35', '2019-02-19 06:04:35'),
(1788, 26, '2019-02-18 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:04:35', '2019-02-19 06:04:35'),
(1789, 3, '2019-02-18 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:04:35', '2019-02-19 06:04:35'),
(1790, 3, '2019-02-18 17:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:04:35', '2019-02-19 06:04:35'),
(1791, 5, '2019-02-18 10:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:05:02', '2019-02-19 06:05:02'),
(1792, 5, '2019-02-18 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-19 06:05:02', '2019-02-19 06:05:02'),
(1803, 2, '2019-02-19 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 05:12:38', '2019-02-20 05:12:38'),
(1804, 2, '2019-02-19 20:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 05:12:38', '2019-02-20 05:12:38'),
(1805, 1, '2019-02-19 10:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 05:12:38', '2019-02-20 05:12:38'),
(1806, 1, '2019-02-19 20:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 05:12:38', '2019-02-20 05:12:38'),
(1807, 7, '2019-02-19 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 05:16:40', '2019-02-20 05:16:40'),
(1808, 7, '2019-02-19 20:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 05:16:40', '2019-02-20 05:16:40'),
(1809, 9, '2019-02-19 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:23:26', '2019-02-20 06:23:26'),
(1810, 9, '2019-02-19 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:23:26', '2019-02-20 06:23:26'),
(1811, 24, '2019-02-19 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:23:26', '2019-02-20 06:23:26'),
(1812, 24, '2019-02-19 21:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:23:26', '2019-02-20 06:23:26'),
(1813, 8, '2019-02-19 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:23:26', '2019-02-20 06:23:26'),
(1814, 8, '2019-02-19 18:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:23:26', '2019-02-20 06:23:26'),
(1815, 10, '2019-02-19 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:23:26', '2019-02-20 06:23:26'),
(1816, 10, '2019-02-19 20:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:23:26', '2019-02-20 06:23:26'),
(1817, 26, '2019-02-19 10:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:24:41', '2019-02-20 06:24:41'),
(1818, 26, '2019-02-19 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:24:41', '2019-02-20 06:24:41'),
(1819, 3, '2019-02-19 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:24:41', '2019-02-20 06:24:41'),
(1820, 3, '2019-02-19 20:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:24:41', '2019-02-20 06:24:41'),
(1821, 5, '2019-02-19 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:25:18', '2019-02-20 06:25:18'),
(1822, 5, '2019-02-19 19:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-20 06:25:18', '2019-02-20 06:25:18'),
(1833, 2, '2019-02-20 10:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:05:57', '2019-02-23 05:05:57'),
(1834, 2, '2019-02-20 19:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:05:58', '2019-02-23 05:05:58'),
(1835, 1, '2019-02-20 10:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:05:58', '2019-02-23 05:05:58'),
(1836, 1, '2019-02-20 19:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:05:58', '2019-02-23 05:05:58'),
(1837, 7, '2019-02-20 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:06:47', '2019-02-23 05:06:47'),
(1838, 7, '2019-02-20 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:06:47', '2019-02-23 05:06:47'),
(1839, 9, '2019-02-20 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:08:12', '2019-02-23 05:08:12'),
(1840, 9, '2019-02-20 19:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:08:12', '2019-02-23 05:08:12'),
(1841, 24, '2019-02-20 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:08:12', '2019-02-23 05:08:12'),
(1842, 24, '2019-02-20 19:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:08:12', '2019-02-23 05:08:12'),
(1843, 8, '2019-02-20 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:08:12', '2019-02-23 05:08:12'),
(1844, 8, '2019-02-20 19:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:08:12', '2019-02-23 05:08:12'),
(1845, 10, '2019-02-20 10:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:08:12', '2019-02-23 05:08:12'),
(1846, 10, '2019-02-20 19:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:08:12', '2019-02-23 05:08:12'),
(1847, 26, '2019-02-20 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:10:12', '2019-02-23 05:10:12'),
(1848, 26, '2019-02-20 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:10:12', '2019-02-23 05:10:12'),
(1849, 3, '2019-02-20 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:10:12', '2019-02-23 05:10:12'),
(1850, 3, '2019-02-20 19:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:10:12', '2019-02-23 05:10:12'),
(1851, 5, '2019-02-20 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:10:39', '2019-02-23 05:10:39'),
(1852, 5, '2019-02-20 19:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:10:39', '2019-02-23 05:10:39'),
(1862, 4, '2019-02-19 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:34:36', '2019-02-23 05:34:36'),
(1863, 4, '2019-02-19 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:34:37', '2019-02-23 05:34:37'),
(1864, 4, '2019-02-20 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:35:13', '2019-02-23 05:35:13'),
(1865, 4, '2019-02-20 17:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-23 05:35:13', '2019-02-23 05:35:13'),
(1866, 2, '2019-02-23 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:15:53', '2019-02-24 05:15:53'),
(1867, 2, '2019-02-23 21:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:15:53', '2019-02-24 05:15:53'),
(1868, 4, '2019-02-23 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:16:16', '2019-02-24 05:16:16'),
(1869, 4, '2019-02-23 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:16:16', '2019-02-24 05:16:16'),
(1870, 9, '2019-02-23 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:17:54', '2019-02-24 05:17:54'),
(1871, 9, '2019-02-23 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:17:54', '2019-02-24 05:17:54'),
(1872, 24, '2019-02-23 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:17:54', '2019-02-24 05:17:54'),
(1873, 24, '2019-02-23 21:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:17:54', '2019-02-24 05:17:54'),
(1874, 8, '2019-02-23 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:17:54', '2019-02-24 05:17:54'),
(1875, 8, '2019-02-23 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:17:54', '2019-02-24 05:17:54'),
(1876, 10, '2019-02-23 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:17:54', '2019-02-24 05:17:54'),
(1877, 10, '2019-02-23 21:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:17:54', '2019-02-24 05:17:54'),
(1878, 26, '2019-02-23 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:22:03', '2019-02-24 05:22:03'),
(1879, 26, '2019-02-23 20:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:22:03', '2019-02-24 05:22:03'),
(1880, 3, '2019-02-23 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:22:03', '2019-02-24 05:22:03'),
(1881, 3, '2019-02-23 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:22:03', '2019-02-24 05:22:03'),
(1882, 5, '2019-02-23 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:22:41', '2019-02-24 05:22:41'),
(1883, 5, '2019-02-23 21:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-24 05:22:41', '2019-02-24 05:22:41'),
(1896, 2, '2019-02-24 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:28:02', '2019-02-25 05:28:02'),
(1897, 2, '2019-02-24 19:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:28:02', '2019-02-25 05:28:02'),
(1898, 1, '2019-02-24 10:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:28:02', '2019-02-25 05:28:02'),
(1899, 1, '2019-02-24 20:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:28:02', '2019-02-25 05:28:02'),
(1900, 4, '2019-02-24 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:28:34', '2019-02-25 05:28:34'),
(1901, 4, '2019-02-24 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:28:34', '2019-02-25 05:28:34'),
(1902, 7, '2019-02-24 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:31:51', '2019-02-25 05:31:51'),
(1903, 7, '2019-02-24 19:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:31:51', '2019-02-25 05:31:51'),
(1904, 9, '2019-02-24 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:33:31', '2019-02-25 05:33:31'),
(1905, 9, '2019-02-24 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:33:31', '2019-02-25 05:33:31'),
(1906, 24, '2019-02-24 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:33:31', '2019-02-25 05:33:31'),
(1907, 24, '2019-02-24 20:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:33:31', '2019-02-25 05:33:31'),
(1908, 8, '2019-02-24 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:33:31', '2019-02-25 05:33:31'),
(1909, 8, '2019-02-24 19:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:33:31', '2019-02-25 05:33:31'),
(1910, 10, '2019-02-24 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:33:31', '2019-02-25 05:33:31'),
(1911, 10, '2019-02-24 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:33:31', '2019-02-25 05:33:31'),
(1912, 26, '2019-02-24 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:34:31', '2019-02-25 05:34:31'),
(1913, 26, '2019-02-24 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:34:31', '2019-02-25 05:34:31'),
(1914, 3, '2019-02-24 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:34:31', '2019-02-25 05:34:31'),
(1915, 3, '2019-02-24 19:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:34:31', '2019-02-25 05:34:31'),
(1916, 5, '2019-02-24 10:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:35:36', '2019-02-25 05:35:36'),
(1917, 5, '2019-02-24 20:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-25 05:35:36', '2019-02-25 05:35:36'),
(1930, 2, '2019-02-25 10:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 07:13:38', '2019-02-26 07:13:38'),
(1931, 2, '2019-02-25 19:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 07:13:38', '2019-02-26 07:13:38'),
(1932, 1, '2019-02-25 11:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 07:13:38', '2019-02-26 07:13:38'),
(1933, 1, '2019-02-25 19:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 07:13:38', '2019-02-26 07:13:38'),
(1934, 4, '2019-02-25 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 07:15:52', '2019-02-26 07:15:52'),
(1935, 4, '2019-02-25 20:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 07:15:52', '2019-02-26 07:15:52'),
(1936, 7, '2019-02-25 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:49:43', '2019-02-26 09:49:43'),
(1937, 7, '2019-02-25 19:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:49:43', '2019-02-26 09:49:43'),
(1938, 9, '2019-02-25 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:54:29', '2019-02-26 09:54:29'),
(1939, 9, '2019-02-25 20:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:54:30', '2019-02-26 09:54:30'),
(1940, 24, '2019-02-25 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:54:30', '2019-02-26 09:54:30'),
(1941, 24, '2019-02-25 15:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:54:30', '2019-02-26 09:54:30'),
(1942, 8, '2019-02-25 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:54:30', '2019-02-26 09:54:30'),
(1943, 8, '2019-02-25 17:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:54:30', '2019-02-26 09:54:30');
INSERT INTO `employee_attendance` (`employee_attendance_id`, `finger_print_id`, `in_out_time`, `check_type`, `verify_code`, `sensor_id`, `Memoinfo`, `WorkCode`, `sn`, `UserExtFmt`, `mechine_sl`, `created_at`, `updated_at`) VALUES
(1944, 10, '2019-02-25 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:54:30', '2019-02-26 09:54:30'),
(1945, 10, '2019-02-25 20:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:54:30', '2019-02-26 09:54:30'),
(1946, 26, '2019-02-25 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:55:15', '2019-02-26 09:55:15'),
(1947, 26, '2019-02-25 20:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:55:15', '2019-02-26 09:55:15'),
(1948, 3, '2019-02-25 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:55:15', '2019-02-26 09:55:15'),
(1949, 3, '2019-02-25 19:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:55:15', '2019-02-26 09:55:15'),
(1950, 5, '2019-02-25 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:55:46', '2019-02-26 09:55:46'),
(1951, 5, '2019-02-25 20:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-26 09:55:46', '2019-02-26 09:55:46'),
(1963, 2, '2019-02-26 10:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 04:59:54', '2019-02-27 04:59:54'),
(1964, 2, '2019-02-26 20:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 04:59:54', '2019-02-27 04:59:54'),
(1965, 1, '2019-02-26 10:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 04:59:54', '2019-02-27 04:59:54'),
(1966, 1, '2019-02-26 20:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 04:59:54', '2019-02-27 04:59:54'),
(1967, 4, '2019-02-26 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:00:30', '2019-02-27 05:00:30'),
(1968, 4, '2019-02-26 18:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:00:30', '2019-02-27 05:00:30'),
(1969, 7, '2019-02-26 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:01:01', '2019-02-27 05:01:01'),
(1970, 7, '2019-02-26 20:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:01:01', '2019-02-27 05:01:01'),
(1971, 9, '2019-02-26 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:02:56', '2019-02-27 05:02:56'),
(1972, 9, '2019-02-26 21:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:02:56', '2019-02-27 05:02:56'),
(1973, 24, '2019-02-26 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:02:56', '2019-02-27 05:02:56'),
(1974, 24, '2019-02-26 21:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:02:56', '2019-02-27 05:02:56'),
(1975, 8, '2019-02-26 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:02:56', '2019-02-27 05:02:56'),
(1976, 8, '2019-02-26 18:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:02:56', '2019-02-27 05:02:56'),
(1977, 10, '2019-02-26 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:02:56', '2019-02-27 05:02:56'),
(1978, 10, '2019-02-26 21:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:02:56', '2019-02-27 05:02:56'),
(1979, 26, '2019-02-26 10:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:04:03', '2019-02-27 05:04:03'),
(1980, 26, '2019-02-26 19:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:04:03', '2019-02-27 05:04:03'),
(1981, 3, '2019-02-26 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:04:03', '2019-02-27 05:04:03'),
(1982, 3, '2019-02-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:04:03', '2019-02-27 05:04:03'),
(1983, 5, '2019-02-26 10:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:04:36', '2019-02-27 05:04:36'),
(1984, 5, '2019-02-26 20:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-02-27 05:04:36', '2019-02-27 05:04:36'),
(1996, 1, '2019-02-27 11:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:21:33', '2019-03-02 06:21:33'),
(1997, 1, '2019-02-27 21:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:21:33', '2019-03-02 06:21:33'),
(1998, 4, '2019-02-27 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:22:10', '2019-03-02 06:22:10'),
(1999, 4, '2019-02-27 19:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:22:10', '2019-03-02 06:22:10'),
(2000, 7, '2019-02-27 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:22:48', '2019-03-02 06:22:48'),
(2001, 7, '2019-02-27 21:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:22:48', '2019-03-02 06:22:48'),
(2002, 9, '2019-02-27 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:24:28', '2019-03-02 06:24:28'),
(2003, 9, '2019-02-27 22:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:24:28', '2019-03-02 06:24:28'),
(2004, 24, '2019-02-27 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:24:28', '2019-03-02 06:24:28'),
(2005, 24, '2019-02-27 21:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:24:28', '2019-03-02 06:24:28'),
(2006, 8, '2019-02-27 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:24:28', '2019-03-02 06:24:28'),
(2007, 8, '2019-02-27 19:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:24:28', '2019-03-02 06:24:28'),
(2008, 10, '2019-02-27 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:24:28', '2019-03-02 06:24:28'),
(2009, 10, '2019-02-27 22:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:24:28', '2019-03-02 06:24:28'),
(2010, 26, '2019-02-27 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:26:28', '2019-03-02 06:26:28'),
(2011, 26, '2019-02-27 21:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:26:28', '2019-03-02 06:26:28'),
(2012, 3, '2019-02-27 10:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:26:28', '2019-03-02 06:26:28'),
(2013, 3, '2019-02-27 21:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:26:28', '2019-03-02 06:26:28'),
(2014, 2, '2019-02-27 11:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:26:28', '2019-03-02 06:26:28'),
(2015, 2, '2019-02-27 21:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:26:28', '2019-03-02 06:26:28'),
(2016, 5, '2019-02-27 10:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:26:28', '2019-03-02 06:26:28'),
(2017, 5, '2019-02-27 21:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-02 06:26:28', '2019-03-02 06:26:28'),
(2029, 1, '2019-03-02 11:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 05:37:39', '2019-03-03 05:37:39'),
(2030, 1, '2019-03-02 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 05:37:39', '2019-03-03 05:37:39'),
(2031, 4, '2019-03-02 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:05:26', '2019-03-03 07:05:26'),
(2032, 4, '2019-03-02 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:05:26', '2019-03-03 07:05:26'),
(2033, 7, '2019-03-02 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:06:00', '2019-03-03 07:06:00'),
(2034, 7, '2019-03-02 20:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:06:00', '2019-03-03 07:06:00'),
(2035, 9, '2019-03-02 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:09:02', '2019-03-03 07:09:02'),
(2036, 9, '2019-03-02 20:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:09:02', '2019-03-03 07:09:02'),
(2037, 24, '2019-03-02 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:09:02', '2019-03-03 07:09:02'),
(2038, 24, '2019-03-02 18:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:09:02', '2019-03-03 07:09:02'),
(2039, 8, '2019-03-02 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:09:02', '2019-03-03 07:09:02'),
(2040, 8, '2019-03-02 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:09:02', '2019-03-03 07:09:02'),
(2041, 10, '2019-03-02 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:09:02', '2019-03-03 07:09:02'),
(2042, 10, '2019-03-02 20:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:09:02', '2019-03-03 07:09:02'),
(2043, 26, '2019-03-02 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:10:52', '2019-03-03 07:10:52'),
(2044, 26, '2019-03-02 20:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:10:52', '2019-03-03 07:10:52'),
(2045, 3, '2019-03-02 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:10:52', '2019-03-03 07:10:52'),
(2046, 3, '2019-03-02 20:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:10:52', '2019-03-03 07:10:52'),
(2047, 2, '2019-03-02 10:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:10:52', '2019-03-03 07:10:52'),
(2048, 2, '2019-03-02 18:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:10:52', '2019-03-03 07:10:52'),
(2049, 5, '2019-03-02 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:10:52', '2019-03-03 07:10:52'),
(2050, 5, '2019-03-02 20:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-03 07:10:52', '2019-03-03 07:10:52'),
(2062, 1, '2019-03-03 11:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:23:13', '2019-03-04 07:23:13'),
(2063, 1, '2019-03-03 20:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:23:13', '2019-03-04 07:23:13'),
(2064, 4, '2019-03-03 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:23:59', '2019-03-04 07:23:59'),
(2065, 4, '2019-03-03 16:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:23:59', '2019-03-04 07:23:59'),
(2066, 7, '2019-03-03 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:24:45', '2019-03-04 07:24:45'),
(2067, 7, '2019-03-03 19:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:24:45', '2019-03-04 07:24:45'),
(2068, 9, '2019-03-03 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:27:33', '2019-03-04 07:27:33'),
(2069, 9, '2019-03-03 21:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:27:33', '2019-03-04 07:27:33'),
(2070, 24, '2019-03-03 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:27:33', '2019-03-04 07:27:33'),
(2071, 24, '2019-03-03 21:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:27:33', '2019-03-04 07:27:33'),
(2072, 8, '2019-03-03 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:27:33', '2019-03-04 07:27:33'),
(2073, 8, '2019-03-03 16:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:27:33', '2019-03-04 07:27:33'),
(2074, 10, '2019-03-03 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:27:33', '2019-03-04 07:27:33'),
(2075, 10, '2019-03-03 21:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:27:33', '2019-03-04 07:27:33'),
(2076, 26, '2019-03-03 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:29:25', '2019-03-04 07:29:25'),
(2077, 26, '2019-03-03 19:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:29:25', '2019-03-04 07:29:25'),
(2078, 3, '2019-03-03 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:29:25', '2019-03-04 07:29:25'),
(2079, 3, '2019-03-03 19:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:29:25', '2019-03-04 07:29:25'),
(2080, 2, '2019-03-03 11:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:29:25', '2019-03-04 07:29:25'),
(2081, 2, '2019-03-03 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:29:25', '2019-03-04 07:29:25'),
(2082, 5, '2019-03-03 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:29:25', '2019-03-04 07:29:25'),
(2083, 5, '2019-03-03 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-04 07:29:25', '2019-03-04 07:29:25'),
(2095, 1, '2019-03-04 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:30:59', '2019-03-05 06:30:59'),
(2096, 1, '2019-03-04 20:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:30:59', '2019-03-05 06:30:59'),
(2097, 4, '2019-03-04 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:35:23', '2019-03-05 06:35:23'),
(2098, 4, '2019-03-04 19:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:35:23', '2019-03-05 06:35:23'),
(2099, 7, '2019-03-04 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:35:55', '2019-03-05 06:35:55'),
(2100, 7, '2019-03-04 19:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:35:55', '2019-03-05 06:35:55'),
(2101, 9, '2019-03-04 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:38:48', '2019-03-05 06:38:48'),
(2102, 9, '2019-03-04 20:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:38:48', '2019-03-05 06:38:48'),
(2103, 24, '2019-03-04 09:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:38:48', '2019-03-05 06:38:48'),
(2104, 24, '2019-03-04 19:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:38:48', '2019-03-05 06:38:48'),
(2105, 8, '2019-03-04 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:38:48', '2019-03-05 06:38:48'),
(2106, 8, '2019-03-04 19:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:38:48', '2019-03-05 06:38:48'),
(2107, 10, '2019-03-04 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:38:48', '2019-03-05 06:38:48'),
(2108, 10, '2019-03-04 20:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:38:48', '2019-03-05 06:38:48'),
(2109, 26, '2019-03-04 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:40:10', '2019-03-05 06:40:10'),
(2110, 26, '2019-03-04 20:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:40:10', '2019-03-05 06:40:10'),
(2111, 3, '2019-03-04 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:40:10', '2019-03-05 06:40:10'),
(2112, 3, '2019-03-04 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:40:10', '2019-03-05 06:40:10'),
(2113, 2, '2019-03-04 10:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:40:10', '2019-03-05 06:40:10'),
(2114, 2, '2019-03-04 20:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:40:10', '2019-03-05 06:40:10'),
(2115, 5, '2019-03-04 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:40:10', '2019-03-05 06:40:10'),
(2116, 5, '2019-03-04 20:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-05 06:40:10', '2019-03-05 06:40:10'),
(2128, 1, '2019-03-05 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:10:52', '2019-03-06 06:10:52'),
(2129, 1, '2019-03-05 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:10:52', '2019-03-06 06:10:52'),
(2130, 4, '2019-03-05 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:11:28', '2019-03-06 06:11:28'),
(2131, 4, '2019-03-05 18:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:11:28', '2019-03-06 06:11:28'),
(2132, 7, '2019-03-05 11:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:12:05', '2019-03-06 06:12:05'),
(2133, 7, '2019-03-05 19:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:12:05', '2019-03-06 06:12:05'),
(2134, 9, '2019-03-05 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:14:04', '2019-03-06 06:14:04'),
(2135, 9, '2019-03-05 16:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:14:04', '2019-03-06 06:14:04'),
(2136, 24, '2019-03-05 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:14:04', '2019-03-06 06:14:04'),
(2137, 24, '2019-03-05 19:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:14:04', '2019-03-06 06:14:04'),
(2138, 8, '2019-03-05 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:14:04', '2019-03-06 06:14:04'),
(2139, 8, '2019-03-05 18:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:14:04', '2019-03-06 06:14:04'),
(2140, 10, '2019-03-05 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:14:04', '2019-03-06 06:14:04'),
(2141, 10, '2019-03-05 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:14:04', '2019-03-06 06:14:04'),
(2142, 26, '2019-03-05 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:17:01', '2019-03-06 06:17:01'),
(2143, 26, '2019-03-05 18:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:17:01', '2019-03-06 06:17:01'),
(2144, 3, '2019-03-05 11:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:17:01', '2019-03-06 06:17:01'),
(2145, 3, '2019-03-05 18:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:17:01', '2019-03-06 06:17:01'),
(2146, 2, '2019-03-05 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:17:01', '2019-03-06 06:17:01'),
(2147, 2, '2019-03-05 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:17:01', '2019-03-06 06:17:01'),
(2148, 5, '2019-03-05 10:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:17:01', '2019-03-06 06:17:01'),
(2149, 5, '2019-03-05 19:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-06 06:17:01', '2019-03-06 06:17:01'),
(2161, 1, '2019-03-06 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:48:45', '2019-03-07 06:48:45'),
(2162, 1, '2019-03-06 18:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:48:45', '2019-03-07 06:48:45'),
(2163, 4, '2019-03-06 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:49:33', '2019-03-07 06:49:33'),
(2164, 4, '2019-03-06 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:49:33', '2019-03-07 06:49:33'),
(2165, 7, '2019-03-06 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:50:39', '2019-03-07 06:50:39'),
(2166, 7, '2019-03-06 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:50:39', '2019-03-07 06:50:39'),
(2167, 9, '2019-03-06 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:51:55', '2019-03-07 06:51:55'),
(2168, 9, '2019-03-06 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:51:55', '2019-03-07 06:51:55'),
(2169, 24, '2019-03-06 09:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:51:55', '2019-03-07 06:51:55'),
(2170, 24, '2019-03-06 18:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:51:55', '2019-03-07 06:51:55'),
(2171, 8, '2019-03-06 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:51:55', '2019-03-07 06:51:55'),
(2172, 8, '2019-03-06 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:51:55', '2019-03-07 06:51:55'),
(2173, 10, '2019-03-06 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:51:55', '2019-03-07 06:51:55'),
(2174, 10, '2019-03-06 18:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:51:55', '2019-03-07 06:51:55'),
(2175, 26, '2019-03-06 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:53:26', '2019-03-07 06:53:26'),
(2176, 26, '2019-03-06 18:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:53:27', '2019-03-07 06:53:27'),
(2177, 3, '2019-03-06 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:53:27', '2019-03-07 06:53:27'),
(2178, 3, '2019-03-06 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:53:27', '2019-03-07 06:53:27'),
(2179, 2, '2019-03-06 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:53:27', '2019-03-07 06:53:27'),
(2180, 2, '2019-03-06 18:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:53:27', '2019-03-07 06:53:27'),
(2181, 5, '2019-03-06 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:53:27', '2019-03-07 06:53:27'),
(2182, 5, '2019-03-06 18:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-07 06:53:27', '2019-03-07 06:53:27'),
(2198, 1, '2019-03-07 11:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:25:56', '2019-03-09 09:25:56'),
(2199, 1, '2019-03-07 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:25:56', '2019-03-09 09:25:56'),
(2200, 4, '2019-03-07 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:26:28', '2019-03-09 09:26:28'),
(2201, 4, '2019-03-07 17:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:26:28', '2019-03-09 09:26:28'),
(2202, 7, '2019-03-07 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:27:22', '2019-03-09 09:27:22'),
(2203, 7, '2019-03-07 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:27:22', '2019-03-09 09:27:22'),
(2204, 9, '2019-03-07 09:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:31:50', '2019-03-09 09:31:50'),
(2205, 9, '2019-03-07 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:31:50', '2019-03-09 09:31:50'),
(2206, 24, '2019-03-07 09:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:31:50', '2019-03-09 09:31:50'),
(2207, 24, '2019-03-07 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:31:50', '2019-03-09 09:31:50'),
(2208, 8, '2019-03-07 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:31:50', '2019-03-09 09:31:50'),
(2209, 8, '2019-03-07 17:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:31:50', '2019-03-09 09:31:50'),
(2210, 10, '2019-03-07 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:31:50', '2019-03-09 09:31:50'),
(2211, 10, '2019-03-07 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:31:50', '2019-03-09 09:31:50'),
(2212, 26, '2019-03-07 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:33:20', '2019-03-09 09:33:20'),
(2213, 26, '2019-03-07 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:33:20', '2019-03-09 09:33:20'),
(2214, 3, '2019-03-07 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:33:20', '2019-03-09 09:33:20'),
(2215, 3, '2019-03-07 18:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:33:20', '2019-03-09 09:33:20'),
(2216, 2, '2019-03-07 10:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:33:20', '2019-03-09 09:33:20'),
(2217, 2, '2019-03-07 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:33:20', '2019-03-09 09:33:20'),
(2218, 5, '2019-03-07 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:33:20', '2019-03-09 09:33:20'),
(2219, 5, '2019-03-07 17:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-09 09:33:20', '2019-03-09 09:33:20'),
(2230, 1, '2019-03-09 11:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:23:55', '2019-03-10 10:23:55'),
(2231, 1, '2019-03-09 18:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:23:55', '2019-03-10 10:23:55'),
(2232, 4, '2019-03-09 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:24:50', '2019-03-10 10:24:50'),
(2233, 4, '2019-03-09 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:24:50', '2019-03-10 10:24:50'),
(2234, 7, '2019-03-09 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:34:21', '2019-03-10 10:34:21'),
(2235, 7, '2019-03-09 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:34:21', '2019-03-10 10:34:21'),
(2236, 9, '2019-03-09 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:36:07', '2019-03-10 10:36:07'),
(2237, 9, '2019-03-09 22:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:36:07', '2019-03-10 10:36:07'),
(2238, 24, '2019-03-09 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:36:07', '2019-03-10 10:36:07'),
(2239, 24, '2019-03-09 22:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:36:07', '2019-03-10 10:36:07'),
(2240, 8, '2019-03-09 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:36:07', '2019-03-10 10:36:07'),
(2241, 8, '2019-03-09 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:36:07', '2019-03-10 10:36:07'),
(2242, 10, '2019-03-09 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:36:07', '2019-03-10 10:36:07'),
(2243, 10, '2019-03-09 22:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:36:07', '2019-03-10 10:36:07'),
(2244, 3, '2019-03-09 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:39:24', '2019-03-10 10:39:24'),
(2245, 3, '2019-03-09 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:39:24', '2019-03-10 10:39:24'),
(2246, 2, '2019-03-09 10:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:39:24', '2019-03-10 10:39:24'),
(2247, 2, '2019-03-09 17:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:39:24', '2019-03-10 10:39:24'),
(2248, 5, '2019-03-09 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:39:24', '2019-03-10 10:39:24'),
(2249, 5, '2019-03-09 17:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-10 10:39:24', '2019-03-10 10:39:24'),
(2261, 1, '2019-03-10 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 05:55:13', '2019-03-12 05:55:13'),
(2262, 1, '2019-03-10 19:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 05:55:13', '2019-03-12 05:55:13'),
(2263, 4, '2019-03-10 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 05:55:49', '2019-03-12 05:55:49'),
(2264, 4, '2019-03-10 17:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 05:55:49', '2019-03-12 05:55:49'),
(2265, 7, '2019-03-10 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 05:56:31', '2019-03-12 05:56:31'),
(2266, 7, '2019-03-10 20:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 05:56:31', '2019-03-12 05:56:31'),
(2267, 9, '2019-03-10 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:30:01', '2019-03-12 06:30:01'),
(2268, 9, '2019-03-10 20:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:30:01', '2019-03-12 06:30:01'),
(2269, 24, '2019-03-10 09:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:30:01', '2019-03-12 06:30:01'),
(2270, 24, '2019-03-10 20:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:30:01', '2019-03-12 06:30:01'),
(2271, 8, '2019-03-10 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:30:01', '2019-03-12 06:30:01'),
(2272, 8, '2019-03-10 17:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:30:01', '2019-03-12 06:30:01'),
(2273, 10, '2019-03-10 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:30:01', '2019-03-12 06:30:01'),
(2274, 10, '2019-03-10 20:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:30:01', '2019-03-12 06:30:01'),
(2275, 26, '2019-03-10 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:31:02', '2019-03-12 06:31:02'),
(2276, 26, '2019-03-10 20:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:31:02', '2019-03-12 06:31:02'),
(2277, 3, '2019-03-10 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:31:02', '2019-03-12 06:31:02'),
(2278, 3, '2019-03-10 20:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:31:02', '2019-03-12 06:31:02'),
(2279, 2, '2019-03-10 10:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:31:02', '2019-03-12 06:31:02'),
(2280, 2, '2019-03-10 17:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:31:02', '2019-03-12 06:31:02'),
(2281, 5, '2019-03-10 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:31:02', '2019-03-12 06:31:02'),
(2282, 5, '2019-03-10 20:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:31:02', '2019-03-12 06:31:02'),
(2283, 1, '2019-03-11 11:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:32:03', '2019-03-12 06:32:03'),
(2284, 1, '2019-03-11 17:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:32:03', '2019-03-12 06:32:03'),
(2285, 7, '2019-03-11 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:33:06', '2019-03-12 06:33:06'),
(2286, 7, '2019-03-11 18:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:33:06', '2019-03-12 06:33:06'),
(2287, 9, '2019-03-11 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:36:18', '2019-03-12 06:36:18'),
(2288, 9, '2019-03-11 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:36:18', '2019-03-12 06:36:18'),
(2289, 24, '2019-03-11 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:36:18', '2019-03-12 06:36:18'),
(2290, 24, '2019-03-11 18:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:36:18', '2019-03-12 06:36:18'),
(2291, 10, '2019-03-11 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:36:18', '2019-03-12 06:36:18'),
(2292, 10, '2019-03-11 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 06:36:18', '2019-03-12 06:36:18'),
(2311, 26, '2019-03-11 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 11:51:50', '2019-03-12 11:51:50'),
(2312, 26, '2019-03-11 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 11:51:50', '2019-03-12 11:51:50'),
(2313, 3, '2019-03-11 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 11:51:50', '2019-03-12 11:51:50'),
(2314, 3, '2019-03-11 18:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 11:51:50', '2019-03-12 11:51:50'),
(2315, 2, '2019-03-11 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 11:51:50', '2019-03-12 11:51:50'),
(2316, 2, '2019-03-11 18:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 11:51:50', '2019-03-12 11:51:50'),
(2317, 5, '2019-03-11 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 11:51:50', '2019-03-12 11:51:50'),
(2318, 5, '2019-03-11 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-12 11:51:50', '2019-03-12 11:51:50'),
(2323, 1, '2019-03-12 11:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:04:27', '2019-03-13 06:04:27'),
(2324, 1, '2019-03-12 19:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:04:27', '2019-03-13 06:04:27'),
(2325, 4, '2019-03-12 10:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:04:57', '2019-03-13 06:04:57'),
(2326, 4, '2019-03-12 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:04:57', '2019-03-13 06:04:57'),
(2327, 7, '2019-03-12 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:05:26', '2019-03-13 06:05:26'),
(2328, 7, '2019-03-12 19:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:05:26', '2019-03-13 06:05:26'),
(2329, 9, '2019-03-12 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:06:35', '2019-03-13 06:06:35'),
(2330, 9, '2019-03-12 20:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:06:35', '2019-03-13 06:06:35'),
(2331, 24, '2019-03-12 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:06:35', '2019-03-13 06:06:35'),
(2332, 24, '2019-03-12 20:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:06:35', '2019-03-13 06:06:35'),
(2333, 8, '2019-03-12 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:06:35', '2019-03-13 06:06:35'),
(2334, 8, '2019-03-12 18:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:06:35', '2019-03-13 06:06:35'),
(2335, 10, '2019-03-12 10:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:06:35', '2019-03-13 06:06:35'),
(2336, 10, '2019-03-12 20:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:06:35', '2019-03-13 06:06:35'),
(2337, 26, '2019-03-12 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:14:29', '2019-03-13 06:14:29'),
(2338, 26, '2019-03-12 18:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:14:29', '2019-03-13 06:14:29'),
(2339, 3, '2019-03-12 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:14:29', '2019-03-13 06:14:29'),
(2340, 3, '2019-03-12 19:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:14:29', '2019-03-13 06:14:29'),
(2341, 2, '2019-03-12 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:14:29', '2019-03-13 06:14:29'),
(2342, 2, '2019-03-12 19:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:14:29', '2019-03-13 06:14:29'),
(2343, 5, '2019-03-12 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:14:29', '2019-03-13 06:14:29'),
(2344, 5, '2019-03-12 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-13 06:14:29', '2019-03-13 06:14:29'),
(2355, 1, '2019-03-13 11:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:55:21', '2019-03-14 07:55:21'),
(2356, 1, '2019-03-13 19:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:55:21', '2019-03-14 07:55:21'),
(2357, 4, '2019-03-13 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:55:49', '2019-03-14 07:55:49'),
(2358, 4, '2019-03-13 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:55:49', '2019-03-14 07:55:49'),
(2359, 7, '2019-03-13 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:56:25', '2019-03-14 07:56:25'),
(2360, 7, '2019-03-13 19:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:56:25', '2019-03-14 07:56:25'),
(2361, 9, '2019-03-13 09:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:58:13', '2019-03-14 07:58:13'),
(2362, 9, '2019-03-13 20:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:58:13', '2019-03-14 07:58:13'),
(2363, 24, '2019-03-13 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:58:13', '2019-03-14 07:58:13'),
(2364, 24, '2019-03-13 20:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:58:13', '2019-03-14 07:58:13'),
(2365, 8, '2019-03-13 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:58:13', '2019-03-14 07:58:13'),
(2366, 8, '2019-03-13 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:58:13', '2019-03-14 07:58:13'),
(2367, 10, '2019-03-13 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:58:13', '2019-03-14 07:58:13'),
(2368, 10, '2019-03-13 20:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:58:13', '2019-03-14 07:58:13'),
(2369, 26, '2019-03-13 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:59:49', '2019-03-14 07:59:49'),
(2370, 26, '2019-03-13 17:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:59:49', '2019-03-14 07:59:49'),
(2371, 3, '2019-03-13 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:59:49', '2019-03-14 07:59:49'),
(2372, 3, '2019-03-13 19:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:59:49', '2019-03-14 07:59:49'),
(2373, 2, '2019-03-13 11:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:59:49', '2019-03-14 07:59:49'),
(2374, 2, '2019-03-13 19:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-14 07:59:49', '2019-03-14 07:59:49'),
(2386, 1, '2019-03-14 11:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:37:14', '2019-03-18 09:37:14'),
(2387, 1, '2019-03-14 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:37:14', '2019-03-18 09:37:14'),
(2388, 4, '2019-03-14 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:37:37', '2019-03-18 09:37:37'),
(2389, 4, '2019-03-14 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:37:37', '2019-03-18 09:37:37'),
(2390, 4, '2019-03-14 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:37:37', '2019-03-18 09:37:37'),
(2391, 4, '2019-03-14 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:37:37', '2019-03-18 09:37:37'),
(2392, 7, '2019-03-14 10:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:38:02', '2019-03-18 09:38:02'),
(2393, 7, '2019-03-14 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:38:02', '2019-03-18 09:38:02'),
(2394, 9, '2019-03-14 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:40:55', '2019-03-18 09:40:55'),
(2395, 9, '2019-03-14 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:40:55', '2019-03-18 09:40:55'),
(2396, 24, '2019-03-14 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:40:55', '2019-03-18 09:40:55'),
(2397, 24, '2019-03-14 19:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:40:55', '2019-03-18 09:40:55'),
(2398, 8, '2019-03-14 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:40:55', '2019-03-18 09:40:55'),
(2399, 8, '2019-03-14 19:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:40:55', '2019-03-18 09:40:55'),
(2400, 10, '2019-03-14 09:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:40:55', '2019-03-18 09:40:55'),
(2401, 10, '2019-03-14 19:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:40:55', '2019-03-18 09:40:55'),
(2402, 26, '2019-03-14 10:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:41:59', '2019-03-18 09:41:59'),
(2403, 26, '2019-03-14 19:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:41:59', '2019-03-18 09:41:59'),
(2404, 3, '2019-03-14 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:41:59', '2019-03-18 09:41:59'),
(2405, 3, '2019-03-14 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:41:59', '2019-03-18 09:41:59'),
(2406, 2, '2019-03-14 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:41:59', '2019-03-18 09:41:59'),
(2407, 2, '2019-03-14 19:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:41:59', '2019-03-18 09:41:59'),
(2408, 5, '2019-03-14 10:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:41:59', '2019-03-18 09:41:59'),
(2409, 5, '2019-03-14 19:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-18 09:41:59', '2019-03-18 09:41:59'),
(2419, 1, '2019-03-18 12:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:53:16', '2019-03-19 08:53:16'),
(2420, 1, '2019-03-18 19:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:53:16', '2019-03-19 08:53:16'),
(2421, 4, '2019-03-18 11:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:53:44', '2019-03-19 08:53:44'),
(2422, 4, '2019-03-18 19:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:53:44', '2019-03-19 08:53:44'),
(2423, 7, '2019-03-18 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:54:19', '2019-03-19 08:54:19'),
(2424, 7, '2019-03-18 19:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:54:19', '2019-03-19 08:54:19'),
(2425, 8, '2019-03-18 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:56:30', '2019-03-19 08:56:30'),
(2426, 8, '2019-03-18 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:56:30', '2019-03-19 08:56:30'),
(2427, 10, '2019-03-18 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:56:30', '2019-03-19 08:56:30'),
(2428, 10, '2019-03-18 20:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:56:30', '2019-03-19 08:56:30'),
(2429, 26, '2019-03-18 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:58:18', '2019-03-19 08:58:18'),
(2430, 26, '2019-03-18 18:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:58:18', '2019-03-19 08:58:18'),
(2431, 3, '2019-03-18 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:58:18', '2019-03-19 08:58:18'),
(2432, 3, '2019-03-18 19:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:58:18', '2019-03-19 08:58:18'),
(2433, 2, '2019-03-18 11:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:58:18', '2019-03-19 08:58:18'),
(2434, 2, '2019-03-18 19:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:58:18', '2019-03-19 08:58:18'),
(2435, 5, '2019-03-18 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:58:18', '2019-03-19 08:58:18'),
(2436, 5, '2019-03-18 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-19 08:58:18', '2019-03-19 08:58:18'),
(2447, 1, '2019-03-19 11:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:30:56', '2019-03-20 07:30:56'),
(2448, 1, '2019-03-19 20:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:30:56', '2019-03-20 07:30:56'),
(2449, 4, '2019-03-19 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:31:37', '2019-03-20 07:31:37'),
(2450, 4, '2019-03-19 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:31:37', '2019-03-20 07:31:37'),
(2451, 7, '2019-03-19 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:32:32', '2019-03-20 07:32:32'),
(2452, 7, '2019-03-19 20:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:32:32', '2019-03-20 07:32:32'),
(2453, 24, '2019-03-19 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:34:55', '2019-03-20 07:34:55'),
(2454, 24, '2019-03-19 22:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:34:55', '2019-03-20 07:34:55'),
(2455, 8, '2019-03-19 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:34:55', '2019-03-20 07:34:55'),
(2456, 8, '2019-03-19 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:34:55', '2019-03-20 07:34:55'),
(2457, 10, '2019-03-19 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:34:55', '2019-03-20 07:34:55'),
(2458, 10, '2019-03-19 22:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:34:55', '2019-03-20 07:34:55'),
(2459, 26, '2019-03-19 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:38:45', '2019-03-20 07:38:45'),
(2460, 26, '2019-03-19 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:38:45', '2019-03-20 07:38:45'),
(2461, 3, '2019-03-19 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:38:45', '2019-03-20 07:38:45'),
(2462, 3, '2019-03-19 20:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:38:45', '2019-03-20 07:38:45'),
(2463, 2, '2019-03-19 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:38:45', '2019-03-20 07:38:45'),
(2464, 2, '2019-03-19 20:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:38:45', '2019-03-20 07:38:45'),
(2465, 5, '2019-03-19 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:38:45', '2019-03-20 07:38:45'),
(2466, 5, '2019-03-19 20:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-20 07:38:45', '2019-03-20 07:38:45'),
(2478, 1, '2019-03-20 11:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:46:19', '2019-03-21 08:46:19'),
(2479, 1, '2019-03-20 17:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:46:19', '2019-03-21 08:46:19'),
(2480, 4, '2019-03-20 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:46:56', '2019-03-21 08:46:56'),
(2481, 4, '2019-03-20 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:46:56', '2019-03-21 08:46:56'),
(2482, 7, '2019-03-20 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:47:44', '2019-03-21 08:47:44'),
(2483, 7, '2019-03-20 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:47:44', '2019-03-21 08:47:44'),
(2484, 9, '2019-03-20 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:49:13', '2019-03-21 08:49:13'),
(2485, 9, '2019-03-20 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:49:13', '2019-03-21 08:49:13'),
(2486, 24, '2019-03-20 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:49:13', '2019-03-21 08:49:13'),
(2487, 24, '2019-03-20 21:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:49:13', '2019-03-21 08:49:13'),
(2488, 8, '2019-03-20 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:49:13', '2019-03-21 08:49:13'),
(2489, 8, '2019-03-20 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:49:13', '2019-03-21 08:49:13'),
(2490, 10, '2019-03-20 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:49:13', '2019-03-21 08:49:13'),
(2491, 10, '2019-03-20 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:49:13', '2019-03-21 08:49:13'),
(2492, 26, '2019-03-20 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:50:33', '2019-03-21 08:50:33'),
(2493, 26, '2019-03-20 18:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:50:33', '2019-03-21 08:50:33'),
(2494, 3, '2019-03-20 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:50:33', '2019-03-21 08:50:33'),
(2495, 3, '2019-03-20 21:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:50:33', '2019-03-21 08:50:33'),
(2496, 2, '2019-03-20 11:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:50:33', '2019-03-21 08:50:33'),
(2497, 2, '2019-03-20 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:50:33', '2019-03-21 08:50:33'),
(2498, 5, '2019-03-20 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:50:33', '2019-03-21 08:50:33'),
(2499, 5, '2019-03-20 18:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-21 08:50:33', '2019-03-21 08:50:33'),
(2510, 4, '2019-03-21 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:00:10', '2019-03-23 05:00:10'),
(2511, 4, '2019-03-21 18:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:00:10', '2019-03-23 05:00:10'),
(2512, 7, '2019-03-21 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:01:26', '2019-03-23 05:01:26'),
(2513, 7, '2019-03-21 19:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:01:26', '2019-03-23 05:01:26'),
(2514, 9, '2019-03-21 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:04:33', '2019-03-23 05:04:33'),
(2515, 9, '2019-03-21 20:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:04:33', '2019-03-23 05:04:33'),
(2516, 24, '2019-03-21 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:04:33', '2019-03-23 05:04:33'),
(2517, 24, '2019-03-21 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:04:33', '2019-03-23 05:04:33'),
(2518, 8, '2019-03-21 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:04:33', '2019-03-23 05:04:33'),
(2519, 8, '2019-03-21 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:04:33', '2019-03-23 05:04:33'),
(2520, 10, '2019-03-21 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:04:33', '2019-03-23 05:04:33'),
(2521, 10, '2019-03-21 20:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:04:33', '2019-03-23 05:04:33'),
(2522, 26, '2019-03-21 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:06:09', '2019-03-23 05:06:09'),
(2523, 26, '2019-03-21 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:06:09', '2019-03-23 05:06:09'),
(2524, 3, '2019-03-21 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:06:09', '2019-03-23 05:06:09'),
(2525, 3, '2019-03-21 20:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:06:09', '2019-03-23 05:06:09'),
(2526, 2, '2019-03-21 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:06:09', '2019-03-23 05:06:09'),
(2527, 2, '2019-03-21 20:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:06:09', '2019-03-23 05:06:09'),
(2528, 5, '2019-03-21 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:06:09', '2019-03-23 05:06:09'),
(2529, 5, '2019-03-21 19:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:06:09', '2019-03-23 05:06:09'),
(2530, 3, '2019-03-22 15:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:07:57', '2019-03-23 05:07:57'),
(2531, 3, '2019-03-22 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:07:57', '2019-03-23 05:07:57'),
(2532, 9, '2019-03-22 15:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:08:38', '2019-03-23 05:08:38'),
(2533, 9, '2019-03-22 22:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-23 05:08:38', '2019-03-23 05:08:38');
INSERT INTO `employee_attendance` (`employee_attendance_id`, `finger_print_id`, `in_out_time`, `check_type`, `verify_code`, `sensor_id`, `Memoinfo`, `WorkCode`, `sn`, `UserExtFmt`, `mechine_sl`, `created_at`, `updated_at`) VALUES
(2545, 1, '2019-03-23 10:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:29:27', '2019-03-24 05:29:27'),
(2546, 1, '2019-03-23 19:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:29:27', '2019-03-24 05:29:27'),
(2547, 4, '2019-03-23 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:31:51', '2019-03-24 05:31:51'),
(2548, 4, '2019-03-23 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:31:52', '2019-03-24 05:31:52'),
(2549, 7, '2019-03-23 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:32:30', '2019-03-24 05:32:30'),
(2550, 7, '2019-03-23 20:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:32:30', '2019-03-24 05:32:30'),
(2551, 9, '2019-03-23 09:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:34:39', '2019-03-24 05:34:39'),
(2552, 9, '2019-03-23 20:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:34:39', '2019-03-24 05:34:39'),
(2553, 24, '2019-03-23 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:34:39', '2019-03-24 05:34:39'),
(2554, 24, '2019-03-23 20:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:34:39', '2019-03-24 05:34:39'),
(2555, 8, '2019-03-23 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:34:39', '2019-03-24 05:34:39'),
(2556, 8, '2019-03-23 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:34:39', '2019-03-24 05:34:39'),
(2557, 10, '2019-03-23 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:34:39', '2019-03-24 05:34:39'),
(2558, 10, '2019-03-23 20:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:34:39', '2019-03-24 05:34:39'),
(2567, 26, '2019-03-23 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:36:49', '2019-03-24 05:36:49'),
(2568, 26, '2019-03-23 20:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:36:49', '2019-03-24 05:36:49'),
(2569, 3, '2019-03-23 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:36:49', '2019-03-24 05:36:49'),
(2570, 3, '2019-03-23 20:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:36:49', '2019-03-24 05:36:49'),
(2571, 2, '2019-03-23 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:36:49', '2019-03-24 05:36:49'),
(2572, 2, '2019-03-23 20:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:36:49', '2019-03-24 05:36:49'),
(2573, 5, '2019-03-23 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:36:49', '2019-03-24 05:36:49'),
(2574, 5, '2019-03-23 20:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-24 05:36:49', '2019-03-24 05:36:49'),
(2589, 1, '2019-03-24 11:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:49:58', '2019-03-25 05:49:58'),
(2590, 1, '2019-03-24 21:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:49:58', '2019-03-25 05:49:58'),
(2591, 4, '2019-03-24 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:56:06', '2019-03-25 05:56:06'),
(2592, 4, '2019-03-24 20:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:56:06', '2019-03-25 05:56:06'),
(2593, 7, '2019-03-24 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:56:28', '2019-03-25 05:56:28'),
(2594, 7, '2019-03-24 21:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:56:28', '2019-03-25 05:56:28'),
(2595, 9, '2019-03-24 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:57:49', '2019-03-25 05:57:49'),
(2596, 9, '2019-03-24 22:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:57:49', '2019-03-25 05:57:49'),
(2597, 24, '2019-03-24 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:57:49', '2019-03-25 05:57:49'),
(2598, 24, '2019-03-24 21:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:57:49', '2019-03-25 05:57:49'),
(2599, 8, '2019-03-24 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:57:49', '2019-03-25 05:57:49'),
(2600, 8, '2019-03-24 18:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:57:49', '2019-03-25 05:57:49'),
(2601, 10, '2019-03-24 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:57:49', '2019-03-25 05:57:49'),
(2602, 10, '2019-03-24 22:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:57:49', '2019-03-25 05:57:49'),
(2603, 26, '2019-03-24 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:59:12', '2019-03-25 05:59:12'),
(2604, 26, '2019-03-24 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:59:12', '2019-03-25 05:59:12'),
(2605, 3, '2019-03-24 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:59:12', '2019-03-25 05:59:12'),
(2606, 3, '2019-03-24 21:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:59:12', '2019-03-25 05:59:12'),
(2607, 2, '2019-03-24 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:59:12', '2019-03-25 05:59:12'),
(2608, 2, '2019-03-24 21:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:59:12', '2019-03-25 05:59:12'),
(2609, 5, '2019-03-24 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:59:12', '2019-03-25 05:59:12'),
(2610, 5, '2019-03-24 20:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-25 05:59:12', '2019-03-25 05:59:12'),
(2622, 1, '2019-03-25 13:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:34:10', '2019-03-27 08:34:10'),
(2623, 1, '2019-03-25 18:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:34:10', '2019-03-27 08:34:10'),
(2624, 4, '2019-03-25 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:35:03', '2019-03-27 08:35:03'),
(2625, 4, '2019-03-25 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:35:03', '2019-03-27 08:35:03'),
(2626, 7, '2019-03-25 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:35:36', '2019-03-27 08:35:36'),
(2627, 7, '2019-03-25 17:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:35:36', '2019-03-27 08:35:36'),
(2628, 9, '2019-03-25 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:37:12', '2019-03-27 08:37:12'),
(2629, 9, '2019-03-25 18:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:37:12', '2019-03-27 08:37:12'),
(2630, 24, '2019-03-25 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:37:12', '2019-03-27 08:37:12'),
(2631, 24, '2019-03-25 12:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:37:12', '2019-03-27 08:37:12'),
(2632, 8, '2019-03-25 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:37:12', '2019-03-27 08:37:12'),
(2633, 8, '2019-03-25 18:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:37:12', '2019-03-27 08:37:12'),
(2634, 10, '2019-03-25 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:37:12', '2019-03-27 08:37:12'),
(2635, 10, '2019-03-25 18:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:37:12', '2019-03-27 08:37:12'),
(2636, 26, '2019-03-25 11:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:38:51', '2019-03-27 08:38:51'),
(2637, 26, '2019-03-25 17:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:38:51', '2019-03-27 08:38:51'),
(2638, 3, '2019-03-25 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:38:51', '2019-03-27 08:38:51'),
(2639, 3, '2019-03-25 18:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:38:51', '2019-03-27 08:38:51'),
(2640, 2, '2019-03-25 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:38:51', '2019-03-27 08:38:51'),
(2641, 2, '2019-03-25 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:38:51', '2019-03-27 08:38:51'),
(2642, 5, '2019-03-25 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:38:51', '2019-03-27 08:38:51'),
(2643, 5, '2019-03-25 17:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-27 08:38:51', '2019-03-27 08:38:51'),
(2653, 1, '2019-03-27 11:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:31:10', '2019-03-28 05:31:10'),
(2654, 1, '2019-03-27 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:31:10', '2019-03-28 05:31:10'),
(2655, 4, '2019-03-27 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:31:44', '2019-03-28 05:31:44'),
(2656, 4, '2019-03-27 18:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:31:44', '2019-03-28 05:31:44'),
(2657, 9, '2019-03-27 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:33:15', '2019-03-28 05:33:15'),
(2658, 9, '2019-03-27 18:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:33:15', '2019-03-28 05:33:15'),
(2659, 24, '2019-03-27 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:33:15', '2019-03-28 05:33:15'),
(2660, 24, '2019-03-27 18:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:33:15', '2019-03-28 05:33:15'),
(2661, 8, '2019-03-27 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:33:15', '2019-03-28 05:33:15'),
(2662, 8, '2019-03-27 18:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:33:15', '2019-03-28 05:33:15'),
(2663, 26, '2019-03-27 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:34:41', '2019-03-28 05:34:41'),
(2664, 26, '2019-03-27 18:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:34:41', '2019-03-28 05:34:41'),
(2665, 3, '2019-03-27 10:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:34:41', '2019-03-28 05:34:41'),
(2666, 3, '2019-03-27 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:34:41', '2019-03-28 05:34:41'),
(2667, 2, '2019-03-27 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:34:41', '2019-03-28 05:34:41'),
(2668, 2, '2019-03-27 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:34:41', '2019-03-28 05:34:41'),
(2669, 5, '2019-03-27 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:34:41', '2019-03-28 05:34:41'),
(2670, 5, '2019-03-27 18:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-28 05:34:41', '2019-03-28 05:34:41'),
(2681, 1, '2019-03-28 11:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:25:16', '2019-03-30 06:25:16'),
(2682, 1, '2019-03-28 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:25:16', '2019-03-30 06:25:16'),
(2683, 4, '2019-03-28 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:25:57', '2019-03-30 06:25:57'),
(2684, 4, '2019-03-28 18:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:25:57', '2019-03-30 06:25:57'),
(2685, 9, '2019-03-28 09:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:27:43', '2019-03-30 06:27:43'),
(2686, 9, '2019-03-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:27:43', '2019-03-30 06:27:43'),
(2687, 24, '2019-03-28 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:27:43', '2019-03-30 06:27:43'),
(2688, 24, '2019-03-28 18:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:27:43', '2019-03-30 06:27:43'),
(2689, 8, '2019-03-28 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:27:43', '2019-03-30 06:27:43'),
(2690, 8, '2019-03-28 18:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:27:43', '2019-03-30 06:27:43'),
(2691, 10, '2019-03-28 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:27:43', '2019-03-30 06:27:43'),
(2692, 10, '2019-03-28 18:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:27:43', '2019-03-30 06:27:43'),
(2693, 26, '2019-03-28 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:29:10', '2019-03-30 06:29:10'),
(2694, 26, '2019-03-28 18:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:29:10', '2019-03-30 06:29:10'),
(2695, 3, '2019-03-28 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:29:10', '2019-03-30 06:29:10'),
(2696, 3, '2019-03-28 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:29:10', '2019-03-30 06:29:10'),
(2697, 2, '2019-03-28 10:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:29:10', '2019-03-30 06:29:10'),
(2698, 2, '2019-03-28 18:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:29:10', '2019-03-30 06:29:10'),
(2699, 5, '2019-03-28 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:29:10', '2019-03-30 06:29:10'),
(2700, 5, '2019-03-28 18:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-30 06:29:10', '2019-03-30 06:29:10'),
(2710, 4, '2019-03-30 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:19:05', '2019-03-31 05:19:05'),
(2711, 4, '2019-03-30 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:19:05', '2019-03-31 05:19:05'),
(2712, 7, '2019-03-30 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:19:50', '2019-03-31 05:19:50'),
(2713, 7, '2019-03-30 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:19:50', '2019-03-31 05:19:50'),
(2714, 24, '2019-03-30 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:21:13', '2019-03-31 05:21:13'),
(2715, 24, '2019-03-30 18:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:21:13', '2019-03-31 05:21:13'),
(2716, 8, '2019-03-30 09:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:21:13', '2019-03-31 05:21:13'),
(2717, 8, '2019-03-30 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:21:13', '2019-03-31 05:21:13'),
(2718, 10, '2019-03-30 09:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:21:13', '2019-03-31 05:21:13'),
(2719, 10, '2019-03-30 18:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:21:13', '2019-03-31 05:21:13'),
(2720, 26, '2019-03-30 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:22:45', '2019-03-31 05:22:45'),
(2721, 26, '2019-03-30 17:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:22:45', '2019-03-31 05:22:45'),
(2722, 3, '2019-03-30 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:22:45', '2019-03-31 05:22:45'),
(2723, 3, '2019-03-30 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:22:45', '2019-03-31 05:22:45'),
(2724, 2, '2019-03-30 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:22:45', '2019-03-31 05:22:45'),
(2725, 2, '2019-03-30 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:22:45', '2019-03-31 05:22:45'),
(2726, 5, '2019-03-30 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:22:45', '2019-03-31 05:22:45'),
(2727, 5, '2019-03-30 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-31 05:22:45', '2019-03-31 05:22:45'),
(2739, 1, '2019-03-31 11:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:22:34', '2019-04-01 05:22:34'),
(2740, 1, '2019-03-31 20:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:22:34', '2019-04-01 05:22:34'),
(2741, 4, '2019-03-31 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:23:11', '2019-04-01 05:23:11'),
(2742, 4, '2019-03-31 16:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:23:11', '2019-04-01 05:23:11'),
(2743, 7, '2019-03-31 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:23:35', '2019-04-01 05:23:35'),
(2744, 7, '2019-03-31 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:23:35', '2019-04-01 05:23:35'),
(2745, 9, '2019-03-31 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:25:00', '2019-04-01 05:25:00'),
(2746, 9, '2019-03-31 20:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:25:00', '2019-04-01 05:25:00'),
(2747, 24, '2019-03-31 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:25:00', '2019-04-01 05:25:00'),
(2748, 24, '2019-03-31 20:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:25:00', '2019-04-01 05:25:00'),
(2749, 8, '2019-03-31 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:25:00', '2019-04-01 05:25:00'),
(2750, 8, '2019-03-31 16:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:25:00', '2019-04-01 05:25:00'),
(2751, 10, '2019-03-31 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:25:00', '2019-04-01 05:25:00'),
(2752, 10, '2019-03-31 20:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:25:00', '2019-04-01 05:25:00'),
(2753, 26, '2019-03-31 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:26:41', '2019-04-01 05:26:41'),
(2754, 26, '2019-03-31 20:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:26:41', '2019-04-01 05:26:41'),
(2755, 3, '2019-03-31 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:26:41', '2019-04-01 05:26:41'),
(2756, 3, '2019-03-31 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:26:41', '2019-04-01 05:26:41'),
(2757, 2, '2019-03-31 10:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:26:41', '2019-04-01 05:26:41'),
(2758, 2, '2019-03-31 17:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:26:41', '2019-04-01 05:26:41'),
(2759, 5, '2019-03-31 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:26:41', '2019-04-01 05:26:41'),
(2760, 5, '2019-03-31 20:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-01 05:26:41', '2019-04-01 05:26:41'),
(2771, 1, '2019-04-01 11:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:47:59', '2019-04-02 05:47:59'),
(2772, 1, '2019-04-01 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:47:59', '2019-04-02 05:47:59'),
(2773, 4, '2019-04-01 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:49:14', '2019-04-02 05:49:14'),
(2774, 4, '2019-04-01 16:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:49:14', '2019-04-02 05:49:14'),
(2775, 7, '2019-04-01 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:50:17', '2019-04-02 05:50:17'),
(2776, 7, '2019-04-01 19:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:50:17', '2019-04-02 05:50:17'),
(2777, 9, '2019-04-01 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:51:14', '2019-04-02 05:51:14'),
(2778, 9, '2019-04-01 19:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:51:14', '2019-04-02 05:51:14'),
(2779, 24, '2019-04-01 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:51:14', '2019-04-02 05:51:14'),
(2780, 24, '2019-04-01 19:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:51:14', '2019-04-02 05:51:14'),
(2781, 8, '2019-04-01 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:51:14', '2019-04-02 05:51:14'),
(2782, 8, '2019-04-01 16:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:51:14', '2019-04-02 05:51:14'),
(2783, 10, '2019-04-01 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:51:14', '2019-04-02 05:51:14'),
(2784, 10, '2019-04-01 19:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:51:14', '2019-04-02 05:51:14'),
(2785, 26, '2019-04-01 10:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:52:29', '2019-04-02 05:52:29'),
(2786, 26, '2019-04-01 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:52:29', '2019-04-02 05:52:29'),
(2787, 2, '2019-04-01 10:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:52:29', '2019-04-02 05:52:29'),
(2788, 2, '2019-04-01 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:52:29', '2019-04-02 05:52:29'),
(2789, 5, '2019-04-01 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:52:29', '2019-04-02 05:52:29'),
(2790, 5, '2019-04-01 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-02 05:52:29', '2019-04-02 05:52:29'),
(2802, 1, '2019-04-02 11:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:18:18', '2019-04-03 05:18:18'),
(2803, 1, '2019-04-02 19:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:18:18', '2019-04-03 05:18:18'),
(2804, 4, '2019-04-02 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:18:40', '2019-04-03 05:18:40'),
(2805, 4, '2019-04-02 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:18:40', '2019-04-03 05:18:40'),
(2806, 7, '2019-04-02 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:19:21', '2019-04-03 05:19:21'),
(2807, 7, '2019-04-02 18:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:19:21', '2019-04-03 05:19:21'),
(2808, 9, '2019-04-02 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:20:47', '2019-04-03 05:20:47'),
(2809, 9, '2019-04-02 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:20:47', '2019-04-03 05:20:47'),
(2810, 24, '2019-04-02 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:20:47', '2019-04-03 05:20:47'),
(2811, 24, '2019-04-02 19:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:20:47', '2019-04-03 05:20:47'),
(2812, 8, '2019-04-02 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:20:47', '2019-04-03 05:20:47'),
(2813, 8, '2019-04-02 19:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:20:47', '2019-04-03 05:20:47'),
(2814, 10, '2019-04-02 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:20:47', '2019-04-03 05:20:47'),
(2815, 10, '2019-04-02 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:20:47', '2019-04-03 05:20:47'),
(2816, 26, '2019-04-02 10:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:22:18', '2019-04-03 05:22:18'),
(2817, 26, '2019-04-02 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:22:18', '2019-04-03 05:22:18'),
(2818, 3, '2019-04-02 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:22:18', '2019-04-03 05:22:18'),
(2819, 3, '2019-04-02 18:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:22:18', '2019-04-03 05:22:18'),
(2820, 2, '2019-04-02 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:22:18', '2019-04-03 05:22:18'),
(2821, 2, '2019-04-02 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:22:18', '2019-04-03 05:22:18'),
(2822, 5, '2019-04-02 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:22:18', '2019-04-03 05:22:18'),
(2823, 5, '2019-04-02 19:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-03 05:22:18', '2019-04-03 05:22:18'),
(2835, 1, '2019-04-03 12:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:01:12', '2019-04-04 06:01:12'),
(2836, 1, '2019-04-03 19:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:01:12', '2019-04-04 06:01:12'),
(2837, 4, '2019-04-03 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:01:56', '2019-04-04 06:01:56'),
(2838, 4, '2019-04-03 18:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:01:56', '2019-04-04 06:01:56'),
(2839, 7, '2019-04-03 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:02:20', '2019-04-04 06:02:20'),
(2840, 7, '2019-04-03 19:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:02:20', '2019-04-04 06:02:20'),
(2841, 9, '2019-04-03 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:04:11', '2019-04-04 06:04:11'),
(2842, 9, '2019-04-03 20:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:04:11', '2019-04-04 06:04:11'),
(2843, 24, '2019-04-03 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:04:11', '2019-04-04 06:04:11'),
(2844, 24, '2019-04-03 20:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:04:11', '2019-04-04 06:04:11'),
(2845, 8, '2019-04-03 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:04:11', '2019-04-04 06:04:11'),
(2846, 8, '2019-04-03 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:04:11', '2019-04-04 06:04:11'),
(2847, 10, '2019-04-03 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:04:11', '2019-04-04 06:04:11'),
(2848, 10, '2019-04-03 20:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:04:11', '2019-04-04 06:04:11'),
(2849, 26, '2019-04-03 10:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:19:10', '2019-04-04 06:19:10'),
(2850, 26, '2019-04-03 19:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:19:10', '2019-04-04 06:19:10'),
(2851, 3, '2019-04-03 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:19:10', '2019-04-04 06:19:10'),
(2852, 3, '2019-04-03 19:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:19:10', '2019-04-04 06:19:10'),
(2853, 2, '2019-04-03 10:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:19:10', '2019-04-04 06:19:10'),
(2854, 2, '2019-04-03 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:19:10', '2019-04-04 06:19:10'),
(2855, 5, '2019-04-03 10:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:19:10', '2019-04-04 06:19:10'),
(2856, 5, '2019-04-03 17:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-04 06:19:10', '2019-04-04 06:19:10'),
(2868, 1, '2019-04-04 13:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 05:58:15', '2019-04-06 05:58:15'),
(2869, 1, '2019-04-04 19:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 05:58:15', '2019-04-06 05:58:15'),
(2870, 4, '2019-04-04 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 05:59:11', '2019-04-06 05:59:11'),
(2871, 4, '2019-04-04 18:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 05:59:11', '2019-04-06 05:59:11'),
(2872, 7, '2019-04-04 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 05:59:56', '2019-04-06 05:59:56'),
(2873, 7, '2019-04-04 19:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 05:59:56', '2019-04-06 05:59:56'),
(2874, 9, '2019-04-04 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:01:31', '2019-04-06 06:01:31'),
(2875, 9, '2019-04-04 19:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:01:31', '2019-04-06 06:01:31'),
(2876, 24, '2019-04-04 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:01:31', '2019-04-06 06:01:31'),
(2877, 24, '2019-04-04 19:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:01:31', '2019-04-06 06:01:31'),
(2878, 8, '2019-04-04 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:01:31', '2019-04-06 06:01:31'),
(2879, 8, '2019-04-04 18:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:01:31', '2019-04-06 06:01:31'),
(2880, 10, '2019-04-04 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:01:31', '2019-04-06 06:01:31'),
(2881, 10, '2019-04-04 19:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:01:31', '2019-04-06 06:01:31'),
(2882, 26, '2019-04-04 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:03:06', '2019-04-06 06:03:06'),
(2883, 26, '2019-04-04 16:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:03:06', '2019-04-06 06:03:06'),
(2884, 3, '2019-04-04 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:03:06', '2019-04-06 06:03:06'),
(2885, 3, '2019-04-04 19:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:03:06', '2019-04-06 06:03:06'),
(2886, 2, '2019-04-04 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:03:06', '2019-04-06 06:03:06'),
(2887, 2, '2019-04-04 19:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:03:06', '2019-04-06 06:03:06'),
(2888, 5, '2019-04-04 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:03:06', '2019-04-06 06:03:06'),
(2889, 5, '2019-04-04 19:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-06 06:03:06', '2019-04-06 06:03:06'),
(2902, 1, '2019-04-06 11:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:00:42', '2019-04-07 06:00:42'),
(2903, 1, '2019-04-06 17:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:00:42', '2019-04-07 06:00:42'),
(2904, 4, '2019-04-06 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:01:13', '2019-04-07 06:01:13'),
(2905, 4, '2019-04-06 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:01:13', '2019-04-07 06:01:13'),
(2906, 7, '2019-04-06 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:05:09', '2019-04-07 06:05:09'),
(2907, 7, '2019-04-06 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:05:09', '2019-04-07 06:05:09'),
(2908, 9, '2019-04-06 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:07:38', '2019-04-07 06:07:38'),
(2909, 9, '2019-04-06 18:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:07:38', '2019-04-07 06:07:38'),
(2910, 24, '2019-04-06 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:07:38', '2019-04-07 06:07:38'),
(2911, 24, '2019-04-06 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:07:38', '2019-04-07 06:07:38'),
(2912, 8, '2019-04-06 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:07:38', '2019-04-07 06:07:38'),
(2913, 8, '2019-04-06 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:07:38', '2019-04-07 06:07:38'),
(2914, 10, '2019-04-06 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:07:38', '2019-04-07 06:07:38'),
(2915, 10, '2019-04-06 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:07:38', '2019-04-07 06:07:38'),
(2916, 26, '2019-04-06 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:15:38', '2019-04-07 06:15:38'),
(2917, 26, '2019-04-06 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:15:38', '2019-04-07 06:15:38'),
(2918, 3, '2019-04-06 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:15:38', '2019-04-07 06:15:38'),
(2919, 3, '2019-04-06 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:15:38', '2019-04-07 06:15:38'),
(2920, 2, '2019-04-06 10:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:15:38', '2019-04-07 06:15:38'),
(2921, 2, '2019-04-06 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:15:38', '2019-04-07 06:15:38'),
(2922, 5, '2019-04-06 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:15:38', '2019-04-07 06:15:38'),
(2923, 5, '2019-04-06 18:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-07 06:15:38', '2019-04-07 06:15:38'),
(2934, 1, '2019-04-07 10:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:47:59', '2019-04-08 05:47:59'),
(2935, 1, '2019-04-07 19:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:47:59', '2019-04-08 05:47:59'),
(2936, 4, '2019-04-07 10:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:48:28', '2019-04-08 05:48:28'),
(2937, 4, '2019-04-07 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:48:28', '2019-04-08 05:48:28'),
(2938, 7, '2019-04-07 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:49:01', '2019-04-08 05:49:01'),
(2939, 7, '2019-04-07 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:49:01', '2019-04-08 05:49:01'),
(2940, 9, '2019-04-07 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:50:18', '2019-04-08 05:50:18'),
(2941, 9, '2019-04-07 19:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:50:18', '2019-04-08 05:50:18'),
(2942, 24, '2019-04-07 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:50:18', '2019-04-08 05:50:18'),
(2943, 24, '2019-04-07 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:50:18', '2019-04-08 05:50:18'),
(2944, 8, '2019-04-07 10:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:50:18', '2019-04-08 05:50:18'),
(2945, 8, '2019-04-07 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:50:18', '2019-04-08 05:50:18'),
(2946, 10, '2019-04-07 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:50:18', '2019-04-08 05:50:18'),
(2947, 10, '2019-04-07 19:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 05:50:18', '2019-04-08 05:50:18'),
(2948, 26, '2019-04-07 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 06:04:59', '2019-04-08 06:04:59'),
(2949, 26, '2019-04-07 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 06:04:59', '2019-04-08 06:04:59'),
(2952, 5, '2019-04-07 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 06:04:59', '2019-04-08 06:04:59'),
(2953, 5, '2019-04-07 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-08 06:04:59', '2019-04-08 06:04:59'),
(2965, 1, '2019-04-08 11:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:29:58', '2019-04-09 05:29:58'),
(2966, 1, '2019-04-08 19:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:29:58', '2019-04-09 05:29:58'),
(2967, 4, '2019-04-08 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:30:25', '2019-04-09 05:30:25'),
(2968, 4, '2019-04-08 19:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:30:25', '2019-04-09 05:30:25'),
(2969, 7, '2019-04-08 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:31:07', '2019-04-09 05:31:07'),
(2970, 7, '2019-04-08 19:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:31:07', '2019-04-09 05:31:07'),
(2971, 9, '2019-04-08 09:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:33:59', '2019-04-09 05:33:59'),
(2972, 9, '2019-04-08 20:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:33:59', '2019-04-09 05:33:59'),
(2973, 24, '2019-04-08 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:33:59', '2019-04-09 05:33:59'),
(2974, 24, '2019-04-08 21:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:33:59', '2019-04-09 05:33:59'),
(2975, 8, '2019-04-08 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:33:59', '2019-04-09 05:33:59'),
(2976, 8, '2019-04-08 17:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:33:59', '2019-04-09 05:33:59'),
(2977, 10, '2019-04-08 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:33:59', '2019-04-09 05:33:59'),
(2978, 10, '2019-04-08 21:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:33:59', '2019-04-09 05:33:59'),
(2979, 26, '2019-04-08 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:35:56', '2019-04-09 05:35:56'),
(2980, 26, '2019-04-08 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:35:56', '2019-04-09 05:35:56'),
(2981, 3, '2019-04-08 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:35:56', '2019-04-09 05:35:56'),
(2982, 3, '2019-04-08 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:35:56', '2019-04-09 05:35:56'),
(2983, 2, '2019-04-08 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:35:56', '2019-04-09 05:35:56'),
(2984, 2, '2019-04-08 19:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:35:56', '2019-04-09 05:35:56'),
(2985, 5, '2019-04-08 10:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:35:56', '2019-04-09 05:35:56'),
(2986, 5, '2019-04-08 19:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 05:35:56', '2019-04-09 05:35:56'),
(3004, 1, '2019-04-09 14:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:00:43', '2019-04-10 06:00:43'),
(3005, 1, '2019-04-09 19:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:00:43', '2019-04-10 06:00:43'),
(3006, 4, '2019-04-09 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:01:21', '2019-04-10 06:01:21'),
(3007, 4, '2019-04-09 19:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:01:21', '2019-04-10 06:01:21'),
(3008, 7, '2019-04-09 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:02:15', '2019-04-10 06:02:15'),
(3009, 7, '2019-04-09 19:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:02:15', '2019-04-10 06:02:15'),
(3010, 9, '2019-04-09 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:03:58', '2019-04-10 06:03:58'),
(3011, 9, '2019-04-09 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:03:58', '2019-04-10 06:03:58'),
(3012, 24, '2019-04-09 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:03:58', '2019-04-10 06:03:58'),
(3013, 24, '2019-04-09 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:03:58', '2019-04-10 06:03:58'),
(3014, 8, '2019-04-09 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:03:58', '2019-04-10 06:03:58'),
(3015, 8, '2019-04-09 19:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:03:58', '2019-04-10 06:03:58'),
(3016, 10, '2019-04-09 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:03:58', '2019-04-10 06:03:58'),
(3017, 10, '2019-04-09 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:03:58', '2019-04-10 06:03:58'),
(3018, 26, '2019-04-09 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:05:55', '2019-04-10 06:05:55'),
(3019, 26, '2019-04-09 19:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:05:55', '2019-04-10 06:05:55'),
(3020, 3, '2019-04-09 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:05:55', '2019-04-10 06:05:55'),
(3021, 3, '2019-04-09 19:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:05:55', '2019-04-10 06:05:55'),
(3022, 2, '2019-04-09 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:05:55', '2019-04-10 06:05:55'),
(3023, 2, '2019-04-09 19:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:05:55', '2019-04-10 06:05:55'),
(3024, 5, '2019-04-09 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:05:55', '2019-04-10 06:05:55'),
(3025, 5, '2019-04-09 19:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 06:05:55', '2019-04-10 06:05:55'),
(3037, 1, '2019-04-10 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:06:44', '2019-04-11 09:06:44'),
(3038, 1, '2019-04-10 17:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:06:44', '2019-04-11 09:06:44'),
(3039, 4, '2019-04-10 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:07:19', '2019-04-11 09:07:19'),
(3040, 4, '2019-04-10 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:07:19', '2019-04-11 09:07:19'),
(3041, 7, '2019-04-10 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:07:46', '2019-04-11 09:07:46'),
(3042, 7, '2019-04-10 18:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:07:46', '2019-04-11 09:07:46'),
(3043, 9, '2019-04-10 09:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:14:17', '2019-04-11 09:14:17'),
(3044, 9, '2019-04-10 19:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:14:17', '2019-04-11 09:14:17'),
(3045, 24, '2019-04-10 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:14:17', '2019-04-11 09:14:17'),
(3046, 24, '2019-04-10 19:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:14:17', '2019-04-11 09:14:17'),
(3047, 8, '2019-04-10 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:14:17', '2019-04-11 09:14:17'),
(3048, 8, '2019-04-10 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:14:17', '2019-04-11 09:14:17'),
(3049, 10, '2019-04-10 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:14:17', '2019-04-11 09:14:17'),
(3050, 10, '2019-04-10 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:14:17', '2019-04-11 09:14:17'),
(3051, 26, '2019-04-10 10:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:17:33', '2019-04-11 09:17:33'),
(3052, 26, '2019-04-10 19:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:17:33', '2019-04-11 09:17:33'),
(3053, 3, '2019-04-10 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:17:33', '2019-04-11 09:17:33'),
(3054, 3, '2019-04-10 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:17:33', '2019-04-11 09:17:33'),
(3055, 2, '2019-04-10 10:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:17:33', '2019-04-11 09:17:33'),
(3056, 2, '2019-04-10 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:17:33', '2019-04-11 09:17:33'),
(3057, 5, '2019-04-10 10:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:17:33', '2019-04-11 09:17:33'),
(3058, 5, '2019-04-10 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-11 09:17:33', '2019-04-11 09:17:33'),
(3067, 1, '2019-04-11 11:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:44:00', '2019-04-15 04:44:00'),
(3068, 1, '2019-04-11 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:44:00', '2019-04-15 04:44:00'),
(3069, 4, '2019-04-11 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:44:26', '2019-04-15 04:44:26'),
(3070, 4, '2019-04-11 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:44:26', '2019-04-15 04:44:26'),
(3071, 7, '2019-04-11 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:44:56', '2019-04-15 04:44:56'),
(3072, 7, '2019-04-11 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:44:56', '2019-04-15 04:44:56'),
(3073, 9, '2019-04-11 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:46:06', '2019-04-15 04:46:06'),
(3074, 9, '2019-04-11 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:46:06', '2019-04-15 04:46:06'),
(3075, 24, '2019-04-11 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:46:06', '2019-04-15 04:46:06'),
(3076, 24, '2019-04-11 18:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:46:06', '2019-04-15 04:46:06'),
(3077, 8, '2019-04-11 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:46:06', '2019-04-15 04:46:06'),
(3078, 8, '2019-04-11 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:46:06', '2019-04-15 04:46:06'),
(3079, 26, '2019-04-11 10:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:48:44', '2019-04-15 04:48:44'),
(3080, 26, '2019-04-11 16:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:48:44', '2019-04-15 04:48:44'),
(3081, 2, '2019-04-11 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:48:44', '2019-04-15 04:48:44'),
(3082, 2, '2019-04-11 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:48:44', '2019-04-15 04:48:44'),
(3083, 1, '2019-04-13 10:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:49:44', '2019-04-15 04:49:44'),
(3084, 1, '2019-04-13 18:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:49:44', '2019-04-15 04:49:44'),
(3085, 4, '2019-04-13 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:50:19', '2019-04-15 04:50:19'),
(3086, 4, '2019-04-13 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:50:19', '2019-04-15 04:50:19'),
(3087, 7, '2019-04-13 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:50:51', '2019-04-15 04:50:51'),
(3088, 7, '2019-04-13 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:50:51', '2019-04-15 04:50:51'),
(3089, 24, '2019-04-13 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:52:27', '2019-04-15 04:52:27'),
(3090, 24, '2019-04-13 18:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:52:27', '2019-04-15 04:52:27'),
(3091, 8, '2019-04-13 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:52:27', '2019-04-15 04:52:27'),
(3092, 8, '2019-04-13 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:52:27', '2019-04-15 04:52:27'),
(3093, 10, '2019-04-13 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:52:27', '2019-04-15 04:52:27'),
(3094, 10, '2019-04-13 18:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:52:27', '2019-04-15 04:52:27'),
(3095, 26, '2019-04-13 10:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:54:25', '2019-04-15 04:54:25'),
(3096, 26, '2019-04-13 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-15 04:54:25', '2019-04-15 04:54:25'),
(3107, 1, '2019-04-15 11:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:14:08', '2019-04-17 05:14:08'),
(3108, 1, '2019-04-15 19:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:14:08', '2019-04-17 05:14:08'),
(3109, 4, '2019-04-15 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:14:37', '2019-04-17 05:14:37'),
(3110, 4, '2019-04-15 19:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:14:37', '2019-04-17 05:14:37'),
(3111, 7, '2019-04-15 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:15:24', '2019-04-17 05:15:24'),
(3112, 7, '2019-04-15 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:15:24', '2019-04-17 05:15:24'),
(3113, 9, '2019-04-15 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:16:57', '2019-04-17 05:16:57'),
(3114, 9, '2019-04-15 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:16:57', '2019-04-17 05:16:57'),
(3115, 24, '2019-04-15 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:16:57', '2019-04-17 05:16:57'),
(3116, 24, '2019-04-15 19:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:16:57', '2019-04-17 05:16:57'),
(3117, 8, '2019-04-15 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:16:57', '2019-04-17 05:16:57'),
(3118, 8, '2019-04-15 19:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:16:57', '2019-04-17 05:16:57'),
(3119, 10, '2019-04-15 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:16:57', '2019-04-17 05:16:57'),
(3120, 10, '2019-04-15 19:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:16:57', '2019-04-17 05:16:57'),
(3127, 26, '2019-04-15 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:18:06', '2019-04-17 05:18:06'),
(3128, 26, '2019-04-15 18:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:18:06', '2019-04-17 05:18:06'),
(3129, 2, '2019-04-15 10:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:18:06', '2019-04-17 05:18:06'),
(3130, 2, '2019-04-15 19:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:18:06', '2019-04-17 05:18:06'),
(3131, 5, '2019-04-15 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:18:06', '2019-04-17 05:18:06'),
(3132, 5, '2019-04-15 19:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:18:06', '2019-04-17 05:18:06'),
(3133, 1, '2019-04-16 11:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:19:02', '2019-04-17 05:19:02'),
(3134, 1, '2019-04-16 19:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:19:02', '2019-04-17 05:19:02'),
(3135, 4, '2019-04-16 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:20:11', '2019-04-17 05:20:11'),
(3136, 4, '2019-04-16 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:20:11', '2019-04-17 05:20:11'),
(3137, 7, '2019-04-16 10:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:20:42', '2019-04-17 05:20:42'),
(3138, 7, '2019-04-16 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:20:42', '2019-04-17 05:20:42'),
(3139, 9, '2019-04-16 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:23:10', '2019-04-17 05:23:10'),
(3140, 9, '2019-04-16 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:23:10', '2019-04-17 05:23:10');
INSERT INTO `employee_attendance` (`employee_attendance_id`, `finger_print_id`, `in_out_time`, `check_type`, `verify_code`, `sensor_id`, `Memoinfo`, `WorkCode`, `sn`, `UserExtFmt`, `mechine_sl`, `created_at`, `updated_at`) VALUES
(3141, 24, '2019-04-16 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:23:10', '2019-04-17 05:23:10'),
(3142, 24, '2019-04-16 19:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:23:10', '2019-04-17 05:23:10'),
(3143, 8, '2019-04-16 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:23:10', '2019-04-17 05:23:10'),
(3144, 8, '2019-04-16 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:23:10', '2019-04-17 05:23:10'),
(3145, 10, '2019-04-16 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:23:10', '2019-04-17 05:23:10'),
(3146, 10, '2019-04-16 19:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:23:10', '2019-04-17 05:23:10'),
(3147, 26, '2019-04-16 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:25:54', '2019-04-17 05:25:54'),
(3148, 26, '2019-04-16 18:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:25:54', '2019-04-17 05:25:54'),
(3149, 3, '2019-04-16 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:25:54', '2019-04-17 05:25:54'),
(3150, 3, '2019-04-16 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:25:54', '2019-04-17 05:25:54'),
(3151, 2, '2019-04-16 11:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:25:54', '2019-04-17 05:25:54'),
(3152, 2, '2019-04-16 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:25:54', '2019-04-17 05:25:54'),
(3153, 5, '2019-04-16 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:25:54', '2019-04-17 05:25:54'),
(3154, 5, '2019-04-16 17:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-17 05:25:54', '2019-04-17 05:25:54'),
(3172, 4, '2019-04-17 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:32:28', '2019-04-18 07:32:28'),
(3173, 4, '2019-04-17 18:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:32:28', '2019-04-18 07:32:28'),
(3174, 7, '2019-04-17 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:33:10', '2019-04-18 07:33:10'),
(3175, 7, '2019-04-17 18:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:33:10', '2019-04-18 07:33:10'),
(3176, 9, '2019-04-17 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:46:18', '2019-04-18 07:46:18'),
(3177, 9, '2019-04-17 13:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:46:18', '2019-04-18 07:46:18'),
(3178, 24, '2019-04-17 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:46:18', '2019-04-18 07:46:18'),
(3179, 24, '2019-04-17 18:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:46:18', '2019-04-18 07:46:18'),
(3180, 8, '2019-04-17 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:46:18', '2019-04-18 07:46:18'),
(3181, 8, '2019-04-17 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:46:18', '2019-04-18 07:46:18'),
(3182, 10, '2019-04-17 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:46:18', '2019-04-18 07:46:18'),
(3183, 10, '2019-04-17 18:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:46:18', '2019-04-18 07:46:18'),
(3184, 26, '2019-04-17 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:48:08', '2019-04-18 07:48:08'),
(3185, 26, '2019-04-17 18:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:48:08', '2019-04-18 07:48:08'),
(3186, 3, '2019-04-17 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:48:08', '2019-04-18 07:48:08'),
(3187, 3, '2019-04-17 18:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:48:08', '2019-04-18 07:48:08'),
(3188, 2, '2019-04-17 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:48:08', '2019-04-18 07:48:08'),
(3189, 2, '2019-04-17 18:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:48:08', '2019-04-18 07:48:08'),
(3190, 5, '2019-04-17 11:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:48:08', '2019-04-18 07:48:08'),
(3191, 5, '2019-04-17 18:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 07:48:08', '2019-04-18 07:48:08'),
(3202, 1, '2019-04-18 11:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:32:02', '2019-04-20 06:32:02'),
(3203, 1, '2019-04-18 16:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:32:02', '2019-04-20 06:32:02'),
(3204, 4, '2019-04-18 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:32:36', '2019-04-20 06:32:36'),
(3205, 4, '2019-04-18 18:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:32:36', '2019-04-20 06:32:36'),
(3206, 7, '2019-04-18 10:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:33:07', '2019-04-20 06:33:07'),
(3207, 7, '2019-04-18 19:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:33:07', '2019-04-20 06:33:07'),
(3208, 24, '2019-04-18 09:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:36:42', '2019-04-20 06:36:42'),
(3209, 24, '2019-04-18 19:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:36:42', '2019-04-20 06:36:42'),
(3210, 8, '2019-04-18 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:36:42', '2019-04-20 06:36:42'),
(3211, 8, '2019-04-18 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:36:42', '2019-04-20 06:36:42'),
(3212, 10, '2019-04-18 09:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:36:42', '2019-04-20 06:36:42'),
(3213, 10, '2019-04-18 19:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:36:42', '2019-04-20 06:36:42'),
(3214, 26, '2019-04-18 10:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:38:32', '2019-04-20 06:38:32'),
(3215, 26, '2019-04-18 16:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:38:32', '2019-04-20 06:38:32'),
(3216, 3, '2019-04-18 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:38:32', '2019-04-20 06:38:32'),
(3217, 3, '2019-04-18 19:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:38:32', '2019-04-20 06:38:32'),
(3218, 2, '2019-04-18 10:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:38:32', '2019-04-20 06:38:32'),
(3219, 2, '2019-04-18 19:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:38:32', '2019-04-20 06:38:32'),
(3220, 5, '2019-04-18 10:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:38:32', '2019-04-20 06:38:32'),
(3221, 5, '2019-04-18 19:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-20 06:38:32', '2019-04-20 06:38:32'),
(3231, 4, '2019-04-20 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-21 10:50:55', '2019-04-21 10:50:55'),
(3232, 4, '2019-04-20 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-21 10:50:55', '2019-04-21 10:50:55'),
(3233, 7, '2019-04-20 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-21 10:51:18', '2019-04-21 10:51:18'),
(3234, 7, '2019-04-20 19:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-21 10:51:18', '2019-04-21 10:51:18'),
(3235, 9, '2019-04-20 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-21 10:52:22', '2019-04-21 10:52:22'),
(3236, 9, '2019-04-20 19:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-21 10:52:22', '2019-04-21 10:52:22'),
(3237, 24, '2019-04-20 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-21 10:52:22', '2019-04-21 10:52:22'),
(3238, 24, '2019-04-20 19:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-21 10:52:22', '2019-04-21 10:52:22'),
(3239, 8, '2019-04-20 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-21 10:52:22', '2019-04-21 10:52:22'),
(3240, 8, '2019-04-20 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-21 10:52:22', '2019-04-21 10:52:22'),
(3241, 10, '2019-04-20 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-21 10:52:22', '2019-04-21 10:52:22'),
(3242, 10, '2019-04-20 19:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-21 10:52:22', '2019-04-21 10:52:22'),
(3260, 1, '2019-04-21 11:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:30:05', '2019-04-23 10:30:05'),
(3261, 1, '2019-04-21 19:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:30:05', '2019-04-23 10:30:05'),
(3262, 4, '2019-04-21 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:30:42', '2019-04-23 10:30:42'),
(3263, 4, '2019-04-21 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:30:42', '2019-04-23 10:30:42'),
(3264, 7, '2019-04-21 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:31:19', '2019-04-23 10:31:19'),
(3265, 7, '2019-04-21 19:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:31:19', '2019-04-23 10:31:19'),
(3266, 9, '2019-04-21 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:33:18', '2019-04-23 10:33:18'),
(3267, 9, '2019-04-21 19:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:33:18', '2019-04-23 10:33:18'),
(3268, 24, '2019-04-21 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:33:18', '2019-04-23 10:33:18'),
(3269, 24, '2019-04-21 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:33:18', '2019-04-23 10:33:18'),
(3270, 8, '2019-04-21 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:33:18', '2019-04-23 10:33:18'),
(3271, 8, '2019-04-21 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:33:18', '2019-04-23 10:33:18'),
(3272, 10, '2019-04-21 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:33:18', '2019-04-23 10:33:18'),
(3273, 10, '2019-04-21 19:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:33:18', '2019-04-23 10:33:18'),
(3274, 3, '2019-04-21 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:35:11', '2019-04-23 10:35:11'),
(3275, 3, '2019-04-21 19:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:35:11', '2019-04-23 10:35:11'),
(3276, 2, '2019-04-21 10:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:35:11', '2019-04-23 10:35:11'),
(3277, 2, '2019-04-21 19:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:35:11', '2019-04-23 10:35:11'),
(3278, 5, '2019-04-21 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:35:11', '2019-04-23 10:35:11'),
(3279, 5, '2019-04-21 19:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-23 10:35:11', '2019-04-23 10:35:11'),
(3291, 1, '2019-04-23 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:21:56', '2019-04-24 09:21:56'),
(3292, 1, '2019-04-23 18:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:21:56', '2019-04-24 09:21:56'),
(3293, 4, '2019-04-23 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:23:29', '2019-04-24 09:23:29'),
(3294, 4, '2019-04-23 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:23:29', '2019-04-24 09:23:29'),
(3295, 7, '2019-04-23 10:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:25:25', '2019-04-24 09:25:25'),
(3296, 7, '2019-04-23 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:25:25', '2019-04-24 09:25:25'),
(3297, 9, '2019-04-23 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:26:28', '2019-04-24 09:26:28'),
(3298, 9, '2019-04-23 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:26:28', '2019-04-24 09:26:28'),
(3299, 24, '2019-04-23 09:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:26:28', '2019-04-24 09:26:28'),
(3300, 24, '2019-04-23 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:26:28', '2019-04-24 09:26:28'),
(3301, 8, '2019-04-23 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:26:28', '2019-04-24 09:26:28'),
(3302, 8, '2019-04-23 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:26:28', '2019-04-24 09:26:28'),
(3303, 10, '2019-04-23 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:26:28', '2019-04-24 09:26:28'),
(3304, 10, '2019-04-23 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:26:28', '2019-04-24 09:26:28'),
(3305, 26, '2019-04-23 10:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:28:24', '2019-04-24 09:28:24'),
(3306, 26, '2019-04-23 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:28:24', '2019-04-24 09:28:24'),
(3307, 3, '2019-04-23 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:28:24', '2019-04-24 09:28:24'),
(3308, 3, '2019-04-23 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:28:24', '2019-04-24 09:28:24'),
(3309, 2, '2019-04-23 11:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:28:24', '2019-04-24 09:28:24'),
(3310, 2, '2019-04-23 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:28:24', '2019-04-24 09:28:24'),
(3311, 5, '2019-04-23 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:28:24', '2019-04-24 09:28:24'),
(3312, 5, '2019-04-23 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-24 09:28:24', '2019-04-24 09:28:24'),
(3328, 1, '2019-04-24 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:55:21', '2019-04-25 05:55:21'),
(3329, 1, '2019-04-24 17:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:55:21', '2019-04-25 05:55:21'),
(3330, 4, '2019-04-24 10:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:55:58', '2019-04-25 05:55:58'),
(3331, 4, '2019-04-24 16:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:55:58', '2019-04-25 05:55:58'),
(3332, 7, '2019-04-24 10:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:56:36', '2019-04-25 05:56:36'),
(3333, 7, '2019-04-24 17:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:56:36', '2019-04-25 05:56:36'),
(3334, 9, '2019-04-24 09:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:58:33', '2019-04-25 05:58:33'),
(3335, 9, '2019-04-24 17:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:58:33', '2019-04-25 05:58:33'),
(3336, 24, '2019-04-24 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:58:33', '2019-04-25 05:58:33'),
(3337, 24, '2019-04-24 17:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:58:33', '2019-04-25 05:58:33'),
(3338, 8, '2019-04-24 10:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:58:33', '2019-04-25 05:58:33'),
(3339, 8, '2019-04-24 16:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:58:33', '2019-04-25 05:58:33'),
(3340, 10, '2019-04-24 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:58:33', '2019-04-25 05:58:33'),
(3341, 10, '2019-04-24 17:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 05:58:33', '2019-04-25 05:58:33'),
(3342, 26, '2019-04-24 10:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 06:01:17', '2019-04-25 06:01:17'),
(3343, 26, '2019-04-24 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 06:01:17', '2019-04-25 06:01:17'),
(3344, 3, '2019-04-24 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 06:01:17', '2019-04-25 06:01:17'),
(3345, 3, '2019-04-24 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 06:01:17', '2019-04-25 06:01:17'),
(3346, 2, '2019-04-24 10:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 06:01:17', '2019-04-25 06:01:17'),
(3347, 2, '2019-04-24 17:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 06:01:17', '2019-04-25 06:01:17'),
(3348, 5, '2019-04-24 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 06:01:17', '2019-04-25 06:01:17'),
(3349, 5, '2019-04-24 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-25 06:01:17', '2019-04-25 06:01:17'),
(3363, 1, '2019-04-25 11:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:40:22', '2019-04-27 07:40:22'),
(3364, 1, '2019-04-25 18:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:40:22', '2019-04-27 07:40:22'),
(3365, 4, '2019-04-25 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:41:03', '2019-04-27 07:41:03'),
(3366, 4, '2019-04-25 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:41:03', '2019-04-27 07:41:03'),
(3367, 7, '2019-04-25 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:41:29', '2019-04-27 07:41:29'),
(3368, 7, '2019-04-25 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:41:29', '2019-04-27 07:41:29'),
(3369, 9, '2019-04-25 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:42:43', '2019-04-27 07:42:43'),
(3370, 9, '2019-04-25 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:42:43', '2019-04-27 07:42:43'),
(3371, 24, '2019-04-25 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:42:43', '2019-04-27 07:42:43'),
(3372, 24, '2019-04-25 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:42:43', '2019-04-27 07:42:43'),
(3373, 8, '2019-04-25 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:42:43', '2019-04-27 07:42:43'),
(3374, 8, '2019-04-25 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:42:43', '2019-04-27 07:42:43'),
(3375, 10, '2019-04-25 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:42:43', '2019-04-27 07:42:43'),
(3376, 10, '2019-04-25 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:42:43', '2019-04-27 07:42:43'),
(3377, 26, '2019-04-25 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:43:48', '2019-04-27 07:43:48'),
(3378, 26, '2019-04-25 17:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:43:48', '2019-04-27 07:43:48'),
(3379, 3, '2019-04-25 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:43:48', '2019-04-27 07:43:48'),
(3380, 3, '2019-04-25 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:43:48', '2019-04-27 07:43:48'),
(3381, 2, '2019-04-25 10:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:43:48', '2019-04-27 07:43:48'),
(3382, 2, '2019-04-25 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:43:48', '2019-04-27 07:43:48'),
(3383, 5, '2019-04-25 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:43:48', '2019-04-27 07:43:48'),
(3384, 5, '2019-04-25 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-27 07:43:48', '2019-04-27 07:43:48'),
(3395, 4, '2019-04-27 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:02:50', '2019-04-28 06:02:50'),
(3396, 4, '2019-04-27 18:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:02:50', '2019-04-28 06:02:50'),
(3397, 7, '2019-04-27 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:08:18', '2019-04-28 06:08:18'),
(3398, 7, '2019-04-27 18:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:08:18', '2019-04-28 06:08:18'),
(3399, 9, '2019-04-27 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:11:56', '2019-04-28 06:11:56'),
(3400, 9, '2019-04-27 18:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:11:56', '2019-04-28 06:11:56'),
(3401, 24, '2019-04-27 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:11:56', '2019-04-28 06:11:56'),
(3402, 24, '2019-04-27 12:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:11:56', '2019-04-28 06:11:56'),
(3403, 8, '2019-04-27 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:11:56', '2019-04-28 06:11:56'),
(3404, 8, '2019-04-27 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:11:56', '2019-04-28 06:11:56'),
(3405, 10, '2019-04-27 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:11:56', '2019-04-28 06:11:56'),
(3406, 10, '2019-04-27 18:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:11:56', '2019-04-28 06:11:56'),
(3407, 26, '2019-04-27 10:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:14:03', '2019-04-28 06:14:03'),
(3408, 26, '2019-04-27 15:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:14:03', '2019-04-28 06:14:03'),
(3409, 3, '2019-04-27 10:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:14:03', '2019-04-28 06:14:03'),
(3410, 3, '2019-04-27 18:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:14:03', '2019-04-28 06:14:03'),
(3411, 2, '2019-04-27 10:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:14:03', '2019-04-28 06:14:03'),
(3412, 2, '2019-04-27 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:14:03', '2019-04-28 06:14:03'),
(3413, 5, '2019-04-27 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:14:03', '2019-04-28 06:14:03'),
(3414, 5, '2019-04-27 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-28 06:14:03', '2019-04-28 06:14:03'),
(3426, 1, '2019-04-28 11:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:18:03', '2019-04-30 10:18:03'),
(3427, 1, '2019-04-28 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:18:03', '2019-04-30 10:18:03'),
(3428, 4, '2019-04-28 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:18:45', '2019-04-30 10:18:45'),
(3429, 4, '2019-04-28 18:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:18:45', '2019-04-30 10:18:45'),
(3430, 7, '2019-04-28 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:19:20', '2019-04-30 10:19:20'),
(3431, 7, '2019-04-28 20:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:19:20', '2019-04-30 10:19:20'),
(3432, 9, '2019-04-28 09:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:20:23', '2019-04-30 10:20:23'),
(3433, 9, '2019-04-28 20:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:20:23', '2019-04-30 10:20:23'),
(3434, 24, '2019-04-28 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:20:23', '2019-04-30 10:20:23'),
(3435, 24, '2019-04-28 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:20:23', '2019-04-30 10:20:23'),
(3436, 8, '2019-04-28 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:20:23', '2019-04-30 10:20:23'),
(3437, 8, '2019-04-28 18:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:20:23', '2019-04-30 10:20:23'),
(3438, 10, '2019-04-28 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:20:23', '2019-04-30 10:20:23'),
(3439, 10, '2019-04-28 20:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:20:23', '2019-04-30 10:20:23'),
(3440, 26, '2019-04-28 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:21:55', '2019-04-30 10:21:55'),
(3441, 26, '2019-04-28 18:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:21:55', '2019-04-30 10:21:55'),
(3442, 3, '2019-04-28 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:21:55', '2019-04-30 10:21:55'),
(3443, 3, '2019-04-28 18:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:21:55', '2019-04-30 10:21:55'),
(3444, 2, '2019-04-28 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:21:55', '2019-04-30 10:21:55'),
(3445, 2, '2019-04-28 18:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:21:55', '2019-04-30 10:21:55'),
(3446, 5, '2019-04-28 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:21:55', '2019-04-30 10:21:55'),
(3447, 5, '2019-04-28 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:21:55', '2019-04-30 10:21:55'),
(3448, 1, '2019-04-29 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:24:47', '2019-04-30 10:24:47'),
(3449, 1, '2019-04-29 23:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:24:47', '2019-04-30 10:24:47'),
(3450, 7, '2019-04-29 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:26:09', '2019-04-30 10:26:09'),
(3451, 7, '2019-04-29 21:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:26:09', '2019-04-30 10:26:09'),
(3458, 9, '2019-04-29 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:28:44', '2019-04-30 10:28:44'),
(3459, 9, '2019-04-29 23:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:28:45', '2019-04-30 10:28:45'),
(3460, 24, '2019-04-29 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:28:45', '2019-04-30 10:28:45'),
(3461, 24, '2019-04-29 23:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:28:45', '2019-04-30 10:28:45'),
(3462, 10, '2019-04-29 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:28:45', '2019-04-30 10:28:45'),
(3463, 10, '2019-04-29 23:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:28:45', '2019-04-30 10:28:45'),
(3464, 26, '2019-04-29 10:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:31:47', '2019-04-30 10:31:47'),
(3465, 26, '2019-04-29 17:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:31:47', '2019-04-30 10:31:47'),
(3466, 3, '2019-04-29 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:31:47', '2019-04-30 10:31:47'),
(3467, 3, '2019-04-29 21:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:31:47', '2019-04-30 10:31:47'),
(3468, 2, '2019-04-29 10:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:31:47', '2019-04-30 10:31:47'),
(3469, 2, '2019-04-29 23:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:31:47', '2019-04-30 10:31:47'),
(3470, 5, '2019-04-29 10:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:31:47', '2019-04-30 10:31:47'),
(3471, 5, '2019-04-29 23:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-30 10:31:47', '2019-04-30 10:31:47'),
(3483, 1, '2019-04-30 12:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:39:16', '2019-05-02 05:39:16'),
(3484, 1, '2019-04-30 20:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:39:16', '2019-05-02 05:39:16'),
(3485, 4, '2019-04-30 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:39:50', '2019-05-02 05:39:50'),
(3486, 4, '2019-04-30 20:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:39:50', '2019-05-02 05:39:50'),
(3487, 7, '2019-04-30 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:45:44', '2019-05-02 05:45:44'),
(3488, 7, '2019-04-30 20:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:45:44', '2019-05-02 05:45:44'),
(3489, 9, '2019-04-30 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:47:24', '2019-05-02 05:47:24'),
(3490, 9, '2019-04-30 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:47:24', '2019-05-02 05:47:24'),
(3491, 24, '2019-04-30 09:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:47:24', '2019-05-02 05:47:24'),
(3492, 24, '2019-04-30 20:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:47:24', '2019-05-02 05:47:24'),
(3493, 8, '2019-04-30 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:47:24', '2019-05-02 05:47:24'),
(3494, 8, '2019-04-30 20:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:47:24', '2019-05-02 05:47:24'),
(3495, 10, '2019-04-30 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:47:24', '2019-05-02 05:47:24'),
(3496, 10, '2019-04-30 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:47:24', '2019-05-02 05:47:24'),
(3497, 26, '2019-04-30 10:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:49:13', '2019-05-02 05:49:13'),
(3498, 26, '2019-04-30 20:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:49:13', '2019-05-02 05:49:13'),
(3499, 3, '2019-04-30 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:49:13', '2019-05-02 05:49:13'),
(3500, 3, '2019-04-30 20:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:49:13', '2019-05-02 05:49:13'),
(3501, 2, '2019-04-30 12:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:49:13', '2019-05-02 05:49:13'),
(3502, 2, '2019-04-30 20:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:49:13', '2019-05-02 05:49:13'),
(3503, 5, '2019-04-30 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:49:13', '2019-05-02 05:49:13'),
(3504, 5, '2019-04-30 20:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-02 05:49:13', '2019-05-02 05:49:13'),
(3518, 3, '2019-04-20 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 08:41:18', '2019-05-04 08:41:18'),
(3519, 3, '2019-04-20 19:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 08:41:18', '2019-05-04 08:41:18'),
(3520, 2, '2019-04-20 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 08:41:18', '2019-05-04 08:41:18'),
(3521, 2, '2019-04-20 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 08:41:18', '2019-05-04 08:41:18'),
(3522, 5, '2019-04-20 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 08:41:18', '2019-05-04 08:41:18'),
(3523, 5, '2019-04-20 19:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 08:41:18', '2019-05-04 08:41:18'),
(3524, 1, '2019-05-02 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 08:44:54', '2019-05-04 08:44:54'),
(3525, 1, '2019-05-02 19:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 08:44:54', '2019-05-04 08:44:54'),
(3526, 4, '2019-05-02 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 08:45:21', '2019-05-04 08:45:21'),
(3527, 4, '2019-05-02 19:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 08:45:21', '2019-05-04 08:45:21'),
(3533, 27, '2019-05-02 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:10:47', '2019-05-04 09:10:47'),
(3534, 27, '2019-05-02 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:10:47', '2019-05-04 09:10:47'),
(3535, 9, '2019-05-02 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:12:14', '2019-05-04 09:12:14'),
(3536, 9, '2019-05-02 19:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:12:14', '2019-05-04 09:12:14'),
(3537, 24, '2019-05-02 09:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:12:14', '2019-05-04 09:12:14'),
(3538, 24, '2019-05-02 19:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:12:14', '2019-05-04 09:12:14'),
(3539, 8, '2019-05-02 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:12:14', '2019-05-04 09:12:14'),
(3540, 8, '2019-05-02 19:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:12:14', '2019-05-04 09:12:14'),
(3541, 10, '2019-05-02 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:12:14', '2019-05-04 09:12:14'),
(3542, 10, '2019-05-02 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:12:14', '2019-05-04 09:12:14'),
(3543, 26, '2019-05-02 10:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:13:22', '2019-05-04 09:13:22'),
(3544, 26, '2019-05-02 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:13:22', '2019-05-04 09:13:22'),
(3545, 3, '2019-05-02 11:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:13:22', '2019-05-04 09:13:22'),
(3546, 3, '2019-05-02 19:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:13:22', '2019-05-04 09:13:22'),
(3547, 2, '2019-05-02 11:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:13:22', '2019-05-04 09:13:22'),
(3548, 2, '2019-05-02 19:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:13:22', '2019-05-04 09:13:22'),
(3549, 5, '2019-05-02 10:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:13:22', '2019-05-04 09:13:22'),
(3550, 5, '2019-05-02 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:13:22', '2019-05-04 09:13:22'),
(3554, 27, '2019-05-04 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-04 09:16:53', '2019-05-04 09:16:53'),
(3563, 1, '2019-05-04 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:01:33', '2019-05-05 05:01:33'),
(3564, 1, '2019-05-04 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:01:33', '2019-05-05 05:01:33'),
(3565, 4, '2019-05-04 13:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:02:16', '2019-05-05 05:02:16'),
(3566, 4, '2019-05-04 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:02:16', '2019-05-05 05:02:16'),
(3567, 7, '2019-05-04 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:03:26', '2019-05-05 05:03:26'),
(3568, 7, '2019-05-04 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:03:26', '2019-05-05 05:03:26'),
(3569, 30, '2019-05-04 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:03:26', '2019-05-05 05:03:26'),
(3570, 30, '2019-05-04 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:03:26', '2019-05-05 05:03:26'),
(3571, 9, '2019-05-04 09:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:05:43', '2019-05-05 05:05:43'),
(3572, 9, '2019-05-04 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:05:43', '2019-05-05 05:05:43'),
(3573, 24, '2019-05-04 09:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:05:43', '2019-05-05 05:05:43'),
(3574, 24, '2019-05-04 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:05:43', '2019-05-05 05:05:43'),
(3575, 8, '2019-05-04 13:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:05:43', '2019-05-05 05:05:43'),
(3576, 8, '2019-05-04 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:05:43', '2019-05-05 05:05:43'),
(3577, 10, '2019-05-04 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:05:43', '2019-05-05 05:05:43'),
(3578, 10, '2019-05-04 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:05:43', '2019-05-05 05:05:43'),
(3579, 3, '2019-05-04 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:07:18', '2019-05-05 05:07:18'),
(3580, 3, '2019-05-04 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:07:18', '2019-05-05 05:07:18'),
(3581, 2, '2019-05-04 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:07:18', '2019-05-05 05:07:18'),
(3582, 2, '2019-05-04 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:07:18', '2019-05-05 05:07:18'),
(3583, 26, '2019-05-04 10:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:08:22', '2019-05-05 05:08:22'),
(3584, 26, '2019-05-04 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:08:22', '2019-05-05 05:08:22'),
(3585, 5, '2019-05-04 10:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:08:22', '2019-05-05 05:08:22'),
(3586, 5, '2019-05-04 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-05 05:08:22', '2019-05-05 05:08:22'),
(3599, 1, '2019-05-05 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:21:33', '2019-05-06 09:21:33'),
(3600, 1, '2019-05-05 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:21:34', '2019-05-06 09:21:34'),
(3601, 4, '2019-05-05 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:22:09', '2019-05-06 09:22:09'),
(3602, 4, '2019-05-05 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:22:09', '2019-05-06 09:22:09'),
(3603, 7, '2019-05-05 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:23:14', '2019-05-06 09:23:14'),
(3604, 7, '2019-05-05 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:23:14', '2019-05-06 09:23:14'),
(3605, 30, '2019-05-05 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:23:14', '2019-05-06 09:23:14'),
(3606, 30, '2019-05-05 19:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:23:14', '2019-05-06 09:23:14'),
(3607, 9, '2019-05-05 09:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:24:51', '2019-05-06 09:24:51'),
(3608, 9, '2019-05-05 20:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:24:51', '2019-05-06 09:24:51'),
(3609, 24, '2019-05-05 09:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:24:51', '2019-05-06 09:24:51'),
(3610, 24, '2019-05-05 20:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:24:51', '2019-05-06 09:24:51'),
(3611, 8, '2019-05-05 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:24:51', '2019-05-06 09:24:51'),
(3612, 8, '2019-05-05 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:24:51', '2019-05-06 09:24:51'),
(3613, 10, '2019-05-05 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:24:51', '2019-05-06 09:24:51'),
(3614, 10, '2019-05-05 20:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:24:51', '2019-05-06 09:24:51'),
(3615, 3, '2019-05-05 10:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:25:27', '2019-05-06 09:25:27'),
(3616, 3, '2019-05-05 18:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:25:27', '2019-05-06 09:25:27'),
(3617, 2, '2019-05-05 10:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:25:27', '2019-05-06 09:25:27'),
(3618, 2, '2019-05-05 18:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:25:27', '2019-05-06 09:25:27'),
(3619, 26, '2019-05-05 10:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:29:36', '2019-05-06 09:29:36'),
(3620, 26, '2019-05-05 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:29:36', '2019-05-06 09:29:36'),
(3621, 5, '2019-05-05 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:29:36', '2019-05-06 09:29:36'),
(3622, 5, '2019-05-05 18:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-06 09:29:36', '2019-05-06 09:29:36'),
(3635, 1, '2019-05-06 12:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:19:33', '2019-05-07 04:19:33'),
(3636, 1, '2019-05-06 19:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:19:33', '2019-05-07 04:19:33'),
(3637, 4, '2019-05-06 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:20:04', '2019-05-07 04:20:04'),
(3638, 4, '2019-05-06 19:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:20:04', '2019-05-07 04:20:04'),
(3639, 7, '2019-05-06 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:20:52', '2019-05-07 04:20:52'),
(3640, 7, '2019-05-06 19:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:20:52', '2019-05-07 04:20:52'),
(3641, 30, '2019-05-06 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:20:52', '2019-05-07 04:20:52'),
(3642, 30, '2019-05-06 19:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:20:52', '2019-05-07 04:20:52'),
(3643, 9, '2019-05-06 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:22:27', '2019-05-07 04:22:27'),
(3644, 9, '2019-05-06 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:22:27', '2019-05-07 04:22:27'),
(3645, 24, '2019-05-06 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:22:27', '2019-05-07 04:22:27'),
(3646, 24, '2019-05-06 20:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:22:27', '2019-05-07 04:22:27'),
(3647, 8, '2019-05-06 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:22:27', '2019-05-07 04:22:27'),
(3648, 8, '2019-05-06 19:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:22:27', '2019-05-07 04:22:27'),
(3649, 10, '2019-05-06 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:22:27', '2019-05-07 04:22:27'),
(3650, 10, '2019-05-06 18:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:22:27', '2019-05-07 04:22:27'),
(3651, 3, '2019-05-06 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:23:36', '2019-05-07 04:23:36'),
(3652, 3, '2019-05-06 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:23:36', '2019-05-07 04:23:36'),
(3653, 2, '2019-05-06 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:23:36', '2019-05-07 04:23:36'),
(3654, 2, '2019-05-06 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:23:36', '2019-05-07 04:23:36'),
(3655, 26, '2019-05-06 10:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:25:07', '2019-05-07 04:25:07'),
(3656, 26, '2019-05-06 19:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:25:07', '2019-05-07 04:25:07'),
(3657, 5, '2019-05-06 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:25:07', '2019-05-07 04:25:07'),
(3658, 5, '2019-05-06 19:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-07 04:25:07', '2019-05-07 04:25:07'),
(3674, 1, '2019-05-07 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:27:08', '2019-05-08 07:27:08'),
(3675, 1, '2019-05-07 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:27:08', '2019-05-08 07:27:08'),
(3676, 4, '2019-05-07 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:27:24', '2019-05-08 07:27:24'),
(3677, 4, '2019-05-07 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:27:24', '2019-05-08 07:27:24'),
(3678, 7, '2019-05-07 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:30:18', '2019-05-08 07:30:18'),
(3679, 7, '2019-05-07 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:30:18', '2019-05-08 07:30:18'),
(3680, 30, '2019-05-07 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:30:18', '2019-05-08 07:30:18'),
(3681, 30, '2019-05-07 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:30:18', '2019-05-08 07:30:18'),
(3690, 9, '2019-05-07 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:34:40', '2019-05-08 07:34:40'),
(3691, 9, '2019-05-07 17:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:34:40', '2019-05-08 07:34:40'),
(3692, 24, '2019-05-07 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:34:40', '2019-05-08 07:34:40'),
(3693, 24, '2019-05-07 17:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:34:40', '2019-05-08 07:34:40'),
(3694, 8, '2019-05-07 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:34:40', '2019-05-08 07:34:40'),
(3695, 8, '2019-05-07 16:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:34:40', '2019-05-08 07:34:40'),
(3696, 10, '2019-05-07 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:34:40', '2019-05-08 07:34:40'),
(3697, 10, '2019-05-07 17:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:34:40', '2019-05-08 07:34:40'),
(3698, 3, '2019-05-07 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:35:55', '2019-05-08 07:35:55'),
(3699, 3, '2019-05-07 16:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:35:55', '2019-05-08 07:35:55'),
(3700, 2, '2019-05-07 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:35:55', '2019-05-08 07:35:55'),
(3701, 2, '2019-05-07 16:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:35:55', '2019-05-08 07:35:55'),
(3702, 26, '2019-05-07 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:37:23', '2019-05-08 07:37:23'),
(3703, 26, '2019-05-07 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:37:23', '2019-05-08 07:37:23'),
(3704, 5, '2019-05-07 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:37:23', '2019-05-08 07:37:23'),
(3705, 5, '2019-05-07 16:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-08 07:37:23', '2019-05-08 07:37:23'),
(3719, 1, '2019-05-08 10:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:15:29', '2019-05-09 05:15:29'),
(3720, 1, '2019-05-08 17:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:15:29', '2019-05-09 05:15:29'),
(3721, 4, '2019-05-08 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:18:13', '2019-05-09 05:18:13'),
(3722, 4, '2019-05-08 16:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:18:13', '2019-05-09 05:18:13'),
(3723, 7, '2019-05-08 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:19:42', '2019-05-09 05:19:42'),
(3724, 7, '2019-05-08 17:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:19:42', '2019-05-09 05:19:42'),
(3725, 30, '2019-05-08 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:19:42', '2019-05-09 05:19:42'),
(3726, 30, '2019-05-08 16:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:19:42', '2019-05-09 05:19:42'),
(3727, 9, '2019-05-08 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:21:34', '2019-05-09 05:21:34'),
(3728, 9, '2019-05-08 17:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:21:34', '2019-05-09 05:21:34'),
(3729, 24, '2019-05-08 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:21:34', '2019-05-09 05:21:34'),
(3730, 24, '2019-05-08 17:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:21:34', '2019-05-09 05:21:34'),
(3731, 8, '2019-05-08 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:21:34', '2019-05-09 05:21:34'),
(3732, 8, '2019-05-08 16:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:21:34', '2019-05-09 05:21:34'),
(3733, 10, '2019-05-08 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:21:34', '2019-05-09 05:21:34'),
(3734, 10, '2019-05-08 17:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:21:34', '2019-05-09 05:21:34'),
(3735, 3, '2019-05-08 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:25:40', '2019-05-09 05:25:40'),
(3736, 3, '2019-05-08 17:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:25:40', '2019-05-09 05:25:40'),
(3737, 2, '2019-05-08 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:25:40', '2019-05-09 05:25:40'),
(3738, 2, '2019-05-08 16:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:25:40', '2019-05-09 05:25:40'),
(3739, 26, '2019-05-08 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:26:41', '2019-05-09 05:26:41'),
(3740, 26, '2019-05-08 16:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:26:41', '2019-05-09 05:26:41'),
(3741, 5, '2019-05-08 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:26:41', '2019-05-09 05:26:41'),
(3742, 5, '2019-05-08 16:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-09 05:26:41', '2019-05-09 05:26:41'),
(3755, 1, '2019-05-09 10:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:25:42', '2019-05-11 05:25:42'),
(3756, 1, '2019-05-09 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:25:42', '2019-05-11 05:25:42'),
(3757, 4, '2019-05-09 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:26:23', '2019-05-11 05:26:23'),
(3758, 4, '2019-05-09 16:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:26:23', '2019-05-11 05:26:23'),
(3759, 7, '2019-05-09 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:27:15', '2019-05-11 05:27:15'),
(3760, 7, '2019-05-09 17:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:27:16', '2019-05-11 05:27:16'),
(3761, 30, '2019-05-09 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:27:16', '2019-05-11 05:27:16'),
(3762, 30, '2019-05-09 15:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:27:16', '2019-05-11 05:27:16'),
(3763, 9, '2019-05-09 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:28:52', '2019-05-11 05:28:52'),
(3764, 9, '2019-05-09 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:28:52', '2019-05-11 05:28:52'),
(3765, 24, '2019-05-09 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:28:52', '2019-05-11 05:28:52');
INSERT INTO `employee_attendance` (`employee_attendance_id`, `finger_print_id`, `in_out_time`, `check_type`, `verify_code`, `sensor_id`, `Memoinfo`, `WorkCode`, `sn`, `UserExtFmt`, `mechine_sl`, `created_at`, `updated_at`) VALUES
(3766, 24, '2019-05-09 17:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:28:52', '2019-05-11 05:28:52'),
(3767, 8, '2019-05-09 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:28:52', '2019-05-11 05:28:52'),
(3768, 8, '2019-05-09 16:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:28:52', '2019-05-11 05:28:52'),
(3769, 10, '2019-05-09 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:28:52', '2019-05-11 05:28:52'),
(3770, 10, '2019-05-09 17:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:28:52', '2019-05-11 05:28:52'),
(3771, 3, '2019-05-09 10:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:29:58', '2019-05-11 05:29:58'),
(3772, 3, '2019-05-09 17:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:29:58', '2019-05-11 05:29:58'),
(3773, 2, '2019-05-09 10:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:29:58', '2019-05-11 05:29:58'),
(3774, 2, '2019-05-09 17:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:29:58', '2019-05-11 05:29:58'),
(3775, 26, '2019-05-09 10:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:30:37', '2019-05-11 05:30:37'),
(3776, 26, '2019-05-09 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:30:37', '2019-05-11 05:30:37'),
(3777, 5, '2019-05-09 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:30:37', '2019-05-11 05:30:37'),
(3778, 5, '2019-05-09 16:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-11 05:30:37', '2019-05-11 05:30:37'),
(3789, 1, '2019-05-11 10:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:12:30', '2019-05-12 05:12:30'),
(3790, 1, '2019-05-11 17:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:12:30', '2019-05-12 05:12:30'),
(3791, 4, '2019-05-11 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:12:57', '2019-05-12 05:12:57'),
(3792, 4, '2019-05-11 16:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:12:57', '2019-05-12 05:12:57'),
(3793, 7, '2019-05-11 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:14:39', '2019-05-12 05:14:39'),
(3794, 7, '2019-05-11 17:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:14:39', '2019-05-12 05:14:39'),
(3795, 30, '2019-05-11 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:14:39', '2019-05-12 05:14:39'),
(3796, 30, '2019-05-11 17:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:14:39', '2019-05-12 05:14:39'),
(3797, 24, '2019-05-11 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:17:00', '2019-05-12 05:17:00'),
(3798, 24, '2019-05-11 17:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:17:00', '2019-05-12 05:17:00'),
(3799, 8, '2019-05-11 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:17:00', '2019-05-12 05:17:00'),
(3800, 8, '2019-05-11 16:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:17:00', '2019-05-12 05:17:00'),
(3801, 10, '2019-05-11 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:17:00', '2019-05-12 05:17:00'),
(3802, 10, '2019-05-11 17:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:17:00', '2019-05-12 05:17:00'),
(3803, 3, '2019-05-11 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:17:43', '2019-05-12 05:17:43'),
(3804, 3, '2019-05-11 17:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:17:43', '2019-05-12 05:17:43'),
(3805, 26, '2019-05-11 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:20:01', '2019-05-12 05:20:01'),
(3806, 26, '2019-05-11 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:20:01', '2019-05-12 05:20:01'),
(3807, 5, '2019-05-11 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:20:01', '2019-05-12 05:20:01'),
(3808, 5, '2019-05-11 17:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 05:20:01', '2019-05-12 05:20:01'),
(3821, 1, '2019-05-12 10:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 05:44:29', '2019-05-13 05:44:29'),
(3822, 1, '2019-05-12 17:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 05:44:29', '2019-05-13 05:44:29'),
(3823, 4, '2019-05-12 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 05:45:08', '2019-05-13 05:45:08'),
(3824, 4, '2019-05-12 16:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 05:45:08', '2019-05-13 05:45:08'),
(3825, 7, '2019-05-12 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 05:47:09', '2019-05-13 05:47:09'),
(3826, 7, '2019-05-12 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 05:47:09', '2019-05-13 05:47:09'),
(3827, 30, '2019-05-12 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 05:47:09', '2019-05-13 05:47:09'),
(3828, 30, '2019-05-12 16:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 05:47:09', '2019-05-13 05:47:09'),
(3829, 9, '2019-05-12 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:04:17', '2019-05-13 06:04:17'),
(3830, 9, '2019-05-12 17:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:04:17', '2019-05-13 06:04:17'),
(3831, 24, '2019-05-12 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:04:17', '2019-05-13 06:04:17'),
(3832, 24, '2019-05-12 17:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:04:17', '2019-05-13 06:04:17'),
(3833, 8, '2019-05-12 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:04:17', '2019-05-13 06:04:17'),
(3834, 8, '2019-05-12 16:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:04:17', '2019-05-13 06:04:17'),
(3835, 10, '2019-05-12 09:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:04:17', '2019-05-13 06:04:17'),
(3836, 10, '2019-05-12 17:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:04:17', '2019-05-13 06:04:17'),
(3837, 3, '2019-05-12 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:05:09', '2019-05-13 06:05:09'),
(3838, 3, '2019-05-12 16:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:05:09', '2019-05-13 06:05:09'),
(3839, 2, '2019-05-12 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:05:09', '2019-05-13 06:05:09'),
(3840, 2, '2019-05-12 17:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:05:09', '2019-05-13 06:05:09'),
(3841, 26, '2019-05-12 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:06:13', '2019-05-13 06:06:13'),
(3842, 26, '2019-05-12 16:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:06:13', '2019-05-13 06:06:13'),
(3843, 5, '2019-05-12 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:06:13', '2019-05-13 06:06:13'),
(3844, 5, '2019-05-12 16:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-13 06:06:13', '2019-05-13 06:06:13'),
(3857, 1, '2019-05-13 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:40:44', '2019-05-14 05:40:44'),
(3858, 1, '2019-05-13 16:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:40:44', '2019-05-14 05:40:44'),
(3859, 4, '2019-05-13 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:41:45', '2019-05-14 05:41:45'),
(3860, 4, '2019-05-13 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:41:45', '2019-05-14 05:41:45'),
(3861, 7, '2019-05-13 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:43:51', '2019-05-14 05:43:51'),
(3862, 7, '2019-05-13 16:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:43:51', '2019-05-14 05:43:51'),
(3863, 30, '2019-05-13 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:43:51', '2019-05-14 05:43:51'),
(3864, 30, '2019-05-13 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:43:51', '2019-05-14 05:43:51'),
(3865, 9, '2019-05-13 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:46:00', '2019-05-14 05:46:00'),
(3866, 9, '2019-05-13 16:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:46:00', '2019-05-14 05:46:00'),
(3867, 24, '2019-05-13 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:46:00', '2019-05-14 05:46:00'),
(3868, 24, '2019-05-13 16:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:46:00', '2019-05-14 05:46:00'),
(3869, 8, '2019-05-13 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:46:00', '2019-05-14 05:46:00'),
(3870, 8, '2019-05-13 16:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:46:00', '2019-05-14 05:46:00'),
(3871, 10, '2019-05-13 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:46:00', '2019-05-14 05:46:00'),
(3872, 10, '2019-05-13 16:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:46:00', '2019-05-14 05:46:00'),
(3873, 3, '2019-05-13 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:46:59', '2019-05-14 05:46:59'),
(3874, 3, '2019-05-13 16:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:46:59', '2019-05-14 05:46:59'),
(3875, 2, '2019-05-13 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:46:59', '2019-05-14 05:46:59'),
(3876, 2, '2019-05-13 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:46:59', '2019-05-14 05:46:59'),
(3877, 26, '2019-05-13 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:49:07', '2019-05-14 05:49:07'),
(3878, 26, '2019-05-13 15:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:49:07', '2019-05-14 05:49:07'),
(3879, 5, '2019-05-13 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:49:07', '2019-05-14 05:49:07'),
(3880, 5, '2019-05-13 16:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-14 05:49:07', '2019-05-14 05:49:07'),
(3893, 1, '2019-05-14 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:29:40', '2019-05-15 04:29:40'),
(3894, 1, '2019-05-14 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:29:40', '2019-05-15 04:29:40'),
(3895, 4, '2019-05-14 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:32:36', '2019-05-15 04:32:36'),
(3896, 4, '2019-05-14 16:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:32:36', '2019-05-15 04:32:36'),
(3897, 7, '2019-05-14 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:33:28', '2019-05-15 04:33:28'),
(3898, 7, '2019-05-14 16:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:33:28', '2019-05-15 04:33:28'),
(3899, 30, '2019-05-14 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:33:28', '2019-05-15 04:33:28'),
(3900, 30, '2019-05-14 15:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:33:28', '2019-05-15 04:33:28'),
(3901, 9, '2019-05-14 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:35:30', '2019-05-15 04:35:30'),
(3902, 9, '2019-05-14 16:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:35:30', '2019-05-15 04:35:30'),
(3903, 24, '2019-05-14 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:35:30', '2019-05-15 04:35:30'),
(3904, 24, '2019-05-14 16:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:35:30', '2019-05-15 04:35:30'),
(3905, 8, '2019-05-14 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:35:30', '2019-05-15 04:35:30'),
(3906, 8, '2019-05-14 16:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:35:30', '2019-05-15 04:35:30'),
(3907, 10, '2019-05-14 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:35:30', '2019-05-15 04:35:30'),
(3908, 10, '2019-05-14 16:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:35:30', '2019-05-15 04:35:30'),
(3909, 3, '2019-05-14 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:36:06', '2019-05-15 04:36:06'),
(3910, 3, '2019-05-14 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:36:06', '2019-05-15 04:36:06'),
(3911, 2, '2019-05-14 10:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:36:06', '2019-05-15 04:36:06'),
(3912, 2, '2019-05-14 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:36:06', '2019-05-15 04:36:06'),
(3913, 26, '2019-05-14 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:36:56', '2019-05-15 04:36:56'),
(3914, 26, '2019-05-14 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:36:56', '2019-05-15 04:36:56'),
(3915, 5, '2019-05-14 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:36:56', '2019-05-15 04:36:56'),
(3916, 5, '2019-05-14 16:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 04:36:56', '2019-05-15 04:36:56'),
(3929, 7, '2019-05-02 10:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 06:28:59', '2019-05-15 06:28:59'),
(3930, 7, '2019-05-02 19:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 06:28:59', '2019-05-15 06:28:59'),
(3931, 30, '2019-05-02 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 06:28:59', '2019-05-15 06:28:59'),
(3932, 30, '2019-05-02 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 06:28:59', '2019-05-15 06:28:59'),
(3933, 3, '2019-04-07 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 06:39:41', '2019-05-15 06:39:41'),
(3934, 3, '2019-04-07 18:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 06:39:41', '2019-05-15 06:39:41'),
(3935, 2, '2019-04-07 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 06:39:41', '2019-05-15 06:39:41'),
(3936, 2, '2019-04-07 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-15 06:39:41', '2019-05-15 06:39:41'),
(3937, 1, '2019-05-15 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:31:53', '2019-05-16 05:31:53'),
(3938, 1, '2019-05-15 17:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:31:53', '2019-05-16 05:31:53'),
(3939, 4, '2019-05-15 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:32:13', '2019-05-16 05:32:13'),
(3940, 4, '2019-05-15 16:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:32:13', '2019-05-16 05:32:13'),
(3941, 7, '2019-05-15 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:32:58', '2019-05-16 05:32:58'),
(3942, 7, '2019-05-15 17:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:32:58', '2019-05-16 05:32:58'),
(3943, 30, '2019-05-15 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:32:58', '2019-05-16 05:32:58'),
(3944, 30, '2019-05-15 15:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:32:58', '2019-05-16 05:32:58'),
(3945, 9, '2019-05-15 08:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:34:38', '2019-05-16 05:34:38'),
(3946, 9, '2019-05-15 17:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:34:38', '2019-05-16 05:34:38'),
(3947, 24, '2019-05-15 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:34:38', '2019-05-16 05:34:38'),
(3948, 24, '2019-05-15 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:34:38', '2019-05-16 05:34:38'),
(3949, 8, '2019-05-15 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:34:38', '2019-05-16 05:34:38'),
(3950, 8, '2019-05-15 16:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:34:38', '2019-05-16 05:34:38'),
(3951, 10, '2019-05-15 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:34:38', '2019-05-16 05:34:38'),
(3952, 10, '2019-05-15 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 05:34:38', '2019-05-16 05:34:38'),
(3953, 3, '2019-05-15 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 06:10:11', '2019-05-16 06:10:11'),
(3954, 3, '2019-05-15 17:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 06:10:11', '2019-05-16 06:10:11'),
(3955, 2, '2019-05-15 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 06:10:11', '2019-05-16 06:10:11'),
(3956, 2, '2019-05-15 17:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 06:10:11', '2019-05-16 06:10:11'),
(3957, 26, '2019-05-15 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 06:12:50', '2019-05-16 06:12:50'),
(3958, 26, '2019-05-15 16:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 06:12:50', '2019-05-16 06:12:50'),
(3959, 5, '2019-05-15 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 06:12:50', '2019-05-16 06:12:50'),
(3960, 5, '2019-05-15 17:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-16 06:12:50', '2019-05-16 06:12:50'),
(3973, 1, '2019-05-16 10:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:05:34', '2019-05-19 05:05:34'),
(3974, 1, '2019-05-16 19:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:05:34', '2019-05-19 05:05:34'),
(3975, 4, '2019-05-16 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:06:29', '2019-05-19 05:06:29'),
(3976, 4, '2019-05-16 19:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:06:29', '2019-05-19 05:06:29'),
(3977, 7, '2019-05-16 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:09:15', '2019-05-19 05:09:15'),
(3978, 7, '2019-05-16 19:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:09:15', '2019-05-19 05:09:15'),
(3979, 30, '2019-05-16 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:09:15', '2019-05-19 05:09:15'),
(3980, 30, '2019-05-16 15:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:09:15', '2019-05-19 05:09:15'),
(3981, 9, '2019-05-16 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:12:29', '2019-05-19 05:12:29'),
(3982, 9, '2019-05-16 15:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:12:29', '2019-05-19 05:12:29'),
(3983, 24, '2019-05-16 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:12:29', '2019-05-19 05:12:29'),
(3984, 24, '2019-05-16 19:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:12:29', '2019-05-19 05:12:29'),
(3985, 8, '2019-05-16 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:12:29', '2019-05-19 05:12:29'),
(3986, 8, '2019-05-16 19:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:12:29', '2019-05-19 05:12:29'),
(3987, 10, '2019-05-16 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:12:29', '2019-05-19 05:12:29'),
(3988, 10, '2019-05-16 19:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:12:29', '2019-05-19 05:12:29'),
(3989, 3, '2019-05-16 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:13:07', '2019-05-19 05:13:07'),
(3990, 3, '2019-05-16 19:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:13:07', '2019-05-19 05:13:07'),
(3991, 2, '2019-05-16 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:13:07', '2019-05-19 05:13:07'),
(3992, 2, '2019-05-16 19:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:13:07', '2019-05-19 05:13:07'),
(3993, 26, '2019-05-16 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:13:48', '2019-05-19 05:13:48'),
(3994, 26, '2019-05-16 19:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:13:48', '2019-05-19 05:13:48'),
(3995, 5, '2019-05-16 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:13:48', '2019-05-19 05:13:48'),
(3996, 5, '2019-05-16 19:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:13:48', '2019-05-19 05:13:48'),
(3997, 24, '2019-05-18 11:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:19:47', '2019-05-19 05:19:47'),
(3998, 24, '2019-05-18 16:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:19:47', '2019-05-19 05:19:47'),
(3999, 10, '2019-05-18 11:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:19:47', '2019-05-19 05:19:47'),
(4000, 10, '2019-05-18 16:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:19:47', '2019-05-19 05:19:47'),
(4001, 2, '2019-05-18 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:20:39', '2019-05-19 05:20:39'),
(4002, 2, '2019-05-18 16:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:20:39', '2019-05-19 05:20:39'),
(4003, 7, '2019-05-18 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:21:28', '2019-05-19 05:21:28'),
(4004, 7, '2019-05-18 16:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-19 05:21:28', '2019-05-19 05:21:28'),
(4016, 1, '2019-05-19 12:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:31:36', '2019-05-20 05:31:36'),
(4017, 1, '2019-05-19 16:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:31:36', '2019-05-20 05:31:36'),
(4018, 4, '2019-05-19 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:32:00', '2019-05-20 05:32:00'),
(4019, 4, '2019-05-19 16:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:32:00', '2019-05-20 05:32:00'),
(4020, 7, '2019-05-19 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:35:20', '2019-05-20 05:35:20'),
(4021, 7, '2019-05-19 17:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:35:20', '2019-05-20 05:35:20'),
(4022, 30, '2019-05-19 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:35:20', '2019-05-20 05:35:20'),
(4023, 30, '2019-05-19 15:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:35:20', '2019-05-20 05:35:20'),
(4024, 9, '2019-05-19 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:36:32', '2019-05-20 05:36:32'),
(4025, 9, '2019-05-19 17:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:36:32', '2019-05-20 05:36:32'),
(4026, 8, '2019-05-19 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:36:32', '2019-05-20 05:36:32'),
(4027, 8, '2019-05-19 16:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:36:32', '2019-05-20 05:36:32'),
(4028, 10, '2019-05-19 09:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:36:32', '2019-05-20 05:36:32'),
(4029, 10, '2019-05-19 17:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:36:32', '2019-05-20 05:36:32'),
(4030, 3, '2019-05-19 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:37:18', '2019-05-20 05:37:18'),
(4031, 3, '2019-05-19 16:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:37:18', '2019-05-20 05:37:18'),
(4032, 2, '2019-05-19 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:37:18', '2019-05-20 05:37:18'),
(4033, 2, '2019-05-19 16:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:37:18', '2019-05-20 05:37:18'),
(4034, 26, '2019-05-19 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:38:02', '2019-05-20 05:38:02'),
(4035, 26, '2019-05-19 16:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:38:02', '2019-05-20 05:38:02'),
(4036, 5, '2019-05-19 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:38:02', '2019-05-20 05:38:02'),
(4037, 5, '2019-05-19 16:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-20 05:38:02', '2019-05-20 05:38:02'),
(4049, 1, '2019-05-20 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:27:14', '2019-05-21 05:27:14'),
(4050, 1, '2019-05-20 16:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:27:14', '2019-05-21 05:27:14'),
(4051, 4, '2019-05-20 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:27:53', '2019-05-21 05:27:53'),
(4052, 4, '2019-05-20 16:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:27:53', '2019-05-21 05:27:53'),
(4053, 7, '2019-05-20 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:28:37', '2019-05-21 05:28:37'),
(4054, 7, '2019-05-20 16:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:28:37', '2019-05-21 05:28:37'),
(4055, 30, '2019-05-20 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:28:37', '2019-05-21 05:28:37'),
(4056, 30, '2019-05-20 16:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:28:37', '2019-05-21 05:28:37'),
(4057, 9, '2019-05-20 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:29:39', '2019-05-21 05:29:39'),
(4058, 9, '2019-05-20 16:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:29:39', '2019-05-21 05:29:39'),
(4059, 8, '2019-05-20 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:29:39', '2019-05-21 05:29:39'),
(4060, 8, '2019-05-20 16:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:29:39', '2019-05-21 05:29:39'),
(4061, 10, '2019-05-20 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:29:39', '2019-05-21 05:29:39'),
(4062, 10, '2019-05-20 16:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:29:39', '2019-05-21 05:29:39'),
(4063, 3, '2019-05-20 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:30:39', '2019-05-21 05:30:39'),
(4064, 3, '2019-05-20 16:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:30:39', '2019-05-21 05:30:39'),
(4065, 2, '2019-05-20 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:30:39', '2019-05-21 05:30:39'),
(4066, 2, '2019-05-20 16:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:30:39', '2019-05-21 05:30:39'),
(4067, 26, '2019-05-20 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:31:20', '2019-05-21 05:31:20'),
(4068, 26, '2019-05-20 16:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:31:20', '2019-05-21 05:31:20'),
(4069, 5, '2019-05-20 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:31:20', '2019-05-21 05:31:20'),
(4070, 5, '2019-05-20 16:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 05:31:20', '2019-05-21 05:31:20'),
(4084, 1, '2019-05-21 11:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:29:27', '2019-05-22 06:29:27'),
(4085, 1, '2019-05-21 15:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:29:27', '2019-05-22 06:29:27'),
(4086, 4, '2019-05-21 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:30:05', '2019-05-22 06:30:05'),
(4087, 4, '2019-05-21 16:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:30:05', '2019-05-22 06:30:05'),
(4088, 7, '2019-05-21 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:31:08', '2019-05-22 06:31:08'),
(4089, 7, '2019-05-21 16:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:31:08', '2019-05-22 06:31:08'),
(4090, 30, '2019-05-21 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:31:08', '2019-05-22 06:31:08'),
(4091, 30, '2019-05-21 15:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:31:08', '2019-05-22 06:31:08'),
(4092, 9, '2019-05-21 09:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:32:20', '2019-05-22 06:32:20'),
(4093, 9, '2019-05-21 16:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:32:20', '2019-05-22 06:32:20'),
(4094, 24, '2019-05-21 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:32:20', '2019-05-22 06:32:20'),
(4095, 24, '2019-05-21 11:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:32:20', '2019-05-22 06:32:20'),
(4096, 8, '2019-05-21 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:32:20', '2019-05-22 06:32:20'),
(4097, 8, '2019-05-21 16:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:32:20', '2019-05-22 06:32:20'),
(4098, 10, '2019-05-21 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:32:20', '2019-05-22 06:32:20'),
(4099, 10, '2019-05-21 16:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:32:20', '2019-05-22 06:32:20'),
(4100, 3, '2019-05-21 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:33:24', '2019-05-22 06:33:24'),
(4101, 3, '2019-05-21 15:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:33:25', '2019-05-22 06:33:25'),
(4102, 2, '2019-05-21 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:33:25', '2019-05-22 06:33:25'),
(4103, 2, '2019-05-21 15:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:33:25', '2019-05-22 06:33:25'),
(4104, 26, '2019-05-21 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:34:12', '2019-05-22 06:34:12'),
(4105, 26, '2019-05-21 16:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:34:12', '2019-05-22 06:34:12'),
(4106, 5, '2019-05-21 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:34:12', '2019-05-22 06:34:12'),
(4107, 5, '2019-05-21 16:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 06:34:12', '2019-05-22 06:34:12'),
(4120, 1, '2019-04-17 10:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 07:52:08', '2019-05-22 07:52:08'),
(4121, 1, '2019-04-17 19:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-22 07:52:08', '2019-05-22 07:52:08'),
(4122, 1, '2019-05-22 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:47:30', '2019-05-23 05:47:30'),
(4123, 1, '2019-05-22 14:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:47:30', '2019-05-23 05:47:30'),
(4124, 4, '2019-05-22 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:47:59', '2019-05-23 05:47:59'),
(4125, 4, '2019-05-22 16:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:47:59', '2019-05-23 05:47:59'),
(4126, 7, '2019-05-22 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:49:38', '2019-05-23 05:49:38'),
(4127, 7, '2019-05-22 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:49:38', '2019-05-23 05:49:38'),
(4128, 30, '2019-05-22 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:49:38', '2019-05-23 05:49:38'),
(4129, 30, '2019-05-22 15:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:49:38', '2019-05-23 05:49:38'),
(4130, 9, '2019-05-22 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:51:15', '2019-05-23 05:51:15'),
(4131, 9, '2019-05-22 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:51:15', '2019-05-23 05:51:15'),
(4132, 24, '2019-05-22 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:51:15', '2019-05-23 05:51:15'),
(4133, 24, '2019-05-22 16:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:51:15', '2019-05-23 05:51:15'),
(4134, 8, '2019-05-22 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:51:15', '2019-05-23 05:51:15'),
(4135, 8, '2019-05-22 16:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:51:15', '2019-05-23 05:51:15'),
(4136, 10, '2019-05-22 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:51:15', '2019-05-23 05:51:15'),
(4137, 10, '2019-05-22 16:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:51:15', '2019-05-23 05:51:15'),
(4138, 3, '2019-05-22 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:52:23', '2019-05-23 05:52:23'),
(4139, 3, '2019-05-22 16:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:52:23', '2019-05-23 05:52:23'),
(4140, 2, '2019-05-22 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:52:23', '2019-05-23 05:52:23'),
(4141, 2, '2019-05-22 16:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:52:23', '2019-05-23 05:52:23'),
(4142, 26, '2019-05-22 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:53:08', '2019-05-23 05:53:08'),
(4143, 26, '2019-05-22 16:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:53:08', '2019-05-23 05:53:08'),
(4144, 5, '2019-05-22 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:53:08', '2019-05-23 05:53:08'),
(4145, 5, '2019-05-22 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-23 05:53:08', '2019-05-23 05:53:08'),
(4157, 1, '2019-05-23 11:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:27:59', '2019-05-25 05:27:59'),
(4158, 1, '2019-05-23 16:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:28:00', '2019-05-25 05:28:00'),
(4159, 4, '2019-05-23 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:28:40', '2019-05-25 05:28:40'),
(4160, 4, '2019-05-23 15:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:28:40', '2019-05-25 05:28:40'),
(4161, 7, '2019-05-23 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:29:56', '2019-05-25 05:29:56'),
(4162, 7, '2019-05-23 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:29:56', '2019-05-25 05:29:56'),
(4163, 30, '2019-05-23 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:29:56', '2019-05-25 05:29:56'),
(4164, 30, '2019-05-23 15:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:29:56', '2019-05-25 05:29:56'),
(4165, 24, '2019-05-23 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:06', '2019-05-25 05:32:06'),
(4166, 24, '2019-05-23 17:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:06', '2019-05-25 05:32:06'),
(4167, 8, '2019-05-23 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:06', '2019-05-25 05:32:06'),
(4168, 8, '2019-05-23 15:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:06', '2019-05-25 05:32:06'),
(4169, 10, '2019-05-23 09:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:06', '2019-05-25 05:32:06'),
(4170, 10, '2019-05-23 17:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:06', '2019-05-25 05:32:06'),
(4171, 24, '2019-05-23 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:06', '2019-05-25 05:32:06'),
(4172, 24, '2019-05-23 17:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:06', '2019-05-25 05:32:06'),
(4173, 8, '2019-05-23 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:06', '2019-05-25 05:32:06'),
(4174, 8, '2019-05-23 15:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:06', '2019-05-25 05:32:06'),
(4175, 10, '2019-05-23 09:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:06', '2019-05-25 05:32:06'),
(4176, 10, '2019-05-23 17:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:06', '2019-05-25 05:32:06'),
(4177, 3, '2019-05-23 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:55', '2019-05-25 05:32:55'),
(4178, 3, '2019-05-23 17:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:55', '2019-05-25 05:32:55'),
(4179, 2, '2019-05-23 10:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:55', '2019-05-25 05:32:55'),
(4180, 2, '2019-05-23 16:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:32:55', '2019-05-25 05:32:55'),
(4181, 26, '2019-05-23 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:33:48', '2019-05-25 05:33:48'),
(4182, 26, '2019-05-23 15:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:33:48', '2019-05-25 05:33:48'),
(4183, 5, '2019-05-23 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:33:48', '2019-05-25 05:33:48'),
(4184, 5, '2019-05-23 15:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-25 05:33:48', '2019-05-25 05:33:48'),
(4195, 4, '2019-05-25 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:56:37', '2019-05-26 06:56:37'),
(4196, 4, '2019-05-25 16:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:56:37', '2019-05-26 06:56:37'),
(4197, 7, '2019-05-25 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:57:31', '2019-05-26 06:57:31'),
(4198, 7, '2019-05-25 16:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:57:31', '2019-05-26 06:57:31'),
(4199, 30, '2019-05-25 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:57:31', '2019-05-26 06:57:31'),
(4200, 30, '2019-05-25 16:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:57:31', '2019-05-26 06:57:31'),
(4201, 9, '2019-05-25 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:58:44', '2019-05-26 06:58:44'),
(4202, 9, '2019-05-25 16:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:58:44', '2019-05-26 06:58:44'),
(4203, 24, '2019-05-25 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:58:44', '2019-05-26 06:58:44'),
(4204, 24, '2019-05-25 16:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:58:44', '2019-05-26 06:58:44'),
(4205, 8, '2019-05-25 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:58:44', '2019-05-26 06:58:44'),
(4206, 8, '2019-05-25 16:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:58:44', '2019-05-26 06:58:44'),
(4207, 10, '2019-05-25 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:58:44', '2019-05-26 06:58:44'),
(4208, 10, '2019-05-25 16:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:58:44', '2019-05-26 06:58:44'),
(4209, 2, '2019-05-25 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:59:16', '2019-05-26 06:59:16'),
(4210, 2, '2019-05-25 15:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 06:59:16', '2019-05-26 06:59:16'),
(4211, 26, '2019-05-25 11:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 07:00:14', '2019-05-26 07:00:14'),
(4212, 26, '2019-05-25 16:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 07:00:14', '2019-05-26 07:00:14'),
(4213, 5, '2019-05-25 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 07:00:14', '2019-05-26 07:00:14'),
(4214, 5, '2019-05-25 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-26 07:00:14', '2019-05-26 07:00:14'),
(4227, 1, '2019-05-26 11:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:27:10', '2019-05-28 05:27:10'),
(4228, 1, '2019-05-26 16:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:27:10', '2019-05-28 05:27:10'),
(4233, 7, '2019-05-26 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:28:43', '2019-05-28 05:28:43'),
(4234, 7, '2019-05-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:28:43', '2019-05-28 05:28:43'),
(4235, 30, '2019-05-26 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:28:43', '2019-05-28 05:28:43'),
(4236, 30, '2019-05-26 15:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:28:43', '2019-05-28 05:28:43'),
(4237, 4, '2019-05-26 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:29:21', '2019-05-28 05:29:21'),
(4238, 4, '2019-05-26 16:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:29:21', '2019-05-28 05:29:21'),
(4239, 9, '2019-05-26 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:30:44', '2019-05-28 05:30:44'),
(4240, 9, '2019-05-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:30:44', '2019-05-28 05:30:44'),
(4241, 24, '2019-05-26 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:30:44', '2019-05-28 05:30:44'),
(4242, 24, '2019-05-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:30:44', '2019-05-28 05:30:44'),
(4243, 8, '2019-05-26 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:30:44', '2019-05-28 05:30:44'),
(4244, 8, '2019-05-26 16:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:30:44', '2019-05-28 05:30:44'),
(4245, 10, '2019-05-26 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:30:44', '2019-05-28 05:30:44'),
(4246, 10, '2019-05-26 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:30:44', '2019-05-28 05:30:44'),
(4247, 3, '2019-05-26 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:31:33', '2019-05-28 05:31:33'),
(4248, 3, '2019-05-26 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:31:33', '2019-05-28 05:31:33'),
(4249, 2, '2019-05-26 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:31:33', '2019-05-28 05:31:33'),
(4250, 2, '2019-05-26 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:31:33', '2019-05-28 05:31:33'),
(4251, 26, '2019-05-26 10:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:32:06', '2019-05-28 05:32:06'),
(4252, 26, '2019-05-26 16:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:32:06', '2019-05-28 05:32:06'),
(4253, 5, '2019-05-26 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:32:06', '2019-05-28 05:32:06'),
(4254, 5, '2019-05-26 16:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:32:06', '2019-05-28 05:32:06'),
(4255, 1, '2019-05-27 10:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:34:47', '2019-05-28 05:34:47'),
(4256, 1, '2019-05-27 16:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:34:47', '2019-05-28 05:34:47'),
(4257, 4, '2019-05-27 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:35:51', '2019-05-28 05:35:51'),
(4258, 4, '2019-05-27 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:35:51', '2019-05-28 05:35:51'),
(4259, 7, '2019-05-27 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:36:55', '2019-05-28 05:36:55'),
(4260, 7, '2019-05-27 16:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:36:55', '2019-05-28 05:36:55'),
(4261, 30, '2019-05-27 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:36:55', '2019-05-28 05:36:55'),
(4262, 30, '2019-05-27 16:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:36:55', '2019-05-28 05:36:55'),
(4263, 9, '2019-05-27 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:39:06', '2019-05-28 05:39:06'),
(4264, 9, '2019-05-27 16:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:39:06', '2019-05-28 05:39:06'),
(4265, 24, '2019-05-27 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:39:06', '2019-05-28 05:39:06'),
(4266, 24, '2019-05-27 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:39:06', '2019-05-28 05:39:06'),
(4267, 10, '2019-05-27 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:39:06', '2019-05-28 05:39:06'),
(4268, 10, '2019-05-27 16:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:39:06', '2019-05-28 05:39:06'),
(4269, 3, '2019-05-27 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:40:13', '2019-05-28 05:40:13'),
(4270, 3, '2019-05-27 16:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:40:13', '2019-05-28 05:40:13'),
(4271, 2, '2019-05-27 10:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:40:13', '2019-05-28 05:40:13'),
(4272, 2, '2019-05-27 16:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:40:13', '2019-05-28 05:40:13'),
(4273, 26, '2019-05-27 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:42:37', '2019-05-28 05:42:37'),
(4274, 26, '2019-05-27 16:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:42:37', '2019-05-28 05:42:37'),
(4275, 5, '2019-05-27 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:42:37', '2019-05-28 05:42:37'),
(4276, 5, '2019-05-27 16:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-28 05:42:37', '2019-05-28 05:42:37'),
(4290, 1, '2019-05-28 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:32:29', '2019-05-29 05:32:29'),
(4291, 1, '2019-05-28 16:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:32:29', '2019-05-29 05:32:29'),
(4292, 4, '2019-05-28 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:33:07', '2019-05-29 05:33:07'),
(4293, 4, '2019-05-28 16:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:33:07', '2019-05-29 05:33:07'),
(4294, 7, '2019-05-28 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:33:59', '2019-05-29 05:33:59'),
(4295, 7, '2019-05-28 17:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:33:59', '2019-05-29 05:33:59'),
(4296, 30, '2019-05-28 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:33:59', '2019-05-29 05:33:59'),
(4297, 30, '2019-05-28 15:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:33:59', '2019-05-29 05:33:59'),
(4298, 9, '2019-05-28 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:36:59', '2019-05-29 05:36:59'),
(4299, 9, '2019-05-28 17:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:36:59', '2019-05-29 05:36:59'),
(4300, 24, '2019-05-28 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:36:59', '2019-05-29 05:36:59'),
(4301, 24, '2019-05-28 17:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:36:59', '2019-05-29 05:36:59'),
(4302, 8, '2019-05-28 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:36:59', '2019-05-29 05:36:59'),
(4303, 8, '2019-05-28 12:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:36:59', '2019-05-29 05:36:59'),
(4304, 10, '2019-05-28 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:36:59', '2019-05-29 05:36:59'),
(4305, 10, '2019-05-28 17:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:36:59', '2019-05-29 05:36:59'),
(4306, 3, '2019-05-28 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:38:44', '2019-05-29 05:38:44'),
(4307, 3, '2019-05-28 17:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:38:44', '2019-05-29 05:38:44'),
(4308, 2, '2019-05-28 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:38:44', '2019-05-29 05:38:44'),
(4309, 2, '2019-05-28 16:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:38:44', '2019-05-29 05:38:44'),
(4310, 26, '2019-05-28 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:39:49', '2019-05-29 05:39:49'),
(4311, 26, '2019-05-28 17:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:39:49', '2019-05-29 05:39:49'),
(4312, 5, '2019-05-28 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:39:49', '2019-05-29 05:39:49'),
(4313, 5, '2019-05-28 17:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-29 05:39:49', '2019-05-29 05:39:49'),
(4326, 1, '2019-05-29 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:22:30', '2019-05-30 05:22:30'),
(4327, 1, '2019-05-29 16:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:22:30', '2019-05-30 05:22:30'),
(4328, 4, '2019-05-29 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:23:28', '2019-05-30 05:23:28'),
(4329, 4, '2019-05-29 16:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:23:28', '2019-05-30 05:23:28'),
(4330, 7, '2019-05-29 09:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:24:49', '2019-05-30 05:24:49'),
(4331, 7, '2019-05-29 18:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:24:49', '2019-05-30 05:24:49'),
(4332, 30, '2019-05-29 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:24:49', '2019-05-30 05:24:49'),
(4333, 30, '2019-05-29 15:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:24:49', '2019-05-30 05:24:49'),
(4334, 9, '2019-05-29 09:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:26:17', '2019-05-30 05:26:17'),
(4335, 9, '2019-05-29 19:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:26:17', '2019-05-30 05:26:17'),
(4336, 24, '2019-05-29 09:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:26:17', '2019-05-30 05:26:17'),
(4337, 24, '2019-05-29 19:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:26:17', '2019-05-30 05:26:17');
INSERT INTO `employee_attendance` (`employee_attendance_id`, `finger_print_id`, `in_out_time`, `check_type`, `verify_code`, `sensor_id`, `Memoinfo`, `WorkCode`, `sn`, `UserExtFmt`, `mechine_sl`, `created_at`, `updated_at`) VALUES
(4338, 8, '2019-05-29 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:26:17', '2019-05-30 05:26:17'),
(4339, 8, '2019-05-29 16:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:26:17', '2019-05-30 05:26:17'),
(4340, 10, '2019-05-29 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:26:17', '2019-05-30 05:26:17'),
(4341, 10, '2019-05-29 19:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:26:17', '2019-05-30 05:26:17'),
(4342, 3, '2019-05-29 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:28:09', '2019-05-30 05:28:09'),
(4343, 3, '2019-05-29 18:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:28:09', '2019-05-30 05:28:09'),
(4344, 2, '2019-05-29 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:28:09', '2019-05-30 05:28:09'),
(4345, 2, '2019-05-29 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:28:09', '2019-05-30 05:28:09'),
(4346, 26, '2019-05-29 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:30:23', '2019-05-30 05:30:23'),
(4347, 26, '2019-05-29 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:30:23', '2019-05-30 05:30:23'),
(4348, 5, '2019-05-29 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:30:23', '2019-05-30 05:30:23'),
(4349, 5, '2019-05-29 16:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-30 05:30:23', '2019-05-30 05:30:23'),
(4362, 1, '2019-05-30 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:53:17', '2019-06-01 05:53:17'),
(4363, 1, '2019-05-30 20:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:53:17', '2019-06-01 05:53:17'),
(4364, 4, '2019-05-30 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:54:07', '2019-06-01 05:54:07'),
(4365, 4, '2019-05-30 19:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:54:07', '2019-06-01 05:54:07'),
(4366, 7, '2019-05-30 09:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:55:27', '2019-06-01 05:55:27'),
(4367, 7, '2019-05-30 20:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:55:27', '2019-06-01 05:55:27'),
(4368, 30, '2019-05-30 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:55:27', '2019-06-01 05:55:27'),
(4369, 30, '2019-05-30 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:55:27', '2019-06-01 05:55:27'),
(4370, 9, '2019-05-30 09:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:57:45', '2019-06-01 05:57:45'),
(4371, 9, '2019-05-30 21:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:57:45', '2019-06-01 05:57:45'),
(4372, 24, '2019-05-30 09:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:57:45', '2019-06-01 05:57:45'),
(4373, 24, '2019-05-30 21:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:57:45', '2019-06-01 05:57:45'),
(4374, 8, '2019-05-30 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:57:45', '2019-06-01 05:57:45'),
(4375, 8, '2019-05-30 19:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:57:45', '2019-06-01 05:57:45'),
(4376, 10, '2019-05-30 09:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:57:45', '2019-06-01 05:57:45'),
(4377, 10, '2019-05-30 21:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 05:57:45', '2019-06-01 05:57:45'),
(4378, 3, '2019-05-30 09:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 06:00:29', '2019-06-01 06:00:29'),
(4379, 3, '2019-05-30 20:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 06:00:29', '2019-06-01 06:00:29'),
(4380, 2, '2019-05-30 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 06:00:29', '2019-06-01 06:00:29'),
(4381, 2, '2019-05-30 20:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 06:00:29', '2019-06-01 06:00:29'),
(4382, 26, '2019-05-30 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 06:01:44', '2019-06-01 06:01:44'),
(4383, 26, '2019-05-30 20:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 06:01:44', '2019-06-01 06:01:44'),
(4384, 5, '2019-05-30 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 06:01:44', '2019-06-01 06:01:44'),
(4385, 5, '2019-05-30 20:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-01 06:01:44', '2019-06-01 06:01:44'),
(4398, 1, '2019-06-01 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:40:59', '2019-06-03 04:40:59'),
(4399, 1, '2019-06-01 16:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:40:59', '2019-06-03 04:40:59'),
(4400, 4, '2019-06-01 09:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:41:35', '2019-06-03 04:41:35'),
(4401, 4, '2019-06-01 16:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:41:35', '2019-06-03 04:41:35'),
(4402, 7, '2019-06-01 09:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:42:12', '2019-06-03 04:42:12'),
(4403, 7, '2019-06-01 16:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:42:12', '2019-06-03 04:42:12'),
(4404, 30, '2019-06-01 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:42:12', '2019-06-03 04:42:12'),
(4405, 30, '2019-06-01 16:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:42:12', '2019-06-03 04:42:12'),
(4406, 9, '2019-06-01 09:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:43:20', '2019-06-03 04:43:20'),
(4407, 9, '2019-06-01 16:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:43:20', '2019-06-03 04:43:20'),
(4408, 24, '2019-06-01 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:43:20', '2019-06-03 04:43:20'),
(4409, 24, '2019-06-01 16:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:43:20', '2019-06-03 04:43:20'),
(4410, 8, '2019-06-01 09:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:43:20', '2019-06-03 04:43:20'),
(4411, 8, '2019-06-01 16:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:43:20', '2019-06-03 04:43:20'),
(4412, 10, '2019-06-01 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:43:20', '2019-06-03 04:43:20'),
(4413, 10, '2019-06-01 16:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:43:20', '2019-06-03 04:43:20'),
(4414, 3, '2019-06-01 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:46:36', '2019-06-03 04:46:36'),
(4415, 3, '2019-06-01 16:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:46:36', '2019-06-03 04:46:36'),
(4416, 2, '2019-06-01 12:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:46:36', '2019-06-03 04:46:36'),
(4417, 2, '2019-06-01 16:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:46:36', '2019-06-03 04:46:36'),
(4418, 26, '2019-06-01 10:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:47:31', '2019-06-03 04:47:31'),
(4419, 26, '2019-06-01 16:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:47:31', '2019-06-03 04:47:31'),
(4420, 5, '2019-06-01 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:47:31', '2019-06-03 04:47:31'),
(4421, 5, '2019-06-01 16:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-03 04:47:31', '2019-06-03 04:47:31'),
(4434, 1, '2019-06-03 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:10:47', '2019-06-11 06:10:47'),
(4435, 1, '2019-06-03 21:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:10:47', '2019-06-11 06:10:47'),
(4436, 4, '2019-06-03 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:12:35', '2019-06-11 06:12:35'),
(4437, 4, '2019-06-03 14:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:12:35', '2019-06-11 06:12:35'),
(4438, 7, '2019-06-03 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:14:50', '2019-06-11 06:14:50'),
(4439, 7, '2019-06-03 21:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:14:50', '2019-06-11 06:14:50'),
(4440, 30, '2019-06-03 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:14:50', '2019-06-11 06:14:50'),
(4441, 30, '2019-06-03 19:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:14:50', '2019-06-11 06:14:50'),
(4450, 3, '2019-06-03 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:17:49', '2019-06-11 06:17:49'),
(4451, 3, '2019-06-03 21:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:17:49', '2019-06-11 06:17:49'),
(4452, 2, '2019-06-03 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:17:49', '2019-06-11 06:17:49'),
(4453, 2, '2019-06-03 21:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:17:49', '2019-06-11 06:17:49'),
(4454, 26, '2019-06-03 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:18:37', '2019-06-11 06:18:37'),
(4455, 26, '2019-06-03 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:18:37', '2019-06-11 06:18:37'),
(4456, 5, '2019-06-03 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:18:37', '2019-06-11 06:18:37'),
(4457, 5, '2019-06-03 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:18:37', '2019-06-11 06:18:37'),
(4458, 7, '2019-06-09 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:20:58', '2019-06-11 06:20:58'),
(4459, 7, '2019-06-09 16:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:20:58', '2019-06-11 06:20:58'),
(4460, 3, '2019-06-09 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:21:56', '2019-06-11 06:21:56'),
(4461, 3, '2019-06-09 16:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:21:56', '2019-06-11 06:21:56'),
(4462, 9, '2019-06-09 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:23:32', '2019-06-11 06:23:32'),
(4463, 9, '2019-06-09 17:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:23:32', '2019-06-11 06:23:32'),
(4464, 24, '2019-06-09 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:23:32', '2019-06-11 06:23:32'),
(4465, 24, '2019-06-09 17:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:23:32', '2019-06-11 06:23:32'),
(4466, 7, '2019-06-10 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:26:45', '2019-06-11 06:26:45'),
(4467, 7, '2019-06-10 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:26:45', '2019-06-11 06:26:45'),
(4468, 9, '2019-06-10 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:29:37', '2019-06-11 06:29:37'),
(4469, 9, '2019-06-10 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:29:37', '2019-06-11 06:29:37'),
(4470, 24, '2019-06-10 09:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:29:37', '2019-06-11 06:29:37'),
(4471, 24, '2019-06-10 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:29:37', '2019-06-11 06:29:37'),
(4472, 8, '2019-06-10 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:29:37', '2019-06-11 06:29:37'),
(4473, 8, '2019-06-10 17:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:29:37', '2019-06-11 06:29:37'),
(4474, 10, '2019-06-10 09:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:29:37', '2019-06-11 06:29:37'),
(4475, 10, '2019-06-10 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:29:37', '2019-06-11 06:29:37'),
(4476, 3, '2019-06-10 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:30:47', '2019-06-11 06:30:47'),
(4477, 3, '2019-06-10 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:30:47', '2019-06-11 06:30:47'),
(4478, 26, '2019-06-10 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:32:36', '2019-06-11 06:32:36'),
(4479, 26, '2019-06-10 18:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:32:36', '2019-06-11 06:32:36'),
(4480, 5, '2019-06-10 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:32:36', '2019-06-11 06:32:36'),
(4481, 5, '2019-06-10 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-11 06:32:36', '2019-06-11 06:32:36'),
(4494, 1, '2019-06-11 11:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:16:48', '2019-06-12 09:16:48'),
(4495, 1, '2019-06-11 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:16:48', '2019-06-12 09:16:48'),
(4496, 4, '2019-06-11 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:17:24', '2019-06-12 09:17:24'),
(4497, 4, '2019-06-11 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:17:24', '2019-06-12 09:17:24'),
(4498, 7, '2019-06-11 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:18:04', '2019-06-12 09:18:04'),
(4499, 7, '2019-06-11 16:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:18:04', '2019-06-12 09:18:04'),
(4500, 30, '2019-06-11 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:18:04', '2019-06-12 09:18:04'),
(4501, 30, '2019-06-11 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:18:04', '2019-06-12 09:18:04'),
(4502, 9, '2019-06-11 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:20:40', '2019-06-12 09:20:40'),
(4503, 9, '2019-06-11 18:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:20:40', '2019-06-12 09:20:40'),
(4504, 24, '2019-06-11 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:20:40', '2019-06-12 09:20:40'),
(4505, 24, '2019-06-11 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:20:40', '2019-06-12 09:20:40'),
(4506, 8, '2019-06-11 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:20:40', '2019-06-12 09:20:40'),
(4507, 8, '2019-06-11 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:20:40', '2019-06-12 09:20:40'),
(4508, 10, '2019-06-11 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:20:40', '2019-06-12 09:20:40'),
(4509, 10, '2019-06-11 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:20:40', '2019-06-12 09:20:40'),
(4510, 3, '2019-06-11 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:21:28', '2019-06-12 09:21:28'),
(4511, 3, '2019-06-11 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:21:28', '2019-06-12 09:21:28'),
(4512, 2, '2019-06-11 11:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:21:28', '2019-06-12 09:21:28'),
(4513, 2, '2019-06-11 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:21:28', '2019-06-12 09:21:28'),
(4514, 26, '2019-06-11 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:22:46', '2019-06-12 09:22:46'),
(4515, 26, '2019-06-11 18:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:22:47', '2019-06-12 09:22:47'),
(4516, 5, '2019-06-11 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:22:47', '2019-06-12 09:22:47'),
(4517, 5, '2019-06-11 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-12 09:22:47', '2019-06-12 09:22:47'),
(4529, 4, '2019-06-12 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:44:39', '2019-06-13 06:44:39'),
(4530, 4, '2019-06-12 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:44:39', '2019-06-13 06:44:39'),
(4531, 7, '2019-06-12 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:45:27', '2019-06-13 06:45:27'),
(4532, 7, '2019-06-12 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:45:27', '2019-06-13 06:45:27'),
(4533, 30, '2019-06-12 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:45:27', '2019-06-13 06:45:27'),
(4534, 30, '2019-06-12 18:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:45:27', '2019-06-13 06:45:27'),
(4535, 9, '2019-06-12 09:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:46:31', '2019-06-13 06:46:31'),
(4536, 9, '2019-06-12 18:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:46:32', '2019-06-13 06:46:32'),
(4537, 24, '2019-06-12 09:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:46:32', '2019-06-13 06:46:32'),
(4538, 24, '2019-06-12 18:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:46:32', '2019-06-13 06:46:32'),
(4539, 8, '2019-06-12 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:46:32', '2019-06-13 06:46:32'),
(4540, 8, '2019-06-12 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:46:32', '2019-06-13 06:46:32'),
(4541, 10, '2019-06-12 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:46:32', '2019-06-13 06:46:32'),
(4542, 10, '2019-06-12 18:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:46:32', '2019-06-13 06:46:32'),
(4543, 3, '2019-06-12 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:47:21', '2019-06-13 06:47:21'),
(4544, 3, '2019-06-12 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:47:22', '2019-06-13 06:47:22'),
(4545, 2, '2019-06-12 10:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:47:22', '2019-06-13 06:47:22'),
(4546, 2, '2019-06-12 17:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:47:22', '2019-06-13 06:47:22'),
(4547, 3, '2019-06-12 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:47:22', '2019-06-13 06:47:22'),
(4548, 3, '2019-06-12 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:47:22', '2019-06-13 06:47:22'),
(4549, 2, '2019-06-12 10:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:47:22', '2019-06-13 06:47:22'),
(4550, 2, '2019-06-12 17:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:47:22', '2019-06-13 06:47:22'),
(4551, 26, '2019-06-12 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:49:56', '2019-06-13 06:49:56'),
(4552, 26, '2019-06-12 18:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:49:56', '2019-06-13 06:49:56'),
(4553, 5, '2019-06-12 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:49:56', '2019-06-13 06:49:56'),
(4554, 5, '2019-06-12 18:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-13 06:49:56', '2019-06-13 06:49:56'),
(4566, 4, '2019-06-13 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:35:46', '2019-06-15 06:35:46'),
(4567, 4, '2019-06-13 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:35:47', '2019-06-15 06:35:47'),
(4568, 7, '2019-06-13 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:36:51', '2019-06-15 06:36:51'),
(4569, 7, '2019-06-13 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:36:51', '2019-06-15 06:36:51'),
(4570, 30, '2019-06-13 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:36:51', '2019-06-15 06:36:51'),
(4571, 30, '2019-06-13 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:36:51', '2019-06-15 06:36:51'),
(4572, 9, '2019-06-13 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:38:53', '2019-06-15 06:38:53'),
(4573, 9, '2019-06-13 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:38:53', '2019-06-15 06:38:53'),
(4574, 24, '2019-06-13 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:38:53', '2019-06-15 06:38:53'),
(4575, 24, '2019-06-13 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:38:53', '2019-06-15 06:38:53'),
(4576, 8, '2019-06-13 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:38:53', '2019-06-15 06:38:53'),
(4577, 8, '2019-06-13 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:38:53', '2019-06-15 06:38:53'),
(4578, 10, '2019-06-13 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:38:53', '2019-06-15 06:38:53'),
(4579, 10, '2019-06-13 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:38:53', '2019-06-15 06:38:53'),
(4580, 3, '2019-06-13 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:40:03', '2019-06-15 06:40:03'),
(4581, 3, '2019-06-13 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:40:03', '2019-06-15 06:40:03'),
(4582, 2, '2019-06-13 10:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:40:03', '2019-06-15 06:40:03'),
(4583, 2, '2019-06-13 17:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:40:03', '2019-06-15 06:40:03'),
(4584, 26, '2019-06-13 10:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:40:49', '2019-06-15 06:40:49'),
(4585, 26, '2019-06-13 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:40:49', '2019-06-15 06:40:49'),
(4586, 5, '2019-06-13 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:40:49', '2019-06-15 06:40:49'),
(4587, 5, '2019-06-13 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-15 06:40:49', '2019-06-15 06:40:49'),
(4600, 1, '2019-06-15 11:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 05:58:48', '2019-06-16 05:58:48'),
(4601, 1, '2019-06-15 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 05:58:48', '2019-06-16 05:58:48'),
(4602, 4, '2019-06-15 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 05:59:10', '2019-06-16 05:59:10'),
(4603, 4, '2019-06-15 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 05:59:10', '2019-06-16 05:59:10'),
(4604, 7, '2019-06-15 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:00:12', '2019-06-16 06:00:12'),
(4605, 7, '2019-06-15 17:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:00:12', '2019-06-16 06:00:12'),
(4606, 30, '2019-06-15 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:00:12', '2019-06-16 06:00:12'),
(4607, 30, '2019-06-15 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:00:12', '2019-06-16 06:00:12'),
(4608, 9, '2019-06-15 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:04:10', '2019-06-16 06:04:10'),
(4609, 9, '2019-06-15 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:04:10', '2019-06-16 06:04:10'),
(4610, 24, '2019-06-15 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:04:10', '2019-06-16 06:04:10'),
(4611, 24, '2019-06-15 16:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:04:10', '2019-06-16 06:04:10'),
(4612, 8, '2019-06-15 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:04:10', '2019-06-16 06:04:10'),
(4613, 8, '2019-06-15 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:04:10', '2019-06-16 06:04:10'),
(4614, 10, '2019-06-15 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:04:10', '2019-06-16 06:04:10'),
(4615, 10, '2019-06-15 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:04:10', '2019-06-16 06:04:10'),
(4616, 3, '2019-06-15 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:04:49', '2019-06-16 06:04:49'),
(4617, 3, '2019-06-15 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:04:49', '2019-06-16 06:04:49'),
(4618, 2, '2019-06-15 11:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:04:49', '2019-06-16 06:04:49'),
(4619, 2, '2019-06-15 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:04:49', '2019-06-16 06:04:49'),
(4620, 26, '2019-06-15 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:05:46', '2019-06-16 06:05:46'),
(4621, 26, '2019-06-15 14:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:05:46', '2019-06-16 06:05:46'),
(4622, 5, '2019-06-15 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:05:46', '2019-06-16 06:05:46'),
(4623, 5, '2019-06-15 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-16 06:05:46', '2019-06-16 06:05:46'),
(4635, 1, '2019-06-16 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-17 10:03:12', '2019-06-17 10:03:12'),
(4636, 1, '2019-06-16 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-17 10:03:12', '2019-06-17 10:03:12'),
(4639, 30, '2019-06-16 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-17 10:04:35', '2019-06-17 10:04:35'),
(4640, 30, '2019-06-16 18:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-17 10:04:35', '2019-06-17 10:04:35'),
(4649, 3, '2019-06-16 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-17 10:14:30', '2019-06-17 10:14:30'),
(4650, 3, '2019-06-16 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-17 10:14:30', '2019-06-17 10:14:30'),
(4651, 2, '2019-06-16 10:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-17 10:14:30', '2019-06-17 10:14:30'),
(4652, 2, '2019-06-16 19:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-17 10:14:30', '2019-06-17 10:14:30'),
(4653, 26, '2019-06-16 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-17 10:17:05', '2019-06-17 10:17:05'),
(4654, 26, '2019-06-16 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-17 10:17:05', '2019-06-17 10:17:05'),
(4655, 5, '2019-06-16 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-17 10:17:05', '2019-06-17 10:17:05'),
(4656, 5, '2019-06-16 19:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-17 10:17:05', '2019-06-17 10:17:05'),
(4669, 1, '2019-06-17 11:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:18:48', '2019-06-18 06:18:48'),
(4670, 1, '2019-06-17 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:18:48', '2019-06-18 06:18:48'),
(4671, 4, '2019-06-17 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:19:11', '2019-06-18 06:19:11'),
(4672, 4, '2019-06-17 19:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:19:11', '2019-06-18 06:19:11'),
(4673, 7, '2019-06-17 10:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:19:46', '2019-06-18 06:19:46'),
(4674, 7, '2019-06-17 19:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:19:46', '2019-06-18 06:19:46'),
(4675, 30, '2019-06-17 10:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:19:46', '2019-06-18 06:19:46'),
(4676, 30, '2019-06-17 19:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:19:46', '2019-06-18 06:19:46'),
(4677, 9, '2019-06-17 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:20:59', '2019-06-18 06:20:59'),
(4678, 9, '2019-06-17 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:20:59', '2019-06-18 06:20:59'),
(4679, 24, '2019-06-17 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:20:59', '2019-06-18 06:20:59'),
(4680, 24, '2019-06-17 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:20:59', '2019-06-18 06:20:59'),
(4681, 8, '2019-06-17 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:20:59', '2019-06-18 06:20:59'),
(4682, 8, '2019-06-17 19:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:20:59', '2019-06-18 06:20:59'),
(4683, 10, '2019-06-17 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:20:59', '2019-06-18 06:20:59'),
(4684, 10, '2019-06-17 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:20:59', '2019-06-18 06:20:59'),
(4685, 3, '2019-06-17 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:30:34', '2019-06-18 06:30:34'),
(4686, 3, '2019-06-17 19:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:30:34', '2019-06-18 06:30:34'),
(4687, 2, '2019-06-17 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:30:34', '2019-06-18 06:30:34'),
(4688, 2, '2019-06-17 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:30:34', '2019-06-18 06:30:34'),
(4689, 26, '2019-06-17 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:31:17', '2019-06-18 06:31:17'),
(4690, 26, '2019-06-17 19:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:31:17', '2019-06-18 06:31:17'),
(4691, 5, '2019-06-17 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:31:17', '2019-06-18 06:31:17'),
(4692, 5, '2019-06-17 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-18 06:31:17', '2019-06-18 06:31:17'),
(4705, 1, '2019-06-18 11:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:40:44', '2019-06-19 10:40:44'),
(4706, 1, '2019-06-18 19:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:40:44', '2019-06-19 10:40:44'),
(4707, 4, '2019-06-18 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:42:44', '2019-06-19 10:42:44'),
(4708, 4, '2019-06-18 19:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:42:44', '2019-06-19 10:42:44'),
(4709, 7, '2019-06-18 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:53:11', '2019-06-19 10:53:11'),
(4710, 7, '2019-06-18 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:53:12', '2019-06-19 10:53:12'),
(4711, 30, '2019-06-18 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:53:12', '2019-06-19 10:53:12'),
(4712, 30, '2019-06-18 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:53:12', '2019-06-19 10:53:12'),
(4713, 9, '2019-06-18 09:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:54:49', '2019-06-19 10:54:49'),
(4714, 9, '2019-06-18 19:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:54:49', '2019-06-19 10:54:49'),
(4715, 24, '2019-06-18 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:54:49', '2019-06-19 10:54:49'),
(4716, 24, '2019-06-18 19:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:54:49', '2019-06-19 10:54:49'),
(4717, 8, '2019-06-18 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:54:49', '2019-06-19 10:54:49'),
(4718, 8, '2019-06-18 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:54:49', '2019-06-19 10:54:49'),
(4719, 10, '2019-06-18 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:54:49', '2019-06-19 10:54:49'),
(4720, 10, '2019-06-18 19:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:54:49', '2019-06-19 10:54:49'),
(4721, 3, '2019-06-18 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:59:52', '2019-06-19 10:59:52'),
(4722, 3, '2019-06-18 19:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:59:52', '2019-06-19 10:59:52'),
(4723, 2, '2019-06-18 11:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:59:52', '2019-06-19 10:59:52'),
(4724, 2, '2019-06-18 19:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 10:59:52', '2019-06-19 10:59:52'),
(4725, 26, '2019-06-18 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 11:00:53', '2019-06-19 11:00:53'),
(4726, 26, '2019-06-18 18:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 11:00:53', '2019-06-19 11:00:53'),
(4727, 5, '2019-06-18 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 11:00:53', '2019-06-19 11:00:53'),
(4728, 5, '2019-06-18 19:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-19 11:00:53', '2019-06-19 11:00:53'),
(4741, 1, '2019-06-19 11:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 06:48:42', '2019-06-20 06:48:42'),
(4742, 1, '2019-06-19 20:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 06:48:42', '2019-06-20 06:48:42'),
(4743, 4, '2019-06-19 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 06:49:25', '2019-06-20 06:49:25'),
(4744, 4, '2019-06-19 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 06:49:25', '2019-06-20 06:49:25'),
(4745, 7, '2019-06-19 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 06:51:32', '2019-06-20 06:51:32'),
(4746, 7, '2019-06-19 20:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 06:51:32', '2019-06-20 06:51:32'),
(4747, 30, '2019-06-19 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 06:51:32', '2019-06-20 06:51:32'),
(4748, 30, '2019-06-19 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 06:51:32', '2019-06-20 06:51:32'),
(4749, 9, '2019-06-19 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:03:32', '2019-06-20 07:03:32'),
(4750, 9, '2019-06-19 18:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:03:32', '2019-06-20 07:03:32'),
(4751, 24, '2019-06-19 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:03:32', '2019-06-20 07:03:32'),
(4752, 24, '2019-06-19 20:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:03:32', '2019-06-20 07:03:32'),
(4753, 8, '2019-06-19 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:03:32', '2019-06-20 07:03:32'),
(4754, 8, '2019-06-19 18:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:03:32', '2019-06-20 07:03:32'),
(4755, 10, '2019-06-19 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:03:32', '2019-06-20 07:03:32'),
(4756, 10, '2019-06-19 20:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:03:32', '2019-06-20 07:03:32'),
(4757, 3, '2019-06-19 10:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:04:35', '2019-06-20 07:04:35'),
(4758, 3, '2019-06-19 18:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:04:35', '2019-06-20 07:04:35'),
(4759, 2, '2019-06-19 11:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:04:35', '2019-06-20 07:04:35'),
(4760, 2, '2019-06-19 15:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:04:35', '2019-06-20 07:04:35'),
(4761, 26, '2019-06-19 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:06:19', '2019-06-20 07:06:19'),
(4762, 26, '2019-06-19 18:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:06:19', '2019-06-20 07:06:19'),
(4763, 5, '2019-06-19 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:06:19', '2019-06-20 07:06:19'),
(4764, 5, '2019-06-19 20:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-20 07:06:19', '2019-06-20 07:06:19'),
(4777, 1, '2019-06-20 10:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:23:28', '2019-06-22 06:23:28'),
(4778, 1, '2019-06-20 19:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:23:28', '2019-06-22 06:23:28'),
(4779, 4, '2019-06-20 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:24:00', '2019-06-22 06:24:00'),
(4780, 4, '2019-06-20 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:24:00', '2019-06-22 06:24:00'),
(4781, 7, '2019-06-20 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:24:50', '2019-06-22 06:24:50'),
(4782, 7, '2019-06-20 19:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:24:50', '2019-06-22 06:24:50'),
(4783, 30, '2019-06-20 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:24:50', '2019-06-22 06:24:50'),
(4784, 30, '2019-06-20 17:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:24:50', '2019-06-22 06:24:50'),
(4785, 9, '2019-06-20 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:26:51', '2019-06-22 06:26:51'),
(4786, 9, '2019-06-20 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:26:51', '2019-06-22 06:26:51'),
(4787, 24, '2019-06-20 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:26:51', '2019-06-22 06:26:51'),
(4788, 24, '2019-06-20 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:26:51', '2019-06-22 06:26:51'),
(4789, 8, '2019-06-20 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:26:51', '2019-06-22 06:26:51'),
(4790, 8, '2019-06-20 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:26:51', '2019-06-22 06:26:51'),
(4791, 10, '2019-06-20 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:26:51', '2019-06-22 06:26:51'),
(4792, 10, '2019-06-20 21:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:26:51', '2019-06-22 06:26:51'),
(4793, 3, '2019-06-20 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:28:19', '2019-06-22 06:28:19'),
(4794, 3, '2019-06-20 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:28:19', '2019-06-22 06:28:19'),
(4795, 2, '2019-06-20 10:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:28:19', '2019-06-22 06:28:19'),
(4796, 2, '2019-06-20 17:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:28:19', '2019-06-22 06:28:19'),
(4797, 26, '2019-06-20 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:29:23', '2019-06-22 06:29:23'),
(4798, 26, '2019-06-20 19:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:29:23', '2019-06-22 06:29:23'),
(4799, 5, '2019-06-20 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:29:23', '2019-06-22 06:29:23'),
(4800, 5, '2019-06-20 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-22 06:29:23', '2019-06-22 06:29:23'),
(4810, 1, '2019-06-22 10:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:54:01', '2019-06-23 11:54:01'),
(4811, 1, '2019-06-22 17:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:54:01', '2019-06-23 11:54:01'),
(4812, 4, '2019-06-22 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:56:43', '2019-06-23 11:56:43'),
(4813, 4, '2019-06-22 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:56:43', '2019-06-23 11:56:43'),
(4814, 7, '2019-06-22 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:57:17', '2019-06-23 11:57:17'),
(4815, 7, '2019-06-22 18:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:57:17', '2019-06-23 11:57:17'),
(4816, 30, '2019-06-22 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:57:17', '2019-06-23 11:57:17'),
(4817, 30, '2019-06-22 17:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:57:17', '2019-06-23 11:57:17'),
(4818, 24, '2019-06-22 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:58:14', '2019-06-23 11:58:14'),
(4819, 24, '2019-06-22 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:58:14', '2019-06-23 11:58:14'),
(4820, 8, '2019-06-22 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:58:14', '2019-06-23 11:58:14'),
(4821, 8, '2019-06-22 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:58:14', '2019-06-23 11:58:14'),
(4822, 3, '2019-06-22 11:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:59:17', '2019-06-23 11:59:17'),
(4823, 3, '2019-06-22 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:59:17', '2019-06-23 11:59:17'),
(4824, 26, '2019-06-22 10:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:59:51', '2019-06-23 11:59:51'),
(4825, 26, '2019-06-22 18:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:59:51', '2019-06-23 11:59:51'),
(4826, 5, '2019-06-22 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:59:51', '2019-06-23 11:59:51'),
(4827, 5, '2019-06-22 18:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-23 11:59:51', '2019-06-23 11:59:51'),
(4840, 1, '2019-06-23 11:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:40:13', '2019-06-25 09:40:13'),
(4841, 1, '2019-06-23 17:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:40:13', '2019-06-25 09:40:13'),
(4842, 4, '2019-06-23 10:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:40:44', '2019-06-25 09:40:44'),
(4843, 4, '2019-06-23 18:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:40:44', '2019-06-25 09:40:44'),
(4844, 7, '2019-06-23 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:41:44', '2019-06-25 09:41:44'),
(4845, 7, '2019-06-23 18:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:41:44', '2019-06-25 09:41:44'),
(4846, 30, '2019-06-23 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:41:44', '2019-06-25 09:41:44'),
(4847, 30, '2019-06-23 17:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:41:44', '2019-06-25 09:41:44'),
(4848, 24, '2019-06-23 08:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:43:29', '2019-06-25 09:43:29'),
(4849, 24, '2019-06-23 18:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:43:29', '2019-06-25 09:43:29'),
(4850, 8, '2019-06-23 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:43:29', '2019-06-25 09:43:29'),
(4851, 8, '2019-06-23 18:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:43:29', '2019-06-25 09:43:29'),
(4852, 3, '2019-06-23 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:44:29', '2019-06-25 09:44:29'),
(4853, 3, '2019-06-23 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:44:29', '2019-06-25 09:44:29'),
(4854, 2, '2019-06-23 11:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:44:29', '2019-06-25 09:44:29'),
(4855, 2, '2019-06-23 17:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:44:29', '2019-06-25 09:44:29'),
(4856, 26, '2019-06-23 10:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:47:12', '2019-06-25 09:47:12'),
(4857, 26, '2019-06-23 18:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:47:12', '2019-06-25 09:47:12'),
(4858, 5, '2019-06-23 09:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:47:12', '2019-06-25 09:47:12'),
(4859, 5, '2019-06-23 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:47:12', '2019-06-25 09:47:12'),
(4860, 1, '2019-06-24 10:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:52:28', '2019-06-25 09:52:28'),
(4861, 1, '2019-06-24 19:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:52:28', '2019-06-25 09:52:28'),
(4862, 7, '2019-06-24 10:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:54:16', '2019-06-25 09:54:16'),
(4863, 7, '2019-06-24 19:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:54:16', '2019-06-25 09:54:16'),
(4864, 30, '2019-06-24 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:54:16', '2019-06-25 09:54:16'),
(4865, 30, '2019-06-24 18:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:54:16', '2019-06-25 09:54:16'),
(4866, 9, '2019-06-24 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:55:47', '2019-06-25 09:55:47'),
(4867, 9, '2019-06-24 19:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:55:47', '2019-06-25 09:55:47'),
(4868, 24, '2019-06-24 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:55:47', '2019-06-25 09:55:47'),
(4869, 24, '2019-06-24 19:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:55:47', '2019-06-25 09:55:47'),
(4870, 3, '2019-06-24 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:56:56', '2019-06-25 09:56:56'),
(4871, 3, '2019-06-24 19:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:56:56', '2019-06-25 09:56:56'),
(4872, 2, '2019-06-24 10:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:56:56', '2019-06-25 09:56:56'),
(4873, 2, '2019-06-24 19:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:56:56', '2019-06-25 09:56:56'),
(4874, 26, '2019-06-24 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:58:39', '2019-06-25 09:58:39'),
(4875, 26, '2019-06-24 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:58:39', '2019-06-25 09:58:39'),
(4876, 5, '2019-06-24 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:58:39', '2019-06-25 09:58:39'),
(4877, 5, '2019-06-24 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 09:58:39', '2019-06-25 09:58:39'),
(4890, 1, '2019-06-25 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:06:33', '2019-06-26 06:06:33'),
(4891, 1, '2019-06-25 19:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:06:33', '2019-06-26 06:06:33'),
(4892, 4, '2019-06-25 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:06:54', '2019-06-26 06:06:54'),
(4893, 4, '2019-06-25 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:06:54', '2019-06-26 06:06:54'),
(4894, 7, '2019-06-25 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:07:48', '2019-06-26 06:07:48'),
(4895, 7, '2019-06-25 19:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:07:48', '2019-06-26 06:07:48'),
(4896, 30, '2019-06-25 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:07:48', '2019-06-26 06:07:48'),
(4897, 30, '2019-06-25 19:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:07:48', '2019-06-26 06:07:48'),
(4898, 9, '2019-06-25 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:17:01', '2019-06-26 06:17:01'),
(4899, 9, '2019-06-25 19:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:17:01', '2019-06-26 06:17:01'),
(4900, 24, '2019-06-25 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:17:01', '2019-06-26 06:17:01'),
(4901, 24, '2019-06-25 19:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:17:01', '2019-06-26 06:17:01'),
(4902, 8, '2019-06-25 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:17:01', '2019-06-26 06:17:01'),
(4903, 8, '2019-06-25 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:17:01', '2019-06-26 06:17:01'),
(4904, 10, '2019-06-25 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:17:01', '2019-06-26 06:17:01'),
(4905, 10, '2019-06-25 19:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:17:01', '2019-06-26 06:17:01'),
(4906, 3, '2019-06-25 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:17:59', '2019-06-26 06:17:59'),
(4907, 3, '2019-06-25 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:17:59', '2019-06-26 06:17:59'),
(4908, 2, '2019-06-25 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:17:59', '2019-06-26 06:17:59'),
(4909, 2, '2019-06-25 18:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:17:59', '2019-06-26 06:17:59'),
(4910, 26, '2019-06-25 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:18:54', '2019-06-26 06:18:54'),
(4911, 26, '2019-06-25 19:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:18:54', '2019-06-26 06:18:54'),
(4912, 5, '2019-06-25 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:18:54', '2019-06-26 06:18:54'),
(4913, 5, '2019-06-25 19:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-26 06:18:54', '2019-06-26 06:18:54'),
(4926, 1, '2019-06-26 10:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:41:05', '2019-06-27 06:41:05'),
(4927, 1, '2019-06-26 19:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:41:05', '2019-06-27 06:41:05'),
(4928, 4, '2019-06-26 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:41:31', '2019-06-27 06:41:31'),
(4929, 4, '2019-06-26 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:41:31', '2019-06-27 06:41:31'),
(4930, 7, '2019-06-26 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:42:25', '2019-06-27 06:42:25'),
(4931, 7, '2019-06-26 16:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:42:25', '2019-06-27 06:42:25'),
(4932, 30, '2019-06-26 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:42:25', '2019-06-27 06:42:25'),
(4933, 30, '2019-06-26 18:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:42:25', '2019-06-27 06:42:25'),
(4934, 9, '2019-06-26 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:43:42', '2019-06-27 06:43:42');
INSERT INTO `employee_attendance` (`employee_attendance_id`, `finger_print_id`, `in_out_time`, `check_type`, `verify_code`, `sensor_id`, `Memoinfo`, `WorkCode`, `sn`, `UserExtFmt`, `mechine_sl`, `created_at`, `updated_at`) VALUES
(4935, 9, '2019-06-26 19:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:43:42', '2019-06-27 06:43:42'),
(4936, 24, '2019-06-26 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:43:42', '2019-06-27 06:43:42'),
(4937, 24, '2019-06-26 19:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:43:42', '2019-06-27 06:43:42'),
(4938, 8, '2019-06-26 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:43:42', '2019-06-27 06:43:42'),
(4939, 8, '2019-06-26 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:43:42', '2019-06-27 06:43:42'),
(4940, 10, '2019-06-26 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:43:42', '2019-06-27 06:43:42'),
(4941, 10, '2019-06-26 19:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:43:42', '2019-06-27 06:43:42'),
(4942, 3, '2019-06-26 10:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:44:47', '2019-06-27 06:44:47'),
(4943, 3, '2019-06-26 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:44:47', '2019-06-27 06:44:47'),
(4944, 2, '2019-06-26 10:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:44:47', '2019-06-27 06:44:47'),
(4945, 2, '2019-06-26 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:44:47', '2019-06-27 06:44:47'),
(4946, 26, '2019-06-26 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:45:54', '2019-06-27 06:45:54'),
(4947, 26, '2019-06-26 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:45:54', '2019-06-27 06:45:54'),
(4948, 5, '2019-06-26 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:45:54', '2019-06-27 06:45:54'),
(4949, 5, '2019-06-26 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-27 06:45:54', '2019-06-27 06:45:54'),
(4961, 1, '2019-06-27 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:27:44', '2019-06-29 05:27:44'),
(4962, 1, '2019-06-27 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:27:44', '2019-06-29 05:27:44'),
(4963, 4, '2019-06-27 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:28:36', '2019-06-29 05:28:36'),
(4964, 4, '2019-06-27 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:28:36', '2019-06-29 05:28:36'),
(4965, 7, '2019-06-27 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:30:28', '2019-06-29 05:30:28'),
(4966, 7, '2019-06-27 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:30:28', '2019-06-29 05:30:28'),
(4967, 30, '2019-06-27 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:30:28', '2019-06-29 05:30:28'),
(4968, 30, '2019-06-27 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:30:28', '2019-06-29 05:30:28'),
(4969, 9, '2019-06-27 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:32:22', '2019-06-29 05:32:22'),
(4970, 9, '2019-06-27 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:32:22', '2019-06-29 05:32:22'),
(4971, 24, '2019-06-27 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:32:22', '2019-06-29 05:32:22'),
(4972, 24, '2019-06-27 18:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:32:22', '2019-06-29 05:32:22'),
(4973, 8, '2019-06-27 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:32:22', '2019-06-29 05:32:22'),
(4974, 8, '2019-06-27 16:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:32:22', '2019-06-29 05:32:22'),
(4975, 10, '2019-06-27 10:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:32:22', '2019-06-29 05:32:22'),
(4976, 10, '2019-06-27 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:32:22', '2019-06-29 05:32:22'),
(4977, 2, '2019-06-27 10:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:35:41', '2019-06-29 05:35:41'),
(4978, 2, '2019-06-27 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:35:41', '2019-06-29 05:35:41'),
(4979, 26, '2019-06-27 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:37:06', '2019-06-29 05:37:06'),
(4980, 26, '2019-06-27 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:37:06', '2019-06-29 05:37:06'),
(4981, 5, '2019-06-27 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:37:06', '2019-06-29 05:37:06'),
(4982, 5, '2019-06-27 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-29 05:37:06', '2019-06-29 05:37:06'),
(4994, 1, '2019-06-29 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:12:50', '2019-06-30 06:12:50'),
(4995, 1, '2019-06-29 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:12:50', '2019-06-30 06:12:50'),
(4996, 4, '2019-06-29 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:13:11', '2019-06-30 06:13:11'),
(4997, 4, '2019-06-29 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:13:11', '2019-06-30 06:13:11'),
(4998, 7, '2019-06-29 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:13:44', '2019-06-30 06:13:44'),
(4999, 7, '2019-06-29 17:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:13:44', '2019-06-30 06:13:44'),
(5000, 9, '2019-06-29 09:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:14:51', '2019-06-30 06:14:51'),
(5001, 9, '2019-06-29 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:14:51', '2019-06-30 06:14:51'),
(5002, 24, '2019-06-29 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:14:51', '2019-06-30 06:14:51'),
(5003, 24, '2019-06-29 11:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:14:51', '2019-06-30 06:14:51'),
(5004, 8, '2019-06-29 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:14:51', '2019-06-30 06:14:51'),
(5005, 8, '2019-06-29 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:14:51', '2019-06-30 06:14:51'),
(5006, 10, '2019-06-29 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:14:51', '2019-06-30 06:14:51'),
(5007, 10, '2019-06-29 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:14:51', '2019-06-30 06:14:51'),
(5008, 3, '2019-06-29 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:15:58', '2019-06-30 06:15:58'),
(5009, 3, '2019-06-29 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:15:58', '2019-06-30 06:15:58'),
(5010, 2, '2019-06-29 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:15:58', '2019-06-30 06:15:58'),
(5011, 2, '2019-06-29 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:15:58', '2019-06-30 06:15:58'),
(5012, 26, '2019-06-29 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:16:37', '2019-06-30 06:16:37'),
(5013, 26, '2019-06-29 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:16:37', '2019-06-30 06:16:37'),
(5014, 5, '2019-06-29 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:16:37', '2019-06-30 06:16:37'),
(5015, 5, '2019-06-29 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-30 06:16:37', '2019-06-30 06:16:37'),
(5027, 1, '2019-06-30 10:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:29:36', '2019-07-01 06:29:36'),
(5028, 1, '2019-06-30 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:29:36', '2019-07-01 06:29:36'),
(5029, 4, '2019-06-30 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:30:12', '2019-07-01 06:30:12'),
(5030, 4, '2019-06-30 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:30:13', '2019-07-01 06:30:13'),
(5035, 9, '2019-06-30 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:32:28', '2019-07-01 06:32:28'),
(5036, 9, '2019-06-30 19:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:32:28', '2019-07-01 06:32:28'),
(5037, 24, '2019-06-30 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:32:28', '2019-07-01 06:32:28'),
(5038, 24, '2019-06-30 19:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:32:28', '2019-07-01 06:32:28'),
(5039, 8, '2019-06-30 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:32:28', '2019-07-01 06:32:28'),
(5040, 8, '2019-06-30 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:32:28', '2019-07-01 06:32:28'),
(5041, 10, '2019-06-30 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:32:28', '2019-07-01 06:32:28'),
(5042, 10, '2019-06-30 19:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:32:28', '2019-07-01 06:32:28'),
(5043, 3, '2019-06-30 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:33:07', '2019-07-01 06:33:07'),
(5044, 3, '2019-06-30 19:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:33:07', '2019-07-01 06:33:07'),
(5045, 2, '2019-06-30 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:33:07', '2019-07-01 06:33:07'),
(5046, 2, '2019-06-30 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:33:07', '2019-07-01 06:33:07'),
(5047, 5, '2019-06-30 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:33:40', '2019-07-01 06:33:40'),
(5048, 5, '2019-06-30 19:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 06:33:40', '2019-07-01 06:33:40'),
(5061, 4, '2019-06-16 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:22:22', '2019-07-01 08:22:22'),
(5062, 4, '2019-06-16 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:22:22', '2019-07-01 08:22:22'),
(5063, 9, '2019-06-16 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:40:04', '2019-07-01 08:40:04'),
(5064, 9, '2019-06-16 19:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:40:04', '2019-07-01 08:40:04'),
(5065, 24, '2019-06-16 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:40:04', '2019-07-01 08:40:04'),
(5066, 24, '2019-06-16 19:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:40:04', '2019-07-01 08:40:04'),
(5067, 8, '2019-06-16 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:40:04', '2019-07-01 08:40:04'),
(5068, 8, '2019-06-16 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:40:04', '2019-07-01 08:40:04'),
(5069, 10, '2019-06-16 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:40:04', '2019-07-01 08:40:04'),
(5070, 10, '2019-06-16 19:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:40:04', '2019-07-01 08:40:04'),
(5071, 9, '2019-06-03 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:42:40', '2019-07-01 08:42:40'),
(5072, 9, '2019-06-03 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:42:40', '2019-07-01 08:42:40'),
(5073, 24, '2019-06-03 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:42:40', '2019-07-01 08:42:40'),
(5074, 24, '2019-06-03 21:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:42:40', '2019-07-01 08:42:40'),
(5075, 8, '2019-06-03 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:42:40', '2019-07-01 08:42:40'),
(5076, 8, '2019-06-03 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:42:40', '2019-07-01 08:42:40'),
(5077, 10, '2019-06-03 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:42:40', '2019-07-01 08:42:40'),
(5078, 10, '2019-06-03 21:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:42:40', '2019-07-01 08:42:40'),
(5079, 7, '2019-06-30 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:55:23', '2019-07-01 08:55:23'),
(5080, 7, '2019-06-30 19:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:55:23', '2019-07-01 08:55:23'),
(5081, 30, '2019-06-30 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:55:23', '2019-07-01 08:55:23'),
(5082, 30, '2019-06-30 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-01 08:55:23', '2019-07-01 08:55:23'),
(5083, 1, '2019-07-01 12:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:43:28', '2019-07-02 06:43:28'),
(5084, 1, '2019-07-01 18:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:43:28', '2019-07-02 06:43:28'),
(5085, 4, '2019-07-01 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:44:14', '2019-07-02 06:44:14'),
(5086, 4, '2019-07-01 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:44:14', '2019-07-02 06:44:14'),
(5087, 7, '2019-07-01 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:49:09', '2019-07-02 06:49:09'),
(5088, 7, '2019-07-01 15:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:49:09', '2019-07-02 06:49:09'),
(5089, 30, '2019-07-01 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:49:09', '2019-07-02 06:49:09'),
(5090, 30, '2019-07-01 18:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:49:09', '2019-07-02 06:49:09'),
(5091, 9, '2019-07-01 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:50:51', '2019-07-02 06:50:51'),
(5092, 9, '2019-07-01 19:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:50:51', '2019-07-02 06:50:51'),
(5093, 24, '2019-07-01 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:50:51', '2019-07-02 06:50:51'),
(5094, 24, '2019-07-01 17:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:50:51', '2019-07-02 06:50:51'),
(5095, 8, '2019-07-01 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:50:51', '2019-07-02 06:50:51'),
(5096, 8, '2019-07-01 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:50:51', '2019-07-02 06:50:51'),
(5097, 10, '2019-07-01 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:50:51', '2019-07-02 06:50:51'),
(5098, 10, '2019-07-01 19:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:50:51', '2019-07-02 06:50:51'),
(5099, 3, '2019-07-01 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:54:27', '2019-07-02 06:54:27'),
(5100, 3, '2019-07-01 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:54:27', '2019-07-02 06:54:27'),
(5101, 2, '2019-07-01 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:54:27', '2019-07-02 06:54:27'),
(5102, 2, '2019-07-01 18:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:54:27', '2019-07-02 06:54:27'),
(5103, 26, '2019-07-01 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:56:18', '2019-07-02 06:56:18'),
(5104, 26, '2019-07-01 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:56:18', '2019-07-02 06:56:18'),
(5105, 5, '2019-07-01 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:56:18', '2019-07-02 06:56:18'),
(5106, 5, '2019-07-01 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-02 06:56:18', '2019-07-02 06:56:18'),
(5118, 1, '2019-07-02 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:30:16', '2019-07-03 06:30:16'),
(5119, 1, '2019-07-02 19:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:30:16', '2019-07-03 06:30:16'),
(5120, 4, '2019-07-02 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:30:40', '2019-07-03 06:30:40'),
(5121, 4, '2019-07-02 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:30:40', '2019-07-03 06:30:40'),
(5122, 7, '2019-07-02 10:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:31:50', '2019-07-03 06:31:50'),
(5123, 7, '2019-07-02 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:31:50', '2019-07-03 06:31:50'),
(5124, 30, '2019-07-02 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:31:50', '2019-07-03 06:31:50'),
(5125, 30, '2019-07-02 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:31:50', '2019-07-03 06:31:50'),
(5126, 9, '2019-07-02 09:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:34:08', '2019-07-03 06:34:08'),
(5127, 9, '2019-07-02 19:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:34:08', '2019-07-03 06:34:08'),
(5128, 24, '2019-07-02 08:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:34:08', '2019-07-03 06:34:08'),
(5129, 24, '2019-07-02 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:34:08', '2019-07-03 06:34:08'),
(5130, 8, '2019-07-02 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:34:08', '2019-07-03 06:34:08'),
(5131, 8, '2019-07-02 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:34:08', '2019-07-03 06:34:08'),
(5132, 10, '2019-07-02 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:34:08', '2019-07-03 06:34:08'),
(5133, 10, '2019-07-02 19:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:34:08', '2019-07-03 06:34:08'),
(5134, 2, '2019-07-02 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:34:43', '2019-07-03 06:34:43'),
(5135, 2, '2019-07-02 19:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:34:43', '2019-07-03 06:34:43'),
(5136, 26, '2019-07-02 10:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:35:21', '2019-07-03 06:35:21'),
(5137, 26, '2019-07-02 19:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:35:21', '2019-07-03 06:35:21'),
(5138, 5, '2019-07-02 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:35:21', '2019-07-03 06:35:21'),
(5139, 5, '2019-07-02 19:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-03 06:35:21', '2019-07-03 06:35:21'),
(5151, 1, '2019-07-03 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:44:49', '2019-07-04 05:44:49'),
(5152, 1, '2019-07-03 17:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:44:49', '2019-07-04 05:44:49'),
(5153, 4, '2019-07-03 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:45:14', '2019-07-04 05:45:14'),
(5154, 4, '2019-07-03 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:45:14', '2019-07-04 05:45:14'),
(5155, 7, '2019-07-03 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:45:53', '2019-07-04 05:45:53'),
(5156, 7, '2019-07-03 18:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:45:53', '2019-07-04 05:45:53'),
(5157, 30, '2019-07-03 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:45:53', '2019-07-04 05:45:53'),
(5158, 30, '2019-07-03 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:45:53', '2019-07-04 05:45:53'),
(5159, 9, '2019-07-03 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:47:41', '2019-07-04 05:47:41'),
(5160, 9, '2019-07-03 18:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:47:41', '2019-07-04 05:47:41'),
(5161, 24, '2019-07-03 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:47:41', '2019-07-04 05:47:41'),
(5162, 24, '2019-07-03 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:47:41', '2019-07-04 05:47:41'),
(5163, 8, '2019-07-03 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:47:41', '2019-07-04 05:47:41'),
(5164, 8, '2019-07-03 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:47:41', '2019-07-04 05:47:41'),
(5165, 10, '2019-07-03 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:47:41', '2019-07-04 05:47:41'),
(5166, 10, '2019-07-03 18:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:47:41', '2019-07-04 05:47:41'),
(5167, 2, '2019-07-03 10:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:48:31', '2019-07-04 05:48:31'),
(5168, 2, '2019-07-03 17:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:48:31', '2019-07-04 05:48:31'),
(5169, 26, '2019-07-03 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:49:18', '2019-07-04 05:49:18'),
(5170, 26, '2019-07-03 18:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:49:18', '2019-07-04 05:49:18'),
(5171, 5, '2019-07-03 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:49:18', '2019-07-04 05:49:18'),
(5172, 5, '2019-07-03 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-04 05:49:18', '2019-07-04 05:49:18'),
(5185, 1, '2019-07-04 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:57:48', '2019-07-06 05:57:48'),
(5186, 1, '2019-07-04 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:57:48', '2019-07-06 05:57:48'),
(5187, 4, '2019-07-04 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:58:03', '2019-07-06 05:58:03'),
(5188, 4, '2019-07-04 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:58:03', '2019-07-06 05:58:03'),
(5189, 7, '2019-07-04 09:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:59:02', '2019-07-06 05:59:02'),
(5190, 7, '2019-07-04 17:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:59:02', '2019-07-06 05:59:02'),
(5191, 30, '2019-07-04 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:59:02', '2019-07-06 05:59:02'),
(5192, 30, '2019-07-04 17:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:59:02', '2019-07-06 05:59:02'),
(5193, 9, '2019-07-04 09:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:59:57', '2019-07-06 05:59:57'),
(5194, 9, '2019-07-04 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:59:57', '2019-07-06 05:59:57'),
(5195, 24, '2019-07-04 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:59:57', '2019-07-06 05:59:57'),
(5196, 24, '2019-07-04 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:59:57', '2019-07-06 05:59:57'),
(5197, 8, '2019-07-04 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:59:57', '2019-07-06 05:59:57'),
(5198, 8, '2019-07-04 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:59:57', '2019-07-06 05:59:57'),
(5199, 10, '2019-07-04 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:59:57', '2019-07-06 05:59:57'),
(5200, 10, '2019-07-04 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 05:59:57', '2019-07-06 05:59:57'),
(5201, 3, '2019-07-04 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 06:01:02', '2019-07-06 06:01:02'),
(5202, 3, '2019-07-04 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 06:01:02', '2019-07-06 06:01:02'),
(5203, 2, '2019-07-04 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 06:01:02', '2019-07-06 06:01:02'),
(5204, 2, '2019-07-04 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 06:01:02', '2019-07-06 06:01:02'),
(5205, 26, '2019-07-04 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 06:01:50', '2019-07-06 06:01:50'),
(5206, 26, '2019-07-04 17:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 06:01:50', '2019-07-06 06:01:50'),
(5207, 5, '2019-07-04 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 06:01:50', '2019-07-06 06:01:50'),
(5208, 5, '2019-07-04 17:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-06 06:01:50', '2019-07-06 06:01:50'),
(5220, 1, '2019-07-06 11:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:55:39', '2019-07-07 06:55:39'),
(5221, 1, '2019-07-06 17:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:55:39', '2019-07-07 06:55:39'),
(5222, 4, '2019-07-06 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:56:05', '2019-07-07 06:56:05'),
(5223, 4, '2019-07-06 17:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:56:05', '2019-07-07 06:56:05'),
(5224, 30, '2019-07-06 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:56:28', '2019-07-07 06:56:28'),
(5225, 30, '2019-07-06 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:56:28', '2019-07-07 06:56:28'),
(5226, 9, '2019-07-06 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:58:19', '2019-07-07 06:58:19'),
(5227, 9, '2019-07-06 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:58:19', '2019-07-07 06:58:19'),
(5228, 24, '2019-07-06 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:58:19', '2019-07-07 06:58:19'),
(5229, 24, '2019-07-06 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:58:19', '2019-07-07 06:58:19'),
(5230, 8, '2019-07-06 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:58:19', '2019-07-07 06:58:19'),
(5231, 8, '2019-07-06 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:58:19', '2019-07-07 06:58:19'),
(5232, 10, '2019-07-06 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:58:19', '2019-07-07 06:58:19'),
(5233, 10, '2019-07-06 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:58:19', '2019-07-07 06:58:19'),
(5234, 3, '2019-07-06 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:58:56', '2019-07-07 06:58:56'),
(5235, 3, '2019-07-06 17:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:58:56', '2019-07-07 06:58:56'),
(5236, 2, '2019-07-06 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:58:56', '2019-07-07 06:58:56'),
(5237, 2, '2019-07-06 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:58:56', '2019-07-07 06:58:56'),
(5238, 26, '2019-07-06 10:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:59:59', '2019-07-07 06:59:59'),
(5239, 26, '2019-07-06 17:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:59:59', '2019-07-07 06:59:59'),
(5240, 5, '2019-07-06 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:59:59', '2019-07-07 06:59:59'),
(5241, 5, '2019-07-06 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-07 06:59:59', '2019-07-07 06:59:59'),
(5253, 1, '2019-07-07 12:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:54:16', '2019-07-08 11:54:16'),
(5254, 1, '2019-07-07 18:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:54:16', '2019-07-08 11:54:16'),
(5255, 4, '2019-07-07 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:54:39', '2019-07-08 11:54:39'),
(5256, 4, '2019-07-07 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:54:39', '2019-07-08 11:54:39'),
(5257, 30, '2019-07-07 10:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:55:03', '2019-07-08 11:55:03'),
(5258, 30, '2019-07-07 18:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:55:03', '2019-07-08 11:55:03'),
(5259, 9, '2019-07-07 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:56:22', '2019-07-08 11:56:22'),
(5260, 9, '2019-07-07 19:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:56:22', '2019-07-08 11:56:22'),
(5261, 24, '2019-07-07 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:56:22', '2019-07-08 11:56:22'),
(5262, 24, '2019-07-07 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:56:22', '2019-07-08 11:56:22'),
(5263, 8, '2019-07-07 10:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:56:22', '2019-07-08 11:56:22'),
(5264, 8, '2019-07-07 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:56:22', '2019-07-08 11:56:22'),
(5265, 10, '2019-07-07 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:56:22', '2019-07-08 11:56:22'),
(5266, 10, '2019-07-07 19:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:56:22', '2019-07-08 11:56:22'),
(5267, 3, '2019-07-07 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:56:58', '2019-07-08 11:56:58'),
(5268, 3, '2019-07-07 18:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:56:58', '2019-07-08 11:56:58'),
(5269, 2, '2019-07-07 10:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:56:58', '2019-07-08 11:56:58'),
(5270, 2, '2019-07-07 18:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:56:58', '2019-07-08 11:56:58'),
(5271, 26, '2019-07-07 10:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:57:53', '2019-07-08 11:57:53'),
(5272, 26, '2019-07-07 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:57:53', '2019-07-08 11:57:53'),
(5273, 5, '2019-07-07 10:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:57:53', '2019-07-08 11:57:53'),
(5274, 5, '2019-07-07 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-08 11:57:53', '2019-07-08 11:57:53'),
(5286, 1, '2019-07-08 10:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:13:04', '2019-07-10 06:13:04'),
(5287, 1, '2019-07-08 19:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:13:04', '2019-07-10 06:13:04'),
(5288, 4, '2019-07-08 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:20:18', '2019-07-10 06:20:18'),
(5289, 4, '2019-07-08 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:20:18', '2019-07-10 06:20:18'),
(5290, 30, '2019-07-08 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:24:21', '2019-07-10 06:24:21'),
(5291, 30, '2019-07-08 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:24:21', '2019-07-10 06:24:21'),
(5292, 9, '2019-07-08 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:27:17', '2019-07-10 06:27:17'),
(5293, 9, '2019-07-08 20:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:27:17', '2019-07-10 06:27:17'),
(5294, 24, '2019-07-08 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:27:17', '2019-07-10 06:27:17'),
(5295, 24, '2019-07-08 16:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:27:17', '2019-07-10 06:27:17'),
(5296, 8, '2019-07-08 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:27:17', '2019-07-10 06:27:17'),
(5297, 8, '2019-07-08 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:27:17', '2019-07-10 06:27:17'),
(5298, 10, '2019-07-08 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:27:17', '2019-07-10 06:27:17'),
(5299, 10, '2019-07-08 20:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:27:17', '2019-07-10 06:27:17'),
(5304, 3, '2019-07-08 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:29:15', '2019-07-10 06:29:15'),
(5305, 3, '2019-07-08 19:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:29:15', '2019-07-10 06:29:15'),
(5306, 2, '2019-07-08 10:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:29:15', '2019-07-10 06:29:15'),
(5307, 2, '2019-07-08 19:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:29:15', '2019-07-10 06:29:15'),
(5308, 26, '2019-07-08 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:30:43', '2019-07-10 06:30:43'),
(5309, 26, '2019-07-08 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:30:43', '2019-07-10 06:30:43'),
(5310, 5, '2019-07-08 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:30:43', '2019-07-10 06:30:43'),
(5311, 5, '2019-07-08 19:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 06:30:43', '2019-07-10 06:30:43'),
(5313, 4, '2019-07-09 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:11:50', '2019-07-10 07:11:50'),
(5314, 4, '2019-07-09 18:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:11:50', '2019-07-10 07:11:50'),
(5315, 7, '2019-07-09 10:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:14:47', '2019-07-10 07:14:47'),
(5316, 7, '2019-07-09 20:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:14:47', '2019-07-10 07:14:47'),
(5317, 30, '2019-07-09 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:14:47', '2019-07-10 07:14:47'),
(5318, 30, '2019-07-09 19:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:14:47', '2019-07-10 07:14:47'),
(5319, 9, '2019-07-09 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:21:35', '2019-07-10 07:21:35'),
(5320, 9, '2019-07-09 20:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:21:35', '2019-07-10 07:21:35'),
(5321, 24, '2019-07-09 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:21:35', '2019-07-10 07:21:35'),
(5322, 24, '2019-07-09 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:21:35', '2019-07-10 07:21:35'),
(5323, 8, '2019-07-09 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:21:35', '2019-07-10 07:21:35'),
(5324, 8, '2019-07-09 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:21:35', '2019-07-10 07:21:35'),
(5325, 10, '2019-07-09 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:21:35', '2019-07-10 07:21:35'),
(5326, 10, '2019-07-09 20:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:21:35', '2019-07-10 07:21:35'),
(5327, 3, '2019-07-09 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:24:39', '2019-07-10 07:24:39'),
(5328, 3, '2019-07-09 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:24:39', '2019-07-10 07:24:39'),
(5329, 2, '2019-07-09 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:24:39', '2019-07-10 07:24:39'),
(5330, 2, '2019-07-09 15:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:24:39', '2019-07-10 07:24:39'),
(5331, 1, '2019-07-09 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:25:14', '2019-07-10 07:25:14'),
(5332, 1, '2019-07-09 18:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:25:14', '2019-07-10 07:25:14'),
(5333, 26, '2019-07-09 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:27:22', '2019-07-10 07:27:22'),
(5334, 26, '2019-07-09 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:27:22', '2019-07-10 07:27:22'),
(5335, 5, '2019-07-09 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:27:22', '2019-07-10 07:27:22'),
(5336, 5, '2019-07-09 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-10 07:27:22', '2019-07-10 07:27:22'),
(5351, 1, '2019-07-10 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 06:54:38', '2019-07-11 06:54:38'),
(5352, 1, '2019-07-10 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 06:54:38', '2019-07-11 06:54:38'),
(5353, 4, '2019-07-10 09:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 06:55:50', '2019-07-11 06:55:50'),
(5354, 4, '2019-07-10 17:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 06:55:50', '2019-07-11 06:55:50'),
(5355, 7, '2019-07-10 09:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:17:13', '2019-07-11 08:17:13'),
(5356, 7, '2019-07-10 19:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:17:13', '2019-07-11 08:17:13'),
(5357, 30, '2019-07-10 08:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:17:13', '2019-07-11 08:17:13'),
(5358, 30, '2019-07-10 17:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:17:13', '2019-07-11 08:17:13'),
(5359, 9, '2019-07-10 08:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:19:20', '2019-07-11 08:19:20'),
(5360, 9, '2019-07-10 20:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:19:20', '2019-07-11 08:19:20'),
(5361, 24, '2019-07-10 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:19:20', '2019-07-11 08:19:20'),
(5362, 24, '2019-07-10 20:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:19:20', '2019-07-11 08:19:20'),
(5363, 8, '2019-07-10 09:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:19:20', '2019-07-11 08:19:20'),
(5364, 8, '2019-07-10 17:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:19:20', '2019-07-11 08:19:20'),
(5365, 10, '2019-07-10 09:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:19:20', '2019-07-11 08:19:20'),
(5366, 10, '2019-07-10 20:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:19:20', '2019-07-11 08:19:20'),
(5367, 3, '2019-07-10 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:20:30', '2019-07-11 08:20:30'),
(5368, 3, '2019-07-10 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:20:30', '2019-07-11 08:20:30'),
(5369, 2, '2019-07-10 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:20:30', '2019-07-11 08:20:30'),
(5370, 2, '2019-07-10 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:20:30', '2019-07-11 08:20:30'),
(5371, 26, '2019-07-10 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:21:48', '2019-07-11 08:21:48'),
(5372, 26, '2019-07-10 19:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:21:48', '2019-07-11 08:21:48'),
(5373, 5, '2019-07-10 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:21:48', '2019-07-11 08:21:48'),
(5374, 5, '2019-07-10 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-11 08:21:48', '2019-07-11 08:21:48'),
(5387, 1, '2019-07-11 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:48:51', '2019-07-13 08:48:51'),
(5388, 1, '2019-07-11 18:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:48:51', '2019-07-13 08:48:51'),
(5389, 4, '2019-07-11 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:53:27', '2019-07-13 08:53:27'),
(5390, 4, '2019-07-11 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:53:27', '2019-07-13 08:53:27'),
(5391, 7, '2019-07-11 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:54:09', '2019-07-13 08:54:09'),
(5392, 7, '2019-07-11 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:54:09', '2019-07-13 08:54:09'),
(5393, 30, '2019-07-11 09:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:54:09', '2019-07-13 08:54:09'),
(5394, 30, '2019-07-11 17:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:54:09', '2019-07-13 08:54:09'),
(5395, 9, '2019-07-11 09:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:55:34', '2019-07-13 08:55:34'),
(5396, 9, '2019-07-11 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:55:34', '2019-07-13 08:55:34'),
(5397, 24, '2019-07-11 09:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:55:34', '2019-07-13 08:55:34'),
(5398, 24, '2019-07-11 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:55:34', '2019-07-13 08:55:34'),
(5399, 8, '2019-07-11 09:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:55:34', '2019-07-13 08:55:34'),
(5400, 8, '2019-07-11 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:55:34', '2019-07-13 08:55:34'),
(5401, 10, '2019-07-11 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:55:34', '2019-07-13 08:55:34'),
(5402, 10, '2019-07-11 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:55:34', '2019-07-13 08:55:34'),
(5403, 3, '2019-07-11 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:56:15', '2019-07-13 08:56:15'),
(5404, 3, '2019-07-11 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:56:15', '2019-07-13 08:56:15'),
(5405, 2, '2019-07-11 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:56:15', '2019-07-13 08:56:15'),
(5406, 2, '2019-07-11 16:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:56:15', '2019-07-13 08:56:15'),
(5407, 26, '2019-07-11 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:56:51', '2019-07-13 08:56:51'),
(5408, 26, '2019-07-11 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:56:51', '2019-07-13 08:56:51'),
(5409, 5, '2019-07-11 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:56:51', '2019-07-13 08:56:51'),
(5410, 5, '2019-07-11 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-13 08:56:51', '2019-07-13 08:56:51'),
(5421, 1, '2019-07-13 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:49:00', '2019-07-14 05:49:00'),
(5422, 1, '2019-07-13 17:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:49:01', '2019-07-14 05:49:01'),
(5423, 4, '2019-07-13 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:49:35', '2019-07-14 05:49:35'),
(5424, 4, '2019-07-13 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:49:35', '2019-07-14 05:49:35'),
(5425, 7, '2019-07-13 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:50:16', '2019-07-14 05:50:16'),
(5426, 7, '2019-07-13 17:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:50:16', '2019-07-14 05:50:16'),
(5427, 30, '2019-07-13 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:50:16', '2019-07-14 05:50:16'),
(5428, 30, '2019-07-13 17:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:50:16', '2019-07-14 05:50:16'),
(5429, 24, '2019-07-13 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:51:21', '2019-07-14 05:51:21'),
(5430, 24, '2019-07-13 17:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:51:21', '2019-07-14 05:51:21'),
(5431, 8, '2019-07-13 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:51:21', '2019-07-14 05:51:21'),
(5432, 8, '2019-07-13 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:51:21', '2019-07-14 05:51:21'),
(5433, 10, '2019-07-13 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:51:21', '2019-07-14 05:51:21'),
(5434, 10, '2019-07-13 18:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:51:21', '2019-07-14 05:51:21'),
(5435, 3, '2019-07-13 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:51:46', '2019-07-14 05:51:46'),
(5436, 3, '2019-07-13 17:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:51:46', '2019-07-14 05:51:46'),
(5437, 26, '2019-07-13 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:52:21', '2019-07-14 05:52:21'),
(5438, 26, '2019-07-13 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:52:21', '2019-07-14 05:52:21'),
(5439, 5, '2019-07-13 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:52:21', '2019-07-14 05:52:21'),
(5440, 5, '2019-07-13 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-14 05:52:21', '2019-07-14 05:52:21'),
(5452, 1, '2019-07-14 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:21:51', '2019-07-15 06:21:51'),
(5453, 1, '2019-07-14 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:21:51', '2019-07-15 06:21:51'),
(5454, 4, '2019-07-14 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:22:35', '2019-07-15 06:22:35'),
(5455, 4, '2019-07-14 18:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:22:35', '2019-07-15 06:22:35'),
(5456, 7, '2019-07-14 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:23:25', '2019-07-15 06:23:25'),
(5457, 7, '2019-07-14 18:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:23:25', '2019-07-15 06:23:25'),
(5458, 30, '2019-07-14 10:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:23:25', '2019-07-15 06:23:25'),
(5459, 30, '2019-07-14 18:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:23:25', '2019-07-15 06:23:25'),
(5460, 9, '2019-07-14 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:24:57', '2019-07-15 06:24:57'),
(5461, 9, '2019-07-14 19:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:24:57', '2019-07-15 06:24:57'),
(5462, 24, '2019-07-14 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:24:57', '2019-07-15 06:24:57'),
(5463, 24, '2019-07-14 19:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:24:57', '2019-07-15 06:24:57'),
(5464, 8, '2019-07-14 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:24:57', '2019-07-15 06:24:57'),
(5465, 8, '2019-07-14 18:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:24:57', '2019-07-15 06:24:57'),
(5466, 10, '2019-07-14 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:24:57', '2019-07-15 06:24:57'),
(5467, 10, '2019-07-14 19:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:24:57', '2019-07-15 06:24:57'),
(5470, 26, '2019-07-14 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:27:18', '2019-07-15 06:27:18'),
(5471, 26, '2019-07-14 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:27:18', '2019-07-15 06:27:18'),
(5472, 5, '2019-07-14 10:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:27:18', '2019-07-15 06:27:18'),
(5473, 5, '2019-07-14 18:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:27:18', '2019-07-15 06:27:18'),
(5474, 3, '2019-07-14 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:27:40', '2019-07-15 06:27:40'),
(5475, 3, '2019-07-14 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-15 06:27:40', '2019-07-15 06:27:40'),
(5488, 1, '2019-07-15 11:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 10:35:58', '2019-07-16 10:35:58'),
(5489, 1, '2019-07-15 18:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 10:35:58', '2019-07-16 10:35:58'),
(5490, 4, '2019-07-15 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 10:36:33', '2019-07-16 10:36:33'),
(5491, 4, '2019-07-15 17:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 10:36:33', '2019-07-16 10:36:33'),
(5492, 7, '2019-07-15 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 10:37:08', '2019-07-16 10:37:08'),
(5493, 7, '2019-07-15 18:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 10:37:08', '2019-07-16 10:37:08'),
(5494, 30, '2019-07-15 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 10:37:08', '2019-07-16 10:37:08'),
(5495, 30, '2019-07-15 18:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 10:37:08', '2019-07-16 10:37:08'),
(5496, 9, '2019-07-15 09:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:18:21', '2019-07-16 11:18:21'),
(5497, 9, '2019-07-15 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:18:21', '2019-07-16 11:18:21'),
(5498, 24, '2019-07-15 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:18:21', '2019-07-16 11:18:21'),
(5499, 24, '2019-07-15 16:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:18:21', '2019-07-16 11:18:21'),
(5500, 8, '2019-07-15 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:18:21', '2019-07-16 11:18:21'),
(5501, 8, '2019-07-15 17:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:18:21', '2019-07-16 11:18:21'),
(5502, 10, '2019-07-15 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:18:21', '2019-07-16 11:18:21'),
(5503, 10, '2019-07-15 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:18:21', '2019-07-16 11:18:21'),
(5504, 3, '2019-07-15 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:19:39', '2019-07-16 11:19:39'),
(5505, 3, '2019-07-15 18:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:19:39', '2019-07-16 11:19:39'),
(5506, 2, '2019-07-15 11:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:19:39', '2019-07-16 11:19:39'),
(5507, 2, '2019-07-15 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:19:39', '2019-07-16 11:19:39'),
(5508, 26, '2019-07-15 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:20:35', '2019-07-16 11:20:35'),
(5509, 26, '2019-07-15 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:20:35', '2019-07-16 11:20:35');
INSERT INTO `employee_attendance` (`employee_attendance_id`, `finger_print_id`, `in_out_time`, `check_type`, `verify_code`, `sensor_id`, `Memoinfo`, `WorkCode`, `sn`, `UserExtFmt`, `mechine_sl`, `created_at`, `updated_at`) VALUES
(5510, 5, '2019-07-15 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:20:35', '2019-07-16 11:20:35'),
(5511, 5, '2019-07-15 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-16 11:20:35', '2019-07-16 11:20:35'),
(5524, 1, '2019-07-16 10:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:42:46', '2019-07-17 05:42:46'),
(5525, 1, '2019-07-16 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:42:46', '2019-07-17 05:42:46'),
(5526, 4, '2019-07-16 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:45:02', '2019-07-17 05:45:02'),
(5527, 4, '2019-07-16 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:45:02', '2019-07-17 05:45:02'),
(5528, 7, '2019-07-16 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:49:52', '2019-07-17 05:49:52'),
(5529, 7, '2019-07-16 18:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:49:52', '2019-07-17 05:49:52'),
(5530, 30, '2019-07-16 12:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:49:52', '2019-07-17 05:49:52'),
(5531, 30, '2019-07-16 18:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:49:52', '2019-07-17 05:49:52'),
(5532, 9, '2019-07-16 09:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:51:11', '2019-07-17 05:51:11'),
(5533, 9, '2019-07-16 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:51:11', '2019-07-17 05:51:11'),
(5534, 24, '2019-07-16 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:51:11', '2019-07-17 05:51:11'),
(5535, 24, '2019-07-16 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:51:11', '2019-07-17 05:51:11'),
(5536, 8, '2019-07-16 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:51:11', '2019-07-17 05:51:11'),
(5537, 8, '2019-07-16 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:51:11', '2019-07-17 05:51:11'),
(5538, 10, '2019-07-16 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:51:11', '2019-07-17 05:51:11'),
(5539, 10, '2019-07-16 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:51:11', '2019-07-17 05:51:11'),
(5540, 3, '2019-07-16 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:51:59', '2019-07-17 05:51:59'),
(5541, 3, '2019-07-16 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:51:59', '2019-07-17 05:51:59'),
(5542, 2, '2019-07-16 10:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:51:59', '2019-07-17 05:51:59'),
(5543, 2, '2019-07-16 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:51:59', '2019-07-17 05:51:59'),
(5544, 26, '2019-07-16 10:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:52:46', '2019-07-17 05:52:46'),
(5545, 26, '2019-07-16 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:52:46', '2019-07-17 05:52:46'),
(5546, 5, '2019-07-16 10:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:52:46', '2019-07-17 05:52:46'),
(5547, 5, '2019-07-16 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-17 05:52:46', '2019-07-17 05:52:46'),
(5560, 1, '2019-07-17 11:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:03:07', '2019-07-18 09:03:07'),
(5561, 1, '2019-07-17 17:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:03:07', '2019-07-18 09:03:07'),
(5562, 4, '2019-07-17 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:03:43', '2019-07-18 09:03:43'),
(5563, 4, '2019-07-17 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:03:43', '2019-07-18 09:03:43'),
(5564, 7, '2019-07-17 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:04:20', '2019-07-18 09:04:20'),
(5565, 7, '2019-07-17 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:04:20', '2019-07-18 09:04:20'),
(5566, 30, '2019-07-17 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:04:20', '2019-07-18 09:04:20'),
(5567, 30, '2019-07-17 18:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:04:20', '2019-07-18 09:04:20'),
(5568, 9, '2019-07-17 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:05:38', '2019-07-18 09:05:38'),
(5569, 9, '2019-07-17 18:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:05:38', '2019-07-18 09:05:38'),
(5570, 24, '2019-07-17 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:05:38', '2019-07-18 09:05:38'),
(5571, 24, '2019-07-17 18:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:05:38', '2019-07-18 09:05:38'),
(5572, 8, '2019-07-17 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:05:38', '2019-07-18 09:05:38'),
(5573, 8, '2019-07-17 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:05:38', '2019-07-18 09:05:38'),
(5574, 10, '2019-07-17 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:05:38', '2019-07-18 09:05:38'),
(5575, 10, '2019-07-17 18:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:05:38', '2019-07-18 09:05:38'),
(5576, 3, '2019-07-17 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:06:37', '2019-07-18 09:06:37'),
(5577, 3, '2019-07-17 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:06:37', '2019-07-18 09:06:37'),
(5578, 2, '2019-07-17 11:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:06:37', '2019-07-18 09:06:37'),
(5579, 2, '2019-07-17 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:06:37', '2019-07-18 09:06:37'),
(5580, 26, '2019-07-17 10:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:07:23', '2019-07-18 09:07:23'),
(5581, 26, '2019-07-17 18:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:07:23', '2019-07-18 09:07:23'),
(5582, 5, '2019-07-17 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:07:23', '2019-07-18 09:07:23'),
(5583, 5, '2019-07-17 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-18 09:07:23', '2019-07-18 09:07:23'),
(5596, 1, '2019-07-18 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:51:49', '2019-07-20 06:51:49'),
(5597, 1, '2019-07-18 18:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:51:49', '2019-07-20 06:51:49'),
(5598, 4, '2019-07-18 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:52:23', '2019-07-20 06:52:23'),
(5599, 4, '2019-07-18 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:52:23', '2019-07-20 06:52:23'),
(5600, 7, '2019-07-18 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:53:11', '2019-07-20 06:53:11'),
(5601, 7, '2019-07-18 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:53:11', '2019-07-20 06:53:11'),
(5602, 30, '2019-07-18 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:53:11', '2019-07-20 06:53:11'),
(5603, 30, '2019-07-18 18:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:53:11', '2019-07-20 06:53:11'),
(5604, 9, '2019-07-18 09:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:54:24', '2019-07-20 06:54:24'),
(5605, 9, '2019-07-18 19:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:54:24', '2019-07-20 06:54:24'),
(5606, 24, '2019-07-18 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:54:24', '2019-07-20 06:54:24'),
(5607, 24, '2019-07-18 19:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:54:24', '2019-07-20 06:54:24'),
(5608, 8, '2019-07-18 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:54:24', '2019-07-20 06:54:24'),
(5609, 8, '2019-07-18 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:54:24', '2019-07-20 06:54:24'),
(5610, 10, '2019-07-18 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:54:24', '2019-07-20 06:54:24'),
(5611, 10, '2019-07-18 19:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:54:24', '2019-07-20 06:54:24'),
(5612, 3, '2019-07-18 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:55:12', '2019-07-20 06:55:12'),
(5613, 3, '2019-07-18 18:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:55:12', '2019-07-20 06:55:12'),
(5614, 2, '2019-07-18 10:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:55:12', '2019-07-20 06:55:12'),
(5615, 2, '2019-07-18 18:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:55:12', '2019-07-20 06:55:12'),
(5616, 26, '2019-07-18 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:56:07', '2019-07-20 06:56:07'),
(5617, 26, '2019-07-18 16:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:56:07', '2019-07-20 06:56:07'),
(5618, 5, '2019-07-18 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:56:07', '2019-07-20 06:56:07'),
(5619, 5, '2019-07-18 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-20 06:56:07', '2019-07-20 06:56:07'),
(5630, 1, '2019-07-20 11:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:53:37', '2019-07-21 05:53:37'),
(5631, 1, '2019-07-20 17:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:53:37', '2019-07-21 05:53:37'),
(5632, 7, '2019-07-20 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:54:34', '2019-07-21 05:54:34'),
(5633, 7, '2019-07-20 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:54:34', '2019-07-21 05:54:34'),
(5634, 30, '2019-07-20 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:54:34', '2019-07-21 05:54:34'),
(5635, 30, '2019-07-20 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:54:34', '2019-07-21 05:54:34'),
(5636, 9, '2019-07-20 09:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:55:36', '2019-07-21 05:55:36'),
(5637, 9, '2019-07-20 19:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:55:36', '2019-07-21 05:55:36'),
(5638, 24, '2019-07-20 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:55:36', '2019-07-21 05:55:36'),
(5639, 24, '2019-07-20 19:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:55:36', '2019-07-21 05:55:36'),
(5640, 8, '2019-07-20 09:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:55:36', '2019-07-21 05:55:36'),
(5641, 8, '2019-07-20 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:55:36', '2019-07-21 05:55:36'),
(5642, 10, '2019-07-20 09:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:55:36', '2019-07-21 05:55:36'),
(5643, 10, '2019-07-20 19:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:55:36', '2019-07-21 05:55:36'),
(5648, 5, '2019-07-20 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:57:12', '2019-07-21 05:57:12'),
(5649, 5, '2019-07-20 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:57:12', '2019-07-21 05:57:12'),
(5650, 3, '2019-07-20 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:57:26', '2019-07-21 05:57:26'),
(5651, 3, '2019-07-20 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:57:26', '2019-07-21 05:57:26'),
(5652, 2, '2019-07-20 11:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:57:26', '2019-07-21 05:57:26'),
(5653, 2, '2019-07-20 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-21 05:57:26', '2019-07-21 05:57:26'),
(5666, 1, '2019-07-21 11:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:53:33', '2019-07-22 05:53:33'),
(5667, 1, '2019-07-21 19:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:53:33', '2019-07-22 05:53:33'),
(5668, 4, '2019-07-21 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:54:21', '2019-07-22 05:54:21'),
(5669, 4, '2019-07-21 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:54:21', '2019-07-22 05:54:21'),
(5670, 7, '2019-07-21 09:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:55:27', '2019-07-22 05:55:27'),
(5671, 7, '2019-07-21 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:55:27', '2019-07-22 05:55:27'),
(5672, 30, '2019-07-21 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:55:27', '2019-07-22 05:55:27'),
(5673, 30, '2019-07-21 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:55:27', '2019-07-22 05:55:27'),
(5674, 9, '2019-07-21 09:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:58:57', '2019-07-22 05:58:57'),
(5675, 9, '2019-07-21 20:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:58:57', '2019-07-22 05:58:57'),
(5676, 24, '2019-07-21 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:58:57', '2019-07-22 05:58:57'),
(5677, 24, '2019-07-21 20:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:58:57', '2019-07-22 05:58:57'),
(5678, 8, '2019-07-21 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:58:57', '2019-07-22 05:58:57'),
(5679, 8, '2019-07-21 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:58:57', '2019-07-22 05:58:57'),
(5680, 10, '2019-07-21 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:58:57', '2019-07-22 05:58:57'),
(5681, 10, '2019-07-21 20:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:58:57', '2019-07-22 05:58:57'),
(5682, 3, '2019-07-21 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:59:52', '2019-07-22 05:59:52'),
(5683, 3, '2019-07-21 19:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:59:52', '2019-07-22 05:59:52'),
(5684, 2, '2019-07-21 10:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:59:52', '2019-07-22 05:59:52'),
(5685, 2, '2019-07-21 19:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 05:59:52', '2019-07-22 05:59:52'),
(5686, 26, '2019-07-21 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 06:00:48', '2019-07-22 06:00:48'),
(5687, 26, '2019-07-21 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 06:00:48', '2019-07-22 06:00:48'),
(5688, 5, '2019-07-21 10:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 06:00:48', '2019-07-22 06:00:48'),
(5689, 5, '2019-07-21 18:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-22 06:00:48', '2019-07-22 06:00:48'),
(5702, 1, '2019-07-22 10:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 06:40:07', '2019-07-23 06:40:07'),
(5703, 1, '2019-07-22 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 06:40:07', '2019-07-23 06:40:07'),
(5704, 4, '2019-07-22 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:49:38', '2019-07-23 08:49:38'),
(5705, 4, '2019-07-22 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:49:38', '2019-07-23 08:49:38'),
(5706, 7, '2019-07-22 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:50:21', '2019-07-23 08:50:21'),
(5707, 7, '2019-07-22 18:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:50:21', '2019-07-23 08:50:21'),
(5708, 30, '2019-07-22 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:50:21', '2019-07-23 08:50:21'),
(5709, 30, '2019-07-22 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:50:21', '2019-07-23 08:50:21'),
(5710, 9, '2019-07-22 09:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:51:28', '2019-07-23 08:51:28'),
(5711, 9, '2019-07-22 18:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:51:28', '2019-07-23 08:51:28'),
(5712, 24, '2019-07-22 09:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:51:28', '2019-07-23 08:51:28'),
(5713, 24, '2019-07-22 18:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:51:28', '2019-07-23 08:51:28'),
(5714, 8, '2019-07-22 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:51:28', '2019-07-23 08:51:28'),
(5715, 8, '2019-07-22 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:51:28', '2019-07-23 08:51:28'),
(5716, 10, '2019-07-22 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:51:28', '2019-07-23 08:51:28'),
(5717, 10, '2019-07-22 18:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:51:28', '2019-07-23 08:51:28'),
(5718, 3, '2019-07-22 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:52:05', '2019-07-23 08:52:05'),
(5719, 3, '2019-07-22 18:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:52:05', '2019-07-23 08:52:05'),
(5720, 2, '2019-07-22 10:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:52:05', '2019-07-23 08:52:05'),
(5721, 2, '2019-07-22 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:52:05', '2019-07-23 08:52:05'),
(5722, 26, '2019-07-22 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:52:37', '2019-07-23 08:52:37'),
(5723, 26, '2019-07-22 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:52:37', '2019-07-23 08:52:37'),
(5724, 5, '2019-07-22 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:52:37', '2019-07-23 08:52:37'),
(5725, 5, '2019-07-22 18:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-23 08:52:37', '2019-07-23 08:52:37'),
(5738, 1, '2019-07-23 10:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:02:53', '2019-07-24 07:02:53'),
(5739, 1, '2019-07-23 18:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:02:53', '2019-07-24 07:02:53'),
(5740, 4, '2019-07-23 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:03:24', '2019-07-24 07:03:24'),
(5741, 4, '2019-07-23 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:03:24', '2019-07-24 07:03:24'),
(5742, 7, '2019-07-23 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:03:59', '2019-07-24 07:03:59'),
(5743, 7, '2019-07-23 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:03:59', '2019-07-24 07:03:59'),
(5744, 30, '2019-07-23 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:03:59', '2019-07-24 07:03:59'),
(5745, 30, '2019-07-23 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:03:59', '2019-07-24 07:03:59'),
(5746, 9, '2019-07-23 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:03', '2019-07-24 07:05:03'),
(5747, 9, '2019-07-23 18:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:03', '2019-07-24 07:05:03'),
(5748, 24, '2019-07-23 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:03', '2019-07-24 07:05:03'),
(5749, 24, '2019-07-23 18:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:03', '2019-07-24 07:05:03'),
(5750, 8, '2019-07-23 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:03', '2019-07-24 07:05:03'),
(5751, 8, '2019-07-23 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:03', '2019-07-24 07:05:03'),
(5752, 10, '2019-07-23 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:03', '2019-07-24 07:05:03'),
(5753, 10, '2019-07-23 18:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:03', '2019-07-24 07:05:03'),
(5754, 3, '2019-07-23 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:32', '2019-07-24 07:05:32'),
(5755, 3, '2019-07-23 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:32', '2019-07-24 07:05:32'),
(5756, 2, '2019-07-23 10:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:32', '2019-07-24 07:05:32'),
(5757, 2, '2019-07-23 18:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:32', '2019-07-24 07:05:32'),
(5758, 26, '2019-07-23 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:59', '2019-07-24 07:05:59'),
(5759, 26, '2019-07-23 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:59', '2019-07-24 07:05:59'),
(5760, 5, '2019-07-23 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:59', '2019-07-24 07:05:59'),
(5761, 5, '2019-07-23 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-24 07:05:59', '2019-07-24 07:05:59'),
(5774, 1, '2019-07-24 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 06:40:12', '2019-07-25 06:40:12'),
(5775, 1, '2019-07-24 19:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 06:40:12', '2019-07-25 06:40:12'),
(5776, 4, '2019-07-24 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 06:40:50', '2019-07-25 06:40:50'),
(5777, 4, '2019-07-24 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 06:40:50', '2019-07-25 06:40:50'),
(5778, 7, '2019-07-24 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 06:41:47', '2019-07-25 06:41:47'),
(5779, 7, '2019-07-24 19:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 06:41:47', '2019-07-25 06:41:47'),
(5780, 30, '2019-07-24 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 06:41:47', '2019-07-25 06:41:47'),
(5781, 30, '2019-07-24 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 06:41:47', '2019-07-25 06:41:47'),
(5782, 9, '2019-07-24 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:36:43', '2019-07-25 07:36:43'),
(5783, 9, '2019-07-24 19:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:36:43', '2019-07-25 07:36:43'),
(5784, 24, '2019-07-24 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:36:43', '2019-07-25 07:36:43'),
(5785, 24, '2019-07-24 19:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:36:43', '2019-07-25 07:36:43'),
(5786, 8, '2019-07-24 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:36:43', '2019-07-25 07:36:43'),
(5787, 8, '2019-07-24 18:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:36:43', '2019-07-25 07:36:43'),
(5788, 10, '2019-07-24 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:36:43', '2019-07-25 07:36:43'),
(5789, 10, '2019-07-24 19:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:36:43', '2019-07-25 07:36:43'),
(5790, 3, '2019-07-24 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:37:47', '2019-07-25 07:37:47'),
(5791, 3, '2019-07-24 19:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:37:47', '2019-07-25 07:37:47'),
(5792, 2, '2019-07-24 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:37:47', '2019-07-25 07:37:47'),
(5793, 2, '2019-07-24 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:37:47', '2019-07-25 07:37:47'),
(5794, 26, '2019-07-24 10:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:39:17', '2019-07-25 07:39:17'),
(5795, 26, '2019-07-24 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:39:17', '2019-07-25 07:39:17'),
(5796, 5, '2019-07-24 10:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:39:17', '2019-07-25 07:39:17'),
(5797, 5, '2019-07-24 19:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-25 07:39:17', '2019-07-25 07:39:17'),
(5809, 1, '2019-07-25 10:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:03:17', '2019-07-27 06:03:17'),
(5810, 1, '2019-07-25 18:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:03:17', '2019-07-27 06:03:17'),
(5811, 4, '2019-07-25 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:17:01', '2019-07-27 06:17:01'),
(5812, 4, '2019-07-25 18:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:17:01', '2019-07-27 06:17:01'),
(5813, 7, '2019-07-25 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:18:01', '2019-07-27 06:18:01'),
(5814, 7, '2019-07-25 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:18:01', '2019-07-27 06:18:01'),
(5815, 30, '2019-07-25 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:18:01', '2019-07-27 06:18:01'),
(5816, 30, '2019-07-25 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:18:01', '2019-07-27 06:18:01'),
(5817, 9, '2019-07-25 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:18:56', '2019-07-27 06:18:56'),
(5818, 9, '2019-07-25 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:18:56', '2019-07-27 06:18:56'),
(5819, 24, '2019-07-25 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:18:56', '2019-07-27 06:18:56'),
(5820, 24, '2019-07-25 19:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:18:56', '2019-07-27 06:18:56'),
(5821, 8, '2019-07-25 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:18:56', '2019-07-27 06:18:56'),
(5822, 8, '2019-07-25 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:18:56', '2019-07-27 06:18:56'),
(5823, 10, '2019-07-25 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:18:56', '2019-07-27 06:18:56'),
(5824, 10, '2019-07-25 19:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:18:56', '2019-07-27 06:18:56'),
(5825, 3, '2019-07-25 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:19:44', '2019-07-27 06:19:44'),
(5826, 3, '2019-07-25 18:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:19:44', '2019-07-27 06:19:44'),
(5827, 26, '2019-07-25 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:21:21', '2019-07-27 06:21:21'),
(5828, 26, '2019-07-25 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:21:21', '2019-07-27 06:21:21'),
(5829, 5, '2019-07-25 10:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:21:21', '2019-07-27 06:21:21'),
(5830, 5, '2019-07-25 18:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-27 06:21:21', '2019-07-27 06:21:21'),
(5841, 1, '2019-07-27 10:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:23:45', '2019-07-28 06:23:45'),
(5842, 1, '2019-07-27 17:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:23:45', '2019-07-28 06:23:45'),
(5843, 4, '2019-07-27 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:24:44', '2019-07-28 06:24:44'),
(5844, 4, '2019-07-27 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:24:44', '2019-07-28 06:24:44'),
(5845, 7, '2019-07-27 09:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:25:06', '2019-07-28 06:25:06'),
(5846, 7, '2019-07-27 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:25:06', '2019-07-28 06:25:06'),
(5847, 9, '2019-07-27 09:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:26:11', '2019-07-28 06:26:11'),
(5848, 9, '2019-07-27 18:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:26:11', '2019-07-28 06:26:11'),
(5849, 24, '2019-07-27 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:26:11', '2019-07-28 06:26:11'),
(5850, 24, '2019-07-27 18:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:26:11', '2019-07-28 06:26:11'),
(5851, 8, '2019-07-27 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:26:11', '2019-07-28 06:26:11'),
(5852, 8, '2019-07-27 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:26:11', '2019-07-28 06:26:11'),
(5853, 10, '2019-07-27 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:26:11', '2019-07-28 06:26:11'),
(5854, 10, '2019-07-27 18:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:26:11', '2019-07-28 06:26:11'),
(5855, 3, '2019-07-27 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:28:04', '2019-07-28 06:28:04'),
(5856, 3, '2019-07-27 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:28:04', '2019-07-28 06:28:04'),
(5857, 26, '2019-07-27 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:29:33', '2019-07-28 06:29:33'),
(5858, 26, '2019-07-27 16:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:29:33', '2019-07-28 06:29:33'),
(5859, 5, '2019-07-27 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:29:33', '2019-07-28 06:29:33'),
(5860, 5, '2019-07-27 16:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-28 06:29:33', '2019-07-28 06:29:33'),
(5872, 1, '2019-07-28 10:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:42:35', '2019-07-29 05:42:35'),
(5873, 1, '2019-07-28 16:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:42:35', '2019-07-29 05:42:35'),
(5874, 4, '2019-07-28 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:43:33', '2019-07-29 05:43:33'),
(5875, 4, '2019-07-28 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:43:33', '2019-07-29 05:43:33'),
(5876, 7, '2019-07-28 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:44:23', '2019-07-29 05:44:23'),
(5877, 7, '2019-07-28 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:44:23', '2019-07-29 05:44:23'),
(5878, 30, '2019-07-28 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:44:23', '2019-07-29 05:44:23'),
(5879, 30, '2019-07-28 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:44:23', '2019-07-29 05:44:23'),
(5880, 9, '2019-07-28 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:45:43', '2019-07-29 05:45:43'),
(5881, 9, '2019-07-28 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:45:43', '2019-07-29 05:45:43'),
(5882, 24, '2019-07-28 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:45:43', '2019-07-29 05:45:43'),
(5883, 24, '2019-07-28 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:45:43', '2019-07-29 05:45:43'),
(5884, 8, '2019-07-28 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:45:43', '2019-07-29 05:45:43'),
(5885, 8, '2019-07-28 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:45:43', '2019-07-29 05:45:43'),
(5886, 10, '2019-07-28 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:45:43', '2019-07-29 05:45:43'),
(5887, 10, '2019-07-28 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:45:43', '2019-07-29 05:45:43'),
(5888, 3, '2019-07-28 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:46:16', '2019-07-29 05:46:16'),
(5889, 3, '2019-07-28 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:46:16', '2019-07-29 05:46:16'),
(5890, 26, '2019-07-28 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:47:04', '2019-07-29 05:47:04'),
(5891, 26, '2019-07-28 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:47:04', '2019-07-29 05:47:04'),
(5892, 5, '2019-07-28 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:47:04', '2019-07-29 05:47:04'),
(5893, 5, '2019-07-28 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-29 05:47:04', '2019-07-29 05:47:04'),
(5905, 1, '2019-07-29 11:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:23:10', '2019-07-30 06:23:10'),
(5906, 1, '2019-07-29 18:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:23:10', '2019-07-30 06:23:10'),
(5907, 4, '2019-07-29 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:23:46', '2019-07-30 06:23:46'),
(5908, 4, '2019-07-29 18:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:23:46', '2019-07-30 06:23:46'),
(5909, 7, '2019-07-29 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:24:38', '2019-07-30 06:24:38'),
(5910, 7, '2019-07-29 18:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:24:38', '2019-07-30 06:24:38'),
(5911, 30, '2019-07-29 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:24:38', '2019-07-30 06:24:38'),
(5912, 30, '2019-07-29 18:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:24:38', '2019-07-30 06:24:38'),
(5913, 9, '2019-07-29 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:25:52', '2019-07-30 06:25:52'),
(5914, 9, '2019-07-29 18:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:25:52', '2019-07-30 06:25:52'),
(5915, 24, '2019-07-29 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:25:52', '2019-07-30 06:25:52'),
(5916, 24, '2019-07-29 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:25:52', '2019-07-30 06:25:52'),
(5917, 8, '2019-07-29 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:25:52', '2019-07-30 06:25:52'),
(5918, 8, '2019-07-29 18:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:25:52', '2019-07-30 06:25:52'),
(5919, 10, '2019-07-29 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:25:52', '2019-07-30 06:25:52'),
(5920, 10, '2019-07-29 18:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:25:52', '2019-07-30 06:25:52'),
(5921, 3, '2019-07-29 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:26:16', '2019-07-30 06:26:16'),
(5922, 3, '2019-07-29 18:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:26:16', '2019-07-30 06:26:16'),
(5923, 26, '2019-07-29 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:27:32', '2019-07-30 06:27:32'),
(5924, 26, '2019-07-29 18:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:27:32', '2019-07-30 06:27:32'),
(5925, 5, '2019-07-29 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:27:32', '2019-07-30 06:27:32'),
(5926, 5, '2019-07-29 18:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 06:27:32', '2019-07-30 06:27:32'),
(5938, 1, '2019-07-30 10:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:51:57', '2019-08-04 06:51:57'),
(5939, 1, '2019-07-30 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:51:58', '2019-08-04 06:51:58'),
(5940, 4, '2019-07-30 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:54:08', '2019-08-04 06:54:08'),
(5941, 4, '2019-07-30 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:54:08', '2019-08-04 06:54:08'),
(5942, 7, '2019-07-30 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:54:56', '2019-08-04 06:54:56'),
(5943, 7, '2019-07-30 18:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:54:56', '2019-08-04 06:54:56'),
(5944, 30, '2019-07-30 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:54:56', '2019-08-04 06:54:56'),
(5945, 30, '2019-07-30 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:54:56', '2019-08-04 06:54:56'),
(5946, 9, '2019-07-30 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:56:16', '2019-08-04 06:56:16'),
(5947, 9, '2019-07-30 18:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:56:16', '2019-08-04 06:56:16'),
(5948, 24, '2019-07-30 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:56:16', '2019-08-04 06:56:16'),
(5949, 24, '2019-07-30 18:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:56:16', '2019-08-04 06:56:16'),
(5950, 8, '2019-07-30 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:56:16', '2019-08-04 06:56:16'),
(5951, 8, '2019-07-30 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:56:16', '2019-08-04 06:56:16'),
(5952, 10, '2019-07-30 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:56:16', '2019-08-04 06:56:16'),
(5953, 10, '2019-07-30 18:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:56:16', '2019-08-04 06:56:16'),
(5954, 3, '2019-07-30 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:57:29', '2019-08-04 06:57:29'),
(5955, 3, '2019-07-30 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:57:29', '2019-08-04 06:57:29'),
(5956, 26, '2019-07-30 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:58:30', '2019-08-04 06:58:30'),
(5957, 26, '2019-07-30 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:58:30', '2019-08-04 06:58:30'),
(5958, 5, '2019-07-30 10:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:58:30', '2019-08-04 06:58:30'),
(5959, 5, '2019-07-30 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 06:58:30', '2019-08-04 06:58:30'),
(5960, 1, '2019-07-31 10:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:00:50', '2019-08-04 07:00:50'),
(5961, 1, '2019-07-31 18:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:00:50', '2019-08-04 07:00:50'),
(5962, 4, '2019-07-31 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:01:38', '2019-08-04 07:01:38'),
(5963, 4, '2019-07-31 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:01:38', '2019-08-04 07:01:38'),
(5964, 7, '2019-07-31 09:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:02:49', '2019-08-04 07:02:49'),
(5965, 7, '2019-07-31 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:02:49', '2019-08-04 07:02:49'),
(5966, 30, '2019-07-31 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:02:49', '2019-08-04 07:02:49'),
(5967, 30, '2019-07-31 18:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:02:49', '2019-08-04 07:02:49'),
(5968, 9, '2019-07-31 09:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:05:21', '2019-08-04 07:05:21'),
(5969, 9, '2019-07-31 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:05:21', '2019-08-04 07:05:21'),
(5970, 24, '2019-07-31 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:05:21', '2019-08-04 07:05:21'),
(5971, 24, '2019-07-31 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:05:21', '2019-08-04 07:05:21'),
(5972, 10, '2019-07-31 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:05:21', '2019-08-04 07:05:21'),
(5973, 10, '2019-07-31 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:05:21', '2019-08-04 07:05:21'),
(5974, 3, '2019-07-31 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:06:03', '2019-08-04 07:06:03'),
(5975, 3, '2019-07-31 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:06:03', '2019-08-04 07:06:03'),
(5976, 26, '2019-07-31 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:07:17', '2019-08-04 07:07:17'),
(5977, 26, '2019-07-31 17:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:07:17', '2019-08-04 07:07:17'),
(5978, 5, '2019-07-31 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:07:17', '2019-08-04 07:07:17'),
(5979, 5, '2019-07-31 18:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:07:17', '2019-08-04 07:07:17'),
(5980, 1, '2019-08-01 10:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:08:19', '2019-08-04 07:08:19'),
(5981, 1, '2019-08-01 19:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:08:19', '2019-08-04 07:08:19'),
(5982, 4, '2019-08-01 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:08:58', '2019-08-04 07:08:58'),
(5983, 4, '2019-08-01 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:08:58', '2019-08-04 07:08:58'),
(5984, 7, '2019-08-01 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:10:58', '2019-08-04 07:10:58'),
(5985, 7, '2019-08-01 18:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:10:58', '2019-08-04 07:10:58'),
(5986, 30, '2019-08-01 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:10:58', '2019-08-04 07:10:58'),
(5987, 30, '2019-08-01 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:10:58', '2019-08-04 07:10:58'),
(5988, 9, '2019-08-01 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:13:55', '2019-08-04 07:13:55'),
(5989, 9, '2019-08-01 19:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:13:55', '2019-08-04 07:13:55'),
(5990, 24, '2019-08-01 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:13:55', '2019-08-04 07:13:55'),
(5991, 24, '2019-08-01 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:13:55', '2019-08-04 07:13:55'),
(5992, 10, '2019-08-01 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:13:55', '2019-08-04 07:13:55'),
(5993, 10, '2019-08-01 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:13:55', '2019-08-04 07:13:55'),
(5994, 3, '2019-08-01 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:14:56', '2019-08-04 07:14:56'),
(5995, 3, '2019-08-01 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:14:57', '2019-08-04 07:14:57'),
(5996, 26, '2019-08-01 10:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:15:52', '2019-08-04 07:15:52'),
(5997, 26, '2019-08-01 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:15:52', '2019-08-04 07:15:52'),
(5998, 1, '2019-08-03 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:16:45', '2019-08-04 07:16:45'),
(5999, 1, '2019-08-03 17:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:16:45', '2019-08-04 07:16:45'),
(6000, 4, '2019-08-03 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:17:26', '2019-08-04 07:17:26'),
(6001, 4, '2019-08-03 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:17:26', '2019-08-04 07:17:26'),
(6002, 7, '2019-08-03 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:18:26', '2019-08-04 07:18:26'),
(6003, 7, '2019-08-03 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:18:26', '2019-08-04 07:18:26'),
(6004, 30, '2019-08-03 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:18:26', '2019-08-04 07:18:26'),
(6005, 30, '2019-08-03 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:18:26', '2019-08-04 07:18:26'),
(6006, 9, '2019-08-03 09:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:20:19', '2019-08-04 07:20:19'),
(6007, 9, '2019-08-03 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:20:19', '2019-08-04 07:20:19'),
(6008, 24, '2019-08-03 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:20:19', '2019-08-04 07:20:19'),
(6009, 24, '2019-08-03 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:20:19', '2019-08-04 07:20:19'),
(6010, 8, '2019-08-03 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:20:19', '2019-08-04 07:20:19'),
(6011, 8, '2019-08-03 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:20:19', '2019-08-04 07:20:19'),
(6012, 10, '2019-08-03 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:20:19', '2019-08-04 07:20:19'),
(6013, 10, '2019-08-03 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:20:19', '2019-08-04 07:20:19'),
(6014, 3, '2019-08-03 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:22:51', '2019-08-04 07:22:51'),
(6015, 3, '2019-08-03 17:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:22:51', '2019-08-04 07:22:51'),
(6016, 2, '2019-08-03 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:22:51', '2019-08-04 07:22:51'),
(6017, 2, '2019-08-03 17:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:22:51', '2019-08-04 07:22:51'),
(6018, 26, '2019-08-03 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:27:59', '2019-08-04 07:27:59'),
(6019, 26, '2019-08-03 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:27:59', '2019-08-04 07:27:59'),
(6020, 5, '2019-08-03 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:27:59', '2019-08-04 07:27:59'),
(6021, 5, '2019-08-03 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-04 07:27:59', '2019-08-04 07:27:59'),
(6034, 1, '2019-08-04 11:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:04:51', '2019-08-05 06:04:51'),
(6035, 1, '2019-08-04 18:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:04:51', '2019-08-05 06:04:51'),
(6036, 4, '2019-08-04 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:05:10', '2019-08-05 06:05:10'),
(6037, 4, '2019-08-04 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:05:10', '2019-08-05 06:05:10'),
(6038, 7, '2019-08-04 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:05:57', '2019-08-05 06:05:57'),
(6039, 7, '2019-08-04 18:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:05:57', '2019-08-05 06:05:57'),
(6040, 30, '2019-08-04 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:05:57', '2019-08-05 06:05:57'),
(6041, 30, '2019-08-04 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:05:57', '2019-08-05 06:05:57'),
(6042, 9, '2019-08-04 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:07:05', '2019-08-05 06:07:05'),
(6043, 9, '2019-08-04 18:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:07:05', '2019-08-05 06:07:05'),
(6044, 24, '2019-08-04 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:07:05', '2019-08-05 06:07:05'),
(6045, 24, '2019-08-04 18:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:07:05', '2019-08-05 06:07:05'),
(6046, 8, '2019-08-04 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:07:05', '2019-08-05 06:07:05'),
(6047, 8, '2019-08-04 18:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:07:05', '2019-08-05 06:07:05'),
(6048, 10, '2019-08-04 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:07:05', '2019-08-05 06:07:05'),
(6049, 10, '2019-08-04 18:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:07:05', '2019-08-05 06:07:05'),
(6050, 3, '2019-08-04 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:07:59', '2019-08-05 06:07:59'),
(6051, 3, '2019-08-04 18:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:08:00', '2019-08-05 06:08:00'),
(6052, 2, '2019-08-04 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:08:00', '2019-08-05 06:08:00'),
(6053, 2, '2019-08-04 18:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:08:00', '2019-08-05 06:08:00'),
(6054, 26, '2019-08-04 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:08:59', '2019-08-05 06:08:59'),
(6055, 26, '2019-08-04 18:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:08:59', '2019-08-05 06:08:59'),
(6056, 5, '2019-08-04 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:08:59', '2019-08-05 06:08:59'),
(6057, 5, '2019-08-04 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-05 06:08:59', '2019-08-05 06:08:59'),
(6069, 1, '2019-08-05 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:49:33', '2019-08-06 04:49:33'),
(6070, 1, '2019-08-05 19:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:49:33', '2019-08-06 04:49:33'),
(6071, 4, '2019-08-05 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:50:05', '2019-08-06 04:50:05'),
(6072, 4, '2019-08-05 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:50:05', '2019-08-06 04:50:05'),
(6073, 7, '2019-08-05 10:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:51:11', '2019-08-06 04:51:11'),
(6074, 7, '2019-08-05 20:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:51:11', '2019-08-06 04:51:11'),
(6075, 30, '2019-08-05 11:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:51:11', '2019-08-06 04:51:11'),
(6076, 30, '2019-08-05 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:51:11', '2019-08-06 04:51:11'),
(6077, 9, '2019-08-05 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:52:53', '2019-08-06 04:52:53');
INSERT INTO `employee_attendance` (`employee_attendance_id`, `finger_print_id`, `in_out_time`, `check_type`, `verify_code`, `sensor_id`, `Memoinfo`, `WorkCode`, `sn`, `UserExtFmt`, `mechine_sl`, `created_at`, `updated_at`) VALUES
(6078, 9, '2019-08-05 20:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:52:53', '2019-08-06 04:52:53'),
(6079, 24, '2019-08-05 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:52:53', '2019-08-06 04:52:53'),
(6080, 24, '2019-08-05 20:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:52:53', '2019-08-06 04:52:53'),
(6081, 8, '2019-08-05 09:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:52:53', '2019-08-06 04:52:53'),
(6082, 8, '2019-08-05 18:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:52:53', '2019-08-06 04:52:53'),
(6083, 10, '2019-08-05 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:52:53', '2019-08-06 04:52:53'),
(6084, 10, '2019-08-05 20:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:52:53', '2019-08-06 04:52:53'),
(6085, 2, '2019-08-05 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:53:34', '2019-08-06 04:53:34'),
(6086, 2, '2019-08-05 19:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:53:34', '2019-08-06 04:53:34'),
(6087, 26, '2019-08-05 10:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:54:40', '2019-08-06 04:54:40'),
(6088, 26, '2019-08-05 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:54:40', '2019-08-06 04:54:40'),
(6089, 5, '2019-08-05 10:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:54:40', '2019-08-06 04:54:40'),
(6090, 5, '2019-08-05 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-06 04:54:40', '2019-08-06 04:54:40'),
(6104, 1, '2019-08-06 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:40:35', '2019-08-07 05:40:35'),
(6105, 1, '2019-08-06 17:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:40:35', '2019-08-07 05:40:35'),
(6106, 4, '2019-08-06 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:41:02', '2019-08-07 05:41:02'),
(6107, 4, '2019-08-06 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:41:02', '2019-08-07 05:41:02'),
(6108, 7, '2019-08-06 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:42:03', '2019-08-07 05:42:03'),
(6109, 7, '2019-08-06 20:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:42:03', '2019-08-07 05:42:03'),
(6110, 30, '2019-08-06 11:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:42:03', '2019-08-07 05:42:03'),
(6111, 30, '2019-08-06 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:42:03', '2019-08-07 05:42:03'),
(6112, 9, '2019-08-06 09:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:45:41', '2019-08-07 05:45:41'),
(6113, 9, '2019-08-06 20:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:45:41', '2019-08-07 05:45:41'),
(6114, 24, '2019-08-06 09:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:45:41', '2019-08-07 05:45:41'),
(6115, 24, '2019-08-06 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:45:41', '2019-08-07 05:45:41'),
(6116, 8, '2019-08-06 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:45:41', '2019-08-07 05:45:41'),
(6117, 8, '2019-08-06 17:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:45:41', '2019-08-07 05:45:41'),
(6118, 10, '2019-08-06 09:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:45:41', '2019-08-07 05:45:41'),
(6119, 10, '2019-08-06 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:45:41', '2019-08-07 05:45:41'),
(6120, 3, '2019-08-06 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:57:40', '2019-08-07 05:57:40'),
(6121, 3, '2019-08-06 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:57:40', '2019-08-07 05:57:40'),
(6122, 2, '2019-08-06 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:57:40', '2019-08-07 05:57:40'),
(6123, 2, '2019-08-06 17:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:57:40', '2019-08-07 05:57:40'),
(6124, 26, '2019-08-06 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:58:28', '2019-08-07 05:58:28'),
(6125, 26, '2019-08-06 19:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:58:28', '2019-08-07 05:58:28'),
(6126, 5, '2019-08-06 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:58:28', '2019-08-07 05:58:28'),
(6127, 5, '2019-08-06 20:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-07 05:58:28', '2019-08-07 05:58:28'),
(6142, 1, '2019-08-07 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:22:26', '2019-08-08 05:22:26'),
(6143, 1, '2019-08-07 19:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:22:26', '2019-08-08 05:22:26'),
(6144, 4, '2019-08-07 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:23:32', '2019-08-08 05:23:32'),
(6145, 4, '2019-08-07 18:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:23:32', '2019-08-08 05:23:32'),
(6150, 7, '2019-08-07 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:27:40', '2019-08-08 05:27:40'),
(6151, 7, '2019-08-07 20:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:27:40', '2019-08-08 05:27:40'),
(6152, 30, '2019-08-07 11:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:27:40', '2019-08-08 05:27:40'),
(6153, 30, '2019-08-07 18:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:27:40', '2019-08-08 05:27:40'),
(6154, 9, '2019-08-07 09:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:30:11', '2019-08-08 05:30:11'),
(6155, 9, '2019-08-07 20:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:30:11', '2019-08-08 05:30:11'),
(6156, 24, '2019-08-07 09:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:30:11', '2019-08-08 05:30:11'),
(6157, 24, '2019-08-07 20:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:30:11', '2019-08-08 05:30:11'),
(6158, 8, '2019-08-07 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:30:11', '2019-08-08 05:30:11'),
(6159, 8, '2019-08-07 18:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:30:11', '2019-08-08 05:30:11'),
(6160, 10, '2019-08-07 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:30:11', '2019-08-08 05:30:11'),
(6161, 10, '2019-08-07 20:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:30:11', '2019-08-08 05:30:11'),
(6162, 3, '2019-08-07 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:31:58', '2019-08-08 05:31:58'),
(6163, 3, '2019-08-07 19:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:31:58', '2019-08-08 05:31:58'),
(6164, 2, '2019-08-07 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:31:58', '2019-08-08 05:31:58'),
(6165, 2, '2019-08-07 19:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:31:58', '2019-08-08 05:31:58'),
(6166, 26, '2019-08-07 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:49:00', '2019-08-08 05:49:00'),
(6167, 26, '2019-08-07 18:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:49:00', '2019-08-08 05:49:00'),
(6168, 5, '2019-08-07 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:49:00', '2019-08-08 05:49:00'),
(6169, 5, '2019-08-07 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-08 05:49:00', '2019-08-08 05:49:00'),
(6182, 1, '2019-08-08 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:11:02', '2019-08-18 07:11:02'),
(6183, 1, '2019-08-08 21:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:11:02', '2019-08-18 07:11:02'),
(6184, 4, '2019-08-08 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:12:18', '2019-08-18 07:12:18'),
(6185, 4, '2019-08-08 18:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:12:18', '2019-08-18 07:12:18'),
(6186, 7, '2019-08-08 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:19:29', '2019-08-18 07:19:29'),
(6187, 7, '2019-08-08 21:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:19:29', '2019-08-18 07:19:29'),
(6188, 30, '2019-08-08 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:19:29', '2019-08-18 07:19:29'),
(6189, 30, '2019-08-08 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:19:29', '2019-08-18 07:19:29'),
(6190, 9, '2019-08-08 09:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:22:23', '2019-08-18 07:22:23'),
(6191, 9, '2019-08-08 22:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:22:23', '2019-08-18 07:22:23'),
(6192, 24, '2019-08-08 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:22:23', '2019-08-18 07:22:23'),
(6193, 24, '2019-08-08 22:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:22:23', '2019-08-18 07:22:23'),
(6194, 8, '2019-08-08 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:22:23', '2019-08-18 07:22:23'),
(6195, 8, '2019-08-08 18:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:22:23', '2019-08-18 07:22:23'),
(6196, 10, '2019-08-08 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:22:23', '2019-08-18 07:22:23'),
(6197, 10, '2019-08-08 22:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:22:23', '2019-08-18 07:22:23'),
(6198, 3, '2019-08-08 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:23:07', '2019-08-18 07:23:07'),
(6199, 3, '2019-08-08 21:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:23:07', '2019-08-18 07:23:07'),
(6200, 2, '2019-08-08 10:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:23:07', '2019-08-18 07:23:07'),
(6201, 2, '2019-08-08 21:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:23:07', '2019-08-18 07:23:07'),
(6202, 26, '2019-08-08 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:23:56', '2019-08-18 07:23:56'),
(6203, 26, '2019-08-08 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:23:56', '2019-08-18 07:23:56'),
(6204, 5, '2019-08-08 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:23:56', '2019-08-18 07:23:56'),
(6205, 5, '2019-08-08 21:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:23:56', '2019-08-18 07:23:56'),
(6207, 30, '2019-08-17 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:25:24', '2019-08-18 07:25:24'),
(6208, 30, '2019-08-17 14:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:25:24', '2019-08-18 07:25:24'),
(6209, 8, '2019-08-17 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:26:27', '2019-08-18 07:26:27'),
(6210, 8, '2019-08-17 18:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:26:27', '2019-08-18 07:26:27'),
(6211, 10, '2019-08-17 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:26:27', '2019-08-18 07:26:27'),
(6212, 10, '2019-08-17 14:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:26:27', '2019-08-18 07:26:27'),
(6213, 3, '2019-08-17 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:27:03', '2019-08-18 07:27:03'),
(6214, 3, '2019-08-17 14:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:27:03', '2019-08-18 07:27:03'),
(6215, 26, '2019-08-17 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:27:50', '2019-08-18 07:27:50'),
(6216, 26, '2019-08-17 14:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:27:50', '2019-08-18 07:27:50'),
(6217, 5, '2019-08-17 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:27:50', '2019-08-18 07:27:50'),
(6218, 5, '2019-08-17 14:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-18 07:27:50', '2019-08-18 07:27:50'),
(6231, 1, '2019-08-18 10:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:27:25', '2019-08-20 06:27:25'),
(6232, 1, '2019-08-18 16:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:27:25', '2019-08-20 06:27:25'),
(6233, 7, '2019-08-18 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:29:01', '2019-08-20 06:29:01'),
(6234, 7, '2019-08-18 18:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:29:01', '2019-08-20 06:29:01'),
(6235, 30, '2019-08-18 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:29:01', '2019-08-20 06:29:01'),
(6236, 30, '2019-08-18 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:29:01', '2019-08-20 06:29:01'),
(6237, 9, '2019-08-18 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:32:22', '2019-08-20 06:32:22'),
(6238, 9, '2019-08-18 18:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:32:22', '2019-08-20 06:32:22'),
(6239, 8, '2019-08-18 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:32:22', '2019-08-20 06:32:22'),
(6240, 8, '2019-08-18 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:32:22', '2019-08-20 06:32:22'),
(6241, 10, '2019-08-18 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:32:22', '2019-08-20 06:32:22'),
(6242, 10, '2019-08-18 18:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:32:22', '2019-08-20 06:32:22'),
(6243, 3, '2019-08-18 10:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:34:40', '2019-08-20 06:34:40'),
(6244, 3, '2019-08-18 18:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:34:40', '2019-08-20 06:34:40'),
(6245, 2, '2019-08-18 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:34:40', '2019-08-20 06:34:40'),
(6246, 2, '2019-08-18 16:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:34:40', '2019-08-20 06:34:40'),
(6247, 26, '2019-08-18 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:36:26', '2019-08-20 06:36:26'),
(6248, 26, '2019-08-18 18:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:36:26', '2019-08-20 06:36:26'),
(6249, 5, '2019-08-18 10:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:36:26', '2019-08-20 06:36:26'),
(6250, 5, '2019-08-18 18:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:36:26', '2019-08-20 06:36:26'),
(6251, 1, '2019-08-19 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:37:14', '2019-08-20 06:37:14'),
(6252, 1, '2019-08-19 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:37:14', '2019-08-20 06:37:14'),
(6253, 7, '2019-08-19 09:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:38:13', '2019-08-20 06:38:13'),
(6254, 7, '2019-08-19 16:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:38:13', '2019-08-20 06:38:13'),
(6255, 9, '2019-08-19 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:40:51', '2019-08-20 06:40:51'),
(6256, 9, '2019-08-19 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:40:51', '2019-08-20 06:40:51'),
(6257, 8, '2019-08-19 09:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:40:51', '2019-08-20 06:40:51'),
(6258, 8, '2019-08-19 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:40:51', '2019-08-20 06:40:51'),
(6259, 10, '2019-08-19 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:40:51', '2019-08-20 06:40:51'),
(6260, 10, '2019-08-19 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:40:51', '2019-08-20 06:40:51'),
(6261, 3, '2019-08-19 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:41:42', '2019-08-20 06:41:42'),
(6262, 3, '2019-08-19 17:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:41:42', '2019-08-20 06:41:42'),
(6263, 2, '2019-08-19 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:41:42', '2019-08-20 06:41:42'),
(6264, 2, '2019-08-19 17:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:41:42', '2019-08-20 06:41:42'),
(6265, 26, '2019-08-19 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:43:06', '2019-08-20 06:43:06'),
(6266, 26, '2019-08-19 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:43:06', '2019-08-20 06:43:06'),
(6267, 5, '2019-08-19 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:43:06', '2019-08-20 06:43:06'),
(6268, 5, '2019-08-19 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-20 06:43:06', '2019-08-20 06:43:06'),
(6278, 1, '2019-08-20 10:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:01:32', '2019-08-25 05:01:32'),
(6279, 1, '2019-08-20 17:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:01:32', '2019-08-25 05:01:32'),
(6280, 7, '2019-08-20 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:03:09', '2019-08-25 05:03:09'),
(6281, 7, '2019-08-20 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:03:09', '2019-08-25 05:03:09'),
(6282, 9, '2019-08-20 09:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:04:39', '2019-08-25 05:04:39'),
(6283, 9, '2019-08-20 18:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:04:39', '2019-08-25 05:04:39'),
(6284, 24, '2019-08-20 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:04:39', '2019-08-25 05:04:39'),
(6285, 24, '2019-08-20 18:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:04:39', '2019-08-25 05:04:39'),
(6286, 8, '2019-08-20 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:04:39', '2019-08-25 05:04:39'),
(6287, 8, '2019-08-20 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:04:39', '2019-08-25 05:04:39'),
(6288, 10, '2019-08-20 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:04:39', '2019-08-25 05:04:39'),
(6289, 10, '2019-08-20 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:04:39', '2019-08-25 05:04:39'),
(6290, 3, '2019-08-20 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:05:56', '2019-08-25 05:05:56'),
(6291, 3, '2019-08-20 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:05:56', '2019-08-25 05:05:56'),
(6292, 26, '2019-08-20 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:06:37', '2019-08-25 05:06:37'),
(6293, 26, '2019-08-20 18:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:06:37', '2019-08-25 05:06:37'),
(6294, 5, '2019-08-20 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:06:37', '2019-08-25 05:06:37'),
(6295, 5, '2019-08-20 18:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:06:37', '2019-08-25 05:06:37'),
(6296, 1, '2019-08-21 11:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:07:16', '2019-08-25 05:07:16'),
(6297, 1, '2019-08-21 18:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:07:16', '2019-08-25 05:07:16'),
(6298, 7, '2019-08-21 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:08:28', '2019-08-25 05:08:28'),
(6299, 7, '2019-08-21 19:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:08:28', '2019-08-25 05:08:28'),
(6300, 9, '2019-08-21 08:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:11:14', '2019-08-25 05:11:14'),
(6301, 9, '2019-08-21 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:11:14', '2019-08-25 05:11:14'),
(6302, 24, '2019-08-21 09:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:11:14', '2019-08-25 05:11:14'),
(6303, 24, '2019-08-21 19:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:11:14', '2019-08-25 05:11:14'),
(6304, 8, '2019-08-21 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:11:14', '2019-08-25 05:11:14'),
(6305, 8, '2019-08-21 17:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:11:14', '2019-08-25 05:11:14'),
(6306, 10, '2019-08-21 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:11:14', '2019-08-25 05:11:14'),
(6307, 10, '2019-08-21 19:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:11:14', '2019-08-25 05:11:14'),
(6308, 3, '2019-08-21 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:13:01', '2019-08-25 05:13:01'),
(6309, 3, '2019-08-21 18:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:13:01', '2019-08-25 05:13:01'),
(6310, 2, '2019-08-21 11:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:13:01', '2019-08-25 05:13:01'),
(6311, 2, '2019-08-21 18:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:13:01', '2019-08-25 05:13:01'),
(6312, 26, '2019-08-21 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:13:57', '2019-08-25 05:13:57'),
(6313, 26, '2019-08-21 18:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:13:57', '2019-08-25 05:13:57'),
(6314, 5, '2019-08-21 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:13:57', '2019-08-25 05:13:57'),
(6315, 5, '2019-08-21 18:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:13:57', '2019-08-25 05:13:57'),
(6316, 1, '2019-08-22 10:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:14:44', '2019-08-25 05:14:44'),
(6317, 1, '2019-08-22 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:14:44', '2019-08-25 05:14:44'),
(6318, 7, '2019-08-22 10:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:15:26', '2019-08-25 05:15:26'),
(6319, 7, '2019-08-22 18:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:15:26', '2019-08-25 05:15:26'),
(6320, 24, '2019-08-22 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:17:22', '2019-08-25 05:17:22'),
(6321, 24, '2019-08-22 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:17:22', '2019-08-25 05:17:22'),
(6322, 8, '2019-08-22 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:17:22', '2019-08-25 05:17:22'),
(6323, 8, '2019-08-22 18:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:17:22', '2019-08-25 05:17:22'),
(6324, 10, '2019-08-22 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:17:22', '2019-08-25 05:17:22'),
(6325, 10, '2019-08-22 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:17:22', '2019-08-25 05:17:22'),
(6326, 3, '2019-08-22 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:18:00', '2019-08-25 05:18:00'),
(6327, 3, '2019-08-22 18:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:18:00', '2019-08-25 05:18:00'),
(6328, 26, '2019-08-22 10:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:22:06', '2019-08-25 05:22:06'),
(6329, 26, '2019-08-22 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:22:06', '2019-08-25 05:22:06'),
(6330, 5, '2019-08-22 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:22:06', '2019-08-25 05:22:06'),
(6331, 5, '2019-08-22 18:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:22:06', '2019-08-25 05:22:06'),
(6332, 1, '2019-08-24 11:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:23:15', '2019-08-25 05:23:15'),
(6333, 1, '2019-08-24 18:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:23:15', '2019-08-25 05:23:15'),
(6334, 7, '2019-08-24 10:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:23:58', '2019-08-25 05:23:58'),
(6335, 7, '2019-08-24 18:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:23:58', '2019-08-25 05:23:58'),
(6336, 9, '2019-08-24 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:26:35', '2019-08-25 05:26:35'),
(6337, 9, '2019-08-24 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:26:35', '2019-08-25 05:26:35'),
(6338, 24, '2019-08-24 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:26:35', '2019-08-25 05:26:35'),
(6339, 24, '2019-08-24 18:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:26:35', '2019-08-25 05:26:35'),
(6340, 8, '2019-08-24 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:26:35', '2019-08-25 05:26:35'),
(6341, 8, '2019-08-24 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:26:35', '2019-08-25 05:26:35'),
(6342, 10, '2019-08-24 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:26:35', '2019-08-25 05:26:35'),
(6343, 10, '2019-08-24 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:26:35', '2019-08-25 05:26:35'),
(6344, 3, '2019-08-24 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:27:21', '2019-08-25 05:27:21'),
(6345, 3, '2019-08-24 18:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:27:21', '2019-08-25 05:27:21'),
(6346, 2, '2019-08-24 11:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:27:21', '2019-08-25 05:27:21'),
(6347, 2, '2019-08-24 18:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:27:21', '2019-08-25 05:27:21'),
(6352, 26, '2019-08-24 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:30:22', '2019-08-25 05:30:22'),
(6353, 26, '2019-08-24 16:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:30:22', '2019-08-25 05:30:22'),
(6354, 5, '2019-08-24 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:30:22', '2019-08-25 05:30:22'),
(6355, 5, '2019-08-24 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-25 05:30:22', '2019-08-25 05:30:22'),
(6366, 1, '2019-08-25 10:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:10:55', '2019-08-27 06:10:55'),
(6367, 1, '2019-08-25 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:10:55', '2019-08-27 06:10:55'),
(6368, 4, '2019-08-25 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:11:28', '2019-08-27 06:11:28'),
(6369, 4, '2019-08-25 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:11:28', '2019-08-27 06:11:28'),
(6370, 7, '2019-08-25 10:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:11:51', '2019-08-27 06:11:51'),
(6371, 7, '2019-08-25 19:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:11:52', '2019-08-27 06:11:52'),
(6372, 9, '2019-08-25 09:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:21:13', '2019-08-27 06:21:13'),
(6373, 9, '2019-08-25 18:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:21:13', '2019-08-27 06:21:13'),
(6374, 24, '2019-08-25 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:21:13', '2019-08-27 06:21:13'),
(6375, 24, '2019-08-25 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:21:13', '2019-08-27 06:21:13'),
(6376, 8, '2019-08-25 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:21:13', '2019-08-27 06:21:13'),
(6377, 8, '2019-08-25 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:21:13', '2019-08-27 06:21:13'),
(6378, 10, '2019-08-25 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:21:13', '2019-08-27 06:21:13'),
(6379, 10, '2019-08-25 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:21:13', '2019-08-27 06:21:13'),
(6380, 3, '2019-08-25 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:21:45', '2019-08-27 06:21:45'),
(6381, 3, '2019-08-25 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:21:45', '2019-08-27 06:21:45'),
(6382, 26, '2019-08-25 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:22:26', '2019-08-27 06:22:26'),
(6383, 26, '2019-08-25 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:22:26', '2019-08-27 06:22:26'),
(6384, 5, '2019-08-25 10:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:22:26', '2019-08-27 06:22:26'),
(6385, 5, '2019-08-25 18:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:22:26', '2019-08-27 06:22:26'),
(6386, 1, '2019-08-26 10:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:24:10', '2019-08-27 06:24:10'),
(6387, 1, '2019-08-26 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:24:10', '2019-08-27 06:24:10'),
(6388, 7, '2019-08-26 09:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:24:55', '2019-08-27 06:24:55'),
(6389, 7, '2019-08-26 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:24:55', '2019-08-27 06:24:55'),
(6390, 9, '2019-08-26 09:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:28:47', '2019-08-27 06:28:47'),
(6391, 9, '2019-08-26 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:28:47', '2019-08-27 06:28:47'),
(6392, 24, '2019-08-26 09:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:28:47', '2019-08-27 06:28:47'),
(6393, 24, '2019-08-26 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:28:47', '2019-08-27 06:28:47'),
(6394, 10, '2019-08-26 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:28:47', '2019-08-27 06:28:47'),
(6395, 10, '2019-08-26 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:28:47', '2019-08-27 06:28:47'),
(6396, 3, '2019-08-26 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:29:26', '2019-08-27 06:29:26'),
(6397, 3, '2019-08-26 18:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:29:26', '2019-08-27 06:29:26'),
(6398, 5, '2019-08-26 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:30:10', '2019-08-27 06:30:10'),
(6399, 5, '2019-08-26 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-27 06:30:10', '2019-08-27 06:30:10'),
(6411, 1, '2019-08-27 10:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 06:45:49', '2019-08-28 06:45:49'),
(6412, 1, '2019-08-27 18:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 06:45:49', '2019-08-28 06:45:49'),
(6413, 4, '2019-08-27 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 06:46:42', '2019-08-28 06:46:42'),
(6414, 4, '2019-08-27 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 06:46:42', '2019-08-28 06:46:42'),
(6415, 7, '2019-08-27 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 06:58:46', '2019-08-28 06:58:46'),
(6416, 7, '2019-08-27 18:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 06:58:46', '2019-08-28 06:58:46'),
(6417, 9, '2019-08-27 09:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:00:13', '2019-08-28 07:00:13'),
(6418, 9, '2019-08-27 19:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:00:13', '2019-08-28 07:00:13'),
(6419, 24, '2019-08-27 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:00:13', '2019-08-28 07:00:13'),
(6420, 24, '2019-08-27 19:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:00:13', '2019-08-28 07:00:13'),
(6421, 8, '2019-08-27 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:00:13', '2019-08-28 07:00:13'),
(6422, 8, '2019-08-27 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:00:13', '2019-08-28 07:00:13'),
(6423, 10, '2019-08-27 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:00:13', '2019-08-28 07:00:13'),
(6424, 10, '2019-08-27 19:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:00:13', '2019-08-28 07:00:13'),
(6425, 3, '2019-08-27 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:01:59', '2019-08-28 07:01:59'),
(6426, 3, '2019-08-27 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:01:59', '2019-08-28 07:01:59'),
(6427, 2, '2019-08-27 10:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:01:59', '2019-08-28 07:01:59'),
(6428, 2, '2019-08-27 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:01:59', '2019-08-28 07:01:59'),
(6429, 26, '2019-08-27 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:02:35', '2019-08-28 07:02:35'),
(6430, 26, '2019-08-27 18:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:02:35', '2019-08-28 07:02:35'),
(6431, 5, '2019-08-27 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:02:35', '2019-08-28 07:02:35'),
(6432, 5, '2019-08-27 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-28 07:02:35', '2019-08-28 07:02:35'),
(6444, 1, '2019-08-28 10:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 06:51:41', '2019-08-29 06:51:41'),
(6445, 1, '2019-08-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 06:51:41', '2019-08-29 06:51:41'),
(6446, 4, '2019-08-28 09:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 06:52:10', '2019-08-29 06:52:10'),
(6447, 4, '2019-08-28 17:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 06:52:10', '2019-08-29 06:52:10'),
(6448, 7, '2019-08-28 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 06:55:54', '2019-08-29 06:55:54'),
(6449, 7, '2019-08-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 06:55:54', '2019-08-29 06:55:54'),
(6450, 9, '2019-08-28 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:05:29', '2019-08-29 07:05:29'),
(6451, 9, '2019-08-28 18:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:05:29', '2019-08-29 07:05:29'),
(6452, 24, '2019-08-28 09:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:05:29', '2019-08-29 07:05:29'),
(6453, 24, '2019-08-28 18:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:05:29', '2019-08-29 07:05:29'),
(6454, 8, '2019-08-28 09:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:05:29', '2019-08-29 07:05:29'),
(6455, 8, '2019-08-28 17:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:05:29', '2019-08-29 07:05:29'),
(6456, 10, '2019-08-28 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:05:29', '2019-08-29 07:05:29'),
(6457, 10, '2019-08-28 18:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:05:29', '2019-08-29 07:05:29'),
(6458, 3, '2019-08-28 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:06:15', '2019-08-29 07:06:15'),
(6459, 3, '2019-08-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:06:15', '2019-08-29 07:06:15'),
(6460, 2, '2019-08-28 10:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:06:15', '2019-08-29 07:06:15'),
(6461, 2, '2019-08-28 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:06:15', '2019-08-29 07:06:15'),
(6462, 26, '2019-08-28 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:06:55', '2019-08-29 07:06:55'),
(6463, 26, '2019-08-28 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:06:55', '2019-08-29 07:06:55'),
(6464, 5, '2019-08-28 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:06:55', '2019-08-29 07:06:55'),
(6465, 5, '2019-08-28 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-29 07:06:55', '2019-08-29 07:06:55'),
(6476, 1, '2019-08-29 10:36:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:00:16', '2019-08-31 06:00:16'),
(6477, 1, '2019-08-29 18:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:00:16', '2019-08-31 06:00:16'),
(6478, 4, '2019-08-29 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:00:48', '2019-08-31 06:00:48'),
(6479, 4, '2019-08-29 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:00:48', '2019-08-31 06:00:48'),
(6480, 7, '2019-08-29 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:02:06', '2019-08-31 06:02:06'),
(6481, 7, '2019-08-29 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:02:06', '2019-08-31 06:02:06'),
(6482, 9, '2019-08-29 09:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:03:31', '2019-08-31 06:03:31'),
(6483, 9, '2019-08-29 20:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:03:32', '2019-08-31 06:03:32'),
(6484, 24, '2019-08-29 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:03:32', '2019-08-31 06:03:32'),
(6485, 24, '2019-08-29 20:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:03:32', '2019-08-31 06:03:32'),
(6486, 8, '2019-08-29 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:03:32', '2019-08-31 06:03:32'),
(6487, 8, '2019-08-29 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:03:32', '2019-08-31 06:03:32'),
(6488, 10, '2019-08-29 09:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:03:32', '2019-08-31 06:03:32'),
(6489, 10, '2019-08-29 20:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:03:32', '2019-08-31 06:03:32'),
(6490, 3, '2019-08-29 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:04:02', '2019-08-31 06:04:02'),
(6491, 3, '2019-08-29 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:04:02', '2019-08-31 06:04:02'),
(6492, 26, '2019-08-29 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:04:41', '2019-08-31 06:04:41'),
(6493, 26, '2019-08-29 18:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:04:41', '2019-08-31 06:04:41'),
(6494, 5, '2019-08-29 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:04:41', '2019-08-31 06:04:41'),
(6495, 5, '2019-08-29 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-31 06:04:41', '2019-08-31 06:04:41'),
(6505, 1, '2019-08-31 10:27:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 09:25:22', '2019-09-01 09:25:22'),
(6506, 1, '2019-08-31 17:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 09:25:22', '2019-09-01 09:25:22'),
(6507, 4, '2019-08-31 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 09:57:37', '2019-09-01 09:57:37'),
(6508, 4, '2019-08-31 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 09:57:37', '2019-09-01 09:57:37'),
(6509, 7, '2019-08-31 09:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 09:59:31', '2019-09-01 09:59:31'),
(6510, 7, '2019-08-31 18:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 09:59:31', '2019-09-01 09:59:31'),
(6511, 9, '2019-08-31 09:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 10:00:37', '2019-09-01 10:00:37'),
(6512, 9, '2019-08-31 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 10:00:37', '2019-09-01 10:00:37'),
(6513, 24, '2019-08-31 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 10:00:37', '2019-09-01 10:00:37'),
(6514, 24, '2019-08-31 18:29:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 10:00:37', '2019-09-01 10:00:37'),
(6515, 8, '2019-08-31 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 10:00:37', '2019-09-01 10:00:37'),
(6516, 8, '2019-08-31 18:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 10:00:37', '2019-09-01 10:00:37'),
(6517, 10, '2019-08-31 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 10:00:37', '2019-09-01 10:00:37'),
(6518, 10, '2019-08-31 18:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 10:00:37', '2019-09-01 10:00:37'),
(6519, 3, '2019-08-31 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 10:01:23', '2019-09-01 10:01:23'),
(6520, 3, '2019-08-31 18:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 10:01:23', '2019-09-01 10:01:23'),
(6521, 5, '2019-08-31 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 10:01:45', '2019-09-01 10:01:45'),
(6522, 5, '2019-08-31 17:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-01 10:01:45', '2019-09-01 10:01:45'),
(6533, 1, '2019-09-01 11:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02 05:56:15', '2019-09-02 05:56:15'),
(6534, 1, '2019-09-01 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02 05:56:15', '2019-09-02 05:56:15'),
(6535, 4, '2019-09-01 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02 05:58:10', '2019-09-02 05:58:10'),
(6536, 4, '2019-09-01 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02 05:58:10', '2019-09-02 05:58:10'),
(6551, 3, '2019-09-01 10:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02 06:01:39', '2019-09-02 06:01:39'),
(6552, 3, '2019-09-01 18:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02 06:01:39', '2019-09-02 06:01:39'),
(6553, 26, '2019-09-01 10:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02 06:02:24', '2019-09-02 06:02:24'),
(6554, 26, '2019-09-01 18:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02 06:02:24', '2019-09-02 06:02:24'),
(6555, 5, '2019-09-01 10:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02 06:02:24', '2019-09-02 06:02:24'),
(6556, 5, '2019-09-01 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02 06:02:24', '2019-09-02 06:02:24'),
(6567, 1, '2019-09-02 10:24:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:45:04', '2019-09-03 14:45:04'),
(6568, 1, '2019-09-02 18:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:45:04', '2019-09-03 14:45:04'),
(6569, 4, '2019-09-02 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:45:28', '2019-09-03 14:45:28'),
(6570, 4, '2019-09-02 18:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:45:28', '2019-09-03 14:45:28'),
(6573, 9, '2019-09-02 09:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:50:20', '2019-09-03 14:50:20'),
(6574, 9, '2019-09-02 19:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:50:20', '2019-09-03 14:50:20'),
(6575, 24, '2019-09-02 09:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:50:20', '2019-09-03 14:50:20'),
(6576, 24, '2019-09-02 19:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:50:20', '2019-09-03 14:50:20'),
(6577, 8, '2019-09-02 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:50:20', '2019-09-03 14:50:20'),
(6578, 8, '2019-09-02 18:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:50:20', '2019-09-03 14:50:20'),
(6579, 10, '2019-09-02 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:50:20', '2019-09-03 14:50:20'),
(6580, 10, '2019-09-02 19:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:50:20', '2019-09-03 14:50:20'),
(6581, 3, '2019-09-02 09:41:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:50:56', '2019-09-03 14:50:56'),
(6582, 3, '2019-09-02 18:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:50:56', '2019-09-03 14:50:56'),
(6583, 26, '2019-09-02 10:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:51:38', '2019-09-03 14:51:38'),
(6584, 26, '2019-09-02 18:46:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:51:38', '2019-09-03 14:51:38'),
(6585, 5, '2019-09-02 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:51:38', '2019-09-03 14:51:38'),
(6586, 5, '2019-09-02 18:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-03 14:51:38', '2019-09-03 14:51:38'),
(6597, 1, '2019-09-03 11:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:29:13', '2019-09-04 14:29:13'),
(6598, 1, '2019-09-03 18:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:29:13', '2019-09-04 14:29:13'),
(6599, 4, '2019-09-03 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:29:56', '2019-09-04 14:29:56'),
(6600, 4, '2019-09-03 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:29:56', '2019-09-04 14:29:56'),
(6601, 7, '2019-09-03 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:31:28', '2019-09-04 14:31:28'),
(6602, 7, '2019-09-03 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:31:28', '2019-09-04 14:31:28'),
(6603, 32, '2019-09-03 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:31:28', '2019-09-04 14:31:28'),
(6604, 32, '2019-09-03 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:31:28', '2019-09-04 14:31:28'),
(6605, 9, '2019-09-03 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:41:35', '2019-09-04 14:41:35'),
(6606, 9, '2019-09-03 20:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:41:35', '2019-09-04 14:41:35'),
(6607, 24, '2019-09-03 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:41:35', '2019-09-04 14:41:35'),
(6608, 24, '2019-09-03 20:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:41:35', '2019-09-04 14:41:35'),
(6609, 8, '2019-09-03 09:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:41:35', '2019-09-04 14:41:35'),
(6610, 8, '2019-09-03 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:41:35', '2019-09-04 14:41:35'),
(6611, 10, '2019-09-03 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:41:35', '2019-09-04 14:41:35'),
(6612, 10, '2019-09-03 20:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:41:35', '2019-09-04 14:41:35'),
(6613, 3, '2019-09-03 09:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:42:55', '2019-09-04 14:42:55'),
(6614, 3, '2019-09-03 18:17:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:42:55', '2019-09-04 14:42:55'),
(6615, 26, '2019-09-03 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:43:52', '2019-09-04 14:43:52'),
(6616, 26, '2019-09-03 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:43:52', '2019-09-04 14:43:52'),
(6617, 5, '2019-09-03 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:43:52', '2019-09-04 14:43:52'),
(6618, 5, '2019-09-03 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 14:43:52', '2019-09-04 14:43:52'),
(6630, 9, '2019-09-01 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:14:22', '2019-09-04 15:14:22'),
(6631, 9, '2019-09-01 18:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:14:22', '2019-09-04 15:14:22'),
(6632, 24, '2019-09-01 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:14:22', '2019-09-04 15:14:22'),
(6633, 24, '2019-09-01 18:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:14:22', '2019-09-04 15:14:22'),
(6634, 8, '2019-09-01 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:14:22', '2019-09-04 15:14:22'),
(6635, 8, '2019-09-01 18:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:14:22', '2019-09-04 15:14:22'),
(6636, 10, '2019-09-01 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:14:22', '2019-09-04 15:14:22'),
(6637, 10, '2019-09-01 18:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:14:22', '2019-09-04 15:14:22'),
(6638, 7, '2019-09-01 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:17:10', '2019-09-04 15:17:10'),
(6639, 7, '2019-09-01 18:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:17:10', '2019-09-04 15:17:10'),
(6640, 32, '2019-09-01 10:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:17:10', '2019-09-04 15:17:10'),
(6641, 32, '2019-09-01 18:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:17:10', '2019-09-04 15:17:10'),
(6642, 7, '2019-09-02 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:17:46', '2019-09-04 15:17:46'),
(6643, 7, '2019-09-02 19:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:17:46', '2019-09-04 15:17:46'),
(6644, 32, '2019-09-02 09:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:17:46', '2019-09-04 15:17:46'),
(6645, 32, '2019-09-02 19:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 15:17:46', '2019-09-04 15:17:46'),
(6646, 1, '2019-09-04 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:42:41', '2019-09-05 14:42:41'),
(6647, 1, '2019-09-04 18:59:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:42:41', '2019-09-05 14:42:41'),
(6648, 4, '2019-09-04 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:50:03', '2019-09-05 14:50:03');
INSERT INTO `employee_attendance` (`employee_attendance_id`, `finger_print_id`, `in_out_time`, `check_type`, `verify_code`, `sensor_id`, `Memoinfo`, `WorkCode`, `sn`, `UserExtFmt`, `mechine_sl`, `created_at`, `updated_at`) VALUES
(6649, 4, '2019-09-04 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:50:03', '2019-09-05 14:50:03'),
(6650, 7, '2019-09-04 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:51:08', '2019-09-05 14:51:08'),
(6651, 7, '2019-09-04 18:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:51:08', '2019-09-05 14:51:08'),
(6652, 32, '2019-09-04 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:51:08', '2019-09-05 14:51:08'),
(6653, 32, '2019-09-04 18:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:51:08', '2019-09-05 14:51:08'),
(6654, 9, '2019-09-04 09:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:52:57', '2019-09-05 14:52:57'),
(6655, 9, '2019-09-04 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:52:57', '2019-09-05 14:52:57'),
(6656, 24, '2019-09-04 09:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:52:57', '2019-09-05 14:52:57'),
(6657, 24, '2019-09-04 19:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:52:57', '2019-09-05 14:52:57'),
(6658, 8, '2019-09-04 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:52:57', '2019-09-05 14:52:57'),
(6659, 8, '2019-09-04 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:52:57', '2019-09-05 14:52:57'),
(6660, 10, '2019-09-04 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:52:57', '2019-09-05 14:52:57'),
(6661, 10, '2019-09-04 19:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:52:57', '2019-09-05 14:52:57'),
(6662, 3, '2019-09-04 09:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:53:52', '2019-09-05 14:53:52'),
(6663, 3, '2019-09-04 18:26:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:53:52', '2019-09-05 14:53:52'),
(6664, 26, '2019-09-04 10:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:55:53', '2019-09-05 14:55:53'),
(6665, 26, '2019-09-04 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:55:53', '2019-09-05 14:55:53'),
(6666, 5, '2019-09-04 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:55:53', '2019-09-05 14:55:53'),
(6667, 5, '2019-09-04 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-05 14:55:53', '2019-09-05 14:55:53'),
(6689, 1, '2019-09-05 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:44:42', '2019-09-07 14:44:42'),
(6690, 1, '2019-09-05 18:37:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:44:42', '2019-09-07 14:44:42'),
(6691, 4, '2019-09-05 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:45:23', '2019-09-07 14:45:23'),
(6692, 4, '2019-09-05 18:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:45:23', '2019-09-07 14:45:23'),
(6693, 7, '2019-09-05 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:46:16', '2019-09-07 14:46:16'),
(6694, 7, '2019-09-05 20:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:46:16', '2019-09-07 14:46:16'),
(6695, 32, '2019-09-05 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:46:16', '2019-09-07 14:46:16'),
(6696, 32, '2019-09-05 20:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:46:16', '2019-09-07 14:46:16'),
(6697, 9, '2019-09-05 09:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:47:39', '2019-09-07 14:47:39'),
(6698, 9, '2019-09-05 20:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:47:39', '2019-09-07 14:47:39'),
(6699, 24, '2019-09-05 09:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:47:39', '2019-09-07 14:47:39'),
(6700, 24, '2019-09-05 15:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:47:39', '2019-09-07 14:47:39'),
(6701, 8, '2019-09-05 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:47:39', '2019-09-07 14:47:39'),
(6702, 8, '2019-09-05 18:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:47:39', '2019-09-07 14:47:39'),
(6703, 10, '2019-09-05 09:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:47:39', '2019-09-07 14:47:39'),
(6704, 10, '2019-09-05 20:49:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:47:39', '2019-09-07 14:47:39'),
(6705, 3, '2019-09-05 10:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:48:11', '2019-09-07 14:48:11'),
(6706, 3, '2019-09-05 18:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:48:11', '2019-09-07 14:48:11'),
(6711, 26, '2019-09-05 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:53:13', '2019-09-07 14:53:13'),
(6712, 26, '2019-09-05 18:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:53:13', '2019-09-07 14:53:13'),
(6713, 5, '2019-09-05 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:53:13', '2019-09-07 14:53:13'),
(6714, 5, '2019-09-05 18:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-07 14:53:13', '2019-09-07 14:53:13'),
(6725, 4, '2019-09-07 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:56:21', '2019-09-08 15:56:21'),
(6726, 4, '2019-09-07 18:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:56:21', '2019-09-08 15:56:21'),
(6727, 7, '2019-09-07 09:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:57:24', '2019-09-08 15:57:24'),
(6728, 7, '2019-09-07 19:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:57:24', '2019-09-08 15:57:24'),
(6729, 32, '2019-09-07 09:42:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:57:24', '2019-09-08 15:57:24'),
(6730, 32, '2019-09-07 19:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:57:24', '2019-09-08 15:57:24'),
(6731, 9, '2019-09-07 09:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:59:40', '2019-09-08 15:59:40'),
(6732, 9, '2019-09-07 19:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:59:40', '2019-09-08 15:59:40'),
(6733, 24, '2019-09-07 09:23:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:59:40', '2019-09-08 15:59:40'),
(6734, 24, '2019-09-07 17:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:59:40', '2019-09-08 15:59:40'),
(6735, 8, '2019-09-07 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:59:40', '2019-09-08 15:59:40'),
(6736, 8, '2019-09-07 18:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:59:40', '2019-09-08 15:59:40'),
(6737, 10, '2019-09-07 09:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:59:40', '2019-09-08 15:59:40'),
(6738, 10, '2019-09-07 19:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 15:59:40', '2019-09-08 15:59:40'),
(6739, 3, '2019-09-07 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 16:00:10', '2019-09-08 16:00:10'),
(6740, 3, '2019-09-07 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 16:00:10', '2019-09-08 16:00:10'),
(6741, 26, '2019-09-07 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 16:00:50', '2019-09-08 16:00:50'),
(6742, 26, '2019-09-07 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 16:00:50', '2019-09-08 16:00:50'),
(6743, 5, '2019-09-07 10:07:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 16:00:50', '2019-09-08 16:00:50'),
(6744, 5, '2019-09-07 18:51:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-08 16:00:50', '2019-09-08 16:00:50'),
(6745, 1, '2019-09-08 10:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:03:29', '2019-09-09 15:03:29'),
(6746, 1, '2019-09-08 18:33:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:03:29', '2019-09-09 15:03:29'),
(6747, 4, '2019-09-08 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:16:21', '2019-09-09 15:16:21'),
(6748, 4, '2019-09-08 18:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:16:21', '2019-09-09 15:16:21'),
(6749, 7, '2019-09-08 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:17:11', '2019-09-09 15:17:11'),
(6750, 7, '2019-09-08 20:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:17:11', '2019-09-09 15:17:11'),
(6751, 32, '2019-09-08 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:17:11', '2019-09-09 15:17:11'),
(6752, 32, '2019-09-08 20:02:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:17:11', '2019-09-09 15:17:11'),
(6753, 9, '2019-09-08 09:06:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:18:31', '2019-09-09 15:18:31'),
(6754, 9, '2019-09-08 20:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:18:31', '2019-09-09 15:18:31'),
(6755, 8, '2019-09-08 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:18:31', '2019-09-09 15:18:31'),
(6756, 8, '2019-09-08 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:18:31', '2019-09-09 15:18:31'),
(6757, 10, '2019-09-08 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:18:31', '2019-09-09 15:18:31'),
(6758, 10, '2019-09-08 20:03:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:18:31', '2019-09-09 15:18:31'),
(6759, 3, '2019-09-08 10:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:27:34', '2019-09-09 15:27:34'),
(6760, 3, '2019-09-08 19:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:27:34', '2019-09-09 15:27:34'),
(6761, 26, '2019-09-08 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:28:39', '2019-09-09 15:28:39'),
(6762, 26, '2019-09-08 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:28:39', '2019-09-09 15:28:39'),
(6763, 5, '2019-09-08 10:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:28:39', '2019-09-09 15:28:39'),
(6764, 5, '2019-09-08 18:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-09 15:28:39', '2019-09-09 15:28:39'),
(6775, 1, '2019-09-11 10:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:14:41', '2019-09-11 15:14:41'),
(6776, 4, '2019-09-11 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:14:59', '2019-09-11 15:14:59'),
(6777, 7, '2019-09-11 09:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:15:45', '2019-09-11 15:15:45'),
(6778, 32, '2019-09-11 09:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:15:45', '2019-09-11 15:15:45'),
(6779, 24, '2019-09-11 09:38:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:17:27', '2019-09-11 15:17:27'),
(6780, 8, '2019-09-11 09:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:17:27', '2019-09-11 15:17:27'),
(6781, 10, '2019-09-11 09:28:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:17:27', '2019-09-11 15:17:27'),
(6782, 3, '2019-09-11 09:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:18:17', '2019-09-11 15:18:17'),
(6783, 26, '2019-09-11 10:21:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:19:46', '2019-09-11 15:19:46'),
(6784, 5, '2019-09-11 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:19:46', '2019-09-11 15:19:46'),
(6785, 1, '2019-09-09 10:53:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:22:59', '2019-09-11 15:22:59'),
(6786, 1, '2019-09-09 18:39:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:22:59', '2019-09-11 15:22:59'),
(6787, 4, '2019-09-09 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:23:27', '2019-09-11 15:23:27'),
(6788, 4, '2019-09-09 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:23:27', '2019-09-11 15:23:27'),
(6789, 7, '2019-09-09 09:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:24:23', '2019-09-11 15:24:23'),
(6790, 7, '2019-09-09 18:19:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:24:23', '2019-09-11 15:24:23'),
(6791, 32, '2019-09-09 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:24:23', '2019-09-11 15:24:23'),
(6792, 32, '2019-09-09 17:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:24:23', '2019-09-11 15:24:23'),
(6793, 9, '2019-09-09 09:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:25:57', '2019-09-11 15:25:57'),
(6794, 9, '2019-09-09 18:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:25:57', '2019-09-11 15:25:57'),
(6795, 24, '2019-09-09 09:31:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:25:57', '2019-09-11 15:25:57'),
(6796, 24, '2019-09-09 15:57:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:25:57', '2019-09-11 15:25:57'),
(6797, 8, '2019-09-09 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:25:57', '2019-09-11 15:25:57'),
(6798, 8, '2019-09-09 18:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:25:57', '2019-09-11 15:25:57'),
(6799, 10, '2019-09-09 09:52:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:25:57', '2019-09-11 15:25:57'),
(6800, 10, '2019-09-09 18:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:25:57', '2019-09-11 15:25:57'),
(6801, 3, '2019-09-09 09:47:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:26:18', '2019-09-11 15:26:18'),
(6802, 3, '2019-09-09 18:18:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:26:18', '2019-09-11 15:26:18'),
(6803, 5, '2019-09-09 10:04:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:27:11', '2019-09-11 15:27:11'),
(6804, 5, '2019-09-09 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-11 15:27:11', '2019-09-11 15:27:11'),
(6805, 1, '2019-09-12 10:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:12:51', '2019-09-12 08:12:51'),
(6806, 1, '2019-09-12 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:12:51', '2019-09-12 08:12:51'),
(6807, 11, '2019-09-12 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:12:51', '2019-09-12 08:12:51'),
(6808, 11, '2019-09-12 18:11:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:12:51', '2019-09-12 08:12:51'),
(6809, 12, '2019-09-12 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:12:51', '2019-09-12 08:12:51'),
(6810, 12, '2019-09-12 18:09:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:12:51', '2019-09-12 08:12:51'),
(6811, 33, '2019-09-12 10:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:12:51', '2019-09-12 08:12:51'),
(6812, 33, '2019-09-12 19:12:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:12:51', '2019-09-12 08:12:51'),
(6813, 4, '2019-09-12 09:54:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:13:23', '2019-09-12 08:13:23'),
(6814, 4, '2019-09-12 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:13:23', '2019-09-12 08:13:23'),
(6815, 7, '2019-09-12 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:14:02', '2019-09-12 08:14:02'),
(6816, 7, '2019-09-12 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:14:02', '2019-09-12 08:14:02'),
(6817, 32, '2019-09-12 10:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:14:02', '2019-09-12 08:14:02'),
(6818, 32, '2019-09-12 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:14:02', '2019-09-12 08:14:02'),
(6819, 9, '2019-09-12 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:15:19', '2019-09-12 08:15:19'),
(6820, 9, '2019-09-12 18:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:15:19', '2019-09-12 08:15:19'),
(6821, 24, '2019-09-12 10:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:15:19', '2019-09-12 08:15:19'),
(6822, 24, '2019-09-12 18:13:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:15:19', '2019-09-12 08:15:19'),
(6823, 8, '2019-09-12 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:15:19', '2019-09-12 08:15:19'),
(6824, 8, '2019-09-12 19:14:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:15:19', '2019-09-12 08:15:19'),
(6825, 10, '2019-09-12 10:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:15:19', '2019-09-12 08:15:19'),
(6826, 10, '2019-09-12 19:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:15:19', '2019-09-12 08:15:19'),
(6827, 3, '2019-09-12 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:15:35', '2019-09-12 08:15:35'),
(6828, 3, '2019-09-12 18:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-12 08:15:35', '2019-09-12 08:15:35');

-- --------------------------------------------------------

--
-- Table structure for table `employee_attendance_approve`
--

CREATE TABLE `employee_attendance_approve` (
  `employee_attendance_approve_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(11) NOT NULL,
  `finger_print_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `in_time` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `out_time` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `working_hour` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `approve_working_hour` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `employee_attendance_approve`
--

INSERT INTO `employee_attendance_approve` (`employee_attendance_approve_id`, `employee_id`, `finger_print_id`, `date`, `in_time`, `out_time`, `working_hour`, `approve_working_hour`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 2, 884, '2018-01-08', '08:30', '17:40', '09:10', '09:10', 1, 1, NULL, NULL),
(2, 4, 808, '2018-01-08', '11:25', '18:25', '07:00', '07:10', 1, 1, NULL, NULL),
(5, 2, 884, '2018-01-09', '08:45', '17:45', '09:00', '09:00', 2, 2, NULL, NULL),
(6, 24, 848, '2018-01-09', '00:00', '00:00', '00:00', '00:00', 2, 2, NULL, NULL),
(7, 22, 24, '2019-09-12', '10:14', '18:13', '07:59', '07:59', 2, 2, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `employee_award`
--

CREATE TABLE `employee_award` (
  `employee_award_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(11) NOT NULL,
  `award_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gift_item` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `month` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employee_bonus`
--

CREATE TABLE `employee_bonus` (
  `employee_bonus_id` int(10) UNSIGNED NOT NULL,
  `bonus_setting_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `month` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gross_salary` int(11) NOT NULL,
  `basic_salary` int(11) NOT NULL,
  `bonus_amount` int(11) NOT NULL,
  `tax` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employee_education_qualification`
--

CREATE TABLE `employee_education_qualification` (
  `employee_education_qualification_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `institute` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `board_university` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `degree` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `result` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cgpa` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `passing_year` year(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `employee_education_qualification`
--

INSERT INTO `employee_education_qualification` (`employee_education_qualification_id`, `employee_id`, `institute`, `board_university`, `degree`, `result`, `cgpa`, `created_at`, `updated_at`, `passing_year`) VALUES
(1, 31, 'University', 'University of Dhaka', 'MBA', NULL, '3.42', NULL, '2019-08-28 04:00:29', 2019),
(2, 17, 'Board', 'Rajshahi', 'SSC', NULL, '4.95', '2019-05-04 10:29:50', '2019-05-04 10:44:06', 2007),
(3, 17, 'Board', 'Bangladesh Pharmacy Council', 'Diploma', NULL, 'Passed', '2019-05-04 10:29:50', '2019-05-04 10:44:06', 2014),
(4, 17, 'University', 'The University of Comilla', 'Bsc in Food Science & Technology', 'Second class', '3.55', '2019-05-04 10:29:50', '2019-05-04 10:44:06', 2018),
(5, 20, 'University', 'Daffodil International University', 'Bsc in EEE', 'Second class', '2.98', '2019-05-04 10:45:46', '2019-05-04 10:47:38', 2018),
(6, 2, 'Board', 'Madrasah Board', 'SSC', 'First class', '5.00', '2019-05-04 11:05:16', '2019-09-12 09:03:07', 2011),
(7, 2, 'Board', 'Feni computer institute', 'Diploma in CST', 'First class', '3.51', '2019-05-04 11:05:16', '2019-09-12 09:03:07', 2015),
(8, 2, 'University', 'Bangladesh University', 'BSC in CSE', 'First class', '3.80', '2019-05-04 11:05:16', '2019-09-12 09:03:07', 2019);

-- --------------------------------------------------------

--
-- Table structure for table `employee_experience`
--

CREATE TABLE `employee_experience` (
  `employee_experience_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `organization_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `designation` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `skill` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `responsibility` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employee_performance`
--

CREATE TABLE `employee_performance` (
  `employee_performance_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(11) NOT NULL,
  `month` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `remarks` text COLLATE utf8mb4_unicode_ci,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `employee_performance`
--

INSERT INTO `employee_performance` (`employee_performance_id`, `employee_id`, `month`, `created_by`, `updated_by`, `remarks`, `status`, `created_at`, `updated_at`) VALUES
(1, 16, '2019-08', 2, 2, 'Excellent working expertise', 1, '2019-09-12 08:33:11', '2019-09-12 08:33:14');

-- --------------------------------------------------------

--
-- Table structure for table `employee_performance_details`
--

CREATE TABLE `employee_performance_details` (
  `employee_performance_details_id` int(10) UNSIGNED NOT NULL,
  `employee_performance_id` int(10) UNSIGNED NOT NULL,
  `performance_criteria_id` int(10) UNSIGNED NOT NULL,
  `rating` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `employee_performance_details`
--

INSERT INTO `employee_performance_details` (`employee_performance_details_id`, `employee_performance_id`, `performance_criteria_id`, `rating`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 10, '2019-09-12 08:33:14', '2019-09-12 08:33:14');

-- --------------------------------------------------------

--
-- Table structure for table `holiday`
--

CREATE TABLE `holiday` (
  `holiday_id` int(10) UNSIGNED NOT NULL,
  `holiday_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `holiday`
--

INSERT INTO `holiday` (`holiday_id`, `holiday_name`, `created_at`, `updated_at`) VALUES
(2, 'Victory Day', '2018-12-06 04:31:16', '2018-12-06 04:31:16'),
(3, 'Christmas Day', '2018-12-17 09:09:59', '2018-12-17 09:09:59'),
(4, 'Mother Language Day', '2019-02-05 05:03:10', '2019-02-05 05:03:10'),
(5, 'Libaration Day', '2019-02-05 05:30:49', '2019-02-05 05:30:49'),
(6, 'Birthday of Bangabandhu', '2019-02-14 04:13:47', '2019-02-14 04:13:47'),
(7, 'Pohela Boishak', '2019-02-14 04:18:48', '2019-02-14 04:18:48'),
(8, 'May Day', '2019-02-14 04:20:18', '2019-02-14 04:20:18'),
(9, 'Election of DNCC', '2019-03-02 06:29:22', '2019-03-02 06:29:22'),
(10, 'Annual Picnic 2019', '2019-03-18 09:29:55', '2019-03-18 09:29:55'),
(11, 'Shab-E-Barat', '2019-04-23 10:42:43', '2019-04-23 10:42:43'),
(12, 'Buddha Purnima', '2019-05-19 05:16:17', '2019-05-19 05:16:17'),
(13, 'Shab-E-Qadar', '2019-06-03 04:52:55', '2019-06-03 04:55:55'),
(14, 'Eid-ul-Fitr', '2019-06-03 04:54:23', '2019-06-03 04:54:23'),
(15, 'Eid-ul-Adha 2019', '2019-08-08 05:55:02', '2019-08-08 05:55:02'),
(16, 'Ashura', '2019-09-11 15:31:24', '2019-09-11 15:31:24');

-- --------------------------------------------------------

--
-- Table structure for table `holiday_details`
--

CREATE TABLE `holiday_details` (
  `holiday_details_id` int(10) UNSIGNED NOT NULL,
  `holiday_id` int(10) UNSIGNED NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `holiday_details`
--

INSERT INTO `holiday_details` (`holiday_details_id`, `holiday_id`, `from_date`, `to_date`, `comment`, `created_at`, `updated_at`) VALUES
(2, 2, '2019-12-16', '2019-12-16', 'victory day', '2018-12-06 04:32:14', '2019-02-14 04:17:47'),
(3, 3, '2019-12-25', '2019-12-25', NULL, '2018-12-17 09:10:31', '2019-02-14 04:16:09'),
(4, 4, '2019-02-21', '2019-02-21', 'mother language day', '2019-02-05 05:09:52', '2019-02-05 05:09:52'),
(5, 5, '2019-03-26', '2019-03-26', NULL, '2019-02-05 05:31:10', '2019-02-05 05:31:10'),
(6, 6, '2019-03-17', '2019-03-17', NULL, '2019-02-14 04:14:47', '2019-03-18 09:28:48'),
(7, 7, '2019-04-14', '2019-04-14', 'Bangla new year', '2019-02-14 04:19:23', '2019-02-14 04:19:23'),
(8, 8, '2019-05-01', '2019-05-01', NULL, '2019-02-14 04:20:37', '2019-02-14 04:20:37'),
(9, 9, '2019-02-28', '2019-02-28', NULL, '2019-03-02 06:30:20', '2019-03-02 06:30:20'),
(10, 10, '2019-03-16', '2019-03-16', NULL, '2019-03-18 09:30:46', '2019-03-18 09:30:46'),
(11, 11, '2019-04-22', '2019-04-22', 'shab e barat', '2019-04-23 10:43:06', '2019-04-23 10:43:06'),
(12, 12, '2019-05-18', '2019-05-18', 'Buddha Purnima', '2019-05-19 05:16:51', '2019-05-19 05:16:51'),
(13, 13, '2019-06-02', '2019-06-02', 'Shab-E-Qadar', '2019-06-03 04:57:15', '2019-06-03 04:57:15'),
(14, 14, '2019-06-04', '2019-06-09', 'Eid-ul-Fitr', '2019-06-03 05:01:59', '2019-09-11 17:44:37'),
(15, 15, '2019-08-10', '2019-08-15', 'Eid-ul-Adha 2019', '2019-08-08 05:56:10', '2019-08-08 05:56:10'),
(16, 16, '2019-09-10', '2019-09-10', 'Ashura (10 Muharram)', '2019-09-11 15:32:21', '2019-09-11 15:32:21');

-- --------------------------------------------------------

--
-- Table structure for table `hourly_salaries`
--

CREATE TABLE `hourly_salaries` (
  `hourly_salaries_id` int(10) UNSIGNED NOT NULL,
  `hourly_grade` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hourly_rate` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hourly_salaries`
--

INSERT INTO `hourly_salaries` (`hourly_salaries_id`, `hourly_grade`, `hourly_rate`, `created_at`, `updated_at`) VALUES
(1, 'H-A', 1000, '2018-01-08 04:27:51', '2018-01-08 04:27:51');

-- --------------------------------------------------------

--
-- Table structure for table `interview`
--

CREATE TABLE `interview` (
  `interview_id` int(10) UNSIGNED NOT NULL,
  `job_applicant_id` int(10) UNSIGNED NOT NULL,
  `interview_date` date NOT NULL,
  `interview_time` time NOT NULL,
  `interview_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job`
--

CREATE TABLE `job` (
  `job_id` int(10) UNSIGNED NOT NULL,
  `job_title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `post` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `application_end_date` date NOT NULL,
  `publish_date` date NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_applicant`
--

CREATE TABLE `job_applicant` (
  `job_applicant_id` int(10) UNSIGNED NOT NULL,
  `job_id` int(10) UNSIGNED NOT NULL,
  `applicant_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applicant_email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` int(11) NOT NULL,
  `cover_letter` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `attached_resume` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `application_date` date NOT NULL,
  `status` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leave_application`
--

CREATE TABLE `leave_application` (
  `leave_application_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `leave_type_id` int(10) UNSIGNED NOT NULL,
  `application_from_date` date NOT NULL,
  `application_to_date` date NOT NULL,
  `application_date` date NOT NULL,
  `number_of_day` int(11) NOT NULL,
  `approve_date` date DEFAULT NULL,
  `reject_date` date DEFAULT NULL,
  `approve_by` int(11) DEFAULT NULL,
  `reject_by` int(11) DEFAULT NULL,
  `purpose` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `remarks` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT 'status(1,2,3) = Pending,Approve,Reject',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `leave_application`
--

INSERT INTO `leave_application` (`leave_application_id`, `employee_id`, `leave_type_id`, `application_from_date`, `application_to_date`, `application_date`, `number_of_day`, `approve_date`, `reject_date`, `approve_by`, `reject_by`, `purpose`, `remarks`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 1, '2018-12-22', '2018-12-22', '2018-12-15', 1, '2019-02-06', NULL, 24, NULL, 'dsfsdf', NULL, '2', '2018-12-15 10:13:33', '2019-02-06 07:29:36'),
(2, 2, 2, '2019-02-09', '2019-02-09', '2019-02-06', 1, '2019-02-06', NULL, 24, NULL, 'Going To Home District ....', 'enjoy your time', '2', '2019-02-06 07:20:53', '2019-02-06 07:39:00'),
(3, 2, 2, '2019-02-18', '2019-02-18', '2019-02-14', 1, NULL, '2019-02-17', NULL, 24, 'Going to Home for bring my NID ..& Smart Card', NULL, '3', '2019-02-14 04:25:23', '2019-02-17 04:50:00'),
(4, 2, 2, '2019-02-18', '2019-02-18', '2019-02-17', 1, '2019-02-17', NULL, 24, NULL, 'Going to home for NID purpose', NULL, '2', '2019-02-17 04:48:58', '2019-02-17 04:50:08'),
(5, 16, 2, '2019-03-09', '2019-03-09', '2019-03-06', 1, '2019-04-10', NULL, 24, NULL, 'Due to Exam', 'dd', '2', '2019-03-06 06:34:40', '2019-04-10 04:41:00'),
(6, 20, 2, '2019-04-11', '2019-04-14', '2019-04-10', 2, '2019-04-10', NULL, 24, NULL, 'Going Home', 'Approved', '2', '2019-04-10 04:40:06', '2019-04-10 04:41:08'),
(7, 23, 2, '2019-09-26', '2019-09-29', '2019-09-12', 3, NULL, NULL, NULL, NULL, 'I\'m Going to abroad', NULL, '1', '2019-09-12 09:04:43', '2019-09-12 09:04:43');

-- --------------------------------------------------------

--
-- Table structure for table `leave_type`
--

CREATE TABLE `leave_type` (
  `leave_type_id` int(10) UNSIGNED NOT NULL,
  `leave_type_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `num_of_day` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `leave_type`
--

INSERT INTO `leave_type` (`leave_type_id`, `leave_type_name`, `num_of_day`, `created_at`, `updated_at`) VALUES
(1, 'Earn Leave', 0, '2018-01-10 10:25:01', '2018-01-10 10:25:01'),
(2, 'Casual Leave', 22, '2018-01-10 10:25:01', '2018-01-10 10:25:01'),
(3, 'Sick Leave	', 20, '2018-01-10 10:25:01', '2018-01-10 10:25:01');

-- --------------------------------------------------------

--
-- Table structure for table `menus`
--

CREATE TABLE `menus` (
  `id` int(10) UNSIGNED NOT NULL,
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `action` int(11) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `menu_url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `module_id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `menus`
--

INSERT INTO `menus` (`id`, `parent_id`, `action`, `name`, `menu_url`, `module_id`, `status`) VALUES
(1, 0, NULL, 'User', 'user.index', 1, 2),
(2, 0, NULL, 'Manage Role', NULL, 1, 1),
(3, 2, NULL, 'Add Role', 'userRole.index', 1, 1),
(4, 2, NULL, 'Add Role Permission', 'rolePermission.index', 1, 1),
(5, 0, NULL, 'Change Password', 'changePassword.index', 1, 1),
(6, 0, NULL, 'Department', 'department.index', 2, 1),
(7, 0, NULL, 'Designation', 'designation.index', 2, 1),
(8, 0, NULL, 'Branch', 'branch.index', 2, 1),
(9, 0, NULL, 'Manage Employee', 'employee.index', 2, 1),
(10, 0, NULL, 'Setup', NULL, 3, 1),
(11, 10, NULL, 'Manage Holiday', 'holiday.index', 3, 1),
(12, 10, NULL, 'Public Holiday', 'publicHoliday.index', 3, 1),
(13, 10, NULL, 'Weekly Holiday', 'weeklyHoliday.index', 3, 1),
(14, 10, NULL, 'Leave Type', 'leaveType.index', 3, 1),
(15, 0, NULL, 'Leave Application', NULL, 3, 1),
(16, 15, NULL, 'Apply for Leave', 'applyForLeave.index', 3, 1),
(17, 15, NULL, 'Requested Application', 'requestedApplication.index', 3, 1),
(18, 0, NULL, 'Setup', NULL, 4, 1),
(19, 18, NULL, 'Manage Work Shift', 'workShift.index', 4, 1),
(20, 0, NULL, 'Report', NULL, 4, 1),
(21, 20, NULL, 'Daily Attendance', 'dailyAttendance.dailyAttendance', 4, 1),
(22, 0, NULL, 'Report', NULL, 3, 1),
(23, 22, NULL, 'Leave Report', 'leaveReport.leaveReport', 3, 1),
(24, 20, NULL, 'Monthly Attendance', 'monthlyAttendance.monthlyAttendance', 4, 1),
(25, 0, NULL, 'Setup', NULL, 5, 1),
(26, 25, NULL, 'Tax Rule Setup', 'taxSetup.index', 5, 1),
(27, 0, NULL, 'Allowance', 'allowance.index', 5, 1),
(28, 0, NULL, 'Deduction', 'deduction.index', 5, 1),
(29, 0, NULL, 'Monthly Pay Grade', 'payGrade.index', 5, 1),
(30, 0, NULL, 'Hourly Pay Grade', 'hourlyWages.index', 5, 1),
(31, 0, NULL, 'Generate Salary Sheet', 'generateSalarySheet.index', 5, 1),
(32, 25, NULL, 'Late Configration', 'salaryDeductionRule.index', 5, 1),
(33, 0, NULL, 'Report', NULL, 5, 1),
(34, 33, NULL, 'Payment History', 'paymentHistory.paymentHistory', 5, 1),
(35, 33, NULL, 'My Payroll', 'myPayroll.myPayroll', 5, 1),
(36, 0, NULL, 'Performance Category', 'performanceCategory.index', 6, 1),
(37, 0, NULL, 'Performance Criteria', 'performanceCriteria.index', 6, 1),
(38, 0, NULL, 'Employee Performance', 'employeePerformance.index', 6, 1),
(39, 0, NULL, 'Report', NULL, 6, 1),
(40, 39, NULL, 'Summary Report', 'performanceSummaryReport.performanceSummaryReport', 6, 1),
(41, 0, NULL, 'Job Post', 'jobPost.index', 7, 1),
(42, 0, NULL, 'Job Candidate', 'jobCandidate.index', 7, 1),
(43, 20, NULL, 'My Attendance Report', 'myAttendanceReport.myAttendanceReport', 4, 1),
(44, 10, NULL, 'Earn Leave Configure', 'earnLeaveConfigure.index', 3, 1),
(45, 0, NULL, 'Training Type', 'trainingType.index', 8, 1),
(46, 0, NULL, 'Training List', 'trainingInfo.index', 8, 1),
(47, 0, NULL, 'Training Report', 'employeeTrainingReport.employeeTrainingReport', 8, 1),
(48, 0, NULL, 'Award', 'award.index', 9, 1),
(49, 0, NULL, 'Notice', 'notice.index', 10, 1),
(50, 0, NULL, 'Settings', 'generalSettings.index', 11, 1),
(51, 0, NULL, 'Manual Attendance', 'manualAttendance.manualAttendance', 4, 1),
(52, 22, NULL, 'Summary Report', 'summaryReport.summaryReport', 3, 1),
(53, 22, NULL, 'My Leave Report', 'myLeaveReport.myLeaveReport', 3, 1),
(54, 0, NULL, 'Warning', 'warning.index', 2, 1),
(55, 0, NULL, 'Termination', 'termination.index', 2, 1),
(56, 0, NULL, 'Promotion', 'promotion.index', 2, 1),
(57, 20, NULL, 'Summary Report', 'attendanceSummaryReport.attendanceSummaryReport', 4, 1),
(58, 0, NULL, 'Manage Work Hour', NULL, 5, 1),
(59, 58, NULL, 'Approve Work Hour', 'workHourApproval.create', 5, 1),
(60, 0, NULL, 'Employee Permanent', 'permanent.index', 2, 1),
(61, 0, NULL, 'Manage Bonus', NULL, 5, 1),
(62, 61, NULL, 'Bonus Setting', 'bonusSetting.index', 5, 1),
(63, 61, NULL, 'Generate Bonus', 'generateBonus.index', 5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `menu_permission`
--

CREATE TABLE `menu_permission` (
  `id` int(10) UNSIGNED NOT NULL,
  `role_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `menu_permission`
--

INSERT INTO `menu_permission` (`id`, `role_id`, `menu_id`) VALUES
(230, 1, 2),
(231, 1, 3),
(232, 1, 4),
(233, 1, 5),
(234, 1, 6),
(235, 1, 7),
(236, 1, 8),
(237, 1, 9),
(238, 1, 54),
(239, 1, 55),
(240, 1, 56),
(241, 1, 60),
(242, 1, 10),
(243, 1, 11),
(244, 1, 12),
(245, 1, 13),
(246, 1, 14),
(247, 1, 15),
(248, 1, 16),
(249, 1, 17),
(250, 1, 22),
(251, 1, 23),
(252, 1, 44),
(253, 1, 52),
(254, 1, 53),
(255, 1, 18),
(256, 1, 19),
(257, 1, 20),
(258, 1, 21),
(259, 1, 24),
(260, 1, 43),
(261, 1, 51),
(262, 1, 57),
(263, 1, 25),
(264, 1, 26),
(265, 1, 27),
(266, 1, 28),
(267, 1, 29),
(268, 1, 30),
(269, 1, 31),
(270, 1, 32),
(271, 1, 33),
(272, 1, 34),
(273, 1, 35),
(274, 1, 58),
(275, 1, 59),
(276, 1, 61),
(277, 1, 62),
(278, 1, 63),
(279, 1, 36),
(280, 1, 37),
(281, 1, 38),
(282, 1, 39),
(283, 1, 40),
(284, 1, 41),
(285, 1, 42),
(286, 1, 45),
(287, 1, 46),
(288, 1, 47),
(289, 1, 48),
(290, 1, 49),
(291, 1, 50),
(487, 5, 2),
(488, 5, 3),
(489, 5, 4),
(490, 5, 5),
(491, 5, 6),
(492, 5, 7),
(493, 5, 8),
(494, 5, 9),
(495, 5, 54),
(496, 5, 55),
(497, 5, 56),
(498, 5, 60),
(499, 5, 10),
(500, 5, 11),
(501, 5, 12),
(502, 5, 13),
(503, 5, 14),
(504, 5, 15),
(505, 5, 16),
(506, 5, 17),
(507, 5, 22),
(508, 5, 23),
(509, 5, 44),
(510, 5, 52),
(511, 5, 53),
(512, 5, 18),
(513, 5, 19),
(514, 5, 20),
(515, 5, 21),
(516, 5, 24),
(517, 5, 43),
(518, 5, 51),
(519, 5, 57),
(520, 5, 25),
(521, 5, 26),
(522, 5, 27),
(523, 5, 28),
(524, 5, 29),
(525, 5, 30),
(526, 5, 31),
(527, 5, 32),
(528, 5, 33),
(529, 5, 34),
(530, 5, 35),
(531, 5, 58),
(532, 5, 59),
(533, 5, 61),
(534, 5, 62),
(535, 5, 63),
(536, 5, 36),
(537, 5, 37),
(538, 5, 38),
(539, 5, 39),
(540, 5, 40),
(541, 5, 41),
(542, 5, 42),
(543, 5, 45),
(544, 5, 46),
(545, 5, 47),
(546, 5, 48),
(547, 5, 49),
(548, 5, 50),
(549, 7, 5),
(550, 7, 15),
(551, 7, 16),
(552, 7, 17),
(553, 7, 22),
(554, 7, 53),
(555, 7, 20),
(556, 7, 43),
(557, 7, 33),
(558, 7, 35),
(559, 7, 45),
(560, 7, 46),
(561, 7, 47),
(568, 6, 20),
(569, 6, 43),
(570, 6, 45),
(571, 6, 46),
(572, 6, 47),
(676, 3, 2),
(677, 3, 3),
(678, 3, 4),
(679, 3, 5),
(680, 3, 6),
(681, 3, 7),
(682, 3, 8),
(683, 3, 9),
(684, 3, 54),
(685, 3, 55),
(686, 3, 56),
(687, 3, 60),
(688, 3, 10),
(689, 3, 11),
(690, 3, 12),
(691, 3, 13),
(692, 3, 14),
(693, 3, 15),
(694, 3, 16),
(695, 3, 17),
(696, 3, 22),
(697, 3, 23),
(698, 3, 44),
(699, 3, 52),
(700, 3, 53),
(701, 3, 18),
(702, 3, 19),
(703, 3, 20),
(704, 3, 21),
(705, 3, 24),
(706, 3, 43),
(707, 3, 57),
(708, 3, 25),
(709, 3, 26),
(710, 3, 27),
(711, 3, 28),
(712, 3, 29),
(713, 3, 30),
(714, 3, 31),
(715, 3, 32),
(716, 3, 33),
(717, 3, 34),
(718, 3, 35),
(719, 3, 58),
(720, 3, 59),
(721, 3, 61),
(722, 3, 62),
(723, 3, 63),
(724, 3, 36),
(725, 3, 37),
(726, 3, 38),
(727, 3, 39),
(728, 3, 40),
(729, 3, 41),
(730, 3, 42),
(731, 3, 45),
(732, 3, 46),
(733, 3, 47),
(734, 3, 48),
(735, 3, 49),
(736, 3, 50),
(737, 8, 2),
(738, 8, 4),
(739, 8, 5),
(740, 8, 10),
(741, 8, 11),
(742, 8, 12),
(743, 8, 13),
(744, 8, 14),
(745, 8, 15),
(746, 8, 16),
(747, 8, 17),
(748, 8, 22),
(749, 8, 23),
(750, 8, 44),
(751, 8, 52),
(752, 8, 53),
(753, 8, 20),
(754, 8, 21),
(755, 8, 24),
(756, 8, 43),
(757, 8, 57),
(758, 8, 48),
(759, 8, 49),
(760, 8, 50),
(761, 4, 5),
(762, 4, 15),
(763, 4, 16),
(764, 4, 22),
(765, 4, 53),
(766, 4, 20),
(767, 4, 43),
(768, 2, 5),
(769, 2, 6),
(770, 2, 7),
(771, 2, 8),
(772, 2, 9),
(773, 2, 54),
(774, 2, 55),
(775, 2, 56),
(776, 2, 60),
(777, 2, 10),
(778, 2, 11),
(779, 2, 12),
(780, 2, 13),
(781, 2, 14),
(782, 2, 15),
(783, 2, 16),
(784, 2, 17),
(785, 2, 22),
(786, 2, 23),
(787, 2, 44),
(788, 2, 52),
(789, 2, 53),
(790, 2, 18),
(791, 2, 19),
(792, 2, 20),
(793, 2, 21),
(794, 2, 24),
(795, 2, 43),
(796, 2, 57),
(797, 2, 36),
(798, 2, 37),
(799, 2, 38),
(800, 2, 39),
(801, 2, 40),
(802, 2, 41),
(803, 2, 42),
(804, 2, 45),
(805, 2, 46),
(806, 2, 47),
(807, 2, 48),
(808, 2, 49),
(809, 2, 50);

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2017_09_09_085518_MenuPermissionMigration', 1),
(2, '2017_09_10_080607_create_menus_table', 1),
(3, '2017_09_13_095759_create_roles_table', 1),
(4, '2017_09_19_030632_create_departments_table', 1),
(5, '2017_09_19_043154_create_designations_table', 1),
(6, '2017_09_19_053209_create_employees_table', 1),
(7, '2017_09_19_060623_create_employee_experiences_table', 1),
(8, '2017_09_19_062907_create_employee_education_qualifications_table', 1),
(9, '2017_09_1_000000_create_users_table', 1),
(10, '2017_09_27_033248_create_branches_table', 1),
(11, '2017_09_2_081056_create_modules_table', 1),
(12, '2017_10_02_042807_create_holidays_table', 1),
(13, '2017_10_04_035502_create_holiday_details_table', 1),
(14, '2017_10_04_050224_create_weekly_holidays_table', 1),
(15, '2017_10_04_050517_create_leave_types_table', 1),
(16, '2017_10_04_093455_create_leave_applications_table', 1),
(17, '2017_10_05_094341_create_SP_weekly_holiday_store_procedure', 1),
(18, '2017_10_05_095235_create_SP_get_holiday_store_procedure', 1),
(19, '2017_10_05_095429_create_SP_get_employee_leave_balance_store_procedure', 1),
(20, '2017_10_09_043228_create_work_shifts_table', 1),
(21, '2017_10_09_074500_create_employee_attendances_table', 1),
(22, '2017_10_09_095518_create_view_get_employee_in_out_data', 1),
(25, '2017_10_11_084031_create_allownce_table', 1),
(26, '2017_10_11_084043_create_deduction_table', 1),
(27, '2017_10_23_051619_create_pay_grades_table', 1),
(28, '2017_10_26_064948_create_tax_rules_table', 1),
(29, '2017_10_29_075627_create_pay_grade_to_allowances_table', 1),
(30, '2017_10_29_075706_create_pay_grade_to_deductions_table', 1),
(31, '2017_10_30_065329_create_SP_get_employee_info_store_procedure', 1),
(32, '2017_11_01_045130_create_salary_deduction_for_late_attendances_table', 1),
(33, '2017_11_02_051338_create_salary_details_table', 1),
(34, '2017_11_02_053649_create_salary_details_to_allowances_table', 1),
(35, '2017_11_02_054000_create_salary_details_to_deductions_table', 1),
(36, '2017_11_07_042136_create_performance_categories_table', 1),
(37, '2017_11_07_042334_create_performance_criterias_table', 1),
(38, '2017_11_08_035959_create_employee_performances_table', 1),
(39, '2017_11_08_040029_create_employee_performance_details_table', 1),
(40, '2017_11_14_061231_create_earn_leave_rules_table', 1),
(41, '2017_11_14_092829_create_company_address_settings_table', 1),
(42, '2017_11_15_090514_create_employee_awards_table', 1),
(43, '2017_11_15_105135_create_notices_table', 1),
(44, '2017_11_23_102429_create_print_head_settings_table', 1),
(45, '2017_12_03_112226_create_training_types_table', 1),
(46, '2017_12_03_112805_create_training_infos_table', 1),
(47, '2017_12_04_114921_create_warnings_table', 1),
(48, '2017_12_04_140839_create_terminations_table', 1),
(49, '2017_12_05_154824_create_promotions_table', 1),
(50, '2017_12_10_122540_create_hourly_salaries_table', 1),
(51, '2017_12_13_144211_create_jobs_table', 1),
(52, '2017_12_13_144259_create_job_applicants_table', 1),
(53, '2017_12_13_144320_create_interviews_table', 1),
(54, '2030_09_17_062133_KeyContstraintsMigration', 1),
(55, '2017_12_31_222850_create_salary_details_to_leaves_table', 2),
(56, '2017_10_11_051354_create_SP_daily_attendance_store_procedure', 3),
(57, '2017_10_11_083952_create_SP_monthly_attendance_store_procedure', 3),
(62, '2018_01_08_144502_create_employee_attendance_approves_table', 4),
(67, '2018_01_10_150238_create_bonus_settings_table', 5),
(68, '2018_01_10_161034_create_employee_bonuses_table', 6);

-- --------------------------------------------------------

--
-- Table structure for table `modules`
--

CREATE TABLE `modules` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon_class` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `modules`
--

INSERT INTO `modules` (`id`, `name`, `icon_class`) VALUES
(1, 'Administration', 'mdi mdi-key-plus'),
(2, 'Employee Management', 'mdi mdi-account-multiple-plus'),
(3, 'Leave Management', 'mdi mdi-exit-to-app'),
(4, 'Attendance', 'mdi mdi-calendar-clock'),
(5, 'Payroll', 'mdi mdi-dolby'),
(6, 'Performance', 'mdi mdi-chart-line'),
(7, 'Recruitment', 'mdi mdi-worker'),
(8, 'Training', 'mdi mdi-certificate'),
(9, 'Award', 'mdi mdi-trophy-variant'),
(10, 'Notice Board', 'mdi mdi-flag-checkered'),
(11, 'Settings', 'mdi mdi-wrench');

-- --------------------------------------------------------

--
-- Table structure for table `notice`
--

CREATE TABLE `notice` (
  `notice_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `publish_date` date NOT NULL,
  `attach_file` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notice`
--

INSERT INTO `notice` (`notice_id`, `title`, `description`, `status`, `created_by`, `updated_by`, `publish_date`, `attach_file`, `created_at`, `updated_at`) VALUES
(1, 'Meeting in upcomming day', 'up coming October 4th 2019 we will do a meeting about lorem sipu dolor simply dummy text&nbsp; <br>', 'Published', 2, 2, '2019-09-12', NULL, '2019-09-12 09:06:25', '2019-09-12 09:06:25');

-- --------------------------------------------------------

--
-- Table structure for table `pay_grade`
--

CREATE TABLE `pay_grade` (
  `pay_grade_id` int(10) UNSIGNED NOT NULL,
  `pay_grade_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gross_salary` int(11) NOT NULL,
  `percentage_of_basic` int(11) NOT NULL,
  `basic_salary` int(11) NOT NULL,
  `overtime_rate` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pay_grade`
--

INSERT INTO `pay_grade` (`pay_grade_id`, `pay_grade_name`, `gross_salary`, `percentage_of_basic`, `basic_salary`, `overtime_rate`, `created_at`, `updated_at`) VALUES
(1, 'A', 100000, 50, 50000, 500, '2018-01-08 05:03:38', '2018-01-08 05:03:38'),
(2, 'B', 80000, 50, 40000, 500, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pay_grade_to_allowance`
--

CREATE TABLE `pay_grade_to_allowance` (
  `pay_grade_to_allowance_id` int(10) UNSIGNED NOT NULL,
  `pay_grade_id` int(11) NOT NULL,
  `allowance_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pay_grade_to_allowance`
--

INSERT INTO `pay_grade_to_allowance` (`pay_grade_to_allowance_id`, `pay_grade_id`, `allowance_id`, `created_at`, `updated_at`) VALUES
(37, 1, 1, '2018-01-04 06:04:01', '2018-01-04 06:04:01'),
(38, 1, 2, '2018-01-04 06:04:01', '2018-01-04 06:04:01'),
(39, 1, 3, '2018-01-04 06:04:01', '2018-01-04 06:04:01');

-- --------------------------------------------------------

--
-- Table structure for table `pay_grade_to_deduction`
--

CREATE TABLE `pay_grade_to_deduction` (
  `pay_grade_to_deduction_id` int(10) UNSIGNED NOT NULL,
  `pay_grade_id` int(11) NOT NULL,
  `deduction_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pay_grade_to_deduction`
--

INSERT INTO `pay_grade_to_deduction` (`pay_grade_to_deduction_id`, `pay_grade_id`, `deduction_id`, `created_at`, `updated_at`) VALUES
(12, 1, 1, '2018-01-04 06:04:01', '2018-01-04 06:04:01');

-- --------------------------------------------------------

--
-- Table structure for table `performance_category`
--

CREATE TABLE `performance_category` (
  `performance_category_id` int(10) UNSIGNED NOT NULL,
  `performance_category_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `performance_category`
--

INSERT INTO `performance_category` (`performance_category_id`, `performance_category_name`, `created_at`, `updated_at`) VALUES
(1, 'Ministration', '2018-01-09 06:55:54', '2018-01-09 06:56:02');

-- --------------------------------------------------------

--
-- Table structure for table `performance_criteria`
--

CREATE TABLE `performance_criteria` (
  `performance_criteria_id` int(10) UNSIGNED NOT NULL,
  `performance_category_id` int(10) UNSIGNED NOT NULL,
  `performance_criteria_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `performance_criteria`
--

INSERT INTO `performance_criteria` (`performance_criteria_id`, `performance_category_id`, `performance_criteria_name`, `created_at`, `updated_at`) VALUES
(1, 1, 'Good relation with teammates', '2018-01-09 06:56:08', '2018-01-09 06:56:08');

-- --------------------------------------------------------

--
-- Table structure for table `print_head_settings`
--

CREATE TABLE `print_head_settings` (
  `print_head_setting_id` int(10) UNSIGNED NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `print_head_settings`
--

INSERT INTO `print_head_settings` (`print_head_setting_id`, `description`, `created_at`, `updated_at`) VALUES
(1, '<b>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Amir Group</b><br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; Adil uddin tower,<br>&nbsp; &nbsp; &nbsp; 104/45,Kakrail, Ramna, Dhaka-1000', '2018-01-01 05:07:22', '2019-09-12 09:11:38');

-- --------------------------------------------------------

--
-- Table structure for table `promotion`
--

CREATE TABLE `promotion` (
  `promotion_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `current_department` int(10) UNSIGNED NOT NULL,
  `current_designation` int(10) UNSIGNED NOT NULL,
  `current_pay_grade` int(11) NOT NULL,
  `current_salary` int(11) NOT NULL,
  `promoted_pay_grade` int(10) UNSIGNED NOT NULL,
  `new_salary` int(11) NOT NULL,
  `promoted_department` int(10) UNSIGNED NOT NULL,
  `promoted_designation` int(10) UNSIGNED NOT NULL,
  `promotion_date` date NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE `role` (
  `role_id` int(10) UNSIGNED NOT NULL,
  `role_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`role_id`, `role_name`, `created_at`, `updated_at`) VALUES
(1, 'Super Admin', '2019-02-12 06:33:06', '2019-02-12 06:34:12'),
(2, 'Admin', '2018-01-10 10:24:59', '2018-01-10 10:24:59'),
(3, 'HR', '2018-01-10 10:24:59', '2018-01-10 10:24:59'),
(4, 'Accounts', '2018-01-10 10:24:59', '2018-01-10 10:24:59'),
(5, 'Developer', '2018-01-10 10:24:59', '2018-01-10 10:24:59'),
(6, 'O Assitant', '2018-12-05 05:42:44', '2018-12-05 05:42:44'),
(7, 'Business Development', '2018-12-17 08:42:19', '2018-12-17 08:42:19'),
(8, 'Manager', '2019-05-04 10:41:57', '2019-05-04 10:41:57'),
(9, 'Manager Role', '2019-09-12 07:02:27', '2019-09-12 07:02:27');

-- --------------------------------------------------------

--
-- Table structure for table `salary_deduction_for_late_attendance`
--

CREATE TABLE `salary_deduction_for_late_attendance` (
  `salary_deduction_for_late_attendance_id` int(10) UNSIGNED NOT NULL,
  `for_days` int(11) NOT NULL,
  `day_of_salary_deduction` int(11) NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `salary_deduction_for_late_attendance`
--

INSERT INTO `salary_deduction_for_late_attendance` (`salary_deduction_for_late_attendance_id`, `for_days`, `day_of_salary_deduction`, `status`, `created_at`, `updated_at`) VALUES
(1, 3, 1, 'Active', '2018-01-10 10:25:00', '2018-01-10 10:25:00');

-- --------------------------------------------------------

--
-- Table structure for table `salary_details`
--

CREATE TABLE `salary_details` (
  `salary_details_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(11) NOT NULL,
  `month_of_salary` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `basic_salary` int(11) NOT NULL DEFAULT '0',
  `total_allowance` int(11) NOT NULL DEFAULT '0',
  `total_deduction` int(11) NOT NULL DEFAULT '0',
  `total_late` int(11) NOT NULL DEFAULT '0',
  `total_late_amount` int(11) NOT NULL DEFAULT '0',
  `total_absence` int(11) NOT NULL DEFAULT '0',
  `total_absence_amount` int(11) NOT NULL DEFAULT '0',
  `overtime_rate` int(11) NOT NULL DEFAULT '0',
  `total_over_time_hour` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '00:00',
  `total_overtime_amount` int(11) NOT NULL DEFAULT '0',
  `hourly_rate` int(11) NOT NULL DEFAULT '0',
  `total_present` int(11) NOT NULL DEFAULT '0',
  `total_leave` int(11) NOT NULL DEFAULT '0',
  `total_working_days` int(11) NOT NULL DEFAULT '0',
  `tax` int(11) NOT NULL DEFAULT '0',
  `gross_salary` int(11) NOT NULL DEFAULT '0',
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `comment` text COLLATE utf8mb4_unicode_ci,
  `payment_method` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `per_day_salary` int(11) NOT NULL DEFAULT '0',
  `taxable_salary` int(11) NOT NULL DEFAULT '0',
  `net_salary` int(11) NOT NULL DEFAULT '0',
  `working_hour` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `salary_details`
--

INSERT INTO `salary_details` (`salary_details_id`, `employee_id`, `month_of_salary`, `basic_salary`, `total_allowance`, `total_deduction`, `total_late`, `total_late_amount`, `total_absence`, `total_absence_amount`, `overtime_rate`, `total_over_time_hour`, `total_overtime_amount`, `hourly_rate`, `total_present`, `total_leave`, `total_working_days`, `tax`, `gross_salary`, `created_by`, `updated_by`, `status`, `comment`, `payment_method`, `action`, `created_at`, `updated_at`, `per_day_salary`, `taxable_salary`, `net_salary`, `working_hour`) VALUES
(1, 2, '2019-02', 67500, 37958, 9106, 1, 2273, 0, 0, 500, '10:55', 5458, 0, 20, 2, 22, 5333, 96352, 2, 2, 1, 'Salary Paid', 'Cash', 'monthlySalary', '2019-09-05 14:53:31', '2019-09-05 14:53:31', 2273, 67500, 100000, '00:00'),
(2, 17, '2019-02', 80000, 9917, 9026, 0, 0, 1, 1818, 500, '19:50', 9917, 0, 21, 0, 22, 7208, 80891, 2, 2, 0, NULL, NULL, 'monthlySalary', '2019-09-12 08:07:47', '2019-09-12 08:07:47', 1818, 80000, 80000, '00:00'),
(3, 21, '2019-06', 67500, 42300, 11833, 0, 0, 2, 5000, 500, '19:36', 9800, 0, 18, 0, 20, 5333, 97967, 2, 2, 0, NULL, NULL, 'monthlySalary', '2019-09-12 08:08:00', '2019-09-12 08:08:00', 2500, 67500, 100000, '00:00'),
(4, 20, '2019-08', 67500, 36783, 11833, 1, 2500, 1, 2500, 500, '8:34', 4283, 0, 19, 0, 20, 5333, 92450, 2, 2, 0, NULL, NULL, 'monthlySalary', '2019-09-12 08:08:35', '2019-09-12 08:08:35', 2500, 67500, 100000, '00:00'),
(5, 17, '2019-06', 80000, 6317, 11208, 1, 2000, 1, 2000, 500, '12:38', 6317, 0, 19, 0, 20, 7208, 75109, 2, 2, 1, 'sdfsdfsd', 'Cash', 'monthlySalary', '2019-09-12 08:10:10', '2019-09-12 08:10:10', 2000, 80000, 80000, '00:00');

-- --------------------------------------------------------

--
-- Table structure for table `salary_details_to_allowance`
--

CREATE TABLE `salary_details_to_allowance` (
  `salary_details_to_allowance_id` int(10) UNSIGNED NOT NULL,
  `salary_details_id` int(11) NOT NULL,
  `allowance_id` int(11) NOT NULL,
  `amount_of_allowance` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `salary_details_to_allowance`
--

INSERT INTO `salary_details_to_allowance` (`salary_details_to_allowance_id`, `salary_details_id`, `allowance_id`, `amount_of_allowance`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 25000, '2019-09-05 14:53:13', '2019-09-05 14:53:13'),
(2, 1, 2, 2500, '2019-09-05 14:53:13', '2019-09-05 14:53:13'),
(3, 1, 3, 5000, '2019-09-05 14:53:13', '2019-09-05 14:53:13'),
(4, 3, 1, 25000, '2019-09-12 08:08:00', '2019-09-12 08:08:00'),
(5, 3, 2, 2500, '2019-09-12 08:08:00', '2019-09-12 08:08:00'),
(6, 3, 3, 5000, '2019-09-12 08:08:00', '2019-09-12 08:08:00'),
(7, 4, 1, 25000, '2019-09-12 08:08:35', '2019-09-12 08:08:35'),
(8, 4, 2, 2500, '2019-09-12 08:08:35', '2019-09-12 08:08:35'),
(9, 4, 3, 5000, '2019-09-12 08:08:35', '2019-09-12 08:08:35');

-- --------------------------------------------------------

--
-- Table structure for table `salary_details_to_deduction`
--

CREATE TABLE `salary_details_to_deduction` (
  `salary_details_to_deduction_id` int(10) UNSIGNED NOT NULL,
  `salary_details_id` int(11) NOT NULL,
  `deduction_id` int(11) NOT NULL,
  `amount_of_deduction` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `salary_details_to_deduction`
--

INSERT INTO `salary_details_to_deduction` (`salary_details_to_deduction_id`, `salary_details_id`, `deduction_id`, `amount_of_deduction`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1500, '2019-09-05 14:53:13', '2019-09-05 14:53:13'),
(2, 3, 1, 1500, '2019-09-12 08:08:00', '2019-09-12 08:08:00'),
(3, 4, 1, 1500, '2019-09-12 08:08:35', '2019-09-12 08:08:35');

-- --------------------------------------------------------

--
-- Table structure for table `salary_details_to_leave`
--

CREATE TABLE `salary_details_to_leave` (
  `salary_details_to_leave_id` int(10) UNSIGNED NOT NULL,
  `salary_details_id` int(11) NOT NULL,
  `leave_type_id` int(11) NOT NULL,
  `num_of_day` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `salary_details_to_leave`
--

INSERT INTO `salary_details_to_leave` (`salary_details_to_leave_id`, `salary_details_id`, `leave_type_id`, `num_of_day`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 1, '2019-09-05 14:53:13', '2019-09-05 14:53:13'),
(2, 1, 2, 1, '2019-09-05 14:53:13', '2019-09-05 14:53:13');

-- --------------------------------------------------------

--
-- Table structure for table `tax_rule`
--

CREATE TABLE `tax_rule` (
  `tax_rule_id` int(10) UNSIGNED NOT NULL,
  `amount` int(11) NOT NULL,
  `percentage_of_tax` int(11) NOT NULL,
  `amount_of_tax` int(11) NOT NULL,
  `gender` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tax_rule`
--

INSERT INTO `tax_rule` (`tax_rule_id`, `amount`, `percentage_of_tax`, `amount_of_tax`, `gender`, `created_at`, `updated_at`) VALUES
(1, 250000, 0, 0, 'Male', '2018-01-10 10:25:00', '2018-01-10 10:25:00'),
(2, 400000, 10, 40000, 'Male', '2018-01-10 10:25:00', '2018-01-10 10:25:00'),
(3, 500000, 15, 75000, 'Male', '2018-01-10 10:25:00', '2018-01-10 10:25:00'),
(4, 600000, 20, 120000, 'Male', '2018-01-10 10:25:00', '2018-01-10 10:25:00'),
(5, 3000000, 25, 750000, 'Male', '2018-01-10 10:25:00', '2018-01-10 10:25:00'),
(6, 0, 30, 0, 'Male', '2018-01-10 10:25:00', '2018-01-10 10:25:00'),
(7, 300000, 0, 0, 'Female', '2018-01-10 10:25:00', '2018-01-10 10:25:00'),
(8, 400000, 10, 40000, 'Female', '2018-01-10 10:25:00', '2018-01-10 10:25:00'),
(9, 500000, 15, 75000, 'Female', '2018-01-10 10:25:00', '2018-01-10 10:25:00'),
(10, 600000, 20, 120000, 'Female', '2018-01-10 10:25:00', '2018-01-10 10:25:00'),
(11, 3000000, 25, 750000, 'Female', '2018-01-10 10:25:00', '2018-01-10 10:25:00'),
(12, 0, 30, 0, 'Female', '2018-01-10 10:25:00', '2018-01-10 10:25:00');

-- --------------------------------------------------------

--
-- Table structure for table `termination`
--

CREATE TABLE `termination` (
  `termination_id` int(10) UNSIGNED NOT NULL,
  `terminate_to` int(10) UNSIGNED NOT NULL,
  `terminate_by` int(10) UNSIGNED NOT NULL,
  `termination_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notice_date` date NOT NULL,
  `termination_date` date NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `training_info`
--

CREATE TABLE `training_info` (
  `training_info_id` int(10) UNSIGNED NOT NULL,
  `training_type_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `subject` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `certificate` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `training_type`
--

CREATE TABLE `training_type` (
  `training_type_id` int(10) UNSIGNED NOT NULL,
  `training_type_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `user_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `role_id`, `user_name`, `password`, `status`, `remember_token`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(2, 1, 'admin', '$2y$10$BLV793kKppgrL0ap783efeYQaRTLoQkslnAZt7QzpKUhgMhWir0Yi', 1, 'Any4loi2WnVWpJrGKB7AnJC8gWh7aNfSnrjsjHUe6SFkzMLvmET3CXq2uknr', 23, 23, '2017-12-20 06:24:19', '2019-09-12 09:03:07'),
(16, 7, 'employee', '$2y$10$BLV793kKppgrL0ap783efeYQaRTLoQkslnAZt7QzpKUhgMhWir0Yi', 1, 'wmV51I8Pp0iSdL5jlJet2eubkF4VKIvPaS4zNZF1IWWLBHaUKNMIEIyZnaKb', 16, 16, '2017-12-20 07:46:26', '2019-05-04 10:38:48'),
(17, 8, 'shuvro.sen', '$2y$10$DEPpN.k9Rs0uxsFBhATUfOg6GHDQsaj3Gae6OLk1jF5CAJUYapv4u', 1, 'EDdYzI6am0hxgNNIZICt6liUo69hcQZnzfjOtdDk2yzWO9MPt1YxwoqQICeC', 2, 2, '2017-12-20 07:48:53', '2019-05-04 10:44:06'),
(18, 2, 'Towhid-AGM', '$2y$10$46RrPbD6GZxpTqwKCtbPHOTGyOINTurSUFQhtPOZRubkfIxq9vnKS', 2, 'fdoBXFZJaVLKH554o2dvBSzbg47K5atLVJIhc3fYA0QwFojwInyb44NbJnL7', 2, 2, '2017-12-20 07:52:40', '2019-09-03 15:00:58'),
(20, 2, 'Md Younus', '$2y$10$lxK.FDN7hDG3Gfj/yfh07eShHZxLNH.eSUyQXTWcpZa0NxPQ4YbPS', 1, '4sevE0qpdtedtSMJtjzNb3425UAxt1zz0Yir8gp3qMbvUf3pyq7FmoOcwrXz', 20, 20, '2017-12-20 08:15:02', '2019-05-04 10:47:38'),
(21, 2, 'sm.monir', '$2y$10$durNA92M8NpNz1nXd7FkxeYDfh3mgOzb1e6jMLa9zaY0.dVRoCCIi', 1, 'XekfeEYncxNJF5VigpWxE5SteR7Tm5iVT9T3CCG4wmTjX31ZXuMAQhWdcSNV', 2, 2, '2017-12-20 08:17:17', '2018-12-17 08:33:28'),
(22, 1, 'rajib', '$2y$10$BLV793kKppgrL0ap783efeYQaRTLoQkslnAZt7QzpKUhgMhWir0Yi', 1, 'Io1idV37EofA5hJgQvrwVXQbNmkOmCKcsXtpmuvzh7Ia3XfU5AAGyh4uHhbv', 2, 2, '2017-12-20 08:19:24', '2019-09-12 08:36:39'),
(23, 1, 'mousumi3', '$2y$10$U7BydMw5oOcMoUujgMwckO7R067oeu8wkIVZD8npkHmv.v8qa8SOq', 1, 'yf2dG9sZZgRCMJN4oV9hr4cxz1GSBv7mA17UvFksXHu1b53ehoTQWvHPp85w', 23, 23, '2017-12-20 08:21:08', '2019-09-12 09:04:08'),
(24, 1, 'tushar.realist', '$2y$10$DWYHXQMUCJuENz5jr6bg9eBp4BaRywhwPPo.smJ8dLW.d7Dxhnswy', 1, 'LoMwMzc6yEL7ojQF1OxcmpVvlLqhrcpiJn3dSUXrwHphbQuQnbz0LF2jLII8', 2, 2, '2017-12-20 08:22:44', '2019-02-06 07:24:57'),
(26, 4, 'polash', '$2y$10$iv8.CUdYBQTTmx.plPK6b.xi8hxVpkXexWNA1XU5ye4M6JDjoBAY6', 1, 'zgHVsdZRYxLNlyPMnfRKDZXA32g7QF25s3DTPgXCmvBDeEfsbl5a5qhEz5gJ', 2, 2, '2018-01-03 06:55:17', '2019-02-06 07:24:24'),
(28, 6, 'raihan', '$2y$10$67Q6aL9hZbaXIoN4x7j.8uy0Ubrrt3p27.ZvLge9eLYBB4Y5L5ZfG', 1, 'OHVtfRqJ5LBGDBHfdFjeyqRmAVthxNQU4HkVf8ItngxACEXfZruSoyHrYMFc', 2, 2, '2018-12-05 11:23:11', '2019-02-06 07:23:29'),
(29, 1, 'jahirul', '$2y$10$qTdy7x8JLKZGFQoidijbyuBFVGgdXUWoXqjE924UN9WPnpMVK6IXu', 1, 'JKcLOBTl6gmlshvmsQcG6YnKa4igDYyB5adNyz5qB75haqDcHg4RorSzRJwt', 2, 2, '2018-12-17 07:53:35', '2019-02-13 06:27:47'),
(30, 2, 'tanvir.sohel', '$2y$10$NHSCxsz.Q8ajpd2Qbyd7gOAIzD/3jjmWvjt0iaBFD1NnE5b1ekM0m', 1, NULL, 2, 2, '2019-02-13 06:26:42', '2019-02-13 06:26:42'),
(31, 4, 'MD Junaed Hussain', '$2y$10$70vkE/3LpVtz3i2MOxT7I.O9iRqMp66JBbeFI.oWkJrqAvuYTcAz2', 2, NULL, 2, 2, '2019-05-02 06:17:26', '2019-08-28 04:00:29'),
(32, 4, 'mohsin', '$2y$10$JLlnTZ/XNPzLY3HkF7H1dei2AjP3BrWfZ0KeyT32XIQlq/OSUhRY.', 1, NULL, 2, 2, '2019-08-28 03:59:33', '2019-08-28 03:59:33'),
(33, 1, 'saifur.rahman', '$2y$10$.YPPtIojnoK50wG7.QCXpeJ/Y4LORL/drw06uW0Opn7aLPutl02Ny', 1, NULL, 2, 2, '2019-09-05 21:00:24', '2019-09-12 06:50:04');

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_employee_in_out_data`
-- (See below for the actual view)
--
CREATE TABLE `view_employee_in_out_data` (
`employee_attendance_id` int(10) unsigned
,`finger_print_id` int(11)
,`in_time` datetime
,`out_time` varchar(19)
,`date` varchar(10)
,`working_time` time
);

-- --------------------------------------------------------

--
-- Table structure for table `warning`
--

CREATE TABLE `warning` (
  `warning_id` int(10) UNSIGNED NOT NULL,
  `warning_to` int(10) UNSIGNED NOT NULL,
  `warning_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `warning_by` int(10) UNSIGNED NOT NULL,
  `warning_date` date NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `warning`
--

INSERT INTO `warning` (`warning_id`, `warning_to`, `warning_type`, `subject`, `warning_by`, `warning_date`, `description`, `created_at`, `updated_at`) VALUES
(1, 16, 'Mistiming', 'You have been worned for mistiming', 2, '2019-09-12', 'lorem ispum dolor suit imor simply dummy text<br>', '2019-09-12 08:18:11', '2019-09-12 08:20:26'),
(2, 20, 'Mind your behaviour', 'Problem in behaviour', 2, '2019-09-12', 'lorem <br>', '2019-09-12 08:21:28', '2019-09-12 08:25:17');

-- --------------------------------------------------------

--
-- Table structure for table `weekly_holiday`
--

CREATE TABLE `weekly_holiday` (
  `week_holiday_id` int(10) UNSIGNED NOT NULL,
  `day_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `weekly_holiday`
--

INSERT INTO `weekly_holiday` (`week_holiday_id`, `day_name`, `status`, `created_at`, `updated_at`) VALUES
(2, 'Friday', 1, '2017-12-28 06:14:33', '2017-12-28 06:14:33');

-- --------------------------------------------------------

--
-- Table structure for table `work_shift`
--

CREATE TABLE `work_shift` (
  `work_shift_id` int(10) UNSIGNED NOT NULL,
  `shift_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `late_count_time` time NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `work_shift`
--

INSERT INTO `work_shift` (`work_shift_id`, `shift_name`, `start_time`, `end_time`, `late_count_time`, `created_at`, `updated_at`) VALUES
(1, 'Day', '10:00:00', '18:00:00', '10:15:00', '2018-01-08 05:03:38', '2018-12-05 06:17:02'),
(2, 'Night', '20:00:00', '05:00:00', '20:15:00', '2019-09-12 06:29:20', '2019-09-12 06:29:20');

-- --------------------------------------------------------

--
-- Structure for view `view_employee_in_out_data`
--
DROP TABLE IF EXISTS `view_employee_in_out_data`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_employee_in_out_data`  AS  select `employee_attendance`.`employee_attendance_id` AS `employee_attendance_id`,`employee_attendance`.`finger_print_id` AS `finger_print_id`,min(`employee_attendance`.`in_out_time`) AS `in_time`,if((count(`employee_attendance`.`in_out_time`) > 1),max(`employee_attendance`.`in_out_time`),'') AS `out_time`,date_format(`employee_attendance`.`in_out_time`,'%Y-%m-%d') AS `date`,timediff(max(`employee_attendance`.`in_out_time`),min(`employee_attendance`.`in_out_time`)) AS `working_time` from `employee_attendance` group by date_format(`employee_attendance`.`in_out_time`,'%Y-%m-%d'),`employee_attendance`.`finger_print_id` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `allowance`
--
ALTER TABLE `allowance`
  ADD PRIMARY KEY (`allowance_id`);

--
-- Indexes for table `bonus_setting`
--
ALTER TABLE `bonus_setting`
  ADD PRIMARY KEY (`bonus_setting_id`);

--
-- Indexes for table `branch`
--
ALTER TABLE `branch`
  ADD PRIMARY KEY (`branch_id`),
  ADD UNIQUE KEY `branch_branch_name_unique` (`branch_name`);

--
-- Indexes for table `company_address_settings`
--
ALTER TABLE `company_address_settings`
  ADD PRIMARY KEY (`company_address_setting_id`);

--
-- Indexes for table `deduction`
--
ALTER TABLE `deduction`
  ADD PRIMARY KEY (`deduction_id`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`department_id`),
  ADD UNIQUE KEY `department_department_name_unique` (`department_name`);

--
-- Indexes for table `designation`
--
ALTER TABLE `designation`
  ADD PRIMARY KEY (`designation_id`),
  ADD UNIQUE KEY `designation_designation_name_unique` (`designation_name`);

--
-- Indexes for table `earn_leave_rule`
--
ALTER TABLE `earn_leave_rule`
  ADD PRIMARY KEY (`earn_leave_rule_id`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`employee_id`),
  ADD UNIQUE KEY `employee_finger_id_unique` (`finger_id`),
  ADD UNIQUE KEY `employee_email_unique` (`email`);

--
-- Indexes for table `employee_attendance`
--
ALTER TABLE `employee_attendance`
  ADD PRIMARY KEY (`employee_attendance_id`);

--
-- Indexes for table `employee_attendance_approve`
--
ALTER TABLE `employee_attendance_approve`
  ADD PRIMARY KEY (`employee_attendance_approve_id`);

--
-- Indexes for table `employee_award`
--
ALTER TABLE `employee_award`
  ADD PRIMARY KEY (`employee_award_id`);

--
-- Indexes for table `employee_bonus`
--
ALTER TABLE `employee_bonus`
  ADD PRIMARY KEY (`employee_bonus_id`);

--
-- Indexes for table `employee_education_qualification`
--
ALTER TABLE `employee_education_qualification`
  ADD PRIMARY KEY (`employee_education_qualification_id`);

--
-- Indexes for table `employee_experience`
--
ALTER TABLE `employee_experience`
  ADD PRIMARY KEY (`employee_experience_id`);

--
-- Indexes for table `employee_performance`
--
ALTER TABLE `employee_performance`
  ADD PRIMARY KEY (`employee_performance_id`);

--
-- Indexes for table `employee_performance_details`
--
ALTER TABLE `employee_performance_details`
  ADD PRIMARY KEY (`employee_performance_details_id`);

--
-- Indexes for table `holiday`
--
ALTER TABLE `holiday`
  ADD PRIMARY KEY (`holiday_id`),
  ADD UNIQUE KEY `holiday_holiday_name_unique` (`holiday_name`);

--
-- Indexes for table `holiday_details`
--
ALTER TABLE `holiday_details`
  ADD PRIMARY KEY (`holiday_details_id`);

--
-- Indexes for table `hourly_salaries`
--
ALTER TABLE `hourly_salaries`
  ADD PRIMARY KEY (`hourly_salaries_id`);

--
-- Indexes for table `interview`
--
ALTER TABLE `interview`
  ADD PRIMARY KEY (`interview_id`);

--
-- Indexes for table `job`
--
ALTER TABLE `job`
  ADD PRIMARY KEY (`job_id`);

--
-- Indexes for table `job_applicant`
--
ALTER TABLE `job_applicant`
  ADD PRIMARY KEY (`job_applicant_id`);

--
-- Indexes for table `leave_application`
--
ALTER TABLE `leave_application`
  ADD PRIMARY KEY (`leave_application_id`);

--
-- Indexes for table `leave_type`
--
ALTER TABLE `leave_type`
  ADD PRIMARY KEY (`leave_type_id`),
  ADD UNIQUE KEY `leave_type_leave_type_name_unique` (`leave_type_name`);

--
-- Indexes for table `menus`
--
ALTER TABLE `menus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `menu_permission`
--
ALTER TABLE `menu_permission`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notice`
--
ALTER TABLE `notice`
  ADD PRIMARY KEY (`notice_id`);

--
-- Indexes for table `pay_grade`
--
ALTER TABLE `pay_grade`
  ADD PRIMARY KEY (`pay_grade_id`),
  ADD UNIQUE KEY `pay_grade_pay_grade_name_unique` (`pay_grade_name`);

--
-- Indexes for table `pay_grade_to_allowance`
--
ALTER TABLE `pay_grade_to_allowance`
  ADD PRIMARY KEY (`pay_grade_to_allowance_id`);

--
-- Indexes for table `pay_grade_to_deduction`
--
ALTER TABLE `pay_grade_to_deduction`
  ADD PRIMARY KEY (`pay_grade_to_deduction_id`);

--
-- Indexes for table `performance_category`
--
ALTER TABLE `performance_category`
  ADD PRIMARY KEY (`performance_category_id`),
  ADD UNIQUE KEY `performance_category_performance_category_name_unique` (`performance_category_name`);

--
-- Indexes for table `performance_criteria`
--
ALTER TABLE `performance_criteria`
  ADD PRIMARY KEY (`performance_criteria_id`);

--
-- Indexes for table `print_head_settings`
--
ALTER TABLE `print_head_settings`
  ADD PRIMARY KEY (`print_head_setting_id`);

--
-- Indexes for table `promotion`
--
ALTER TABLE `promotion`
  ADD PRIMARY KEY (`promotion_id`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `role_role_name_unique` (`role_name`);

--
-- Indexes for table `salary_deduction_for_late_attendance`
--
ALTER TABLE `salary_deduction_for_late_attendance`
  ADD PRIMARY KEY (`salary_deduction_for_late_attendance_id`);

--
-- Indexes for table `salary_details`
--
ALTER TABLE `salary_details`
  ADD PRIMARY KEY (`salary_details_id`);

--
-- Indexes for table `salary_details_to_allowance`
--
ALTER TABLE `salary_details_to_allowance`
  ADD PRIMARY KEY (`salary_details_to_allowance_id`);

--
-- Indexes for table `salary_details_to_deduction`
--
ALTER TABLE `salary_details_to_deduction`
  ADD PRIMARY KEY (`salary_details_to_deduction_id`);

--
-- Indexes for table `salary_details_to_leave`
--
ALTER TABLE `salary_details_to_leave`
  ADD PRIMARY KEY (`salary_details_to_leave_id`);

--
-- Indexes for table `tax_rule`
--
ALTER TABLE `tax_rule`
  ADD PRIMARY KEY (`tax_rule_id`);

--
-- Indexes for table `termination`
--
ALTER TABLE `termination`
  ADD PRIMARY KEY (`termination_id`);

--
-- Indexes for table `training_info`
--
ALTER TABLE `training_info`
  ADD PRIMARY KEY (`training_info_id`);

--
-- Indexes for table `training_type`
--
ALTER TABLE `training_type`
  ADD PRIMARY KEY (`training_type_id`),
  ADD UNIQUE KEY `training_type_training_type_name_unique` (`training_type_name`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_user_name_unique` (`user_name`);

--
-- Indexes for table `warning`
--
ALTER TABLE `warning`
  ADD PRIMARY KEY (`warning_id`);

--
-- Indexes for table `weekly_holiday`
--
ALTER TABLE `weekly_holiday`
  ADD PRIMARY KEY (`week_holiday_id`),
  ADD UNIQUE KEY `weekly_holiday_day_name_unique` (`day_name`);

--
-- Indexes for table `work_shift`
--
ALTER TABLE `work_shift`
  ADD PRIMARY KEY (`work_shift_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `allowance`
--
ALTER TABLE `allowance`
  MODIFY `allowance_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `bonus_setting`
--
ALTER TABLE `bonus_setting`
  MODIFY `bonus_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `branch`
--
ALTER TABLE `branch`
  MODIFY `branch_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `company_address_settings`
--
ALTER TABLE `company_address_settings`
  MODIFY `company_address_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `deduction`
--
ALTER TABLE `deduction`
  MODIFY `deduction_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `department_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `designation`
--
ALTER TABLE `designation`
  MODIFY `designation_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `earn_leave_rule`
--
ALTER TABLE `earn_leave_rule`
  MODIFY `earn_leave_rule_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `employee_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `employee_attendance`
--
ALTER TABLE `employee_attendance`
  MODIFY `employee_attendance_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6829;

--
-- AUTO_INCREMENT for table `employee_attendance_approve`
--
ALTER TABLE `employee_attendance_approve`
  MODIFY `employee_attendance_approve_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `employee_award`
--
ALTER TABLE `employee_award`
  MODIFY `employee_award_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employee_bonus`
--
ALTER TABLE `employee_bonus`
  MODIFY `employee_bonus_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employee_education_qualification`
--
ALTER TABLE `employee_education_qualification`
  MODIFY `employee_education_qualification_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `employee_experience`
--
ALTER TABLE `employee_experience`
  MODIFY `employee_experience_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employee_performance`
--
ALTER TABLE `employee_performance`
  MODIFY `employee_performance_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `employee_performance_details`
--
ALTER TABLE `employee_performance_details`
  MODIFY `employee_performance_details_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `holiday`
--
ALTER TABLE `holiday`
  MODIFY `holiday_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `holiday_details`
--
ALTER TABLE `holiday_details`
  MODIFY `holiday_details_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `hourly_salaries`
--
ALTER TABLE `hourly_salaries`
  MODIFY `hourly_salaries_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `interview`
--
ALTER TABLE `interview`
  MODIFY `interview_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `job`
--
ALTER TABLE `job`
  MODIFY `job_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `job_applicant`
--
ALTER TABLE `job_applicant`
  MODIFY `job_applicant_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leave_application`
--
ALTER TABLE `leave_application`
  MODIFY `leave_application_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `leave_type`
--
ALTER TABLE `leave_type`
  MODIFY `leave_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `menus`
--
ALTER TABLE `menus`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `menu_permission`
--
ALTER TABLE `menu_permission`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=810;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `modules`
--
ALTER TABLE `modules`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `notice`
--
ALTER TABLE `notice`
  MODIFY `notice_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `pay_grade`
--
ALTER TABLE `pay_grade`
  MODIFY `pay_grade_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `pay_grade_to_allowance`
--
ALTER TABLE `pay_grade_to_allowance`
  MODIFY `pay_grade_to_allowance_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `pay_grade_to_deduction`
--
ALTER TABLE `pay_grade_to_deduction`
  MODIFY `pay_grade_to_deduction_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `performance_category`
--
ALTER TABLE `performance_category`
  MODIFY `performance_category_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `performance_criteria`
--
ALTER TABLE `performance_criteria`
  MODIFY `performance_criteria_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `print_head_settings`
--
ALTER TABLE `print_head_settings`
  MODIFY `print_head_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `promotion`
--
ALTER TABLE `promotion`
  MODIFY `promotion_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `role`
--
ALTER TABLE `role`
  MODIFY `role_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `salary_deduction_for_late_attendance`
--
ALTER TABLE `salary_deduction_for_late_attendance`
  MODIFY `salary_deduction_for_late_attendance_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `salary_details`
--
ALTER TABLE `salary_details`
  MODIFY `salary_details_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `salary_details_to_allowance`
--
ALTER TABLE `salary_details_to_allowance`
  MODIFY `salary_details_to_allowance_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `salary_details_to_deduction`
--
ALTER TABLE `salary_details_to_deduction`
  MODIFY `salary_details_to_deduction_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `salary_details_to_leave`
--
ALTER TABLE `salary_details_to_leave`
  MODIFY `salary_details_to_leave_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tax_rule`
--
ALTER TABLE `tax_rule`
  MODIFY `tax_rule_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `termination`
--
ALTER TABLE `termination`
  MODIFY `termination_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `training_info`
--
ALTER TABLE `training_info`
  MODIFY `training_info_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `training_type`
--
ALTER TABLE `training_type`
  MODIFY `training_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `warning`
--
ALTER TABLE `warning`
  MODIFY `warning_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `weekly_holiday`
--
ALTER TABLE `weekly_holiday`
  MODIFY `week_holiday_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `work_shift`
--
ALTER TABLE `work_shift`
  MODIFY `work_shift_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
