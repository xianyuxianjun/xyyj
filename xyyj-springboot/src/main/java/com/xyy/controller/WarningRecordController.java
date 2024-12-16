package com.xyy.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.xyy.common.Result;
import com.xyy.entity.StudentInfo;
import com.xyy.entity.WarningRecord;
import com.xyy.service.IStudentInfoService;
import com.xyy.service.IWarningRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

/**
 * <p>
 * 预警记录表 前端控制器
 * </p>
 *
 * @author xyy
 * @since 2024-12-16
 */
@CrossOrigin
@RestController
@RequestMapping("/warningRecord")
public class WarningRecordController {
    @Autowired
    private IWarningRecordService warningRecordService;

    @Autowired
    private IStudentInfoService studentInfoService;

    @GetMapping("/list")
    public Result list(@RequestParam(required = false) String keyword,
                      @RequestParam(required = false) String warningType,
                      @RequestParam(required = false) String level,
                      @RequestParam(required = false) String status) {
        QueryWrapper<WarningRecord> queryWrapper = new QueryWrapper<>();
        
        if (StringUtils.hasText(keyword)) {
            queryWrapper.like("student_name", keyword)
                    .or()
                    .like("student_id", keyword);
        }
        if (StringUtils.hasText(warningType)) {
            queryWrapper.eq("warning_type", warningType);
        }
        if (StringUtils.hasText(level)) {
            queryWrapper.eq("warning_level", level);
        }
        if (StringUtils.hasText(status)) {
            queryWrapper.eq("status", status);
        }
        
        // 按创建时间倒序排序
        queryWrapper.orderByDesc("create_time");
        
        return Result.success(warningRecordService.list(queryWrapper));
    }

    @PostMapping("/create")
    public Result create(@RequestBody WarningRecord warningRecord) {
        try {
            // 验证学生信息
            StudentInfo student = studentInfoService.getOne(
                new QueryWrapper<StudentInfo>()
                    .eq("student_id", warningRecord.getStudentId())
            );
            
            if (student == null) {
                return Result.error("学生不存在");
            }
            
            // 设置预警编号
            warningRecord.setWarningId(generateWarningId());
            // 设置学生姓名
            warningRecord.setStudentName(student.getName());
            // 设置学院
            warningRecord.setCollege(student.getCollege());
            // 设置初始状态
            warningRecord.setStatus("PENDING");
            // 设置创建人ID（这里暂时写死，后续需要从登录用户中获取）
            warningRecord.setCreateUserId(1L);
            // 设置创建时间
            warningRecord.setCreateTime(LocalDateTime.now());
            
            warningRecordService.save(warningRecord);
            return Result.success();
        } catch (Exception e) {
            return Result.error("创建预警失败：" + e.getMessage());
        }
    }

    @PutMapping("/update")
    public Result update(@RequestBody WarningRecord warningRecord) {
        warningRecordService.updateById(warningRecord);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Long id) {
        warningRecordService.removeById(id);
        return Result.success();
    }

    // 生成预警编号
    private String generateWarningId() {
        // 格式：W + 年月 + 3位序号
        return "W" + System.currentTimeMillis();
    }
}
