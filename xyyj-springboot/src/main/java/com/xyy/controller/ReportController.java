package com.xyy.controller;

import com.xyy.common.Result;
import com.xyy.service.IReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@CrossOrigin
@RestController
@RequestMapping("/report")
public class ReportController {
    @Autowired
    private IReportService reportService;

    @GetMapping("/college")
    public Result getCollegeStats() {
        return Result.success(reportService.getCollegeStats());
    }

    @GetMapping("/type")
    public Result getTypeStats() {
        return Result.success(reportService.getTypeStats());
    }

    @GetMapping("/trend")
    public Result getTrendStats(@RequestParam(required = false) String period) {
        return Result.success(reportService.getTrendStats(period));
    }
} 