package com.cursorai.fitnessapp.repository;

import com.cursorai.fitnessapp.model.FoodProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface FoodProductRepository extends JpaRepository<FoodProduct, Long> {
    Optional<FoodProduct> findByNameIgnoreCase(String name);
}
