package com.cursorai.fitnessapp.mapper;

import com.cursorai.fitnessapp.dto.NutritionEntryDto;
import com.cursorai.fitnessapp.model.NutritionEntry;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface NutritionEntryMapper {
    NutritionEntryDto toDto(NutritionEntry entity);
    @Mapping(target = "user", ignore = true)
    NutritionEntry toEntity(NutritionEntryDto dto);
}
