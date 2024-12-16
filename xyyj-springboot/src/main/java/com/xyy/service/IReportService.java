package com.xyy.service;

import java.util.Map;

public interface IReportService {
    Map<String, Object> getCollegeStats();
    Map<String, Object> getTypeStats();
    Map<String, Object> getTrendStats(String period);
} 