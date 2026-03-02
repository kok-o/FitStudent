import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
<<<<<<< HEAD
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
=======
import '../../core/widgets/gradient_card.dart';
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e

class ModernProfileScreen extends ConsumerWidget {
  const ModernProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
<<<<<<< HEAD
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
=======
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildProfileHeader(context)),
          SliverToBoxAdapter(child: _buildStatsSection(context)),
          SliverToBoxAdapter(child: _buildAchievements(context)),
          SliverToBoxAdapter(child: _buildMenuSection(context)),
        ],
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(l10n.profile, style: const TextStyle(fontWeight: FontWeight.bold)),
=======
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
        ),
      ),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      actions: [
        IconButton(
          onPressed: () {
            context.push('/settings');
          },
<<<<<<< HEAD
          icon: Icon(Icons.settings_outlined, color: AppTheme.primaryColor),
=======
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
        ),
      ],
    );
  }

<<<<<<< HEAD
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
=======
  Widget _buildProfileHeader(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -50),
      child: Column(
        children: [
          Stack(
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
                child: const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Alex Johnson',
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
<<<<<<< HEAD
            profile?.email ?? '—',
=======
            'alex.johnson@email.com',
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
<<<<<<< HEAD
=======
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge(Icons.local_fire_department, '🔥 45 Day Streak'),
              const SizedBox(width: 12),
              _buildBadge(Icons.emoji_events, '🏆 Level 12'),
            ],
          ),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
        ],
      ),
    );
  }

<<<<<<< HEAD

  Widget _buildStatsSection(BuildContext context, ActivityState activity, AppLocalizations l10n) {
=======
  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
<<<<<<< HEAD
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
=======
          Expanded(child: _buildStatCard(context, '156', 'Workouts', Icons.fitness_center)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(context, '12.5k', 'Calories', Icons.local_fire_department)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(context, '45', 'Days', Icons.calendar_today)),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon) {
    return Card(
<<<<<<< HEAD
      child: Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
=======
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
<<<<<<< HEAD
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
=======
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
            ),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD

  Widget _buildMenuSection(BuildContext context, WidgetRef ref, AppLocalizations l10n, UserProfileDto? profile) {
=======
  Widget _buildAchievements(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Achievements',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildAchievementCard('🏃', 'Marathon Runner', 'Completed 42km'),
                _buildAchievementCard('💪', 'Strength Master', '100 workouts'),
                _buildAchievementCard('🔥', 'Fire Starter', '30 day streak'),
                _buildAchievementCard('⭐', 'Rising Star', 'Level 10 reached'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String emoji, String title, String subtitle) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: GradientCard(
        gradient: AppTheme.accentGradient,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMenuItem(
            context,
<<<<<<< HEAD
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
=======
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: Icons.fitness_center,
            title: 'My Workouts',
            subtitle: 'View your workout history',
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: Icons.show_chart,
            title: 'Progress & Stats',
            subtitle: 'Track your fitness journey',
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: Icons.emoji_events,
            title: 'Achievements',
            subtitle: 'View all your badges',
            onTap: () {},
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings_outlined,
<<<<<<< HEAD
            title: l10n.settings_label,
=======
            title: 'Settings',
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
            subtitle: 'App preferences and privacy',
            onTap: () {
              context.push('/settings');
            },
          ),
<<<<<<< HEAD
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
=======
          _buildMenuItem(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help or contact us',
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: () {
              // TODO: Implement logout
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
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
<<<<<<< HEAD

=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
}
