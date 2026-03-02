package com.cursorai.fitnessapp.service;

import com.cursorai.fitnessapp.dto.UserWorkoutDto;
import com.cursorai.fitnessapp.dto.WorkoutDto;
import com.cursorai.fitnessapp.mapper.UserWorkoutMapper;
import com.cursorai.fitnessapp.mapper.WorkoutMapper;
import com.cursorai.fitnessapp.model.User;
import com.cursorai.fitnessapp.model.UserWorkout;
import com.cursorai.fitnessapp.model.Workout;
import com.cursorai.fitnessapp.repository.UserRepository;
import com.cursorai.fitnessapp.repository.UserWorkoutRepository;
import com.cursorai.fitnessapp.repository.WorkoutRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import com.cursorai.fitnessapp.model.ActivityLog;
import com.cursorai.fitnessapp.repository.ActivityLogRepository;

@Service
@RequiredArgsConstructor
public class WorkoutService {

        private final WorkoutRepository workoutRepository;
        private final UserWorkoutRepository userWorkoutRepository;
        private final UserRepository userRepository;
        private final ActivityLogRepository activityLogRepository;
        private final WorkoutMapper workoutMapper;
        private final UserWorkoutMapper userWorkoutMapper;

        public List<WorkoutDto> getAllWorkouts() {
                return workoutRepository.findAll()
                                .stream()
                                .map(workoutMapper::toDto)
                                .collect(Collectors.toList());
        }

        public List<WorkoutDto> getWorkoutsByLevel(Workout.Level level) {
                return workoutRepository.findByLevel(level)
                                .stream()
                                .map(workoutMapper::toDto)
                                .collect(Collectors.toList());
        }

        public List<UserWorkoutDto> getUserWorkouts(Long userId) {
                User user = userRepository.findById(userId)
                                .orElseThrow(() -> new RuntimeException("User not found"));

                return userWorkoutRepository.findByUserOrderByCompletedAtDesc(user)
                                .stream()
                                .map(userWorkoutMapper::toDto)
                                .collect(Collectors.toList());
        }

        @Transactional
        public UserWorkoutDto completeWorkout(Long userId, Long workoutId, Integer actualDuration,
                        Integer actualCalories) {
                User user = userRepository.findById(userId)
                                .orElseThrow(() -> new RuntimeException("User not found"));

                Workout workout = workoutRepository.findById(workoutId)
                                .orElseThrow(() -> new RuntimeException("Workout not found"));

                UserWorkout userWorkout = UserWorkout.builder()
                                .user(user)
                                .workout(workout)
                                .completedAt(LocalDateTime.now())
                                .actualDuration(actualDuration)
                                .actualCalories(actualCalories)
                                .build();

                userWorkout = userWorkoutRepository.save(userWorkout);

                // Update ActivityLog for the day
                updateActivityLog(user, actualCalories != null ? actualCalories : workout.getCalories());

                return userWorkoutMapper.toDto(userWorkout);
        }

        private void updateActivityLog(User user, Integer calories) {
                if (calories == null)
                        calories = 0;
                LocalDate today = LocalDate.now();
                ActivityLog log = activityLogRepository.findByUserAndDate(user, today)
                                .orElseGet(() -> ActivityLog.builder()
                                                .user(user)
                                                .date(today)
                                                .steps(0)
                                                .calories(0)
                                                .sleepHours(0.0)
                                                .build());

                log.setCalories(log.getCalories() + calories);
                activityLogRepository.save(log);
        }

        public boolean isWorkoutCompleted(Long userId, Long workoutId) {
                User user = userRepository.findById(userId)
                                .orElseThrow(() -> new RuntimeException("User not found"));

                return userWorkoutRepository.existsByUserAndWorkoutId(user, workoutId);
        }
}
