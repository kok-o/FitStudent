class ActivityLogDto {
  final int? id;
  final int steps;
  final int calories;
  final double sleepHours;
  final DateTime date;
  final String? notes;

  ActivityLogDto({
    this.id,
    required this.steps,
    required this.calories,
    required this.sleepHours,
    required this.date,
    this.notes,
  });

  factory ActivityLogDto.fromJson(Map<String, dynamic> json) {
    return ActivityLogDto(
<<<<<<< HEAD
      id: (json['id'] as num?)?.toInt(),
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      sleepHours: (json['sleepHours'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now(),
=======
      id: json['id'] as int?,
      steps: (json['steps'] as num).toInt(),
      calories: (json['calories'] as num).toInt(),
      sleepHours: (json['sleepHours'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'steps': steps,
      'calories': calories,
      'sleepHours': sleepHours,
      'date': formatDate(date),
      if (notes != null) 'notes': notes,
    };
  }

  static String formatDate(DateTime d) {
    // Format yyyy-MM-dd to match Spring LocalDate
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }
}

class WaterEntryDto {
  final int? id;
<<<<<<< HEAD
  final String timestamp; // yyyy-MM-ddTHH:mm:ss
  final int ml;

  WaterEntryDto({this.id, required this.timestamp, required this.ml});

  factory WaterEntryDto.fromJson(Map<String, dynamic> json) => WaterEntryDto(
        id: (json['id'] as num?)?.toInt(),
        timestamp: json['timestamp'] as String? ?? DateTime.now().toIso8601String(),
        ml: (json['ml'] as num?)?.toInt() ?? 0,
=======
  final String date; // yyyy-MM-dd
  final int milliliters;

  WaterEntryDto({this.id, required this.date, required this.milliliters});

  factory WaterEntryDto.fromJson(Map<String, dynamic> json) => WaterEntryDto(
        id: (json['id'] as num?)?.toInt(),
        date: json['date'] as String,
        milliliters: (json['milliliters'] as num).toInt(),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
<<<<<<< HEAD
        'timestamp': timestamp,
        'ml': ml,
=======
        'date': date,
        'milliliters': milliliters,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      };
}

class NutritionEntryDto {
  final int? id;
<<<<<<< HEAD
  final String timestamp; // yyyy-MM-ddTHH:mm:ss
=======
  final String date; // yyyy-MM-dd
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
  final String food;
  final int calories;
  final double? proteinG;
  final double? fatG;
  final double? carbsG;

  NutritionEntryDto({
    this.id,
<<<<<<< HEAD
    required this.timestamp,
=======
    required this.date,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
    required this.food,
    required this.calories,
    this.proteinG,
    this.fatG,
    this.carbsG,
  });

  factory NutritionEntryDto.fromJson(Map<String, dynamic> json) => NutritionEntryDto(
        id: (json['id'] as num?)?.toInt(),
<<<<<<< HEAD
        timestamp: json['timestamp'] as String? ?? DateTime.now().toIso8601String(),
        food: json['food'] as String? ?? '',
        calories: (json['calories'] as num?)?.toInt() ?? 0,
=======
        date: json['date'] as String,
        food: json['food'] as String,
        calories: (json['calories'] as num).toInt(),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
        proteinG: (json['proteinG'] as num?)?.toDouble(),
        fatG: (json['fatG'] as num?)?.toDouble(),
        carbsG: (json['carbsG'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
<<<<<<< HEAD
        'timestamp': timestamp,
=======
        'date': date,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
        'food': food,
        'calories': calories,
        if (proteinG != null) 'proteinG': proteinG,
        if (fatG != null) 'fatG': fatG,
        if (carbsG != null) 'carbsG': carbsG,
      };
}
