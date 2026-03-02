import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_flutter/generated/app_localizations.dart';
import 'activity_provider.dart';
import 'activity_service.dart';
import 'models.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final _service = ActivityService();

  // Summary form
  final _formKey = GlobalKey<FormState>();
  final _stepsCtrl = TextEditingController(text: '7000');
  final _calCtrl = TextEditingController(text: '350');
  final _sleepCtrl = TextEditingController(text: '7.0');
  DateTime _date = DateTime.now();
  bool _saving = false;
  String? _formError;

  // Water form
  final _waterMlCtrl = TextEditingController(text: '250');
  DateTime _waterDate = DateTime.now();

  // Nutrition form
  final _foodNameCtrl = TextEditingController();
  final _foodCalCtrl = TextEditingController(text: '200');
  final _foodProtCtrl = TextEditingController();
  final _foodFatCtrl = TextEditingController();
  final _foodCarbCtrl = TextEditingController();
  DateTime _foodDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    Future.microtask(() => ref.read(activityProvider.notifier).refresh());
  }

  Future<void> _saveSummary() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _formError = null;
    });

    try {
      final dto = ActivityLogDto(
        steps: int.parse(_stepsCtrl.text),
        calories: int.parse(_calCtrl.text),
        sleepHours: double.parse(_sleepCtrl.text),
        date: _date,
        notes: null,
      );
      await _service.logActivity(dto);
      // Synchronize dashboard and charts
      ref.read(activityProvider.notifier).refresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.saved)));
      }
    } catch (e) {
      if (mounted) setState(() => _formError = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _addWater() async {
    final dto = WaterEntryDto(
      timestamp: _waterDate.toIso8601String(),
      ml: int.tryParse(_waterMlCtrl.text) ?? 250,
    );
    await _service.addWater(dto);
    // Refresh global state which includes the list
    ref.read(activityProvider.notifier).refresh();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.waterAdded)));
      _waterMlCtrl.text = '250'; // Reset
    }
  }

  Future<void> _addFood() async {
    final dto = NutritionEntryDto(
      timestamp: _foodDate.toIso8601String(),
      food: _foodNameCtrl.text.trim(),
      calories: int.tryParse(_foodCalCtrl.text) ?? 0,
      proteinG: _foodProtCtrl.text.trim().isEmpty ? null : double.tryParse(_foodProtCtrl.text),
      fatG: _foodFatCtrl.text.trim().isEmpty ? null : double.tryParse(_foodFatCtrl.text),
      carbsG: _foodCarbCtrl.text.trim().isEmpty ? null : double.tryParse(_foodCarbCtrl.text),
    );
    if (dto.food.isEmpty) return;
    await _service.addNutrition(dto);
    ref.read(activityProvider.notifier).refresh();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.foodAdded)));
      _foodNameCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.activityNav),
        bottom: TabBar(
          controller: _tab,
          tabs: [
            Tab(text: t.summary, icon: const Icon(Icons.directions_run)),
            Tab(text: t.water, icon: const Icon(Icons.local_drink)),
            Tab(text: t.nutrition, icon: const Icon(Icons.restaurant)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: t.exportCsv,
            icon: const Icon(Icons.download),
            onPressed: () async {
              final csv = await _service.exportCsv();
              if (!mounted) return;
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(t.exportCsv),
                  content: SingleChildScrollView(child: Text(csv)),
                  actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
                ),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildSummaryTab(),
          _buildWaterTab(),
          _buildFoodTab(),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    final t = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text(t.date),
            subtitle: Text('${_date.toLocal()}'.split(' ').first),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) setState(() => _date = picked);
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _stepsCtrl,
            decoration: InputDecoration(labelText: t.stepsLabel),
            keyboardType: TextInputType.number,
            validator: (v) => (v == null || int.tryParse(v) == null) ? t.enterSteps : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _calCtrl,
            decoration: InputDecoration(labelText: t.caloriesBurned),
            keyboardType: TextInputType.number,
            validator: (v) => (v == null || int.tryParse(v) == null) ? t.enterCalories : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _sleepCtrl,
            decoration: InputDecoration(labelText: t.sleepHoursLabel),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) => (v == null || double.tryParse(v) == null) ? t.enterSleepHours : null,
          ),
          const SizedBox(height: 16),
          if (_formError != null) ...[
            Text(_formError!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
          ],
          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: _saving ? null : _saveSummary,
              child: _saving
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(t.save),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterTab() {
    final t = AppLocalizations.of(context)!;
    final activityState = ref.watch(activityProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(activityProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            Expanded(
              child: TextField(
                controller: _waterMlCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: t.milliliters),
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text('${_waterDate.toLocal()}'.split(' ').first),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _waterDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => _waterDate = picked);
              },
            ),
            const SizedBox(width: 8),
            FilledButton.icon(onPressed: _addWater, icon: const Icon(Icons.add), label: Text(t.add)),
          ]),
          const SizedBox(height: 12),
          activityState.water.when(
            data: (water) => Column(
              children: water.map((w) => Card(
                child: ListTile(
                  leading: const Icon(Icons.local_drink, color: Colors.blue),
                  title: Text('${w.ml} ml'),
                  subtitle: Text(w.timestamp.split('T')[0]),
                ),
              )).toList(),
            ),
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
            error: (e, __) => Center(child: Text('Error: $e')),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodTab() {
    final t = AppLocalizations.of(context)!;
    final activityState = ref.watch(activityProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(activityProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _foodNameCtrl,
            decoration: InputDecoration(labelText: t.food),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _foodCalCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: t.calories),
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text('${_foodDate.toLocal()}'.split(' ').first),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _foodDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => _foodDate = picked);
              },
            ),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _foodProtCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: t.proteinG),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _foodFatCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: t.fatG),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _foodCarbCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: t.carbsG),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(onPressed: _addFood, icon: const Icon(Icons.add), label: Text(t.add)),
          ),
          const SizedBox(height: 12),
          activityState.nutrition.when(
            data: (foods) => Column(
              children: foods.map((n) => Card(
                child: ListTile(
                  leading: const Icon(Icons.restaurant, color: Colors.orange),
                  title: Text('${n.food} • ${n.calories} kcal'),
                  subtitle: Text('${n.timestamp.split('T')[0]}  P:${n.proteinG ?? '-'} F:${n.fatG ?? '-'} C:${n.carbsG ?? '-'}'),
                ),
              )).toList(),
            ),
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
            error: (e, __) => Center(child: Text('Error: $e')),
          ),
        ],
      ),
    );
  }
}
