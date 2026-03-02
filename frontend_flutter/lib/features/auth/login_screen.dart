import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_service.dart';
import '../workouts/workouts_screen.dart';
import 'register_screen.dart';
import '../../core/di/auth_providers.dart';
import '../../core/auth/auth_provider.dart' as app_auth;
<<<<<<< HEAD
import 'package:frontend_flutter/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../profile/profile_provider.dart';
=======
import 'package:frontend_flutter/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
import '../../core/widgets/animated_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  String? _error;
  bool _obscure = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );
<<<<<<< HEAD
      
      // mark global auth state for router guards
      ref.read(app_auth.authProvider.notifier).setAuthenticated(true);
      
      // Fetch profile to get actual role
      await ref.read(profileProvider.notifier).load();
      final profileSnap = ref.read(profileProvider).profile;
      
      if (profileSnap.hasValue && profileSnap.value?.role != null) {
        await ref.read(app_auth.authProvider.notifier).setRole(profileSnap.value!.role!);
      } else {
        await ref.read(app_auth.authProvider.notifier).setRole('user');
      }
      
      if (!mounted) return;
      context.go('/dashboard');
    } catch (e) {
      final t = AppLocalizations.of(context)!;
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (errorMessage.contains('User not found') || errorMessage.contains('Invalid password')) {
        errorMessage = t.invalidEmailOrPassword;
      } else {
        errorMessage = t.loginError;
      }
      setState(() {
        _error = errorMessage;
=======
      // mark global auth state for router guards
      ref.read(app_auth.authProvider.notifier).setAuthenticated(true);
      await ref.read(app_auth.authProvider.notifier).setRole('user');
      if (!mounted) return;
      context.go('/dashboard');
    } catch (e) {
      setState(() {
        _error = e.toString();
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.signIn)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(t.welcomeBack, style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(t.signInToContinue, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: t.emailLabel, prefixIcon: const Icon(Icons.email_outlined)),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || !v.contains('@')) ? t.enterValidEmail : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: t.passwordLabel,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        obscureText: _obscure,
                        validator: (v) => (v == null || v.isEmpty) ? t.enterPassword : null,
                      ),
                      const SizedBox(height: 20),
                      if (_error != null) ...[
                        Text(_error!, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 12),
                      ],
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: _loading ? null : _login,
                          child: _loading
                              ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                              : Text(t.signIn),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
<<<<<<< HEAD
                        onPressed: _loading ? null : () => context.go('/register'),
=======
                        onPressed: _loading
                            ? null
                            : () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                ),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
                        child: Text(t.dontHaveAccount),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



