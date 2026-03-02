package com.cursorai.fitnessapp.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MedicalProfileDto {
    private Set<String> diagnoses;
    private Set<String> allergies;
    private String contraindications;
    private Integer activityLevel;
}
