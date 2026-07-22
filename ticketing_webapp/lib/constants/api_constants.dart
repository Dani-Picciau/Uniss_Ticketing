class ApiConstants {
  // Il tuo IP locale con la porta di Spring Boot
  static const String baseUrl = 'http://localhost:8080';

  // ==================== Login ====================

  // Endpoint specifico per il login
  static const String login = '$baseUrl/api/auth/login';
  // Se vi serve, anche quello dell'hash che avete testato prima
  static const String hash = '$baseUrl/api/auth/hash';

  // ==================== getProfessor ====================

  static const String professor = '$baseUrl/api/users/professors';
  static const String assignedAdministrator = '$baseUrl/api/users/assignedAdministrator';

}
