package com.cursorai.fitnessapp.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "food_products")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FoodProduct {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String name;

    private boolean allergenNuts;
    private boolean allergenGluten;
    private boolean allergenLactose;
    private boolean allergenSeafood;
    private boolean allergenEggs;
    private boolean allergenSoy;

    private boolean highSugar;
    private boolean highSodium;
    private boolean highPurine;
    private boolean highCalorie;
    private boolean lowIron; // For anemia recommendations

    private String replacementSuggestion;
    private String replacementReason;
}
