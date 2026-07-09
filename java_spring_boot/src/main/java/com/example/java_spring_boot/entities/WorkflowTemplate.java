package com.example.demo.entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

/**
 * Represents a reusable workflow template stored in MongoDB.
 *
 * This is the DEFINITION of a procedure type (the "blueprint").
 * It is never modified when a concrete procedure is opened or advances —
 * only the Procedure document changes.
 *
 * To modify or extend a workflow (e.g. add a new required document,
 * change the order of steps), update the corresponding MongoDB document
 * in the "template_flussi" collection. No Java code needs to change.
 */
@Document(collection = "template_flussi")
public class WorkflowTemplate {

    @Id
    private String id;

    /**
     * Unique identifier for this workflow type.
     * Examples: "ORDINI_SU_MEPA_BENI_CONSUMO", "ORDINI_FUORI_MEPA_BENI_CONSUMO"
     * This value is used as the foreign key from Procedure.procedureType.
     */
    private String procedureType;

    /** Human-readable name shown in the UI */
    private String workflowName;

    /**
     * Ordered list of nodes that define the steps of this workflow.
     * Each node is self-contained: it knows its role, its required documents,
     * and which node to go to next.
     */
    private List<Node> nodes;

    public WorkflowTemplate() {}

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getProcedureType() { return procedureType; }
    public void setProcedureType(String procedureType) { this.procedureType = procedureType; }

    public String getWorkflowName() { return workflowName; }
    public void setWorkflowName(String workflowName) { this.workflowName = workflowName; }

    public List<Node> getNodes() { return nodes; }
    public void setNodes(List<Node> nodes) { this.nodes = nodes; }

    /** Finds a node by its ID within this template. Returns null if not found. */
    public Node findNodeById(String nodeId) {
        if (nodeId == null || nodes == null) return null;
        return nodes.stream()
                .filter(n -> nodeId.equals(n.getNodeId()))
                .findFirst()
                .orElse(null);
    }
}
