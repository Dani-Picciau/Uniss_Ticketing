package com.example.java_spring_boot.web_api;

import com.example.java_spring_boot.services.AuthService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * REST controller that exposes the authentication endpoints to Flutter.
 * Base path: /api/auth
 */
@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*") // Allow Flutter (mobile/web) to call this endpoint
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    /**
     * Login endpoint.
     *
     * Flutter sends:
     *   POST /api/auth/login
     *   Content-Type: application/json
     *   { "email": "mario.rossi@uniss.it", "password": "plainPassword" }
     *
     * On success (HTTP 200), Flutter receives:
     *   {
     *     "token": "eyJhbGci...",   <- JWT token, save this locally in Flutter
     *     "userId": "6a3903...",
     *     "roles": ["DOCENTE_RICHIEDENTE"],
     *     "displayName": "Prof. Mario Rossi"
     *   }
     *
     * On failure (HTTP 401):
     *   { "error": "Utente non trovato" }
     *   { "error": "Password non corretta" }
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        try {
            AuthService.LoginResult result = authService.login(
                    request.getEmail(),
                    request.getPassword()
            );
            return ResponseEntity.ok(result);

        } catch (RuntimeException e) {
            // Return 401 Unauthorized with the error message
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * TEMPORARY utility endpoint — generates a BCrypt hash for a plain password.
     * Use this to populate passwordHash in MongoDB Compass during setup.
     *
     * POST /api/auth/hash
     * { "password": "laPasswordScelta" }
     * → { "hash": "$2a$10$..." }
     *
     * REMOVE THIS ENDPOINT before going to production.
     */
    @PostMapping("/hash")
    public ResponseEntity<?> hashPassword(@RequestBody Map<String, String> body) {
        String plain = body.get("password");
        if (plain == null || plain.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Password mancante"));
        }
        return ResponseEntity.ok(Map.of("hash", authService.hashPassword(plain)));
    }

    // -------------------------------------------------------------------------
    // Inner class: LoginRequest
    // Represents the JSON body sent by Flutter
    // -------------------------------------------------------------------------

    public static class LoginRequest {
        private String email;
        private String password;

        public LoginRequest() {}

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }
    }
}
