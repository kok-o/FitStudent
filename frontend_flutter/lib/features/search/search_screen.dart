import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  final List<String> _recentSearches = [
    'Cardio workouts',
    'High protein meals',
    'Yoga for beginners',
  ];

  final List<String> _trendingSearches = [
    '30-day challenge',
    'HIIT training',
    'Meal prep ideas',
    'Weight loss tips',
    'Muscle building',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = true;
    });
    
    // Simulate search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search workouts, meals, exercises...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppTheme.textTertiary),
          ),
          onSubmitted: _performSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
        ],
      ),
      body: _searchQuery.isEmpty ? _buildSearchSuggestions() : _buildSearchResults(),
    );
  }

  Widget _buildSearchSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_recentSearches.isNotEmpty) ...[
          _buildSectionHeader('Recent Searches', onClear: () {
            setState(() {
              _recentSearches.clear();
            });
          }),
          const SizedBox(height: 12),
          ..._recentSearches.map((search) => _buildSearchItem(
                search,
                icon: Icons.history,
                onTap: () => _performSearch(search),
              )),
          const SizedBox(height: 24),
        ],
        _buildSectionHeader('Trending'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _trendingSearches
              .map((search) => _buildTrendingChip(search))
              .toList(),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('Categories'),
        const SizedBox(height: 12),
        _buildCategoryCard('Workouts', Icons.fitness_center, Colors.purple),
        _buildCategoryCard('Nutrition', Icons.restaurant, Colors.green),
        _buildCategoryCard('Exercises', Icons.directions_run, Colors.orange),
        _buildCategoryCard('Recipes', Icons.menu_book, Colors.blue),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onClear}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (onClear != null)
          TextButton(
            onPressed: onClear,
            child: const Text('Clear'),
          ),
      ],
    );
  }

  Widget _buildSearchItem(String text, {required IconData icon, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.textSecondary),
        title: Text(text),
        trailing: const Icon(Icons.north_west, size: 16, color: AppTheme.textTertiary),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTrendingChip(String label) {
    return ActionChip(
      label: Text(label),
      avatar: const Icon(Icons.trending_up, size: 16),
      onPressed: () => _performSearch(label),
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      labelStyle: const TextStyle(
        color: AppTheme.primaryColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.textTertiary),
        onTap: () {},
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Results for "$_searchQuery"',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Morning Cardio Blast',
          'Workout • 30 min • Beginner',
          Icons.fitness_center,
          AppTheme.primaryColor,
        ),
        _buildResultCard(
          'High Protein Breakfast',
          'Meal • 450 cal • 35g protein',
          Icons.restaurant,
          AppTheme.successColor,
        ),
        _buildResultCard(
          'Yoga Flow for Flexibility',
          'Workout • 45 min • Intermediate',
          Icons.self_improvement,
          AppTheme.accentColor,
        ),
      ],
    );
  }

  Widget _buildResultCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: () {},
        ),
        onTap: () {},
      ),
    );
  }
}
