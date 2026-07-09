package com.example.demo.database_connections;

import com.example.demo.entities.User;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends MongoRepository<User, String> {

    /** Used for login: look up a user by their institutional email */
    Optional<User> findByEmail(String email);

    /** Used by the director's dashboard to list all RUPs or professors */
    List<User> findByRole(String role);
}
