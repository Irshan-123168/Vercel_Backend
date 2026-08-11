# Stage 1: Build the application
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
# Railway injects PORT dynamically; fall back to 9040 for local runs
EXPOSE ${PORT:-9040}
ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT:-9040} -jar app.jar"]