package com.example.demo.config;

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
            String role = claims.get("role", String.class);

            // 6. Tell Spring Security who this user is and what role they have
            //    This is what allows the request to proceed past the security filter
            UsernamePasswordAuthenticationToken authentication =
                    new UsernamePasswordAuthenticationToken(
                            userId,
                            null,
                            List.of(new SimpleGrantedAuthority("ROLE_" + role))
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
