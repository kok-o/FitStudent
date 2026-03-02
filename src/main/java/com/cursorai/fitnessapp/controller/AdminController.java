package com.cursorai.fitnessapp.controller;

import com.cursorai.fitnessapp.dto.*;
import com.cursorai.fitnessapp.model.User;
import com.cursorai.fitnessapp.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {

    private final AdminService adminService;

    // User Management
    @GetMapping("/users")
    public ResponseEntity<Page<AdminUserDTO>> getAllUsers(Pageable pageable) {
        return ResponseEntity.ok(adminService.getAllUsers(pageable));
    }

    @GetMapping("/users/{userId}")
    public ResponseEntity<AdminUserDTO> getUserDetails(@PathVariable Long userId) {
        return ResponseEntity.ok(adminService.getUserDetails(userId));
    }

    @PutMapping("/users/{userId}/role")
    public ResponseEntity<Void> updateUserRole(
            @PathVariable Long userId,
            @RequestParam String role) {
        User.Role newRole = User.Role.valueOf(role.toUpperCase());
        adminService.updateUserRole(userId, newRole);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/users/{userId}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long userId) {
        adminService.deleteUser(userId);
        return ResponseEntity.ok().build();
    }

    // Statistics
    @GetMapping("/statistics/users")
    public ResponseEntity<AdminUserStatsDTO> getUserStatistics() {
        return ResponseEntity.ok(adminService.getUserStatistics());
    }

    @GetMapping("/statistics/workouts")
    public ResponseEntity<List<AdminWorkoutStatsDTO>> getWorkoutStatistics() {
        return ResponseEntity.ok(adminService.getWorkoutStatistics());
    }

    // Notifications
    @PostMapping("/notifications/broadcast")
    public ResponseEntity<Void> broadcastNotification(
            @RequestBody BroadcastNotificationRequest request) {
        adminService.broadcastNotification(request);
        return ResponseEntity.ok().build();
    }
}
