/*
 Navicat Premium Data Transfer

 Source Server         : root
 Source Server Type    : MySQL
 Source Server Version : 80028
 Source Host           : localhost:3306
 Source Schema         : covid19

 Target Server Type    : MySQL
 Target Server Version : 80028
 File Encoding         : 65001

 Date: 18/05/2022 17:04:04
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for class
-- ----------------------------
DROP TABLE IF EXISTS `class`;
CREATE TABLE `class`  (
  `c_id` int NOT NULL AUTO_INCREMENT,
  `classes` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`c_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of class
-- ----------------------------
INSERT INTO `class` VALUES (18, '计算机科学与技术10班');
INSERT INTO `class` VALUES (19, '软件技术10班');
INSERT INTO `class` VALUES (20, '信息10班');

-- ----------------------------
-- Table structure for health
-- ----------------------------
DROP TABLE IF EXISTS `health`;
CREATE TABLE `health`  (
  `h_id` int NOT NULL AUTO_INCREMENT,
  `u_id` int NULL DEFAULT NULL,
  `temperature` float NULL DEFAULT NULL,
  `hot` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gohubei` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `hubeiren` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `fever` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `leaveout` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `hesuan` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `mask` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `masknum` int NULL DEFAULT NULL,
  `kills` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `createtime` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`h_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of health
-- ----------------------------
INSERT INTO `health` VALUES (18, 1, 36.9, '否', '否', '否', '否', '否', '否', '否', 20, '是', '2022-05-14 00:00:00');
INSERT INTO `health` VALUES (19, 44, 36.8, '否', '是', '否', '否', '是', '是', '是', 10, '是', '2022-05-14 00:00:00');
INSERT INTO `health` VALUES (20, 45, 36.6, '否', '否', '否', '否', '否', '是', '否', 30, '否', '2022-05-14 00:00:00');
INSERT INTO `health` VALUES (21, 1, 36.5, '否', '否', '否', '否', '否', '否', '否', 33, '否', '2022-05-15 00:00:00');
INSERT INTO `health` VALUES (22, 1, 36.1, '否', '否', '否', '否', '否', '是', '否', 40, '否', '2022-05-17 00:00:00');
INSERT INTO `health` VALUES (23, 45, 36.5, '否', '否', '否', '否', '否', '否', '否', 20, '是', '2022-05-17 00:00:00');
INSERT INTO `health` VALUES (24, 1, 36, '否', '否', '否', '否', '否', '是', '否', 10, '否', '2022-05-18 00:00:00');
INSERT INTO `health` VALUES (25, 44, 36, '否', '否', '否', '否', '否', '是', '否', 90, '是', '2022-05-18 00:00:00');

-- ----------------------------
-- Table structure for leave
-- ----------------------------
DROP TABLE IF EXISTS `leave`;
CREATE TABLE `leave`  (
  `l_id` int NOT NULL AUTO_INCREMENT,
  `u_id` int NULL DEFAULT NULL,
  `reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `leavetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `starttime` date NULL DEFAULT NULL,
  `endtime` date NULL DEFAULT NULL,
  `state` int NULL DEFAULT NULL,
  `createtime` bigint NULL DEFAULT NULL,
  `classes` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`l_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of leave
-- ----------------------------
INSERT INTO `leave` VALUES (12, 44, '身体不适需要请假就医', '事假', '2022-05-14', '2022-05-17', 2, 1652505484882, '计算机科学与技术10班');
INSERT INTO `leave` VALUES (13, 44, '玩', '事假', '2022-05-18', '2022-05-25', 2, 1652707438547, '计算机科学与技术10班');
INSERT INTO `leave` VALUES (14, 44, '比赛', '事假', '2022-05-21', '2022-06-19', 2, 1652772985841, '计算机科学与技术10班');
INSERT INTO `leave` VALUES (15, 44, '生病', '事假', '2022-05-17', '2022-05-19', 1, 1652773711663, '计算机科学与技术10班');
INSERT INTO `leave` VALUES (16, 44, '生病', '病假', '2022-05-17', '2022-05-19', 2, 1652773876402, '计算机科学与技术10班');
INSERT INTO `leave` VALUES (17, 46, '参加比赛', '事假', '2022-05-18', '2022-05-23', 2, 1652855781021, '软件技术10班');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `n_id` int NOT NULL AUTO_INCREMENT,
  `title` mediumtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `content` mediumtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `createtime` bigint NULL DEFAULT NULL,
  `class` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`n_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (22, '黄码通知', '如果有黄码的请立即报备', 1652505760938, '计算机科学与技术10班;软件技术10班');
INSERT INTO `notice` VALUES (23, '放假通知', '六一放假', 1652842196520, '计算机科学与技术10班;软件技术10班;信息10班');

-- ----------------------------
-- Table structure for read
-- ----------------------------
DROP TABLE IF EXISTS `read`;
CREATE TABLE `read`  (
  `r_id` int NOT NULL AUTO_INCREMENT,
  `u_id` int NOT NULL,
  `n_id` int NOT NULL,
  `readtime` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`r_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of read
-- ----------------------------
INSERT INTO `read` VALUES (1, 44, 22, NULL);
INSERT INTO `read` VALUES (2, 44, 23, NULL);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `token` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '123456',
  `head` mediumtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `mailbox` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sex` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `createtime` bigint NULL DEFAULT NULL,
  `modifytime` datetime NULL DEFAULT NULL,
  `classes` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `type` int NULL DEFAULT NULL,
  `position` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, NULL, 'admin', '123456', '', NULL, 'SC', '男', NULL, NULL, NULL, 1, NULL);
INSERT INTO `user` VALUES (44, NULL, 'student', '123456', NULL, NULL, '四川', '女', NULL, '2022-05-18 10:55:20', '计算机科学与技术10班', 2, 'undefined');
INSERT INTO `user` VALUES (45, NULL, 'teacher', '123456', NULL, NULL, 'SC', '男', 1652505294535, '2022-05-16 18:42:57', '计算机科学与技术10班;软件技术10班', 3, '讲师');
INSERT INTO `user` VALUES (46, NULL, '张三', '123456', NULL, NULL, '四川', '男', NULL, NULL, '软件技术10班', 2, NULL);
INSERT INTO `user` VALUES (47, NULL, '王五', '123456', NULL, NULL, '上海', '男', NULL, '2022-05-18 17:01:46', '软件技术10班', 2, 'undefined');
INSERT INTO `user` VALUES (50, NULL, '李老师', '123456', NULL, NULL, '四川', '男', 1652585220857, '2022-05-18 17:01:17', '计算机科学与技术10班;软件技术10班', 3, '讲师');
INSERT INTO `user` VALUES (51, NULL, '张三', '123456', NULL, NULL, '四川', '女', 1652794595375, '2022-05-18 16:59:36', '计算机科学与技术10班;软件技术10班;信息10班', 3, '教师');
INSERT INTO `user` VALUES (52, NULL, 'tian', '123456', NULL, NULL, '四川', '男', NULL, NULL, '计算机科学与技术10班', 2, NULL);

SET FOREIGN_KEY_CHECKS = 1;
