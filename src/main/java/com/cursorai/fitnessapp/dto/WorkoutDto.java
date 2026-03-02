package com.cursorai.fitnessapp.dto;

import com.cursorai.fitnessapp.model.Workout;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WorkoutDto {
    private Long id;
    private String title;
    private String description;
    private Workout.Level level;
    private Integer duration;
    private Integer calories;
    private List<String> exercises;
}
