import 'package:dio/dio.dart';
import 'package:dio/browser.dart';
import '../constants.dart';

class DioClient {
  final Dio dio;
  DioClient._(this.dio);

  factory DioClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );
    final adapter = BrowserHttpClientAdapter()..withCredentials = true;
    dio.httpClientAdapter = adapter;
    return DioClient._(dio);
  }
}
