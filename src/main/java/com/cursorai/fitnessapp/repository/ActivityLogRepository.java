package com.cursorai.fitnessapp.repository;

import com.cursorai.fitnessapp.model.ActivityLog;
import com.cursorai.fitnessapp.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ActivityLogRepository extends JpaRepository<ActivityLog, Long> {
    List<ActivityLog> findByUserOrderByDateDesc(User user);
    Optional<ActivityLog> findByUserAndDate(User user, LocalDate date);
    List<ActivityLog> findByUserAndDateBetween(User user, LocalDate startDate, LocalDate endDate);
}
