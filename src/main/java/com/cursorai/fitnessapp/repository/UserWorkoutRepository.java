package com.cursorai.fitnessapp.repository;

import com.cursorai.fitnessapp.model.User;
import com.cursorai.fitnessapp.model.UserWorkout;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface UserWorkoutRepository extends JpaRepository<UserWorkout, Long> {
    List<UserWorkout> findByUserOrderByCompletedAtDesc(User user);
    List<UserWorkout> findByUserAndCompletedAtBetween(User user, LocalDateTime startDate, LocalDateTime endDate);
    boolean existsByUserAndWorkoutId(User user, Long workoutId);
}
