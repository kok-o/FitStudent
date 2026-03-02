package com.cursorai.fitnessapp.repository;

import com.cursorai.fitnessapp.model.NutritionEntry;
import com.cursorai.fitnessapp.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface NutritionEntryRepository extends JpaRepository<NutritionEntry, Long> {
    List<NutritionEntry> findByUserOrderByTimestampDesc(User user);
    List<NutritionEntry> findByUserAndTimestampBetween(User user, LocalDateTime from, LocalDateTime to);
}
