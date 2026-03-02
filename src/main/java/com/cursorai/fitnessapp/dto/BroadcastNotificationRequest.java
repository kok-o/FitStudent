package com.cursorai.fitnessapp.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BroadcastNotificationRequest {
    private String message;
    private String type; // SYSTEM, MOTIVATION, REMINDER
}
