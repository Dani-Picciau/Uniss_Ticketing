package com.example.java_spring_boot.web_api;

import com.example.java_spring_boot.entities.ProfessorRequest;
import com.example.java_spring_boot.services.ProfessorRequestService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;

import java.security.Principal;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * CONTROLLER LAYER:
 * Exposes REST API endpoints for the Flutter frontend to interact with the Professor Requests system.
 * Base path: /api/professor-requests
 */
@RestController
@RequestMapping("/api/professor-requests")
@CrossOrigin(origins = "*") // Allows the Flutter app to bypass CORS policy
public class ProfessorRequestController {

    private final ProfessorRequestService professorRequestService;

    public ProfessorRequestController(ProfessorRequestService professorRequestService) {
        this.professorRequestService = professorRequestService;
    }

    /**
     * POST /api/professor-requests
     * Allows a Professor to create a new request.
     * The Professor's ID is automatically extracted from the secure JWT token.
     */
    @PostMapping
    public ResponseEntity<?> createRequest(@RequestBody CreateRequestDto dto, Principal principal) {
        try {
            // principal.getName() safely returns the logged-in user's ID from the Spring Security context
            String professorId = principal.getName();
            ProfessorRequest request = professorRequestService.createRequest(professorId, dto.getSubject(), dto.getContent());
            return ResponseEntity.ok(request);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * GET /api/professor-requests/my-requests
     * Retrieves requests for the logged-in professor.
     * Optionally filters by status using a query parameter (e.g., ?status=In attesa).
     */
    @GetMapping("/my-requests")
    public ResponseEntity<List<ProfessorRequest>> getMyRequests(
            @RequestParam(required = false) String status, 
            Principal principal) {
        
        // Extract the professor's ID safely from the JWT token
        String professorId = principal.getName();
        List<ProfessorRequest> requests;

        // If a status is provided in the URL, filter the results
        if (status != null && !status.isBlank()) {
            requests = professorRequestService.getRequestsByProfessorAndStatus(professorId, status);
        } else {
            // Otherwise, return all requests for this professor
            requests = professorRequestService.getRequestsByProfessor(professorId);
        }
        
        return ResponseEntity.ok(requests);
    }

    /**
     * GET /api/professor-requests/status/{status}
     * Retrieves requests based on their status (e.g., /api/professor-requests/status/IN_ATTESA).
     * Typically used by the Administrative Manager (RUP) to see pending work.
     */
    @GetMapping("/status/{status}")
    public ResponseEntity<List<ProfessorRequest>> getRequestsByStatus(@PathVariable String status) {
        List<ProfessorRequest> requests = professorRequestService.getRequestsByStatus(status);
        return ResponseEntity.ok(requests);
    }

    /**
     * PUT /api/professor-requests/{id}/link-procedure
     * Called by the RUP right after starting a formal procedure to link the two together.
     */
    @PutMapping("/{id}/link-procedure")
    public ResponseEntity<?> linkProcedure(@PathVariable String id, @RequestBody LinkProcedureDto dto) {
        try {
            ProfessorRequest updatedRequest = professorRequestService.linkProcedureToRequest(id, dto.getProcedureId());
            return ResponseEntity.ok(updatedRequest);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * PUT /api/professor-requests/{id}/status
     * Called by the RUP to manually change the status (e.g., rejecting the request).
     */
    @PutMapping("/{id}/status")
    public ResponseEntity<?> updateStatus(@PathVariable String id, @RequestBody UpdateStatusDto dto) {
        try {
            ProfessorRequest updatedRequest = professorRequestService.updateStatus(id, dto.getStatus());
            return ResponseEntity.ok(updatedRequest);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * GET /api/professor-requests/assigned/{adminId}
     * Retrieves requests specifically assigned to an administrator.
     */
    @GetMapping("/assigned/{adminId}")
    public ResponseEntity<List<ProfessorRequest>> getAssignedRequests(@PathVariable String adminId) {
        List<ProfessorRequest> requests = professorRequestService.getRequestsByAssignedAdministrator(adminId);
        return ResponseEntity.ok(requests);
    }

    /**
     * PUT /api/professor-requests/{id}/assign
     * Called by the RUP to assign a pending request to an administrator.
     */
    @PutMapping("/{id}/assign")
    public ResponseEntity<?> assignRequest(@PathVariable String id, @RequestBody AssignRequestDto dto) {
        try {
            ProfessorRequest updatedRequest = professorRequestService.assignToAdministrator(id, dto.getAdministratorId());
            return ResponseEntity.ok(updatedRequest);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * DELETE /api/professor-requests/{id}
     * Called to delete a pending request. Requires ownership OR Director role.
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteRequest(@PathVariable String id, Authentication authentication) {
        try {
            // Safely extract the user's ID
            String userId = authentication.getName();
            
            // Extract the user's roles from the security token (removing the "ROLE_" prefix)
            List<String> roles = authentication.getAuthorities().stream()
                    .map(GrantedAuthority::getAuthority)
                    .map(role -> role.replace("ROLE_", ""))
                    .collect(Collectors.toList());
            
            // Call the service passing the extracted roles
            professorRequestService.deleteRequest(id, userId, roles);
            
            return ResponseEntity.ok(Map.of("message", "Richiesta eliminata con successo."));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // -------------------------------------------------------------------------
    // Inner Classes: DTOs (Data Transfer Objects) representing incoming JSON
    // -------------------------------------------------------------------------

    public static class CreateRequestDto {
        private String subject;
        private String content;

        public String getSubject() { return subject; }
        public void setSubject(String subject) { this.subject = subject; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
    }

    public static class LinkProcedureDto {
        private String procedureId;

        public String getProcedureId() { return procedureId; }
        public void setProcedureId(String procedureId) { this.procedureId = procedureId; }
    }

    public static class UpdateStatusDto {
        private String status;

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }

    public static class AssignRequestDto {
        private String administratorId;

        public String getAdministratorId() { return administratorId; }
        public void setAdministratorId(String administratorId) { this.administratorId = administratorId; }
    }
}