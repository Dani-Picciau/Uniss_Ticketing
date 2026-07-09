package com.example.demo.database_connections;

import com.example.demo.entities.Procedure;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface ProcedureRepository extends MongoRepository<Procedure, String> {

    /** All procedures opened by a specific professor (for the professor's dashboard) */
    List<Procedure> findByRequestingProfessorId(String requestingProfessorId);

    /** All procedures assigned to a specific RUP (for the RUP's dashboard) */
    List<Procedure> findByAssignedRupId(String assignedRupId);

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
}
