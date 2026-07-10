package com.example.java_spring_boot.entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Represents a single concrete instance of an administrative procedure.
 *
 * This is the INSTANCE of a workflow (the "running copy").
 * It references a WorkflowTemplate by procedureType and keeps track of
 * the current step, which requirements have been satisfied, and the full
 * history of all completed steps.
 */
@Document(collection = "procedure")
public class Procedure {

    @Id
    private String id;

    /**
     * Links this procedure to its WorkflowTemplate.
     * Example: "ORDINI_SU_MEPA_BENI_CONSUMO"
     */
    private String procedureType;

    /** Human-readable title for this specific procedure */
    private String title;

    /**
     * Total amount in euros. Used to evaluate skip conditions such as
     * "amount < 40000" on optional nodes (e.g. STEP_7C fideiussione).
     */
    private double amount;

    private Date createdAt;

    // -------------------------------------------------------------------------
    // User references
    // -------------------------------------------------------------------------

    /** MongoDB _id of the professor who opened this procedure */
    private String requestingProfessorId;

    /** MongoDB _id of the RUP assigned to manage this procedure */
    private String assignedRupId;

    // -------------------------------------------------------------------------
    // Workflow state
    // -------------------------------------------------------------------------

    /**
     * The nodeId of the step this procedure is currently on.
     * Special value: "FINITO" means the procedure is fully complete.
     */
    private String currentNodeId;

    /**
     * Overall lifecycle status of this procedure.
     *
     * Possible values:
     *   "IN_CORSO"   — active, someone needs to act
     *   "COMPLETATA" — reached the final node ("FINITO")
     *   "BLOCCATA"   — stalled, waiting for an action (e.g. director signature)
     *   "ANNULLATA"  — manually cancelled
     */
    private String status;

    /**
     * Tracks which requirements have been checked off for the CURRENT step.
     * This list is replaced entirely every time the procedure advances to a new node.
     */
    private List<RequirementStatus> currentRequirementsStatus;

    /**
     * Full history of every step that has been completed.
     * Never cleared — grows with each advancement.
     * Allows administrators and the director to see the full audit trail.
     */
    private List<CompletedStep> completedSteps;

    public Procedure() {
        this.completedSteps = new ArrayList<>();
        this.currentRequirementsStatus = new ArrayList<>();
    }

    // -------------------------------------------------------------------------
    // Inner class: RequirementStatus
    // Tracks whether a single document/requirement has been satisfied
    // -------------------------------------------------------------------------

    public static class RequirementStatus {
        private String requirementName;
        private boolean satisfied;

        public RequirementStatus() {}

        public RequirementStatus(String requirementName, boolean satisfied) {
            this.requirementName = requirementName;
            this.satisfied = satisfied;
        }

        public String getRequirementName() { return requirementName; }
        public void setRequirementName(String requirementName) { this.requirementName = requirementName; }

        public boolean isSatisfied() { return satisfied; }
        public void setSatisfied(boolean satisfied) { this.satisfied = satisfied; }
    }

    // -------------------------------------------------------------------------
    // Inner class: CompletedStep
    // One entry per step that has been fully completed and advanced past
    // -------------------------------------------------------------------------

    public static class CompletedStep {

        /** The nodeId of the step that was completed */
        private String nodeId;

        /** Human-readable name of the step, copied from the template at completion time */
        private String stageName;

        /** MongoDB _id of the user who marked this step as complete */
        private String completedByUserId;

        /** Timestamp of when the step was marked complete and the procedure advanced */
        private Date completedAt;

        /**
         * Snapshot of all requirements and their final status at the time of completion.
         * Useful for audit: shows exactly what was checked off before advancing.
         */
        private List<RequirementStatus> requirementsAtCompletion;

        public CompletedStep() {}

        public CompletedStep(String nodeId, String stageName, String completedByUserId,
                             Date completedAt, List<RequirementStatus> requirementsAtCompletion) {
            this.nodeId = nodeId;
            this.stageName = stageName;
            this.completedByUserId = completedByUserId;
            this.completedAt = completedAt;
            this.requirementsAtCompletion = requirementsAtCompletion;
        }

        public String getNodeId() { return nodeId; }
        public void setNodeId(String nodeId) { this.nodeId = nodeId; }

        public String getStageName() { return stageName; }
        public void setStageName(String stageName) { this.stageName = stageName; }

        public String getCompletedByUserId() { return completedByUserId; }
        public void setCompletedByUserId(String completedByUserId) { this.completedByUserId = completedByUserId; }

        public Date getCompletedAt() { return completedAt; }
        public void setCompletedAt(Date completedAt) { this.completedAt = completedAt; }

        public List<RequirementStatus> getRequirementsAtCompletion() { return requirementsAtCompletion; }
        public void setRequirementsAtCompletion(List<RequirementStatus> requirementsAtCompletion) {
            this.requirementsAtCompletion = requirementsAtCompletion;
        }
    }

    // -------------------------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------------------------

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getProcedureType() { return procedureType; }
    public void setProcedureType(String procedureType) { this.procedureType = procedureType; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getRequestingProfessorId() { return requestingProfessorId; }
    public void setRequestingProfessorId(String requestingProfessorId) {
        this.requestingProfessorId = requestingProfessorId;
    }

    public String getAssignedRupId() { return assignedRupId; }
    public void setAssignedRupId(String assignedRupId) { this.assignedRupId = assignedRupId; }

    public String getCurrentNodeId() { return currentNodeId; }
    public void setCurrentNodeId(String currentNodeId) { this.currentNodeId = currentNodeId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<RequirementStatus> getCurrentRequirementsStatus() { return currentRequirementsStatus; }
    public void setCurrentRequirementsStatus(List<RequirementStatus> currentRequirementsStatus) {
        this.currentRequirementsStatus = currentRequirementsStatus;
    }

    public List<CompletedStep> getCompletedSteps() { return completedSteps; }
    public void setCompletedSteps(List<CompletedStep> completedSteps) { this.completedSteps = completedSteps; }

    // -------------------------------------------------------------------------
    // Convenience helpers
    // -------------------------------------------------------------------------

    /** True if the procedure has reached the final node */
    public boolean isFinished() {
        return "FINITO".equals(currentNodeId) || "COMPLETATA".equals(status);
    }

    /** True if all requirements of the current step are satisfied */
    public boolean areAllCurrentRequirementsSatisfied() {
        if (currentRequirementsStatus == null || currentRequirementsStatus.isEmpty()) return false;
        return currentRequirementsStatus.stream().allMatch(RequirementStatus::isSatisfied);
    }
}
