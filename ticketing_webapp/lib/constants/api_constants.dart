class ApiConstants {
  // Il tuo IP locale con la porta di Spring Boot
  static const String baseUrl = 'http://172.22.217.182:8080';

  // Endpoint specifico per il login
  static const String login = '$baseUrl/api/auth/login';

  // Se vi serve, anche quello dell'hash che avete testato prima
  static const String hash = '$baseUrl/api/auth/hash';
}
