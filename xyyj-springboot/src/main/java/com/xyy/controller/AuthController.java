package com.xyy.controller;

import com.xyy.common.Result;
import com.xyy.entity.SysUser;
import com.xyy.service.IAuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/auth")
@CrossOrigin
public class AuthController {
    @Autowired
    private IAuthService authService;

    @PostMapping("/login")
    public Result login(@RequestBody Map<String, String> loginForm) {
        String username = loginForm.get("username");
        String password = loginForm.get("password");
        return authService.login(username, password);
    }

    @GetMapping("/info")
    public Result getUserInfo(@RequestHeader("Authorization") String token) {
        return authService.getUserInfo(token);
    }

    @PostMapping("/logout")
    public Result logout() {
        return Result.success();
    }
} 