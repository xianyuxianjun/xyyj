package com.xyy.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.xyy.common.Result;
import com.xyy.entity.WarningProcess;
import com.xyy.entity.WarningRecord;
import com.xyy.service.IWarningProcessService;
import com.xyy.service.IWarningRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

/**
 * <p>
 * 预警处理记录表 前端控制器
 * </p>
 *
 * @author xyy
 * @since 2024-12-16
 */
@CrossOrigin
@RestController
@RequestMapping("/warningProcess")
public class WarningProcessController {
    @Autowired
    private IWarningProcessService warningProcessService;
    
    @Autowired
    private IWarningRecordService warningRecordService;

    @PostMapping("/create")
    @Transactional
    public Result create(@RequestBody WarningProcess warningProcess) {
        try {
            // 验证预警记录是否存在
            WarningRecord warningRecord = warningRecordService.getOne(
                new QueryWrapper<WarningRecord>()
                    .eq("warning_id", warningProcess.getWarningId())
            );
            
            if (warningRecord == null) {
                return Result.error("预警记录不存在");
            }
            
            // 设置处理时间
            warningProcess.setProcessTime(LocalDateTime.now());
            // 设置处理人ID（这里暂时写死，后续需要从登录用户中获取）
            warningProcess.setProcessorId(1L);
            // 设置创建时间
            warningProcess.setCreateTime(LocalDateTime.now());
            
            // 保存处理记录
            warningProcessService.save(warningProcess);
            
            // 更新预警状态
            warningRecord.setStatus("PROCESSED");
            warningRecordService.updateById(warningRecord);
            
            return Result.success();
        } catch (Exception e) {
            return Result.error("创建处理记录失败：" + e.getMessage());
        }
    }

    @GetMapping("/list/{warningId}")
    public Result getProcessList(@PathVariable String warningId) {
        return Result.success(
            warningProcessService.list(
                new QueryWrapper<WarningProcess>()
                    .eq("warning_id", warningId)
                    .orderByDesc("process_time")
            )
        );
    }
}
