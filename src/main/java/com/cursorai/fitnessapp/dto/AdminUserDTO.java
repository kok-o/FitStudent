package com.cursorai.fitnessapp.dto;

import com.cursorai.fitnessapp.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminUserDTO {
    private Long id;
    private String email;
    private String name;
    private Integer age;
    private String gender;
    private User.Role role;
    private LocalDateTime createdAt;
    private Long totalWorkouts;
    private LocalDateTime lastActivity;
}
