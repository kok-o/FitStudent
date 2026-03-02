class MedicalProfileModel {
  final Set<String> diagnoses;
  final Set<String> allergies;
  final String contraindications;
  final int activityLevel;

  MedicalProfileModel({
    required this.diagnoses,
    required this.allergies,
    required this.contraindications,
    required this.activityLevel,
  });

  factory MedicalProfileModel.fromJson(Map<String, dynamic> json) {
    return MedicalProfileModel(
      diagnoses: Set<String>.from(json['diagnoses'] ?? []),
      allergies: Set<String>.from(json['allergies'] ?? []),
      contraindications: json['contraindications'] ?? '',
      activityLevel: (json['activityLevel'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'diagnoses': diagnoses.toList(),
        'allergies': allergies.toList(),
        'contraindications': contraindications,
        'activityLevel': activityLevel,
      };

  MedicalProfileModel copyWith({
    Set<String>? diagnoses,
    Set<String>? allergies,
    String? contraindications,
    int? activityLevel,
  }) {
    return MedicalProfileModel(
      diagnoses: diagnoses ?? this.diagnoses,
      allergies: allergies ?? this.allergies,
      contraindications: contraindications ?? this.contraindications,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }
}
