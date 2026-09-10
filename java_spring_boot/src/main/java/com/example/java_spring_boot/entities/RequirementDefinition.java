package com.example.java_spring_boot.entities;

public class RequirementDefinition {
    
    private String name;
    private String targetRole; // es. "DIRETTORE", "RUP", "DOCENTE_RICHIEDENTE", o null per l'amministratore

    public RequirementDefinition() {}

    public RequirementDefinition(String name, String targetRole) {
        this.name = name;
        this.targetRole = targetRole;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTargetRole() {
        return targetRole;
    }

    public void setTargetRole(String targetRole) {
        this.targetRole = targetRole;
    }
}
