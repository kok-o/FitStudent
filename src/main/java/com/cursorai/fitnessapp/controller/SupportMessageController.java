package com.cursorai.fitnessapp.controller;

import com.cursorai.fitnessapp.dto.SupportMessageDto;
import com.cursorai.fitnessapp.model.SupportMessage;
import com.cursorai.fitnessapp.model.User;
import com.cursorai.fitnessapp.repository.SupportMessageRepository;
import com.cursorai.fitnessapp.repository.UserRepository;
import com.cursorai.fitnessapp.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/support")
@RequiredArgsConstructor
public class SupportMessageController {

        private final SupportMessageRepository supportMessageRepository;
        private final UserRepository userRepository;

        @PostMapping("/messages")
        public ResponseEntity<Void> sendMessage(@RequestBody Map<String, String> payload,
                        Authentication authentication) {
                CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
                Long userId = userDetails.getId();
                if (userId == null) {
                        return ResponseEntity.badRequest().build();
                }

                User user = userRepository.findById(userId)
                                .orElseThrow(() -> new RuntimeException("User not found"));

                SupportMessage message = SupportMessage.builder()
                                .user(user)
                                .message(payload.get("message"))
                                .timestamp(LocalDateTime.now())
                                .isRead(false)
                                .build();

                if (message != null) {
                        supportMessageRepository.save(message);
                }
                return ResponseEntity.ok().build();
        }

        @GetMapping("/messages")
        public ResponseEntity<List<SupportMessageDto>> getMessages(Authentication authentication) {
                CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
                boolean isAdmin = userDetails.getAuthorities().stream()
                                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

                List<SupportMessage> messagesList;
                if (isAdmin) {
                        messagesList = supportMessageRepository.findAllByOrderByTimestampDesc();
                } else {
                        User user = userRepository.findById(userDetails.getId())
                                        .orElseThrow(() -> new RuntimeException("User not found"));
                        messagesList = supportMessageRepository.findByUserOrderByTimestampAsc(user);
                }

                List<SupportMessageDto> messages = messagesList.stream()
                                .map(m -> SupportMessageDto.builder()
                                                .id(m.getId())
                                                .userId(m.getUser().getId())
                                                .userName(m.getUser().getName())
                                                .message(m.getMessage())
                                                .timestamp(m.getTimestamp().toString())
                                                .read(m.isRead())
                                                .adminMessage(m.isAdminMessage())
                                                .build())
                                .collect(Collectors.toList());
                return ResponseEntity.ok(messages);
        }

        @PostMapping("/messages/{userId}/reply")
        @PreAuthorize("hasRole('ADMIN')")
        public ResponseEntity<Void> replyToUser(@PathVariable Long userId, @RequestBody Map<String, String> payload) {
                User user = userRepository.findById(userId)
                                .orElseThrow(() -> new RuntimeException("User not found"));

                SupportMessage message = SupportMessage.builder()
                                .user(user)
                                .message(payload.get("message"))
                                .timestamp(LocalDateTime.now())
                                .isRead(false)
                                .isAdminMessage(true)
                                .build();

                supportMessageRepository.save(message);
                return ResponseEntity.ok().build();
        }

        @PutMapping("/messages/{id}/read")
        @PreAuthorize("hasRole('ADMIN')")
        public ResponseEntity<Void> markAsRead(@PathVariable Long id) {
                if (id == null) {
                        return ResponseEntity.badRequest().build();
                }
                SupportMessage message = supportMessageRepository.findById(id)
                                .orElseThrow(() -> new RuntimeException("Message not found"));
                message.setRead(true);
                supportMessageRepository.save(message);
                return ResponseEntity.ok().build();
        }
}
