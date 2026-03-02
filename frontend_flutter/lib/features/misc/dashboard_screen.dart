import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_flutter/generated/app_localizations.dart';
import '../profile/profile_service.dart';
import '../profile/profile_models.dart';
import '../activity/activity_service.dart';
import '../activity/models.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.dashboard)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Calculations card
          FutureBuilder<ProfileCalculationsDto>(
            future: ProfileService().getCalculations(),
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const _Skeleton(height: 120);
              }
              if (snap.hasError) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.error_outline, color: Colors.orange),
                    title: Text(t.calculations),
                    subtitle: Text('${t.error}: ${snap.error}'),
                  ),
                );
              }
              if (!snap.hasData || snap.data!.bmi == null) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.blue),
                    title: Text(t.calculations),
                    subtitle: const Text('Please fill your profile data (height, weight, age) to see calculations'),
                    trailing: TextButton(
                      onPressed: () => context.go('/profile'),
                      child: Text(t.profile),
                    ),
                  ),
                );
              }
              final c = snap.data!;
              return Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.analytics_outlined, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Text(t.calculations, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(spacing: 12, runSpacing: 12, children: [
                      _statCard(t.bmi, c.bmi?.toStringAsFixed(1) ?? '-', Icons.monitor_weight_outlined),
                      _statCard(t.bmr, c.bmr?.toStringAsFixed(0) ?? '-', Icons.local_fire_department_outlined),
                      _statCard(t.tdee, c.tdee?.toStringAsFixed(0) ?? '-', Icons.flash_on_outlined),
                      _statCard(t.targetKcal, c.targetCalories?.toStringAsFixed(0) ?? '-', Icons.restaurant_outlined),
                    ]),
                  ]),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          // Today activity card
          FutureBuilder<ActivityLogDto>(
            future: ActivityService().getToday(),
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const _Skeleton(height: 100);
              }
              if (!snap.hasData) {
                return Card(child: ListTile(title: Text(t.today), subtitle: Text(t.error)));
              }
              final a = snap.data!;
              return Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.today_outlined, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Text(t.today, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(children: [
                        _stat(Icons.directions_walk, t.steps, a.steps?.toString() ?? '-'),
                        const SizedBox(width: 16),
                        _stat(Icons.local_fire_department_outlined, t.calories, a.calories?.toString() ?? '-'),
                        const SizedBox(width: 16),
                        _stat(Icons.nightlight_round, t.sleepHours, a.sleepHours?.toStringAsFixed(1) ?? '-'),
                      ]),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _Tile(icon: Icons.person_outline, label: t.profileNav, route: '/profile', gradient: const [Color(0xFFEC4899), Color(0xFFDB2777)]),
              _Tile(icon: Icons.directions_walk, label: t.activityNav, route: '/activity', gradient: const [Color(0xFF3B82F6), Color(0xFF2563EB)]),
              _Tile(icon: Icons.restaurant_menu_outlined, label: t.dietNav, route: '/diet', gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)]),
              _Tile(icon: Icons.show_chart_outlined, label: t.progressNav, route: '/progress', gradient: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)]),
              _Tile(icon: Icons.menu_book_outlined, label: t.recipesNav, route: '/recipes', gradient: const [Color(0xFF14B8A6), Color(0xFF0D9488)]),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final List<Color> gradient;
  const _Tile({required this.icon, required this.label, required this.route, required this.gradient});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _statCard(String label, String value, IconData icon) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.9))),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ],
    ),
  );
}

class _Skeleton extends StatelessWidget {
  final double height;
  const _Skeleton({required this.height});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

Widget _stat(IconData icon, String label, String value) {
  return Expanded(
    child: Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9))),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    ),
  );
}
