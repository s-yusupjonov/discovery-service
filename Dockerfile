## --- Build stage ---
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /workspace
COPY pom.xml .
RUN mvn -B dependency:go-offline
COPY src ./src
RUN mvn -B clean package -DskipTests

## --- Runtime stage (non-root) ---
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
RUN useradd --system --create-home appuser
COPY --from=build /workspace/target/discovery-service-0.0.1-SNAPSHOT.jar app.jar
USER appuser
EXPOSE 8761
HEALTHCHECK --interval=10s --timeout=3s --start-period=30s --retries=10 \
  CMD wget -qO- http://localhost:8761/actuator/health > /dev/null || exit 1
ENTRYPOINT ["java", "-jar", "app.jar"]
