package com.cursorai.fitnessapp.dto;

<<<<<<< HEAD
import com.fasterxml.jackson.annotation.JsonFormat;
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NutritionEntryDto {
    private Long id;
<<<<<<< HEAD
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
    private LocalDateTime timestamp;
    private String food;
    private Integer calories;
    private Double proteinG;
    private Double fatG;
    private Double carbsG;
}
