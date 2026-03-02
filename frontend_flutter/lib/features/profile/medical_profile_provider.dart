import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/api_providers.dart';
import 'medical_profile_model.dart';

class MedicalProfileNotifier extends StateNotifier<AsyncValue<MedicalProfileModel?>> {
  final Ref _ref;

  MedicalProfileNotifier(this._ref) : super(const AsyncValue.loading()) {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    state = const AsyncValue.loading();
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.client.get('/api/medicalProfile');
      if (response.statusCode == 200) {
        state = AsyncValue.data(MedicalProfileModel.fromJson(response.data));
      } else if (response.statusCode == 404) {
        state = AsyncValue.data(MedicalProfileModel(
          diagnoses: {},
          allergies: {},
          contraindications: '',
          activityLevel: 1,
        ));
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> saveProfile(MedicalProfileModel profile) async {
    final prevState = state;
    state = const AsyncValue.loading();
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.client.post(
        '/api/medicalProfile',
        data: profile.toJson(),
      );
      if (response.statusCode == 200) {
        state = AsyncValue.data(MedicalProfileModel.fromJson(response.data));
        return true;
      }
      state = prevState;
      return false;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final medicalProfileProvider = StateNotifierProvider<MedicalProfileNotifier, AsyncValue<MedicalProfileModel?>>((ref) {
  return MedicalProfileNotifier(ref);
});
