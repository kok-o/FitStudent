import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_flutter/generated/app_localizations.dart';
import '../../l10n/app_localizations_extension.dart';
import 'medical_profile_model.dart';
import 'medical_profile_provider.dart';

class ProfileMedicalScreen extends ConsumerStatefulWidget {
  const ProfileMedicalScreen({super.key});

  @override
  ConsumerState<ProfileMedicalScreen> createState() => _ProfileMedicalScreenState();
}

class _ProfileMedicalScreenState extends ConsumerState<ProfileMedicalScreen> {
  late Set<String> _diagnoses;
  late Set<String> _allergies;
  late TextEditingController _contraindicationsController;
  late double _activityLevel;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _contraindicationsController = TextEditingController();
  }

  @override
  void dispose() {
    _contraindicationsController.dispose();
    super.dispose();
  }

  void _initialize(MedicalProfileModel profile) {
    if (!_isInitialized) {
      _diagnoses = Set.from(profile.diagnoses);
      _allergies = Set.from(profile.allergies);
      _contraindicationsController.text = profile.contraindications;
      _activityLevel = profile.activityLevel.toDouble();
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(medicalProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medicalProfile),
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile != null) _initialize(profile);
          return _buildContent(l10n);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveProfile,
        label: Text(l10n.save),
        icon: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            title: l10n.diagnoses,
            icon: Icons.list_alt,
            child: _buildDiagnosisCheckboxes(l10n),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: l10n.allergies,
            icon: Icons.warning_amber_rounded,
            child: _buildAllergyCheckboxes(l10n),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: l10n.activityLevel,
            icon: Icons.speed,
            child: Column(
              children: [
                Slider(
                  value: _activityLevel,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _activityLevel.round().toString(),
                  onChanged: (val) => setState(() => _activityLevel = val),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sedentary', style: Theme.of(context).textTheme.bodySmall),
                      Text('Very Active', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: l10n.contraindications,
            icon: Icons.notes,
            child: TextField(
              controller: _contraindicationsController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: l10n.contraindications,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon, required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }


  Widget _buildDiagnosisCheckboxes(AppLocalizations l10n) {
    final diagnoses = {
      'diabetes': {'label': l10n.diabetes, 'icon': Icons.bloodtype},
      'hypertension': {'label': l10n.hypertension, 'icon': Icons.monitor_heart},
      'gastritis': {'label': l10n.gastritis, 'icon': Icons.restaurant_menu},
      'gout': {'label': l10n.gout, 'icon': Icons.healing},
      'ckd': {'label': l10n.ckd, 'icon': Icons.water_drop},
      'celiac': {'label': l10n.celiac, 'icon': Icons.no_food},
      'obesity': {'label': l10n.obesity, 'icon': Icons.accessibility_new},
      'anemia': {'label': l10n.anemia, 'icon': Icons.opacity},
    };

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: diagnoses.entries.map((e) {
        final isSelected = _diagnoses.contains(e.key);
        return FilterChip(
          avatar: Icon(e.value['icon'] as IconData, size: 16, color: isSelected ? Colors.white : Colors.blue),
          label: Text(e.value['label'] as String),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _diagnoses.add(e.key);
              } else {
                _diagnoses.remove(e.key);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildAllergyCheckboxes(AppLocalizations l10n) {
    final allergies = {
      'gluten': {'label': l10n.gluten, 'icon': Icons.bakery_dining},
      'lactose': {'label': l10n.lactose, 'icon': Icons.egg_alt},
      'nuts': {'label': l10n.nuts, 'icon': Icons.eco},
      'seafood': {'label': l10n.seafood, 'icon': Icons.set_meal},
      'eggs': {'label': l10n.eggs, 'icon': Icons.egg},
      'soy': {'label': l10n.soy, 'icon': Icons.grass},
    };

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: allergies.entries.map((e) {
        final isSelected = _allergies.contains(e.key);
        return FilterChip(
          avatar: Icon(e.value['icon'] as IconData, size: 16, color: isSelected ? Colors.white : Colors.orange),
          label: Text(e.value['label'] as String),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _allergies.add(e.key);
              } else {
                _allergies.remove(e.key);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Future<void> _saveProfile() async {
    final profile = MedicalProfileModel(
      diagnoses: _diagnoses,
      allergies: _allergies,
      contraindications: _contraindicationsController.text,
      activityLevel: _activityLevel.round(),
    );

    final success = await ref.read(medicalProfileProvider.notifier).saveProfile(profile);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? AppLocalizations.of(context)!.saved : AppLocalizations.of(context)!.saveFailed)),
      );
    }
  }
}
