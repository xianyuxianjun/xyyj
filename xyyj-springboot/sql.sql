-- 用户表
CREATE TABLE `sys_user` (
                            `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                            `username` varchar(50) NOT NULL COMMENT '用户名',
                            `password` varchar(100) NOT NULL COMMENT '密码',
                            `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
                            `avatar` varchar(200) DEFAULT NULL COMMENT '头像URL',
                            `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
                            `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
                            `role` varchar(20) NOT NULL COMMENT '角色(ADMIN:管理员,TEACHER:教师,STUDENT:学生)',
                            `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态(0:禁用,1:正常)',
                            `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                            `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表';

-- 学生信息表
CREATE TABLE `student_info` (
                                `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                `student_id` varchar(20) NOT NULL COMMENT '学号',
                                `name` varchar(50) NOT NULL COMMENT '姓名',
                                `gender` char(1) NOT NULL COMMENT '性别(M:男,F:女)',
                                `college` varchar(50) NOT NULL COMMENT '学院',
                                `major` varchar(50) NOT NULL COMMENT '专业',
                                `class_name` varchar(50) NOT NULL COMMENT '班级',
                                `admission_year` int NOT NULL COMMENT '入学年份',
                                `status` varchar(20) NOT NULL DEFAULT 'NORMAL' COMMENT '状态(NORMAL:正常,WARNING:预警,PROBATION:留校察看)',
                                `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                PRIMARY KEY (`id`),
                                UNIQUE KEY `uk_student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生信息表';

-- 预警记录表
CREATE TABLE `warning_record` (
                                  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                  `warning_id` varchar(20) NOT NULL COMMENT '预警编号',
                                  `student_id` varchar(20) NOT NULL COMMENT '学号',
                                  `warning_type` varchar(20) NOT NULL COMMENT '预警类型(GRADE:成绩,ATTENDANCE:考勤,BEHAVIOR:行为)',
                                  `warning_level` tinyint NOT NULL COMMENT '预警等级(1:一级,2:二级,3:三级)',
                                  `description` text NOT NULL COMMENT '预警描述',
                                  `status` varchar(20) NOT NULL COMMENT '状态(PENDING:待处理,PROCESSING:处理中,PROCESSED:已处理)',
                                  `create_user_id` bigint NOT NULL COMMENT '创建人ID',
                                  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                  PRIMARY KEY (`id`),
                                  UNIQUE KEY `uk_warning_id` (`warning_id`),
                                  KEY `idx_student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预警记录表';

-- 预警处理记录表
CREATE TABLE `warning_process` (
                                   `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                   `warning_id` varchar(20) NOT NULL COMMENT '预警编号',
                                   `process_type` varchar(20) NOT NULL COMMENT '处理方式(COUNSEL:辅导,NOTICE:通知,OTHER:其他)',
                                   `description` text NOT NULL COMMENT '处理说明',
                                   `processor_id` bigint NOT NULL COMMENT '处理人ID',
                                   `process_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '处理时间',
                                   `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                   `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                   PRIMARY KEY (`id`),
                                   KEY `idx_warning_id` (`warning_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预警处理记录表';

-- 附件表
CREATE TABLE `attachment` (
                              `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                              `business_id` varchar(20) NOT NULL COMMENT '业务ID',
                              `business_type` varchar(20) NOT NULL COMMENT '业务类型(WARNING:预警记录,PROCESS:处理记录)',
                              `file_name` varchar(200) NOT NULL COMMENT '文件名',
                              `file_path` varchar(500) NOT NULL COMMENT '文件路径',
                              `file_size` bigint NOT NULL COMMENT '文件大小(字节)',
                              `file_type` varchar(50) NOT NULL COMMENT '文件类型',
                              `upload_user_id` bigint NOT NULL COMMENT '上传人ID',
                              `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                              `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                              PRIMARY KEY (`id`),
                              KEY `idx_business` (`business_id`,`business_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='附件表';

-- 系统配置表
CREATE TABLE `sys_config` (
                              `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                              `config_key` varchar(50) NOT NULL COMMENT '配置键',
                              `config_value` text NOT NULL COMMENT '配置值',
                              `description` varchar(200) DEFAULT NULL COMMENT '描述',
                              `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                              `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                              PRIMARY KEY (`id`),
                              UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';