package com.example.java_spring_boot.services;

import com.example.java_spring_boot.database_connections.UserRepository;
import com.example.java_spring_boot.entities.User;
import org.springframework.stereotype.Service;

/**
 * SERVICE LAYER:
 * Dedicated service for User-related business logic and data retrieval.
 */
@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * Centralized helper method to retrieve a user's full display name.
     * Uses the modern Optional.map approach to safely handle missing users.
     */
    public String getUserDisplayNameById(String userId) {
        if (userId == null) return null;
        return userRepository.findById(userId)
                .map(User::getDisplayName)
                .orElse(null);
    }
    /** Same thing of above 
        private String getUserDisplayNameById(String userId) {
            if (userId == null) return null;

            User user = userRepository.findById(userId).orElse(null);
            if (user != null) return user.getDisplayName(); 
            
            return null;
        }
    */
}