import 'package:flutter/material.dart';
import 'package:frontend_flutter/generated/app_localizations.dart';
import '../profile/profile_service.dart';
import '../profile/profile_models.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.diet)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Daily macros from profile calculations
          FutureBuilder<ProfileCalculationsDto>(
            future: ProfileService().getCalculations(),
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              if (snap.hasError) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.error_outline, color: Colors.orange),
                    title: Text(t.dailyMacros),
                    subtitle: Text('${t.error}: ${snap.error}'),
                  ),
                );
              }
              if (!snap.hasData || snap.data!.proteinG == null) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.blue),
                    title: Text(t.dailyMacros),
                    subtitle: const Text('Please fill your profile data (height, weight, age) to calculate macros'),
                  ),
                );
              }
              final c = snap.data!;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.dailyMacros, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Text('${t.targetKcal}: ${c.targetCalories?.toStringAsFixed(0) ?? '-'} kcal',
                          style: const TextStyle(fontSize: 16)),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _MacroCard(label: t.protein, value: '${c.proteinG?.toStringAsFixed(0) ?? '-'} g', color: Colors.red),
                          _MacroCard(label: t.fat, value: '${c.fatG?.toStringAsFixed(0) ?? '-'} g', color: Colors.orange),
                          _MacroCard(label: t.carbs, value: '${c.carbsG?.toStringAsFixed(0) ?? '-'} g', color: Colors.blue),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MacroCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.fiber_manual_record, color: color, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

