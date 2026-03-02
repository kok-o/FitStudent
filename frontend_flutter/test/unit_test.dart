import 'package:flutter_test/flutter_test.dart';


int calculateWaterIntake(double weightKg, int activityLevelMultiplier) {
  
  return (weightKg * 30).round() + (500 * activityLevelMultiplier);
}

void main() {
  group('calculateWaterIntake tests', () {
    test('Calculates correct water intake for sedentary user', () {
      
      double weight = 70.0;
      int sedentaryActivityMultiplier = 0; 

    
      int result = calculateWaterIntake(weight, sedentaryActivityMultiplier);

     
      expect(result, 2100); 
    });

    test('Calculates correct water intake for active user', () {
      
      double weight = 80.0;
      int activeMultiplier = 2; 

      
      int result = calculateWaterIntake(weight, activeMultiplier);

      
      expect(result, 3400); 
    });
  });
}
