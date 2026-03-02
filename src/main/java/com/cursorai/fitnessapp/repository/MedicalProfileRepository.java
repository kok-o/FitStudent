package com.cursorai.fitnessapp.repository;

import com.cursorai.fitnessapp.model.MedicalProfile;
import com.cursorai.fitnessapp.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface MedicalProfileRepository extends JpaRepository<MedicalProfile, Long> {
    Optional<MedicalProfile> findByUserId(Long userId);

    Optional<MedicalProfile> findByUser(User user);
}
