package com.xyy.service;

import java.util.Map;

public interface IStatisticsService {
    Map<String, Object> getOverviewData();
    Map<String, Object> getTrendData(String type, String period);
    Map<String, Object> getDistributionData();
} 