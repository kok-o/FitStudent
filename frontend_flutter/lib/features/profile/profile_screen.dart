import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animations/animations.dart';
import 'package:frontend_flutter/generated/app_localizations.dart';
import '../../l10n/app_localizations_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/locale_provider.dart';
import '../../core/api_client.dart';
import 'package:go_router/go_router.dart';
import 'profile_service.dart';
import 'profile_models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _service = ProfileService();
  Future<UserProfileDto>? _future;
  Future<ProfileCalculationsDto>? _calcFuture;
  Future<UserPreferenceDto>? _prefFuture;

  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  String? _selectedGender;
  String? _selectedGoal;
  String? _selectedActivity;

  final _typesCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _equipCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = _service.getProfile();
    _calcFuture = _service.getCalculations();
    _prefFuture = _service.getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
            tooltip: t.settings,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _future = _service.getProfile();
            _calcFuture = _service.getCalculations();
            _prefFuture = _service.getPreferences();
          });
          await Future.wait([
            _future!,
            _calcFuture!,
            _prefFuture!,
          ]);
        },
        child: FutureBuilder<UserProfileDto>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return ListView(children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('${t.error}: ${snap.error}'),
                )
              ]);
            }
            final u = snap.data!;
            // Заполняем контроллеры данными
            if (_nameCtrl.text.isEmpty) {
              _nameCtrl.text = u.name;
              _ageCtrl.text = u.age?.toString() ?? '';
              _heightCtrl.text = u.height?.toString() ?? '';
              _weightCtrl.text = u.weight?.toString() ?? '';
              _selectedGender = u.gender;
              _selectedGoal = u.goal;
              _selectedActivity = u.activityLevel;
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Column(
                    children: [
                      Hero(
                        tag: 'profile_photo',
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: (u.photoUrl != null && u.photoUrl!.isNotEmpty)
                              ? Container(
                                  key: ValueKey(u.photoUrl),
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: u.photoUrl!.startsWith('http') 
                                        ? u.photoUrl! 
                                        : '${ApiClient.baseUrl}${u.photoUrl}',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.error_outline, color: Colors.white),
                                            const SizedBox(height: 4),
                                            Text('Error: ${error.toString().substring(0, 20)}...', 
                                              style: const TextStyle(fontSize: 8, color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  key: const ValueKey('no-photo'),
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.primary,
                                        Theme.of(context).colorScheme.primaryContainer
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Медицинские функции
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('/profile/medical'),
                        icon: const Icon(Icons.medical_services),
                        label: Text(t.medicalProfile),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('/food-check'),
                        icon: const Icon(Icons.search),
                        label: Text(t.foodCheck),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Форма редактирования основных данных
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.profileDetails, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameCtrl,
                          decoration: InputDecoration(labelText: t.name),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _ageCtrl,
                          decoration: InputDecoration(labelText: t.age),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _heightCtrl,
                          decoration: InputDecoration(labelText: '${t.height} (cm)'),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _weightCtrl,
                          decoration: InputDecoration(labelText: '${t.weight} (kg)'),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedGender?.toLowerCase(),
                          decoration: InputDecoration(labelText: t.gender),
                          items: const [
                            DropdownMenuItem(value: 'male', child: Text('Male')),
                            DropdownMenuItem(value: 'female', child: Text('Female')),
                          ],
                          onChanged: (v) => setState(() => _selectedGender = v),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedGoal,
                          decoration: InputDecoration(labelText: t.goal),
                          items: const [
                            DropdownMenuItem(value: 'LOSE', child: Text('Lose Weight')),
                            DropdownMenuItem(value: 'MAINTAIN', child: Text('Maintain')),
                            DropdownMenuItem(value: 'GAIN', child: Text('Gain Weight')),
                          ],
                          onChanged: (v) => setState(() => _selectedGoal = v),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedActivity,
                          decoration: InputDecoration(labelText: t.activity),
                          items: const [
                            DropdownMenuItem(value: 'SEDENTARY', child: Text('Sedentary')),
                            DropdownMenuItem(value: 'MODERATE', child: Text('Moderate')),
                            DropdownMenuItem(value: 'ACTIVE', child: Text('Active')),
                          ],
                          onChanged: (v) => setState(() => _selectedActivity = v),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                final dto = UserProfileDto(
                                  id: u.id,
                                  email: u.email,
                                  name: _nameCtrl.text.trim(),
                                  age: int.tryParse(_ageCtrl.text),
                                  height: double.tryParse(_heightCtrl.text),
                                  weight: double.tryParse(_weightCtrl.text),
                                  gender: _selectedGender,
                                  goal: _selectedGoal,
                                  activityLevel: _selectedActivity,
                                  role: u.role,
                                  createdAt: u.createdAt,
                                  photoUrl: u.photoUrl,
                                );
                                final updated = await _service.updateProfile(dto);
                                if (!mounted) return;
                                setState(() {
                                  _future = Future.value(updated);
                                  _calcFuture = _service.getCalculations();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Profile updated successfully')),
                                );
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${t.error}: $e')),
                                  );
                                }
                              }
                            },
                            child: Text(t.save),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<ProfileCalculationsDto>(
                  future: _calcFuture,
                  builder: (context, calcSnap) {
                    if (calcSnap.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (calcSnap.hasError) {
                      return Card(child: ListTile(title: Text(t.calculations), subtitle: Text(t.error)));
                    }
                    final c = calcSnap.data!;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Card(
                        key: ValueKey('${c.bmi}_${c.tdee}_${c.targetCalories}_${c.proteinG}_${c.fatG}_${c.carbsG}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(title: Text(t.calculations)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Wrap(spacing: 16, runSpacing: 8, children: [
                              _chip(t.bmi, c.bmi?.toStringAsFixed(1) ?? '-'),
                              _chip(t.bmr, c.bmr?.toStringAsFixed(0) ?? '-'),
                              _chip(t.tdee, c.tdee?.toStringAsFixed(0) ?? '-'),
                              _chip(t.targetKcal, c.targetCalories?.toStringAsFixed(0) ?? '-'),
                              _chip(t.proteinG, c.proteinG?.toStringAsFixed(0) ?? '-'),
                              _chip(t.fatG, c.fatG?.toStringAsFixed(0) ?? '-'),
                              _chip(t.carbsG, c.carbsG?.toStringAsFixed(0) ?? '-'),
                            ]),
                          ),
                        ],
                      ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                FutureBuilder<UserPreferenceDto>(
                  future: _prefFuture,
                  builder: (context, prefSnap) {
                    if (prefSnap.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (prefSnap.hasData) {
                      final p = prefSnap.data!;
                      _typesCtrl.text = p.preferredTrainingTypes ?? '';
                      _timeCtrl.text = p.preferredTimeOfDay ?? '';
                      _equipCtrl.text = p.equipment ?? '';
                    }
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.preferences, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _typesCtrl,
                              decoration: InputDecoration(labelText: t.trainingTypes),
                            ),
                            TextField(
                              controller: _timeCtrl,
                              decoration: InputDecoration(labelText: t.timeOfDay),
                            ),
                            TextField(
                              controller: _equipCtrl,
                              decoration: InputDecoration(labelText: t.equipment),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final dto = UserPreferenceDto(
                                    preferredTrainingTypes: _typesCtrl.text.trim().isEmpty ? null : _typesCtrl.text.trim(),
                                    preferredTimeOfDay: _timeCtrl.text.trim().isEmpty ? null : _timeCtrl.text.trim(),
                                    equipment: _equipCtrl.text.trim().isEmpty ? null : _equipCtrl.text.trim(),
                                  );
                                  try {
                                    await _service.updatePreferences(dto);
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(t.preferencesSaved)),
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${t.saveFailed}: $e')),
                                      );
                                    }
                                  }
                                },
                                child: Text(t.save),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _chip(String label, String value) {
    return Chip(label: Text('$label: $value'));
  }
}
