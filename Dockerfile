FROM maven:3.8.7 as build
WORKDIR /app
COPY . .
RUN mvn -B clean package -DskipTests

FROM openjdk:17
COPY --from=build /app/target/*.jar new-image.jar
EXPOSE 8087

ENTRYPOINT ["java", "-jar", "-Dserver.port=8087", "new-image.jar"]


#FROM maven:3.8.7 as build
#COPY . .
#RUN mvn -B clean package -DskipTests
#
#FROM openjdk:17
#COPY --from=build target/*.jar cloud.jar
#EXPOSE 8080
#
## Removed the problematic backtick
#ENTRYPOINT ["java", "-jar", "-Dserver.port=8080", "cloud.jar"]