import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/api_client.dart';
import '../../core/widgets/gradient_card.dart';
import '../../core/widgets/shimmer_loading.dart';
import '../profile/profile_provider.dart';
import '../activity/activity_provider.dart';
import '../activity/models.dart';
import '../notifications/notification_service.dart';
import 'package:frontend_flutter/generated/app_localizations.dart';

class ModernDashboardScreen extends ConsumerStatefulWidget {
  const ModernDashboardScreen({super.key});

  @override
  ConsumerState<ModernDashboardScreen> createState() => _ModernDashboardScreenState();
}

class _ModernDashboardScreenState extends ConsumerState<ModernDashboardScreen> {
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadData());
  }

  Future<void> _loadData() async {
    // Data is loaded by providers, we can refresh them if needed
    ref.read(profileProvider.notifier).load();
    ref.read(activityProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(l10n),
          SliverToBoxAdapter(child: _buildStatsCards(l10n)),
          SliverToBoxAdapter(child: _buildQuickActions(l10n)),
          _buildActivityHeader(l10n),
          _buildActivityFeed(l10n),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/workouts');
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.newWorkout),
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      ref.watch(profileProvider).profile.when(
                        data: (profile) => CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          backgroundImage: profile?.photoUrl != null && profile!.photoUrl!.isNotEmpty
                              ? NetworkImage(
                                  profile!.photoUrl!.startsWith('http')
                                      ? profile!.photoUrl!
                                      : '${ApiClient.baseUrl}${profile!.photoUrl}',
                                )
                              : null,
                          child: profile?.photoUrl == null || profile!.photoUrl!.isEmpty
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        loading: () => CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        ),
                        error: (_, __) => CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ref.watch(profileProvider).profile.when(
                              data: (profile) => Text(
                                '${l10n.hello}, ${profile?.name ?? 'User'}!',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              loading: () => const ShimmerLoading(width: 100, height: 20),
                              error: (_, __) => Text(
                                '${l10n.hello}!',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Text(
                              l10n.readyForWorkout,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, _) {
                          final unreadAsync = ref.watch(unreadNotificationsCountProvider);
                          final count = unreadAsync.valueOrNull ?? 0;
                          return IconButton(
                            icon: Badge(
                              isLabelVisible: count > 0,
                              label: Text('$count'),
                              child: const Icon(Icons.notifications_none, color: Colors.white),
                            ),
                            onPressed: () => context.push('/notifications'),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(AppLocalizations l10n) {
    final activityState = ref.watch(activityProvider);
    final activityAsync = activityState.today;
    final logsAsync = activityState.logs;
    final waterAsync = activityState.water;

    final todayWater = waterAsync.when(
      data: (list) {
        final todayStr = DateTime.now().toIso8601String().substring(0, 10);
        return list
            .where((e) => e.timestamp.startsWith(todayStr))
            .fold<int>(0, (sum, e) => sum + e.ml);
      },
      loading: () => 0,
      error: (_, __) => 0,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: activityAsync.when(
        data: (today) => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.local_fire_department,
                    value: today.calories.toString(),
                    label: l10n.calories,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.fitness_center,
                    value: logsAsync.when(
                      data: (logs) {
                        final today = DateTime.now();
                        return logs.where((l) => 
                          l.date.year == today.year && 
                          l.date.month == today.month && 
                          l.date.day == today.day
                        ).length.toString();
                      },
                      loading: () => '...',
                      error: (_, __) => '0',
                    ),
                    label: l10n.dashboard, // Changed Workouts string, perhaps to "Workouts" or "Dashboard"
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.bedtime_outlined,
                    value: today.sleepHours.toStringAsFixed(1),
                    label: l10n.sleepHours,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.local_drink_outlined,
                    value: '$todayWater ${l10n.milliliters}',
                    label: l10n.water,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
        loading: () => Column(
          children: [
            Row(
              children: [
                Expanded(child: ShimmerCard(height: 120)),
                const SizedBox(width: 12),
                Expanded(child: ShimmerCard(height: 120)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: ShimmerCard(height: 120)),
                const SizedBox(width: 12),
                Expanded(child: ShimmerCard(height: 120)),
              ],
            ),
          ],
        ),
        error: (_, __) => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.local_fire_department,
                    value: '0',
                    label: 'Calories',
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.fitness_center,
                    value: '0',
                    label: 'Workouts',
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quickActions,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.play_circle_outline,
                  label: l10n.startWorkout,
                  color: AppTheme.primaryColor,
                  onTap: () {
                    context.go('/workouts');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.restaurant_menu,
                  label: l10n.logMeal,
                  color: AppTheme.primaryColor,
                  onTap: () {
                    context.go('/activity'); // Go to activity log
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.edit_calendar_outlined,
                  label: l10n.dailyLog,
                  color: AppTheme.primaryColor,
                  onTap: () {
                    context.go('/activity');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityHeader(AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Text(
          l10n.recentActivity,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget _buildActivityFeed(AppLocalizations l10n) {
    final logsAsync = ref.watch(activityProvider).logs;

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return SliverToBoxAdapter(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.history, size: 48, color: AppTheme.textTertiary),
                      const SizedBox(height: 12),
                      Text(
                        l10n.noActivityYet,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.startFirstWorkout,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildActivityCard(logs[index], l10n),
              childCount: logs.length,
            ),
          );
        },
        loading: () => SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const ShimmerListTile(),
            childCount: 3,
          ),
        ),
        error: (err, __) => SliverToBoxAdapter(
          child: Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildActivityCard(ActivityLogDto log, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.directions_run,
            color: AppTheme.primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          l10n.workoutSession,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${log.steps} ${l10n.steps.toLowerCase()} • ${log.calories} ${l10n.calories.toLowerCase()}'),
            const SizedBox(height: 4),
            Text(
              '${l10n.date}: ${ActivityLogDto.formatDate(log.date)}',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
