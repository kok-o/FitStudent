package com.cursorai.fitnessapp.mapper;

import com.cursorai.fitnessapp.dto.UserWorkoutDto;
import com.cursorai.fitnessapp.model.UserWorkout;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", uses = WorkoutMapper.class)
public interface UserWorkoutMapper {
    @Mapping(source = "workout", target = "workout")
    UserWorkoutDto toDto(UserWorkout userWorkout);
    
    @Mapping(target = "user", ignore = true)
    UserWorkout toEntity(UserWorkoutDto userWorkoutDto);
}
