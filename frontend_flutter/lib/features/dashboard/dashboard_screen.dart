import 'package:flutter/material.dart';
import '../activity/activity_service.dart';
import '../activity/models.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _service = ActivityService();
  late Future<ActivityLogDto> _todayFuture;

  @override
  void initState() {
    super.initState();
    _todayFuture = _service.getToday();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Привет!', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          FutureBuilder<ActivityLogDto>(
            future: _todayFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ));
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Ошибка загрузки: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                );
              }
              final data = snapshot.data!;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(title: 'Шаги сегодня', value: '${data.steps}'),
                  _StatCard(title: 'Калории', value: '${data.calories}'),
                  _StatCard(title: 'Сон (ч)', value: data.sleepHours.toStringAsFixed(1)),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: ListTile(
              title: const Text('Ближайшая тренировка'),
              subtitle: const Text('Stretch · 15 мин · 50 ккал'),
              trailing: FilledButton(onPressed: () {}, child: const Text('Начать')),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Мотивация', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text('Маленькие шаги каждый день приводят к большим результатам.')
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      ),
    );
  }
}
