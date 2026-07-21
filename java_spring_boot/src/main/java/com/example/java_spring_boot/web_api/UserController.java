package com.example.java_spring_boot.web_api;

import com.example.java_spring_boot.database_connections.UserRepository;
import com.example.java_spring_boot.entities.User;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserRepository userRepository;

    // Iniettiamo il repository che avevi già preparato
    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/professors")
    public List<User> getProfessori() {
        // Sfruttiamo il metodo findByRole che hai già nel tuo UserRepository
        return userRepository.findByRole("DOCENTE_RICHIEDENTE");
    }
}