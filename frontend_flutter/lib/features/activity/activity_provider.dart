import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'activity_service.dart';
import 'models.dart';

class ActivityState {
  final AsyncValue<ActivityLogDto> today;
  final AsyncValue<List<ActivityLogDto>> logs;
  final AsyncValue<List<WaterEntryDto>> water;
  final AsyncValue<List<NutritionEntryDto>> nutrition;

  const ActivityState({
    required this.today,
    required this.logs,
    required this.water,
    required this.nutrition,
  });

  ActivityState copyWith({
    AsyncValue<ActivityLogDto>? today,
    AsyncValue<List<ActivityLogDto>>? logs,
    AsyncValue<List<WaterEntryDto>>? water,
    AsyncValue<List<NutritionEntryDto>>? nutrition,
  }) {
    return ActivityState(
      today: today ?? this.today,
      logs: logs ?? this.logs,
      water: water ?? this.water,
      nutrition: nutrition ?? this.nutrition,
    );
  }
}

class ActivityNotifier extends StateNotifier<ActivityState> {
  final ActivityService _service = ActivityService();

  ActivityNotifier()
      : super(ActivityState(
          today: const AsyncValue.loading(),
          logs: const AsyncValue.loading(),
          water: const AsyncValue.loading(),
          nutrition: const AsyncValue.loading(),
        )); // refresh() removed from constructor to prevent build-time updates

  Future<void> refresh() async {
    state = state.copyWith(
      today: const AsyncValue.loading(),
      logs: const AsyncValue.loading(),
      water: const AsyncValue.loading(),
      nutrition: const AsyncValue.loading(),
    );

    final results = await Future.wait([
      AsyncValue.guard(() => _service.getToday()),
      AsyncValue.guard(() => _service.getLogs()),
      AsyncValue.guard(() => _service.getWater()),
      AsyncValue.guard(() => _service.getNutrition()),
    ]);

    state = state.copyWith(
      today: results[0] as AsyncValue<ActivityLogDto>,
      logs: results[1] as AsyncValue<List<ActivityLogDto>>,
      water: results[2] as AsyncValue<List<WaterEntryDto>>,
      nutrition: results[3] as AsyncValue<List<NutritionEntryDto>>,
    );
  }


  Future<void> fetchToday() async {
    state = state.copyWith(today: const AsyncValue.loading());
    state = state.copyWith(today: await AsyncValue.guard(() => _service.getToday()));
  }

  Future<void> fetchLogs() async {
    state = state.copyWith(logs: const AsyncValue.loading());
    state = state.copyWith(logs: await AsyncValue.guard(() => _service.getLogs()));
  }

  Future<void> fetchWater() async {
    state = state.copyWith(water: const AsyncValue.loading());
    state = state.copyWith(water: await AsyncValue.guard(() => _service.getWater()));
  }

  Future<void> fetchNutrition() async {
    state = state.copyWith(nutrition: const AsyncValue.loading());
    state = state.copyWith(nutrition: await AsyncValue.guard(() => _service.getNutrition()));
  }

  Future<void> logActivity(ActivityLogDto dto) async {
    try {
      await _service.logActivity(dto);
      await refresh();
    } catch (e, st) {
      // Handle error
    }
  }
}

final activityProvider = StateNotifierProvider<ActivityNotifier, ActivityState>((ref) {
  return ActivityNotifier();
});
