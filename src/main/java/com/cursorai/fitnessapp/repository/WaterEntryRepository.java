package com.cursorai.fitnessapp.repository;

import com.cursorai.fitnessapp.model.User;
import com.cursorai.fitnessapp.model.WaterEntry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface WaterEntryRepository extends JpaRepository<WaterEntry, Long> {
    List<WaterEntry> findByUserOrderByTimestampDesc(User user);
    List<WaterEntry> findByUserAndTimestampBetween(User user, LocalDateTime from, LocalDateTime to);
}
