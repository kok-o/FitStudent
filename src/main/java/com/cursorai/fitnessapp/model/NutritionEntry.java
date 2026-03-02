package com.cursorai.fitnessapp.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "nutrition_entries")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NutritionEntry {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private LocalDateTime timestamp;
    @Column(columnDefinition = "TEXT")
    private String food;
    private Integer calories;
    private Double proteinG;
    private Double fatG;
    private Double carbsG;
}
