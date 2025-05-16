package com.example.mind_laundromat.jwt;

import com.example.mind_laundromat.user.dto.CustomUserDetails;
import com.example.mind_laundromat.user.entity.Role;
import com.example.mind_laundromat.user.entity.User;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.io.IOException;

public class JWTFilter extends OncePerRequestFilter {

    private final JWTUtil jwtUtil;

    public JWTFilter(JWTUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        // 1. Authorization 헤더 확인
        String authorization = request.getHeader("Authorization");

        if (authorization == null || !authorization.startsWith("Bearer ")) {
            System.out.println("token null");
            filterChain.doFilter(request, response);
            return;
        }

        System.out.println("authorization now");

        // 2. 토큰 파싱
        String token = authorization.split(" ")[1];

        // 3. 만료 검증
        if (jwtUtil.isExpired(token)) {
            System.out.println("token expired");
            filterChain.doFilter(request, response);
            return;
        }

        // 4. 토큰에서 정보 추출
        String email = jwtUtil.getEmail(token);  // getEmail이 정확히 구현되어 있어야 함
        String role = jwtUtil.getRole(token);

        // 5. 사용자 엔티티 생성
        User user = User.builder()
                .email(email)
                .password("TempPassword") // 비밀번호 그냥 임시
                .role(Role.valueOf(role))
                .build();

        // 6. 인증 객체 생성
        CustomUserDetails customUserDetails = new CustomUserDetails(user);
        Authentication authToken = new UsernamePasswordAuthenticationToken(
                customUserDetails, null, customUserDetails.getAuthorities());

        // 7. 시큐리티 컨텍스트에 등록
        SecurityContextHolder.getContext().setAuthentication(authToken);

        // 8. 다음 필터로 이동
        filterChain.doFilter(request, response);
    }
}
