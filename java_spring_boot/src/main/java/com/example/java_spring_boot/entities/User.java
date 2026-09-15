package com.example.java_spring_boot.entities;

import java.util.List;

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
     *   "DOCENTE" — professor who opens a procedure
     *   "RUP"                 — administrative officer who manages the procedure
     *   "DIRETTORE"           — department director, signs off on key steps
     */
    private List<String> roles;

    private String title; // e.g. "Prof.", "Dott."

    /** The department the user belongs to */
    private String department;

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

    public List<String> getRoles() { return roles; }
    public void setRoles(List<String> roles) { this.roles = roles; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    /** Convenience: full display name for the UI */
    public String getDisplayName() {
        String prefix = (title != null && !title.isBlank()) ? title + " " : "";
        return prefix + name + " " + surname;
    }
}
