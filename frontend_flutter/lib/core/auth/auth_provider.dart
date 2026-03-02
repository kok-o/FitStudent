import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth_state.dart' as global_auth;

class AuthState {
  final bool isAuthenticated;
  final String? role;
  final String? name;
  const AuthState({required this.isAuthenticated, this.role, this.name});
  AuthState copyWith({bool? isAuthenticated, String? role, String? name}) =>
      AuthState(isAuthenticated: isAuthenticated ?? this.isAuthenticated, role: role ?? this.role, name: name ?? this.name);
}

class AuthController extends StateNotifier<AuthState> {
  static const roleKey = 'smartdiet_role';
  AuthController() : super(const AuthState(isAuthenticated: false, role: 'guest')) {
    _init();
  }

  Future<void> _init() async {
    final sp = await SharedPreferences.getInstance();
    final savedRole = sp.getString(roleKey) ?? 'guest';
    final hasToken = global_auth.AuthState.isAuthenticated;
    state = state.copyWith(role: savedRole, isAuthenticated: hasToken);
  }

  Future<void> setRole(String role) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(roleKey, role);
    state = state.copyWith(role: role);
  }

  void setAuthenticated(bool v) {
    state = state.copyWith(isAuthenticated: v);
  }
<<<<<<< HEAD

  Future<void> logout() async {
    await global_auth.AuthState.clear();
    final sp = await SharedPreferences.getInstance();
    await sp.remove(roleKey);
    state = const AuthState(isAuthenticated: false, role: 'guest');
  }
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
}

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) => AuthController());
