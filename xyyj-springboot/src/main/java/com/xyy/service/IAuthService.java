package com.xyy.service;

import com.xyy.common.Result;

public interface IAuthService {
    Result login(String username, String password);
    Result getUserInfo(String token);
} 