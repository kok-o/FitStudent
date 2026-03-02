class UserProfileDto {
  UserProfileDto({
    required this.id,
    required this.email,
    required this.name,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.goal,
    this.activityLevel,
    this.role,
    this.createdAt,
    this.photoUrl,
  });

  final int id;
  final String email;
  final String name;
  final int? age;
  final String? gender;
  final double? height;
  final double? weight;
  final String? goal;
  final String? activityLevel;
  final String? role;
  final String? createdAt;
  final String? photoUrl;

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      name: json['name'] as String,
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      goal: json['goal']?.toString(),
      activityLevel: json['activityLevel']?.toString(),
      role: json['role']?.toString(),
      createdAt: json['createdAt']?.toString(),
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        if (age != null) 'age': age,
        if (gender != null) 'gender': gender,
        if (height != null) 'height': height,
        if (weight != null) 'weight': weight,
        if (goal != null) 'goal': goal,
        if (activityLevel != null) 'activityLevel': activityLevel,
        if (role != null) 'role': role,
        if (createdAt != null) 'createdAt': createdAt,
        if (photoUrl != null) 'photoUrl': photoUrl,
      };
}

class ProfileCalculationsDto {
  ProfileCalculationsDto({
    this.bmi,
    this.bmr,
    this.tdee,
    this.targetCalories,
    this.proteinG,
    this.fatG,
    this.carbsG,
  });

  final double? bmi;
  final double? bmr;
  final double? tdee;
  final double? targetCalories;
  final double? proteinG;
  final double? fatG;
  final double? carbsG;

  factory ProfileCalculationsDto.fromJson(Map<String, dynamic> json) {
    return ProfileCalculationsDto(
      bmi: (json['bmi'] as num?)?.toDouble(),
      bmr: (json['bmr'] as num?)?.toDouble(),
      tdee: (json['tdee'] as num?)?.toDouble(),
      targetCalories: (json['targetCalories'] as num?)?.toDouble(),
      proteinG: (json['proteinG'] as num?)?.toDouble(),
      fatG: (json['fatG'] as num?)?.toDouble(),
      carbsG: (json['carbsG'] as num?)?.toDouble(),
    );
  }
}

class UserPreferenceDto {
  UserPreferenceDto({
    this.preferredTrainingTypes,
    this.preferredTimeOfDay,
    this.equipment,
  });

  final String? preferredTrainingTypes; // comma-separated
  final String? preferredTimeOfDay; // morning | afternoon | evening
  final String? equipment; // comma-separated

  factory UserPreferenceDto.fromJson(Map<String, dynamic> json) {
    return UserPreferenceDto(
      preferredTrainingTypes: json['preferredTrainingTypes'] as String?,
      preferredTimeOfDay: json['preferredTimeOfDay'] as String?,
      equipment: json['equipment'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (preferredTrainingTypes != null)
          'preferredTrainingTypes': preferredTrainingTypes,
        if (preferredTimeOfDay != null)
          'preferredTimeOfDay': preferredTimeOfDay,
        if (equipment != null) 'equipment': equipment,
      };
}
