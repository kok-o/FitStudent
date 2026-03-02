package com.cursorai.fitnessapp.repository;

import com.cursorai.fitnessapp.model.SupportMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SupportMessageRepository extends JpaRepository<SupportMessage, Long> {
    List<SupportMessage> findAllByOrderByTimestampDesc();

    List<SupportMessage> findByUserOrderByTimestampAsc(com.cursorai.fitnessapp.model.User user);
}
