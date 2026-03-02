package com.cursorai.fitnessapp.mapper;

import com.cursorai.fitnessapp.dto.WorkoutDto;
import com.cursorai.fitnessapp.model.Workout;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface WorkoutMapper {
    WorkoutDto toDto(Workout workout);
    Workout toEntity(WorkoutDto workoutDto);
}
