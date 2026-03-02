package com.cursorai.fitnessapp.controller;

import com.cursorai.fitnessapp.dto.UserDto;
import com.cursorai.fitnessapp.dto.ProfileCalculationsDto;
import com.cursorai.fitnessapp.dto.UserPreferenceDto;
import com.cursorai.fitnessapp.dto.PasswordChangeRequest;
import com.cursorai.fitnessapp.security.CustomUserDetails;
import com.cursorai.fitnessapp.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
@Tag(name = "User", description = "User profile endpoints")
public class UserController {

    private final UserService userService;

    @GetMapping("/profile")
    @Operation(summary = "Get user profile", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<UserDto> getProfile(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        UserDto user = userService.getProfile(userId);
        return ResponseEntity.ok(user);
    }

    @PutMapping("/profile")
    @Operation(summary = "Update user profile", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<UserDto> updateProfile(@Valid @RequestBody UserDto userDto, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        UserDto updatedUser = userService.updateProfile(userId, userDto);
        return ResponseEntity.ok(updatedUser);
    }

    @GetMapping("/profile/calculations")
    @Operation(summary = "Get BMI/BMR/TDEE and macros", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<ProfileCalculationsDto> getProfileCalculations(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        ProfileCalculationsDto result = userService.getProfileCalculations(userId);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/preferences")
    @Operation(summary = "Get user preferences", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<UserPreferenceDto> getPreferences(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        return ResponseEntity.ok(userService.getPreferences(userId));
    }

    @PutMapping("/preferences")
    @Operation(summary = "Update user preferences", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<UserPreferenceDto> updatePreferences(@Valid @RequestBody UserPreferenceDto dto,
            Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        return ResponseEntity.ok(userService.updatePreferences(userId, dto));
    }

    @PostMapping(value = "/profile/photo", consumes = { "multipart/form-data" })
    @Operation(summary = "Upload profile photo", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<UserDto> uploadPhoto(@RequestPart("file") MultipartFile file, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        return ResponseEntity.ok(userService.uploadProfilePhoto(userId, file));
    }

    @PutMapping("/profile/password")
    @Operation(summary = "Change user password", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<Void> changePassword(@Valid @RequestBody PasswordChangeRequest request,
            Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        userService.changePassword(userId, request);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/profile/make-admin")
    @Operation(summary = "Make current user an admin (Temporary for testing)", security = @SecurityRequirement(name = "bearerAuth"))
    public ResponseEntity<Void> makeAdmin(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();
        userService.makeUserAdmin(userId);
        return ResponseEntity.ok().build();
    }
}
