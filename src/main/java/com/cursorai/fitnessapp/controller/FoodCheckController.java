package com.cursorai.fitnessapp.controller;

import com.cursorai.fitnessapp.dto.FoodCheckRequest;
import com.cursorai.fitnessapp.dto.FoodCheckResponse;
import com.cursorai.fitnessapp.dto.FoodReplacementDto;
import com.cursorai.fitnessapp.model.FoodProduct;
import com.cursorai.fitnessapp.model.MedicalProfile;
import com.cursorai.fitnessapp.repository.FoodProductRepository;
import com.cursorai.fitnessapp.repository.MedicalProfileRepository;
import com.cursorai.fitnessapp.security.CustomUserDetails;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@RestController
@RequestMapping("/api/food")
@RequiredArgsConstructor
@Tag(name = "Food Check", description = "Endpoints for checking food against medical profile")
@Slf4j
public class FoodCheckController {

    private final MedicalProfileRepository medicalProfileRepository;
    private final FoodProductRepository foodProductRepository;

    @PostMapping("/check")
    @Operation(summary = "Check food against user's medical profile", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<FoodCheckResponse> checkFood(@RequestBody FoodCheckRequest request,
            Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        log.info("User {} checking food: {}", userDetails.getEmail(), request.getFoodName());
        MedicalProfile profile = medicalProfileRepository.findByUserId(userDetails.getId()).orElse(null);

        String foodName = request.getFoodName();
        String foodLower = foodName.toLowerCase();

        Optional<FoodProduct> productOpt = foodProductRepository.findByNameIgnoreCase(foodName);

        List<FoodReplacementDto> replacements = new ArrayList<>();
        String status = "ALLOWED";
        StringBuilder reason = new StringBuilder();

        if (profile != null) {
            Set<String> diagnoses = profile.getDiagnoses();
            Set<String> allergies = profile.getAllergies();

            if (productOpt.isPresent()) {
                FoodProduct product = productOpt.get();

                // Nut allergy check
                if ((allergies.contains("nuts") || allergies.contains("орехи")) && product.isAllergenNuts()) {
                    status = "FORBIDDEN";
                    reason.append("Contains nuts - extreme risk for nut allergy. ");
                }

                // Gluten check
                if ((allergies.contains("gluten") || allergies.contains("глютен") || diagnoses.contains("celiac")
                        || diagnoses.contains("целиакия"))
                        && product.isAllergenGluten()) {
                    status = "FORBIDDEN";
                    reason.append("Contains gluten - unsafe for Celiac or gluten intolerance. ");
                }

                // Lactose check
                if ((allergies.contains("lactose") || allergies.contains("лактоза")) && product.isAllergenLactose()) {
                    status = "FORBIDDEN";
                    reason.append("Contains lactose - unsafe for lactose intolerance. ");
                }

                // Sugar check for diabetes
                if ((diagnoses.contains("diabetes") || diagnoses.contains("диабет")) && product.isHighSugar()) {
                    status = "FORBIDDEN";
                    reason.append("High sugar content - not recommended for diabetes. ");
                }

                // Sodium check for hypertension/CKD
                if ((diagnoses.contains("hypertension") || diagnoses.contains("гипертония") || diagnoses.contains("ckd")
                        || diagnoses.contains("хпн"))
                        && product.isHighSodium()) {
                    status = "LIMITED";
                    reason.append("High sodium - limit intake for blood pressure/kidney health. ");
                }

                // Purine check for gout
                if ((diagnoses.contains("gout") || diagnoses.contains("подагра") || diagnoses.contains("ckd")
                        || diagnoses.contains("хпн"))
                        && product.isHighPurine()) {
                    status = "LIMITED";
                    reason.append("High in purines - limit for gout/kidney health. ");
                }

                // Calorie check for obesity
                if ((diagnoses.contains("obesity") || diagnoses.contains("ожирение")) && product.isHighCalorie()) {
                    status = "LIMITED";
                    reason.append("High calorie density - limit for weight management. ");
                }

                // Anemia source check
                if ((diagnoses.contains("anemia") || diagnoses.contains("анемия")) && !product.isLowIron()) {
                    reason.append("Good source of iron - beneficial for anemia. ");
                }

                // Add replacements if forbidden/limited
                if (!status.equals("ALLOWED") && product.getReplacementSuggestion() != null) {
                    replacements.add(new FoodReplacementDto(foodName,
                            product.getReplacementSuggestion(),
                            product.getReplacementReason()));
                }

            } else {
                // FALLBACK: Keyword based matching for unknown foods
                // Diabetes
                if (diagnoses.contains("diabetes") || diagnoses.contains("диабет")) {
                    if (foodLower.contains("sugar") || foodLower.contains("сахар") || foodLower.contains("chocolate")) {
                        status = "FORBIDDEN";
                        reason.append("Potential high sugar - use caution with diabetes. ");
                    }
                }
                // Nuts
                if (allergies.contains("nuts") || allergies.contains("орехи")) {
                    if (foodLower.contains("nut") || foodLower.contains("орех") || foodLower.contains("peanuts")) {
                        status = "FORBIDDEN";
                        reason.append("Product name suggests nut content - verify packaging. ");
                    }
                }
                // Add more fallback keywords if needed...
            }
        }

        if (reason.length() == 0) {
            reason.append("No specific contraindications found based on your profile.");
        }

        return ResponseEntity.ok(FoodCheckResponse.builder()
                .status(status)
                .reason(reason.toString().trim())
                .replacements(replacements)
                .build());
    }
}
