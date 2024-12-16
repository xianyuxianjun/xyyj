package com.xyy.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.xyy.common.Result;
import com.xyy.entity.StudentInfo;
import com.xyy.service.IStudentInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * <p>
 * 学生信息表 前端控制器
 * </p>
 *
 * @author xyy
 * @since 2024-12-16
 */
@CrossOrigin
@RestController
@RequestMapping("/studentInfo")
public class StudentInfoController {
    @Autowired
    private IStudentInfoService studentInfoService;

    @GetMapping("/list")
    public Result list(@RequestParam(required = false) String keyword,
                      @RequestParam(required = false) String college) {
        try {
            QueryWrapper<StudentInfo> queryWrapper = new QueryWrapper<>();
            
            // 添加查询条件
            if (StringUtils.hasText(keyword)) {
                // 使用括号包裹OR条件
                queryWrapper.and(wrapper -> wrapper
                    .like("name", keyword)
                    .or()
                    .like("student_id", keyword));
            }
            
            if (StringUtils.hasText(college)) {
                queryWrapper.eq("college", college);
            }
            
            // 按学号排序
            queryWrapper.orderByAsc("student_id");
            
            List<StudentInfo> list = studentInfoService.list(queryWrapper);
            return Result.success(list);
        } catch (Exception e) {
            return Result.error("获取学生列表失败：" + e.getMessage());
        }
    }

    @PostMapping("/create")
    public Result create(@RequestBody StudentInfo studentInfo) {
        studentInfoService.save(studentInfo);
        return Result.success();
    }

    @PutMapping("/update")
    public Result update(@RequestBody StudentInfo studentInfo) {
        studentInfoService.updateById(studentInfo);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        studentInfoService.removeById(id);
        return Result.success();
    }
}
