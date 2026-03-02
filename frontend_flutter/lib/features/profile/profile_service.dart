import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import 'profile_models.dart';

class ProfileService {
  ProfileService({ApiClient? apiClient}) : _api = (apiClient ?? ApiClient()).client;

  final Dio _api;

  Future<UserProfileDto> getProfile() async {
    final res = await _api.get('/api/user/profile');
    if (res.statusCode != 200) {
      throw Exception('Failed to load profile: HTTP ${res.statusCode}');
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected profile format');
    }
    return UserProfileDto.fromJson(data);
  }

  Future<UserProfileDto> updateProfile(UserProfileDto dto) async {
    final res = await _api.put('/api/user/profile', data: dto.toJson());
    if (res.statusCode != 200) {
      throw Exception('Failed to update profile: HTTP ${res.statusCode}');
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected profile format');
    }
    return UserProfileDto.fromJson(data);
  }

  Future<ProfileCalculationsDto> getCalculations() async {
    final res = await _api.get('/api/user/profile/calculations');
    if (res.statusCode != 200) {
      throw Exception('Failed to load calculations: HTTP ${res.statusCode}');
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected calculations format');
    }
    return ProfileCalculationsDto.fromJson(data);
  }

  Future<UserPreferenceDto> getPreferences() async {
    final res = await _api.get('/api/user/preferences');
    if (res.statusCode != 200) {
      throw Exception('Failed to load preferences: HTTP ${res.statusCode}');
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected preferences format');
    }
    return UserPreferenceDto.fromJson(data);
  }

  Future<UserPreferenceDto> updatePreferences(UserPreferenceDto dto) async {
    final res = await _api.put('/api/user/preferences', data: dto.toJson());
    if (res.statusCode != 200) {
      throw Exception('Failed to update preferences: HTTP ${res.statusCode}');
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected preferences format');
    }
    return UserPreferenceDto.fromJson(data);
  }

  Future<UserProfileDto> uploadPhoto({required List<int> bytes, required String filename}) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: filename),
    });
    final res = await _api.post('/api/user/profile/photo', data: formData,
        options: Options(contentType: 'multipart/form-data'));
    if (res.statusCode != 200) {
      throw Exception('Failed to upload photo: HTTP ${res.statusCode}');
    }
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected profile format after upload');
    }
    return UserProfileDto.fromJson(data);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final res = await _api.put('/api/user/profile/password', data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
    if (res.statusCode != 200) {
      throw Exception('Failed to change password: HTTP ${res.statusCode}');
    }
  }
}
