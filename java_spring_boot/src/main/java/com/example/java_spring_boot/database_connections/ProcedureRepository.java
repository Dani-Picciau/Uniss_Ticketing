package com.example.java_spring_boot.database_connections;

import com.example.java_spring_boot.entities.Procedure;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface ProcedureRepository extends MongoRepository<Procedure, String> {

    List<Procedure> findByProcedureType(String procedureType);

    /** All procedures opened by a specific professor (for the professor's dashboard) */
    List<Procedure> findByRequestingProfessorId(String requestingProfessorId);
    
    List<Procedure> findByAssignedAdministratorId(String adminId);


    /** All procedures assigned to a specific RUP (for the RUP's dashboard) */
    List<Procedure> findByAssignedRupId(String assignedRupId);

    /** 
     * Finds all renewals linked to a specific mother scholarship. 
     * Essential for calculating total duration and finding the latest end date.
     */
    List<Procedure> findByParentProcedureId(String parentProcedureId);

    /**
     * All procedures currently waiting on a specific node.
     * Used by the director's dashboard to find every procedure
     * that is blocked waiting for their signature or approval.
     *
     * Example call from service layer:
     *   List<String> directorNodes = List.of(
     *       "STEP_7B_DETERMINA_FIRMATA",
     *       "STEP_10B_STIPULA_FIRMATA",
     *       "STEP_11B_BUONO_ORDINE_FIRMATO",
     *       "STEP_16B_MANDATO_FIRMATO"
     *   );
     *   repository.findByCurrentNodeIdIn(directorNodes);
     */
    List<Procedure> findByCurrentNodeIdIn(List<String> nodeIds);

    /**
     * All procedures with a given status.
     * Useful for dashboards that need to filter by "IN_CORSO", "COMPLETATA", etc.
     */
    List<Procedure> findByStatus(String status);

    /**
     * Combines status and RUP filter — e.g. find all active procedures for a RUP.
     */
    List<Procedure> findByAssignedRupIdAndStatus(String assignedRupId, String status);

    /**
     * Combines status and professor filter — e.g. find all active procedures for a professor.
     */
    List<Procedure> findByRequestingProfessorIdAndStatus(String requestingProfessorId, String status);

    /** 
     * Fetches procedures assigned to a specific administrator, filtered by type. 
     */
    List<Procedure> findByAssignedAdministratorIdAndProcedureType(String adminId, String procedureType);

    /**
     * Retrieves a list of procedures currently awaiting action from a specific role.
     * Used to dynamically populate role-based dashboards (e.g., fetching all procedures
     * waiting for the 'DIRETTORE' regardless of the specific workflow step they are on).
     *
     * @param role the user role to filter by (e.g., "DIRETTORE", "RUP", "DOCENTE_RICHIEDENTE")
     * @return a list of active procedures assigned to the specified role
     */
    List<Procedure> findByCurrentEnabledRole(String role);

    /**
     * Department-based queries for Role visibility
     */
    List<Procedure> findByDepartment(String department);
    
    List<Procedure> findByProcedureTypeAndDepartment(String procedureType, String department);
    
    List<Procedure> findByCurrentEnabledRoleAndDepartment(String role, String department);

    // Finds procedures assigned to a list of admins (we will pass [adminId, null])
    List<Procedure> findByAssignedAdministratorIdIn(List<String> adminIds);

    List<Procedure> findByProcedureTypeAndAssignedAdministratorIdIn(String procedureType, List<String> adminIds);

    // Finds procedures matching the professor in either of the two fields
    List<Procedure> findByTicketRequesterIdOrFundOwnerId(String requesterId, String ownerId);

    // Finds procedures by status AND either requesting or assigned professor (fund owner).
    // Spring Data evaluates "And" before "Or", so we must repeat the status check in the method name.
    List<Procedure> findByStatusAndTicketRequesterIdOrStatusAndFundOwnerId(
        String status1, String requesterId, String status2, String ownerId
    );
}
