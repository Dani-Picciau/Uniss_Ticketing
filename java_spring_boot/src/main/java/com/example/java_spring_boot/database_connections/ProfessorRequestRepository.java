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
     * Fetches all requests filtered by their status (e.g., all "IN_ATTESA"), ordered oldest first.
     * Used for the RUP/Administrative dashboard to manage pending tickets.
     */
    List<ProfessorRequest> findByStatusOrderByCreatedAtAsc(String status);
}
