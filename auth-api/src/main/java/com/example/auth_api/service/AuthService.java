package com.example.auth_api.service;

import com.example.auth_api.dto.*;
import com.example.auth_api.model.User;
import com.example.auth_api.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired private UserRepository userRepository;
    @Autowired private PasswordEncoder passwordEncoder;

    public AuthResponse register(RegisterRequest req) {
        if (userRepository.existsByUsername(req.getUsername()))
            return new AuthResponse(false, "Username already taken", null);
        if (userRepository.existsByEmail(req.getEmail()))
            return new AuthResponse(false, "Email already registered", null);

        User user = new User();
        user.setUsername(req.getUsername());
        user.setEmail(req.getEmail());
        user.setPassword(passwordEncoder.encode(req.getPassword()));
        userRepository.save(user);

        return new AuthResponse(true, "Registration successful!", req.getUsername());
    }

    public AuthResponse login(LoginRequest req) {
        return userRepository.findByUsername(req.getUsername())
            .filter(u -> passwordEncoder.matches(req.getPassword(), u.getPassword()))
            .map(u -> new AuthResponse(true, "Login successful!", u.getUsername()))
            .orElse(new AuthResponse(false, "Invalid username or password", null));
    }
}