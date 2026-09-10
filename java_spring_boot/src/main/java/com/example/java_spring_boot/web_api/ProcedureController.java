package com.example.java_spring_boot.web_api;

import com.example.java_spring_boot.database_connections.ProcedureRepository;
import com.example.java_spring_boot.database_connections.ProfessorRequestRepository;
import com.example.java_spring_boot.entities.Procedure;
import com.example.java_spring_boot.services.WorkflowService;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping; 
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/procedures")
public class ProcedureController {

    private final ProcedureRepository procedureRepository;
    private final ProfessorRequestRepository requestRepository;
    private final WorkflowService workflowService;

    public ProcedureController(ProcedureRepository procedureRepository, 
                               ProfessorRequestRepository requestRepository,
                               WorkflowService workflowService) {
        this.procedureRepository = procedureRepository;
        this.requestRepository = requestRepository;
        this.workflowService = workflowService;
    }

    /**
     * GET /api/procedures
     * Retrieves a list of procedures wrapped in DTOs.
     * Uses ?viewAs=DOCENTE to force the query to fetch only the logged-in user's procedures.
     */
    @GetMapping
    public ResponseEntity<List<ProcedureWithTicketDto>> getProcedures(
            @RequestParam(name = "type", required = false) String procedureType,
            @RequestParam(name = "status", required = false) String status,
            @RequestParam(name = "viewAs", required = false) String viewAs,
            Authentication authentication) {
        
        // 1. Safely extract user ID and Roles from JWT
        String userId = authentication.getName();
        List<String> roles = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .map(role -> role.replace("ROLE_", ""))
                .collect(Collectors.toList());
        
        // 2. Delegate all complex logic to the Service
        List<Procedure> procedures = workflowService.getFilteredProcedures(userId, roles, procedureType, status, viewAs);

        // 3. The Controller is only responsible for formatting the DTO
        List<ProcedureWithTicketDto> dtoList = procedures.stream().map(procedure -> {
            ProcedureWithTicketDto dto = new ProcedureWithTicketDto(procedure);
            if (procedure.getTicketRequestId() != null) {
                requestRepository.findById(procedure.getTicketRequestId())
                        .ifPresent(ticket -> {
                            dto.setTicketSubject(ticket.getSubject());
                            dto.setTicketContent(ticket.getContent());
                        });
            }
            return dto;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(dtoList);
    }

    /**
     * GET /api/procedures/{id}
     * Retrieves a procedure and its associated ticket request details (if any) on the fly.
     */
    @GetMapping("/{id}")
    public ResponseEntity<ProcedureWithTicketDto> getProcedureById(@PathVariable String id) {
        Procedure procedure = procedureRepository.findById(id).orElse(null);
        
        if (procedure == null) {
            return ResponseEntity.notFound().build();
        }

        // 1. Wrap the procedure in our DTO
        ProcedureWithTicketDto dto = new ProcedureWithTicketDto(procedure);

        // 2. If a ticket is linked, fetch its subject and content from the DB
        if (procedure.getTicketRequestId() != null) {
            requestRepository.findById(procedure.getTicketRequestId())
                    .ifPresent(ticket -> {
                        dto.setTicketSubject(ticket.getSubject());
                        dto.setTicketContent(ticket.getContent());
                    });
        }

        return ResponseEntity.ok(dto);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProcedure(@PathVariable String id) {
        if (procedureRepository.existsById(id)) {
            procedureRepository.deleteById(id);
            return ResponseEntity.noContent().build(); // Restituisce HTTP 204 (Successo, nessun contenuto)
        } else {
            return ResponseEntity.notFound().build(); // Restituisce HTTP 404 se l'ID non esiste
        }
    }

    // -------------------------------------------------------------------------
    // DTO for returning a Procedure along with its original request text
    // -------------------------------------------------------------------------
    public static class ProcedureWithTicketDto {
        /** The full procedure instance */
        private Procedure procedure;
        
        /** The subject of the associated ProfessorRequest (if any) */
        private String ticketSubject;
        
        /** The content body of the associated ProfessorRequest (if any) */
        private String ticketContent;

        public ProcedureWithTicketDto(Procedure procedure) {
            this.procedure = procedure;
        }

        // Getters and Setters
        public Procedure getProcedure() { return procedure; }
        public void setProcedure(Procedure procedure) { this.procedure = procedure; }

        public String getTicketSubject() { return ticketSubject; }
        public void setTicketSubject(String ticketSubject) { this.ticketSubject = ticketSubject; }

        public String getTicketContent() { return ticketContent; }
        public void setTicketContent(String ticketContent) { this.ticketContent = ticketContent; }
    }
}