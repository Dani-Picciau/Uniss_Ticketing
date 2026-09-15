package com.example.java_spring_boot.database_connections;

import com.example.java_spring_boot.entities.ProfessorRequest;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

/**
 * REPOSITORY LAYER:
 * Interface for database operations on the "Richieste_Docenti" MongoDB collection.
 * Spring Data MongoDB automatically implements these methods based on their names.
 */
public interface ProfessorRequestRepository extends MongoRepository<ProfessorRequest, String> {
    
    /** 
     * Fetches all requests opened by a specific professor, ordered from newest to oldest.
     * Used for the Professor's dashboard.
     */
    List<ProfessorRequest> findByRequestingProfessorIdOrderByCreatedAtDesc(String professorId);
    
    /** 
     * Fetches all requests filtered by their status (e.g., all "In attesa"), ordered oldest first.
     * Used for the RUP/Administrative dashboard to manage pending tickets.
     */
    List<ProfessorRequest> findByStatusOrderByCreatedAtAsc(String status);

    /** 
     * Fetches all requests assigned to a specific administrator.
     * Used for the Administrator's dashboard to see tickets assigned to them by the RUP.
     */
    List<ProfessorRequest> findByAssignedAdministratorIdOrderByCreatedAtDesc(String adminId);

    /** 
     * Fetches requests opened by a specific professor, filtered by their current status.
     * Ordered from newest to oldest.
     */
    List<ProfessorRequest> findByRequestingProfessorIdAndStatusOrderByCreatedAtDesc(String professorId, String status);

    /** 
     * Fetches all requests, ordered from newest to oldest.
     * Used by the Director and RUP dashboards to see every ticket.
     */
    List<ProfessorRequest> findAllByOrderByCreatedAtDesc();

    /** 
     * Fetches requests assigned to a specific admin, filtered by status.
     * Ordered from newest to oldest.
     */
    List<ProfessorRequest> findByAssignedAdministratorIdAndStatusOrderByCreatedAtDesc(String adminId, String status);

    // ---> NEW: Department queries for requests
    List<ProfessorRequest> findByDepartmentOrderByCreatedAtDesc(String department);
    
    List<ProfessorRequest> findByDepartmentAndStatusOrderByCreatedAtAsc(String department, String status);

    // ---> NEW: Finds tickets assigned to a list of admins (we will pass [adminId, null])
    List<ProfessorRequest> findByAssignedAdministratorIdInOrderByCreatedAtDesc(List<String> adminIds);

    List<ProfessorRequest> findByStatusAndAssignedAdministratorIdInOrderByCreatedAtAsc(String status, List<String> adminIds);
}
