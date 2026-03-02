package com.cursorai.fitnessapp.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminWorkoutStatsDTO {
    private Long workoutId;
    private String title;
    private String level;
    private Long completionCount;
    private Double averageRating;
}
