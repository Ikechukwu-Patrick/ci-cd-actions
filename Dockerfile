FROM openjdk:21
EXPOSE 8080
ADD target/new-image.jar new-image.jar
ENTRYPOINT ["java", "-jar", "/new-image.jar"]