// lib/models/user_model.dart
class UserModel {
  final String uid;
  final String username;
  final String avatar;
  final int flow;
  final bool isOnline;

  UserModel({
    required this.uid,
    required this.username,
    required this.avatar,
    required this.flow,
    required this.isOnline,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      avatar: map['avatar'] ?? '👤',
      flow: map['flow'] ?? 0,
      isOnline: map['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'avatar': avatar,
      'flow': flow,
      'isOnline': isOnline,
    };
  }
}