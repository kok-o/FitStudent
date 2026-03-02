import 'package:dio/dio.dart';
import 'package:dio/browser.dart';
import 'package:flutter/foundation.dart';
import 'auth_state.dart';

class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      headers: {'Content-Type': 'application/json'},
<<<<<<< HEAD
      validateStatus: (status) => status! < 500, // Handle 404 as valid response
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
    );
    if (kIsWeb) {
      final adapter = BrowserHttpClientAdapter()..withCredentials = true;
      _dio.httpClientAdapter = adapter;
    }

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = AuthState.token;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ' + token;
        }
        handler.next(options);
      },
    ));
  }

  static const String _envBase = String.fromEnvironment('API_BASE_URL');
  static final String _baseUrl = _envBase.isNotEmpty
      ? _envBase
      : (kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080');

  final Dio _dio;

  Dio get client => _dio;
  
  static String get baseUrl => _baseUrl;
}



