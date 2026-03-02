package com.cursorai.fitnessapp.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminUserStatsDTO {
    private Long totalUsers;
    private Long activeUsersToday;
    private Long activeUsersThisWeek;
    private Long newUsersThisMonth;
    private Double averageWorkoutsPerUser;
}
