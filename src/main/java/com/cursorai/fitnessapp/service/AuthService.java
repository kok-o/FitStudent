package com.cursorai.fitnessapp.service;

import com.cursorai.fitnessapp.dto.AuthResponse;
import com.cursorai.fitnessapp.dto.LoginRequest;
import com.cursorai.fitnessapp.dto.RegisterRequest;
import com.cursorai.fitnessapp.exception.UserAlreadyExistsException;
import com.cursorai.fitnessapp.mapper.UserMapper;
import com.cursorai.fitnessapp.model.User;
import com.cursorai.fitnessapp.repository.UserRepository;
import com.cursorai.fitnessapp.security.JwtService;
import com.cursorai.fitnessapp.security.UserDetailsServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final UserDetailsServiceImpl userDetailsService;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new UserAlreadyExistsException("User with email " + request.getEmail() + " already exists");
        }

        User user = User.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .name(request.getName())
                .age(request.getAge())
                .gender(request.getGender())
                .height(request.getHeight())
                .weight(request.getWeight())
                .goal(request.getGoal())
                .activityLevel(request.getActivityLevel())
                .role(User.Role.STUDENT)
                .build();

        user = userRepository.save(user);
        String token = jwtService.generateToken(userDetailsService.loadUserByUsername(user.getEmail()));

        return AuthResponse.builder()
                .token(token)
                .user(userMapper.toDto(user))
                .build();
    }

    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid password");
        }

        String token = jwtService.generateToken(userDetailsService.loadUserByUsername(user.getEmail()));

        return AuthResponse.builder()
                .token(token)
                .user(userMapper.toDto(user))
                .build();
    }
}
