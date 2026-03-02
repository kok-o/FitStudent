package com.cursorai.fitnessapp.service;

import com.cursorai.fitnessapp.config.StorageProperties;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Instant;

@Service
@RequiredArgsConstructor
public class StorageService {

    private final StorageProperties storageProperties;

    public String savePublic(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new RuntimeException("Empty file");
        }
        try {
            Path uploadRoot = Paths.get(storageProperties.getUploadDir()).toAbsolutePath().normalize();
            Files.createDirectories(uploadRoot);
            String original = StringUtils.cleanPath(file.getOriginalFilename() == null ? "file" : file.getOriginalFilename());
            String ext = original.contains(".") ? original.substring(original.lastIndexOf('.')) : "";
            String name = "photo_" + Instant.now().toEpochMilli() + ext;
            Path target = uploadRoot.resolve(name);
            Files.copy(file.getInputStream(), target);
            // Return public URL path served by WebConfig
            return "/uploads/" + name;
        } catch (IOException e) {
            throw new RuntimeException("Failed to store file", e);
        }
    }
}
