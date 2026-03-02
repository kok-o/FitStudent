package com.cursorai.fitnessapp.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserWorkoutDto {
    private Long id;
    private WorkoutDto workout;
    private LocalDateTime completedAt;
    private Integer actualDuration;
    private Integer actualCalories;
}
