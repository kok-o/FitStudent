package com.cursorai.fitnessapp.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SupportMessageDto {
    private Long id;
    private Long userId;
    private String userName;
    private String message;
    private String timestamp;
    private boolean read;
    private boolean adminMessage;
}
