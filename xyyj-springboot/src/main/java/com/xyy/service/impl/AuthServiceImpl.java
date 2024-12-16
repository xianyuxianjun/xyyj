package com.xyy.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.xyy.common.Result;
import com.xyy.entity.SysUser;
import com.xyy.service.IAuthService;
import com.xyy.service.ISysUserService;
import com.xyy.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import java.util.HashMap;
import java.util.Map;

@Service
public class AuthServiceImpl implements IAuthService {
    @Autowired
    private ISysUserService sysUserService;

    @Override
    public Result login(String username, String password) {
        // 查询用户
        SysUser user = sysUserService.getOne(
            new QueryWrapper<SysUser>()
                .eq("username", username)
        );

        if (user == null) {
            return Result.error("用户不存在");
        }

        // 添加日志输出，用于调试
        System.out.println("Input password: " + password);
        System.out.println("Encoded password: " + DigestUtils.md5DigestAsHex(password.getBytes()));
        System.out.println("DB password: " + user.getPassword());

        // 验证密码
        String encodedPassword = DigestUtils.md5DigestAsHex(password.getBytes());
        if (!encodedPassword.equals(user.getPassword())) {
            return Result.error("密码错误");
        }

        // 生成token
        String token = JwtUtil.generateToken(user.getId());

        // 返回结果
        Map<String, Object> data = new HashMap<>();
        data.put("token", token);
        
        Map<String, Object> userInfo = new HashMap<>();
        userInfo.put("id", user.getId());
        userInfo.put("username", user.getUsername());
        userInfo.put("name", user.getRealName());
        userInfo.put("role", user.getRole());
        data.put("userInfo", userInfo);

        return Result.success(data);
    }

    @Override
    public Result getUserInfo(String token) {
        try {
            Long userId = JwtUtil.validateToken(token);
            SysUser user = sysUserService.getById(userId);
            if (user == null) {
                return Result.error("用户不存在");
            }

            Map<String, Object> userInfo = new HashMap<>();
            userInfo.put("id", user.getId());
            userInfo.put("username", user.getUsername());
            userInfo.put("name", user.getRealName());
            userInfo.put("role", user.getRole());

            return Result.success(userInfo);
        } catch (Exception e) {
            return Result.error("token无效");
        }
    }
} 