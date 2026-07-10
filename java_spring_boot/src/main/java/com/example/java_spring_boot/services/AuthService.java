package com.example.java_spring_boot.services;

import com.example.java_spring_boot.database_connections.UserRepository;
import com.example.java_spring_boot.entities.User;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Service
public class AuthService {

    private final UserRepository userRepository;

    public AuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    /**
     * Secret key used to sign JWT tokens.
     * Set this in application.properties as: jwt.secret=yourSecretKeyHere
     * Must be at least 32 characters long.
     */
    @Value("${jwt.secret}")
    private String jwtSecret;

    /**
     * Token validity in milliseconds.
     * Set in application.properties as: jwt.expiration=86400000 (= 24 hours)
     */
    @Value("${jwt.expiration}")
    private long jwtExpiration;

    /**
     * Attempts to log in a user with the given email and password.
     * Returns a LoginResult containing the JWT token and user info if successful,
     * or throws an exception if the credentials are invalid.
     */
    public LoginResult login(String email, String password) {

        // 1. Find the user by email
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Utente non trovato"));

        // 2. Verify the password against the stored BCrypt hash
        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new RuntimeException("Password non corretta");
        }

        // 3. Generate a JWT token containing the user's id and role
        String token = generateToken(user);

        // 4. Return the token along with basic user info for Flutter to display
        return new LoginResult(
                token,
                user.getId(),
                user.getRole(),
                user.getTitle() + " " + user.getName() + " " + user.getSurname()
        );
    }

    /**
     * Hashes a plain-text password using BCrypt.
     * Use this when creating or updating a user's password.
     */
    public String hashPassword(String plainPassword) {
        return passwordEncoder.encode(plainPassword);
    }

    // -------------------------------------------------------------------------
    // JWT helpers
    // -------------------------------------------------------------------------

    private String generateToken(User user) {
        SecretKey key = Keys.hmacShaKeyFor(jwtSecret.getBytes(StandardCharsets.UTF_8));

        Map<String, Object> claims = new HashMap<>();
        claims.put("role", user.getRole());
        claims.put("displayName", user.getTitle() + " " + user.getName() + " " + user.getSurname());

        return Jwts.builder()
                .subject(user.getId())       // the user's MongoDB _id
                .claims(claims)              // role and display name embedded in the token
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + jwtExpiration))
                .signWith(key)
                .compact();
    }

    // -------------------------------------------------------------------------
    // Inner class: LoginResult
    // This is what gets serialized to JSON and sent back to Flutter
    // -------------------------------------------------------------------------

    public static class LoginResult {

        private final String token;
        private final String userId;
        private final String role;
        private final String displayName;

        public LoginResult(String token, String userId, String role, String displayName) {
            this.token = token;
            this.userId = userId;
            this.role = role;
            this.displayName = displayName;
        }

        public String getToken() { return token; }
        public String getUserId() { return userId; }
        public String getRole() { return role; }
        public String getDisplayName() { return displayName; }
    }
}
