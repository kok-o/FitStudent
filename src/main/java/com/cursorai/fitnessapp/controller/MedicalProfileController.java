package com.cursorai.fitnessapp.controller;

import com.cursorai.fitnessapp.dto.MedicalProfileDto;
import com.cursorai.fitnessapp.model.MedicalProfile;
import com.cursorai.fitnessapp.model.User;
import com.cursorai.fitnessapp.repository.MedicalProfileRepository;
import com.cursorai.fitnessapp.repository.UserRepository;
import com.cursorai.fitnessapp.security.CustomUserDetails;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/medicalProfile")
@RequiredArgsConstructor
@Tag(name = "Medical Profile", description = "Endpoints for user medical profile management")
public class MedicalProfileController {

        private final MedicalProfileRepository medicalProfileRepository;
        private final UserRepository userRepository;

        @GetMapping
        @Operation(summary = "Get current user's medical profile", security = @SecurityRequirement(name = "bearerAuth"))
        public ResponseEntity<MedicalProfileDto> getMedicalProfile(Authentication authentication) {
                CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
                return medicalProfileRepository.findByUserId(userDetails.getId())
                                .map(this::convertToDto)
                                .map(ResponseEntity::ok)
                                .orElse(ResponseEntity.notFound().build());
        }

        @PostMapping
        @Operation(summary = "Save or update current user's medical profile", security = @SecurityRequirement(name = "bearerAuth"))
        public ResponseEntity<MedicalProfileDto> saveMedicalProfile(@RequestBody MedicalProfileDto dto,
                        Authentication authentication) {
                CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
                Long userId = userDetails.getId();
                if (userId == null) {
                        return ResponseEntity.badRequest().build();
                }
                User user = userRepository.findById(userId)
                                .orElseThrow(() -> new RuntimeException("User not found"));

                MedicalProfile medicalProfile = medicalProfileRepository.findByUserId(userId)
                                .orElse(new MedicalProfile());

                medicalProfile.setUser(user);
                medicalProfile.setDiagnoses(dto.getDiagnoses());
                medicalProfile.setAllergies(dto.getAllergies());
                medicalProfile.setContraindications(dto.getContraindications());
                medicalProfile.setActivityLevel(dto.getActivityLevel());

                MedicalProfile saved = medicalProfileRepository.save(medicalProfile);
                return ResponseEntity.ok(convertToDto(saved));
        }

        private MedicalProfileDto convertToDto(MedicalProfile medicalProfile) {
                return MedicalProfileDto.builder()
                                .diagnoses(medicalProfile.getDiagnoses())
                                .allergies(medicalProfile.getAllergies())
                                .contraindications(medicalProfile.getContraindications())
                                .activityLevel(medicalProfile.getActivityLevel())
                                .build();
        }
}
