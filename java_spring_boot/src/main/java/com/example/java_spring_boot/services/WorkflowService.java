package com.example.java_spring_boot.services;

import com.example.java_spring_boot.database_connections.ProcedureRepository;
import com.example.java_spring_boot.database_connections.WorkflowTemplateRepository;
import com.example.java_spring_boot.entities.Node;
import com.example.java_spring_boot.entities.Procedure;
import com.example.java_spring_boot.entities.Procedure.CompletedStep;
import com.example.java_spring_boot.entities.Procedure.RequirementStatus;
import com.example.java_spring_boot.entities.WorkflowTemplate;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class WorkflowService {

    private final ProcedureRepository procedureRepository;
    private final WorkflowTemplateRepository workflowTemplateRepository;

    public WorkflowService(ProcedureRepository procedureRepository,
                           WorkflowTemplateRepository workflowTemplateRepository) {
        this.procedureRepository = procedureRepository;
        this.workflowTemplateRepository = workflowTemplateRepository;
    }

    // -------------------------------------------------------------------------
    // 1. START A NEW PROCEDURE
    // Carica il template dal DB, crea l'istanza e inizializza il primo step.
    // -------------------------------------------------------------------------

    public Procedure startProcedure(String procedureType,
                                    String title,
                                    double amount,
                                    String requestingProfessorId,
                                    String assignedRupId) {

        // 1. Load the workflow template for this procedure type
        WorkflowTemplate template = workflowTemplateRepository
                .findByProcedureType(procedureType)
                .orElseThrow(() -> new RuntimeException(
                        "Nessun template trovato per: " + procedureType));

        // 2. Get the first node of the workflow
        if (template.getNodes() == null || template.getNodes().isEmpty()) {
            throw new RuntimeException("Il template non contiene nodi: " + procedureType);
        }
        Node firstNode = template.getNodes().get(0);

        // 3. Initialize the requirements for the first step (all unsatisfied)
        List<RequirementStatus> initialRequirements = new ArrayList<>();
        for (String req : firstNode.getRequirementsToSatisfy()) {
            initialRequirements.add(new RequirementStatus(req, false));
        }

        // 4. Create the procedure instance
        Procedure procedure = new Procedure();
        procedure.setProcedureType(procedureType);
        procedure.setTitle(title);
        procedure.setAmount(amount);
        procedure.setCreatedAt(new Date());
        procedure.setRequestingProfessorId(requestingProfessorId);
        procedure.setAssignedRupId(assignedRupId);
        procedure.setCurrentNodeId(firstNode.getNodeId());
        
        // Assegnazione dinamica del ruolo richiesto per il nodo corrente
        procedure.setCurrentEnabledRole(firstNode.getEnabledRole()); 
        
        procedure.setStatus("IN_CORSO");
        procedure.setCurrentRequirementsStatus(initialRequirements);
        procedure.setCompletedSteps(new ArrayList<>());

        // 5. Save and return
        return procedureRepository.save(procedure);
    }

    // -------------------------------------------------------------------------
    // 2. UPDATE REQUIREMENT
    // Chiamato quando il RUP o il docente spunta/deseleziona una checkbox.
    // -------------------------------------------------------------------------

    public Procedure updateRequirementStatus(String procedureId,
                                             String requirementName,
                                             boolean satisfied,
                                             String userId) {

        // 1. Load the procedure
        Procedure procedure = getProcedureById(procedureId);

        // 2. Find the requirement and update it
        boolean found = false;
        for (RequirementStatus req : procedure.getCurrentRequirementsStatus()) {
            if (req.getRequirementName().equals(requirementName)) {
                req.setSatisfied(satisfied);
                found = true;
                break;
            }
        }
        if (!found) {
            throw new RuntimeException("Requisito non trovato: " + requirementName);
        }

        // 3. Save and return
        return procedureRepository.save(procedure);
    }

    // -------------------------------------------------------------------------
    // 3. ADVANCE TO NEXT STEP
    // skip = false → percorso normale (nextNodeIfOk)
    // skip = true  → percorso alternativo (nextNodeIfSkipped), solo se canSkip()
    // -------------------------------------------------------------------------

    public Procedure advanceToNextStep(String procedureId, boolean skip, String completedByUserId) {

        // 1. Load the procedure and its template
        Procedure procedure = getProcedureById(procedureId);
        WorkflowTemplate template = getTemplateForProcedure(procedure);
        Node currentNode = getCurrentNode(procedure, template);

        // 2. If not skipping, verify all requirements are satisfied
        if (!skip && !procedure.areAllCurrentRequirementsSatisfied()) {
            throw new RuntimeException(
                    "Non tutti i requisiti sono soddisfatti per avanzare");
        }

        // 3. If skipping, verify this step is actually skippable
        if (skip && !canSkip(procedure, currentNode)) {
            throw new RuntimeException(
                    "Questo step non può essere saltato");
        }

        // 4. Save the current step to the completed steps history
        CompletedStep completedStep = new CompletedStep(
                currentNode.getNodeId(),
                currentNode.getStageName(),
                completedByUserId,
                new Date(),
                new ArrayList<>(procedure.getCurrentRequirementsStatus())
        );
        procedure.getCompletedSteps().add(completedStep);

        // 5. Determine the next node
        String nextNodeId = skip
                ? currentNode.getNextNodeIfSkipped()
                : currentNode.getNextNodeIfOk();

        // 6. Check if the procedure is finished
        if ("FINITO".equals(nextNodeId)) {
            procedure.setCurrentNodeId("FINITO");
            procedure.setCurrentEnabledRole(null);
            procedure.setStatus("COMPLETATA");
            procedure.setCurrentRequirementsStatus(new ArrayList<>());
            return procedureRepository.save(procedure);
        }

        // 7. Load the next node and initialize its requirements
        Node nextNode = template.findNodeById(nextNodeId);
        if (nextNode == null) {
            throw new RuntimeException("Nodo successivo non trovato: " + nextNodeId);
        }

        List<RequirementStatus> nextRequirements = new ArrayList<>();
        for (String req : nextNode.getRequirementsToSatisfy()) {
            nextRequirements.add(new RequirementStatus(req, false));
        }

        // 8. Advance the procedure to the next node and update the dynamic role
        procedure.setCurrentNodeId(nextNodeId);
        procedure.setCurrentEnabledRole(nextNode.getEnabledRole());
        procedure.setCurrentRequirementsStatus(nextRequirements);

        return procedureRepository.save(procedure);
    }

    // -------------------------------------------------------------------------
    // 4. GET STEP OPTIONS
    // Usato dal Frontend per sapere se abilitare o mostrare i bottoni
    // -------------------------------------------------------------------------

    public StepOptions getStepOptions(String procedureId) {

        Procedure procedure = getProcedureById(procedureId);
        WorkflowTemplate template = getTemplateForProcedure(procedure);
        Node currentNode = getCurrentNode(procedure, template);

        boolean skipAvailable = canSkip(procedure, currentNode);
        boolean allSatisfied = procedure.areAllCurrentRequirementsSatisfied();

        return new StepOptions(
                currentNode.getNodeId(),
                currentNode.getStageName(),
                currentNode.getEnabledRole(),
                skipAvailable,
                allSatisfied
        );
    }

    // -------------------------------------------------------------------------
    // 5. DASHBOARD — Fetch procedures dynamically
    // -------------------------------------------------------------------------

    public List<Procedure> getProceduresByRequestingProfessor(String professorId) {
        return procedureRepository.findByRequestingProfessorId(professorId);
    }

    public List<Procedure> getProceduresByAssignedRup(String rupId) {
        return procedureRepository.findByAssignedRupId(rupId);
    }

    public List<Procedure> getProceduresAwaitingDirector() {
        // Query flessibile: non dipende dai nomi dei nodi, ma dal ruolo richiesto attualmente dal nodo!
        return procedureRepository.findByCurrentEnabledRole("DIRETTORE");
    }

    // -------------------------------------------------------------------------
    // Private helpers
    // -------------------------------------------------------------------------

    private Procedure getProcedureById(String procedureId) {
        return procedureRepository.findById(procedureId)
                .orElseThrow(() -> new RuntimeException(
                        "Procedura non trovata: " + procedureId));
    }

    private WorkflowTemplate getTemplateForProcedure(Procedure procedure) {
        return workflowTemplateRepository
                .findByProcedureType(procedure.getProcedureType())
                .orElseThrow(() -> new RuntimeException(
                        "Template non trovato per: " + procedure.getProcedureType()));
    }

    private Node getCurrentNode(Procedure procedure, WorkflowTemplate template) {
        Node node = template.findNodeById(procedure.getCurrentNodeId());
        if (node == null) {
            throw new RuntimeException(
                    "Nodo corrente non trovato: " + procedure.getCurrentNodeId());
        }
        return node;
    }

    /**
     * Utilizza Spring Expression Language (SpEL) per valutare dinamicamente 
     * le stringhe scritte nel database (es. "amount < 40000").
     */
    private boolean canSkip(Procedure procedure, Node node) {
        if (node.getSkipCondition() == null || node.getSkipCondition().isBlank()) {
            return false;
        }
        
        try {
            ExpressionParser parser = new SpelExpressionParser();
            
            // Impostiamo l'oggetto "procedure" come radice del contesto.
            // SpEL capirà automaticamente che la parola "amount" si riferisce a "procedure.getAmount()"
            StandardEvaluationContext context = new StandardEvaluationContext(procedure);
            
            Boolean result = parser.parseExpression(node.getSkipCondition()).getValue(context, Boolean.class);
            return result != null && result;
        } catch (Exception e) {
            // Se l'espressione è malformata nel DB, si assume che il salto non sia permesso
            System.err.println("Errore di valutazione della skipCondition: " + e.getMessage());
            return false;
        }
    }

    // -------------------------------------------------------------------------
    // Inner class: StepOptions
    // -------------------------------------------------------------------------

    public static class StepOptions {
        private final String nodeId;
        private final String stageName;
        private final String enabledRole;
        private final boolean canSkip;
        private final boolean canAdvance;

        public StepOptions(String nodeId, String stageName, String enabledRole,
                           boolean canSkip, boolean canAdvance) {
            this.nodeId = nodeId;
            this.stageName = stageName;
            this.enabledRole = enabledRole;
            this.canSkip = canSkip;
            this.canAdvance = canAdvance;
        }

        public String getNodeId() { return nodeId; }
        public String getStageName() { return stageName; }
        public String getEnabledRole() { return enabledRole; }
        public boolean isCanSkip() { return canSkip; }
        public boolean isCanAdvance() { return canAdvance; }
    }
}