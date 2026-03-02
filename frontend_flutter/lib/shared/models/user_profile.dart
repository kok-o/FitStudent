class UserProfile {
  String name;
  int age;
  double weight;
  double height;
  String gender;
  String activityLevel;
  String goal;
  List<String> allergies;
  List<String> chronicDiseases;
  List<String> medications;

  UserProfile({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.activityLevel,
    required this.goal,
    required this.allergies,
    required this.chronicDiseases,
    required this.medications,
  });

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
        name: j['name'] ?? '',
        age: (j['age'] ?? 0) as int,
        weight: (j['weight'] ?? 0).toDouble(),
        height: (j['height'] ?? 0).toDouble(),
        gender: j['gender'] ?? 'other',
        activityLevel: j['activityLevel'] ?? 'low',
        goal: j['goal'] ?? 'maintain',
        allergies: List<String>.from(j['allergies'] ?? []),
        chronicDiseases: List<String>.from(j['chronicDiseases'] ?? []),
        medications: List<String>.from(j['medications'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'weight': weight,
        'height': height,
        'gender': gender,
        'activityLevel': activityLevel,
        'goal': goal,
        'allergies': allergies,
        'chronicDiseases': chronicDiseases,
        'medications': medications,
      };
}
