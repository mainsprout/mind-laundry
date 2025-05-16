package com.example.mind_laundromat.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CORSConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry){

        registry.addMapping("/**") // 모든 경로에 대해 규칙을 적용
                .allowedOrigins("*") // 모든 출처에서의 요청을 허용
                .allowedMethods("HEAD", "GET", "POST", "PUT", "DELETE", "OPTIONS") // 허용할 HTTP 메서드를 지정
                .maxAge(300) // 브라우저가 CORS 설정을 캐시하는 시간
                .allowedHeaders("Authorization", "Cache-Control", "Content-Type"); // 허용할 요청 헤더
    }
}
