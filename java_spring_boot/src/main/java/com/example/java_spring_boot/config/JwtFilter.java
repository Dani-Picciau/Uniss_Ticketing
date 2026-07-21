package com.example.java_spring_boot.config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.crypto.SecretKey;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * JWT Filter — runs once before every HTTP request.
 *
 * If the request contains a valid JWT token in the Authorization header,
 * this filter extracts the user's id and role and tells Spring Security
 * who is making the request. Spring Security then allows or blocks the
 * request based on the SecurityConfig rules.
 *
 * If the token is missing or invalid, the filter simply does nothing and
 * Spring Security will block the request with a 401 Unauthorized response
 * (unless the endpoint is public, like /api/auth/login).
 */
@Component
public class JwtFilter extends OncePerRequestFilter {

    @Value("${jwt.secret}")
    private String jwtSecret;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

            
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            response.setStatus(HttpServletResponse.SC_OK);
            filterChain.doFilter(request, response);
            return;
        }
        // 1. Read the Authorization header
        String authHeader = request.getHeader("Authorization");

        // 2. If the header is missing or doesn't start with "Bearer ", skip this filter
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        // 3. Extract the token (remove the "Bearer " prefix)
        String token = authHeader.substring(7);

        try {
            // 4. Verify the token signature and parse the claims
            SecretKey key = Keys.hmacShaKeyFor(jwtSecret.getBytes(StandardCharsets.UTF_8));

            Claims claims = Jwts.parser()
                    .verifyWith(key)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();

            // 5. Extract user id and role from the token
            String userId = claims.getSubject();
            
            
            // Extracts the "roles" array from the JWT payload and automatically maps it into a Java List.
            // List<String> roles = claims.get("roles", List.class);
            // WARNING EXPLANATION: 
            // A direct cast like this causes a "Type Safety" warning.
            // Java cannot guarantee at compile-time that the raw List returned by the JWT parser 
            // actually contains only Strings (Type Erasure).

            // SOLUTION: SAFE CASTING

            // extract into a generic list
            List<?> rawRoles = claims.get("roles", List.class);
            List<String> roles = new ArrayList<>();
            if (rawRoles != null) {
                for (Object roleObj : rawRoles) {
                    // insert roles that are strictly string 
                    roles.add(roleObj.toString());
                }
            }
            
            
            // Translate every string into a "badge" suitable for Spring Security
            List<SimpleGrantedAuthority> authorities = roles.stream()
                .map(r -> new SimpleGrantedAuthority("ROLE_" + r))
                .collect(java.util.stream.Collectors.toList());

            // 6. Tell Spring Security who this user is and what role they have
            //    This is what allows the request to proceed past the security filter
            UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(
                        userId,
                        null,
                        authorities // Passiamo la lista completa delle autorizzazioni
                );

            SecurityContextHolder.getContext().setAuthentication(authentication);

        } catch (Exception e) {
            // Token is invalid or expired — clear any existing authentication
            // Spring Security will return 401 automatically
            SecurityContextHolder.clearContext();
        }

        // 7. Continue with the next filter in the chain
        filterChain.doFilter(request, response);
    }
}
