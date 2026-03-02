package com.cursorai.fitnessapp.mapper;

import com.cursorai.fitnessapp.dto.NotificationDto;
import com.cursorai.fitnessapp.model.Notification;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface NotificationMapper {
    NotificationDto toDto(Notification notification);
    Notification toEntity(NotificationDto notificationDto);
}
