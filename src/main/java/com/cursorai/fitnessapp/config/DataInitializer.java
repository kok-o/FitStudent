package com.cursorai.fitnessapp.config;

import com.cursorai.fitnessapp.model.*;
import com.cursorai.fitnessapp.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

        private final UserRepository userRepository;
        private final WorkoutRepository workoutRepository;
        private final NotificationRepository notificationRepository;
        private final FoodProductRepository foodProductRepository;
        private final PasswordEncoder passwordEncoder;

        @Override
        public void run(String... args) throws Exception {
                createAdminUser();
                if (userRepository.count() == 0) {
                        createDemoWorkouts();
                        createDemoNotifications();
                        createDemoFoodProducts();
                }
        }

        private void createAdminUser() {
                if (!userRepository.existsByEmail("admin@fitstudent.com")) {
                        User admin = User.builder()
                                        .email("admin@fitstudent.com")
                                        .password(passwordEncoder.encode("admin123"))
                                        .name("Admin")
                                        .age(25)
                                        .gender("Male")
                                        .height(180.0)
                                        .weight(75.0)
                                        .goal(User.Goal.MAINTAIN)
                                        .activityLevel(User.ActivityLevel.ACTIVE)
                                        .role(User.Role.ADMIN)
                                        .build();

                        userRepository.save(admin);
                }
        }

        private void createDemoWorkouts() {
                // Beginner workout
                Workout beginnerWorkout = Workout.builder()
                                .title("Morning Stretch")
                                .description("Gentle stretching routine for beginners")
                                .level(Workout.Level.BEGINNER)
                                .duration(15)
                                .calories(50)
                                .exercises(Arrays.asList(
                                                "Neck rolls - 10 reps",
                                                "Shoulder shrugs - 10 reps",
                                                "Arm circles - 10 reps each direction",
                                                "Hip circles - 10 reps each direction",
                                                "Leg swings - 10 reps each leg",
                                                "Calf raises - 15 reps"))
                                .build();

                // Medium workout
                Workout mediumWorkout = Workout.builder()
                                .title("Cardio Blast")
                                .description("Moderate intensity cardio workout")
                                .level(Workout.Level.MEDIUM)
                                .duration(30)
                                .calories(200)
                                .exercises(Arrays.asList(
                                                "Jumping jacks - 1 minute",
                                                "High knees - 1 minute",
                                                "Burpees - 10 reps",
                                                "Mountain climbers - 1 minute",
                                                "Jump squats - 15 reps",
                                                "Push-ups - 10 reps",
                                                "Plank - 30 seconds"))
                                .build();

                // Advanced workout
                Workout advancedWorkout = Workout.builder()
                                .title("HIIT Challenge")
                                .description("High intensity interval training")
                                .level(Workout.Level.ADVANCED)
                                .duration(45)
                                .calories(400)
                                .exercises(Arrays.asList(
                                                "Burpee tuck jumps - 20 reps",
                                                "Diamond push-ups - 15 reps",
                                                "Single-leg deadlifts - 12 reps each leg",
                                                "Pike push-ups - 10 reps",
                                                "Jump lunges - 20 reps",
                                                "Handstand push-ups - 8 reps",
                                                "Box jumps - 15 reps",
                                                "Turkish get-ups - 5 reps each side"))
                                .build();

                workoutRepository.saveAll(Arrays.asList(beginnerWorkout, mediumWorkout, advancedWorkout));
        }

        private void createDemoNotifications() {
                List<User> users = userRepository.findAll();
                if (!users.isEmpty()) {
                        User user = users.get(0);

                        Notification welcomeNotification = Notification.builder()
                                        .user(user)
                                        .message("Welcome to FitStudent! Start your fitness journey today.")
                                        .type(Notification.Type.SYSTEM)
                                        .isRead(false)
                                        .build();

                        Notification motivationNotification = Notification.builder()
                                        .user(user)
                                        .message("Remember: Consistency is key to achieving your fitness goals!")
                                        .type(Notification.Type.MOTIVATION)
                                        .isRead(false)
                                        .build();

                        notificationRepository.saveAll(Arrays.asList(welcomeNotification, motivationNotification));
                }
        }

        private void createDemoFoodProducts() {
                List<FoodProduct> products = Arrays.asList(
                                FoodProduct.builder()
                                                .name("Snickers")
                                                .allergenNuts(true)
                                                .highSugar(true)
                                                .replacementSuggestion("Dark Chocolate with Stevia")
                                                .replacementReason("High sugar and contains peanuts (nuts).")
                                                .build(),
                                FoodProduct.builder()
                                                .name("Milk")
                                                .allergenLactose(true)
                                                .replacementSuggestion("Almond Milk or Oat Milk")
                                                .replacementReason("Contains lactose.")
                                                .build(),
                                FoodProduct.builder()
                                                .name("White Bread")
                                                .allergenGluten(true)
                                                .highCalorie(true)
                                                .replacementSuggestion("Whole Grain Bread or Gluten-free Bread")
                                                .replacementReason("High glycemic index and contains gluten.")
                                                .build(),
                                FoodProduct.builder()
                                                .name("Beer")
                                                .highPurine(true)
                                                .highSugar(true)
                                                .replacementSuggestion("Sparkling Water with Lemon")
                                                .replacementReason("High in purines (bad for gout) and alcohol.")
                                                .build(),
                                FoodProduct.builder()
                                                .name("Liver")
                                                .lowIron(false) // Actually high in iron
                                                .highPurine(true)
                                                .replacementSuggestion("Spinach or Lentils")
                                                .replacementReason(
                                                                "Excellent iron source for anemia, but high purine for gout.")
                                                .build(),
                                FoodProduct.builder()
                                                .name("Potato Chips")
                                                .highSodium(true)
                                                .highCalorie(true)
                                                .replacementSuggestion("Baked Apple Chips")
                                                .replacementReason("High sodium and fat content.")
                                                .build(),
                                FoodProduct.builder()
                                                .name("Soy Sauce")
                                                .allergenSoy(true)
                                                .highSodium(true)
                                                .replacementSuggestion("Coconut Aminos")
                                                .replacementReason("Contains soy and very high sodium.")
                                                .build(),
                                FoodProduct.builder()
                                                .name("Shrimp")
                                                .allergenSeafood(true)
                                                .replacementSuggestion("Tofu or Grilled Chicken")
                                                .replacementReason("Common seafood allergen.")
                                                .build(),
                                FoodProduct.builder()
                                                .name("Mayonnaise")
                                                .allergenEggs(true)
                                                .highCalorie(true)
                                                .replacementSuggestion("Avocado spread or Egg-free Mayo")
                                                .replacementReason("Contains eggs and high fat.")
                                                .build());

                if (products != null && !products.isEmpty()) {
                        foodProductRepository.saveAll(products);
                }
        }
}
