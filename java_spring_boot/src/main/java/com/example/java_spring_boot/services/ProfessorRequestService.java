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

    public ProfessorRequestService(ProfessorRequestRepository ticketRepository) {
        this.ticketRepository = ticketRepository;
    }

    /**
     * Creates a new informal request from a Professor.
     */
    public ProfessorRequest createRequest(String professorId, String subject, String content) {
        ProfessorRequest request = new ProfessorRequest();
        request.setRequestingProfessorId(professorId);
        request.setSubject(subject);
        request.setContent(content);
        request.setCreatedAt(new Date());
        request.setStatus("IN_ATTESA"); // Default starting status
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
     * Automatically updates the ticket status to "PRESA_IN_CARICO".
     */
    public ProfessorRequest linkProcedureToRequest(String requestId, String procedureId) {
        ProfessorRequest request = ticketRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found: " + requestId));
        
        request.setStatus("PRESA_IN_CARICO");
        request.setLinkedProcedureId(procedureId);
        return ticketRepository.save(request);
    }
}