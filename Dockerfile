FROM maven:3.8.7 as build
WORKDIR /app
COPY . .
RUN mvn -B clean package -DskipTests

FROM openjdk:21
COPY --from=build /app/target/*.jar new-image.jar
EXPOSE 8087

ENTRYPOINT ["java", "-jar", "-Dserver.port=8087", "new-image.jar"]
