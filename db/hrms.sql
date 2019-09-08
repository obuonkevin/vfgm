/*
SQLyog Enterprise v12.09 (64 bit)
MySQL - 10.1.26-MariaDB : Database - hrms
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`hrms` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `hrms`;

/*Table structure for table `allowance` */

DROP TABLE IF EXISTS `allowance`;

CREATE TABLE `allowance` (
  `allowance_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `allowance_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `allowance_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `percentage_of_basic` int(11) NOT NULL,
  `limit_per_month` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`allowance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `allowance` */

insert  into `allowance`(`allowance_id`,`allowance_name`,`allowance_type`,`percentage_of_basic`,`limit_per_month`,`created_at`,`updated_at`) values (1,'House Rent','Percentage',50,25000,'2017-12-26 15:07:43','2017-12-26 15:07:43'),(2,'Convince','Fixed',0,2500,'2017-12-26 15:08:48','2017-12-26 15:08:48'),(3,'Medical Allowance','Percentage',10,10000,'2017-12-26 15:10:38','2017-12-26 15:10:38');

/*Table structure for table `bonus_setting` */

DROP TABLE IF EXISTS `bonus_setting`;

CREATE TABLE `bonus_setting` (
  `bonus_setting_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `festival_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `percentage_of_bonus` int(11) NOT NULL,
  `bonus_type` enum('Gross','Basic') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`bonus_setting_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `bonus_setting` */

insert  into `bonus_setting`(`bonus_setting_id`,`festival_name`,`percentage_of_bonus`,`bonus_type`,`created_at`,`updated_at`) values (3,'Eid ul Fitr',100,'Basic','2018-01-14 14:45:00','2018-01-14 14:45:00'),(4,'Eid ul adhz',100,'Basic','2018-01-14 14:45:19','2018-01-14 14:45:19');

/*Table structure for table `branch` */

DROP TABLE IF EXISTS `branch`;

CREATE TABLE `branch` (
  `branch_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `branch_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`branch_id`),
  UNIQUE KEY `branch_branch_name_unique` (`branch_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `branch` */

insert  into `branch`(`branch_id`,`branch_name`,`created_at`,`updated_at`) values (2,'Dhaka Branch','2017-12-19 11:10:19','2017-12-19 11:10:19'),(4,'Chittagong Branch','2018-01-03 13:22:10','2018-01-03 13:22:10');

/*Table structure for table `company_address_settings` */

DROP TABLE IF EXISTS `company_address_settings`;

CREATE TABLE `company_address_settings` (
  `company_address_setting_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`company_address_setting_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `company_address_settings` */

insert  into `company_address_settings`(`company_address_setting_id`,`address`,`created_at`,`updated_at`) values (1,'<div><b>NextDot</b><br>Sumona Gani Trade Center, Plot-2<br>Level 8. Panthapath, Dhaka 1215, Bangladesh.</div><div><a target=\"_blank\" rel=\"nofollow\">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</a></div>','2017-12-26 16:39:05','2017-12-26 16:39:05');

/*Table structure for table `deduction` */

DROP TABLE IF EXISTS `deduction`;

CREATE TABLE `deduction` (
  `deduction_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `deduction_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deduction_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `percentage_of_basic` int(11) NOT NULL,
  `limit_per_month` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`deduction_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `deduction` */

insert  into `deduction`(`deduction_id`,`deduction_name`,`deduction_type`,`percentage_of_basic`,`limit_per_month`,`created_at`,`updated_at`) values (1,'Provident Fund','Percentage',3,0,'2017-12-26 15:15:56','2018-01-03 16:40:26');

/*Table structure for table `department` */

DROP TABLE IF EXISTS `department`;

CREATE TABLE `department` (
  `department_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `department_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `department_department_name_unique` (`department_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `department` */

insert  into `department`(`department_id`,`department_name`,`created_at`,`updated_at`) values (2,'Management','2017-12-19 11:10:20','2017-12-19 11:10:20'),(6,'IT','2017-12-20 12:46:19','2017-12-20 12:46:19'),(7,'Accounts','2017-12-26 12:29:06','2017-12-26 12:29:06'),(8,'Human Resource','2018-01-03 12:48:14','2018-01-03 12:48:14'),(9,'Digital Marketing','2018-01-14 16:43:01','2018-01-14 16:43:01');

/*Table structure for table `designation` */

DROP TABLE IF EXISTS `designation`;

CREATE TABLE `designation` (
  `designation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `designation_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`designation_id`),
  UNIQUE KEY `designation_designation_name_unique` (`designation_name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `designation` */

insert  into `designation`(`designation_id`,`designation_name`,`created_at`,`updated_at`) values (1,'CEO','2017-12-19 11:10:20','2017-12-20 12:54:58'),(2,'Admin Manager','2017-12-19 11:10:20','2017-12-20 12:56:53'),(3,'Sales & Marketing','2017-12-19 11:10:20','2017-12-20 13:00:18'),(4,'Web Developer','2017-12-19 11:10:20','2017-12-20 13:00:33'),(5,'IOS Developer','2017-12-19 11:10:20','2017-12-20 13:00:55'),(6,'Android Developer','2017-12-20 13:01:52','2017-12-20 13:01:52'),(7,'Designer','2017-12-20 13:02:21','2017-12-20 13:02:21'),(8,'Office Assistant','2017-12-20 13:02:59','2017-12-20 13:02:59'),(9,'Driver','2017-12-20 13:03:21','2017-12-20 13:03:21'),(11,'Sr. Executive','2018-01-03 12:52:03','2018-01-03 13:12:15'),(12,'Jr. Executive','2018-01-03 13:11:15','2018-01-03 13:11:15'),(15,'Business Development Executive','2018-01-03 13:16:49','2018-01-03 13:16:49'),(16,'General Manager','2018-01-03 13:18:54','2018-01-03 13:18:54'),(17,'Deputy General Manager','2018-01-03 13:21:13','2018-01-03 13:21:13');

/*Table structure for table `earn_leave_rule` */

DROP TABLE IF EXISTS `earn_leave_rule`;

CREATE TABLE `earn_leave_rule` (
  `earn_leave_rule_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `for_month` int(11) NOT NULL,
  `day_of_earn_leave` double(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`earn_leave_rule_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `earn_leave_rule` */

insert  into `earn_leave_rule`(`earn_leave_rule_id`,`for_month`,`day_of_earn_leave`,`created_at`,`updated_at`) values (1,1,1.50,'2017-12-19 11:10:24','2017-12-26 13:05:09');

/*Table structure for table `employee` */

DROP TABLE IF EXISTS `employee`;

CREATE TABLE `employee` (
  `employee_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `finger_id` int(11) NOT NULL,
  `department_id` int(10) unsigned NOT NULL,
  `designation_id` int(10) unsigned NOT NULL,
  `branch_id` int(10) unsigned DEFAULT NULL,
  `supervisor_id` int(11) DEFAULT NULL,
  `work_shift_id` int(10) unsigned NOT NULL,
  `pay_grade_id` int(10) unsigned NOT NULL DEFAULT '0',
  `hourly_salaries_id` int(10) unsigned DEFAULT '0',
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
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `employee_finger_id_unique` (`finger_id`),
  UNIQUE KEY `employee_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `employee` */

insert  into `employee`(`employee_id`,`user_id`,`finger_id`,`department_id`,`designation_id`,`branch_id`,`supervisor_id`,`work_shift_id`,`pay_grade_id`,`hourly_salaries_id`,`email`,`first_name`,`last_name`,`date_of_birth`,`date_of_joining`,`date_of_leaving`,`gender`,`religion`,`marital_status`,`photo`,`address`,`emergency_contacts`,`phone`,`status`,`permanent_status`,`created_by`,`updated_by`,`created_at`,`updated_at`) values (1,1,878,6,4,2,3,1,1,NULL,NULL,'Iqbal',NULL,'1995-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1924278435,1,1,2,2,'2017-12-19 11:10:20','2018-01-14 15:06:57'),(2,2,884,6,4,2,1,1,0,1,'kamrultouhids@gmail.com','kamrul','Islam Touhid','1995-10-21','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1832518180,1,0,2,2,'2017-12-20 12:24:19','2018-01-14 15:12:30'),(3,3,838,6,1,2,3,1,1,NULL,NULL,'Ayon','Rahman','1994-06-14','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1781912626,1,0,1,1,'2017-12-20 13:07:12','2017-12-20 14:26:58'),(4,4,808,2,2,2,3,1,1,NULL,NULL,'Sabbir','Rashid','2017-09-14','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1919128825,1,0,1,1,'2017-12-20 13:11:50','2017-12-20 13:11:50'),(5,5,814,2,2,2,3,1,1,NULL,NULL,'Md','Ferdous Alam','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1670922066,1,0,1,1,'2017-12-20 13:17:09','2017-12-20 13:17:09'),(6,6,825,6,3,2,3,1,1,NULL,NULL,'Moniruzzaman','Manik','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1717576872,1,0,1,1,'2017-12-20 13:20:16','2017-12-20 13:20:16'),(7,7,821,6,4,2,3,1,1,NULL,NULL,'Mahbubur','Rahman','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1738246580,1,0,1,1,'2017-12-20 13:22:37','2017-12-20 13:22:37'),(8,8,833,6,4,2,3,1,1,NULL,NULL,'Maruful','Haque','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1670321449,1,0,1,1,'2017-12-20 13:24:56','2017-12-20 15:10:41'),(9,9,886,6,5,2,3,1,1,NULL,NULL,'Nazmul','Hasan','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1924362749,1,0,1,1,'2017-12-20 13:26:40','2017-12-20 13:26:40'),(10,10,857,6,4,2,3,1,1,NULL,NULL,'Saad','Khan','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1710576658,1,0,1,1,'2017-12-20 13:28:05','2017-12-20 13:28:05'),(11,11,866,6,4,2,3,1,1,NULL,NULL,'Anjan','Biswas','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1944239678,1,0,1,1,'2017-12-20 13:29:53','2017-12-20 13:29:53'),(12,12,827,6,6,2,NULL,1,1,NULL,NULL,'Imtiaz','Kalam','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1729000914,1,0,1,1,'2017-12-20 13:33:21','2017-12-20 13:33:21'),(13,13,877,6,4,2,3,1,1,NULL,NULL,'Imtiaz','Zahid','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1686407947,1,0,1,1,'2017-12-20 13:36:43','2017-12-20 13:36:43'),(14,14,858,6,2,2,3,1,1,NULL,NULL,'Imtiaz','Dipto','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1681170028,1,0,1,1,'2017-12-20 13:40:40','2017-12-20 13:41:05'),(15,15,810,2,8,2,3,1,1,NULL,'sumon@nextdot.com.au','Sumon','Sheikh','2000-01-01','2015-10-01',NULL,'Male','Islam',NULL,NULL,NULL,'01871011909',1934721103,1,0,22,22,'2017-12-20 13:43:18','2018-01-15 11:27:14'),(16,16,835,6,8,2,3,1,1,NULL,NULL,'Nihad','Sharker','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1639128940,1,0,1,1,'2017-12-20 13:46:26','2017-12-20 13:46:26'),(17,17,828,6,7,2,3,1,2,NULL,NULL,'Sohel','Chowdhury','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1677605966,1,0,2,2,'2017-12-20 13:48:53','2018-01-03 13:26:46'),(18,18,875,6,6,2,3,1,1,NULL,NULL,'Md','Shadikul Bari','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1743813242,1,0,1,1,'2017-12-20 13:52:40','2017-12-20 15:09:32'),(20,20,885,6,7,2,3,1,1,NULL,NULL,'Shamiur','Rahman Shawon','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1731130002,1,0,1,1,'2017-12-20 14:15:02','2017-12-20 14:15:02'),(21,21,889,6,4,2,3,1,1,NULL,NULL,'Himadree','Shekhar Halder','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1617715214,1,0,1,1,'2017-12-20 14:17:17','2017-12-20 14:17:17'),(22,22,887,6,9,2,3,1,1,NULL,NULL,'Rajib','Hossain','2000-01-01','2017-01-01',NULL,'Male',NULL,NULL,NULL,NULL,NULL,1797185743,1,0,1,1,'2017-12-20 14:19:24','2017-12-20 14:19:24'),(23,23,846,6,3,2,3,1,1,NULL,NULL,'Rabita','Shadin','2000-01-01','2017-01-01',NULL,'Female',NULL,NULL,NULL,NULL,NULL,1789479759,1,0,22,22,'2017-12-20 14:21:08','2018-01-14 16:42:22'),(24,24,848,6,3,2,3,1,1,NULL,NULL,'Nabila','Nasir','2000-01-01','2017-01-01',NULL,'Female',NULL,NULL,NULL,NULL,NULL,1621399791,1,0,1,1,'2017-12-20 14:22:44','2017-12-20 14:22:44'),(25,25,444,6,4,2,4,1,2,NULL,'fffff@gmai.com','t','s','2017-12-26','2017-12-26',NULL,'Female',NULL,NULL,'ebbc47807ab2d0d2cda2c95e53aef56f.jpg',NULL,NULL,1478523693,3,0,2,2,'2017-12-26 12:48:37','2018-01-03 13:26:03'),(26,26,888,6,15,2,22,1,2,NULL,'888@gmail.com','M','T','2018-01-24','2018-01-02',NULL,'Male','Islam','Unmarried',NULL,'Mirpur-1','01234567890',1234567890,1,0,22,22,'2018-01-03 12:55:17','2018-01-03 14:42:17'),(27,27,999,7,12,2,26,1,3,NULL,'gt@gmail.com','G','T','1993-08-05','2017-01-03',NULL,'Male','Islam','Unmarried',NULL,'Mirpur','01234567890',1234567885,1,0,22,22,'2018-01-07 09:23:30','2018-01-07 11:53:44');

/*Table structure for table `employee_attendance` */

DROP TABLE IF EXISTS `employee_attendance`;

CREATE TABLE `employee_attendance` (
  `employee_attendance_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`employee_attendance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41390 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `employee_attendance` */

insert  into `employee_attendance`(`employee_attendance_id`,`finger_print_id`,`in_out_time`,`check_type`,`verify_code`,`sensor_id`,`Memoinfo`,`WorkCode`,`sn`,`UserExtFmt`,`mechine_sl`,`created_at`,`updated_at`) values (41341,808,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:20','2018-01-15 11:35:20'),(41342,814,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:20','2018-01-15 11:35:20'),(41343,810,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:20','2018-01-15 11:35:20'),(41344,878,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41345,884,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41346,838,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41347,825,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41348,821,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41349,833,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41350,886,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41351,857,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41352,866,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41353,827,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41354,877,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41355,858,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41356,835,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41357,828,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41358,875,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41359,885,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41360,889,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41361,887,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41362,846,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41363,848,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41364,888,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:41','2018-01-15 11:35:41'),(41365,999,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:35:53','2018-01-15 11:35:53'),(41366,878,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41367,884,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41368,838,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41369,825,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41370,821,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41371,833,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41372,886,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41373,857,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41374,866,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41375,827,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41376,877,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41377,858,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41378,835,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41379,828,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41380,875,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41381,885,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41382,889,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41383,887,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41384,846,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41385,848,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41386,888,'2017-12-01 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:30','2018-01-15 11:36:30'),(41387,808,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:58','2018-01-15 11:36:58'),(41388,814,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:58','2018-01-15 11:36:58'),(41389,810,'2018-01-15 11:35:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-15 11:36:58','2018-01-15 11:36:58');

/*Table structure for table `employee_attendance_approve` */

DROP TABLE IF EXISTS `employee_attendance_approve`;

CREATE TABLE `employee_attendance_approve` (
  `employee_attendance_approve_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`employee_attendance_approve_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `employee_attendance_approve` */

insert  into `employee_attendance_approve`(`employee_attendance_approve_id`,`employee_id`,`finger_print_id`,`date`,`in_time`,`out_time`,`working_hour`,`approve_working_hour`,`created_by`,`updated_by`,`created_at`,`updated_at`) values (1,2,884,'2018-01-08','08:30','17:40','09:10','09:10',1,1,NULL,NULL),(2,4,808,'2018-01-08','11:25','18:25','07:00','07:10',1,1,NULL,NULL),(5,2,884,'2018-01-09','08:45','17:45','09:00','09:00',2,2,NULL,NULL),(6,24,848,'2018-01-09','00:00','00:00','00:00','00:00',2,2,NULL,NULL);

/*Table structure for table `employee_award` */

DROP TABLE IF EXISTS `employee_award`;

CREATE TABLE `employee_award` (
  `employee_award_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NOT NULL,
  `award_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gift_item` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `month` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`employee_award_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `employee_award` */

/*Table structure for table `employee_bonus` */

DROP TABLE IF EXISTS `employee_bonus`;

CREATE TABLE `employee_bonus` (
  `employee_bonus_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bonus_setting_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `month` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gross_salary` int(11) NOT NULL,
  `basic_salary` int(11) NOT NULL,
  `bonus_amount` int(11) NOT NULL,
  `tax` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`employee_bonus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `employee_bonus` */

insert  into `employee_bonus`(`employee_bonus_id`,`bonus_setting_id`,`employee_id`,`month`,`gross_salary`,`basic_salary`,`bonus_amount`,`tax`,`created_at`,`updated_at`) values (41,1,1,'2018-01',100000,50000,50000,0,'2018-01-14 12:18:22','2018-01-14 12:18:22'),(42,1,2,'2018-01',0,0,184000,0,'2018-01-14 12:18:22','2018-01-14 12:18:22'),(43,1,3,'2018-01',100000,50000,50000,0,'2018-01-14 12:18:22','2018-01-14 12:18:22'),(44,1,12,'2018-01',100000,50000,50000,0,'2018-01-14 12:18:22','2018-01-14 12:18:22'),(45,1,20,'2018-01',100000,50000,50000,0,'2018-01-14 12:18:22','2018-01-14 12:18:22'),(46,1,22,'2018-01',100000,50000,50000,0,'2018-01-14 12:18:22','2018-01-14 12:18:22'),(47,1,24,'2018-01',0,0,184000,0,'2018-01-14 12:18:22','2018-01-14 12:18:22'),(48,1,4,'2018-01',0,0,184000,0,'2018-01-14 12:18:22','2018-01-14 12:18:22'),(49,1,5,'2018-01',100000,50000,50000,0,'2018-01-14 12:18:22','2018-01-14 12:18:22'),(50,1,27,'2018-01',0,0,184000,0,'2018-01-14 12:18:22','2018-01-14 12:18:22'),(51,2,1,'2018-03',100000,50000,50000,0,'2018-01-14 12:18:33','2018-01-14 12:18:33'),(52,2,2,'2018-03',0,0,84000,0,'2018-01-14 12:18:33','2018-01-14 12:18:33'),(53,2,3,'2018-03',100000,50000,50000,0,'2018-01-14 12:18:33','2018-01-14 12:18:33'),(54,2,12,'2018-03',100000,50000,50000,0,'2018-01-14 12:18:33','2018-01-14 12:18:33'),(55,2,20,'2018-03',100000,50000,50000,0,'2018-01-14 12:18:33','2018-01-14 12:18:33'),(56,2,22,'2018-03',100000,50000,50000,0,'2018-01-14 12:18:33','2018-01-14 12:18:33'),(57,2,24,'2018-03',0,0,84000,0,'2018-01-14 12:18:33','2018-01-14 12:18:33'),(58,2,4,'2018-03',0,0,84000,0,'2018-01-14 12:18:33','2018-01-14 12:18:33'),(59,2,5,'2018-03',100000,50000,50000,0,'2018-01-14 12:18:33','2018-01-14 12:18:33'),(60,2,27,'2018-03',0,0,84000,0,'2018-01-14 12:18:33','2018-01-14 12:18:33');

/*Table structure for table `employee_education_qualification` */

DROP TABLE IF EXISTS `employee_education_qualification`;

CREATE TABLE `employee_education_qualification` (
  `employee_education_qualification_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` int(10) unsigned NOT NULL,
  `institute` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `board_university` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `degree` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `result` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cgpa` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `passing_year` year(4) NOT NULL,
  PRIMARY KEY (`employee_education_qualification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `employee_education_qualification` */

/*Table structure for table `employee_experience` */

DROP TABLE IF EXISTS `employee_experience`;

CREATE TABLE `employee_experience` (
  `employee_experience_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` int(10) unsigned NOT NULL,
  `organization_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `designation` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `skill` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `responsibility` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`employee_experience_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `employee_experience` */

/*Table structure for table `employee_performance` */

DROP TABLE IF EXISTS `employee_performance`;

CREATE TABLE `employee_performance` (
  `employee_performance_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NOT NULL,
  `month` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `remarks` text COLLATE utf8mb4_unicode_ci,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`employee_performance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `employee_performance` */

insert  into `employee_performance`(`employee_performance_id`,`employee_id`,`month`,`created_by`,`updated_by`,`remarks`,`status`,`created_at`,`updated_at`) values (5,2,'2018-10',2,2,NULL,0,'2018-01-09 13:01:46','2018-01-09 13:01:46'),(6,2,'2017-10',2,2,NULL,0,'2018-01-14 12:04:42','2018-01-14 12:04:42');

/*Table structure for table `employee_performance_details` */

DROP TABLE IF EXISTS `employee_performance_details`;

CREATE TABLE `employee_performance_details` (
  `employee_performance_details_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `employee_performance_id` int(10) unsigned NOT NULL,
  `performance_criteria_id` int(10) unsigned NOT NULL,
  `rating` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`employee_performance_details_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `employee_performance_details` */

insert  into `employee_performance_details`(`employee_performance_details_id`,`employee_performance_id`,`performance_criteria_id`,`rating`,`created_at`,`updated_at`) values (1,6,1,0,'2018-01-14 12:04:43','2018-01-14 12:04:43');

/*Table structure for table `holiday` */

DROP TABLE IF EXISTS `holiday`;

CREATE TABLE `holiday` (
  `holiday_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `holiday_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`holiday_id`),
  UNIQUE KEY `holiday_holiday_name_unique` (`holiday_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `holiday` */

insert  into `holiday`(`holiday_id`,`holiday_name`,`created_at`,`updated_at`) values (1,'test','2017-12-31 09:49:46','2017-12-31 09:49:46');

/*Table structure for table `holiday_details` */

DROP TABLE IF EXISTS `holiday_details`;

CREATE TABLE `holiday_details` (
  `holiday_details_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `holiday_id` int(10) unsigned NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`holiday_details_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `holiday_details` */

insert  into `holiday_details`(`holiday_details_id`,`holiday_id`,`from_date`,`to_date`,`comment`,`created_at`,`updated_at`) values (1,1,'2017-12-10','2017-12-11','ssdfs','2017-12-31 09:50:25','2017-12-31 10:24:10');

/*Table structure for table `hourly_salaries` */

DROP TABLE IF EXISTS `hourly_salaries`;

CREATE TABLE `hourly_salaries` (
  `hourly_salaries_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hourly_grade` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hourly_rate` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`hourly_salaries_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `hourly_salaries` */

insert  into `hourly_salaries`(`hourly_salaries_id`,`hourly_grade`,`hourly_rate`,`created_at`,`updated_at`) values (1,'H-A',1000,'2018-01-08 10:27:51','2018-01-08 10:27:51');

/*Table structure for table `interview` */

DROP TABLE IF EXISTS `interview`;

CREATE TABLE `interview` (
  `interview_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `job_applicant_id` int(10) unsigned NOT NULL,
  `interview_date` date NOT NULL,
  `interview_time` time NOT NULL,
  `interview_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`interview_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `interview` */

/*Table structure for table `job` */

DROP TABLE IF EXISTS `job`;

CREATE TABLE `job` (
  `job_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `job_title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `post` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `application_end_date` date NOT NULL,
  `publish_date` date NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `job` */

/*Table structure for table `job_applicant` */

DROP TABLE IF EXISTS `job_applicant`;

CREATE TABLE `job_applicant` (
  `job_applicant_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `job_id` int(10) unsigned NOT NULL,
  `applicant_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applicant_email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` int(11) NOT NULL,
  `cover_letter` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `attached_resume` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `application_date` date NOT NULL,
  `status` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`job_applicant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `job_applicant` */

/*Table structure for table `leave_application` */

DROP TABLE IF EXISTS `leave_application`;

CREATE TABLE `leave_application` (
  `leave_application_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` int(10) unsigned NOT NULL,
  `leave_type_id` int(10) unsigned NOT NULL,
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
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`leave_application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `leave_application` */

insert  into `leave_application`(`leave_application_id`,`employee_id`,`leave_type_id`,`application_from_date`,`application_to_date`,`application_date`,`number_of_day`,`approve_date`,`reject_date`,`approve_by`,`reject_by`,`purpose`,`remarks`,`status`,`created_at`,`updated_at`) values (1,2,1,'2017-12-27','2017-12-27','2017-12-27',1,'2017-12-27',NULL,1,NULL,'sfdsd',NULL,'2','2017-12-28 16:11:51','2017-12-28 16:12:13'),(2,1,2,'2017-12-19','2017-12-21','2017-12-19',3,'2017-12-19',NULL,1,NULL,'sds',NULL,'2','2017-12-28 16:39:52','2017-12-28 16:39:52'),(3,1,3,'2017-12-17','2017-12-17','2017-12-17',1,'2017-12-17',NULL,1,NULL,'sf',NULL,'2','2017-12-31 11:03:51','2017-12-31 11:03:51');

/*Table structure for table `leave_type` */

DROP TABLE IF EXISTS `leave_type`;

CREATE TABLE `leave_type` (
  `leave_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `leave_type_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `num_of_day` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`leave_type_id`),
  UNIQUE KEY `leave_type_leave_type_name_unique` (`leave_type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `leave_type` */

insert  into `leave_type`(`leave_type_id`,`leave_type_name`,`num_of_day`,`created_at`,`updated_at`) values (1,'Earn Leave',0,'2018-01-10 16:25:01','2018-01-10 16:25:01'),(2,'Casual Leave',22,'2018-01-10 16:25:01','2018-01-10 16:25:01'),(3,'Sick Leave	',20,'2018-01-10 16:25:01','2018-01-10 16:25:01');

/*Table structure for table `menu_permission` */

DROP TABLE IF EXISTS `menu_permission`;

CREATE TABLE `menu_permission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `menu_permission` */

insert  into `menu_permission`(`id`,`role_id`,`menu_id`) values (1,1,2),(2,1,3),(3,1,4),(4,1,5),(5,1,6),(6,1,7),(7,1,8),(8,1,9),(9,1,10),(10,1,11),(11,1,12),(12,1,13),(13,1,14),(14,1,15),(15,1,16),(16,1,17),(17,1,18),(18,1,19),(19,1,20),(20,1,21),(21,1,22),(22,1,23),(23,1,24),(24,1,25),(25,1,26),(26,1,27),(27,1,28),(28,1,29),(29,1,30),(30,1,31),(31,1,32),(32,1,33),(33,1,34),(34,1,35),(35,1,36),(36,1,37),(37,1,38),(38,1,39),(39,1,40),(40,1,41),(41,1,42),(42,1,43),(43,1,44),(44,1,45),(45,1,46),(46,1,47),(47,1,48),(48,1,49),(49,1,50),(50,1,51),(51,1,52),(52,1,53),(53,1,54),(54,1,55),(55,1,56),(56,1,57),(57,1,58),(58,1,59),(59,1,60),(60,1,61),(61,1,62),(62,1,63);

/*Table structure for table `menus` */

DROP TABLE IF EXISTS `menus`;

CREATE TABLE `menus` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `action` int(11) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `menu_url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `module_id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `menus` */

insert  into `menus`(`id`,`parent_id`,`action`,`name`,`menu_url`,`module_id`,`status`) values (1,0,NULL,'User','user.index',1,2),(2,0,NULL,'Manage Role',NULL,1,1),(3,2,NULL,'Add Role','userRole.index',1,1),(4,2,NULL,'Add Role Permission','rolePermission.index',1,1),(5,0,NULL,'Change Password','changePassword.index',1,1),(6,0,NULL,'Department','department.index',2,1),(7,0,NULL,'Designation','designation.index',2,1),(8,0,NULL,'Branch','branch.index',2,1),(9,0,NULL,'Manage Employee','employee.index',2,1),(10,0,NULL,'Setup',NULL,3,1),(11,10,NULL,'Manage Holiday','holiday.index',3,1),(12,10,NULL,'Public Holiday','publicHoliday.index',3,1),(13,10,NULL,'Weekly Holiday','weeklyHoliday.index',3,1),(14,10,NULL,'Leave Type','leaveType.index',3,1),(15,0,NULL,'Leave Application',NULL,3,1),(16,15,NULL,'Apply for Leave','applyForLeave.index',3,1),(17,15,NULL,'Requested Application','requestedApplication.index',3,1),(18,0,NULL,'Setup',NULL,4,1),(19,18,NULL,'Manage Work Shift','workShift.index',4,1),(20,0,NULL,'Report',NULL,4,1),(21,20,NULL,'Daily Attendance','dailyAttendance.dailyAttendance',4,1),(22,0,NULL,'Report',NULL,3,1),(23,22,NULL,'Leave Report','leaveReport.leaveReport',3,1),(24,20,NULL,'Monthly Attendance','monthlyAttendance.monthlyAttendance',4,1),(25,0,NULL,'Setup',NULL,5,1),(26,25,NULL,'Tax Rule Setup','taxSetup.index',5,1),(27,0,NULL,'Allowance','allowance.index',5,1),(28,0,NULL,'Deduction','deduction.index',5,1),(29,0,NULL,'Monthly Pay Grade','payGrade.index',5,1),(30,0,NULL,'Hourly Pay Grade','hourlyWages.index',5,1),(31,0,NULL,'Generate Salary Sheet','generateSalarySheet.index',5,1),(32,25,NULL,'Late Configration','salaryDeductionRule.index',5,1),(33,0,NULL,'Report',NULL,5,1),(34,33,NULL,'Payment History','paymentHistory.paymentHistory',5,1),(35,33,NULL,'My Payroll','myPayroll.myPayroll',5,1),(36,0,NULL,'Performance Category','performanceCategory.index',6,1),(37,0,NULL,'Performance Criteria','performanceCriteria.index',6,1),(38,0,NULL,'Employee Performance','employeePerformance.index',6,1),(39,0,NULL,'Report',NULL,6,1),(40,39,NULL,'Summary Report','performanceSummaryReport.performanceSummaryReport',6,1),(41,0,NULL,'Job Post','jobPost.index',7,1),(42,0,NULL,'Job Candidate','jobCandidate.index',7,1),(43,20,NULL,'My Attendance Report','myAttendanceReport.myAttendanceReport',4,1),(44,10,NULL,'Earn Leave Configure','earnLeaveConfigure.index',3,1),(45,0,NULL,'Training Type','trainingType.index',8,1),(46,0,NULL,'Training List','trainingInfo.index',8,1),(47,0,NULL,'Training Report','employeeTrainingReport.employeeTrainingReport',8,1),(48,0,NULL,'Award','award.index',9,1),(49,0,NULL,'Notice','notice.index',10,1),(50,0,NULL,'Settings','generalSettings.index',11,1),(51,0,NULL,'Manual Attendance','manualAttendance.manualAttendance',4,1),(52,22,NULL,'Summary Report','summaryReport.summaryReport',3,1),(53,22,NULL,'My Leave Report','myLeaveReport.myLeaveReport',3,1),(54,0,NULL,'Warning','warning.index',2,1),(55,0,NULL,'Termination','termination.index',2,1),(56,0,NULL,'Promotion','promotion.index',2,1),(57,20,NULL,'Summary Report','attendanceSummaryReport.attendanceSummaryReport',4,1),(58,0,NULL,'Manage Work Hour',NULL,5,1),(59,58,NULL,'Approve Work Hour','workHourApproval.create',5,1),(60,0,NULL,'Employee Permanent','permanent.index',2,1),(61,0,NULL,'Manage Bonus',NULL,5,1),(62,61,NULL,'Bonus Setting','bonusSetting.index',5,1),(63,61,NULL,'Generate Bonus','generateBonus.index',5,1);

/*Table structure for table `migrations` */

DROP TABLE IF EXISTS `migrations`;

CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `migrations` */

insert  into `migrations`(`id`,`migration`,`batch`) values (1,'2017_09_09_085518_MenuPermissionMigration',1),(2,'2017_09_10_080607_create_menus_table',1),(3,'2017_09_13_095759_create_roles_table',1),(4,'2017_09_19_030632_create_departments_table',1),(5,'2017_09_19_043154_create_designations_table',1),(6,'2017_09_19_053209_create_employees_table',1),(7,'2017_09_19_060623_create_employee_experiences_table',1),(8,'2017_09_19_062907_create_employee_education_qualifications_table',1),(9,'2017_09_1_000000_create_users_table',1),(10,'2017_09_27_033248_create_branches_table',1),(11,'2017_09_2_081056_create_modules_table',1),(12,'2017_10_02_042807_create_holidays_table',1),(13,'2017_10_04_035502_create_holiday_details_table',1),(14,'2017_10_04_050224_create_weekly_holidays_table',1),(15,'2017_10_04_050517_create_leave_types_table',1),(16,'2017_10_04_093455_create_leave_applications_table',1),(17,'2017_10_05_094341_create_SP_weekly_holiday_store_procedure',1),(18,'2017_10_05_095235_create_SP_get_holiday_store_procedure',1),(19,'2017_10_05_095429_create_SP_get_employee_leave_balance_store_procedure',1),(20,'2017_10_09_043228_create_work_shifts_table',1),(21,'2017_10_09_074500_create_employee_attendances_table',1),(22,'2017_10_09_095518_create_view_get_employee_in_out_data',1),(25,'2017_10_11_084031_create_allownce_table',1),(26,'2017_10_11_084043_create_deduction_table',1),(27,'2017_10_23_051619_create_pay_grades_table',1),(28,'2017_10_26_064948_create_tax_rules_table',1),(29,'2017_10_29_075627_create_pay_grade_to_allowances_table',1),(30,'2017_10_29_075706_create_pay_grade_to_deductions_table',1),(31,'2017_10_30_065329_create_SP_get_employee_info_store_procedure',1),(32,'2017_11_01_045130_create_salary_deduction_for_late_attendances_table',1),(33,'2017_11_02_051338_create_salary_details_table',1),(34,'2017_11_02_053649_create_salary_details_to_allowances_table',1),(35,'2017_11_02_054000_create_salary_details_to_deductions_table',1),(36,'2017_11_07_042136_create_performance_categories_table',1),(37,'2017_11_07_042334_create_performance_criterias_table',1),(38,'2017_11_08_035959_create_employee_performances_table',1),(39,'2017_11_08_040029_create_employee_performance_details_table',1),(40,'2017_11_14_061231_create_earn_leave_rules_table',1),(41,'2017_11_14_092829_create_company_address_settings_table',1),(42,'2017_11_15_090514_create_employee_awards_table',1),(43,'2017_11_15_105135_create_notices_table',1),(44,'2017_11_23_102429_create_print_head_settings_table',1),(45,'2017_12_03_112226_create_training_types_table',1),(46,'2017_12_03_112805_create_training_infos_table',1),(47,'2017_12_04_114921_create_warnings_table',1),(48,'2017_12_04_140839_create_terminations_table',1),(49,'2017_12_05_154824_create_promotions_table',1),(50,'2017_12_10_122540_create_hourly_salaries_table',1),(51,'2017_12_13_144211_create_jobs_table',1),(52,'2017_12_13_144259_create_job_applicants_table',1),(53,'2017_12_13_144320_create_interviews_table',1),(54,'2030_09_17_062133_KeyContstraintsMigration',1),(55,'2017_12_31_222850_create_salary_details_to_leaves_table',2),(56,'2017_10_11_051354_create_SP_daily_attendance_store_procedure',3),(57,'2017_10_11_083952_create_SP_monthly_attendance_store_procedure',3),(62,'2018_01_08_144502_create_employee_attendance_approves_table',4),(67,'2018_01_10_150238_create_bonus_settings_table',5),(68,'2018_01_10_161034_create_employee_bonuses_table',6);

/*Table structure for table `modules` */

DROP TABLE IF EXISTS `modules`;

CREATE TABLE `modules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon_class` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `modules` */

insert  into `modules`(`id`,`name`,`icon_class`) values (1,'Administration','mdi mdi-contacts'),(2,'Employee Management','mdi mdi-account-multiple-plus'),(3,'Leave Management','mdi mdi-format-line-weight'),(4,'Attendance','mdi mdi-clock-fast'),(5,'Payroll','mdi mdi-cash'),(6,'Performance','mdi mdi-calculator'),(7,'Recruitment','mdi mdi-newspaper'),(8,'Training','mdi mdi-web'),(9,'Award','mdi mdi-trophy-variant'),(10,'Notice Board','mdi mdi-flag'),(11,'Settings','mdi mdi-settings');

/*Table structure for table `notice` */

DROP TABLE IF EXISTS `notice`;

CREATE TABLE `notice` (
  `notice_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `publish_date` date NOT NULL,
  `attach_file` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `notice` */

/*Table structure for table `pay_grade` */

DROP TABLE IF EXISTS `pay_grade`;

CREATE TABLE `pay_grade` (
  `pay_grade_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pay_grade_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gross_salary` int(11) NOT NULL,
  `percentage_of_basic` int(11) NOT NULL,
  `basic_salary` int(11) NOT NULL,
  `overtime_rate` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`pay_grade_id`),
  UNIQUE KEY `pay_grade_pay_grade_name_unique` (`pay_grade_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `pay_grade` */

insert  into `pay_grade`(`pay_grade_id`,`pay_grade_name`,`gross_salary`,`percentage_of_basic`,`basic_salary`,`overtime_rate`,`created_at`,`updated_at`) values (1,'A',100000,50,50000,500,'2018-01-08 11:03:38','2018-01-08 11:03:38'),(2,'B',80000,50,40000,500,NULL,NULL);

/*Table structure for table `pay_grade_to_allowance` */

DROP TABLE IF EXISTS `pay_grade_to_allowance`;

CREATE TABLE `pay_grade_to_allowance` (
  `pay_grade_to_allowance_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pay_grade_id` int(11) NOT NULL,
  `allowance_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`pay_grade_to_allowance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `pay_grade_to_allowance` */

insert  into `pay_grade_to_allowance`(`pay_grade_to_allowance_id`,`pay_grade_id`,`allowance_id`,`created_at`,`updated_at`) values (37,1,1,'2018-01-04 12:04:01','2018-01-04 12:04:01'),(38,1,2,'2018-01-04 12:04:01','2018-01-04 12:04:01'),(39,1,3,'2018-01-04 12:04:01','2018-01-04 12:04:01');

/*Table structure for table `pay_grade_to_deduction` */

DROP TABLE IF EXISTS `pay_grade_to_deduction`;

CREATE TABLE `pay_grade_to_deduction` (
  `pay_grade_to_deduction_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pay_grade_id` int(11) NOT NULL,
  `deduction_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`pay_grade_to_deduction_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `pay_grade_to_deduction` */

insert  into `pay_grade_to_deduction`(`pay_grade_to_deduction_id`,`pay_grade_id`,`deduction_id`,`created_at`,`updated_at`) values (12,1,1,'2018-01-04 12:04:01','2018-01-04 12:04:01');

/*Table structure for table `performance_category` */

DROP TABLE IF EXISTS `performance_category`;

CREATE TABLE `performance_category` (
  `performance_category_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `performance_category_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`performance_category_id`),
  UNIQUE KEY `performance_category_performance_category_name_unique` (`performance_category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `performance_category` */

insert  into `performance_category`(`performance_category_id`,`performance_category_name`,`created_at`,`updated_at`) values (1,'Ministration','2018-01-09 12:55:54','2018-01-09 12:56:02');

/*Table structure for table `performance_criteria` */

DROP TABLE IF EXISTS `performance_criteria`;

CREATE TABLE `performance_criteria` (
  `performance_criteria_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `performance_category_id` int(10) unsigned NOT NULL,
  `performance_criteria_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`performance_criteria_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `performance_criteria` */

insert  into `performance_criteria`(`performance_criteria_id`,`performance_category_id`,`performance_criteria_name`,`created_at`,`updated_at`) values (1,1,'Good relation with teammates','2018-01-09 12:56:08','2018-01-09 12:56:08');

/*Table structure for table `print_head_settings` */

DROP TABLE IF EXISTS `print_head_settings`;

CREATE TABLE `print_head_settings` (
  `print_head_setting_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`print_head_setting_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `print_head_settings` */

insert  into `print_head_settings`(`print_head_setting_id`,`description`,`created_at`,`updated_at`) values (1,'<b>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; NextDot</b><br>&nbsp; &nbsp; &nbsp;Sumona Gani Trade Center, Plot-2<br>Level 8. Panthapath, Dhaka 1215, Bangladesh.<br>','2018-01-01 11:07:22','2018-01-09 11:29:17');

/*Table structure for table `promotion` */

DROP TABLE IF EXISTS `promotion`;

CREATE TABLE `promotion` (
  `promotion_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` int(10) unsigned NOT NULL,
  `current_department` int(10) unsigned NOT NULL,
  `current_designation` int(10) unsigned NOT NULL,
  `current_pay_grade` int(11) NOT NULL,
  `current_salary` int(11) NOT NULL,
  `promoted_pay_grade` int(10) unsigned NOT NULL,
  `new_salary` int(11) NOT NULL,
  `promoted_department` int(10) unsigned NOT NULL,
  `promoted_designation` int(10) unsigned NOT NULL,
  `promotion_date` date NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `promotion` */

/*Table structure for table `role` */

DROP TABLE IF EXISTS `role`;

CREATE TABLE `role` (
  `role_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_role_name_unique` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `role` */

insert  into `role`(`role_id`,`role_name`,`created_at`,`updated_at`) values (1,'Super Admin','2018-01-10 16:24:59','2018-01-10 16:24:59'),(2,'Admin','2018-01-10 16:24:59','2018-01-10 16:24:59'),(3,'HR','2018-01-10 16:24:59','2018-01-10 16:24:59'),(4,'Accounts','2018-01-10 16:24:59','2018-01-10 16:24:59'),(5,'Developer','2018-01-10 16:24:59','2018-01-10 16:24:59');

/*Table structure for table `salary_deduction_for_late_attendance` */

DROP TABLE IF EXISTS `salary_deduction_for_late_attendance`;

CREATE TABLE `salary_deduction_for_late_attendance` (
  `salary_deduction_for_late_attendance_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `for_days` int(11) NOT NULL,
  `day_of_salary_deduction` int(11) NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`salary_deduction_for_late_attendance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `salary_deduction_for_late_attendance` */

insert  into `salary_deduction_for_late_attendance`(`salary_deduction_for_late_attendance_id`,`for_days`,`day_of_salary_deduction`,`status`,`created_at`,`updated_at`) values (1,3,1,'Active','2018-01-10 16:25:00','2018-01-10 16:25:00');

/*Table structure for table `salary_details` */

DROP TABLE IF EXISTS `salary_details`;

CREATE TABLE `salary_details` (
  `salary_details_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
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
  `working_hour` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '00:00',
  PRIMARY KEY (`salary_details_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `salary_details` */

insert  into `salary_details`(`salary_details_id`,`employee_id`,`month_of_salary`,`basic_salary`,`total_allowance`,`total_deduction`,`total_late`,`total_late_amount`,`total_absence`,`total_absence_amount`,`overtime_rate`,`total_over_time_hour`,`total_overtime_amount`,`hourly_rate`,`total_present`,`total_leave`,`total_working_days`,`tax`,`gross_salary`,`created_by`,`updated_by`,`status`,`comment`,`payment_method`,`action`,`created_at`,`updated_at`,`per_day_salary`,`taxable_salary`,`net_salary`,`working_hour`) values (28,1,'2017-12',67500,32500,46307,0,0,15,39474,0,'00:00',0,0,0,4,19,5333,53693,2,2,1,'paid','Cash','monthlySalary','2018-01-16 12:36:57','2018-01-16 12:36:57',2632,67500,100000,'00:00'),(29,2,'2017-12',0,0,0,0,0,0,0,0,'00:00',0,1000,0,0,0,0,0,2,2,0,NULL,NULL,'hourlySalary','2018-01-15 11:38:39','2018-01-15 11:38:39',0,0,0,'0:00'),(30,3,'2017-12',67500,32500,56833,0,0,19,50000,0,'00:00',0,0,0,0,19,5333,43167,2,2,1,'paid','Cash','monthlySalary','2018-01-16 12:36:50','2018-01-16 12:36:50',2632,67500,100000,'00:00'),(31,4,'2017-12',67500,32500,56833,0,0,19,50000,0,'00:00',0,0,0,0,19,5333,43167,2,2,1,'paid','Cash','monthlySalary','2018-01-15 11:41:17','2018-01-15 11:41:17',2632,67500,100000,'00:00'),(32,5,'2017-12',67500,32500,56833,0,0,19,50000,0,'00:00',0,0,0,0,19,5333,43167,2,2,1,'paid','Cash','monthlySalary','2018-01-15 11:41:13','2018-01-15 11:41:13',2632,67500,100000,'00:00'),(33,6,'2017-12',67500,32500,56833,0,0,19,50000,0,'00:00',0,0,0,0,19,5333,43167,2,2,1,'paid','Cash','monthlySalary','2018-01-15 11:41:10','2018-01-15 11:41:10',2632,67500,100000,'00:00'),(34,7,'2017-12',67500,32500,56833,0,0,19,50000,0,'00:00',0,0,0,0,19,5333,43167,2,2,1,'paid','Cash','monthlySalary','2018-01-15 11:41:06','2018-01-15 11:41:06',2632,67500,100000,'00:00'),(35,11,'2017-12',67500,32500,56833,0,0,19,50000,0,'00:00',0,0,0,0,19,5333,43167,2,2,1,'paid','Cash','monthlySalary','2018-01-15 11:41:01','2018-01-15 11:41:01',2632,67500,100000,'00:00'),(36,12,'2017-12',67500,32500,56833,0,0,19,50000,0,'00:00',0,0,0,0,19,5333,43167,2,2,1,'paid','Cash','monthlySalary','2018-01-15 11:40:58','2018-01-15 11:40:58',2632,67500,100000,'00:00'),(37,24,'2017-12',67500,32500,56208,0,0,19,50000,0,'00:00',0,0,0,0,19,4708,43792,2,2,1,'paid','Cash','monthlySalary','2018-01-15 11:40:50','2018-01-15 11:40:50',2632,67500,100000,'00:00'),(38,1,'2018-01',67500,32500,52288,0,0,10,45455,0,'00:00',0,0,1,0,11,5333,47712,2,2,1,'paid','Cash','monthlySalary','2018-01-16 12:36:04','2018-01-16 12:36:04',4545,67500,100000,'00:00'),(39,2,'2018-01',0,0,0,0,0,0,0,0,'00:00',0,1000,0,0,0,0,18167,2,2,1,'paid','Cash','hourlySalary','2018-01-16 12:36:43','2018-01-16 12:36:43',0,0,0,'18:10'),(40,3,'2018-01',67500,32500,52288,0,0,10,45455,0,'00:00',0,0,1,0,11,5333,47712,2,2,1,'paid','Cash','monthlySalary','2018-01-16 12:36:20','2018-01-16 12:36:20',4545,67500,100000,'00:00'),(41,4,'2018-01',67500,32500,52288,0,0,10,45455,0,'00:00',0,0,1,0,11,5333,47712,2,2,1,'paid','Cheque','monthlySalary','2018-01-16 12:36:11','2018-01-16 12:36:11',4545,67500,100000,'00:00');

/*Table structure for table `salary_details_to_allowance` */

DROP TABLE IF EXISTS `salary_details_to_allowance`;

CREATE TABLE `salary_details_to_allowance` (
  `salary_details_to_allowance_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `salary_details_id` int(11) NOT NULL,
  `allowance_id` int(11) NOT NULL,
  `amount_of_allowance` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`salary_details_to_allowance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `salary_details_to_allowance` */

insert  into `salary_details_to_allowance`(`salary_details_to_allowance_id`,`salary_details_id`,`allowance_id`,`amount_of_allowance`,`created_at`,`updated_at`) values (4,28,1,25000,'2018-01-15 11:38:28','2018-01-15 11:38:28'),(5,28,2,2500,'2018-01-15 11:38:28','2018-01-15 11:38:28'),(6,28,3,5000,'2018-01-15 11:38:28','2018-01-15 11:38:28'),(7,30,1,25000,'2018-01-15 11:38:59','2018-01-15 11:38:59'),(8,30,2,2500,'2018-01-15 11:38:59','2018-01-15 11:38:59'),(9,30,3,5000,'2018-01-15 11:38:59','2018-01-15 11:38:59'),(10,31,1,25000,'2018-01-15 11:39:09','2018-01-15 11:39:09'),(11,31,2,2500,'2018-01-15 11:39:09','2018-01-15 11:39:09'),(12,31,3,5000,'2018-01-15 11:39:09','2018-01-15 11:39:09'),(13,32,1,25000,'2018-01-15 11:39:18','2018-01-15 11:39:18'),(14,32,2,2500,'2018-01-15 11:39:18','2018-01-15 11:39:18'),(15,32,3,5000,'2018-01-15 11:39:18','2018-01-15 11:39:18'),(16,33,1,25000,'2018-01-15 11:39:29','2018-01-15 11:39:29'),(17,33,2,2500,'2018-01-15 11:39:29','2018-01-15 11:39:29'),(18,33,3,5000,'2018-01-15 11:39:29','2018-01-15 11:39:29'),(19,34,1,25000,'2018-01-15 11:39:45','2018-01-15 11:39:45'),(20,34,2,2500,'2018-01-15 11:39:45','2018-01-15 11:39:45'),(21,34,3,5000,'2018-01-15 11:39:45','2018-01-15 11:39:45'),(22,35,1,25000,'2018-01-15 11:40:04','2018-01-15 11:40:04'),(23,35,2,2500,'2018-01-15 11:40:04','2018-01-15 11:40:04'),(24,35,3,5000,'2018-01-15 11:40:04','2018-01-15 11:40:04'),(25,36,1,25000,'2018-01-15 11:40:23','2018-01-15 11:40:23'),(26,36,2,2500,'2018-01-15 11:40:23','2018-01-15 11:40:23'),(27,36,3,5000,'2018-01-15 11:40:23','2018-01-15 11:40:23'),(28,37,1,25000,'2018-01-15 11:40:33','2018-01-15 11:40:33'),(29,37,2,2500,'2018-01-15 11:40:33','2018-01-15 11:40:33'),(30,37,3,5000,'2018-01-15 11:40:33','2018-01-15 11:40:33'),(31,38,1,25000,'2018-01-15 11:41:26','2018-01-15 11:41:26'),(32,38,2,2500,'2018-01-15 11:41:26','2018-01-15 11:41:26'),(33,38,3,5000,'2018-01-15 11:41:26','2018-01-15 11:41:26'),(34,40,1,25000,'2018-01-15 11:41:46','2018-01-15 11:41:46'),(35,40,2,2500,'2018-01-15 11:41:46','2018-01-15 11:41:46'),(36,40,3,5000,'2018-01-15 11:41:46','2018-01-15 11:41:46'),(37,41,1,25000,'2018-01-15 11:42:02','2018-01-15 11:42:02'),(38,41,2,2500,'2018-01-15 11:42:02','2018-01-15 11:42:02'),(39,41,3,5000,'2018-01-15 11:42:02','2018-01-15 11:42:02');

/*Table structure for table `salary_details_to_deduction` */

DROP TABLE IF EXISTS `salary_details_to_deduction`;

CREATE TABLE `salary_details_to_deduction` (
  `salary_details_to_deduction_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `salary_details_id` int(11) NOT NULL,
  `deduction_id` int(11) NOT NULL,
  `amount_of_deduction` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`salary_details_to_deduction_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `salary_details_to_deduction` */

insert  into `salary_details_to_deduction`(`salary_details_to_deduction_id`,`salary_details_id`,`deduction_id`,`amount_of_deduction`,`created_at`,`updated_at`) values (2,28,1,1500,'2018-01-15 11:38:28','2018-01-15 11:38:28'),(3,30,1,1500,'2018-01-15 11:38:59','2018-01-15 11:38:59'),(4,31,1,1500,'2018-01-15 11:39:09','2018-01-15 11:39:09'),(5,32,1,1500,'2018-01-15 11:39:18','2018-01-15 11:39:18'),(6,33,1,1500,'2018-01-15 11:39:29','2018-01-15 11:39:29'),(7,34,1,1500,'2018-01-15 11:39:45','2018-01-15 11:39:45'),(8,35,1,1500,'2018-01-15 11:40:04','2018-01-15 11:40:04'),(9,36,1,1500,'2018-01-15 11:40:23','2018-01-15 11:40:23'),(10,37,1,1500,'2018-01-15 11:40:33','2018-01-15 11:40:33'),(11,38,1,1500,'2018-01-15 11:41:26','2018-01-15 11:41:26'),(12,40,1,1500,'2018-01-15 11:41:46','2018-01-15 11:41:46'),(13,41,1,1500,'2018-01-15 11:42:02','2018-01-15 11:42:02');

/*Table structure for table `salary_details_to_leave` */

DROP TABLE IF EXISTS `salary_details_to_leave`;

CREATE TABLE `salary_details_to_leave` (
  `salary_details_to_leave_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `salary_details_id` int(11) NOT NULL,
  `leave_type_id` int(11) NOT NULL,
  `num_of_day` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`salary_details_to_leave_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `salary_details_to_leave` */

insert  into `salary_details_to_leave`(`salary_details_to_leave_id`,`salary_details_id`,`leave_type_id`,`num_of_day`,`created_at`,`updated_at`) values (1,28,2,3,'2018-01-15 11:38:28','2018-01-15 11:38:28'),(2,28,3,1,'2018-01-15 11:38:28','2018-01-15 11:38:28');

/*Table structure for table `tax_rule` */

DROP TABLE IF EXISTS `tax_rule`;

CREATE TABLE `tax_rule` (
  `tax_rule_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `amount` int(11) NOT NULL,
  `percentage_of_tax` int(11) NOT NULL,
  `amount_of_tax` int(11) NOT NULL,
  `gender` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`tax_rule_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `tax_rule` */

insert  into `tax_rule`(`tax_rule_id`,`amount`,`percentage_of_tax`,`amount_of_tax`,`gender`,`created_at`,`updated_at`) values (1,250000,0,0,'Male','2018-01-10 16:25:00','2018-01-10 16:25:00'),(2,400000,10,40000,'Male','2018-01-10 16:25:00','2018-01-10 16:25:00'),(3,500000,15,75000,'Male','2018-01-10 16:25:00','2018-01-10 16:25:00'),(4,600000,20,120000,'Male','2018-01-10 16:25:00','2018-01-10 16:25:00'),(5,3000000,25,750000,'Male','2018-01-10 16:25:00','2018-01-10 16:25:00'),(6,0,30,0,'Male','2018-01-10 16:25:00','2018-01-10 16:25:00'),(7,300000,0,0,'Female','2018-01-10 16:25:00','2018-01-10 16:25:00'),(8,400000,10,40000,'Female','2018-01-10 16:25:00','2018-01-10 16:25:00'),(9,500000,15,75000,'Female','2018-01-10 16:25:00','2018-01-10 16:25:00'),(10,600000,20,120000,'Female','2018-01-10 16:25:00','2018-01-10 16:25:00'),(11,3000000,25,750000,'Female','2018-01-10 16:25:00','2018-01-10 16:25:00'),(12,0,30,0,'Female','2018-01-10 16:25:00','2018-01-10 16:25:00');

/*Table structure for table `termination` */

DROP TABLE IF EXISTS `termination`;

CREATE TABLE `termination` (
  `termination_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `terminate_to` int(10) unsigned NOT NULL,
  `terminate_by` int(10) unsigned NOT NULL,
  `termination_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notice_date` date NOT NULL,
  `termination_date` date NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`termination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `termination` */

/*Table structure for table `training_info` */

DROP TABLE IF EXISTS `training_info`;

CREATE TABLE `training_info` (
  `training_info_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `training_type_id` int(10) unsigned NOT NULL,
  `employee_id` int(10) unsigned NOT NULL,
  `subject` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `certificate` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`training_info_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `training_info` */

/*Table structure for table `training_type` */

DROP TABLE IF EXISTS `training_type`;

CREATE TABLE `training_type` (
  `training_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `training_type_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`training_type_id`),
  UNIQUE KEY `training_type_training_type_name_unique` (`training_type_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `training_type` */

/*Table structure for table `user` */

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL,
  `user_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_user_name_unique` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `user` */

insert  into `user`(`user_id`,`role_id`,`user_name`,`password`,`status`,`remember_token`,`created_by`,`updated_by`,`created_at`,`updated_at`) values (1,1,'iqbal','$2y$10$k8S036FYOY5ODrCUoiaNhefAv3lArAEA5sxn3NoZpNbnm2Tu.USlG',1,'j5Kc27Y5ojT1bHWNSiMxodihY2hY2SzxNOiYLTDTh2LXr0NX47T62E0azMO1',2,2,'2017-12-19 11:10:20','2017-12-27 08:39:17'),(2,1,'kamrul','$2y$10$U7BydMw5oOcMoUujgMwckO7R067oeu8wkIVZD8npkHmv.v8qa8SOq',1,'UjMGbozZSOi4ycJurH24h6kIwbiXlCx4GaYlbMfNDN2goiNcRSlt4qz4I9Wu',2,2,'2017-12-20 12:24:19','2018-01-09 11:00:02'),(3,1,'ayonrahman','$2y$10$uj6FnO9tADsBuy5C5gtpcOGFh/MznEwS6tYfMGClB08heqKEf1mX2',1,NULL,1,1,'2017-12-20 13:07:12','2017-12-20 14:26:58'),(4,1,'sabbirrashid','$2y$10$CnQnNEC9BHBqJGkKwVdq8eZUbwPDdzywEMrrGCQrLXUhAqkhJF2lm',1,NULL,2,2,'2017-12-20 13:11:50','2018-01-14 12:22:21'),(5,6,'mdferdousalam','$2y$10$CyNolxNZ0VSWoFHONaKgFef3lVmfT6xElvFuZ5R015f7ijMwIfurW',1,NULL,1,1,'2017-12-20 13:17:09','2017-12-20 13:17:09'),(6,6,'moniruzzamanmanik','$2y$10$qZq3GEcQIsewXG6EEQJ.yeOZSFccGcizLoUqKlzW6YwOip/19ddiG',1,NULL,1,1,'2017-12-20 13:20:16','2017-12-20 13:20:16'),(7,6,'mahbuburrahman','$2y$10$Fi.TJSLKXhUNe1wFRUgQYe1W8A4QjX2LRKnwImn8VZTAh.drI9762',1,NULL,1,1,'2017-12-20 13:22:37','2017-12-20 13:22:37'),(8,6,'maruf','$2y$10$W7s0Rh5/ILI2Zct9x0yROet1N7bZKo5aeA6j/lf4jDPf80O.n/.KG',1,NULL,1,1,'2017-12-20 13:24:56','2017-12-20 15:10:51'),(9,6,'nazmulhasan','$2y$10$q6MPozXZ5Wrps3EmLi192enTaiGUYnRfFaM1KBH95h5lU.8vjNdR6',1,NULL,1,1,'2017-12-20 13:26:40','2017-12-20 13:26:40'),(10,6,'saadkhan','$2y$10$TQICL2cYL0P4sJ5qhXEeSeQdR/k1b5u9bAgIBNqFcTu7v1m/KAOf6',1,NULL,1,1,'2017-12-20 13:28:05','2017-12-20 13:28:05'),(11,6,'anjanbiswas','$2y$10$SzTw85G.pKuWSDTy.jcYw./vnrUG9asY6z8FhpCAZQjjM7eR589IK',1,NULL,1,1,'2017-12-20 13:29:53','2017-12-20 13:29:53'),(12,6,'imtiazkalam','$2y$10$uC/kD5XEQewMkGT.iR6XAOaBXJ1915LfUecFK9rHWuIWqyHPKzVLa',1,NULL,1,1,'2017-12-20 13:33:21','2017-12-20 13:33:21'),(13,6,'imtiazzahid','$2y$10$4/nAprqfjYwsTiL/bT4XW.u5rgWcRx7nOSrzaiUoCIV9qKLJEUauO',1,NULL,1,1,'2017-12-20 13:36:43','2017-12-20 13:36:43'),(14,6,'imtiazdipto','$2y$10$2pkpkvjBoRBXjF/QlU32Pe/JYg7eGX6AaOE6BMrN210rgt9PdEDEG',1,NULL,1,1,'2017-12-20 13:40:40','2017-12-20 13:41:05'),(15,6,'sumonsheikh','$2y$10$OoEI7ADqlQYIlx1RlEfGHOHT71tMhvfPg/EYrBeYqiuynA7yRZV7.',1,NULL,1,1,'2017-12-20 13:43:18','2017-12-20 13:43:18'),(16,6,'nihadsharker','$2y$10$8GPVDFsZlpyNA9k/DuwxeeHl2A.Xd7WDVYkaeUfF1dTsZwr./pz3q',1,NULL,1,1,'2017-12-20 13:46:26','2017-12-20 13:46:26'),(17,6,'sohelchowdhury','$2y$10$DEPpN.k9Rs0uxsFBhATUfOg6GHDQsaj3Gae6OLk1jF5CAJUYapv4u',1,NULL,2,2,'2017-12-20 13:48:53','2018-01-03 13:26:46'),(18,6,'sadikul','$2y$10$46RrPbD6GZxpTqwKCtbPHOTGyOINTurSUFQhtPOZRubkfIxq9vnKS',1,NULL,1,1,'2017-12-20 13:52:40','2017-12-20 15:09:32'),(20,6,'shamiurrahmanshawon','$2y$10$lxK.FDN7hDG3Gfj/yfh07eShHZxLNH.eSUyQXTWcpZa0NxPQ4YbPS',1,NULL,1,1,'2017-12-20 14:15:02','2017-12-20 14:15:02'),(21,6,'himadreeshekharhalder','$2y$10$durNA92M8NpNz1nXd7FkxeYDfh3mgOzb1e6jMLa9zaY0.dVRoCCIi',1,NULL,1,1,'2017-12-20 14:17:17','2017-12-20 14:17:17'),(22,1,'rajib','$2y$10$BLV793kKppgrL0ap783efeYQaRTLoQkslnAZt7QzpKUhgMhWir0Yi',1,'Io1idV37EofA5hJgQvrwVXQbNmkOmCKcsXtpmuvzh7Ia3XfU5AAGyh4uHhbv',1,1,'2017-12-20 14:19:24','2017-12-20 15:50:59'),(23,6,'rabitashadin','$2y$10$/5WBSM6OFqVNbhu11yobuu57PhJ5v3WCz1hUyYQAPpZiFywVomBpK',1,NULL,1,1,'2017-12-20 14:21:08','2017-12-20 14:22:54'),(24,1,'nabilanasir','$2y$10$DWYHXQMUCJuENz5jr6bg9eBp4BaRywhwPPo.smJ8dLW.d7Dxhnswy',1,NULL,2,2,'2017-12-20 14:22:44','2018-01-09 13:16:22'),(25,6,'test','$2y$10$i1BaXCNGUjW9s//udLfTrOXl0yTCLgutp.ErBe0AmCoxbcMrOUIFu',3,'uailCaadIFtzqyjXWAkdZSKtI1N2hYB4F5GJQC9sOMgR55Qk2UayUzsUlyNV',2,2,'2017-12-26 12:48:37','2018-01-03 13:26:03'),(26,2,'MT','$2y$10$iv8.CUdYBQTTmx.plPK6b.xi8hxVpkXexWNA1XU5ye4M6JDjoBAY6',1,'zgHVsdZRYxLNlyPMnfRKDZXA32g7QF25s3DTPgXCmvBDeEfsbl5a5qhEz5gJ',2,2,'2018-01-03 12:55:17','2018-01-10 11:04:42'),(27,1,'GT','$2y$10$.05sT0h2WaO7tZW35yn0Gux5AtFDnKH2SK9xHOUIozfpIl.5REUcO',1,NULL,2,2,'2018-01-07 09:23:30','2018-01-11 13:03:23');

/*Table structure for table `warning` */

DROP TABLE IF EXISTS `warning`;

CREATE TABLE `warning` (
  `warning_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `warning_to` int(10) unsigned NOT NULL,
  `warning_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `warning_by` int(10) unsigned NOT NULL,
  `warning_date` date NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`warning_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `warning` */

/*Table structure for table `weekly_holiday` */

DROP TABLE IF EXISTS `weekly_holiday`;

CREATE TABLE `weekly_holiday` (
  `week_holiday_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `day_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`week_holiday_id`),
  UNIQUE KEY `weekly_holiday_day_name_unique` (`day_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `weekly_holiday` */

insert  into `weekly_holiday`(`week_holiday_id`,`day_name`,`status`,`created_at`,`updated_at`) values (1,'Saturday',1,'2017-12-28 12:14:28','2017-12-28 12:14:28'),(2,'Friday',1,'2017-12-28 12:14:33','2017-12-28 12:14:33');

/*Table structure for table `work_shift` */

DROP TABLE IF EXISTS `work_shift`;

CREATE TABLE `work_shift` (
  `work_shift_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `shift_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `late_count_time` time NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`work_shift_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `work_shift` */

insert  into `work_shift`(`work_shift_id`,`shift_name`,`start_time`,`end_time`,`late_count_time`,`created_at`,`updated_at`) values (1,'Day','08:30:00','17:00:00','08:45:00','2018-01-08 11:03:38','2018-01-08 11:03:38');

/* Procedure structure for procedure `SP_calculateEmployeeLeaveBalance` */

/*!50003 DROP PROCEDURE IF EXISTS  `SP_calculateEmployeeLeaveBalance` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_calculateEmployeeLeaveBalance`( IN employeeId int(10),IN leaveTypeId int(10) )
BEGIN  
          SELECT SUM(number_of_day) AS totalNumberOfDays FROM leave_application WHERE employee_id=employeeId AND leave_type_id=leaveTypeId and status = 2
          AND (approve_date  BETWEEN DATE_FORMAT(NOW(),'%Y-01-01') AND DATE_FORMAT(NOW(),'%Y-12-31'));
         END */$$
DELIMITER ;

/* Procedure structure for procedure `SP_DailyAttendance` */

/*!50003 DROP PROCEDURE IF EXISTS  `SP_DailyAttendance` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DailyAttendance`(
            IN input_date DATE
        )
BEGIN 
 
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
   

 
 END */$$
DELIMITER ;

/* Procedure structure for procedure `SP_getEmployeeInfo` */

/*!50003 DROP PROCEDURE IF EXISTS  `SP_getEmployeeInfo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_getEmployeeInfo`(IN employeeId INT(10))
BEGIN
	       SELECT employee.*,user.`user_name` FROM employee 
            INNER JOIN `user` ON `user`.`user_id` = employee.`user_id`
            WHERE employee_id = employeeId;
        END */$$
DELIMITER ;

/* Procedure structure for procedure `SP_getHoliday` */

/*!50003 DROP PROCEDURE IF EXISTS  `SP_getHoliday` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_getHoliday`(
IN fromDate DATE,
IN toDate DATE
)
BEGIN 
 
SELECT from_date,to_date FROM holiday_details WHERE from_date >= fromDate AND to_date <=toDate;
   

 
 END */$$
DELIMITER ;

/* Procedure structure for procedure `SP_getWeeklyHoliday` */

/*!50003 DROP PROCEDURE IF EXISTS  `SP_getWeeklyHoliday` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_getWeeklyHoliday`()
BEGIN
	        select day_name from  weekly_holiday where status=1;
        END */$$
DELIMITER ;

/* Procedure structure for procedure `SP_monthlyAttendance` */

/*!50003 DROP PROCEDURE IF EXISTS  `SP_monthlyAttendance` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_monthlyAttendance`(
                    IN employeeId INT(10),
                    IN from_date DATE,
                    IN to_date DATE
        )
BEGIN 
 
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
   

 
 END */$$
DELIMITER ;

/*Table structure for table `view_employee_in_out_data` */

DROP TABLE IF EXISTS `view_employee_in_out_data`;

/*!50001 DROP VIEW IF EXISTS `view_employee_in_out_data` */;
/*!50001 DROP TABLE IF EXISTS `view_employee_in_out_data` */;

/*!50001 CREATE TABLE  `view_employee_in_out_data`(
 `employee_attendance_id` int(10) unsigned ,
 `finger_print_id` int(11) ,
 `in_time` datetime ,
 `out_time` varchar(19) ,
 `date` varchar(10) ,
 `working_time` time 
)*/;

/*View structure for view view_employee_in_out_data */

/*!50001 DROP TABLE IF EXISTS `view_employee_in_out_data` */;
/*!50001 DROP VIEW IF EXISTS `view_employee_in_out_data` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_employee_in_out_data` AS select `employee_attendance`.`employee_attendance_id` AS `employee_attendance_id`,`employee_attendance`.`finger_print_id` AS `finger_print_id`,min(`employee_attendance`.`in_out_time`) AS `in_time`,if((count(`employee_attendance`.`in_out_time`) > 1),max(`employee_attendance`.`in_out_time`),'') AS `out_time`,date_format(`employee_attendance`.`in_out_time`,'%Y-%m-%d') AS `date`,timediff(max(`employee_attendance`.`in_out_time`),min(`employee_attendance`.`in_out_time`)) AS `working_time` from `employee_attendance` group by date_format(`employee_attendance`.`in_out_time`,'%Y-%m-%d'),`employee_attendance`.`finger_print_id` */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
