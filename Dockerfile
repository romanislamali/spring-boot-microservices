# Stage 1: Build the application
FROM maven:3.8.5-openjdk-17-slim AS builder
WORKDIR /app
COPY . .
#RUN mvn clean install -DskipTests

# Stage 2: Create a minimal runtime image
FROM openjdk:17-slim
WORKDIR /app
COPY --from=builder /app/service-registry/target/service-registry-0.0.1-SNAPSHOT.jar ./service-registry.jar
COPY --from=builder /app/config-server/target/config-server-0.0.1-SNAPSHOT.jar ./config-server.jar
COPY --from=builder /app/department-service/target/department-service-0.0.1-SNAPSHOT.jar ./department-service.jar
ENTRYPOINT ["sh", "-c"]
CMD ["java -jar service-registry.jar & java -jar config-server.jar & java -jar department-service.jar"]
