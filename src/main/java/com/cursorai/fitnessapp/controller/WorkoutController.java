package com.cursorai.fitnessapp.controller;

import com.cursorai.fitnessapp.dto.UserWorkoutDto;
import com.cursorai.fitnessapp.dto.WorkoutDto;
import com.cursorai.fitnessapp.model.Workout;
import com.cursorai.fitnessapp.security.CustomUserDetails;
import com.cursorai.fitnessapp.service.WorkoutService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/workouts")
@RequiredArgsConstructor
@Tag(name = "Workouts", description = "Workout endpoints")
public class WorkoutController {
    
    private final WorkoutService workoutService;

    @GetMapping
    @Operation(summary = "Get all workouts")
    public ResponseEntity<List<WorkoutDto>> getAllWorkouts() {
        List<WorkoutDto> workouts = workoutService.getAllWorkouts();
        return ResponseEntity.ok(workouts);
    }

    @GetMapping("/level/{level}")
    @Operation(summary = "Get workouts by level")
    public ResponseEntity<List<WorkoutDto>> getWorkoutsByLevel(@PathVariable Workout.Level level) {
        List<WorkoutDto> workouts = workoutService.getWorkoutsByLevel(level);
        return ResponseEntity.ok(workouts);
    }

    @GetMapping("/my-workouts")
    @Operation(summary = "Get user's completed workouts", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<List<UserWorkoutDto>> getUserWorkouts(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        List<UserWorkoutDto> userWorkouts = workoutService.getUserWorkouts(userId);
        return ResponseEntity.ok(userWorkouts);
    }

    @PostMapping("/{workoutId}/complete")
    @Operation(summary = "Complete a workout", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<UserWorkoutDto> completeWorkout(
            @PathVariable Long workoutId,
            @RequestParam(required = false) Integer actualDuration,
            @RequestParam(required = false) Integer actualCalories,
            Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        UserWorkoutDto completedWorkout = workoutService.completeWorkout(userId, workoutId, actualDuration, actualCalories);
        return ResponseEntity.ok(completedWorkout);
    }

    @GetMapping("/{workoutId}/completed")
    @Operation(summary = "Check if workout is completed", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<Boolean> isWorkoutCompleted(@PathVariable Long workoutId, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        boolean isCompleted = workoutService.isWorkoutCompleted(userId, workoutId);
        return ResponseEntity.ok(isCompleted);
    }
}
