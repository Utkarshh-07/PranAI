// lib/models/ai_character_model.dart

class AICharacter {
  final String id;
  String name;
  String gender; // 'male', 'female', 'neutral'
  String voiceType; // 'calm', 'energetic', 'wise', 'gentle'
  String baseColor;
  String eyeColor;
  String expression; // 'neutral', 'happy', 'concerned', 'listening'
  List<String> customizationOptions;
  DateTime createdAt;
  int conversationsCount;
  int totalMinutes;

  AICharacter({
    required this.id,
    required this.name,
    required this.gender,
    required this.voiceType,
    required this.baseColor,
    required this.eyeColor,
    this.expression = 'neutral',
    this.customizationOptions = const [],
    DateTime? createdAt,
    this.conversationsCount = 0,
    this.totalMinutes = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'gender': gender,
    'voiceType': voiceType,
    'baseColor': baseColor,
    'eyeColor': eyeColor,
    'expression': expression,
    'customizationOptions': customizationOptions,
    'createdAt': createdAt.toIso8601String(),
    'conversationsCount': conversationsCount,
    'totalMinutes': totalMinutes,
  };

  factory AICharacter.fromJson(Map<String, dynamic> json) => AICharacter(
    id: json['id'],
    name: json['name'],
    gender: json['gender'],
    voiceType: json['voiceType'],
    baseColor: json['baseColor'],
    eyeColor: json['eyeColor'],
    expression: json['expression'] ?? 'neutral',
    customizationOptions: List<String>.from(json['customizationOptions'] ?? []),
    createdAt: DateTime.parse(json['createdAt']),
    conversationsCount: json['conversationsCount'] ?? 0,
    totalMinutes: json['totalMinutes'] ?? 0,
  );

  AICharacter copyWith({
    String? name,
    String? gender,
    String? voiceType,
    String? baseColor,
    String? eyeColor,
    String? expression,
    List<String>? customizationOptions,
    int? conversationsCount,
    int? totalMinutes,
  }) {
    return AICharacter(
      id: id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      voiceType: voiceType ?? this.voiceType,
      baseColor: baseColor ?? this.baseColor,
      eyeColor: eyeColor ?? this.eyeColor,
      expression: expression ?? this.expression,
      customizationOptions: customizationOptions ?? this.customizationOptions,
      createdAt: createdAt,
      conversationsCount: conversationsCount ?? this.conversationsCount,
      totalMinutes: totalMinutes ?? this.totalMinutes,
    );
  }
}