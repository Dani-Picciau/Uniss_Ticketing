package com.example.java_spring_boot.web_api;

import com.example.java_spring_boot.database_connections.ProcedureRepository;
import com.example.java_spring_boot.entities.Procedure;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/procedures")
public class ProcedureController {

    private final ProcedureRepository procedureRepository;

    public ProcedureController(ProcedureRepository procedureRepository) {
        this.procedureRepository = procedureRepository;
    }

    // Risponde a GET /api/procedures
    // Con @RequestParam("type") possiamo intercettare ?type=ORDINI_SU_MEPA_BENI_CONSUMO
    @GetMapping
    public List<Procedure> getProcedures(
            @RequestParam(name = "type", required = false) String procedureType) {
        
        // Se Flutter ci ha inviato un tipo specifico, filtriamo
        if (procedureType != null && !procedureType.isEmpty()) {
            return procedureRepository.findByProcedureType(procedureType);
        }
        
        // Altrimenti (se required = false) restituiamo tutte le procedure del DB
        return procedureRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Procedure> getProcedureById(@PathVariable String id) {
        return procedureRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}