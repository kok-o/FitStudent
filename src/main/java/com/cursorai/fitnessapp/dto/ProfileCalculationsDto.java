package com.cursorai.fitnessapp.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProfileCalculationsDto {
    private Double bmi;
    private Double bmr;
    private Double tdee;
    private Double targetCalories;
    private Double proteinG;
    private Double fatG;
    private Double carbsG;
}
