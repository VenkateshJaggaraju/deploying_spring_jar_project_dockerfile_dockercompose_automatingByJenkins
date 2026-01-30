# -------- Stage 1: Build with Maven --------
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml first (for dependency caching)
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build jar
RUN mvn clean package -DskipTests


# -------- Stage 2: Run with Java --------
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port (optional, change as per your app)
EXPOSE 8080

# Run jar
ENTRYPOINT ["java", "-jar", "app.jar"]
