package com.example.java_spring_boot.entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;

/**
 * ENTITY LAYER:
 * Represents an informal request (ticket) submitted by a Professor.
 * This entity maps to the "Richieste_Docenti" collection in MongoDB.
 * 
 * It acts as a precursor to a formal Procedure. It contains simple text 
 * fields representing the user's intent. Once an administrative manager (RUP) 
 * takes charge of it, a formal Procedure (based on a Petri net template) 
 * is generated and linked to this request.
 */
@Document(collection = "Richieste_Docenti")
public class ProfessorRequest {

    @Id
    private String id;

    /** MongoDB _id of the professor who opened this request */
    private String requestingProfessorId;
    /** Real name of the professor */
    private String requestingProfessorName;

    /** MongoDB _id of the administrator assigned to handle this request */
    private String assignedAdministratorId;
    /** Real name of the assigned administrator */
    private String assignedAdministratorName;
    
    /** A short summary or title of the request for UI lists */
    private String subject; 
    
    /** The actual text content/description of the professor's request */
    private String content;
    
    private Date createdAt;

    /** 
     * Lifecycle status of the ticket.
     * Possible values: "IN_ATTESA" (Pending), "PRESA_IN_CARICO" (Taken in charge), 
     * "RIFIUTATA" (Rejected), "RISOLTA" (Resolved).
     */
    private String status;

    /** 
     * ID of the formal Procedure that the RUP started based on this ticket.
     * It establishes a forward link from the Ticket to the formal Workflow.
     * It will be null if the ticket is still pending or was rejected.
     */
    private String linkedProcedureId;

    public ProfessorRequest() {}

    // -------------------------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------------------------

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getRequestingProfessorId() { return requestingProfessorId; }
    public void setRequestingProfessorId(String requestingProfessorId) { 
        this.requestingProfessorId = requestingProfessorId; 
    }

    public String getRequestingProfessorName() { return requestingProfessorName; }
    public void setRequestingProfessorName(String requestingProfessorName) { 
        this.requestingProfessorName = requestingProfessorName; 
    }

    public String getAssignedAdministratorId() { return assignedAdministratorId; }
    public void setAssignedAdministratorId(String assignedAdministratorId) { 
        this.assignedAdministratorId = assignedAdministratorId; 
    }

    public String getAssignedAdministratorName() { return assignedAdministratorName; }
    public void setAssignedAdministratorName(String assignedAdministratorName) { 
        this.assignedAdministratorName = assignedAdministratorName; 
    }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getLinkedProcedureId() { return linkedProcedureId; }
    public void setLinkedProcedureId(String linkedProcedureId) { 
        this.linkedProcedureId = linkedProcedureId; 
    }
}