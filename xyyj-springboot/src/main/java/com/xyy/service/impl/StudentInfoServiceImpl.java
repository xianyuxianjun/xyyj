package com.xyy.service.impl;

import com.xyy.entity.StudentInfo;
import com.xyy.mapper.StudentInfoMapper;
import com.xyy.service.IStudentInfoService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 学生信息表 服务实现类
 * </p>
 *
 * @author xyy
 * @since 2024-12-16
 */
@Service
public class StudentInfoServiceImpl extends ServiceImpl<StudentInfoMapper, StudentInfo> implements IStudentInfoService {

}
