package com.cursorai.fitnessapp.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;

    private String name;
    private Integer age;
    private String gender;
    private Double height;
    private Double weight;

    private String photoUrl;

    @Enumerated(EnumType.STRING)
    private Goal goal;

    @Enumerated(EnumType.STRING)
    private ActivityLevel activityLevel;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private Role role = Role.STUDENT;

    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    public enum Goal {
        LOSE, MAINTAIN, GAIN
    }

    public enum ActivityLevel {
        SEDENTARY, MODERATE, ACTIVE
    }

    public enum Role {
        STUDENT, ADMIN
    }
}
