class WorkoutDto {
  WorkoutDto({
    required this.id,
    required this.title,
    this.description,
    required this.level,
    this.duration,
    this.calories,
    this.exercises = const [],
  });

  final int id;
  final String title;
  final String? description;
  final String level; // backend enum serialized as string
  final int? duration;
  final int? calories;
  final List<String> exercises;

  factory WorkoutDto.fromJson(Map<String, dynamic> json) {
    final lvl = json['level'];
    final ex = json['exercises'];
    return WorkoutDto(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? json['name']) as String, // support older 'name'
      description: json['description'] as String?,
      level: (lvl is String) ? lvl : (lvl?.toString() ?? ''),
      duration: (json['duration'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toInt(),
      exercises: ex is List ? ex.map((e) => e.toString()).toList().cast<String>() : const <String>[],
    );
  }
}

class UserWorkoutDto {
  UserWorkoutDto({
    required this.id,
    required this.workoutId,
    required this.completedAt,
    this.actualDuration,
    this.actualCalories,
  });

  final int id;
  final int workoutId;
  final DateTime completedAt;
  final int? actualDuration;
  final int? actualCalories;

  factory UserWorkoutDto.fromJson(Map<String, dynamic> json) {
    return UserWorkoutDto(
      id: (json['id'] as num).toInt(),
      workoutId: (json['workoutId'] as num).toInt(),
      completedAt: DateTime.parse(json['completedAt'] as String),
      actualDuration: (json['actualDuration'] as num?)?.toInt(),
      actualCalories: (json['actualCalories'] as num?)?.toInt(),
    );
  }
}


