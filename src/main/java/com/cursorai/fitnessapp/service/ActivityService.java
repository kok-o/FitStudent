package com.cursorai.fitnessapp.service;

import com.cursorai.fitnessapp.dto.ActivityLogDto;
import com.cursorai.fitnessapp.dto.WaterEntryDto;
import com.cursorai.fitnessapp.dto.NutritionEntryDto;
import com.cursorai.fitnessapp.mapper.ActivityLogMapper;
import com.cursorai.fitnessapp.mapper.WaterEntryMapper;
import com.cursorai.fitnessapp.mapper.NutritionEntryMapper;
import com.cursorai.fitnessapp.model.ActivityLog;
import com.cursorai.fitnessapp.model.WaterEntry;
import com.cursorai.fitnessapp.model.NutritionEntry;
import com.cursorai.fitnessapp.model.User;
import com.cursorai.fitnessapp.repository.ActivityLogRepository;
import com.cursorai.fitnessapp.repository.WaterEntryRepository;
import com.cursorai.fitnessapp.repository.NutritionEntryRepository;
import com.cursorai.fitnessapp.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ActivityService {
    
    private final ActivityLogRepository activityLogRepository;
    private final UserRepository userRepository;
    private final ActivityLogMapper activityLogMapper;
    private final WaterEntryRepository waterEntryRepository;
    private final NutritionEntryRepository nutritionEntryRepository;
    private final WaterEntryMapper waterEntryMapper;
    private final NutritionEntryMapper nutritionEntryMapper;

    public List<ActivityLogDto> getActivityLogs(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        return activityLogRepository.findByUserOrderByDateDesc(user)
                .stream()
                .map(activityLogMapper::toDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public ActivityLogDto logActivity(Long userId, ActivityLogDto activityLogDto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        ActivityLog existingLog = activityLogRepository.findByUserAndDate(user, activityLogDto.getDate()).orElse(null);
        
        if (existingLog != null) {
            existingLog.setSteps(activityLogDto.getSteps());
            existingLog.setCalories(activityLogDto.getCalories());
            existingLog.setSleepHours(activityLogDto.getSleepHours());
            existingLog.setNotes(activityLogDto.getNotes());
            existingLog = activityLogRepository.save(existingLog);
        } else {
            ActivityLog activityLog = ActivityLog.builder()
                    .user(user)
                    .steps(activityLogDto.getSteps())
                    .calories(activityLogDto.getCalories())
                    .sleepHours(activityLogDto.getSleepHours())
                    .date(activityLogDto.getDate())
                    .notes(activityLogDto.getNotes())
                    .build();
            existingLog = activityLogRepository.save(activityLog);
        }

        return activityLogMapper.toDto(existingLog);
    }

    public ActivityLogDto getTodayActivity(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        return activityLogRepository.findByUserAndDate(user, LocalDate.now())
                .map(activityLogMapper::toDto)
                .orElse(ActivityLogDto.builder()
                        .date(LocalDate.now())
                        .steps(0)
                        .calories(0)
                        .sleepHours(0.0)
                        .build());
    }

    // Water
    public List<WaterEntryDto> getWater(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return waterEntryRepository.findByUserOrderByTimestampDesc(user)
                .stream().map(waterEntryMapper::toDto).collect(Collectors.toList());
    }

    @Transactional
    public WaterEntryDto addWater(Long userId, WaterEntryDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        WaterEntry entity = waterEntryMapper.toEntity(dto);
        entity.setUser(user);
        if (entity.getTimestamp() == null) entity.setTimestamp(LocalDateTime.now());
        entity = waterEntryRepository.save(entity);
        return waterEntryMapper.toDto(entity);
    }

    @Transactional
    public WaterEntryDto updateWater(Long userId, Long entryId, WaterEntryDto dto) {
        WaterEntry entity = waterEntryRepository.findById(entryId)
                .orElseThrow(() -> new RuntimeException("Water entry not found"));
        entity.setMl(dto.getMl());
        entity.setTimestamp(dto.getTimestamp() != null ? dto.getTimestamp() : entity.getTimestamp());
        entity = waterEntryRepository.save(entity);
        return waterEntryMapper.toDto(entity);
    }

    // Nutrition
    public List<NutritionEntryDto> getNutrition(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return nutritionEntryRepository.findByUserOrderByTimestampDesc(user)
                .stream().map(nutritionEntryMapper::toDto).collect(Collectors.toList());
    }

    @Transactional
    public NutritionEntryDto addNutrition(Long userId, NutritionEntryDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        NutritionEntry entity = nutritionEntryMapper.toEntity(dto);
        entity.setUser(user);
        if (entity.getTimestamp() == null) entity.setTimestamp(LocalDateTime.now());
        entity = nutritionEntryRepository.save(entity);
        return nutritionEntryMapper.toDto(entity);
    }

    @Transactional
    public NutritionEntryDto updateNutrition(Long userId, Long entryId, NutritionEntryDto dto) {
        NutritionEntry entity = nutritionEntryRepository.findById(entryId)
                .orElseThrow(() -> new RuntimeException("Nutrition entry not found"));
        entity.setFood(dto.getFood());
        entity.setCalories(dto.getCalories());
        entity.setProteinG(dto.getProteinG());
        entity.setFatG(dto.getFatG());
        entity.setCarbsG(dto.getCarbsG());
        entity.setTimestamp(dto.getTimestamp() != null ? dto.getTimestamp() : entity.getTimestamp());
        entity = nutritionEntryRepository.save(entity);
        return nutritionEntryMapper.toDto(entity);
    }

    // CSV export for activity logs by date range
    public String exportActivityCsv(Long userId, LocalDate from, LocalDate to) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        LocalDate start = from != null ? from : LocalDate.now().minusDays(30);
        LocalDate end = to != null ? to : LocalDate.now();
        List<ActivityLog> logs = activityLogRepository.findByUserAndDateBetween(user, start, end);
        StringBuilder sb = new StringBuilder();
        sb.append("date,steps,calories,sleep_hours,notes\n");
        for (ActivityLog log : logs) {
            sb.append(log.getDate()).append(',')
              .append(nz(log.getSteps())).append(',')
              .append(nz(log.getCalories())).append(',')
              .append(nzD(log.getSleepHours())).append(',')
              .append(escapeCsv(log.getNotes()))
              .append('\n');
        }
        return sb.toString();
    }

    private int nz(Integer v) { return v == null ? 0 : v; }
    private double nzD(Double v) { return v == null ? 0.0 : v; }
    private String escapeCsv(String s) {
        if (s == null) return "";
        String t = s.replace("\"", "\"\"");
        if (t.contains(",") || t.contains("\n") || t.contains("\r") || t.contains("\"")) {
            return "\"" + t + "\"";
        }
        return t;
    }
}
