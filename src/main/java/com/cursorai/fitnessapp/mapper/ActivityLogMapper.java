package com.cursorai.fitnessapp.mapper;

import com.cursorai.fitnessapp.dto.ActivityLogDto;
import com.cursorai.fitnessapp.model.ActivityLog;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ActivityLogMapper {
    ActivityLogDto toDto(ActivityLog activityLog);
    ActivityLog toEntity(ActivityLogDto activityLogDto);
}
