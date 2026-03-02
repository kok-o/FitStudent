import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_service.dart';
import 'profile_models.dart';

class ProfileState {
  final AsyncValue<UserProfileDto?> profile;
  const ProfileState({required this.profile});
  ProfileState copyWith({AsyncValue<UserProfileDto?>? profile}) => ProfileState(profile: profile ?? this.profile);
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileService _service = ProfileService();
  ProfileNotifier() : super(const ProfileState(profile: AsyncValue.loading())) {
    load();
  }

  Future<void> load() async {
    try {
      final dto = await _service.getProfile();
      state = state.copyWith(profile: AsyncValue.data(dto));
    } catch (e, st) {
      state = state.copyWith(profile: AsyncValue.error(e, st));
    }
  }

  Future<void> save(UserProfileDto profile) async {
    state = state.copyWith(profile: const AsyncValue.loading());
    try {
      final updated = await _service.updateProfile(profile);
      state = state.copyWith(profile: AsyncValue.data(updated));
    } catch (e, st) {
      state = state.copyWith(profile: AsyncValue.error(e, st));
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) => ProfileNotifier());
