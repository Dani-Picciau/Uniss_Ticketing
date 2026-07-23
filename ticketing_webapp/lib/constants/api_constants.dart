class ApiConstants {
  // Il tuo IP locale con la porta di Spring Boot
  static const String baseUrl = 'http://localhost:8080';

  // ==================== Login ====================
  static const String login =
      '$baseUrl/api/auth/login'; // Endpoint specifico per il login
  static const String hash =
      '$baseUrl/api/auth/hash'; // Se vi serve, anche quello dell'hash che avete testato prima

  // ========== Ottenimento professori e amministratori per il form ==========
  static const String professor = '$baseUrl/api/users/professors';
  static const String assignedAdministrator =
      '$baseUrl/api/users/assignedAdministrator';

  // ========== Creazione di una nuova procedura ==========
  static const String createProcedure = '$baseUrl/api/workflow/start';
}
