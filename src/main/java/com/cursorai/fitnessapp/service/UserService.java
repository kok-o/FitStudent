package com.cursorai.fitnessapp.service;

import com.cursorai.fitnessapp.dto.UserDto;
import com.cursorai.fitnessapp.dto.ProfileCalculationsDto;
import com.cursorai.fitnessapp.dto.UserPreferenceDto;
import com.cursorai.fitnessapp.dto.PasswordChangeRequest;
import com.cursorai.fitnessapp.mapper.UserMapper;
import com.cursorai.fitnessapp.mapper.UserPreferenceMapper;
import com.cursorai.fitnessapp.model.User;
import com.cursorai.fitnessapp.model.UserPreference;
import com.cursorai.fitnessapp.repository.UserRepository;
import com.cursorai.fitnessapp.repository.UserPreferenceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;
    private final UserPreferenceRepository userPreferenceRepository;
    private final UserPreferenceMapper userPreferenceMapper;
    private final StorageService storageService;
    private final PasswordEncoder passwordEncoder;

    public UserDto getProfile(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return userMapper.toDto(user);
    }

    @Transactional
    public UserDto updateProfile(Long userId, UserDto userDto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setName(userDto.getName());
        user.setAge(userDto.getAge());
        user.setGender(userDto.getGender());
        user.setHeight(userDto.getHeight());
        user.setWeight(userDto.getWeight());
        user.setGoal(userDto.getGoal());
        user.setActivityLevel(userDto.getActivityLevel());

        user = userRepository.save(user);
        return userMapper.toDto(user);
    }

    public ProfileCalculationsDto getProfileCalculations(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Double heightCm = user.getHeight();
        Double weightKg = user.getWeight();
        Integer age = user.getAge();

        if (heightCm == null || heightCm == 0 || weightKg == null || weightKg == 0 || age == null) {
            return ProfileCalculationsDto.builder().build();
        }

        double heightM = heightCm / 100.0;
        double bmi = weightKg / (heightM * heightM);

        boolean male = user.getGender() != null && user.getGender().equalsIgnoreCase("male");
        double bmr;
        if (male) {
            bmr = 10 * weightKg + 6.25 * heightCm - 5 * age + 5;
        } else {
            bmr = 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
        }

        double activityFactor = 1.2; // default SEDENTARY
        if (user.getActivityLevel() != null) {
            switch (user.getActivityLevel()) {
                case MODERATE -> activityFactor = 1.55;
                case ACTIVE -> activityFactor = 1.725;
                default -> activityFactor = 1.2;
            }
        }
        double tdee = bmr * activityFactor;

        double targetCalories = tdee;
        if (user.getGoal() != null) {
            switch (user.getGoal()) {
                case LOSE -> targetCalories = tdee * 0.85; // -15%
                case MAINTAIN -> targetCalories = tdee;
                case GAIN -> targetCalories = tdee * 1.15; // +15%
            }
        }

        // Macros: protein 1.8 g/kg, fats 30% kcal, carbs rest
        double proteinG = 1.8 * weightKg;
        double fatKcal = targetCalories * 0.30;
        double fatG = fatKcal / 9.0;
        double proteinKcal = proteinG * 4.0;
        double carbsKcal = Math.max(0, targetCalories - fatKcal - proteinKcal);
        double carbsG = carbsKcal / 4.0;

        return ProfileCalculationsDto.builder()
                .bmi(round1(bmi))
                .bmr(round0(bmr))
                .tdee(round0(tdee))
                .targetCalories(round0(targetCalories))
                .proteinG(round0(proteinG))
                .fatG(round0(fatG))
                .carbsG(round0(carbsG))
                .build();
    }

    private double round0(double v) {
        return Math.round(v);
    }

    private double round1(double v) {
        return Math.round(v * 10.0) / 10.0;
    }

    // Preferences
    public UserPreferenceDto getPreferences(Long userId) {
        UserPreference pref = userPreferenceRepository.findById(userId).orElse(null);
        if (pref == null) {
            return UserPreferenceDto.builder().build();
        }
        return userPreferenceMapper.toDto(pref);
    }

    @Transactional
    public UserPreferenceDto updatePreferences(Long userId, UserPreferenceDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        UserPreference pref = userPreferenceRepository.findById(userId).orElse(null);
        if (pref == null) {
            pref = new UserPreference();
            pref.setUser(user);
        }
        pref.setPreferredTrainingTypes(dto.getPreferredTrainingTypes());
        pref.setPreferredTimeOfDay(dto.getPreferredTimeOfDay());
        pref.setEquipment(dto.getEquipment());
        pref = userPreferenceRepository.save(pref);
        return userPreferenceMapper.toDto(pref);
    }

    // Photo upload
    @Transactional
    public UserDto uploadProfilePhoto(Long userId, MultipartFile file) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        String publicUrl = storageService.savePublic(file);
        user.setPhotoUrl(publicUrl);
        user = userRepository.save(user);
        return userMapper.toDto(user);
    }

    @Transactional
    public void changePassword(Long userId, PasswordChangeRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!passwordEncoder.matches(request.getCurrentPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid current password");
        }

        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);
    }

    @Transactional
    public void makeUserAdmin(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        user.setRole(User.Role.ADMIN);
        userRepository.save(user);
    }
}
