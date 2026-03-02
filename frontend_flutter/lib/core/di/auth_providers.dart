import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/auth_service.dart';
import '../secure_storage.dart';

class AuthState {
  const AuthState({required this.token});
  final String? token;
  bool get isAuthenticated => token != null && token!.isNotEmpty;
}

class AuthController extends AsyncNotifier<AuthState> {
  late final SecureTokenStorage _storage;
  late final AuthService _auth;

  @override
  Future<AuthState> build() async {
    _storage = SecureTokenStorage();
    _auth = AuthService();
    final t = await _storage.readToken();
    return AuthState(token: t);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _auth.login(email, password);
      final t = await _storage.readToken();
      state = AsyncValue.data(AuthState(token: t));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _auth.register(name, email, password);
      final t = await _storage.readToken();
      state = AsyncValue.data(AuthState(token: t));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.clear();
    state = const AsyncValue.data(AuthState(token: null));
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
