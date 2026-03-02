import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_flutter/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../activity/activity_provider.dart';
import '../activity/models.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(activityProvider.notifier).refresh());
=======
import 'package:frontend_flutter/l10n/app_localizations.dart';
import '../activity/activity_service.dart';
import '../activity/models.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _service = ActivityService();
  List<ActivityLogDto> _logs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _loading = true);
    try {
      final logs = await _service.getLogs();
      if (!mounted) return;
      // Take last 7 days, sorted by date
      final sorted = logs..sort((a, b) => a.date.compareTo(b.date));
      setState(() => _logs = sorted.length > 7 ? sorted.sublist(sorted.length - 7) : sorted);
    } catch (e) {
      // Ignore errors, show empty state
      if (mounted) setState(() => _logs = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
<<<<<<< HEAD
    final activityState = ref.watch(activityProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.progress)),
      body: activityState.logs.when(
        data: (rawLogs) {
          final waterList = activityState.water.maybeWhen(
            data: (d) => d,
            orElse: () => <WaterEntryDto>[],
          );

          if (rawLogs.isEmpty && waterList.isEmpty) {
            return _buildEmptyState(t);
          }

          // Preparation: Group data by date
          final logsMap = <String, ActivityLogDto>{};
          for (var log in rawLogs) {
            logsMap[ActivityLogDto.formatDate(log.date)] = log;
          }

          final waterMap = <String, int>{};
          for (var w in waterList) {
            final dateKey = w.timestamp.split('T')[0];
            waterMap[dateKey] = (waterMap[dateKey] ?? 0) + w.ml;
          }

          // Generate 7-day range
          final List<ActivityLogDto> filledLogs = [];
          final Map<String, int> filledWater = {};
          
          for (int i = 6; i >= 0; i--) {
            final date = DateTime.now().subtract(Duration(days: i));
            final dateKey = ActivityLogDto.formatDate(date);
            
            final log = logsMap[dateKey] ?? ActivityLogDto(
              steps: 0,
              calories: 0,
              sleepHours: 0.0,
              date: date,
            );
            filledLogs.add(log);
            filledWater[dateKey] = waterMap[dateKey] ?? 0;
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(activityProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(t.last7Days, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildChart(t.stepsChart, Colors.blue, filledLogs.map((e) => e.steps.toDouble()).toList(), filledLogs),
                const SizedBox(height: 24),
                _buildChart(t.caloriesChart, Colors.orange, filledLogs.map((e) => e.calories.toDouble()).toList(), filledLogs),
                const SizedBox(height: 24),
                _buildChart(t.sleepChart, Colors.purple, filledLogs.map((e) => e.sleepHours).toList(), filledLogs),
                const SizedBox(height: 24),
                _buildChart(
                  'Water (ml)', 
                  Colors.cyan, 
                  filledLogs.map((e) => (filledWater[ActivityLogDto.formatDate(e.date)] ?? 0).toDouble()).toList(), 
                  filledLogs
                ),
                const SizedBox(height: 32),
                Text('Recent History', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ..._buildHistoryList(rawLogs, waterList),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Error loading data: $e')),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.show_chart, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(t.noData, style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text('Add activity or water in Activity tab', style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  List<Widget> _buildHistoryList(List<ActivityLogDto> logs, List<WaterEntryDto> water) {
    final items = <_HistoryItem>[];
    
    for (var l in logs) {
      if (l.steps > 0 || l.calories > 0) {
        items.add(_HistoryItem(
          date: l.date,
          title: 'Workout Summary',
          subtitle: '${l.steps} steps • ${l.calories} kcal',
          icon: Icons.directions_run,
          color: Colors.blue,
        ));
      }
    }

    for (var w in water) {
      items.add(_HistoryItem(
        date: DateTime.parse(w.timestamp),
        title: 'Water Intake',
        subtitle: '${w.ml} ml',
        icon: Icons.local_drink,
        color: Colors.cyan,
      ));
    }

    items.sort((a, b) => b.date.compareTo(a.date));

    return items.take(10).map((item) => Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: item.color.withOpacity(0.1),
          child: Icon(item.icon, color: item.color, size: 20),
        ),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(item.subtitle),
        trailing: Text(
          '${item.date.day}/${item.date.month}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    )).toList();
  }

  Widget _buildChart(String title, Color color, List<double> values, List<ActivityLogDto> logs) {
    if (values.isEmpty) return const SizedBox.shrink();
    final spots = values.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
    
    // Check if all values are zero to adjust Y axis
    final allZero = values.every((v) => v == 0);

=======
    return Scaffold(
      appBar: AppBar(title: Text(t.progress)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.show_chart, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(t.noData, style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                      const SizedBox(height: 8),
                      Text('Add activity data in Activity tab', style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadLogs,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(t.last7Days, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),
                      _buildChart(t.stepsChart, Colors.blue, _logs.map((e) => e.steps.toDouble()).toList(), _logs),
                      const SizedBox(height: 24),
                      _buildChart(t.caloriesChart, Colors.orange, _logs.map((e) => e.calories.toDouble()).toList(), _logs),
                      const SizedBox(height: 24),
                      _buildChart(t.sleepChart, Colors.purple, _logs.map((e) => e.sleepHours).toList(), _logs),
                    ],
                  ),
                ),
    );
  }

  Widget _buildChart(String title, Color color, List<double> values, List<ActivityLogDto> logs) {
    if (values.isEmpty) return const SizedBox.shrink();
    final spots = values.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
<<<<<<< HEAD
        Container(
          height: 180,
          padding: const EdgeInsets.only(right: 16, top: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
=======
        SizedBox(
          height: 180,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: color,
                  barWidth: 3,
<<<<<<< HEAD
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withOpacity(0.1),
                  ),
                  spots: spots,
                ),
              ],
              minY: 0,
              maxY: allZero ? 10 : null,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.1),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true, 
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  )
                ),
=======
                  spots: spots,
                  dotData: const FlDotData(show: true),
                ),
              ],
              gridData: FlGridData(show: true, drawVerticalLine: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= logs.length) return const Text('');
                      final date = logs[index].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${date.day}/${date.month}',
<<<<<<< HEAD
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
=======
                          style: const TextStyle(fontSize: 10),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
<<<<<<< HEAD
              borderData: FlBorderData(show: false),
=======
              borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
            ),
          ),
        ),
      ],
    );
  }
}
<<<<<<< HEAD

class _HistoryItem {
  final DateTime date;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  _HistoryItem({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
