import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:frontend_flutter/generated/app_localizations.dart';
=======
import 'package:frontend_flutter/l10n/app_localizations.dart';
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
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
<<<<<<< HEAD
=======
          const SizedBox(height: 16),
          // Sample meal plan
          Row(
            children: [
              Expanded(
                child: Text(t.mealPlan, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              const Chip(
                label: Text('Example', style: TextStyle(fontSize: 12)),
                backgroundColor: Colors.amber,
                padding: EdgeInsets.symmetric(horizontal: 8),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'This is a sample meal plan. Create your own plan or consult with a nutritionist.',
            style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 8),
          _MealCard(title: t.breakfast, items: ['Oatmeal (250 kcal)', 'Greek Yogurt (150 kcal)']),
          _MealCard(title: t.lunch, items: ['Grilled Chicken Salad (400 kcal)', 'Whole Grain Bread (100 kcal)']),
          _MealCard(title: t.dinner, items: ['Salmon with Vegetables (500 kcal)', 'Brown Rice (200 kcal)']),
          _MealCard(title: t.snack, items: ['Apple (80 kcal)', 'Almonds (160 kcal)']),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
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

<<<<<<< HEAD
=======
class _MealCard extends StatelessWidget {
  final String title;
  final List<String> items;
  const _MealCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) => Padding(padding: const EdgeInsets.only(top: 4), child: Text('• $item'))).toList(),
        ),
      ),
    );
  }
}
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
