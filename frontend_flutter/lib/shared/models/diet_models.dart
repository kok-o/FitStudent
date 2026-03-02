class Ingredient {
  String name;
  String amount;
  bool excluded;
  Ingredient({required this.name, required this.amount, this.excluded = false});
  factory Ingredient.fromJson(Map<String, dynamic> j) => Ingredient(
        name: j['name'] ?? '',
        amount: j['amount'] ?? '',
        excluded: (j['excluded'] ?? false) as bool,
      );
  Map<String, dynamic> toJson() => {'name': name, 'amount': amount, 'excluded': excluded};
}

class Recipe {
  String id;
  String name;
  String instructions;
  String image;
  double calories;
  double protein;
  double fats;
  double carbs;
  List<Ingredient> ingredients;
  List<String> tags;
  Recipe({
    required this.id,
    required this.name,
    required this.instructions,
    required this.image,
    required this.calories,
    required this.protein,
    required this.fats,
    required this.carbs,
    required this.ingredients,
    required this.tags,
  });
  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
        id: j['id'] ?? '',
        name: j['name'] ?? '',
        instructions: j['instructions'] ?? '',
        image: j['image'] ?? '',
        calories: (j['calories'] ?? 0).toDouble(),
        protein: (j['protein'] ?? 0).toDouble(),
        fats: (j['fats'] ?? 0).toDouble(),
        carbs: (j['carbs'] ?? 0).toDouble(),
        ingredients: (j['ingredients'] as List<dynamic>? ?? []).map((e) => Ingredient.fromJson(e)).toList(),
        tags: List<String>.from(j['tags'] ?? []),
      );
}

class DietPlan {
  double dailyCalories;
  Map<String, double> macros;
  Map<String, List<Recipe>> meals;
  List<Recipe> snacks;
  DietPlan({required this.dailyCalories, required this.macros, required this.meals, required this.snacks});
  factory DietPlan.fromJson(Map<String, dynamic> j) => DietPlan(
        dailyCalories: (j['dailyCalories'] ?? 0).toDouble(),
        macros: (j['macros'] as Map<String, dynamic>).map((k, v) => MapEntry(k, (v ?? 0).toDouble())),
        meals: (j['meals'] as Map<String, dynamic>).map((k, v) => MapEntry(k, (v as List).map((e) => Recipe.fromJson(e)).toList())),
        snacks: (j['snacks'] as List<dynamic>? ?? []).map((e) => Recipe.fromJson(e)).toList(),
      );
}
