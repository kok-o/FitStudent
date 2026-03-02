import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/api_providers.dart';

class FoodReplacement {
  final String original;
  final String replacement;
  final String reason;

  FoodReplacement({
    required this.original,
    required this.replacement,
    required this.reason,
  });

  factory FoodReplacement.fromJson(Map<String, dynamic> json) {
    return FoodReplacement(
      original: json['original'] ?? '',
      replacement: json['replacement'] ?? '',
      reason: json['reason'] ?? '',
    );
  }
}

class FoodCheckResult {
  final String status;
  final String reason;
  final List<FoodReplacement> replacements;

  FoodCheckResult({
    required this.status,
    required this.reason,
    required this.replacements,
  });

  factory FoodCheckResult.fromJson(Map<String, dynamic> json) {
    return FoodCheckResult(
      status: json['status'] ?? 'ALLOWED',
      reason: json['reason'] ?? '',
      replacements: (json['replacements'] as List? ?? [])
          .map((e) => FoodReplacement.fromJson(e))
          .toList(),
    );
  }
}

class FoodCheckService {
  final Ref _ref;

  FoodCheckService(this._ref);

  Future<FoodCheckResult> checkFood(String foodName) async {
    final apiClient = _ref.read(apiClientProvider);
    final response = await apiClient.client.post(
      '/api/food/check',
      data: {'foodName': foodName},
    );

    if (response.statusCode == 200) {
      return FoodCheckResult.fromJson(response.data);
    } else {
      throw Exception('Failed to check food');
    }
  }
}

final foodCheckServiceProvider = Provider<FoodCheckService>((ref) {
  return FoodCheckService(ref);
});
