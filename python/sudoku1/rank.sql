/*
 Navicat MySQL Data Transfer

 Source Server         : myConnection
 Source Server Version : 50621
 Source Host           : localhost
 Source Database       : sukudo

 Target Server Version : 50621
 File Encoding         : utf-8

 Date: 11/24/2014 22:41:20 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `rank`
-- ----------------------------
DROP TABLE IF EXISTS `rank`;
CREATE TABLE `rank` (
  `id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `time` int(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
