package com.example.java_spring_boot.entities;

/**
 * Represents the definition of a requirement or document inside the template.
 */
public class RequirementDefinition {
    
    /** Name of the required document or action */
    private String name;
    
    /** The specific role that must provide this document (e.g., "DIRETTORE", "RUP"). Null if it's the admin. */
    private String targetRole; 

    public RequirementDefinition() {}

    public RequirementDefinition(String name, String targetRole) {
        this.name = name;
        this.targetRole = targetRole;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getTargetRole() { return targetRole; }
    public void setTargetRole(String targetRole) { this.targetRole = targetRole; }
}
