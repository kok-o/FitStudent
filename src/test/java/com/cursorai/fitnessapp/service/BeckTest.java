package com.cursorai.fitnessapp.service;

import com.cursorai.fitnessapp.dto.UserDto;
import com.cursorai.fitnessapp.mapper.UserMapper;
import com.cursorai.fitnessapp.model.User;
import com.cursorai.fitnessapp.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class BeckTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserMapper userMapper;

    @InjectMocks
    private UserService userService;

    @Test
    void getProfile_Success() {
       
        Long userId = 1L;
        User mockUser = new User();
        mockUser.setId(userId);
        mockUser.setName("Test User");

        UserDto mockDto = new UserDto();
        mockDto.setId(userId);
        mockDto.setName("Test User");

        when(userRepository.findById(userId)).thenReturn(Optional.of(mockUser));
        when(userMapper.toDto(mockUser)).thenReturn(mockDto);

        
        UserDto result = userService.getProfile(userId);

        
        assertNotNull(result);
        assertEquals(userId, result.getId());
        assertEquals("Test User", result.getName());

        verify(userRepository, times(1)).findById(userId);
        verify(userMapper, times(1)).toDto(mockUser);
    }

    @Test
    void getProfile_UserNotFound_ThrowsException() {
        
        Long userId = 2L;
        when(userRepository.findById(userId)).thenReturn(Optional.empty());

        
        Exception exception = assertThrows(RuntimeException.class, () -> {
            userService.getProfile(userId);
        });

        assertEquals("User not found", exception.getMessage());
        verify(userRepository, times(1)).findById(userId);
        verifyNoInteractions(userMapper);
    }
}
