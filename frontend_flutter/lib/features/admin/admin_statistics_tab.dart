import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class AdminStatisticsTab extends StatefulWidget {
  const AdminStatisticsTab({super.key});

  @override
  State<AdminStatisticsTab> createState() => _AdminStatisticsTabState();
}

class _AdminStatisticsTabState extends State<AdminStatisticsTab> {
  bool _isLoading = true;
  Map<String, dynamic>? _userStats;
  List<dynamic>? _workoutStats;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);
    try {
<<<<<<< HEAD
      final userStats = await ApiService.get('/api/admin/statistics/users');
      final workoutStats = await ApiService.get('/api/admin/statistics/workouts');
=======
      final userStats = await ApiService.get('/admin/statistics/users');
      final workoutStats = await ApiService.get('/admin/statistics/workouts');
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      
      setState(() {
        _userStats = userStats;
        _workoutStats = workoutStats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading statistics: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadStatistics,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'User Statistics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildUserStatsCards(),
          const SizedBox(height: 32),
          const Text(
            'Popular Workouts',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildWorkoutStats(),
        ],
      ),
    );
  }

  Widget _buildUserStatsCards() {
    if (_userStats == null) return const SizedBox();

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildStatCard(
          'Total Users',
          _userStats!['totalUsers']?.toString() ?? '0',
          Icons.people,
          Colors.blue,
        ),
        _buildStatCard(
          'Active Today',
          _userStats!['activeUsersToday']?.toString() ?? '0',
          Icons.trending_up,
          Colors.green,
        ),
        _buildStatCard(
          'Active This Week',
          _userStats!['activeUsersThisWeek']?.toString() ?? '0',
          Icons.calendar_today,
          Colors.orange,
        ),
        _buildStatCard(
          'New This Month',
          _userStats!['newUsersThisMonth']?.toString() ?? '0',
          Icons.person_add,
          Colors.purple,
        ),
<<<<<<< HEAD
=======
        _buildStatCard(
          'Avg Workouts/User',
          _userStats!['averageWorkoutsPerUser']?.toStringAsFixed(1) ?? '0',
          Icons.fitness_center,
          Colors.red,
        ),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutStats() {
    if (_workoutStats == null || _workoutStats!.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No workout statistics available'),
        ),
      );
    }

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _workoutStats!.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final workout = _workoutStats![index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _getLevelColor(workout['level']),
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(workout['title'] ?? 'Unknown'),
            subtitle: Text('Level: ${workout['level']}'),
            trailing: Chip(
              label: Text('${workout['completionCount']} completions'),
              backgroundColor: Colors.green[100],
            ),
          );
        },
      ),
    );
  }

  Color _getLevelColor(String? level) {
    switch (level?.toUpperCase()) {
      case 'BEGINNER':
        return Colors.green;
      case 'MEDIUM':
        return Colors.orange;
      case 'ADVANCED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
