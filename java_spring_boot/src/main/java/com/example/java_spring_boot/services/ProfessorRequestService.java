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
     * NEW: Assigns a pending ticket to a specific administrator and updates its status.
     * Called by the RUP.
     */
    public ProfessorRequest assignToAdministrator(String requestId, String adminId) {
        ProfessorRequest request = ticketRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found: " + requestId));
        
        request.setAssignedAdministratorId(adminId);
        request.setAssignedAdministratorName(userService.getUserDisplayNameById(adminId));
        request.setStatus("Assegnata"); // Cambia lo stato per distinguerla da quelle "In attesa" generiche
        
        return ticketRepository.save(request);
    }

    /**
     * NEW: Retrieves all requests assigned to a specific administrator.
     */
    public List<ProfessorRequest> getRequestsByAssignedAdministrator(String adminId) {
        return ticketRepository.findByAssignedAdministratorIdOrderByCreatedAtDesc(adminId);
    }

    /**
     * Allows a professor to delete their own request, provided it is still pending ("In attesa").
     */
    public void deleteRequest(String requestId, String professorId) {
        ProfessorRequest request = ticketRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found: " + requestId));

        // 1. Controllo di sicurezza: Il docente può eliminare solo le sue richieste
        if (!request.getRequestingProfessorId().equals(professorId)) {
            throw new RuntimeException("Operazione negata: non puoi eliminare una richiesta che non hai creato tu.");
        }

        // 2. Controllo logico: Può eliminare solo se il RUP non l'ha ancora toccata
        if (!"In attesa".equals(request.getStatus())) {
            throw new RuntimeException("Operazione negata: la richiesta è già stata presa in carico (o assegnata) e non può più essere eliminata.");
        }

        // 3. Eliminazione effettiva
        ticketRepository.delete(request);
    }
}