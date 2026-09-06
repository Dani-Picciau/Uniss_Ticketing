package com.example.java_spring_boot.services;

import com.example.java_spring_boot.database_connections.ProcedureRepository;
import com.example.java_spring_boot.database_connections.UserRepository;
import com.example.java_spring_boot.database_connections.WorkflowTemplateRepository;
import com.example.java_spring_boot.entities.Node;
import com.example.java_spring_boot.entities.Procedure;
import com.example.java_spring_boot.entities.Procedure.CompletedStep;
import com.example.java_spring_boot.entities.Procedure.RequirementStatus;
import com.example.java_spring_boot.entities.User;
import com.example.java_spring_boot.entities.WorkflowTemplate;

import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Service
public class WorkflowService {

    private final ProcedureRepository procedureRepository;
    private final WorkflowTemplateRepository workflowTemplateRepository;
    private final UserRepository userRepository;

    public WorkflowService(ProcedureRepository procedureRepository,
                           WorkflowTemplateRepository workflowTemplateRepository,
                           UserRepository userRepository) {
        this.procedureRepository = procedureRepository;
        this.workflowTemplateRepository = workflowTemplateRepository;
        this.userRepository = userRepository;
    }

    // -------------------------------------------------------------------------
    // 1. START A NEW PROCEDURE
    // Carica il template dal DB, crea l'istanza e inizializza il primo step.
    // -------------------------------------------------------------------------

    public Procedure startProcedure(String procedureType,
                                    String title,
                                    double amount,
                                    String requestingProfessorId,
                                    String assignedRupId,
                                    Date deadline,
                                    Integer duration,
                                    String assignedAdministratorId,
                                    Date startDate,
                                    String ticketRequestId) {

        // --- START NEW SCHOLARSHIP VALIDATION & CALCULATION ---
        Date calculatedEndDate = null;
        Double calculatedGrossMonthlyCompensation = null;

        if ("BORSE_DI_STUDIO_NUOVA".equals(procedureType)) {
            // 1. Validate duration first (to avoid division by zero or null)
            if (duration == null || duration < 3) {
                throw new RuntimeException("Una nuova borsa deve durare almeno 3 mesi.");
            }
            if (startDate == null) {
                throw new RuntimeException("La data di inizio è obbligatoria per una nuova borsa.");
            }

            // Get the current date and time using a Calendar instance
            Calendar today = Calendar.getInstance();
            // Reset all time components (hours, minutes, seconds, and milliseconds) to zero.
            // This gives us the exact midnight (00:00:00) of the current day, allowing us 
            // to perform a pure "date-only" comparison and safely ignore the specific time of day.
            today.set(Calendar.HOUR_OF_DAY, 0);
            today.set(Calendar.MINUTE, 0);
            today.set(Calendar.SECOND, 0);
            today.set(Calendar.MILLISECOND, 0);

            if (startDate.before(today.getTime())) {
                throw new RuntimeException("La data di inizio della borsa non può essere antecedente alla data odierna.");
            }
            if (amount <= 0) {
                throw new RuntimeException("L'importo totale della borsa deve essere maggiore di zero.");
            }

            // 2. Calculate monthly compensation
            calculatedGrossMonthlyCompensation = amount / duration;

            // 3. Validate calculated monthly compensation (Max 2000)
            if (calculatedGrossMonthlyCompensation > 2000.0) {
                throw new RuntimeException(String.format(
                    "L'importo totale inserito (%.2f€) diviso per i mesi scelti (%d) genera una retribuzione mensile di %.2f€, che supera il limite massimo consentito di 2000€ al mese.", 
                    amount, duration, calculatedGrossMonthlyCompensation));
            }

            // 4. Calculate end date automatically
            calculatedEndDate = calculateEndDate(startDate, duration);
        }

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
        procedure.setDeadline(deadline); 
        procedure.setDuration(duration);
        procedure.setAssignedAdministratorId(assignedAdministratorId);
        procedure.setStartDate(startDate);
        procedure.setEndDate(calculatedEndDate);
        procedure.setGrossMonthlyCompensation(calculatedGrossMonthlyCompensation);
        procedure.setParentProcedureId(null); 
        procedure.setTicketRequestId(ticketRequestId);
        
        // Note e scadenza partono vuote, sarà l'utente a compilarle su Flutter per questo step
        procedure.setCurrentNodeNotes(null);
        procedure.setCurrentNodeDeadline(null);
        
        // Assegnazione dinamica del ruolo richiesto per il nodo corrente
        procedure.setCurrentEnabledRole(firstNode.getEnabledRole()); 
        
        procedure.setStatus("Attiva");
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
        
        // 2. Verify user permissions
        verifyUserRole(userId, procedure.getCurrentEnabledRole());

        // 3. Find the requirement and update it
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

        // 4. Save and return
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

        verifyUserRole(completedByUserId, procedure.getCurrentEnabledRole());

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
                new ArrayList<>(procedure.getCurrentRequirementsStatus()),
                procedure.getCurrentNodeNotes(),    
                procedure.getCurrentNodeDeadline()
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
            procedure.setStatus("Completata");
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
        // Azzera note e scadenza per il nuovo step appena iniziato
        procedure.setCurrentNodeNotes(null);
        procedure.setCurrentNodeDeadline(null);

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

    public List<Procedure> getProceduresByAssignedAdministrator(String adminId) {
        return procedureRepository.findByAssignedAdministratorId(adminId);
    }

    public List<Procedure> getProceduresByAssignedRup(String rupId) {
        return procedureRepository.findByAssignedRupId(rupId);
    }

    public List<Procedure> getProceduresAwaitingDirector() {
        // Query flessibile: non dipende dai nomi dei nodi, ma dal ruolo richiesto attualmente dal nodo!
        return procedureRepository.findByCurrentEnabledRole("DIRETTORE");
    }

    // -------------------------------------------------------------------------
    // 6. FULL TIMELINE — passato + attuale + percorso futuro proiettato
    // -------------------------------------------------------------------------

    public TimelineDto getFullTimeline(String procedureId) {
        Procedure procedure = getProcedureById(procedureId);
        WorkflowTemplate template = getTemplateForProcedure(procedure);

        List<TimelineStepDto> steps = new ArrayList<>();

        // 1. STEP GIA' COMPLETATI (Tutti i requisiti storici risultano satisfied = true)
        for (CompletedStep completed : procedure.getCompletedSteps()) {
            List<RequirementStatusDto> reqDtos = completed.getRequirementsAtCompletion()
                    .stream()
                    .map(r -> new RequirementStatusDto(r.getRequirementName(), true))
                    .toList();

            steps.add(new TimelineStepDto(
                    completed.getNodeId(),
                    completed.getStageName(),
                    null,
                    reqDtos,
                    true,
                    false,
                    completed.getNotesAtCompletion(),
                    completed.getNodeDeadlineAtCompletion()
            ));
        }

        if (!procedure.isFinished()) {
            // 2. STEP ATTUALE (Leggiamo il vero stato booleano salvato in MongoDB!)
            Node currentNode = getCurrentNode(procedure, template);
            List<RequirementStatusDto> currentReqDtos = procedure.getCurrentRequirementsStatus()
                    .stream()
                    .map(r -> new RequirementStatusDto(r.getRequirementName(), r.isSatisfied()))
                    .toList();

            steps.add(new TimelineStepDto(
                    currentNode.getNodeId(),
                    currentNode.getStageName(),
                    currentNode.getEnabledRole(),
                    currentReqDtos,
                    false,
                    true,
                    procedure.getCurrentNodeNotes(),
                    procedure.getCurrentNodeDeadline()
            ));

            // 3. STEP FUTURI PROIETTATI (Tutti i requisiti partono da satisfied = false)
            Node cursor = currentNode;
            int safetyLimit = template.getNodes().size() + 1;

            while (safetyLimit-- > 0) {
                boolean wouldSkip = canSkip(procedure, cursor);
                String nextId = wouldSkip ? cursor.getNextNodeIfSkipped() : cursor.getNextNodeIfOk();

                if (nextId == null || "FINITO".equals(nextId)) break;
                Node next = template.findNodeById(nextId);
                if (next == null) break;

                List<RequirementStatusDto> futureReqDtos = next.getRequirementsToSatisfy()
                        .stream()
                        .map(name -> new RequirementStatusDto(name, false))
                        .toList();

                steps.add(new TimelineStepDto(
                        next.getNodeId(),
                        next.getStageName(),
                        next.getEnabledRole(),
                        futureReqDtos,
                        false,
                        false,
                        null,
                        null
                ));
                cursor = next;
            }
        }

        return new TimelineDto(procedure.getId(), procedure.getTitle(), procedure.getStatus(), procedure.getStartDate(), // PASSAGGIO DATA
            procedure.getEndDate(), steps);
    }

    // -------------------------------------------------------------------------
    // Inner classes: TimelineDto, TimelineStepDto
    // -------------------------------------------------------------------------

    public static class TimelineDto {
        private final String procedureId;
        private final String title;
        private final String status;
        private final Date startDate;
        private final Date endDate;
        private final List<TimelineStepDto> steps;

        public TimelineDto(String procedureId, String title, String status, Date startDate, Date endDate, List<TimelineStepDto> steps) {
            this.procedureId = procedureId;
            this.title = title;
            this.status = status;
            this.startDate = startDate;
            this.endDate = endDate;
            this.steps = steps;
        }

        public String getProcedureId() { return procedureId; }
        public String getTitle() { return title; }
        public String getStatus() { return status; }
        public Date getStartDate() { return startDate; }
        public Date getEndDate() { return endDate; }
        public List<TimelineStepDto> getSteps() { return steps; }
    }

    public static class TimelineStepDto {
        private final String nodeId;
        private final String stageName;
        private final String enabledRole;
        private final List<RequirementStatusDto> requirements;
        private final boolean completed;
        private final boolean active;
        private final String notes;
        private final Date nodeDeadline;

        public TimelineStepDto(String nodeId, String stageName, String enabledRole,
                               List<RequirementStatusDto> requirements, boolean completed, boolean active,
                               String notes, Date nodeDeadline) {
            this.nodeId = nodeId;
            this.stageName = stageName;
            this.enabledRole = enabledRole;
            this.requirements = requirements;
            this.completed = completed;
            this.active = active;
            this.notes = notes;
            this.nodeDeadline = nodeDeadline;
        }

        public String getNodeId() { return nodeId; }
        public String getStageName() { return stageName; }
        public String getEnabledRole() { return enabledRole; }
        public List<RequirementStatusDto> getRequirements() { return requirements; }
        public boolean isCompleted() { return completed; }
        public boolean isActive() { return active; }
        public String getNotes() { return notes; }
        public Date getNodeDeadline() { return nodeDeadline; }
    }

    public static class RequirementStatusDto {
        private final String name;
        private final boolean satisfied;

        public RequirementStatusDto(String name, boolean satisfied) {
            this.name = name;
            this.satisfied = satisfied;
        }

        public String getName() { return name; }
        public boolean isSatisfied() { return satisfied; }
    }


    // -------------------------------------------------------------------------
    // AGGIORNA SCADENZA E NOTE DELLO STEP CORRENTE (Manuale da Flutter)
    // -------------------------------------------------------------------------
    public Procedure updateCurrentStepDetails(String procedureId, Date newDeadline, String newNotes, String userId) {
        Procedure procedure = getProcedureById(procedureId);
        
        // Controllo permessi utente
        verifyUserRole(userId, procedure.getCurrentEnabledRole());

        // Se Flutter ci invia una data o una nota, la aggiorniamo
        if (newDeadline != null) {
            procedure.setCurrentNodeDeadline(newDeadline);
        }
        if (newNotes != null) {
            procedure.setCurrentNodeNotes(newNotes);
        }
        
        return procedureRepository.save(procedure);
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

    private void verifyUserRole(String userId, String requiredRole) {
        if (requiredRole == null) return; // Se la procedura è "FINITO", non c'è un ruolo

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Utente non trovato per la verifica dei permessi."));

        // Se il ruolo è nullo o non è quello richiesto -> errore 
        if (user.getRoles() == null || !user.getRoles().contains(requiredRole)) {
            throw new RuntimeException("Operazione negata: l'utente non ha il ruolo richiesto (" + requiredRole + ") per modificare questo step.");
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

    // -------------------------------------------------------------------------
    // CHANGE ASSIGNED ADMINISTRATOR
    // -------------------------------------------------------------------------
    public Procedure changeAssignedAdministrator(String procedureId, String newAdminId, List<String> requesterRoles) {
        // Controllo di sicurezza: solo il RUP può fare questa operazione
        if (requesterRoles == null || !requesterRoles.contains("RUP")) {
            throw new RuntimeException("Operazione negata: Solo il RUP può riassegnare una procedura.");
        }

        Procedure procedure = getProcedureById(procedureId);
        procedure.setAssignedAdministratorId(newAdminId);
        return procedureRepository.save(procedure);
    }

    // -------------------------------------------------------------------------
    // RENEW SCHOLARSHIP PROCEDURE
    // -------------------------------------------------------------------------
    public Procedure createScholarshipRenewal(String sourceProcedureId, Integer requestedDuration) {

        if (requestedDuration == null || requestedDuration <= 0) {
            throw new RuntimeException("La durata del rinnovo deve essere maggiore di zero.");
        }

        // 1. Fetch the source scholarship 
        Procedure source = getProcedureById(sourceProcedureId);

        // 2. Identify the true Mother scholarship to keep the tree depth flat
        String motherId = source.getParentProcedureId() != null ? source.getParentProcedureId() : source.getId();
        Procedure mother = getProcedureById(motherId);

        // 3. Fetch all previous renewals linked to the Mother
        List<Procedure> renewals = procedureRepository.findByParentProcedureId(motherId);

        // 4. Calculate total duration and find the absolute latest end date
        int totalDuration = mother.getDuration() == null ? 0 : mother.getDuration();
        Date lastEndDate = mother.getEndDate();

        for (Procedure renewal : renewals) {
            if (renewal.getDuration() != null) {
                totalDuration += renewal.getDuration();
            }
            // Update lastEndDate if this renewal ends later
            if (renewal.getEndDate() != null && (lastEndDate == null || renewal.getEndDate().after(lastEndDate))) {
                lastEndDate = renewal.getEndDate();
            }
        }

        // 5. Validation: Total duration constraint (Max 12 months sum of mother + all renewals)
        if (totalDuration + requestedDuration > 12) {
            throw new RuntimeException("La durata totale (borsa iniziale + rinnovi) non può superare i 12 mesi. Hai già raggiunto " + totalDuration + " mesi.");
        }

        // 6. Validation: Renewal window constraint (Allowed only during the last month of validity)
        validateRenewalWindow(lastEndDate);

        // --- INIZIO NUOVA LOGICA CALCOLO DATA ---
        // 7A. Calcola automaticamente la nuova data di inizio (esattamente il giorno dopo l'ultima scadenza)
        Calendar cal = Calendar.getInstance();
        cal.setTime(lastEndDate);
        cal.add(Calendar.DATE, 1);
        Date automaticallyCalculatedStartDate = cal.getTime();

        // 7B. Calcola la nuova data di fine basandosi sulla nuova data di inizio
        Date newEndDate = calculateEndDate(automaticallyCalculatedStartDate, requestedDuration);
        // --- FINE NUOVA LOGICA CALCOLO DATA ---

        // 8. Fetch the specific template for renewal to initialize the first node
        WorkflowTemplate template = workflowTemplateRepository.findByProcedureType("BORSE_DI_STUDIO_RINNOVO")
                .orElseThrow(() -> new RuntimeException("Template non trovato per: BORSE_DI_STUDIO_RINNOVO"));

        Node firstNode = template.getNodes().get(0);
        List<RequirementStatus> initialRequirements = new ArrayList<>();
        for (String req : firstNode.getRequirementsToSatisfy()) {
            initialRequirements.add(new RequirementStatus(req, false));
        }

        // 9. Build the renewal procedure
        Procedure renewal = new Procedure();
        renewal.setProcedureType("BORSE_DI_STUDIO_RINNOVO");
        renewal.setTitle(source.getTitle()); // Inherits original title
        renewal.setAmount(0.0); // Renewals don't have a new standalone total amount
        renewal.setCreatedAt(new Date());

        // Keep the same actors
        renewal.setRequestingProfessorId(source.getRequestingProfessorId());
        renewal.setAssignedRupId(source.getAssignedRupId());
        renewal.setAssignedAdministratorId(source.getAssignedAdministratorId());

        renewal.setDuration(requestedDuration);
        
        // ASSEGNAZIONE DATE AUTOMATICHE
        renewal.setStartDate(automaticallyCalculatedStartDate);
        renewal.setEndDate(newEndDate);
        
        // EREDITA IL COMPENSO DALLA MADRE (Inherits compensation strictly from Mother)
        renewal.setGrossMonthlyCompensation(mother.getGrossMonthlyCompensation());
        
        // Links back to the original mother scholarship
        renewal.setParentProcedureId(motherId); 

        // Start workflow state
        renewal.setCurrentNodeId(firstNode.getNodeId());
        renewal.setCurrentEnabledRole(firstNode.getEnabledRole());
        renewal.setStatus("Attiva");
        renewal.setCurrentRequirementsStatus(initialRequirements);
        renewal.setCompletedSteps(new ArrayList<>());

        return procedureRepository.save(renewal);
    }

    /**
     * Helper to validate that a renewal is requested during the last month of the current active scholarship.
     */
    private void validateRenewalWindow(Date currentEndDate) {
        if (currentEndDate == null) {
            throw new RuntimeException("La borsa corrente non ha una data di scadenza valida calcolata.");
        }

        Date now = new Date();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(currentEndDate);
        calendar.add(Calendar.MONTH, -1); // Window starts exactly 1 month before end date

        Date startOfLastMonth = calendar.getTime();

        if (now.before(startOfLastMonth) || now.after(currentEndDate)) {
            throw new RuntimeException("La borsa può essere rinnovata soltanto durante il suo ultimo mese di validità.");
        }
    }

    /**
     * Helper to correctly calculate the end date (adds months, subtracts 1 day).
     */
    private Date calculateEndDate(Date startDate, int months) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(startDate);
        calendar.add(Calendar.MONTH, months);
        calendar.add(Calendar.DATE, -1); // Example: starts Jan 10, lasts 3 months -> ends Apr 9
        return calendar.getTime();
    }
}