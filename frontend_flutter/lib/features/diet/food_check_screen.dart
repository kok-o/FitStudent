import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_flutter/generated/app_localizations.dart';
import '../../l10n/app_localizations_extension.dart';
import '../../core/theme/app_theme.dart';
import 'food_check_service.dart';
import '../activity/activity_service.dart';
import '../activity/models.dart';

class FoodCheckScreen extends ConsumerStatefulWidget {
  const FoodCheckScreen({super.key});

  @override
  ConsumerState<FoodCheckScreen> createState() => _FoodCheckScreenState();
}

class _FoodCheckScreenState extends ConsumerState<FoodCheckScreen> {
  final TextEditingController _controller = TextEditingController();
  FoodCheckResult? _result;
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkFood() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      final service = ref.read(foodCheckServiceProvider);
      final res = await service.checkFood(_controller.text);
      setState(() {
        _result = res;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.foodCheck),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Safety First',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Check if a product matches your medical profile and allergies.',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: l10n.foodName,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: _checkFood,
                          icon: const Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _checkFood(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_result != null)
                _buildResultCard(context, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, AppLocalizations l10n) {
    final color = _getStatusColor(_result!.status);
    final icon = _getStatusIcon(_result!.status);
    final statusText = _getStatusText(_result!.status, l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusText,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Scan Result',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.info_outline, color: color.withOpacity(0.7), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l10n.reason,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _result!.reason,
                style: TextStyle(color: Colors.grey[700], height: 1.5),
              ),
              if (_result!.status == 'ALLOWED') ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        final activityService = ActivityService();
                        await activityService.addNutrition(NutritionEntryDto(
                          timestamp: DateTime.now().toIso8601String(),
                          food: _controller.text,
                          calories: 0, // Unknown but safe
                        ));
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Food logged to today\'s activity!')),
                          );
                        }
                      } catch (e) {
                         if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to log food: $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.add_task),
                    label: const Text('Log as Consumed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_result!.replacements.isNotEmpty) ...[
          const SizedBox(height: 32),
          Text(
            l10n.replacements,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
          ),
          const SizedBox(height: 16),
          ..._result!.replacements.map((r) => _buildReplacementCard(context, r, l10n)),
        ],
      ],
    );
  }

  Widget _buildReplacementCard(BuildContext context, FoodReplacement replacement, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.swap_horiz, color: Colors.blue),
        ),
        title: Text(
          '${replacement.original} ➔ ${replacement.replacement}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(replacement.reason),
        ),
        trailing: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.foodAdded),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          icon: Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ALLOWED':
        return Colors.green;
      case 'LIMITED':
        return Colors.orange;
      case 'FORBIDDEN':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'ALLOWED':
        return Icons.check_circle;
      case 'LIMITED':
        return Icons.warning_amber_rounded;
      case 'FORBIDDEN':
        return Icons.dangerous_outlined;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String status, AppLocalizations l10n) {
    switch (status) {
      case 'ALLOWED':
        return l10n.allowed;
      case 'LIMITED':
        return l10n.limited;
      case 'FORBIDDEN':
        return l10n.forbidden;
      default:
        return status;
    }
  }
}
