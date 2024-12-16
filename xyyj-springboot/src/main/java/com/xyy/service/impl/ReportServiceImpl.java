package com.xyy.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.xyy.entity.WarningRecord;
import com.xyy.service.IReportService;
import com.xyy.service.IWarningRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ReportServiceImpl implements IReportService {
    @Autowired
    private IWarningRecordService warningRecordService;

    @Override
    public Map<String, Object> getCollegeStats() {
        List<WarningRecord> records = warningRecordService.list();
        
        // 按学院分组统计
        Map<String, Long> collegeStats = records.stream()
            .filter(record -> record.getCollege() != null)  // 过滤掉没有学院信息的记录
            .collect(Collectors.groupingBy(
                WarningRecord::getCollege,
                Collectors.counting()
            ));

        Map<String, Object> result = new HashMap<>();
        result.put("colleges", collegeStats.keySet());
        result.put("values", collegeStats.values());
        return result;
    }

    @Override
    public Map<String, Object> getTypeStats() {
        List<WarningRecord> records = warningRecordService.list();
        
        // 预警类型映射
        Map<String, String> typeMapping = new HashMap<>();
        typeMapping.put("GRADE", "成绩预警");
        typeMapping.put("ATTENDANCE", "考勤预警");
        typeMapping.put("BEHAVIOR", "行为预警");
        
        // 按预警类型分组统计
        Map<String, Long> typeStats = records.stream()
            .filter(record -> record.getWarningType() != null)
            .collect(Collectors.groupingBy(
                record -> typeMapping.getOrDefault(record.getWarningType(), "其他预警"),
                Collectors.counting()
            ));

        Map<String, Object> result = new HashMap<>();
        result.put("types", typeStats.keySet());
        result.put("values", typeStats.values());
        return result;
    }

    @Override
    public Map<String, Object> getTrendStats(String period) {
        LocalDateTime startTime;
        LocalDateTime now = LocalDateTime.now();
        
        // 根据时间段获取数据
        switch (period) {
            case "week":
                startTime = now.minusWeeks(1);
                break;
            case "month":
                startTime = now.minusMonths(1);
                break;
            case "year":
                startTime = now.minusYears(1);
                break;
            default:
                startTime = now.minusMonths(1);
        }

        List<WarningRecord> records = warningRecordService.list(
            new QueryWrapper<WarningRecord>()
                .ge("create_time", startTime)
                .orderByAsc("create_time")
        );

        // 按时间分组统计
        Map<String, Long> trendStats = records.stream()
            .collect(Collectors.groupingBy(
                record -> record.getCreateTime().toLocalDate().toString(),
                Collectors.counting()
            ));

        Map<String, Object> result = new HashMap<>();
        result.put("dates", trendStats.keySet());
        result.put("values", trendStats.values());
        return result;
    }
} 