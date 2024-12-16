package com.xyy.controller;

import com.xyy.common.Result;
import com.xyy.service.IStatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@CrossOrigin
@RestController
@RequestMapping("/statistics")
public class StatisticsController {
    @Autowired
    private IStatisticsService statisticsService;

    @GetMapping("/overview")
    public Result getOverview() {
        Map<String, Object> data = statisticsService.getOverviewData();
        return Result.success(data);
    }

    @GetMapping("/trend")
    public Result getTrend(@RequestParam(required = false) String type,
                          @RequestParam(required = false) String period) {
        Map<String, Object> data = statisticsService.getTrendData(type, period);
        return Result.success(data);
    }

    @GetMapping("/distribution")
    public Result getDistribution() {
        Map<String, Object> data = statisticsService.getDistributionData();
        return Result.success(data);
    }
} 