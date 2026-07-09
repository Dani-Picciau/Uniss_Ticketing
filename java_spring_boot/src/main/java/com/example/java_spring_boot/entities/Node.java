package com.example.demo.entities;

import java.util.List;

public class Node {

    private String nodeId;
    private String stageName;

    /**
     * The role that can act on this step.
     * Must be one of: "DOCENTE_RICHIEDENTE", "RUP", "DIRETTORE"
     * These values must match exactly with the User.ruolo field.
     */
    private String enabledRole;

    private List<String> requirementsToSatisfy;

    /** ID of the next node when all requirements are satisfied */
    private String nextNodeIfOk;

    /**
     * ID of the node to jump to when this step is skipped entirely.
     * Only set on optional/conditional steps (e.g. STEP_7C for fideiussione).
     * Leave null if the step is mandatory.
     */
    private String nextNodeIfSkipped;

    /**
     * Condition that determines whether the RUP is shown the option to skip
     * this step entirely. The WorkflowService evaluates this at runtime and
     * passes a "canSkip" flag to the Flutter frontend.
     *
     * IMPORTANT — this does NOT cause an automatic skip.
     * The condition only controls whether the skip option is visible in the UI:
     *   - condition is null or false  → step is mandatory, Flutter shows one button only
     *   - condition is true           → step is optional, Flutter shows two buttons
     *                                   and the RUP decides whether to skip or not
     *
     * Example (STEP_7C fideiussione):
     *   "amount < 40000" — if the order is below €40,000 the RUP can choose
     *                      whether to request the fideiussione or skip it.
     *                      If amount >= €40,000 the fideiussione is mandatory
     *                      and the skip option is never shown.
     *
     * Leave null for all mandatory steps.
     * Stored in MongoDB so that changing the threshold rule never requires
     * recompiling any Java code — only updating the template document.
     */
    private String skipCondition;

    public Node() {}

    // Getters and Setters
    public String getNodeId() { return nodeId; }
    public void setNodeId(String nodeId) { this.nodeId = nodeId; }

    public String getStageName() { return stageName; }
    public void setStageName(String stageName) { this.stageName = stageName; }

    public String getEnabledRole() { return enabledRole; }
    public void setEnabledRole(String enabledRole) { this.enabledRole = enabledRole; }

    public List<String> getRequirementsToSatisfy() { return requirementsToSatisfy; }
    public void setRequirementsToSatisfy(List<String> requirementsToSatisfy) {
        this.requirementsToSatisfy = requirementsToSatisfy;
    }

    public String getNextNodeIfOk() { return nextNodeIfOk; }
    public void setNextNodeIfOk(String nextNodeIfOk) { this.nextNodeIfOk = nextNodeIfOk; }

    public String getNextNodeIfSkipped() { return nextNodeIfSkipped; }
    public void setNextNodeIfSkipped(String nextNodeIfSkipped) { this.nextNodeIfSkipped = nextNodeIfSkipped; }

    public String getSkipCondition() { return skipCondition; }
    public void setSkipCondition(String skipCondition) { this.skipCondition = skipCondition; }

    /** True if this node has an optional bypass path */
    public boolean isSkippable() {
        return nextNodeIfSkipped != null && !nextNodeIfSkipped.isBlank();
    }
}
