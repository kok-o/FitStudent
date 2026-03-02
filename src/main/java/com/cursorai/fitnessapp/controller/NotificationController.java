package com.cursorai.fitnessapp.controller;

import com.cursorai.fitnessapp.dto.NotificationDto;
import com.cursorai.fitnessapp.security.CustomUserDetails;
import com.cursorai.fitnessapp.service.NotificationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
@Tag(name = "Notifications", description = "Notification endpoints")
public class NotificationController {
    
    private final NotificationService notificationService;

    @GetMapping
    @Operation(summary = "Get user notifications", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<List<NotificationDto>> getUserNotifications(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        List<NotificationDto> notifications = notificationService.getUserNotifications(userId);
        return ResponseEntity.ok(notifications);
    }

    @GetMapping("/unread")
    @Operation(summary = "Get unread notifications", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<List<NotificationDto>> getUnreadNotifications(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        List<NotificationDto> notifications = notificationService.getUnreadNotifications(userId);
        return ResponseEntity.ok(notifications);
    }

    @GetMapping("/unread-count")
    @Operation(summary = "Get unread notifications count", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<Long> getUnreadCount(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        long count = notificationService.getUnreadCount(userId);
        return ResponseEntity.ok(count);
    }

    @PutMapping("/{notificationId}/read")
    @Operation(summary = "Mark notification as read", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<NotificationDto> markAsRead(@PathVariable Long notificationId, Authentication authentication) {
        NotificationDto notification = notificationService.markAsRead(notificationId);
        return ResponseEntity.ok(notification);
    }
}
