package com.example.java_spring_boot.web_api;

import com.example.java_spring_boot.entities.Procedure;
import com.example.java_spring_boot.services.WorkflowService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

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
                    request.getAssignedRupId()
            );
            return ResponseEntity.ok(newProcedure);
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
            @RequestBody UpdateRequirementRequest request) {
        try {
            Procedure updatedProcedure = workflowService.updateRequirementStatus(
                    procedureId,
                    request.getRequirementName(),
                    request.isSatisfied(),
                    request.getUserId()
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
            @RequestBody AdvanceStepRequest request) {
        try {
            Procedure updatedProcedure = workflowService.advanceToNextStep(
                    procedureId,
                    request.isSkip(),
                    request.getCompletedByUserId()
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
    // Inner Classes: DTOs (Data Transfer Objects) representing incoming JSON
    // -------------------------------------------------------------------------

    public static class StartProcedureRequest {
        private String procedureType;
        private String title;
        private double amount;
        private String requestingProfessorId;
        private String assignedRupId;

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
    }

    public static class UpdateRequirementRequest {
        private String requirementName;
        private boolean satisfied;
        private String userId;

        // Getters and Setters
        public String getRequirementName() { return requirementName; }
        public void setRequirementName(String requirementName) { this.requirementName = requirementName; }

        public boolean isSatisfied() { return satisfied; }
        public void setSatisfied(boolean satisfied) { this.satisfied = satisfied; }

        public String getUserId() { return userId; }
        public void setUserId(String userId) { this.userId = userId; }
    }

    public static class AdvanceStepRequest {
        private boolean skip;
        private String completedByUserId;

        // Getters and Setters
        public boolean isSkip() { return skip; }
        public void setSkip(boolean skip) { this.skip = skip; }

        public String getCompletedByUserId() { return completedByUserId; }
        public void setCompletedByUserId(String completedByUserId) { this.completedByUserId = completedByUserId; }
    }
}