package com.example.auth_api.dto;
import lombok.Data;
import lombok.AllArgsConstructor;

@Data
@AllArgsConstructor
public class AuthResponse {
    private boolean success;
    private String message;
    private String username;
}