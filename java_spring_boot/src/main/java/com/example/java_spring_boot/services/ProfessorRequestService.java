package com.example.java_spring_boot.services;

import com.example.java_spring_boot.database_connections.ProfessorRequestRepository;
import com.example.java_spring_boot.entities.ProfessorRequest;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * SERVICE LAYER:
 * Contains the business logic for managing TicketRequests.
 * Acts as an intermediary between the REST Controller and the MongoDB Repository.
 */
@Service
public class ProfessorRequestService {

    private final ProfessorRequestRepository ticketRepository;
    private final UserService userService;

    public ProfessorRequestService(ProfessorRequestRepository ticketRepository, UserService userService) {
        this.ticketRepository = ticketRepository;
        this.userService = userService;
    }

    /**
     * Creates a new informal request from a Professor.
     */
    public ProfessorRequest createRequest(String professorId, String subject, String content) {
        ProfessorRequest request = new ProfessorRequest();
        request.setRequestingProfessorId(professorId);
        request.setRequestingProfessorName(userService.getUserDisplayNameById(professorId)); 
        request.setSubject(subject);
        request.setSubject(subject);
        request.setContent(content);
        request.setCreatedAt(new Date());
        request.setStatus("In attesa"); 
        return ticketRepository.save(request);
    }

    /**
     * Retrieves all requests submitted by a specific Professor.
     */
    public List<ProfessorRequest> getRequestsByProfessor(String professorId) {
        return ticketRepository.findByRequestingProfessorIdOrderByCreatedAtDesc(professorId);
    }

    /**
     * Retrieves all requests matching a specific status (e.g., pending requests for the RUP).
     */
    public List<ProfessorRequest> getRequestsByStatus(String status) {
        return ticketRepository.findByStatusOrderByCreatedAtAsc(status);
    }

    /**
     * Retrieves all requests submitted by a specific Professor, filtered by a specific status.
     */
    public List<ProfessorRequest> getRequestsByProfessorAndStatus(String professorId, String status) {
        return ticketRepository.findByRequestingProfessorIdAndStatusOrderByCreatedAtDesc(professorId, status);
    }

    /**
     * Updates the status of a ticket (e.g., rejecting it or marking it resolved).
     */
    public ProfessorRequest updateStatus(String requestId, String newStatus) {
        ProfessorRequest request = ticketRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found: " + requestId));
        request.setStatus(newStatus);
        return ticketRepository.save(request);
    }

    /**
     * Links a newly created formal Procedure to the original TicketRequest.
     * Automatically updates the ticket status to "Presa in carico".
     */
    public ProfessorRequest linkProcedureToRequest(String requestId, String procedureId) {
        ProfessorRequest request = ticketRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found: " + requestId));
        
        request.setStatus("Presa in carico");
        request.setLinkedProcedureId(procedureId);
        return ticketRepository.save(request);
    }

    /**
     * Assigns a pending ticket to a specific administrator and updates its status.
     * Called by the RUP.
     * If the RUP delegates it to someone else, the status becomes "Assegnata".
     * If the RUP takes it back (assigning it to themselves), it reverts to "In attesa".
     */
    public ProfessorRequest assignToAdministrator(String requestId, String adminId, String rupId) {
        ProfessorRequest request = ticketRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found: " + requestId));
        
        request.setAssignedAdministratorId(adminId);
        request.setAssignedAdministratorName(userService.getUserDisplayNameById(adminId));
        
        // Logical routing based on the assignee
        if (!adminId.equals(rupId)) {
            request.setStatus("Assegnata"); // Delegated to an administrator
        } else {
            request.setStatus("In attesa"); // The RUP took it back / kept it
        }
        
        return ticketRepository.save(request);
    }

    /**
     * Fetches requests based on user role, requested view, and filters.
     * Contains all the business logic for access control over tickets.
     */
    public List<ProfessorRequest> getFilteredRequests(String userId, List<String> roles, String status, String viewAs) {
        
        // 1. Check if the user wants to see the dashboard as a Professor (handles null safely)
        boolean forceProfessorView = "DOCENTE".equalsIgnoreCase(viewAs);

        // 2. Separate privilege levels (Admin powers are active ONLY IF forceProfessorView is false)
        boolean isDirectorOrRup = (roles.contains("DIRETTORE") || roles.contains("RUP")) && !forceProfessorView;
        boolean isAssignedAdmin = roles.contains("AMMINISTRATORE_ASSEGNATO") && !forceProfessorView;

        // 3. Execute the correct query based on role and optional filters
        if (isDirectorOrRup) {
            // Director and RUP see all requests. Filter by status if requested.
            if (status != null && !status.trim().isEmpty()) {
                return ticketRepository.findByStatusOrderByCreatedAtAsc(status);
            }
            return ticketRepository.findAllByOrderByCreatedAtDesc();
            
        } else if (isAssignedAdmin) {
            // Assigned administrators see ONLY requests assigned to them.
            if (status != null && !status.trim().isEmpty()) {
                return ticketRepository.findByAssignedAdministratorIdAndStatusOrderByCreatedAtDesc(userId, status);
            }
            return ticketRepository.findByAssignedAdministratorIdOrderByCreatedAtDesc(userId);
            
        } else {
            // Professors see ONLY their own tickets. Filter by status if requested.
            if (status != null && !status.trim().isEmpty()) {
                return ticketRepository.findByRequestingProfessorIdAndStatusOrderByCreatedAtDesc(userId, status);
            }
            return ticketRepository.findByRequestingProfessorIdOrderByCreatedAtDesc(userId);
        }
    }

    /**
     * Allows a professor to delete their own request, OR allows the Director to delete any request.
     * The request must still be pending ("In attesa").
     */
    public void deleteRequest(String requestId, String userId, List<String> userRoles) {
        ProfessorRequest request = ticketRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found: " + requestId));

        // 1. Security check: Is the user the creator, OR is the user a Director?
        boolean isOwner = request.getRequestingProfessorId().equals(userId);
        boolean isDirector = userRoles != null && userRoles.contains("DIRETTORE");

        if (!isOwner && !isDirector) {
            throw new RuntimeException("Operazione negata: non hai i permessi per eliminare questa richiesta.");
        }

        // 2. Logical check: Can only be deleted if the RUP hasn't processed it yet
        if ("Presa in carico".equals(request.getStatus()) || "Assolta".equals(request.getStatus())) {
            throw new RuntimeException("Operazione negata: la richiesta è già stata presa in carico");
        }

        // 3. Perform deletion
        ticketRepository.delete(request);
    }

    /**
     * Resets the ticket status to "In attesa" and removes the linked procedure.
     * Called when a linked procedure is deleted for some reason.
     */
    public void resetTicketStatus(String requestId) {
        ticketRepository.findById(requestId).ifPresent(request -> {
            request.setStatus("In attesa");
            request.setLinkedProcedureId(null);
            ticketRepository.save(request);
        });
    }

    /**
     * Marks the ticket as "Assolta" (completed) when the linked procedure is finished.
     */
    public void markTicketAsResolved(String requestId) {
        ticketRepository.findById(requestId).ifPresent(request -> {
            request.setStatus("Assolta");
            ticketRepository.save(request);
        });
    }
}