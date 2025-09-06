class AppUser {
  final String uid;
  final String email;
  final String username;
  final UserRole role;
  final DateTime createdAt;
  final bool isActive;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    required this.role,
    required this.createdAt,
    this.isActive = true,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.name == map['role'],
        orElse: () => UserRole.student,
      ),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? username,
    UserRole? role,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum UserRole {
  admin,
  driver,
  student;

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.driver:
        return 'Driver';
      case UserRole.student:
        return 'Student';
    }
  }
}
