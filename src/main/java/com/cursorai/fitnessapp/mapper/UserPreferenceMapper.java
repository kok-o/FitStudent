package com.cursorai.fitnessapp.mapper;

import com.cursorai.fitnessapp.dto.UserPreferenceDto;
import com.cursorai.fitnessapp.model.UserPreference;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserPreferenceMapper {
    UserPreferenceDto toDto(UserPreference entity);
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "userId", ignore = true)
    UserPreference toEntity(UserPreferenceDto dto);
}
