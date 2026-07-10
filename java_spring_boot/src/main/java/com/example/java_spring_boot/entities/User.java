package com.example.java_spring_boot.entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "Utenti")
public class User {

    @Id
    private String id;

    private String name;
    private String surname;
    private String email;
    private String passwordHash; // Store a BCrypt hash, never plaintext

    /**
     * Possible values (must match enabledRole in workflow nodes exactly):
     *   "DOCENTE_RICHIEDENTE" — professor who opens a procedure
     *   "RUP"                 — administrative officer who manages the procedure
     *   "DIRETTORE"           — department director, signs off on key steps
     */
    private String role;

    private String title; // e.g. "Prof.", "Dott."

    public User() {}

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String firstName) { this.name = firstName; }

    public String getSurname() { return surname; }
    public void setSurname(String lastName) { this.surname = lastName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    /** Convenience: full display name for the UI */
    public String getDisplayName() {
        String prefix = (title != null && !title.isBlank()) ? title + " " : "";
        return prefix + name + " " + surname;
    }
}
