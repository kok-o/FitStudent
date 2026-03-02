import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'workout_service.dart';
import 'workout_models.dart';
import '../activity/activity_service.dart';
import '../activity/models.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  final _service = WorkoutService();
  final _activityService = ActivityService();
  late Future<List<WorkoutDto>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getAllWorkouts();
  }

  bool _completing = false;

  Future<void> _complete(WorkoutDto w) async {
    setState(() => _completing = true);
    try {
      await _service.completeWorkout(w.id, actualCalories: w.calories);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout completed!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _completing = false);
    }
  }

  Future<void> _logWater(int amount) async {
    try {
      final timestamp = DateTime.now().toIso8601String();
      await _activityService.addWater(WaterEntryDto(timestamp: timestamp, ml: amount));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added $amount ml water')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error logging water: $e')));
    }
  }

  Future<void> _updateSleep(double hours) async {
    try {
      final current = await _activityService.getToday();
      await _activityService.logActivity(ActivityLogDto(
        id: current.id,
        steps: current.steps,
        calories: current.calories,
        sleepHours: hours,
        date: current.date,
        notes: current.notes,
      ));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sleep updated to $hours hours')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating sleep: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Daily Tracking & Workouts', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily Logging', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.local_drink,
                          label: 'Log\nWater',
                          color: Colors.cyan,
                          onTap: () async {
                            final ml = await _showWaterDialog(context);
                            if (ml != null && ml > 0) _logWater(ml);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.bedtime,
                          label: 'Log\nSleep',
                          color: Colors.deepPurple,
                          onTap: () async {
                            final h = await _showSleepDialog(context);
                            if (h != null) _updateSleep(h);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text('Available Workouts', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          FutureBuilder<List<WorkoutDto>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(child: Center(child: Text('Error: ${snapshot.error}')));
              }
              final items = snapshot.data ?? const [];
              if (items.isEmpty) {
                return const SliverFillRemaining(child: Center(child: Text('No workouts available')));
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildWorkoutCard(items[index]),
                  childCount: items.length,
                ),
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutDto w) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showWorkoutDetailsDialog(context, w),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.fitness_center, color: AppTheme.primaryColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(w.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Level: ${w.level}', style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500)),
                  Text('${w.calories ?? 0} kcal', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _completing ? null : () => _complete(w),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                elevation: 0,
              ),
              child: const Text('Complete', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Future<double?> _showSleepDialog(BuildContext context) async {
    double value = 8.0;
    return showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sleep Hours', style: TextStyle(fontWeight: FontWeight.bold)),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${value.toStringAsFixed(1)} hours', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
              const SizedBox(height: 16),
              Slider(
                value: value,
                min: 0,
                max: 15,
                divisions: 30,
                activeColor: Colors.deepPurple,
                onChanged: (v) => setState(() => value = v),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, value), 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Save')
          ),
        ],
      ),
    );
  }

  Future<int?> _showWaterDialog(BuildContext context) async {
    int value = 250;
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Water (ml)', style: TextStyle(fontWeight: FontWeight.bold)),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$value ml', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.cyan)),
              const SizedBox(height: 16),
              Slider(
                value: value.toDouble(),
                min: 50,
                max: 2000,
                divisions: 39,
                activeColor: Colors.cyan,
                onChanged: (v) => setState(() => value = v.toInt()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, value), 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Save')
          ),
        ],
      ),
    );
  }

  void _showWorkoutDetailsDialog(BuildContext context, WorkoutDto w) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(w.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (w.description != null && w.description!.isNotEmpty) ...[
                Text(w.description!, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 16),
              ],
              Text('Level: ${w.level}', style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('Duration: ${w.duration ?? '-'} min', style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('Est. Calories: ${w.calories ?? '-'} kcal', style: const TextStyle(fontWeight: FontWeight.w500)),
              if (w.exercises.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Exercises:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...w.exercises.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                      Expanded(child: Text(e)),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (!_completing) _complete(w);
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Complete')
          ),
        ],
      ),
    );
  }
}
