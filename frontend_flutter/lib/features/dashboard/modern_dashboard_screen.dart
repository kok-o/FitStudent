import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
<<<<<<< HEAD
import '../../core/api_client.dart';
import '../../core/widgets/gradient_card.dart';
import '../../core/widgets/shimmer_loading.dart';
import '../profile/profile_provider.dart';
import '../activity/activity_provider.dart';
import '../activity/models.dart';
import '../notifications/notification_service.dart';
import 'package:frontend_flutter/generated/app_localizations.dart';
=======
import '../../core/widgets/gradient_card.dart';
import '../../core/widgets/shimmer_loading.dart';
import '../profile/profile_provider.dart';
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e

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
<<<<<<< HEAD
    Future.microtask(() => _loadData());
  }

  Future<void> _loadData() async {
    // Data is loaded by providers, we can refresh them if needed
    ref.read(profileProvider.notifier).load();
    ref.read(activityProvider.notifier).refresh();
=======
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(l10n),
          SliverToBoxAdapter(child: _buildStatsCards(l10n)),
          SliverToBoxAdapter(child: _buildQuickActions(l10n)),
          _buildActivityHeader(l10n),
          _buildActivityFeed(l10n),
=======
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildStatsCards()),
          SliverToBoxAdapter(child: _buildQuickActions()),
          _buildActivityFeed(),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
<<<<<<< HEAD
          context.go('/workouts');
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.newWorkout),
=======
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New Workout - Coming soon!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Workout'),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildAppBar(AppLocalizations l10n) {
=======
  Widget _buildAppBar() {
    final profileState = ref.watch(profileProvider);
    final userName = profileState.profile.when(
      data: (profile) => profile?.name ?? 'User',
      loading: () => 'User',
      error: (_, __) => 'User',
    );
    
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
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
<<<<<<< HEAD
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
=======
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child: const Icon(Icons.person, color: Colors.white),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
<<<<<<< HEAD
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
=======
                            Text(
                              'Hello, $userName!',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Ready for today\'s workout?',
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                            ),
                          ],
                        ),
                      ),
<<<<<<< HEAD
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
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
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

<<<<<<< HEAD
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
=======
  Widget _buildStatsCards() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: ShimmerCard(height: 120)),
            SizedBox(width: 12),
            Expanded(child: ShimmerCard(height: 120)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.local_fire_department,
              value: '1,245',
              label: 'Calories',
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.fitness_center,
              value: '12',
              label: 'Workouts',
              color: AppTheme.primaryColor,
            ),
          ),
        ],
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
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
<<<<<<< HEAD
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
=======
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
<<<<<<< HEAD
            const SizedBox(height: 12),
=======
            const SizedBox(height: 16),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
<<<<<<< HEAD
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
<<<<<<< HEAD
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
            ),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildQuickActions(AppLocalizations l10n) {
=======
  Widget _buildQuickActions() {
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
<<<<<<< HEAD
            l10n.quickActions,
=======
            'Quick Actions',
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
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
<<<<<<< HEAD
                  label: l10n.startWorkout,
                  color: AppTheme.primaryColor,
                  onTap: () {
                    context.go('/workouts');
=======
                  label: 'Start Workout',
                  color: AppTheme.primaryColor,
                  onTap: () {
                    // TODO: Navigate to workout screen or show workout dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Start Workout - Coming soon!')),
                    );
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.restaurant_menu,
<<<<<<< HEAD
                  label: l10n.logMeal,
                  color: AppTheme.primaryColor,
                  onTap: () {
                    context.go('/activity'); // Go to activity log
=======
                  label: 'Log Meal',
                  color: AppTheme.primaryColor,
                  onTap: () {
                    context.go('/diet');
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
<<<<<<< HEAD
                  icon: Icons.edit_calendar_outlined,
                  label: l10n.dailyLog,
                  color: AppTheme.primaryColor,
                  onTap: () {
                    context.go('/activity');
=======
                  icon: Icons.show_chart,
                  label: 'Progress',
                  color: AppTheme.primaryColor,
                  onTap: () {
                    context.go('/progress');
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
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
<<<<<<< HEAD
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(12),
=======
        child: Padding(
          padding: const EdgeInsets.all(16),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
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

<<<<<<< HEAD
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
=======
  Widget _buildActivityFeed() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (_isLoading) {
              return const ShimmerListTile();
            }
            return _buildActivityCard(index);
          },
          childCount: _isLoading ? 5 : 10,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildActivityCard(ActivityLogDto log, AppLocalizations l10n) {
=======
  Widget _buildActivityCard(int index) {
    final activities = [
      {
        'type': 'workout',
        'title': 'Morning Cardio',
        'subtitle': '30 min • 245 calories',
        'time': '2 hours ago',
        'icon': Icons.directions_run,
      },
      {
        'type': 'meal',
        'title': 'Healthy Breakfast',
        'subtitle': '450 calories • High protein',
        'time': '3 hours ago',
        'icon': Icons.restaurant,
      },
      {
        'type': 'water',
        'title': 'Water Intake',
        'subtitle': '2.5L completed',
        'time': '5 hours ago',
        'icon': Icons.water_drop,
      },
      {
        'type': 'workout',
        'title': 'Strength Training',
        'subtitle': '45 min • 320 calories',
        'time': 'Yesterday',
        'icon': Icons.fitness_center,
      },
      {
        'type': 'achievement',
        'title': 'New Record!',
        'subtitle': 'Completed 7-day streak',
        'time': 'Yesterday',
        'icon': Icons.emoji_events,
      },
    ];

    final activity = activities[index % activities.length];

>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
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
<<<<<<< HEAD
          child: const Icon(
            Icons.directions_run,
=======
          child: Icon(
            activity['icon'] as IconData,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
            color: AppTheme.primaryColor,
            size: 24,
          ),
        ),
        title: Text(
<<<<<<< HEAD
          l10n.workoutSession,
=======
          activity['title'] as String,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
<<<<<<< HEAD
            Text('${log.steps} ${l10n.steps.toLowerCase()} • ${log.calories} ${l10n.calories.toLowerCase()}'),
            const SizedBox(height: 4),
            Text(
              '${l10n.date}: ${ActivityLogDto.formatDate(log.date)}',
=======
            Text(activity['subtitle'] as String),
            const SizedBox(height: 4),
            Text(
              activity['time'] as String,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
<<<<<<< HEAD
=======
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      ),
    );
  }
}
