package com.cursorai.fitnessapp.mapper;

import com.cursorai.fitnessapp.dto.UserDto;
import com.cursorai.fitnessapp.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserMapper {
    UserDto toDto(User user);
    
    @Mapping(target = "password", ignore = true)
    User toEntity(UserDto userDto);
}
