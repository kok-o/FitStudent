package com.cursorai.fitnessapp.controller;

import com.cursorai.fitnessapp.dto.ActivityLogDto;
import com.cursorai.fitnessapp.dto.WaterEntryDto;
import com.cursorai.fitnessapp.dto.NutritionEntryDto;
import com.cursorai.fitnessapp.security.CustomUserDetails;
import com.cursorai.fitnessapp.service.ActivityService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.time.LocalDate;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;

@RestController
@RequestMapping("/api/activity")
@RequiredArgsConstructor
@Tag(name = "Activity", description = "Activity tracking endpoints")
public class ActivityController {
    
    private final ActivityService activityService;

    @GetMapping("/logs")
    @Operation(summary = "Get user activity logs", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<List<ActivityLogDto>> getActivityLogs(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        List<ActivityLogDto> logs = activityService.getActivityLogs(userId);
        return ResponseEntity.ok(logs);
    }

    @PostMapping("/log")
    @Operation(summary = "Log activity", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ActivityLogDto> logActivity(@Valid @RequestBody ActivityLogDto activityLogDto, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        ActivityLogDto savedLog = activityService.logActivity(userId, activityLogDto);
        return ResponseEntity.ok(savedLog);
    }

    @GetMapping("/today")
    @Operation(summary = "Get today's activity", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ActivityLogDto> getTodayActivity(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        ActivityLogDto todayActivity = activityService.getTodayActivity(userId);
        return ResponseEntity.ok(todayActivity);
    }

    // Water endpoints
    @GetMapping("/water")
    @Operation(summary = "Get water entries", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<List<WaterEntryDto>> getWater(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        return ResponseEntity.ok(activityService.getWater(userId));
    }

    @PostMapping("/water")
    @Operation(summary = "Add water entry", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<WaterEntryDto> addWater(@Valid @RequestBody WaterEntryDto dto, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        return ResponseEntity.ok(activityService.addWater(userId, dto));
    }

    @PutMapping("/water/{id}")
    @Operation(summary = "Update water entry", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<WaterEntryDto> updateWater(@PathVariable("id") Long id, @Valid @RequestBody WaterEntryDto dto, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        return ResponseEntity.ok(activityService.updateWater(userId, id, dto));
    }

    // Nutrition endpoints
    @GetMapping("/nutrition")
    @Operation(summary = "Get nutrition entries", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<List<NutritionEntryDto>> getNutrition(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        return ResponseEntity.ok(activityService.getNutrition(userId));
    }

    @PostMapping("/nutrition")
    @Operation(summary = "Add nutrition entry", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<NutritionEntryDto> addNutrition(@Valid @RequestBody NutritionEntryDto dto, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        return ResponseEntity.ok(activityService.addNutrition(userId, dto));
    }

    @PutMapping("/nutrition/{id}")
    @Operation(summary = "Update nutrition entry", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<NutritionEntryDto> updateNutrition(@PathVariable("id") Long id, @Valid @RequestBody NutritionEntryDto dto, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        return ResponseEntity.ok(activityService.updateNutrition(userId, id, dto));
    }

    // CSV export
    @GetMapping(value = "/export.csv", produces = MediaType.TEXT_PLAIN_VALUE)
    @Operation(summary = "Export activity CSV", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<String> exportCsv(@RequestParam(required = false) LocalDate from,
                                            @RequestParam(required = false) LocalDate to,
                                            Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        String csv = activityService.exportActivityCsv(userId, from, to);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=activity_export.csv")
                .contentType(MediaType.TEXT_PLAIN)
                .body(csv);
    }
}
