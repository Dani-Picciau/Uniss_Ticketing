package com.example.java_spring_boot.web_api;

import com.example.java_spring_boot.entities.Procedure;
import com.example.java_spring_boot.services.WorkflowService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat; 

import java.util.List;
import java.util.Map;
import java.util.Date;
import java.security.Principal;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import java.util.stream.Collectors;

/**
 * REST controller that exposes the workflow/procedure endpoints to Flutter.
 * Base path: /api/workflow
 */
@RestController
@RequestMapping("/api/workflow")
@CrossOrigin(origins = "*") // Allow Flutter (mobile/web) to call these endpoints
public class WorkflowController {

    private final WorkflowService workflowService;

    public WorkflowController(WorkflowService workflowService) {
        this.workflowService = workflowService;
    }

    // -------------------------------------------------------------------------
    // 1. START A NEW PROCEDURE
    // POST /api/workflow/start
    // -------------------------------------------------------------------------
    @PostMapping("/start")
    public ResponseEntity<?> startProcedure(@RequestBody StartProcedureRequest request) {
        try {
            Procedure newProcedure = workflowService.startProcedure(
                    request.getProcedureType(),
                    request.getTitle(),
                    request.getAmount(),
                    request.getRequestingProfessorId(),
                    request.getAssignedRupId(),
                    request.getDeadline(),
                    request.getDuration(),
                    request.getAssignedAdministratorId(),
                    request.getStartDate()
            );
            return ResponseEntity.ok(newProcedure);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // -------------------------------------------------------------------------
    // 1.B RENEW SCHOLARSHIP
    // POST /api/workflow/{procedureId}/renew
    // -------------------------------------------------------------------------
    @PostMapping("/{procedureId}/renew")
    public ResponseEntity<?> renewScholarship(
            @PathVariable String procedureId,
            @RequestBody RenewalScholarshipRequest request) {
        try {
            Procedure renewal = workflowService.createScholarshipRenewal(
                    procedureId,
                    request.getDuration()
            );
            return ResponseEntity.ok(renewal);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // -------------------------------------------------------------------------
    // 2. UPDATE REQUIREMENT STATUS
    // PUT /api/workflow/{procedureId}/requirement
    // -------------------------------------------------------------------------
    @PutMapping("/{procedureId}/requirement")
    public ResponseEntity<?> updateRequirementStatus(
            @PathVariable String procedureId,
            @RequestBody UpdateRequirementRequest request,
            Principal principal) {
        try{
            String userId = principal.getName();
            Procedure updatedProcedure = workflowService.updateRequirementStatus(
                    procedureId,
                    request.getRequirementName(),
                    request.isSatisfied(),
                    userId
            );
            return ResponseEntity.ok(updatedProcedure);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // -------------------------------------------------------------------------
    // 3. ADVANCE TO NEXT STEP
    // POST /api/workflow/{procedureId}/advance
    // -------------------------------------------------------------------------
    @PostMapping("/{procedureId}/advance")
    public ResponseEntity<?> advanceToNextStep(
            @PathVariable String procedureId,
            @RequestBody AdvanceStepRequest request,
            Principal principal) {
        try {
            String userId = principal.getName();
            Procedure updatedProcedure = workflowService.advanceToNextStep(
                    procedureId,
                    request.isSkip(),
                    userId
            );
            return ResponseEntity.ok(updatedProcedure);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // -------------------------------------------------------------------------
    // 4. GET STEP OPTIONS (For UI button rendering)
    // GET /api/workflow/{procedureId}/options
    // -------------------------------------------------------------------------
    @GetMapping("/{procedureId}/options")
    public ResponseEntity<?> getStepOptions(@PathVariable String procedureId) {
        try {
            WorkflowService.StepOptions options = workflowService.getStepOptions(procedureId);
            return ResponseEntity.ok(options);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // -------------------------------------------------------------------------
    // 5. DASHBOARD ENDPOINTS
    // -------------------------------------------------------------------------

    /**
     * GET /api/workflow/professor/{professorId}
     */
    @GetMapping("/professor/{professorId}")
    public ResponseEntity<List<Procedure>> getProceduresByProfessor(@PathVariable String professorId) {
        List<Procedure> procedures = workflowService.getProceduresByRequestingProfessor(professorId);
        return ResponseEntity.ok(procedures);
    }

    /**
     * GET /api/workflow/rup/{rupId}
     */
    @GetMapping("/rup/{rupId}")
    public ResponseEntity<List<Procedure>> getProceduresByRup(@PathVariable String rupId) {
        List<Procedure> procedures = workflowService.getProceduresByAssignedRup(rupId);
        return ResponseEntity.ok(procedures);
    }

    /**
     * GET /api/workflow/director
     */
    @GetMapping("/director")
    public ResponseEntity<List<Procedure>> getProceduresAwaitingDirector() {
        List<Procedure> procedures = workflowService.getProceduresAwaitingDirector();
        return ResponseEntity.ok(procedures);
    }

    // -------------------------------------------------------------------------
    // 6. RIASSEGNA AMMINISTRATORE (Solo RUP)
    // PUT /api/workflow/{procedureId}/reassign
    // -------------------------------------------------------------------------
    @PutMapping("/{procedureId}/reassign")
    public ResponseEntity<?> reassignAdministrator(
            @PathVariable String procedureId,
            @RequestBody ReassignRequest request,
            Authentication authentication) {
        try {
            // Estraiamo i ruoli dal token di Spring Security (rimuovendo il prefisso "ROLE_" messo dal filter)
            List<String> requesterRoles = authentication.getAuthorities().stream()
                    .map(GrantedAuthority::getAuthority)
                    .map(role -> role.replace("ROLE_", ""))
                    .collect(Collectors.toList());

            Procedure updatedProcedure = workflowService.changeAssignedAdministrator(
                    procedureId,
                    request.getNewAdministratorId(),
                    requesterRoles // lista sicura letta dal token
            );
            return ResponseEntity.ok(updatedProcedure);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // -------------------------------------------------------------------------
    // 7. GET FULL TIMELINE
    // GET /api/workflow/{procedureId}/timeline
    // -------------------------------------------------------------------------
    @GetMapping("/{procedureId}/timeline")
    public ResponseEntity<?> getFullTimeline(@PathVariable String procedureId) {
        try {
            WorkflowService.TimelineDto timeline = workflowService.getFullTimeline(procedureId);
            return ResponseEntity.ok(timeline);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // -------------------------------------------------------------------------
    // 8. UPDATE CURRENT STEP DETAILS (Deadline & Notes)
    // PUT /api/workflow/{procedureId}/step-details
    // -------------------------------------------------------------------------
    @PutMapping("/{procedureId}/step-details")
    public ResponseEntity<?> updateCurrentStepDetails(
            @PathVariable String procedureId,
            @RequestBody UpdateStepDetailsRequest request,
            Principal principal) {
        try {
            String userId = principal.getName();
            Procedure updatedProcedure = workflowService.updateCurrentStepDetails(
                    procedureId,
                    request.getDeadline(),
                    request.getNotes(),
                    userId
            );
            return ResponseEntity.ok(updatedProcedure);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // -------------------------------------------------------------------------
    // Inner Classes: DTOs (Data Transfer Objects) representing incoming JSON
    // -------------------------------------------------------------------------

    public static class StartProcedureRequest {
        private String procedureType;
        private String title;
        private double amount;
        private String requestingProfessorId;
        private String assignedRupId;
        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy")
        private Date deadline;
        private Integer duration;
        private String assignedAdministratorId;
        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy")
        private Date startDate;


        // Getters and Setters
        public String getProcedureType() { return procedureType; }
        public void setProcedureType(String procedureType) { this.procedureType = procedureType; }

        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public double getAmount() { return amount; }
        public void setAmount(double amount) { this.amount = amount; }

        public String getRequestingProfessorId() { return requestingProfessorId; }
        public void setRequestingProfessorId(String requestingProfessorId) { this.requestingProfessorId = requestingProfessorId; }

        public String getAssignedRupId() { return assignedRupId; }
        public void setAssignedRupId(String assignedRupId) { this.assignedRupId = assignedRupId; }

        public Date getDeadline() {return deadline; }
        public void setDeadline(Date deadline) {this.deadline = deadline;}

        public Integer getDuration() { return duration; }
        public void setDuration(Integer duration) { this.duration = duration; }

        public String getAssignedAdministratorId() {return assignedAdministratorId; }
        public void setAssignedAdministratorId(String assignedAdministratorId) {this.assignedAdministratorId = assignedAdministratorId; }

        public Date getStartDate() { return startDate; }
        public void setStartDate(Date startDate) { this.startDate = startDate; }
    }

    public static class UpdateRequirementRequest {
        private String requirementName;
        private boolean satisfied;

        // Getters and Setters
        public String getRequirementName() { return requirementName; }
        public void setRequirementName(String requirementName) { this.requirementName = requirementName; }

        public boolean isSatisfied() { return satisfied; }
        public void setSatisfied(boolean satisfied) { this.satisfied = satisfied; }
    }

    public static class AdvanceStepRequest {
        private boolean skip;

        // Getters and Setters
        public boolean isSkip() { return skip; }
        public void setSkip(boolean skip) { this.skip = skip; }
    }

    // Riassegnazione aministratore
    public static class ReassignRequest {
        private String newAdministratorId;

        public String getNewAdministratorId() { return newAdministratorId; }
        public void setNewAdministratorId(String newAdministratorId) { this.newAdministratorId = newAdministratorId; }
    }

    public static class UpdateStepDetailsRequest {
        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy")
        private Date deadline;
        private String notes;

        public Date getDeadline() { return deadline; }
        public void setDeadline(Date deadline) { this.deadline = deadline; }

        public String getNotes() { return notes; }
        public void setNotes(String notes) { this.notes = notes; }
    }

    /** 
     * Request body for renewing an existing scholarship.
     * Note: Compensation and Start Date are inherited/calculated automatically.
     */
    public static class RenewalScholarshipRequest {
        private Integer duration;

        public Integer getDuration() { return duration; }
        public void setDuration(Integer duration) { this.duration = duration; }
    }
}