class LoginRequest {
  LoginRequest({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class RegisterRequest {
  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.goal = 'MAINTAIN',
    this.activityLevel = 'MODERATE',
  });

  final String email;
  final String password;
  final String name;
  final int? age;
  final String? gender;
  final double? height;
  final double? weight;
  final String goal; // BACKEND ENUM: User.Goal
  final String activityLevel; // BACKEND ENUM: User.ActivityLevel

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'name': name,
        if (age != null) 'age': age,
        if (gender != null) 'gender': gender,
        if (height != null) 'height': height,
        if (weight != null) 'weight': weight,
        'goal': goal,
        'activityLevel': activityLevel,
      };
}

class AuthResponse {
  AuthResponse({required this.token});

  final String token;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final t = json['token'];
    return AuthResponse(token: (t is String) ? t : (t?.toString() ?? ''));
  }
}


