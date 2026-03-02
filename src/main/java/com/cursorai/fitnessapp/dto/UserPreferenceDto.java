package com.cursorai.fitnessapp.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserPreferenceDto {
    private String preferredTrainingTypes; // comma-separated
    private String preferredTimeOfDay; // morning | afternoon | evening
    private String equipment; // comma-separated
}
