import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/locale_provider.dart';
import '../../core/auth_state.dart' as global_auth;
import '../../core/auth/auth_provider.dart';
import 'package:frontend_flutter/generated/app_localizations.dart';
import '../../core/api_client.dart';
import '../../core/services/api_service.dart';
import '../profile/profile_service.dart';
import '../profile/profile_models.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _service = ProfileService();
  Future<UserProfileDto>? _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _service.getProfile();
  }

  void _refreshProfile() {
    setState(() {
      _profileFuture = _service.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
        elevation: 0,
      ),
      body: FutureBuilder<UserProfileDto>(
        future: _profileFuture,
        builder: (context, snap) {
          final user = snap.data;
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              _buildProfileSection(context, user, t),
              const Divider(),
              _buildSectionTitle(context, t.themeAppearance),
              _buildThemeTile(context, isDark, t),
              const Divider(),
              _buildSectionTitle(context, t.changeLanguage),
              _buildLanguageSection(context, ref, t),
              const Divider(),
              _buildSectionTitle(context, t.changePassword),
              _buildTile(
                context,
                icon: Icons.lock_outline,
                title: t.changePassword,
                onTap: () => _showChangePasswordDialog(context, t),
              ),
              const Divider(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton.icon(
                  onPressed: () => _makeMeAdmin(context),
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text('Developer: Make me Admin'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.purple,
                    side: const BorderSide(color: Colors.purple),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilledButton.icon(
                  onPressed: () => _showLogoutDialog(context, ref, t),
                  icon: const Icon(Icons.logout),
                  label: Text(t.logout),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, UserProfileDto? user, AppLocalizations t) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryColor, width: 2),
                ),
                child: ClipOval(
                  child: user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: user.photoUrl!.startsWith('http')
                              ? user.photoUrl!
                              : '${ApiClient.baseUrl}${user.photoUrl}',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.person, size: 50),
                        )
                      : const Icon(Icons.person, size: 50),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  radius: 18,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    onPressed: () => _handleUploadPhoto(context, t),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (user != null) ...[
            Text(
              user.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleUploadPhoto(BuildContext context, AppLocalizations t) async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (res == null || res.files.isEmpty) return;
    final file = res.files.single;
    final bytes = file.bytes;
    if (bytes == null) return;

    try {
      await _service.uploadPhoto(bytes: bytes, filename: file.name);
      _refreshProfile();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.photoUploaded)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${t.uploadFailed}: $e')));
      }
    }
  }

  Future<void> _makeMeAdmin(BuildContext context) async {
    try {
      await ApiService.put('/api/user/profile/make-admin', {});
      await ref.read(authProvider.notifier).setRole('ADMIN');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Success! You are now an Admin. Please check the Profile screen.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context, bool isDark, AppLocalizations t) {
    return SwitchListTile(
      secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: AppTheme.primaryColor),
      title: Text(isDark ? t.darkMode : t.lightMode),
      value: isDark,
      onChanged: (val) {
        ref.read(themeProvider.notifier).toggleTheme();
      },
    );
  }

  Widget _buildLanguageSection(BuildContext context, WidgetRef ref, AppLocalizations t) {
    final currentLocale = ref.watch(localeProvider);
    final code = currentLocale?.languageCode ?? 'en';

    return Column(
      children: [
        RadioListTile<String>(
          title: Text(t.langEnglish),
          value: 'en',
          groupValue: code,
          onChanged: (val) => ref.read(localeProvider.notifier).setLocale(val!),
        ),
        RadioListTile<String>(
          title: Text(t.langRussian),
          value: 'ru',
          groupValue: code,
          onChanged: (val) => ref.read(localeProvider.notifier).setLocale(val!),
        ),
        RadioListTile<String>(
          title: Text(t.langKazakh),
          value: 'kk',
          groupValue: code,
          onChanged: (val) => ref.read(localeProvider.notifier).setLocale(val!),
        ),
      ],
    );
  }

  Widget _buildTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showChangePasswordDialog(BuildContext context, AppLocalizations t) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(t.changePassword, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            TextField(
              controller: currentCtrl,
              decoration: InputDecoration(labelText: t.currentPassword),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newCtrl,
              decoration: InputDecoration(labelText: t.newPassword),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmCtrl,
              decoration: InputDecoration(labelText: t.confirmPassword),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (newCtrl.text != confirmCtrl.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                  return;
                }
                try {
                  await _service.changePassword(
                    currentPassword: currentCtrl.text,
                    newPassword: newCtrl.text,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.passwordChanged)));
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${t.passwordChangeFailed}: $e')));
                  }
                }
              },
              child: Text(t.confirm),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref, AppLocalizations t) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.logout),
        content: Text(t.logoutConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t.cancel)),
          TextButton(
            onPressed: () async {
              await global_auth.AuthState.clear();
              ref.read(authProvider.notifier).setAuthenticated(false);
              if (context.mounted) {
                while (context.canPop()) {
                  context.pop();
                }
                context.go('/login');
              }
            },
            child: Text(t.confirm, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
