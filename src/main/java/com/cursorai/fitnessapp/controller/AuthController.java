package com.cursorai.fitnessapp.controller;

import com.cursorai.fitnessapp.dto.AuthResponse;
import com.cursorai.fitnessapp.dto.LoginRequest;
import com.cursorai.fitnessapp.dto.RegisterRequest;
import com.cursorai.fitnessapp.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
<<<<<<< HEAD
import lombok.extern.slf4j.Slf4j;
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "Authentication endpoints")
<<<<<<< HEAD
@Slf4j
public class AuthController {

=======
public class AuthController {
    
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
    private final AuthService authService;

    @PostMapping("/register")
    @Operation(summary = "Register a new user")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
<<<<<<< HEAD
        log.info("Registration attempt for email: {}", request.getEmail());
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
        AuthResponse response = authService.register(request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/login")
    @Operation(summary = "Login user")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
<<<<<<< HEAD
        log.info("Login attempt for email: {}", request.getEmail());
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(response);
    }
}
