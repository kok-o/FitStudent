import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../../shared/models/diet_models.dart';

class DietState {
  final AsyncValue<DietPlan?> plan;
  const DietState({required this.plan});
  DietState copyWith({AsyncValue<DietPlan?>? plan}) => DietState(plan: plan ?? this.plan);
}

class DietNotifier extends StateNotifier<DietState> {
  final Dio _dio = DioClient().dio;
  DietNotifier() : super(const DietState(plan: AsyncValue.data(null)));

  Future<void> generate(Map<String, dynamic> payload) async {
    state = state.copyWith(plan: const AsyncValue.loading());
    try {
      final res = await _dio.post('/api/diet/generate', data: payload);
      state = state.copyWith(plan: AsyncValue.data(DietPlan.fromJson(res.data)));
    } catch (e, st) {
      state = state.copyWith(plan: AsyncValue.error(e, st));
    }
  }

  void replaceInMeal(String mealKey, int index, Recipe newRecipe) {
    final p = state.plan.value;
    if (p == null) return;
    final meals = Map<String, List<Recipe>>.from(p.meals);
    final list = List<Recipe>.from(meals[mealKey] ?? []);
    if (index >= 0 && index < list.length) list[index] = newRecipe;
    meals[mealKey] = list;
    state = state.copyWith(
      plan: AsyncValue.data(
        DietPlan(dailyCalories: p.dailyCalories, macros: p.macros, meals: meals, snacks: p.snacks),
      ),
    );
  }
}

final dietProvider = StateNotifierProvider<DietNotifier, DietState>((ref) => DietNotifier());
