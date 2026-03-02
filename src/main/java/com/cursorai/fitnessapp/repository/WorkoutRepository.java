package com.cursorai.fitnessapp.repository;

import com.cursorai.fitnessapp.model.Workout;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WorkoutRepository extends JpaRepository<Workout, Long> {
    List<Workout> findByLevel(Workout.Level level);
    List<Workout> findByLevelOrderByDurationAsc(Workout.Level level);
}
