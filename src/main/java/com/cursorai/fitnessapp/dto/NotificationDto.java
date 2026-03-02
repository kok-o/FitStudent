package com.cursorai.fitnessapp.dto;

import com.cursorai.fitnessapp.model.Notification;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NotificationDto {
    private Long id;
    private String message;
    private Notification.Type type;
    private Boolean isRead;
    private LocalDateTime createdAt;
}
