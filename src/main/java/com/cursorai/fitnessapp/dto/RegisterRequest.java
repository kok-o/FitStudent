package com.cursorai.fitnessapp.dto;

import com.cursorai.fitnessapp.model.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RegisterRequest {
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password must be at least 6 characters")
    private String password;

    @NotBlank(message = "Name is required")
    private String name;

    private Integer age;
    private String gender;
    private Double height;
    private Double weight;

    @NotNull(message = "Goal is required")
    private User.Goal goal;

    @NotNull(message = "Activity level is required")
    private User.ActivityLevel activityLevel;
}
