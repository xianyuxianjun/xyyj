package com.xyy.controller;

import com.xyy.service.ISysConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * <p>
 * 系统配置表 前端控制器
 * </p>
 *
 * @author xyy
 * @since 2024-12-16
 */
@CrossOrigin
@RestController
@RequestMapping("/sysConfig")
public class SysConfigController {
    @Autowired
    private ISysConfigService sysConfigService;
}
