package com.cursorai.fitnessapp.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FoodCheckResponse {
    private String status; // ALLOWED, LIMITED, FORBIDDEN
    private String reason;
    private List<FoodReplacementDto> replacements;
}
