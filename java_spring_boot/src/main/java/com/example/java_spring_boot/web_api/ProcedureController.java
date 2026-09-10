package com.example.java_spring_boot.web_api;

import com.example.java_spring_boot.database_connections.ProcedureRepository;
import com.example.java_spring_boot.database_connections.ProfessorRequestRepository;
import com.example.java_spring_boot.entities.Procedure;
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

    public ProcedureController(ProcedureRepository procedureRepository, ProfessorRequestRepository requestRepository) {
        this.procedureRepository = procedureRepository;
        this.requestRepository = requestRepository;
    }

    /**
     * GET /api/procedures
     * Retrieves a list of procedures wrapped in DTOs to include ticket details.
     * RUP/DIRETTORE: see everything.
     * AMMINISTRATORE_ASSEGNATO: see only their assigned procedures.
     * DOCENTE: see only their requested procedures.
     */
    @GetMapping
    public ResponseEntity<List<ProcedureWithTicketDto>> getProcedures(
            @RequestParam(name = "type", required = false) String procedureType,
            @RequestParam(name = "status", required = false) String status,
            Authentication authentication) {
        
        // 1. Extract user ID and Roles safely from JWT
        String userId = authentication.getName();
        List<String> roles = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .map(role -> role.replace("ROLE_", ""))
                .collect(Collectors.toList());
        
        // 2. Separate privilege levels
        boolean isSuperAdmin = roles.contains("RUP") || roles.contains("DIRETTORE");
        boolean isAssignedAdmin = roles.contains("AMMINISTRATORE_ASSEGNATO");

        List<Procedure> procedures;

        // 3. Fetch procedures from DB based on role and filters
        if (isSuperAdmin) {
            // RUP and Director see everything. Filter by type if requested.
            if (procedureType != null && !procedureType.trim().isEmpty()) {
                procedures = procedureRepository.findByProcedureType(procedureType);
            } else {
                procedures = procedureRepository.findAll();
            }
        } else if (isAssignedAdmin) {
            // Assigned administrators see ONLY their own procedures. Filter by type if requested.
            if (procedureType != null && !procedureType.trim().isEmpty()) {
                procedures = procedureRepository.findByAssignedAdministratorIdAndProcedureType(userId, procedureType);
            } else {
                procedures = procedureRepository.findByAssignedAdministratorId(userId);
            }
        } else {
            // Professors see ONLY their requested procedures. Filter by status if requested.
            if (status != null && !status.trim().isEmpty()) {
                procedures = procedureRepository.findByRequestingProfessorIdAndStatus(userId, status);
            } else {
                procedures = procedureRepository.findByRequestingProfessorId(userId);
            }
        }

        // 4. Map the list of Procedure entities to ProcedureWithTicketDto
        List<ProcedureWithTicketDto> dtoList = procedures.stream().map(procedure -> {
            ProcedureWithTicketDto dto = new ProcedureWithTicketDto(procedure);

            // 5. If a ticket is linked, fetch its subject and content dynamically
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