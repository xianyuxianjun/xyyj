package com.xyy.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.xyy.entity.StudentInfo;
import com.xyy.entity.WarningRecord;
import com.xyy.service.IStatisticsService;
import com.xyy.service.IStudentInfoService;
import com.xyy.service.IWarningRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
public class StatisticsServiceImpl implements IStatisticsService {
    @Autowired
    private IStudentInfoService studentInfoService;

    @Autowired
    private IWarningRecordService warningRecordService;

    @Override
    public Map<String, Object> getOverviewData() {
        Map<String, Object> data = new HashMap<>();
        
        // 获取总学生数
        long totalStudents = studentInfoService.count();
        
        // 获取预警学生数
        long warningStudents = studentInfoService.count(
            new QueryWrapper<StudentInfo>()
                .eq("status", "WARNING")
        );
        
        // 获取本月新增预警数
        LocalDateTime monthStart = LocalDateTime.now().withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
        long newWarnings = warningRecordService.count(
            new QueryWrapper<WarningRecord>()
                .ge("create_time", monthStart)
        );
        
        // 获取待处理预警数
        long pendingWarnings = warningRecordService.count(
            new QueryWrapper<WarningRecord>()
                .eq("status", "PENDING")
        );
        
        data.put("totalStudents", totalStudents);
        data.put("warningStudents", warningStudents);
        data.put("newWarnings", newWarnings);
        data.put("pendingWarnings", pendingWarnings);
        
        return data;
    }

    @Override
    public Map<String, Object> getTrendData(String type, String period) {
        // 实现趋势数据统计
        Map<String, Object> data = new HashMap<>();
        // ... 根据type和period参数统计不同时期的预警趋势
        return data;
    }

    @Override
    public Map<String, Object> getDistributionData() {
        // 实现分布数据统计
        Map<String, Object> data = new HashMap<>();
        // ... 统计各类预警的分布情况
        return data;
    }
} 