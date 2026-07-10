package com.example.java_spring_boot.database_connections;

import com.example.java_spring_boot.entities.WorkflowTemplate;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface WorkflowTemplateRepository extends MongoRepository<WorkflowTemplate, String> {

    /**
     * Fetches the workflow blueprint for a given procedure type.
     * Called when opening a new procedure or when the service needs
     * to know what the next step looks like.
     *
     * Example: findByProcedureType("ORDINI_SU_MEPA_BENI_CONSUMO")
     */
    Optional<WorkflowTemplate> findByProcedureType(String procedureType);
}
