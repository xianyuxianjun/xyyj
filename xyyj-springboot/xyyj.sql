/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80200 (8.2.0)
 Source Host           : localhost:3306
 Source Schema         : xyyj

 Target Server Type    : MySQL
 Target Server Version : 80200 (8.2.0)
 File Encoding         : 65001

 Date: 16/12/2024 16:25:47
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for attachment
-- ----------------------------
DROP TABLE IF EXISTS `attachment`;
CREATE TABLE `attachment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `business_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '业务ID',
  `business_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '业务类型(WARNING:预警记录,PROCESS:处理记录)',
  `file_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件名',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件路径',
  `file_size` bigint NOT NULL COMMENT '文件大小(字节)',
  `file_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件类型',
  `upload_user_id` bigint NOT NULL COMMENT '上传人ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_business`(`business_id` ASC, `business_type` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '附件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of attachment
-- ----------------------------

-- ----------------------------
-- Table structure for student_info
-- ----------------------------
DROP TABLE IF EXISTS `student_info`;
CREATE TABLE `student_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `student_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学号',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '姓名',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '性别(M:男,F:女)',
  `college` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学院',
  `major` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '专业',
  `class_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '班级',
  `admission_year` int NOT NULL COMMENT '入学年份',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'NORMAL' COMMENT '状态(NORMAL:正常,WARNING:预警,PROBATION:留校察看)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_student_id`(`student_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学生信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student_info
-- ----------------------------
INSERT INTO `student_info` VALUES (10, '20200001', '李华', 'M', '计算机学院', '软件工程', '软工1班', 2020, 'NORMAL', '2024-12-16 16:13:09', '2024-12-16 16:13:09');
INSERT INTO `student_info` VALUES (11, '20200002', '王芳', 'F', '计算机学院', '软件工程', '软工1班', 2020, 'WARNING', '2024-12-16 16:13:09', '2024-12-16 16:13:09');
INSERT INTO `student_info` VALUES (12, '20200003', '赵强', 'M', '电子工程学院', '通信工程', '通信1班', 2020, 'PROBATION', '2024-12-16 16:13:09', '2024-12-16 16:13:09');
INSERT INTO `student_info` VALUES (13, '20200004', '陈丽', 'F', '经济学院', '金融学', '金融1班', 2020, 'NORMAL', '2024-12-16 16:15:59', '2024-12-16 16:15:59');
INSERT INTO `student_info` VALUES (14, '20200005', '刘洋', 'M', '管理学院', '工商管理', '工商1班', 2020, 'WARNING', '2024-12-16 16:15:59', '2024-12-16 16:15:59');
INSERT INTO `student_info` VALUES (15, '20200006', '张伟', 'M', '外国语学院', '英语', '英语1班', 2020, 'NORMAL', '2024-12-16 16:15:59', '2024-12-16 16:15:59');
INSERT INTO `student_info` VALUES (16, '20200007', '王霞', 'F', '艺术学院', '设计', '设计1班', 2020, 'PROBATION', '2024-12-16 16:15:59', '2024-12-16 16:15:59');
INSERT INTO `student_info` VALUES (17, '20200008', '李娜', 'F', '法学院', '法学', '法学1班', 2020, 'NORMAL', '2024-12-16 16:15:59', '2024-12-16 16:15:59');
INSERT INTO `student_info` VALUES (18, '20200009', '孙斌', 'M', '理学院', '数学', '数学1班', 2020, 'NORMAL', '2024-12-16 16:17:51', '2024-12-16 16:17:51');
INSERT INTO `student_info` VALUES (19, '20200010', '周敏', 'F', '医学院', '临床医学', '临床1班', 2020, 'WARNING', '2024-12-16 16:17:51', '2024-12-16 16:17:51');
INSERT INTO `student_info` VALUES (20, '20200011', '吴强', 'M', '体育学院', '体育教育', '体育1班', 2020, 'NORMAL', '2024-12-16 16:17:51', '2024-12-16 16:17:51');
INSERT INTO `student_info` VALUES (21, '20200012', '郑丽', 'F', '文学与新闻传播学院', '汉语言文学', '中文1班', 2020, 'PROBATION', '2024-12-16 16:17:51', '2024-12-16 16:17:51');
INSERT INTO `student_info` VALUES (22, '20200013', '冯华', 'M', '信息工程学院', '计算机科学与技术', '计科1班', 2020, 'NORMAL', '2024-12-16 16:17:51', '2024-12-16 16:17:51');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `config_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置值',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_config_key`(`config_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, 'WARNING_GRADE_THRESHOLD', '60', '成绩预警阈值', '2024-12-16 14:05:58', '2024-12-16 14:05:58');
INSERT INTO `sys_config` VALUES (2, 'WARNING_ATTENDANCE_THRESHOLD', '3', '考勤预警阈值（次/月）', '2024-12-16 14:05:58', '2024-12-16 14:05:58');
INSERT INTO `sys_config` VALUES (3, 'EMAIL_NOTIFICATION_ENABLED', 'true', '是否启用邮件通知', '2024-12-16 14:05:58', '2024-12-16 14:05:58');
INSERT INTO `sys_config` VALUES (4, 'SMS_NOTIFICATION_ENABLED', 'false', '是否启用短信通知', '2024-12-16 14:05:58', '2024-12-16 14:05:58');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色(ADMIN:管理员,TEACHER:教师,STUDENT:学生)',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态(0:禁用,1:正常)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', '管理员', NULL, NULL, NULL, 'ADMIN', 1, '2024-12-16 14:05:58', '2024-12-16 15:53:24');

-- ----------------------------
-- Table structure for warning_process
-- ----------------------------
DROP TABLE IF EXISTS `warning_process`;
CREATE TABLE `warning_process`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `warning_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预警编号',
  `process_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '处理方式(COUNSEL:辅导,NOTICE:通知,OTHER:其他)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '处理说明',
  `processor_id` bigint NOT NULL COMMENT '处理人ID',
  `process_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '处理时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_warning_id`(`warning_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预警处理记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of warning_process
-- ----------------------------
INSERT INTO `warning_process` VALUES (5, 'WR20240001', 'COUNSEL', '与学生进行了谈话，并建议改进考勤情况', 2, '2024-12-16 16:13:53', '2024-12-16 16:13:53', '2024-12-16 16:13:53');
INSERT INTO `warning_process` VALUES (6, 'WR20240002', 'NOTICE', '通知家长并要求加强监督', 2, '2024-12-16 16:13:53', '2024-12-16 16:13:53', '2024-12-16 16:13:53');

-- ----------------------------
-- Table structure for warning_record
-- ----------------------------
DROP TABLE IF EXISTS `warning_record`;
CREATE TABLE `warning_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `warning_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预警编号',
  `student_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学号',
  `student_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学生姓名',
  `college` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学院',
  `warning_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预警类型(GRADE:成绩,ATTENDANCE:考勤,BEHAVIOR:行为)',
  `warning_level` int NOT NULL COMMENT '预警等级(1:一级,2:二级,3:三级)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预警描述',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态(PENDING:待处理,PROCESSING:处理中,PROCESSED:已处理)',
  `create_user_id` bigint NOT NULL COMMENT '创建人ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_warning_id`(`warning_id` ASC) USING BTREE,
  INDEX `idx_student_id`(`student_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预警记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of warning_record
-- ----------------------------
INSERT INTO `warning_record` VALUES (15, 'WR20240001', '20200002', '王芳', '计算机学院', 'ATTENDANCE', 2, '连续三次缺勤', 'PENDING', 1, '2024-12-16 16:13:33', '2024-12-16 16:13:33');
INSERT INTO `warning_record` VALUES (16, 'WR20240002', '20200003', '赵强', '电子工程学院', 'GRADE', 3, '多门课程不及格', 'PROCESSING', 1, '2024-12-16 16:13:33', '2024-12-16 16:13:33');
INSERT INTO `warning_record` VALUES (17, 'WR20240003', '20200005', '刘洋', '管理学院', 'BEHAVIOR', 2, '在校内违反校规', 'PENDING', 1, '2024-12-16 16:16:11', '2024-12-16 16:16:11');
INSERT INTO `warning_record` VALUES (18, 'WR20240004', '20200007', '王霞', '艺术学院', 'GRADE', 3, '多门课程不及格', 'PROCESSING', 1, '2024-12-16 16:16:11', '2024-12-16 16:16:11');
INSERT INTO `warning_record` VALUES (19, 'WR20240005', '20200006', '张伟', '外国语学院', 'ATTENDANCE', 1, '一次缺勤', 'PROCESSED', 1, '2024-12-16 16:16:11', '2024-12-16 16:16:11');
INSERT INTO `warning_record` VALUES (20, 'WR20240006', '20200010', '周敏', '医学院', 'GRADE', 2, '考试成绩低于平均分', 'PENDING', 1, '2024-12-16 16:17:57', '2024-12-16 16:17:57');
INSERT INTO `warning_record` VALUES (21, 'WR20240007', '20200012', '郑丽', '文学与新闻传播学院', 'ATTENDANCE', 3, '频繁迟到早退', 'PROCESSING', 1, '2024-12-16 16:17:57', '2024-12-16 16:17:57');
INSERT INTO `warning_record` VALUES (22, 'WR20240008', '20200009', '孙斌', '理学院', 'BEHAVIOR', 1, '在课堂上使用手机', 'PROCESSED', 1, '2024-12-16 16:17:57', '2024-12-16 16:17:57');

SET FOREIGN_KEY_CHECKS = 1;
