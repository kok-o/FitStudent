import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/api_client.dart';
import '../../core/widgets/shimmer_loading.dart';
import '../../core/widgets/gradient_card.dart';
import 'package:frontend_flutter/generated/app_localizations.dart';
import '../../l10n/app_localizations_extension.dart';
import 'profile_provider.dart';
import 'profile_models.dart';
import '../activity/activity_provider.dart';
import '../support/support_service.dart';
import '../../core/auth/auth_provider.dart';

class ModernProfileScreen extends ConsumerWidget {
  const ModernProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider).profile;
    final activityState = ref.watch(activityProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: profileAsync.when(
        data: (profile) => CustomScrollView(
          slivers: [
            _buildAppBar(context, l10n),
            SliverToBoxAdapter(child: _buildProfileHeader(context, profile, l10n)),
            SliverToBoxAdapter(child: _buildStatsSection(context, activityState, l10n)),
            SliverToBoxAdapter(child: _buildMenuSection(context, ref, l10n, profile)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, __) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(l10n.profile, style: const TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          onPressed: () {
            context.push('/settings');
          },
          icon: Icon(Icons.settings_outlined, color: AppTheme.primaryColor),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProfileDto? profile, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              backgroundImage: profile?.photoUrl != null && profile!.photoUrl!.isNotEmpty
                  ? NetworkImage(
                      profile!.photoUrl!.startsWith('http')
                          ? profile!.photoUrl!
                          : '${ApiClient.baseUrl}${profile!.photoUrl}',
                    )
                  : null,
              child: profile?.photoUrl == null || profile!.photoUrl!.isEmpty
                  ? Icon(Icons.person, size: 60, color: AppTheme.primaryColor)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile?.name ?? '—',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            profile?.email ?? '—',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
        ],
      ),
    );
  }


  Widget _buildStatsSection(BuildContext context, ActivityState activity, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              activity.logs.value?.length.toString() ?? '0',
              l10n.welcomeBack, // using welcomeBack as temporary or anything, wait we can use something else or 'dashboard'
              Icons.fitness_center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              activity.today.value?.calories.toString() ?? '0',
              l10n.calories,
              Icons.local_fire_department,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              (activity.logs.value?.map((l) => l.date).toSet().length ?? 0).toString(),
              l10n.activeDays,
              Icons.calendar_today,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon) {
    return Card(
      child: Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMenuSection(BuildContext context, WidgetRef ref, AppLocalizations l10n, UserProfileDto? profile) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.medical_services_outlined,
            title: l10n.medicalProfile,
            subtitle: l10n.diagnoses,
            onTap: () => context.push('/profile/medical'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.health_and_safety_outlined,
            title: l10n.foodCheck,
            subtitle: l10n.checkFood,
            onTap: () => context.push('/food-check'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings_outlined,
            title: l10n.settings_label,
            subtitle: 'App preferences and privacy',
            onTap: () {
              context.push('/settings');
            },
          ),
          if (profile?.role?.toUpperCase() == 'ADMIN')
            _buildMenuItem(
              context,
              icon: Icons.admin_panel_settings_outlined,
              title: l10n.users_label,
              subtitle: l10n.manage_users_subtitle,
              onTap: () => context.go('/admin'),
            ),
          if (profile?.role?.toUpperCase() != 'ADMIN')
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              title: l10n.support_label,
              subtitle: '',
              onTap: () => context.push('/support'),
            ),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: l10n.logout_label,
            subtitle: 'Sign out of your account',
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.logout_label),
                  content: Text(l10n.logout_confirm),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel_label)),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n.logout_label, style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              }
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDestructive
                ? AppTheme.errorColor.withOpacity(0.1)
                : AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? AppTheme.errorColor : null,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive ? AppTheme.errorColor : AppTheme.textTertiary,
        ),
      ),
    );
  }

}
