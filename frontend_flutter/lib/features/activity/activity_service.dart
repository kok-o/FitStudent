import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import 'models.dart';

class ActivityService {
  ActivityService({ApiClient? apiClient}) : _api = (apiClient ?? ApiClient()).client;
  final Dio _api;

  Future<ActivityLogDto> getToday() async {
    final res = await _api.get('/api/activity/today');
    if (res.statusCode != 200) {
      throw Exception('Failed to load today activity: HTTP ${res.statusCode}');
    }
    if (res.data == null || (res.data is String && (res.data as String).isEmpty)) {
      return ActivityLogDto(steps: 0, calories: 0, sleepHours: 0.0, date: DateTime.now());
    }
    return ActivityLogDto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<List<ActivityLogDto>> getLogs() async {
    final res = await _api.get('/api/activity/logs');
    if (res.statusCode != 200) {
      throw Exception('Failed to load logs: HTTP ${res.statusCode}');
    }
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map(ActivityLogDto.fromJson).toList();
  }

  Future<ActivityLogDto> logActivity(ActivityLogDto dto) async {
    final res = await _api.post('/api/activity/log', data: dto.toJson());
    if (res.statusCode != 200) {
      throw Exception('Failed to save activity: HTTP ${res.statusCode}');
    }
    return ActivityLogDto.fromJson(res.data as Map<String, dynamic>);
  }

  // Water
  Future<List<WaterEntryDto>> getWater() async {
    final res = await _api.get('/api/activity/water');
    if (res.statusCode != 200) throw Exception('Failed to load water: HTTP ${res.statusCode}');
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map(WaterEntryDto.fromJson).toList();
  }

  Future<WaterEntryDto> addWater(WaterEntryDto dto) async {
    final res = await _api.post('/api/activity/water', data: dto.toJson());
    if (res.statusCode != 200) throw Exception('Failed to add water: HTTP ${res.statusCode}');
    return WaterEntryDto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<WaterEntryDto> updateWater(WaterEntryDto dto) async {
    if (dto.id == null) throw Exception('id required');
    final res = await _api.put('/api/activity/water/${dto.id}', data: dto.toJson());
    if (res.statusCode != 200) throw Exception('Failed to update water: HTTP ${res.statusCode}');
    return WaterEntryDto.fromJson(res.data as Map<String, dynamic>);
  }

  // Nutrition
  Future<List<NutritionEntryDto>> getNutrition() async {
    final res = await _api.get('/api/activity/nutrition');
    if (res.statusCode != 200) throw Exception('Failed to load nutrition: HTTP ${res.statusCode}');
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map(NutritionEntryDto.fromJson).toList();
  }

  Future<NutritionEntryDto> addNutrition(NutritionEntryDto dto) async {
    final res = await _api.post('/api/activity/nutrition', data: dto.toJson());
    if (res.statusCode != 200) throw Exception('Failed to add nutrition: HTTP ${res.statusCode}');
    return NutritionEntryDto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<NutritionEntryDto> updateNutrition(NutritionEntryDto dto) async {
    if (dto.id == null) throw Exception('id required');
    final res = await _api.put('/api/activity/nutrition/${dto.id}', data: dto.toJson());
    if (res.statusCode != 200) throw Exception('Failed to update nutrition: HTTP ${res.statusCode}');
    return NutritionEntryDto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<String> exportCsv({String? from, String? to}) async {
    final res = await _api.get('/api/activity/export.csv', queryParameters: {
      if (from != null) 'from': from,
      if (to != null) 'to': to,
    }, options: Options(responseType: ResponseType.plain));
    if (res.statusCode != 200) throw Exception('Failed to export CSV: HTTP ${res.statusCode}');
    return res.data as String;
  }
}
