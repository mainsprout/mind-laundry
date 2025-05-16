# ✅ 1단계: 빌드 단계 (Gradle + JDK 21)
FROM gradle:8.5.0-jdk21 AS build
WORKDIR /app
COPY . .
RUN gradle build --no-daemon

# ✅ 2단계: 실행 단계 (경량 JRE)
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/build/libs/mind-laundromat-backend-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

