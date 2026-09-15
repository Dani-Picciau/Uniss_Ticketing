package com.example.java_spring_boot.services;

import com.example.java_spring_boot.database_connections.ProcedureRepository;
import com.example.java_spring_boot.database_connections.UserRepository;
import com.example.java_spring_boot.database_connections.WorkflowTemplateRepository;
import com.example.java_spring_boot.entities.Node;
import com.example.java_spring_boot.entities.Procedure;
import com.example.java_spring_boot.entities.Procedure.CompletedStep;
import com.example.java_spring_boot.entities.Procedure.RequirementStatus;
import com.example.java_spring_boot.entities.ProfessorRequest;
import com.example.java_spring_boot.entities.RequirementDefinition;
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
    private final UserService userService;
    private final ProfessorRequestService professorRequestService;

    public WorkflowService(ProcedureRepository procedureRepository,
                           WorkflowTemplateRepository workflowTemplateRepository,
                           UserRepository userRepository,
                           UserService userService,
                           ProfessorRequestService professorRequestService) {
        this.procedureRepository = procedureRepository;
        this.workflowTemplateRepository = workflowTemplateRepository;
        this.userRepository = userRepository;
        this.userService = userService;
        this.professorRequestService = professorRequestService;
    }

    // -------------------------------------------------------------------------
    // 1. START A NEW PROCEDURE
    // Carica il template dal DB, crea l'istanza e inizializza il primo step.
    // -------------------------------------------------------------------------

    public Procedure startProcedure(String procedureType,
                                    String title,
                                    double amount,
                                    String fundOwnerId,
                                    String assignedRupId,
                                    Date deadline,
                                    Integer duration,
                                    String assignedAdministratorId,
                                    Date startDate,
                                    String ticketRequestId,
                                    String scholarshipHolderName,
                                    String requesterId,         // ---> NEW
                                    List<String> requesterRoles) { // ---> NEW

        // Block unauthorized users from bypassing the UI
        if (requesterRoles == null || (!requesterRoles.contains("RUP") && !requesterRoles.contains("AMMINISTRATORE_ASSEGNATO"))) {
            throw new RuntimeException("Accesso negato: Solo il personale amministrativo può avviare una procedura formale.");
        }

        // Only the RUP can assign the procedure to someone else.
        if (!requesterRoles.contains("RUP")) {
            assignedAdministratorId = requesterId;
        }
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

        // 3a. Initialize the requirements for the first step (all unsatisfied)
        // Iterating over RequirementDefinition objects instead of Strings
        List<RequirementStatus> initialRequirements = new ArrayList<>();
        for (RequirementDefinition reqDef : firstNode.getRequirementsToSatisfy()) {
            initialRequirements.add(new RequirementStatus(reqDef.getName(), false, reqDef.getTargetRole()));
        }

        // 3b. Initialize Global Requirements mapping from the template
        List<RequirementStatus> initialGlobalRequirements = new ArrayList<>();
        if (template.getGlobalRequirements() != null) {
            for (RequirementDefinition reqDef : template.getGlobalRequirements()) {
                initialGlobalRequirements.add(new RequirementStatus(reqDef.getName(), false, reqDef.getTargetRole()));
            }
        }

        // 4. Fetch Professor to assign the department to the procedure
        // Determine the requesting professor based on the ticket
        String actualTicketRequesterId = fundOwnerId; // Default fallback: the fund owner is the requester

        if (ticketRequestId != null && !ticketRequestId.trim().isEmpty()) {
            // If a ticket is linked, we extract the real requester from the ticket document
            ProfessorRequest linkedTicket = professorRequestService.getRequestById(ticketRequestId);
            actualTicketRequesterId = linkedTicket.getRequestingProfessorId();
        }

        User ticketRequester = userRepository.findById(actualTicketRequesterId)
                .orElseThrow(() -> new RuntimeException("Docente richiedente non trovato"));

        User fundOwner = userRepository.findById(fundOwnerId)
                .orElseThrow(() -> new RuntimeException("Docente titolare dei fondi non trovato"));

        // 5. Create the procedure instance
        Procedure procedure = new Procedure();
        procedure.setProcedureType(procedureType);
        procedure.setTitle(title);
        procedure.setAmount(amount);
        procedure.setCreatedAt(new Date());
        procedure.setFundOwnerId(fundOwnerId);
        procedure.setTicketRequesterId(actualTicketRequesterId);
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

        // Set the department
        procedure.setDepartment(ticketRequester.getDepartment());
        /* 
            Da modificare! Va pensata un po' meglio, in teoria la procedura dovrebbe essere
            asseganta al dipartimento che detiene i fondi, quindi quello del fundOwner.
            Il problema è che le richieste dei docenti sono visibili solo agli amministratori
            del proprio dipartimento, e questi possono creare procedure solo per il proprio 
            dipartimento. Quindi per il momento il dipartimento sarà quello di chi effettua 
            la richiesta. Tanto nella prima fase sarà utilizzato da un solo dipartimento. 
        */
        
        // Denormalize text names for faster UI reads
        procedure.setFundOwnerName(userService.getUserDisplayNameById(fundOwnerId));
        procedure.setTicketRequesterName(ticketRequester.getDisplayName());
        procedure.setAssignedRupName(userService.getUserDisplayNameById(assignedRupId));
        procedure.setAssignedAdministratorName(userService.getUserDisplayNameById(assignedAdministratorId));
        // Save the plain text name provided by Flutter
        procedure.setScholarshipHolderName(scholarshipHolderName);

        // Note e scadenza partono vuote, sarà l'utente a compilarle su Flutter per questo step
        procedure.setCurrentNodeNotes(null);
        procedure.setCurrentNodeDeadline(null);
        
        // Assegnazione dinamica del ruolo richiesto per il nodo corrente
        procedure.setCurrentEnabledRole(firstNode.getEnabledRole()); 
        
        procedure.setStatus("Attiva");
        procedure.setCurrentRequirementsStatus(initialRequirements);
        // Assign the generated global requirements to the procedure
        procedure.setGlobalRequirementsStatus(initialGlobalRequirements);

        procedure.setCompletedSteps(new ArrayList<>());

        // 6. Save and return
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
        verifyUserRole(userId, procedure);

        // 3. Find the requirement and update it
        boolean found = false;
        for (RequirementStatus req : procedure.getCurrentRequirementsStatus()) {
            if (req.getRequirementName().equals(requirementName)) {
                req.setSatisfied(satisfied);

                // Reset the ping-pong notification ticket once the admin checks the box
                if (satisfied) {
                    req.setVerificationRequested(false); 
                }

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

    // Method for the Admin/RUP to physically check off global requirements (e.g., Conflict of Interest)
    public Procedure updateGlobalRequirementStatus(String procedureId,
                                                   String requirementName,
                                                   boolean satisfied,
                                                   String userId) {
        Procedure procedure = getProcedureById(procedureId);
        
        // Only Admin or RUP can physically check off a document in the system
        verifyUserRole(userId, procedure);

        boolean found = false;
        for (RequirementStatus req : procedure.getGlobalRequirementsStatus()) {
            if (req.getRequirementName().equals(requirementName)) {
                req.setSatisfied(satisfied);
                if (satisfied) {
                    req.setVerificationRequested(false); // Reset notification
                }
                found = true;
                break;
            }
        }
        if (!found) {
            throw new RuntimeException("Requisito globale non trovato: " + requirementName);
        }
        return procedureRepository.save(procedure);
    }

    // Maker-Checker logic (Ping-Pong). Target users call this to notify the Admin they completed a task.
    public Procedure sendVerificationRequest(String procedureId, String requirementName, boolean isGlobal, String userId) {
        Procedure procedure = getProcedureById(procedureId);
        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("Utente non trovato"));
        
        // Determine which list to search based on the isGlobal flag sent by the frontend
        List<RequirementStatus> targetList = isGlobal 
            ? procedure.getGlobalRequirementsStatus() 
            : procedure.getCurrentRequirementsStatus();

        boolean found = false;
        for (RequirementStatus req : targetList) {
            if (req.getRequirementName().equals(requirementName)) {
                
                // Security Check: Only the specific targetRole (e.g., "DIRETTORE") can request verification
                if (req.getTargetRole() != null) {
                    if (user.getRoles() == null || !user.getRoles().contains(req.getTargetRole())) {
                        throw new RuntimeException("Operazione negata: non hai il ruolo richiesto per questo documento (" + req.getTargetRole() + ").");
                    }
                } else {
                    throw new RuntimeException("Questo documento è di competenza esclusiva dell'amministrazione.");
                }

                // Trigger the virtual ticket for the administrator
                req.setVerificationRequested(true);
                found = true;
                break;
            }
        }
        
        if (!found) {
            throw new RuntimeException("Requisito non trovato: " + requirementName);
        }

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

        verifyUserRole(completedByUserId, procedure);

        // 2. If not skipping, verify all requirements are satisfied
        if (!skip && !procedure.areAllCurrentRequirementsSatisfied()) {
            throw new RuntimeException(
                    "Non tutti i requisiti sono soddisfatti per avanzare");
        }

        // Check if the current node has blocking global requirements that are NOT satisfied yet
        if (!skip && currentNode.getBlockingGlobalRequirements() != null) {
            for (String blockingReqName : currentNode.getBlockingGlobalRequirements()) {
                boolean isSatisfied = procedure.getGlobalRequirementsStatus().stream()
                        .anyMatch(req -> req.getRequirementName().equals(blockingReqName) && req.isSatisfied());
                
                if (!isSatisfied) {
                    throw new RuntimeException("Impossibile avanzare: manca il requisito trasversale obbligatorio -> " + blockingReqName);
                }
            }
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

            // Update ticket status to "Assolta" if a ticket is linked
            if (procedure.getTicketRequestId() != null) {
                professorRequestService.markTicketAsResolved(procedure.getTicketRequestId());
            }

            return procedureRepository.save(procedure);
        }

        // 7. Load the next node and initialize its requirements
        Node nextNode = template.findNodeById(nextNodeId);
        if (nextNode == null) {
            throw new RuntimeException("Nodo successivo non trovato: " + nextNodeId);
        }

        List<RequirementStatus> nextRequirements = new ArrayList<>();
        for (RequirementDefinition reqDef : nextNode.getRequirementsToSatisfy()) {
            nextRequirements.add(new RequirementStatus(reqDef.getName(), false, reqDef.getTargetRole()));
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

        // ---> NEW: Check if blocking globals are satisfied so the UI can lock the advance button
        boolean globalsSatisfied = true;
        if (currentNode.getBlockingGlobalRequirements() != null) {
            for (String blockingReqName : currentNode.getBlockingGlobalRequirements()) {
                boolean isSat = procedure.getGlobalRequirementsStatus().stream()
                        .anyMatch(req -> req.getRequirementName().equals(blockingReqName) && req.isSatisfied());
                if (!isSat) { globalsSatisfied = false; break; }
            }
        }

        return new StepOptions(
                currentNode.getNodeId(),
                currentNode.getStageName(),
                currentNode.getEnabledRole(),
                skipAvailable,
                (allSatisfied && globalsSatisfied) // True only if BOTH local and global are satisfied
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

    /**
     * Fetches procedures based on user role, requested view, and filters.
     * Contains all the business logic for access control.
     */
    /**
     * Fetches procedures based on user role, requested view, and filters.
     * Contains all the business logic for access control and downgrade security.
     */
    public List<Procedure> getFilteredProcedures(String userId, List<String> roles, String procedureType, String status, String viewAs) {
        
        // 1. Fetch the user from the database to know their specific department
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Utente non trovato"));
        String userDept = user.getDepartment();

        // 2. Default View Resolution: If Flutter does not send a specific 'viewAs' parameter 
        // (e.g., when the app first opens), we automatically assign the highest possible view 
        // based on the user's roles.
        if (viewAs == null || viewAs.trim().isEmpty()) {
            if (roles.contains("DIRETTORE") || roles.contains("RUP")) {
                viewAs = "DIPARTIMENTO";
            } else if (roles.contains("AMMINISTRATORE_ASSEGNATO")) {
                viewAs = "AMMINISTRATORE_ASSEGNATO";
            } else {
                viewAs = "DOCENTE";
            }
        }

        // 3. Security Check: We must prevent a malicious user from requesting a view they don't own.
        // For example, a simple "DOCENTE" cannot send "?viewAs=RUP" via API to see admin data.
        // ("DIPARTIMENTO" is a special valid view for Directors and RUPs, so we check it inside the switch).
        if (!viewAs.equals("DIPARTIMENTO") && !roles.contains(viewAs)) {
            throw new RuntimeException("Accesso negato: tentativo di impersonare un ruolo non posseduto (" + viewAs + ").");
        }

        // 4. Execute the correct query based on the requested view (Downgrade logic)
        switch (viewAs.toUpperCase()) {
            
            case "DIPARTIMENTO":
                // 4A. Department View: Only Directors and RUPs can see everything in their department.
                // We double-check the roles just to be 100% safe.
                if (!roles.contains("DIRETTORE") && !roles.contains("RUP")) {
                    throw new RuntimeException("Permesso negato per vista Dipartimento");
                }
                
                // If a procedureType filter is requested, return only procedures of that type in the department.
                if (procedureType != null && !procedureType.trim().isEmpty()) {
                    return procedureRepository.findByProcedureTypeAndDepartment(procedureType, userDept);
                }
                // Otherwise, return ALL procedures in the department.
                return procedureRepository.findByDepartment(userDept);

            case "RUP":
            case "AMMINISTRATORE_ASSEGNATO":
                // 4B. Administrator View: They see only procedures assigned to them OR not assigned yet (null).
                // We create a list with [userId, null] to use the "In" keyword in our MongoDB query.
                List<String> validAdminIdsForProcedure = java.util.Arrays.asList(userId, null);
                
                // Filter by procedureType if requested.
                if (procedureType != null && !procedureType.trim().isEmpty()) {
                    return procedureRepository.findByProcedureTypeAndAssignedAdministratorIdIn(procedureType, validAdminIdsForProcedure);
                }
                // Otherwise, return all assigned/unassigned procedures for this admin.
                return procedureRepository.findByAssignedAdministratorIdIn(validAdminIdsForProcedure);

            case "DOCENTE":
            default:
                // 4C. Professor View: They see ONLY procedures where they are the Requester OR the Fund Owner.
                // We pass the userId twice because the repository method checks both fields (OR condition).
                if (status != null && !status.trim().isEmpty()) {
                    return procedureRepository.findByStatusAndTicketRequesterIdOrStatusAndFundOwnerId(status, userId, status, userId);
                }
                // Otherwise, return all procedures involving this professor.
                return procedureRepository.findByTicketRequesterIdOrFundOwnerId(userId, userId);
        }
    }

   // -------------------------------------------------------------------------
    // 6. FULL TIMELINE — past + current + projected future path
    // -------------------------------------------------------------------------

    public TimelineDto getFullTimeline(String procedureId) {
        Procedure procedure = getProcedureById(procedureId);
        WorkflowTemplate template = getTemplateForProcedure(procedure);

        // Fetch the real name of the assigned administrator
        String assignedAdminName = userService.getUserDisplayNameById(procedure.getAssignedAdministratorId());

        List<TimelineStepDto> steps = new ArrayList<>();

        // 1. ALREADY COMPLETED STEPS (All historical requirements are satisfied = true)
        for (Procedure.CompletedStep completed : procedure.getCompletedSteps()) {
            List<RequirementStatusDto> reqDtos = completed.getRequirementsAtCompletion()
                    .stream()
                    .map(r -> new RequirementStatusDto(r.getRequirementName(), true))
                    .toList();

            // Fetch the name of the user who completed this step 
            String stepUserName = userService.getUserDisplayNameById(completed.getCompletedByUserId());

            steps.add(new TimelineStepDto(
                    completed.getNodeId(),
                    completed.getStageName(),
                    null,
                    reqDtos,
                    true,
                    false,
                    completed.getNotesAtCompletion(),
                    completed.getNodeDeadlineAtCompletion(),
                    stepUserName 
            ));
        }

        if (!procedure.isFinished()) {
            // 2. CURRENT STEP (Read the actual boolean state saved in MongoDB!)
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
                    procedure.getCurrentNodeDeadline(),
                    null // <-- No one has completed it yet
            ));

            // 3. PROJECTED FUTURE STEPS (All requirements start with satisfied = false)
            Node cursor = currentNode;
            int safetyLimit = template.getNodes().size() + 1;

            while (safetyLimit-- > 0) {
                boolean wouldSkip = canSkip(procedure, cursor);
                String nextId = wouldSkip ? cursor.getNextNodeIfSkipped() : cursor.getNextNodeIfOk();

                if (nextId == null || "FINITO".equals(nextId)) break;
                Node next = template.findNodeById(nextId);
                if (next == null) break;

                // Read RequirementDefinition objects to build future DTOs
                List<RequirementStatusDto> futureReqDtos = next.getRequirementsToSatisfy()
                        .stream()
                        .map(reqDef -> new RequirementStatusDto(reqDef.getName(), false))
                        .toList();

                steps.add(new TimelineStepDto(
                        next.getNodeId(),
                        next.getStageName(),
                        next.getEnabledRole(),
                        futureReqDtos,
                        false,
                        false,
                        null,
                        null,
                        null // <-- No one has completed it yet
                ));
                cursor = next;
            }
        }

        return new TimelineDto(
            procedure.getId(), 
            procedure.getTitle(), 
            procedure.getStatus(), 
            procedure.getStartDate(), 
            procedure.getEndDate(), 
            assignedAdminName, 
            steps
        );
    }

    // -------------------------------------------------------------------------
    // DELETE PROCEDURE
    // -------------------------------------------------------------------------
    /**
     * Deletes a procedure and resets the linked ticket (if any).
     */
    public void deleteProcedure(String procedureId) {
        Procedure procedure = getProcedureById(procedureId);
        
        // If the procedure originated from a ticket, reset the ticket status
        if (procedure.getTicketRequestId() != null) {
            professorRequestService.resetTicketStatus(procedure.getTicketRequestId());
        }
        
        procedureRepository.delete(procedure);
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
        private final String assignedAdminName;
        private final List<TimelineStepDto> steps;

        public TimelineDto(String procedureId, String title, String status, Date startDate, Date endDate, String assignedAdminName, List<TimelineStepDto> steps) {
            this.procedureId = procedureId;
            this.title = title;
            this.status = status;
            this.startDate = startDate;
            this.endDate = endDate;
            this.assignedAdminName = assignedAdminName;
            this.steps = steps;
        }

        public String getProcedureId() { return procedureId; }
        public String getTitle() { return title; }
        public String getStatus() { return status; }
        public Date getStartDate() { return startDate; }
        public Date getEndDate() { return endDate; }
        public String getAssignedAdminName() { return assignedAdminName; }
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
        private final String completedByUserName;

        public TimelineStepDto(String nodeId, String stageName, String enabledRole,
                               List<RequirementStatusDto> requirements, boolean completed, boolean active,
                               String notes, Date nodeDeadline, String completedByUserName) {
            this.nodeId = nodeId;
            this.stageName = stageName;
            this.enabledRole = enabledRole;
            this.requirements = requirements;
            this.completed = completed;
            this.active = active;
            this.notes = notes;
            this.nodeDeadline = nodeDeadline;
            this.completedByUserName = completedByUserName;
        }

        public String getNodeId() { return nodeId; }
        public String getStageName() { return stageName; }
        public String getEnabledRole() { return enabledRole; }
        public List<RequirementStatusDto> getRequirements() { return requirements; }
        public boolean isCompleted() { return completed; }
        public boolean isActive() { return active; }
        public String getNotes() { return notes; }
        public Date getNodeDeadline() { return nodeDeadline; }
        public String getCompletedByUserName() { return completedByUserName; }
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
        verifyUserRole(userId, procedure);

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

    /**
     * Verifies if the user has the required permissions to interact with the current node.
     * Allows a total override (God-Mode) if the user is the RUP assigned to this specific procedure.
     */
    private void verifyUserRole(String userId, Procedure procedure) {
        // 1. If the user is the RUP of this procedure, skip role checks
        if (procedure.getAssignedRupId() != null && procedure.getAssignedRupId().equals(userId)) {
            return;
        }

        String requiredRole = procedure.getCurrentEnabledRole();
        
        // 2. If no role is required (e.g., procedure is "FINITO"), skip standard role checks
        if (requiredRole == null) return; 

        // 3. Standard check for all other users (e.g., Director, Professor, or a non-assigned RUP)
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Utente non trovato per la verifica dei permessi."));

        // If the role is null or does not match the required one -> throw error
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
    public Procedure changeAssignedAdministrator(String procedureId, String newAssignedAdminId, List<String> requesterRoles) {
        // Controllo di sicurezza: solo il RUP può fare questa operazione
        if (requesterRoles == null || !requesterRoles.contains("RUP")) {
            throw new RuntimeException("Operazione negata: Solo il RUP può riassegnare una procedura.");
        }

        Procedure procedure = getProcedureById(procedureId);
        procedure.setAssignedAdministratorId(newAssignedAdminId);
        procedure.setAssignedAdministratorName(userService.getUserDisplayNameById(newAssignedAdminId));
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
        //Iterating over RequirementDefinition objects, extracting name and targetRole
        List<RequirementStatus> initialRequirements = new ArrayList<>();
        for (RequirementDefinition reqDef : firstNode.getRequirementsToSatisfy()) {
            initialRequirements.add(new RequirementStatus(reqDef.getName(), false, reqDef.getTargetRole()));
        }

        // 9. Build the renewal procedure
        Procedure renewal = new Procedure();
        renewal.setProcedureType("BORSE_DI_STUDIO_RINNOVO");
        renewal.setTitle(source.getTitle()); // Inherits original title
        renewal.setAmount(0.0); // Renewals don't have a new standalone total amount
        renewal.setCreatedAt(new Date());

        // Keep the same actors
        renewal.setFundOwnerId(source.getFundOwnerId());
        renewal.setFundOwnerName(source.getFundOwnerName());

        renewal.setAssignedRupId(source.getAssignedRupId());
        renewal.setAssignedRupName(source.getAssignedRupName());

        renewal.setAssignedAdministratorId(source.getAssignedAdministratorId());
        renewal.setAssignedAdministratorName(source.getAssignedAdministratorName());

        renewal.setScholarshipHolderName(source.getScholarshipHolderName());

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