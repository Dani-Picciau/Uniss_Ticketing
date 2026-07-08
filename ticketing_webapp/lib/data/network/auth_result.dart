// Percorso suggerito: lib/data/auth/auth_result.dart
//
// Rispecchia esattamente il JSON che AuthController.java restituisce su
// login riuscito: { "token", "userId", "role", "displayName" }.

class AuthResult {
  final String token;
  final String userId;
  final String role;
  final String displayName;

  const AuthResult({
    required this.token,
    required this.userId,
    required this.role,
    required this.displayName,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      token: json['token'] as String,
      userId: json['userId'] as String,
      role: json['role'] as String,
      displayName: json['displayName'] as String,
    );
  }
}
