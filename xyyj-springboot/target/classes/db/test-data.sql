-- 插入系统用户测试数据
INSERT INTO sys_user (username, password, real_name, role, status) VALUES
('admin', '$2a$10$X/hX6J2POWwGEwXvP1X9XOeYl3UpzKG/ZeWB/KgwIoLyEj8.KP4Uy', '管理员', 'ADMIN', 1),
('teacher1', '$2a$10$X/hX6J2POWwGEwXvP1X9XOeYl3UpzKG/ZeWB/KgwIoLyEj8.KP4Uy', '张老师', 'TEACHER', 1),
('student1', '$2a$10$X/hX6J2POWwGEwXvP1X9XOeYl3UpzKG/ZeWB/KgwIoLyEj8.KP4Uy', '李明', 'STUDENT', 1);

-- 插入学生信息测试数据
INSERT INTO student_info (student_id, name, gender, college, major, class_name, admission_year, status) VALUES
('2021001', '李明', 'M', '计算机学院', '软件工程', '软工2101', 2021, 'NORMAL'),
('2021002', '王芳', 'F', '计算机学院', '软件工程', '软工2101', 2021, 'WARNING'),
('2021003', '张伟', 'M', '机械工程学院', '机械设计', '机械2101', 2021, 'NORMAL'),
('2021004', '赵静', 'F', '经济管理学院', '工商管理', '工管2101', 2021, 'PROBATION'),
('2021005', '刘强', 'M', '计算机学院', '计算机科学', '计科2101', 2021, 'WARNING');

-- 插入预警记录测试数据
INSERT INTO warning_record (warning_id, student_id, warning_type, warning_level, description, status, create_user_id) VALUES
('W202401001', '2021002', 'GRADE', 1, '期末考试3门课程不及格', 'PENDING', 2),
('W202401002', '2021004', 'ATTENDANCE', 2, '本月旷课次数超过3次', 'PROCESSING', 2),
('W202401003', '2021005', 'BEHAVIOR', 1, '多次违反课堂纪律', 'PROCESSED', 2),
('W202401004', '2021002', 'GRADE', 2, '期中考试平均分低于60分', 'PENDING', 2),
('W202401005', '2021004', 'ATTENDANCE', 3, '连续两周未到课', 'PROCESSED', 2);

-- 插入预警处理记录测试数据
INSERT INTO warning_process (warning_id, process_type, description, processor_id) VALUES
('W202401003', 'COUNSEL', '已与学生谈话并制定学习计划', 2),
('W202401005', 'NOTICE', '已通知家长，并与班主任沟通', 2);

-- 插入系统配置测试数据
INSERT INTO sys_config (config_key, config_value, description) VALUES
('WARNING_GRADE_THRESHOLD', '60', '成绩预警阈值'),
('WARNING_ATTENDANCE_THRESHOLD', '3', '考勤预警阈值（次/月）'),
('EMAIL_NOTIFICATION_ENABLED', 'true', '是否启用邮件通知'),
('SMS_NOTIFICATION_ENABLED', 'false', '是否启用短信通知'); 