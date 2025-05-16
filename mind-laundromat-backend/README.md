# 🧠 Mind Laundromat - Backend
심리치료 기반의 감정관리 앱 "마음 세탁소"의 백엔드 프로젝트입니다. Spring Boot 기반으로 구축되었으며, JWT 인증 및 RESTful API를 제공합니다.

## 📁 프로젝트 구조
```
com.example.mind_laundromat
│
├── cbt/                    # CBT 관련 도메인 (감정일기, 인지 왜곡 등)
│   ├── controller          # 요청 처리 컨트롤러
│   ├── dto                 # 데이터 전송 객체
│   ├── entity              # JPA 엔티티 클래스
│   ├── repository          # JPA 레포지토리 인터페이스
│   └── service             # 비즈니스 로직 처리
│
├── user/                   # 사용자 도메인
│   ├── controller
│   ├── dto
│   ├── entity
│   ├── repository
│   └── service
│
├── config/                 # 글로벌 설정 (CORS, Security)
│   ├── CORSConfig
│   └── SecurityConfig
│
├── jwt/                    # JWT 인증 관련 유틸 및 필터
│   ├── JWTFilter
│   ├── JWTUtil
│   └── LoginFilter
│
├── entity/                 # 공통 엔티티 (BaseEntity 등)
│
└── response/               # 응답 처리 관련 클래스
    ├── CommonResponse
    ├── GlobalExceptionHandler
    ├── ResponseBuilder
    └── ResponseCode
```
