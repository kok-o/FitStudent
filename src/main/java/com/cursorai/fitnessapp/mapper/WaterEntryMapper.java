package com.cursorai.fitnessapp.mapper;

import com.cursorai.fitnessapp.dto.WaterEntryDto;
import com.cursorai.fitnessapp.model.WaterEntry;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface WaterEntryMapper {
    WaterEntryDto toDto(WaterEntry entity);
    @Mapping(target = "user", ignore = true)
    WaterEntry toEntity(WaterEntryDto dto);
}
