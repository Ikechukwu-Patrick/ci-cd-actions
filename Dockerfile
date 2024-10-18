# Use Maven for building the application
FROM maven:3.8.7 as build
WORKDIR /app
COPY . .
RUN mvn -B clean package -DskipTests

# Use OpenJDK to run the application
FROM openjdk:21
WORKDIR /app
COPY --from=build /app/target/*.jar new-image.jar
EXPOSE 8087

ENTRYPOINT ["java", "-jar", "-Dserver.port=8087", "new-image.jar"]
