package com.cursorai.fitnessapp.dto;

import com.cursorai.fitnessapp.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDto {
    private Long id;
    private String email;
    private String name;
    private Integer age;
    private String gender;
    private Double height;
    private Double weight;
    private String photoUrl;
    private User.Goal goal;
    private User.ActivityLevel activityLevel;
    private User.Role role;
    private LocalDateTime createdAt;
}
