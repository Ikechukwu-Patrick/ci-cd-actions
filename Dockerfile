FROM maven:3.8.7-openjdk-17 as build
WORKDIR /app
COPY . .
RUN mvn -B clean package -DskipTests

FROM openjdk:17
COPY --from=build target/*.jar new-image.jar
EXPOSE 8087
ENTRYPOINT ["java", "-jar", "new-image.jar"]
