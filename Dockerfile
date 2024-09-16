FROM maven:3.8.5-openjdk-17-slim AS build 

WORKDIR /app

COPY pom.xml .

RUN mvn dependency:go-offline

COPY src ./src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine AS final

WORKDIR /app

COPY --from=build /app/target/*.jar /app/app.jar 

EXPOSE 80

ENTRYPOINT ["java", "-jar", "app.jar"] 
