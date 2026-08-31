package com.example.java_spring_boot.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

/**
 * Central security configuration for the application (Spring Security).
 *
 * This class defines how the backend handles authentication, authorization,
 * and cross-origin communication (CORS) for the REST API used by the
 * Flutter client.
 *
 * In particular:
 * - Disables CSRF protection, which is not needed because the API is
 *   stateless and protected via JWT tokens instead of cookie-based sessions.
 * - Sets session management to STATELESS: the server does not keep state
 *   between requests, each request must authenticate itself independently
 *   via the JWT token.
 * - Defines which endpoints are public (e.g. login and hash generation) and
 *   which require an authenticated user.
 * - Inserts the custom JwtFilter before Spring's standard authentication
 *   filter, so that the JWT token is validated on every request before it
 *   reaches the controllers.
 * - Configures CORS rules to allow the Flutter client (running on a
 *   different origin/port) to communicate with the backend, authorizing the
 *   necessary HTTP methods and the Authorization header used to send the
 *   JWT token.
 */

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final JwtFilter jwtFilter;

    public SecurityConfig(JwtFilter jwtFilter) {
        this.jwtFilter = jwtFilter;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // 1. Forza Spring a inserire il filtro CORS in cima alla catena dei filtri
            .cors(Customizer.withDefaults()) // Abilita gestione del CORS -> Spring cerca automaticamente un @Bean "corsConfigurationSource"
            .csrf(csrf -> csrf.disable()) // Evita che Spring blocchi le richieste POST/PUT del client 
                                        // -> Non è rischioso: token JWT inviati nell'header e API stateless
            .sessionManagement(session ->
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)) // ogni richiesta del client deve avere il token JWT per identificarsi
            .authorizeHttpRequests(auth -> auth // regole di autorizzazione sugli URL
                .requestMatchers(org.springframework.http.HttpMethod.OPTIONS, "/**").permitAll() // tutte le richieste HTTP di tipo OPTIONS su qualsiasi URL sono permesse
                .requestMatchers("/api/auth/login").permitAll() // endpoint pubblico
                .requestMatchers("/api/auth/hash").permitAll()  //endpoint pubblico
                .anyRequest().authenticated() // tutte le altre hanno bisogno di autenticazione            
            )
            .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class); /*Prende il jwtFilter (iniettato all'inizio) 
            e lo inserisce nella catena di Spring prima del filtro standard che gestisce username e password */
        
        return http.build(); //restituisce l'oggetto SecurityFilterChain configurato.
    }

    // 2. Per risolvere l'errore CORS
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        
        // Permette le richieste da qualsiasi porta (incluso il localhost di Flutter)
        configuration.setAllowedOriginPatterns(List.of("*")); 
        
        // Elenca i metodi HTTP che saranno accettati dal server
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        
        // Permette a Flutter di inviare l'header con il Token JWT
        configuration.setAllowedHeaders(List.of("Authorization", "Content-Type"));
        
        // Collega le regole appena create a tutti i percorsi dell' API
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration); 
        
        return source;
    }
}