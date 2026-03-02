package com.cursorai.fitnessapp.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Set;

@Entity
@Table(name = "medical_profiles")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MedicalProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", unique = true, nullable = false)
    private User user;

    @ElementCollection
    @CollectionTable(name = "medical_profile_diagnoses", joinColumns = @JoinColumn(name = "medical_profile_id"))
    @Column(name = "diagnosis")
    private Set<String> diagnoses;

    @ElementCollection
    @CollectionTable(name = "medical_profile_allergies", joinColumns = @JoinColumn(name = "medical_profile_id"))
    @Column(name = "allergy")
    private Set<String> allergies;

    @Column(columnDefinition = "TEXT")
    private String contraindications;

    private Integer activityLevel; // 1-5 or similar
}
