package com.cursorai.fitnessapp.service;

import com.cursorai.fitnessapp.dto.*;
import com.cursorai.fitnessapp.model.*;
import com.cursorai.fitnessapp.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final UserRepository userRepository;
    private final UserWorkoutRepository userWorkoutRepository;
    private final WorkoutRepository workoutRepository;
    private final NotificationRepository notificationRepository;
    private final ActivityLogRepository activityLogRepository;

    // User Management
    @Transactional(readOnly = true)
    public Page<AdminUserDTO> getAllUsers(Pageable pageable) {
        return userRepository.findAll(pageable).map(this::convertToAdminUserDTO);
    }

    @Transactional(readOnly = true)
    public AdminUserDTO getUserDetails(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return convertToAdminUserDTO(user);
    }

    @Transactional
    public void updateUserRole(Long userId, User.Role newRole) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        user.setRole(newRole);
        userRepository.save(user);
    }

    @Transactional
    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }

    // Statistics
    @Transactional(readOnly = true)
    public AdminUserStatsDTO getUserStatistics() {
        long totalUsers = userRepository.count();
        
        LocalDateTime today = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
        LocalDateTime weekAgo = LocalDateTime.now().minusWeeks(1);
        LocalDateTime monthAgo = LocalDateTime.now().minusMonths(1);

        // Count active users (users with activity logs)
        long activeToday = activityLogRepository.findAll().stream()
                .filter(log -> log.getDate().isEqual(today.toLocalDate()))
                .map(ActivityLog::getUser)
                .distinct()
                .count();

        long activeThisWeek = activityLogRepository.findAll().stream()
                .filter(log -> log.getDate().isAfter(weekAgo.toLocalDate()) || log.getDate().isEqual(weekAgo.toLocalDate()))
                .map(ActivityLog::getUser)
                .distinct()
                .count();

        long newUsersThisMonth = userRepository.findAll().stream()
                .filter(user -> user.getCreatedAt().isAfter(monthAgo))
                .count();

        double avgWorkouts = userRepository.count() > 0 
                ? (double) userWorkoutRepository.count() / userRepository.count() 
                : 0.0;

        return AdminUserStatsDTO.builder()
                .totalUsers(totalUsers)
                .activeUsersToday(activeToday)
                .activeUsersThisWeek(activeThisWeek)
                .newUsersThisMonth(newUsersThisMonth)
                .averageWorkoutsPerUser(avgWorkouts)
                .build();
    }

    @Transactional(readOnly = true)
    public List<AdminWorkoutStatsDTO> getWorkoutStatistics() {
        List<Workout> workouts = workoutRepository.findAll();
        
        return workouts.stream()
                .map(workout -> {
                    long completionCount = userWorkoutRepository.findAll().stream()
                            .filter(uw -> uw.getWorkout().getId().equals(workout.getId()))
                            .count();
                    
                    return AdminWorkoutStatsDTO.builder()
                            .workoutId(workout.getId())
                            .title(workout.getTitle())
                            .level(workout.getLevel().toString())
                            .completionCount(completionCount)
                            .averageRating(0.0) // Can be extended with rating system
                            .build();
                })
                .sorted((a, b) -> Long.compare(b.getCompletionCount(), a.getCompletionCount()))
                .collect(Collectors.toList());
    }

    // Notifications
    @Transactional
    public void broadcastNotification(BroadcastNotificationRequest request) {
        List<User> allUsers = userRepository.findAll();
        
        Notification.Type notificationType = Notification.Type.SYSTEM;
        try {
            notificationType = Notification.Type.valueOf(request.getType().toUpperCase());
        } catch (IllegalArgumentException e) {
            // Use default SYSTEM type
        }

        final Notification.Type finalNotificationType = notificationType;
        List<Notification> notifications = allUsers.stream()
                .map(user -> Notification.builder()
                        .user(user)
                        .message(request.getMessage())
                        .type(finalNotificationType)
                        .isRead(false)
                        .build())
                .collect(Collectors.toList());

        notificationRepository.saveAll(notifications);
    }

    // Helper methods
    private AdminUserDTO convertToAdminUserDTO(User user) {
        long totalWorkouts = userWorkoutRepository.findByUserOrderByCompletedAtDesc(user).size();
        
        LocalDateTime lastActivity = userWorkoutRepository.findByUserOrderByCompletedAtDesc(user)
                .stream()
                .findFirst()
                .map(UserWorkout::getCompletedAt)
                .orElse(null);

        return AdminUserDTO.builder()
                .id(user.getId())
                .email(user.getEmail())
                .name(user.getName())
                .age(user.getAge())
                .gender(user.getGender())
                .role(user.getRole())
                .createdAt(user.getCreatedAt())
                .totalWorkouts(totalWorkouts)
                .lastActivity(lastActivity)
                .build();
    }
}
