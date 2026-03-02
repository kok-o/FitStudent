import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import 'models.dart';
import '../../core/auth_state.dart';

class AuthService {
  AuthService({ApiClient? apiClient}) : _api = (apiClient ?? ApiClient()).client;

  final Dio _api;

  Future<void> login(String email, String password) async {
    try {
      final response = await _api.post('/api/auth/login', data: LoginRequest(email: email, password: password).toJson());
      if (response.statusCode != 200) {
        throw Exception('Login failed: HTTP ${response.statusCode}');
      }
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final auth = AuthResponse.fromJson(data);
        AuthState.setToken(auth.token);
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        final message = e.response?.data['message'];
        if (message != null) {
          throw Exception(message);
        }
      }
      throw Exception('Network error or server unavailable');
    }
  }

  Future<void> register(String name, String email, String password) async {
    final req = RegisterRequest(email: email, password: password, name: name);
    final response = await _api.post('/api/auth/register', data: req.toJson());
    if (response.statusCode != 200) {
      throw Exception('Registration failed: HTTP ${response.statusCode}');
    }
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final auth = AuthResponse.fromJson(data);
      AuthState.setToken(auth.token);
    }
  }

  Future<void> logout() async {
    try {
      // No server endpoint required for JWT; just clear token locally.
      AuthState.clear();
    } catch (_) {}
  }
}



